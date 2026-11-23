WASM: no — the scheduler blocked Lean C emission before either Wasm route could run.

# Round 1 · 22 November 2026

**R0.** The official Apple-silicon Lean 4.19.0 executable started and reported commit `6caaee842e9495688c1567e78c0e68dbb96942aa`. WASI SDK 25 reported Clang 19.1.5 targeting `wasm32-unknown-wasi`. Node reported v24.11.1. These tools and the tagged Lean runtime sources are available in the lab. Only the components needed from the Lean binary archive were unpacked.

On this Mac, `nice -n 10` printed `setpriority: Operation not permitted` and continued at nice 0. A direct request to lower the process's own priority also failed. The build stopped with exit 75 before running `lean -j1 -c`. Route (a), building Lean's runtime for WASI, and route (b), linking the unboxed scalar export, both require that C output. Neither was exercised. Wasm size is unavailable. The Node harness has three cases and produced no answers.

The pending experiment uses exactly the same generated C on both routes. The serial commands are in [the spike driver](spike/build.sh). If both compiler routes subsequently fail, a candidate fallback is a translator from a first-order subset of Lean IR to WAT that rejects unsupported operations. Its correctness would need separate evidence.

| Download | Bytes |
| --- | ---: |
| Lean macOS arm64 release | 329,275,227 |
| Lean tagged source | 39,043,535 |
| WASI SDK macOS arm64 release | 104,133,504 |
| Official release and asset pages | 370,663 |
| **Total response bodies** | **472,822,929** |

The binary archive sizes match the official storage responses. Neither release page nor its asset list displayed a published SHA-256 for these versions. The [transcript](logs/R1-CHECKS.txt) records locally computed SHA-256 values. The lab occupied approximately **1.18 GB** including archives, extracted tools and logs.

**R1 — L1 through L8 are UNCHECKED.** [Core.lean](core/Core.lean) contains the transition, replay, all eight proposed proofs, and an acceptance witness per family. The witnesses cover replay after refusal, ordered append, the valid parent, grant consumption, the five passive events, divergent advice heads, rebind, and a core-changing upgrade. The same scheduling check stopped the Lean source check. The kernel emitted no axiom reports. Earlier reference checks do not count for this round.

**One problem with the scaffold is L6's raw-envelope interpretation.** Issue a grant, then record advice with score 0 on one host and 9 on the other. If the advice envelopes hash differently, an act addressed to the first head is stale on the second host. Their admission ledgers can diverge. The revised statement compares the same event proposals modulo scores, each addressed to its own current head and sequence. The source includes both the raw-suffix counterexample and the revised claim.

The model takes owner verification, the proof check for the exact upgrade target, and destination reports as host inputs. Cryptographic strength, key custody, hosts and screens, the Lean-to-Wasm compiler, and the choice of laws remain outside the proofs.
