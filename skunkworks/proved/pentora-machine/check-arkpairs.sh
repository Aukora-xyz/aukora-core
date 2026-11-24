#!/bin/sh
# Kernel-check ArkPairs.lean with Lean 4.19.0 (a few seconds, under 1 GB).
# It needs only the DEFINITIONS of core/Ark.lean, so it takes that file's text up to (not including) `def checkedMask`
# straight from core/Ark.lean each time it runs; nothing is copied into this folder, so the two cannot drift apart.
# It does NOT check core/Ark.lean's own theorem `every_four_rows` (that check needs several GB of memory).
# Usage: LEAN=/path/to/lean-4.19.0/bin/lean sh check-arkpairs.sh
set -eu
G="$(cd "$(dirname "$0")" && pwd)"; LEAN="${LEAN:?set LEAN to a Lean 4.19.0 binary}"; ARK="$G/../../../core/Ark.lean"
[ -f "$ARK" ] || { echo "core/Ark.lean not found"; exit 1; }
mkdir -p "$G/work/arkpairs"; cd "$G"
n=$(grep -n '^def checkedMask ' "$ARK" | cut -d: -f1); [ -n "$n" ] || { echo "marker not found in core/Ark.lean"; exit 1; }
{ sed "${n},\$d" "$ARK"; echo 'end Aukora.Ark'; } > work/arkpairs/ArkDefs.lean
cp Pentora.lean ArkPairs.lean AxiomsArkPairs.lean work/arkpairs/
cd work/arkpairs
{ "$LEAN" -j1 --root=. -o Pentora.olean Pentora.lean && "$LEAN" -j1 --root=. -o ArkDefs.olean ArkDefs.lean && LEAN_PATH=. "$LEAN" -j1 --root=. -o ArkPairs.olean ArkPairs.lean && LEAN_PATH=. "$LEAN" -j1 AxiomsArkPairs.lean; } > "$G/check-arkpairs.txt" 2>&1; echo "exit $?" >> "$G/check-arkpairs.txt"
cat "$G/check-arkpairs.txt"; grep -q '^exit 0$' "$G/check-arkpairs.txt"
