#!/bin/sh
set -u
limit_for() {
  case "$1" in
    *"GTX 1060"*) echo 140 ;;
  esac
}
while true; do
  nvidia-smi --query-gpu=index,name,power.limit --format=csv,noheader,nounits | while IFS=, read -r idx name current; do
    name=$(echo "$name" | sed 's/^ *//')
    want=$(limit_for "$name")
    [ -n "$want" ] || continue
    if [ "${current%%.*}" != "$want" ]; then
      nvidia-smi -i "$idx" -pl "$want" && echo "$(date -u +%FT%TZ) gpu $idx ($name): ${current} W -> ${want} W"
    fi
  done
  sleep 300
done
