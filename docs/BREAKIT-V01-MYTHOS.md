NO CRASH and NO SILENT CHANGE in about 13,300 hostile inputs to v0.1; signed frames have exactly one accepted form (0 of 9,062 changes passed). One hardening gap: nothing bounds what a host can make the core hold in memory.

# Break-it pass on the v0.1 release, by the second seat (Mythos) · 22 November 2026
Defensive testing of our own two release files only (`v0.1/aukora-core.wasm`, `v0.1/aukora-core-lite.wasm`),
offline, in Node. Scripts and transcripts: `logs/breakit10/`. Everything below is RAN unless marked.

## What was tried, and against which rule
| Rule tested | How | Result |
| --- | --- | --- |
| No input can crash the core | 4,248 malformed frames (bit flips, truncations, extensions, spliced frames, wrong tags, shifted bytes, length-field values) submitted to both cores in mid-session; 600 random call sequences, 24,000 calls, with out-of-range arguments, before and after genesis | **0 traps** |
| A refused submission changes nothing | head, installed digest, threshold and stamp count compared before and after each of 4,176 refusals, on both cores | **0 changes** |
| After garbage, the true next frame still behaves | the corpus frame submitted after each batch of garbage, verdict and head compared | **1,162 of 1,162** |
| The small core and the full core agree on everything except installs (the `LiteTrace` theorem, at the byte level) | every malformed frame given to both | **0 disagreements** in 4,248 |
| An owner-signed frame has exactly one accepted form | each of the 10 accepted signed frames (grant, timed grant, cancel, threshold, rebind, controls), one bit flipped at every 4th byte: header, body, Ed25519 signature, ML-DSA signature | **0 of 9,062 accepted** |
| The install frame (from the round-10 report) | 462 single-bit changes | 8 accepted, all in the proof field; 0 in model, header, target, intent |

72 of the 4,248 malformed frames were accepted. All are unsigned events that became a DIFFERENT VALID unsigned
event (for example a refused test frame whose changed byte made it a well-formed `say`). That is by design: speech
is free. None was a signed frame.

## The gap: nothing bounds memory (found here, not in `NOT-PROVED.md`)
1. Neither Wasm file declares a memory maximum (lite starts at 9.2 MiB, full at 13.6 MiB, "no max").
2. `feed` (staging a candidate file) needs no signature and has no size limit: 96 MiB was accepted in 1 MiB chunks
   with every call returning 1 (I stopped there to spare the owner's machine; process memory went 50 to 244 MiB).
   `reset` then returned 1 and the core carried on.
3. The record itself is held whole in memory and grows with every accepted event; `say` needs no signature.
   A 32-bit Wasm memory ends at 4 GiB, so the core as built has a lifetime ceiling, and long before it a host
   with little memory fails. What happens AT the limit was not tested (it would mean filling the machine); by
   reading, an allocation failure in Lean's runtime aborts, which in Wasm is a trap: the instance dies and the
   host must replay the record. UNVERIFIED.
What this is and is not: no authority is gained and no law is broken; whoever can call the core can make it
unavailable. For a core meant to sit inside other systems that is a real defect.
Asked of round 12: a declared memory maximum; a staging limit with a refusal; a stated record policy (a
checkpoint or "digests only, bodies outside"); out-of-memory as a refusal that changes nothing, never a trap.
For shadow mode this is already settled: the core records digests of cell calls, never bodies.

## Not covered by this pass
Timing differences in signature checks (side channels); the Wasm engine and compilers; inputs beyond 64 KiB as
mutation seeds; the in-Wasm proof checker with hostile proofs or models beyond the install-frame bit flips (a
hostile-proof round belongs next: oversized terms, deep nesting, pathological reduction, since the checker runs
inside the same instance with no fuel); two hosts racing on one record; anything in live x6.1.
