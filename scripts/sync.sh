#!/usr/bin/env bash
# Fetch the Cabinet Office holiday CSV, convert it to UTF-8/LF, validate it,
# and write it to docs/holidays.csv only when the result is sane.
set -euo pipefail

SOURCE_URL="https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv"
OUTPUT="docs/holidays.csv"
HEADER="国民の祝日・休日月日,国民の祝日・休日名称"

tmp="$(mktemp)"
trap 'rm -f "$tmp" "$tmp.utf8"' EXIT

curl --fail --silent --show-error --location -o "$tmp" "$SOURCE_URL"
iconv -f SHIFT_JIS -t UTF-8 "$tmp" | tr -d '\r' > "$tmp.utf8"

# Header must match exactly
if [ "$(head -n 1 "$tmp.utf8")" != "$HEADER" ]; then
  echo "Unexpected header: $(head -n 1 "$tmp.utf8")" >&2
  exit 1
fi

# Every data row must be "YYYY/M/D,name"
if tail -n +2 "$tmp.utf8" | grep -v -E '^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2},.+$' | grep -q .; then
  echo "Malformed rows found:" >&2
  tail -n +2 "$tmp.utf8" | grep -v -E '^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2},.+$' >&2
  exit 1
fi

# Data should never shrink (Cabinet Office only appends future years)
new_count="$(wc -l < "$tmp.utf8")"
if [ -f "$OUTPUT" ]; then
  old_count="$(wc -l < "$OUTPUT")"
  if [ "$new_count" -lt "$old_count" ]; then
    echo "Row count decreased: $old_count -> $new_count" >&2
    exit 1
  fi
fi

mv "$tmp.utf8" "$OUTPUT"
echo "Wrote $OUTPUT ($new_count lines, last: $(tail -n 1 "$OUTPUT"))"
