#!/bin/sh
D=/etc/home-ipv6
T=$(cat "$D/token") || exit 1
best=$(ubus call network.interface.lan status | jsonfilter -e '@["ipv6-prefix-assignment"][*]' | while read -r a; do
	addr=$(echo "$a" | jsonfilter -e '@.address')
	mask=$(echo "$a" | jsonfilter -e '@.mask')
	pref=$(echo "$a" | jsonfilter -e '@.preferred')
	case "$addr" in 2600:88[0-9a-f][0-9a-f]:*) echo "${pref:-0} $addr $mask" ;; esac
done | sort -rn | head -1)
[ -n "$best" ] || { logger -t home-ipv6 "no Cox GUA assignment on lan, keeping cluster values"; exit 0; }
set -- $best
head=${2%%::*}
n=$(echo "$head" | awk -F: '{print NF}')
while [ "$n" -lt 4 ]; do head="$head:0"; n=$((n + 1)); done
lan64=$(echo "$head" | cut -d: -f1-4)
lan60="$lan64::/$3"
for ns in metallb-system crowdsec tailscale-peer-relay; do
	ok=
	for ep in api.k8s.jacob.network 192.168.1.249 192.168.1.250 192.168.1.251; do
		url="https://$ep:6443/api/v1/namespaces/$ns/configmaps/home-ipv6"
		cur=$(curl -sf -m 10 --cacert "$D/ca.crt" -H "Authorization: Bearer $T" "$url") || continue
		ok=1
		c64=$(echo "$cur" | jsonfilter -e '@.data.HOME_V6_LAN64')
		c60=$(echo "$cur" | jsonfilter -e '@.data.HOME_V6_LAN60')
		[ "$c64" = "$lan64" ] && [ "$c60" = "$lan60" ] && break
		if curl -sf -m 10 --cacert "$D/ca.crt" -H "Authorization: Bearer $T" -H 'Content-Type: application/merge-patch+json' -X PATCH "$url" \
			-d "{\"data\":{\"HOME_V6_LAN64\":\"$lan64\",\"HOME_V6_LAN60\":\"$lan60\"}}" >/dev/null; then
			logger -t home-ipv6 "$ns: $c64 $c60 -> $lan64 $lan60"
		else
			logger -t home-ipv6 "$ns: patch to $lan64 $lan60 failed"
		fi
		break
	done
	[ -n "$ok" ] || logger -t home-ipv6 "$ns: API unreachable"
done
