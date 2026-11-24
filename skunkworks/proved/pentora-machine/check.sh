#!/bin/sh
# Kernel-check the Pentora machine's laws with Lean 4.19.0 (about ten seconds, well under 1 GB).
# Usage: LEAN=/path/to/lean-4.19.0/bin/lean sh check.sh
set -eu
G="$(cd "$(dirname "$0")" && pwd)"; LEAN="${LEAN:?set LEAN to a Lean 4.19.0 binary}"
mkdir -p "$G/work"; cd "$G"
{ "$LEAN" -j1 --root="$G" -o work/Pentora.olean Pentora.lean && LEAN_PATH="$G/work" "$LEAN" -j1 --root="$G" -o work/Entry.olean Entry.lean && LEAN_PATH="$G/work" "$LEAN" -j1 Axioms.lean; } > check.txt 2>&1; echo "exit $?" >> check.txt; cat check.txt
