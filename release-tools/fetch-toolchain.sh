#!/bin/sh
# Download the two pinned toolchains for Apple-silicon macOS into DIR, then PRUNE them to exactly the pinned files.
# About 540 MB to download and about 1.8 GB unpacked; about 650 MB is left after pruning.
# Nothing here is trusted: build-tree.py checks every file against release-tools/TOOLCHAIN-darwin-arm64.sha256 and refuses
# a toolchain with a changed, missing OR EXTRA file. The upstream Lean archive holds several thousand files the build never
# reads; the pins name every kept file. Pruning removes the rest, so the toolchain that builds is exactly the pinned one.
# Usage: sh release-tools/fetch-toolchain.sh toolchain
set -eu
dir="${1:?usage: fetch-toolchain.sh DIR}"; pins="$(cd "$(dirname "$0")" && pwd)/TOOLCHAIN-darwin-arm64.sha256"
[ -f "$pins" ] || { echo "fetch-toolchain: pin file not found beside this script"; exit 1; }
archive_pins="$(dirname "$pins")/toolchain-archives.sha256"
archive_digest() {
    python3 - "$archive_pins" "$1" <<'PY'
import re, sys
from pathlib import Path
pins, archive = sys.argv[1:]
lines = Path(pins).read_text().splitlines() if Path(pins).is_file() else []
matches = [line[:64] for line in lines
           if re.fullmatch(r"[0-9a-f]{64}  " + re.escape(archive), line)]
if len(matches) != 1:
    raise SystemExit(f"fetch-toolchain: missing or ambiguous SHA-256 pin for {archive}; refusing to unpack")
print(matches[0])
PY
}
check_archive() {
    actual=$(shasum -a 256 "$1")
    actual=${actual%% *}
    [ "$actual" = "$2" ] || {
        echo "fetch-toolchain: SHA-256 mismatch for $1; refusing to unpack" >&2
        exit 1
    }
}
mkdir -p "$dir"; cd "$dir"
lean=https://github.com/leanprover/lean4/releases/download/v4.19.0/lean-4.19.0-darwin_aarch64.zip
wasi=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-25/wasi-sdk-25.0-arm64-macos.tar.gz
lean_archive=${lean##*/}; wasi_archive=${wasi##*/}
lean_digest=; wasi_digest=
# Require all needed pins before downloading, and verify all downloads before unpacking any.
[ -d lean-4.19.0-darwin_aarch64 ] || lean_digest=$(archive_digest "$lean_archive")
[ -d wasi-sdk-25.0-arm64-macos ] || wasi_digest=$(archive_digest "$wasi_archive")
if [ -n "$lean_digest" ]; then
    curl -fL --retry 3 -o "$lean_archive" "$lean"
    check_archive "$lean_archive" "$lean_digest"
fi
if [ -n "$wasi_digest" ]; then
    curl -fL --retry 3 -o "$wasi_archive" "$wasi"
    check_archive "$wasi_archive" "$wasi_digest"
fi
if [ -n "$lean_digest" ]; then unzip -q "$lean_archive"; rm "$lean_archive"; fi
if [ -n "$wasi_digest" ]; then tar -xzf "$wasi_archive"; rm "$wasi_archive"; fi
python3 - "$pins" <<'PY'
import os, sys
from pathlib import Path
# Keep pinned files and links, and preserve all directories.
# The WASI SDK compiler finds libc++ by the empty include/c++/v1 directory.
# A pin line is 64 hex characters, then two spaces (a file) or " L " (a link), then the path.
keep = set()
for line in Path(sys.argv[1]).read_text().splitlines():
    if not line.strip(): continue
    keep.add(line[67:] if line[64:67] == " L " else line[66:])
tops = sorted({p.split("/", 1)[0] for p in keep})
removed = 0
for top in tops:
    if not Path(top).is_dir(): raise SystemExit(f"fetch-toolchain: {top} is missing after unpacking")
    for root, dirs, files in os.walk(top, topdown=False, followlinks=False):
        for name in files + [d for d in dirs if os.path.islink(os.path.join(root, d))]:
            p = os.path.join(root, name)
            if p not in keep: os.remove(p); removed += 1
missing = [p for p in sorted(keep) if not os.path.lexists(p)]
print(f"pruned {removed} unpinned files; {len(keep)} pinned paths expected; {len(missing)} missing")
if missing: raise SystemExit("fetch-toolchain: pinned paths missing after unpacking, first: " + missing[0])
PY
ls -d lean-4.19.0-darwin_aarch64 wasi-sdk-25.0-arm64-macos
