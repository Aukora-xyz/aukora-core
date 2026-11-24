#!/bin/sh
# From the repository root, with the pinned Apple Silicon toolchains unpacked:
#   TOOLCHAIN=<dir> sh skunkworks/proved/pentora-machine/build-wasm.sh
set -eu

pentora=skunkworks/proved/pentora-machine
archive=toolchain/downloads/lean4-v4.19.0-source.tar.gz
source_sha=26afde96ddf0632c68732943f2b6a0d84c1cd0790292fd464c25054b3d877853
wasm_sha=f735a7f915b97c80a7fbca9b6450ff72733f549207702aba3a8b54f8ced3596f
: "${TOOLCHAIN:?set TOOLCHAIN to the directory containing Lean 4.19.0 and WASI SDK 25}"
tool_dir=$(CDPATH= cd -P "$TOOLCHAIN" && pwd)
lean_dir="$tool_dir/lean-4.19.0-darwin_aarch64"
sdk="$tool_dir/wasi-sdk-25.0-arm64-macos/bin"
if [ ! -f "$pentora/Entry.lean" ] || [ ! -f "$archive" ]; then
    echo "Run from the repository root with the Lean source archive present." >&2
    exit 1
fi
printf '%s  %s\n' "$source_sha" "$archive" | shasum -a 256 -c -

work="$pentora/work/build-wasm"
upstream="$work/upstream"
runtime="$work/runtime"
if [ -L "$pentora/work" ]; then
    echo "The Pentora work directory is a symlink." >&2
    exit 1
fi
mkdir -p "$pentora/work"
# Two builds in the same checkout must not remove each other's work.
lock="$pentora/work/.build-wasm.lock"
mkdir "$lock" || { echo "Build lock in use: $lock" >&2; exit 1; }
trap 'rmdir "$lock"' EXIT
trap 'exit 1' HUP INT TERM
rm -rf "$work"
mkdir -p "$upstream" "$runtime" "$work/lib" "$work/tmp"
export TMPDIR="$PWD/$work/tmp" CLANG_MODULE_CACHE_PATH="$PWD/$work/tmp/ModuleCache"

python3 - "$archive" "$upstream" <<'PY'
import sys
import tarfile
from pathlib import Path

dest = Path(sys.argv[2])
count = 0
with tarfile.open(sys.argv[1], "r|gz") as archive:
    for entry in archive:
        name = entry.name.partition("/")[2]
        init = name == "stage0/stdlib/Init.c" or name.startswith("stage0/stdlib/Init/")
        runtime_source = name.startswith(("src/kernel/", "src/util/", "src/runtime/", "src/library/"))
        if not entry.isfile() or not (init or (runtime_source and name.endswith((".h", ".hpp", ".cpp")))):
            continue
        path = dest / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(archive.extractfile(entry).read())
        count += 1
print(f"Extracted {count} files from the pinned Lean source.")
PY

inc=spike/runtime-r2/include
printf '#define LEAN_GITHASH "6caaee842e9495688c1567e78c0e68dbb96942aa"\n' > "$runtime/githash.h"
set -- -Os -DNDEBUG -D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_MMAN \
    -D_WASI_EMULATED_PROCESS_CLOCKS -D_WASI_EMULATED_GETPID -ffunction-sections -fdata-sections
units='object utf8 alloc apply mpz mpn exception interrupt'
for unit in $units platform; do
    "$sdk/clang++" -std=c++17 "$@" -I"$inc" -I"$lean_dir/include" -I"$runtime" -I"$upstream/src" \
        -c "$upstream/src/runtime/$unit.cpp" -o "$runtime/$unit.o"
done
(
    cd "$runtime"
    set --
    for unit in $units; do set -- "$@" "$unit.o"; done
    "$sdk/llvm-ar" rcs route2.a "$@"
)
"$sdk/clang" "$@" -I"$inc" -I"$lean_dir/include" -c spike/r4/shim.c -o "$runtime/shim.o"
echo "Built route2.a (8 runtime units), platform.o and shim.o."

# Only Pentora and Entry contribute C. The repository's Axioms audit also imports Twin and Sharper.
export LEAN_PATH="$PWD/$work/lib"
run_lean() {
    module=$1
    shift
    # This Lean release rejects -M on its own. Watch only this invocation.
    python3 - "$module" "$work/$module.lean.txt" "$lean_dir/bin/lean" -j1 \
        --root="$pentora" "$@" "$pentora/$module.lean" <<'PY'
import ctypes
import resource
import subprocess
import sys
from pathlib import Path

module, log, *command = sys.argv[1:]
libproc = ctypes.CDLL("/usr/lib/libproc.dylib")
info = ctypes.create_string_buffer(512)
peak = 0
with open(log, "wb") as output:
    with subprocess.Popen(command, stdout=output, stderr=subprocess.STDOUT) as child:
        try:
            while child.poll() is None:
                if libproc.proc_pid_rusage(child.pid, 0, ctypes.byref(info)) == 0:
                    # Darwin rusage_info_v0, ri_resident_size and ri_phys_footprint
                    rss = int.from_bytes(info.raw[64:72], "little")
                    footprint = int.from_bytes(info.raw[72:80], "little")
                    peak = max(peak, rss, footprint)
                    if peak >= 3_500_000_000:
                        sys.exit(f"{module}: stopping before the 4 GB limit")
                try:
                    child.wait(timeout=0.1)
                except subprocess.TimeoutExpired:
                    pass
        finally:
            if child.poll() is None:
                child.kill()
                child.wait()
peak = max(peak, resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
print(f"Lean {module}: exit {child.returncode}, peak {peak // 1024**2} MiB (peak RSS or sampled footprint)")
if child.returncode:
    sys.stderr.write(Path(log).read_text())
    sys.exit(1)
if peak >= 4_000_000_000:
    sys.exit(f"{module}: exceeded the 4 GB limit")
PY
}
for module in Pentora Entry; do
    run_lean "$module" -o "$work/lib/$module.olean" -c "$work/lib/$module.c"
done
for module in Twin Sharper; do run_lean "$module" -o "$work/lib/$module.olean"; done
run_lean Axioms
if grep -En 'sorryAx|ofReduceBool|error:' "$work"/*.lean.txt; then exit 1; fi

python3 spike/r6/reachable.py "$work/reachable.c" "$upstream/stage0/stdlib" \
    --roots pentora_judge pentora_seams pentora_suspects pentora_address_byte pentora_tally \
    pentora_owner pentora_vertex pentora_seal pentora_centre pentora_heal \
    --modules "$work/lib/Pentora.c" "$work/lib/Entry.c"
set -- -Os -DNDEBUG -ffunction-sections -fdata-sections -I"$inc" -I"$lean_dir/include" -I"$work" -Werror=int-conversion
"$sdk/clang" "$@" -c "$work/reachable.c" -o "$work/reachable.o"
"$sdk/clang" "$@" -c "$pentora/interface.c" -o "$work/interface.o"
"$sdk/clang++" -nostartfiles -Wl,--no-entry,--max-memory=268435456,--threads=1,--gc-sections,--strip-all,--error-limit=0 \
    -Wl,-z,stack-size=8388608,--stack-first -Wl,--wrap=lean_internal_panic -Wl,--wrap=abort_message \
    -Wl,--wrap=lean_task_get -Wl,--wrap=_ZNSt3__222__libcpp_verbose_abortEPKcz \
    -Wl,--export=reset -Wl,--export=input -Wl,--export=judge -Wl,--export=seams \
    -Wl,--export=suspects -Wl,--export=addressByte -Wl,--export=tally -Wl,--export=owner \
    -Wl,--export=vertex -Wl,--export=seal -Wl,--export=centre -Wl,--export=heal \
    "$work/reachable.o" "$work/interface.o" "$runtime/platform.o" "$runtime/shim.o" "$runtime/route2.a" \
    -o "$work/linked.wasm"
rebuilt="$work/pentora.wasm"
shipped="$pentora/pentora.wasm"
python3 spike/r3/private-exports.py "$work/linked.wasm" "$rebuilt"

rebuilt_digest=$(shasum -a 256 "$rebuilt")
shipped_digest=$(shasum -a 256 "$shipped")
rebuilt_sha=${rebuilt_digest%% *}
shipped_sha=${shipped_digest%% *}
bytes=$(wc -c < "$rebuilt")
printf '%s  %d bytes  SHA-256 %s\n' "$rebuilt" "$bytes" "$rebuilt_sha"
printf '%s  SHA-256 %s\n' "$shipped" "$shipped_sha"
if [ "$rebuilt_sha" = "$wasm_sha" ] && [ "$rebuilt_sha" = "$shipped_sha" ] && cmp -s "$rebuilt" "$shipped"; then
    echo "MATCH"
else
    echo "MISMATCH (expected shipped SHA-256 $wasm_sha)"
    exit 1
fi
