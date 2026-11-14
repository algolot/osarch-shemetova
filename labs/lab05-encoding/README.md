# Lab 5 — Encoding forensics

Name: shemetova · Date: 14.11.2026 · Tools: Git Bash / PowerShell

## What I received
- Excel: Some Kazakh characters were displayed incorrectly because the original encoding was not recognized.
- LibreOffice Calc: The file was automatically detected as Windows-1251. Most Russian characters appeared correctly, but some Kazakh letters were displayed incorrectly.
- Terminal: The original CSV file contained incorrectly displayed Kazakh characters when opened without conversion.

## Diagnosis (made before the fix)
- file said: Non-ISO extended-ASCII text, with CRLF line terminators (evidence/file-before.txt).
- First 16 bytes: 49 44 3B D4 E0 EC E8 EB E8 FF 3B C8 EC FF 3B CE (evidence/hexdump-before.txt).
- Encoding: KZ-1048 (RK1048) - because Cyrillic characters were encoded as single bytes. For example, A3 represents "Ә" and B3 represents "і". Decoding with RK1048 displayed "Әбдірахманова" correctly, while Windows-1251 produced incorrect characters.
- Line ending: CRLF - because the hexadecimal dump contained 0D 0A at the end of the first line.
- BOM: No — because the original file started with 49 44 3B ("ID;"), which does not match any BOM signature. In the fixed file, I added a UTF-8 BOM (EF BB BF) to improve compatibility with Microsoft Excel and help it automatically recognize UTF-8.

## Fix
- I created fix.sh to convert the original file from RK1048 to UTF-8 with BOM on git bash

```bash
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
```

- Then I executed the script in git bash:

```bash
sh scripts/fix.sh
```

## Verification

- file said: unicode text, UTF-8 (with BOM) text, with CRLF line terminators (evidence/file-after.txt).
- Hex dump: the corrected file starts with EF BB BF, confirming the presence of the UTF-8 BOM (evidence/hexdump-after.txt).
- Data integrity: I used a round-trip conversion to compare the corrected file with the original after converting it back to RK1048 and removing the BOM.
- Excel: the corrected CSV was imported using UTF-8 encoding and the semicolon separator.
- LibreOffice: the corrected CSV was opened using UTF-8 encoding and the semicolon separator.
- Powershell terminal: The corrected file was displayed using the cat command.

## What did not work the first time

- I tried to execute linux commandsin windows powerShell by a mistake. Then I switched to git bash to run the required Unix commands

## Evidence

- [evidence/file-before.txt](evidence/file-before.txt) — Output of the `file` command prior to conversion, showing the original file detected as Non-ISO extended-ASCII text with CRLF line terminators.
- [evidence/hexdump-before.txt](evidence/hexdump-before.txt) — Hexadecimal dump of the first 16 bytes of the original file, showing the header (`49 44 3B` / "ID;") without a BOM and with single-byte Cyrillic characters corresponding to the RK1048 encoding.
- [evidence/opens-wrong.png](evidence/opens-wrong.png) — Screenshot demonstrating how the broken file appears incorrectly across applications before applying the encoding fix.
- [evidence/file-after.txt](evidence/file-after.txt) — Output of the `file` command after conversion, confirming the file is successfully updated to UTF-8 Unicode text with a BOM and CRLF line terminators.
- [evidence/hexdump-after.txt](evidence/hexdump-after.txt) — Hexadecimal dump of the fixed file confirming the presence of the UTF-8 Byte Order Mark (`EF BB BF`) at the beginning.
- [evidence/opens-correctly.png](evidence/opens-correctly.png) — Side-by-side verification screenshot showing `staff-fixed.csv` opening correctly with proper character rendering in Excel, LibreOffice Calc, and the terminal.
