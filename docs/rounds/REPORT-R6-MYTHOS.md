PROOF CHECKED INSIDE WASM: yes, verified by a second seat. A Lean proof checker written in Lean runs as a 1.7 MB Wasm cell, both files rebuilt from source byte-identical, and the upgrade gate refuses the old "proof passed" flag. It checks one law of the model; it does not yet show that a new core keeps all her laws.

# Round 6, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh spike/r6/run.sh` from the recorded source archives (pins checked, 369 library modules rebuilt, the checker and the core relinked, all tests run) | exit 0 in 5 min 48 s, no errors, no gaps. **Both files byte-identical to Astra's**: `core/Kernel6.wasm` 1,727,501 bytes `4d7b16eff23693cb412a22561e247dbdb3187322204b493943454ebfade028b9`; `core/Core6.wasm` 1,970,635 bytes `92baf60040e4800c4dfd0040bbc32eff869ea865d6285b8f054776e940aed1f5`. Transcript `logs/R6-mythos-rebuild.txt` |
| The upgrade tests inside that run | accepted: a signed grant plus a valid proof for the pinned candidate. Refused: proof and bytes with no signed grant; the pinned certificate against different bytes; the proof relabelled for another candidate; the old tag with `proofChecked = true`; a missing, truncated or wrong-typed certificate; a spent grant; a replayed grant |
| My own robustness run on the checker cell (`logs/repro6/mythos-kernel-test.mjs`) | the real 7,641-byte proof is accepted; random bytes and all-zero bytes are refused; of 300 single-bit mutations 292 are refused and 8 accepted; no trap. I did not examine the 8 one by one (a flipped bit in a name or other typing-irrelevant field still leaves a valid proof) |
| `core/Upgrade6.lean` | 4 theorems accepted by the native Lean kernel: the old flag is always refused; ordinary frames behave exactly as in round 5; an upgrade needs a proof the checker accepted; `core` changes only that way |

## What is true now
The mechanism of proof-carrying self-change runs end to end in Wasm: an upgrade frame carries a proof; a checker
inside (lean4lean, pinned commit `f8cd3d35`, with Batteries `f5d04a9c`) infers the proof's type and compares it with a
fixed goal; the core accepts the candidate only if that check passes, the candidate's bytes hash to the approved
digest, and the owner's signature verifies. Nothing in that decision is a host-supplied flag any more.

## What is NOT true yet (read this before quoting the round)
1. **The proof checked is about one law of the model** (`Bound5.wrong_digest`: a wrong digest is refused). It is not a
   proof that the candidate keeps laws L1 to L10.
2. **A pinned manifest, not a proof, links the model to the candidate file.** Nothing yet proves that the exact Wasm
   bytes behave as the Lean model says. Astra rates that step as research.
3. **The checker trusts a snapshot** of 925 earlier declarations, including 72 theorem statements, as given. It
   checks the new proof against them; it does not re-check them inside Wasm.
4. **lean4lean is not Lean's own kernel**, and it refused one proof (the shard proof) that Lean 4.19 accepts. A
   checker that says no to a valid proof is safe but limits what can be carried.
5. Trusted and unproved: lean4lean itself, its C++ primitives, about 11 more runtime units, the hand-written
   interface and build files, both compilers, the Wasm engine; Ed25519 and the SHA functions are tested, not proved.
6. Round 5's own core still reads a host flag on its next upgrade: the gate lives in the round-6 core.
7. Nothing here runs in the live system, and the owner key is still Ed25519, not the owner's passkey format.

## Totals after round 6
116 statements accepted by the Lean kernel and re-run by a second seat. Six Wasm files from Lean text: the gate
(664 bytes), four generations of the core (209 KB to 1.97 MB) and the proof-checker cell (1.7 MB). Every one was
rebuilt byte-identical by a seat that did not build it.

## Housekeeping
Round 6 downloaded 435,461 bytes. After my rebuild I removed 480 MB of regenerable build output; the lab folder is
about 720 MB (almost all of it the Lean and WASI toolchains).
