#!/bin/sh
# Lab 5: Convert RK1048 to UTF-8
set -e
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
iconv -f RK1048 -t UTF-8 "$in" > "$out"
# 2. Preserve CRLF line endings
# No changes needed
# 3. Add UTF-8 BOM
printf '\357\273\277' | cat - "$out" > "$out.tmp"
mv "$out.tmp" "$out"