#!/bin/sh
# Mirrors the current Squallar basemap generation from tiles.squallar.app into
# MinIO with the same key layout, then publishes status/latest.json last.
set -eu

SRC=${SOURCE_URL:-https://tiles.squallar.app}
DST=minio:${BUCKET:-squallar-basemap}
KEEP=${KEEP_GENERATIONS:-2}
W=${WORK_DIR:-/tmp/mirror}
mkdir -p "$W"

die() {
  echo "mirror: $*" >&2
  exit 1
}

field() {
  sed -n "s/.*\"$1\":\"\{0,1\}\([^\",}]*\).*/\1/p" "$W/latest.json"
}

listing() {
  rclone lsf --files-only --format sp --separator ' ' "$DST/basemap/" > "$W/have"
}

rclone copyurl --stdout "$SRC/status/latest.json" > "$W/latest.json"
GEN=$(field generation)
KEY=$(field key)
BYTES=$(field bytes)
PB=$(field part_bytes)
PARTS=$(field parts)

case "$GEN" in '' | *[!A-Za-z0-9._-]*) die "bad generation '$GEN'" ;; esac
[ "$KEY" = "basemap/$GEN.pmtiles" ] || die "key '$KEY' does not match generation '$GEN'"
for n in "$BYTES" "$PB" "$PARTS"; do
  case "$n" in '' | *[!0-9]*) die "bad number '$n' in latest.json" ;; esac
done
[ "$PB" -gt 0 ] && [ "$PARTS" -gt 0 ] && [ "$PARTS" -le 1000 ] || die "bad part layout"
[ $(((BYTES + PB - 1) / PB)) -eq "$PARTS" ] || die "$BYTES bytes in $PB-byte parts is not $PARTS parts"
LAST=$((BYTES - (PARTS - 1) * PB))
echo "source $GEN: $BYTES bytes in $PARTS parts"

missing() {
  i=0
  while [ "$i" -lt "$PARTS" ]; do
    f=$GEN.pmtiles.part$(printf %03d "$i")
    want=$PB
    [ "$i" -eq $((PARTS - 1)) ] && want=$LAST
    have=$(awk -v f="$f" '$2 == f { print $1 }' "$W/have")
    [ "$have" = "$want" ] || echo "$f"
    i=$((i + 1))
  done
}

listing
missing > "$W/need"
if [ -s "$W/need" ]; then
  echo "copying $(wc -l < "$W/need") parts"
  rclone copy :http: "$DST/basemap" \
    --http-url "$SRC/basemap/" \
    --files-from-raw "$W/need" \
    --no-traverse \
    --size-only \
    --transfers "${TRANSFERS:-4}" \
    --retries 5 \
    --low-level-retries 20 \
    --stats 1m \
    --stats-one-line \
    --stats-log-level NOTICE
fi

listing
missing > "$W/need"
[ ! -s "$W/need" ] || die "$(wc -l < "$W/need") parts still missing or the wrong size after the copy"
[ "$(rclone cat --count 7 "$DST/basemap/$GEN.pmtiles.part000")" = "PMTiles" ] || die "part000 has no PMTiles magic"
echo "verified $PARTS parts of $GEN"

rclone cat "$DST/status/latest.json" > "$W/current.json" 2> /dev/null || : > "$W/current.json"
if cmp -s "$W/latest.json" "$W/current.json"; then
  echo "status/latest.json already points at $GEN"
else
  rclone rcat "$DST/status/latest.json" < "$W/latest.json"
  echo "published status/latest.json for $GEN"
fi

listing
sed -n 's/^[0-9]* \(.*\)\.pmtiles\.part[0-9]*$/\1/p' "$W/have" | sort -u -r > "$W/gens"
head -n "$KEEP" "$W/gens" > "$W/keep"
echo "$GEN" >> "$W/keep"
grep -v -x -F -f "$W/keep" "$W/gens" | while read -r old; do
  case "$old" in '' | *[!A-Za-z0-9._-]*) die "refusing to delete odd generation '$old'" ;; esac
  echo "deleting generation $old"
  rclone delete "$DST/basemap" --include "/$old.pmtiles.part*"
done

rclone backend cleanup "$DST"
echo "done"
