SELF-CONTAINED CORE WASM: yes, route 2, 209,455 bytes | ARK: 210 of 210 subsets CHECKED

## The stateful core

Node loaded `core/Core3.wasm` with zero imports and four function exports. Call `init()` once, feed one envelope through `input(byte)`, and call `step()` for the verdict (1 accepts, 0 refuses). Read the 32 head bytes with `head(0)` through `head(31)`. The module owns the state and exports no memory or table. Repeated initialization preserves spent grants. A fresh instance starts at genesis.

The decoder covers all nine events in `core/Core.lean`. Lean accepted `step_decoded`, which equates the whole optional successor state to `Aukora.next envelopeDigest s e`, and `step_malformed`, which proves malformed input returns `none`. Node independently matched every accepted test head to SHA-256 of the submitted bytes, including padding boundaries and a 65,535-byte frame. The Lean implementation hashes the canonical re-encoding. General correctness of SHA-256 and the wire round trip remain unproved.

| Envelope | Verdict | Head prefix in both fresh instances |
| --- | --- | --- |
| Genesis | initialized | `000000000000` |
| Grant | accept | `927f87417895` |
| Act | accept | `bdbeecc8712c` |
| Identical act bytes | refuse | `bdbeecc8712c` |
| Spent act, current parent and sequence | refuse | `bdbeecc8712c` |
| Eligible say, stale parent and correct sequence | refuse | `bdbeecc8712c` |

Grant and claim membership are computed inside Wasm. Owner verification and upgrade-proof verification still come from envelope fields. Frames are capped at 65,535 bytes. Sequence numbers are unsigned 16-bit values, so a chain ends by its 65,535th acceptance. The host controls instance lifetime and persistence.

## Build and trust

**Route 1.** WASI signal emulation left `stack_t` undefined. The upstream single-threaded path with an alternate-stack stub passed that point, then stopped at `memory.cpp:83` because WASI lacks `ru_maxrss`. The Emscripten path lacked `emscripten.h`. No full runtime linked.

**Route 2.** Unchanged upstream runtime routines supply allocation, reference counting, arrays, strings, closures and naturals. The ByteArray probe initially lacked a heartbeat symbol, then pulled in diagnostic I/O. After those fixes, its 32,828-byte module returned 42. The first core link imported WASI clock and I/O through the runtime's task path. Trapping task access removed those imports. The compiler, reachable-code selection, constant initialization, C interface, runtime, linker and memory-export removal are trusted. Route 3 was unnecessary.

**TRUSTED AND UNPROVED** — complete `spike/runtime-r3/shim.c`, line for line. All six trap functions appear in the final link map.

```c
// Route 2. This single-threaded Wasm target has no host error or exception channel.
#include <stddef.h>
void __wrap_lean_internal_panic(const char *message) { __builtin_trap(); }
void *__cxa_allocate_exception(size_t bytes) { __builtin_trap(); }
void __cxa_throw(void *exception, void *type, void (*destroy)(void *)) { __builtin_trap(); }
void _ZN4lean15save_stack_infoEb(_Bool main_thread) { __builtin_trap(); }
void __wrap_abort_message(const char *format, ...) { __builtin_trap(); }
void *__wrap_lean_task_get(void *task) { __builtin_trap(); }
```

## ARK

The certificate generator used the 40 coefficients from the supplied `codeRow`. Lean independently checked those coefficients, the parity denominators’ reciprocals modulo 0x11d, and both matrix products against the identity for every four-row subset. The first timed subset, rows 6–9, took 0.349 s. An initial aggregate run failed on a comment delimiter and the recursion limit in the coverage proof. The corrected full file passed in 33.918 s and again in 32.019 s. Its theorem `everyFour` uses `propext` and `Quot.sound`.

Rebuild and replay with `sh spike/r3/build.sh`. A clean rebuild produced identical bytes, SHA-256 `b36b84988012b4169ebff84d04dbafa4d8001990be8e625d36d78831051cce8a`. This round downloaded zero bytes. After removing build intermediates the lab occupied about 693 MiB. [Commands, full heads, axioms and failures](logs/R3-CHECKS.txt)
