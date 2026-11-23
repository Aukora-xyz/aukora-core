GATE WASM: yes, 664 bytes, rebuilt byte-identical by a second seat and proved equal to the core's accept rule; it is a checker of facts the host hands it, not yet a self-contained core.

# Round 2, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos on this Mac, Lean 4.19.0, single thread; transcript `logs/R2-mythos-check.txt`)
| File | Written by | Result |
| --- | --- | --- |
| `core/Core.lean` | Astra, two proofs repaired by Mythos | exit 0, 28 statements (I miscounted 27 in round 1), no gaps. Astra re-ran it independently: same result. Both seats have now run it. |
| `core/Gate.lean` | Astra | exit 0, 6 statements, no gaps. Axioms: `propext`, `Quot.sound`, `Classical.choice`. |
| `core/Core2.lean` | Astra | exit 0, 19 statements, no gaps. |
| `core/Gate.wasm` | Astra | I regenerated the C from `Gate.lean` (identical to Astra's file), recompiled and relinked: **same SHA-256** `a2b0226f3e01a17ed48515f9b1754b0e4fa2f0baaf4b16435841a88c443baa2d`. Node ran Astra's 23 cases with no failure. |
| `core/Ark.lean` | Astra | UNCHECKED. The kernel run did not finish, and it used a stand-in matrix, not the real one. |

## What the gate result means
`gate_refines` (CHECKED): for every state and envelope, and every faithful encoding of them into machine words, the
exported function answers 1 exactly when the core's rule `Good s x` holds. The 664-byte file is compiled from that
same function, with no hand-written code between, and the build is reproducible.

## What it does NOT mean yet (my review)
1. **The gate holds no state.** "Is this grant in the unspent set?" and "does this claim exist?" arrive as flags from
   the host (`hitA`, `hitB`). A host that lies about a flag gets an accept. So today the Wasm file is a proved
   checker of reported facts; her authority still lives wherever the host keeps it.
2. **The digest is not computed inside.** The head arrives as four words; nothing in the file hashes an envelope.
3. So the next step is the one that matters: **state and hashing inside the Wasm file**, so that a host can only feed
   it envelopes and read its head.
4. Lean's full runtime did not build for WASI (stopped in `thread.cpp`: signals and `stack_t`). Untried: WASI's
   emulated-signal mode, the runtime's own Emscripten code paths, or a small hand-written runtime shim that is
   explicitly listed as trusted.

## Core2 (the four gaps from the decisions map), CHECKED
Retract (removed lines stay readable by address for ever), mandate (one count per use, only the signed payload and
audience, never upgrade or rebind), spend (admitted amounts never exceed the cap, across any replay), pass and revoke
(a revoked or expired pass admits nothing, and re-issuing does not revive it). One accepting witness each.

## Totals after round 2
53 statements accepted by the Lean kernel and run by both seats or by a seat that did not write them
(Core 28, Gate 6, Core2 19). Two Wasm files from proved Lean text (82 and 664 bytes). ARK unchecked.

## Housekeeping
Round 2 downloaded nothing. I removed the two large toolchain archives (433 MB) and build leftovers; the lab folder is
692 MB. The real shard matrix source is now in `reference/sealed-shards.mjs` (read-only copy from x6.1 main).
