#!/usr/bin/env python3
"""ARRIS SURFboard S33 exporter.

Logs in to the modem's HNAP API (HMAC-MD5 challenge/response, as its own
Login.js does), then every POLL_SECONDS:
  - serves channel/uptime metrics on :9100/metrics for Prometheus
  - pushes new event-log entries (T3/T4 timeouts, SYNC failures, ranging
    problems) to Loki as {job="modem"}

Stdlib only. Read-only: it never calls a Set* action.
"""
import hashlib
import hmac
import http.cookiejar
import http.server
import json
import os
import re
import ssl
import threading
import time
import urllib.request
from datetime import datetime, timezone
from zoneinfo import ZoneInfo

MODEM = os.environ.get("MODEM_URL", "https://192.168.100.1")
USER = os.environ.get("MODEM_USER", "admin")
PASSWORD = os.environ["MODEM_PASSWORD"]
LOKI = os.environ.get("LOKI_PUSH_URL", "http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push")
POLL = int(os.environ.get("POLL_SECONDS", "60"))
# The modem's event log is in local time with no zone.
MODEM_TZ = ZoneInfo(os.environ.get("MODEM_TZ", "America/Chicago"))
NS = "http://purenetworks.com/HNAP1/"
# The modem returns 404 to some non-browser User-Agents.
UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0 Safari/537.36"
# A failed login can lock the account (LOCKUP, or REBOOT = locked until the
# modem reboots), so never retry a rejected login quickly.
LOGIN_BACKOFF = int(os.environ.get("LOGIN_BACKOFF_SECONDS", "3600"))

CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE  # self-signed modem certificate

# DOCSIS event priorities, 1 (emergency) .. 7 (debug), like syslog.
LEVELS = {1: "emergency", 2: "alert", 3: "critical", 4: "error", 5: "warning", 6: "notice", 7: "info", 8: "debug"}


def hm(key, msg):
    return hmac.new(key.encode(), msg.encode(), hashlib.md5).hexdigest().upper()


class LoginRejected(Exception):
    pass


class Modem:
    def __init__(self):
        self.jar = http.cookiejar.CookieJar()
        self.opener = urllib.request.build_opener(
            urllib.request.HTTPSHandler(context=CTX), urllib.request.HTTPCookieProcessor(self.jar))
        self.key = None

    def _call(self, action, body):
        uri = f'"{NS}{action}"'
        ts = str(int(time.time() * 1000) % 2000000000000)
        req = urllib.request.Request(f"{MODEM}/HNAP1/", data=json.dumps(body).encode(), method="POST", headers={
            "Content-Type": "application/json; charset=UTF-8",
            "SOAPAction": uri,
            "HNAP_AUTH": f"{hm(self.key or 'withoutloginkey', ts + uri)} {ts}",
            "X-Requested-With": "XMLHttpRequest",
            "Referer": f"{MODEM}/Login.html",
            "User-Agent": UA,
        })
        with self.opener.open(req, timeout=20) as r:
            return json.loads(r.read())

    def _cookie(self, name, value):
        host = MODEM.split("://", 1)[1].split("/")[0]
        self.jar.set_cookie(http.cookiejar.Cookie(0, name, value, None, False, host, False, False,
                                                  "/", True, True, None, False, None, None, {}))

    def login(self):
        self.key = None
        self.jar.clear()
        r = self._call("Login", {"Login": {"Action": "request", "Username": USER, "LoginPassword": "",
                                           "Captcha": "", "PrivateLogin": "LoginPassword"}})["LoginResponse"]
        self.key = hm(r["PublicKey"] + PASSWORD, r["Challenge"])
        self._cookie("uid", r["Cookie"])
        self._cookie("PrivateKey", self.key)
        r2 = self._call("Login", {"Login": {"Action": "login", "Username": USER,
                                            "LoginPassword": hm(self.key, r["Challenge"]),
                                            "Captcha": "", "PrivateLogin": "LoginPassword"}})
        result = r2["LoginResponse"]["LoginResult"]
        if result != "OK":
            self.key = None
            raise LoginRejected(f"modem rejected login: {result}")

    def status(self):
        actions = ["GetCustomerStatusLog", "GetCustomerStatusConnectionInfo", "GetCustomerStatusStartupSequence",
                   "GetCustomerStatusDownstreamChannelInfo", "GetCustomerStatusUpstreamChannelInfo"]
        for attempt in (1, 2):
            if self.key is None:
                self.login()
            out = self._call("GetMultipleHNAPs", {"GetMultipleHNAPs": {a: "" for a in actions}})
            res = out.get("GetMultipleHNAPsResponse", {})
            if res.get("GetMultipleHNAPsResult") == "OK":
                return res
            self.key = None  # session expired; log in again once
        raise RuntimeError(f"status query failed: {res.get('GetMultipleHNAPsResult')}")


def rows(s, sep):
    return [r.split("^") for r in s.split(sep) if r.strip("^ ")]


def num(s):
    try:
        return float(s)
    except (TypeError, ValueError):
        return None


def uptime_seconds(s):
    m = re.match(r"(\d+) days (\d+)h:(\d+)m:(\d+)s", s or "")
    if not m:
        return None
    d, h, mi, se = map(int, m.groups())
    return d * 86400 + h * 3600 + mi * 60 + se


def render_metrics(st):
    lines = []

    def g(name, help_, samples):
        lines.append(f"# HELP {name} {help_}")
        lines.append(f"# TYPE {name} gauge")
        for labels, v in samples:
            if v is None:
                continue
            lab = ",".join(f'{k}="{val}"' for k, val in labels.items())
            lines.append(f"{name}{{{lab}}} {v}")

    ds = rows(st["GetCustomerStatusDownstreamChannelInfoResponse"]["CustomerConnDownstreamChannel"], "|+|")
    # channel^lock^modulation^channel_id^freq_hz^power_dbmv^snr_db^corrected^uncorrectable
    dsl = [({"channel_id": r[3], "modulation": r[2], "frequency_hz": r[4]}, r) for r in ds if len(r) >= 9]
    g("modem_downstream_locked", "1 if the downstream channel is locked", [(l, 1 if r[1] == "Locked" else 0) for l, r in dsl])
    g("modem_downstream_power_dbmv", "Downstream receive power (dBmV)", [(l, num(r[5])) for l, r in dsl])
    g("modem_downstream_snr_db", "Downstream SNR/MER (dB)", [(l, num(r[6])) for l, r in dsl])
    g("modem_downstream_corrected_codewords", "Corrected codewords since modem boot (counter; resets on reboot)", [(l, num(r[7])) for l, r in dsl])
    g("modem_downstream_uncorrectable_codewords", "Uncorrectable codewords since modem boot (counter; resets on reboot)", [(l, num(r[8])) for l, r in dsl])

    us = rows(st["GetCustomerStatusUpstreamChannelInfoResponse"]["CustomerConnUpstreamChannel"], "|+|")
    # channel^lock^type^channel_id^width_hz^freq_hz^power_dbmv
    usl = [({"channel_id": r[3], "type": r[2], "frequency_hz": r[5]}, r) for r in us if len(r) >= 7]
    g("modem_upstream_locked", "1 if the upstream channel is locked", [(l, 1 if r[1] == "Locked" else 0) for l, r in usl])
    g("modem_upstream_power_dbmv", "Upstream transmit power (dBmV)", [(l, num(r[6])) for l, r in usl])
    g("modem_upstream_width_hz", "Upstream channel width (Hz)", [(l, num(r[4])) for l, r in usl])

    conn = st["GetCustomerStatusConnectionInfoResponse"]
    g("modem_uptime_seconds", "Seconds since the modem booted", [({}, uptime_seconds(conn.get("CustomerConnSystemUpTime")))])
    boot = st["GetCustomerStatusStartupSequenceResponse"]
    g("modem_connectivity_ok", "1 if the modem reports connectivity OK / operational",
      [({}, 1 if boot.get("CustomerConnConnectivityStatus") == "OK" else 0)])
    g("modem_network_access_allowed", "1 if the CMTS allows network access",
      [({}, 1 if conn.get("CustomerConnNetworkAccess") == "Allowed" else 0)])
    return "\n".join(lines) + "\n"


def parse_log(st):
    """Yield (timestamp_ns, level, message) for each event-log entry."""
    for r in rows(st["GetCustomerStatusLogResponse"]["CustomerStatusLogList"], "}-{"):
        if len(r) < 5:
            continue
        _, tm, dt, pri, msg = r[:5]
        try:
            when = datetime.strptime(f"{dt} {tm}", "%d/%m/%Y %H:%M:%S").replace(tzinfo=MODEM_TZ)
        except ValueError:
            continue
        # Entries logged before the modem has time-of-day show 1969; stamp them "now".
        if when.year < 2000:
            when = datetime.now(timezone.utc)
        yield int(when.timestamp() * 1e9), LEVELS.get(int(pri) if pri.isdigit() else 0, "unknown"), msg.strip()


class State:
    metrics = "# no data yet\n"
    ok = False
    seen = set()


def push_logs(entries):
    streams = {}
    for ts, level, msg in entries:
        streams.setdefault(level, []).append([str(ts), msg])
    body = {"streams": [{"stream": {"job": "modem", "host": "modem", "level": lvl}, "values": sorted(v)}
                        for lvl, v in streams.items()]}
    req = urllib.request.Request(LOKI, data=json.dumps(body).encode(), method="POST",
                                 headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=20) as r:
        r.read()


def poll_loop():
    modem = Modem()
    first = True
    while True:
        try:
            st = modem.status()
            State.metrics = render_metrics(st)
            State.ok = True
        except LoginRejected as exc:
            State.ok = False
            print(f"{exc}; backing off {LOGIN_BACKOFF}s so the account isn't locked", flush=True)
            time.sleep(LOGIN_BACKOFF)
            continue
        except Exception as exc:  # keep serving; the scrape reports modem_scrape_ok 0
            State.ok = False
            modem.key = None
            print(f"poll failed: {exc!r}", flush=True)
            time.sleep(POLL)
            continue
        entries = list(parse_log(st))
        # The log is a 100-entry ring with no IDs: de-duplicate by content.
        # Loki drops exact duplicates too, so a restart re-sending is harmless.
        new = [e for e in entries if (e[0], e[2]) not in State.seen]
        cutoff = time.time_ns() - 6 * 86400 * 10**9  # Loki rejects >7d old
        to_send = [e for e in new if e[0] >= cutoff]
        try:
            if to_send:
                push_logs(to_send)
            # Only mark entries seen once they are in Loki, so a failed push retries.
            State.seen = {(e[0], e[2]) for e in entries}
            if first or to_send:
                print(f"poll ok: {len(entries)} log entries, {len(to_send)} pushed", flush=True)
            first = False
        except Exception as exc:
            print(f"loki push failed, will retry: {exc!r}", flush=True)
        time.sleep(POLL)


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path not in ("/metrics", "/"):
            self.send_response(404)
            self.end_headers()
            return
        body = (State.metrics + f"# HELP modem_scrape_ok 1 if the last modem poll succeeded\n"
                f"# TYPE modem_scrape_ok gauge\nmodem_scrape_ok {1 if State.ok else 0}\n").encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; version=0.0.4")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    threading.Thread(target=poll_loop, daemon=True).start()
    http.server.ThreadingHTTPServer(("0.0.0.0", 9100), Handler).serve_forever()
