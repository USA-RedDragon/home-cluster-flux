#!/usr/bin/env bash
set -euo pipefail

log="$1"
title="$2"

blocks() {
  awk -v want="$1" '
    /^policy .* -> resource .* failed as audit warning:$/ { mode = "warn"; if (mode == want) print; next }
    /^policy .* -> resource .* failed:$/ { mode = "fail"; if (mode == want) print; next }
    /^[0-9]+ - / { if (mode == want) print; next }
    { mode = "" }
  ' "$log"
}

result=$(grep -E '^pass: [0-9]+, fail: [0-9]+' "$log" | tail -n1 || true)
failures=$(blocks fail)
warnings=$(blocks warn | grep '^policy ' | awk '{print $2}' | sort | uniq -c | sort -rn || true)

echo "## ${title}"
echo
if [ -z "$result" ]; then
  echo "Kyverno did not finish. See the job log."
  exit 0
fi
echo "\`${result}\`"
if [ -n "$failures" ]; then
  echo
  echo "### Enforced policy failures"
  echo
  echo '```text'
  echo "$failures" | head -c 50000
  echo
  echo '```'
fi
if [ -n "$warnings" ]; then
  echo
  echo "<details>"
  echo "<summary>Audit warnings by policy</summary>"
  echo
  echo "| Policy | Results |"
  echo "| --- | --- |"
  echo "$warnings" | awk '{print "| " $2 " | " $1 " |"}'
  echo
  echo "</details>"
fi
