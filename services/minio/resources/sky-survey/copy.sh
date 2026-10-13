#!/bin/sh
set -eu
src="src:stpubdata/mast/skybackgrounds/DSSColor"
dst="dst:sky-survey/hips/CDS_P_DSS2_color"
flags="--checksum --no-update-modtime --transfers 16 --checkers 32 --retries 10 --low-level-retries 20 --stats 60s --stats-one-line --stats-log-level NOTICE --log-level NOTICE"

for k in $ORDERS; do
  echo "copying Norder$k"
  rclone copy "$src/Norder$k" "$dst/Norder$k" $flags
done

rclone cat "$src/properties" | sed \
  -e 's/^hips_status .*/hips_status          = private mirror partial unclonable/' \
  -e 's/^hips_order .*/hips_order           = 8/' > /work/properties
grep -q '^hips_order           = 8$' /work/properties
grep -q '^hips_status          = private mirror partial unclonable$' /work/properties
grep -q '^hips_release_date ' /work/properties
rclone copyto /work/properties "$dst/properties" --checksum --log-level NOTICE

for k in $ORDERS; do
  echo "checking Norder$k"
  rclone check "$src/Norder$k" "$dst/Norder$k" --one-way --checkers 32 --log-level NOTICE
  echo "Norder$k source=$(rclone size "$src/Norder$k" --json) mirror=$(rclone size "$dst/Norder$k" --json)"
done
echo "mirror complete for orders: $ORDERS"
