"""Prometheus exporter for Folding@home v8 clients.

Connects to each client websocket at /api/websocket, reads the first state
message, and closes. Also polls the public stats API for the account score.

Environment:
  FAH_TARGETS          name=host:port pairs, separated by commas or whitespace
  FAH_STATS_USER       stats API user name (empty disables)
  FAH_STATS_TEAM       team number for the per-team score
  FAH_LISTEN_PORT      HTTP port for /metrics (default 8080)
  FAH_SCRAPE_INTERVAL  seconds between client polls (default 30)
  FAH_STATS_INTERVAL   seconds between stats API polls (minimum 600)
  FAH_TIMEOUT          per-target timeout in seconds (default 10)
"""

import base64
import json
import os
import socket
import struct
import sys
import threading
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

UNIT_STATES = ("ASSIGN", "DOWNLOAD", "CORE", "RUN", "UPLOAD", "DUMP", "DONE")
MAX_MESSAGE = 32 * 1024 * 1024


def log(msg):
    print(time.strftime("%Y-%m-%dT%H:%M:%S%z"), msg, file=sys.stderr, flush=True)


def parse_targets(spec):
    targets = []
    for item in spec.replace(",", " ").split():
        name, sep, addr = item.partition("=")
        host, _, port = addr.rpartition(":")
        if not sep or not name or not host or not port.isdigit():
            raise ValueError(f"bad target {item!r}, want name=host:port")
        targets.append((name, host.strip("[]"), int(port)))
    return targets


def recv_exact(sock, n):
    buf = bytearray()
    while len(buf) < n:
        chunk = sock.recv(min(n - len(buf), 1 << 20))
        if not chunk:
            raise ConnectionError("connection closed")
        buf += chunk
    return bytes(buf)


def ws_first_message(host, port, timeout):
    with socket.create_connection((host, port), timeout=timeout) as sock:
        sock.settimeout(timeout)
        key = base64.b64encode(os.urandom(16)).decode()
        hostport = f"[{host}]:{port}" if ":" in host else f"{host}:{port}"
        req = (
            "GET /api/websocket HTTP/1.1\r\n"
            f"Host: {hostport}\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {key}\r\n"
            "Sec-WebSocket-Version: 13\r\n\r\n"
        )
        sock.sendall(req.encode())
        head = b""
        while b"\r\n\r\n" not in head:
            chunk = sock.recv(4096)
            if not chunk:
                raise ConnectionError("closed during handshake")
            head += chunk
            if len(head) > 65536:
                raise ConnectionError("handshake response too large")
        head, _, rest = head.partition(b"\r\n\r\n")
        status = head.split(b"\r\n", 1)[0]
        if b" 101 " not in status + b" ":
            raise ConnectionError(f"handshake failed: {status.decode(errors='replace')}")

        class Reader:
            def __init__(self, pending):
                self.pending = pending

            def read(self, n):
                if len(self.pending) >= n:
                    out, self.pending = self.pending[:n], self.pending[n:]
                    return out
                out, self.pending = self.pending, b""
                return out + recv_exact(sock, n - len(out))

        reader = Reader(rest)
        payload = bytearray()
        started = False
        while True:
            b1, b2 = reader.read(2)
            fin, opcode = b1 & 0x80, b1 & 0x0F
            length = b2 & 0x7F
            if length == 126:
                length = struct.unpack("!H", reader.read(2))[0]
            elif length == 127:
                length = struct.unpack("!Q", reader.read(8))[0]
            mask = reader.read(4) if b2 & 0x80 else None
            if length > MAX_MESSAGE or len(payload) + length > MAX_MESSAGE:
                raise ConnectionError("message too large")
            data = reader.read(length) if length else b""
            if mask:
                data = bytes(c ^ mask[i % 4] for i, c in enumerate(data))
            if opcode == 0x8:
                raise ConnectionError("server closed websocket")
            if opcode in (0x9, 0xA):
                continue
            if opcode == 0x1 or (opcode == 0x2 and not started):
                payload = bytearray(data)
                started = True
            elif opcode == 0x0 and started:
                payload += data
            else:
                raise ConnectionError(f"unexpected opcode {opcode}")
            if fin:
                try:
                    sock.sendall(b"\x88\x80" + os.urandom(4))
                except OSError:
                    pass
                return json.loads(payload.decode())


def fmt(value):
    value = float(value)
    if value.is_integer() and abs(value) < 1e15:
        return str(int(value))
    return repr(value)


def esc(value):
    return str(value).replace("\\", "\\\\").replace("\n", "\\n").replace('"', '\\"')


class Metrics:
    def __init__(self):
        self.families = {}

    def add(self, name, mtype, help_text, labels, value):
        fam = self.families.setdefault(name, (mtype, help_text, {}))
        fam[2][tuple(sorted(labels.items()))] = value

    def inc(self, name, help_text, labels, value=1):
        fam = self.families.setdefault(name, ("gauge", help_text, {}))
        key = tuple(sorted(labels.items()))
        fam[2][key] = fam[2].get(key, 0) + value

    def render(self):
        out = []
        for name, (mtype, help_text, samples) in sorted(self.families.items()):
            out.append(f"# HELP {name} {help_text}")
            out.append(f"# TYPE {name} {mtype}")
            for key, value in samples.items():
                lbl = ",".join(f'{k}="{esc(v)}"' for k, v in key)
                out.append(f"{name}{{{lbl}}} {fmt(value)}" if lbl else f"{name} {fmt(value)}")
        return "\n".join(out) + "\n"


def num(value, default=0.0):
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def unit_rank(unit):
    return (unit.get("state") == "RUN", num(unit.get("wu_progress")))


def client_metrics(m, machine, state):
    info = state.get("info") or {}
    m.add("fah_client_info", "gauge", "Client build and host details.", {
        "machine": machine,
        "version": info.get("version", ""),
        "mach_name": info.get("mach_name", ""),
        "os": info.get("os", ""),
    }, 1)
    m.add("fah_client_cpus", "gauge", "CPUs the client detected on the host.", {"machine": machine}, num(info.get("cpus")))
    m.add("fah_client_gpus_supported", "gauge", "GPUs the client detected as supported.", {"machine": machine},
          sum(1 for g in (info.get("gpus") or {}).values() if g.get("supported")))

    groups = state.get("groups") or {}
    for gname, group in groups.items():
        cfg = group.get("config") or {}
        gl = {"machine": machine, "group": gname}
        m.add("fah_group_paused", "gauge", "1 if the resource group is paused.", gl, 1 if cfg.get("paused") else 0)
        m.add("fah_group_finish", "gauge", "1 if the group is set to finish its current units and then pause.", gl,
              1 if cfg.get("finish") else 0)
        m.add("fah_group_cpus", "gauge", "CPUs configured for folding in the group.", gl, num(cfg.get("cpus")))
        gpus = cfg.get("gpus") or {}
        m.add("fah_group_gpus_enabled", "gauge", "GPUs enabled for folding in the group.", gl,
              sum(1 for g in gpus.values() if (g or {}).get("enabled")))
        m.inc("fah_units_running", "Units in the RUN state.", gl, 0)
        for st in UNIT_STATES:
            m.inc("fah_units", "Units by state.", {**gl, "state": st}, 0)

    best = {}
    for unit in state.get("units") or []:
        gname = unit.get("group", "")
        st = unit.get("state", "")
        gl = {"machine": machine, "group": gname}
        m.inc("fah_units", "Units by state.", {**gl, "state": st})
        if st == "RUN":
            m.inc("fah_units_running", "Units in the RUN state.", gl)
        project = str((unit.get("assignment") or {}).get("project", ""))
        resource = "gpu" if unit.get("gpus") else "cpu"
        key = (gname, resource, project)
        if key not in best or unit_rank(unit) > unit_rank(best[key]):
            best[key] = unit

    for (gname, resource, project), unit in best.items():
        ul = {"machine": machine, "group": gname, "resource": resource, "project": project}
        m.add("fah_unit_ppd", "gauge", "Estimated points per day for the unit.", ul, num(unit.get("ppd")))
        m.add("fah_unit_progress", "gauge", "Work unit progress from 0 to 1.", ul, num(unit.get("wu_progress")))
        m.add("fah_unit_cpus", "gauge", "CPUs assigned to the unit.", ul, num(unit.get("cpus")))
        m.add("fah_unit_paused", "gauge", "1 if the unit is paused.", ul, 1 if unit.get("paused") else 0)
        for st in UNIT_STATES:
            m.add("fah_unit_state", "gauge", "1 for the current state of the unit.", {**ul, "state": st},
                  1 if unit.get("state") == st else 0)


class Exporter:
    def __init__(self):
        self.targets = parse_targets(os.environ.get("FAH_TARGETS", ""))
        if not self.targets:
            raise SystemExit("FAH_TARGETS is empty")
        self.timeout = num(os.environ.get("FAH_TIMEOUT"), 10)
        self.interval = num(os.environ.get("FAH_SCRAPE_INTERVAL"), 30)
        self.stats_interval = max(600.0, num(os.environ.get("FAH_STATS_INTERVAL"), 600))
        self.stats_user = os.environ.get("FAH_STATS_USER", "")
        self.stats_team = os.environ.get("FAH_STATS_TEAM", "")
        self.lock = threading.Lock()
        self.client_state = {name: None for name, _, _ in self.targets}
        self.client_ok = {name: 0 for name, _, _ in self.targets}
        self.client_last = {name: 0.0 for name, _, _ in self.targets}
        self.client_duration = {name: 0.0 for name, _, _ in self.targets}
        self.client_errors = {name: 0 for name, _, _ in self.targets}
        self.stats = None
        self.stats_ok = 0
        self.stats_last = 0.0
        self.stats_errors = 0
        self.last_cycle = 0.0
        self.pool = ThreadPoolExecutor(max_workers=min(16, len(self.targets)))

    def poll_target(self, target):
        name, host, port = target
        start = time.monotonic()
        try:
            state = ws_first_message(host, port, self.timeout)
            ok = 1
        except Exception as exc:
            log(f"{name} ({host}:{port}): {type(exc).__name__}: {exc}")
            state, ok = None, 0
        return name, state, ok, time.monotonic() - start

    def poll_clients(self):
        for name, state, ok, duration in self.pool.map(self.poll_target, self.targets):
            with self.lock:
                self.client_ok[name] = ok
                self.client_duration[name] = duration
                self.client_state[name] = state if ok else None
                if ok:
                    self.client_last[name] = time.time()
                else:
                    self.client_errors[name] += 1

    def poll_stats(self):
        url = "https://api.foldingathome.org/user/" + urllib.parse.quote(self.stats_user)
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "fah-exporter", "Accept": "application/json"})
            with urllib.request.urlopen(req, timeout=30) as resp:
                data = json.load(resp)
            with self.lock:
                self.stats, self.stats_ok, self.stats_last = data, 1, time.time()
        except Exception as exc:
            log(f"stats {url}: {type(exc).__name__}: {exc}")
            with self.lock:
                self.stats_ok = 0
                self.stats_errors += 1

    def render(self):
        m = Metrics()
        with self.lock:
            for name, _, _ in self.targets:
                ml = {"machine": name}
                m.add("fah_up", "gauge", "1 if the last poll of the client websocket succeeded.", ml, self.client_ok[name])
                m.add("fah_last_success_timestamp_seconds", "gauge", "Unix time of the last successful client poll.", ml,
                      self.client_last[name])
                m.add("fah_poll_duration_seconds", "gauge", "Duration of the last client poll.", ml,
                      self.client_duration[name])
                m.add("fah_poll_errors_total", "counter", "Failed client polls since exporter start.", ml,
                      self.client_errors[name])
                if self.client_state[name]:
                    try:
                        client_metrics(m, name, self.client_state[name])
                    except Exception as exc:
                        log(f"{name}: cannot parse state: {type(exc).__name__}: {exc}")
            if self.stats_user:
                ul = {"user": self.stats_user}
                m.add("fah_stats_up", "gauge", "1 if the last stats API poll succeeded.", ul, self.stats_ok)
                m.add("fah_stats_last_success_timestamp_seconds", "gauge", "Unix time of the last successful stats API poll.",
                      ul, self.stats_last)
                m.add("fah_stats_errors_total", "counter", "Failed stats API polls since exporter start.", ul,
                      self.stats_errors)
                if self.stats:
                    s = self.stats
                    m.add("fah_account_score", "gauge", "Total points credited to the user.", ul, num(s.get("score")))
                    m.add("fah_account_wus", "gauge", "Work units credited to the user.", ul, num(s.get("wus")))
                    m.add("fah_account_active_7", "gauge", "Machines active for the user in the last 7 days.", ul,
                          num(s.get("active_7")))
                    m.add("fah_account_active_50", "gauge", "Machines active for the user in the last 50 days.", ul,
                          num(s.get("active_50")))
                    if s.get("rank") is not None:
                        m.add("fah_account_rank", "gauge", "Rank of the user among all donors.", ul, num(s.get("rank")))
                    for team in s.get("teams") or []:
                        if self.stats_team and str(team.get("team")) != str(self.stats_team):
                            continue
                        tl = {**ul, "team": str(team.get("team", "")), "team_name": team.get("name", "")}
                        m.add("fah_account_team_score", "gauge", "Points the user earned for the team.", tl,
                              num(team.get("score")))
                        m.add("fah_account_team_wus", "gauge", "Work units the user completed for the team.", tl,
                              num(team.get("wus")))
                        m.add("fah_team_score", "gauge", "Total points of the team.", tl, num(team.get("tscore")))
                        m.add("fah_team_rank", "gauge", "Rank of the team.", tl, num(team.get("trank")))
            m.add("fah_exporter_last_cycle_timestamp_seconds", "gauge", "Unix time the last client poll cycle finished.",
                  {}, self.last_cycle)
        return m.render().encode()

    def run(self):
        next_stats = 0.0
        while True:
            start = time.monotonic()
            if self.stats_user and start >= next_stats:
                next_stats = start + self.stats_interval
                threading.Thread(target=self.poll_stats, daemon=True).start()
            self.poll_clients()
            with self.lock:
                self.last_cycle = time.time()
            time.sleep(max(1.0, self.interval - (time.monotonic() - start)))


class DualStackServer(ThreadingHTTPServer):
    address_family = socket.AF_INET6

    def server_bind(self):
        self.socket.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
        super().server_bind()


def main():
    exporter = Exporter()

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path.split("?", 1)[0] == "/metrics":
                body = exporter.render()
                self.send_response(200)
                self.send_header("Content-Type", "text/plain; version=0.0.4; charset=utf-8")
            elif self.path in ("/healthz", "/"):
                body = b"ok\n"
                self.send_response(200)
                self.send_header("Content-Type", "text/plain")
            else:
                body = b"not found\n"
                self.send_response(404)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def log_message(self, fmt, *args):
            pass

    port = int(os.environ.get("FAH_LISTEN_PORT", "8080"))
    try:
        server = DualStackServer(("::", port), Handler)
    except OSError:
        server = ThreadingHTTPServer(("0.0.0.0", port), Handler)
    server.daemon_threads = True
    threading.Thread(target=server.serve_forever, daemon=True).start()
    log(f"listening on :{port}, {len(exporter.targets)} targets")
    exporter.run()


if __name__ == "__main__":
    main()
