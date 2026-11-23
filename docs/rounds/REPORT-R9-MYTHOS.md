GATE: a rule, rebuilt byte-identical by a second seat. REVOKE AND EXPIRY: theorems accepted. DIFFERENTIAL: 971 of 971 agree in my run. But the one upgrade it demonstrates lands on an older, weaker core, and the pinned law set is still round 7's.

# Round 9, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh spike/r9/run.sh` from the recorded sources | **PASS Round 9** in 7 min 30 s, no errors, no gaps (`sorryAx` 0). Pinned hashes matched: `Core9.wasm` 5,614,804 bytes `2b5334497f16f1cc299236c15d7498c00f93a3f9e049b92373cd2c60ab76a7eb`; `FixedGenesis9.wasm` 1,970,929 bytes `497d493c8cf6c6f1fcb2517b721cb1c12f25446f8f85a91d6434447b95f0b649`. Transcript `logs/R9-mythos-rebuild.txt` |
| Lean statements | 37 `theorem` lines across the fourteen round-9 files, all accepted in my run |
| Model against file, in my run | 971 of 971 frames gave the same verdict and the same 32-byte head in Lean and in Wasm: 99 accepted, 872 refused (matrix 814, length 86, signed 66, gate 5) |
| My own reader of the two Wasm files (`logs/repro9/mythos-section-test.mjs`, none of Astra's scripts) | Neither file has an import section. `FixedGenesis9.wasm` has exactly one `aukora.model.sha256` section; its 32 bytes equal SHA-256 of `logs/r9/honest.model` (3,243 bytes). `Core9.wasm` has no custom section |
| Source read (`core/Checker9.lean`, `Goal9.lean`, `Candidate9.lean`) | The goal is built from the carried definitions: `Laws7.Lawful <last carried definition>`. Up to 64 definitions, monomorphic, nonrecursive, names under `R9Candidate`, 1 MiB each for model and proof |

## What is true now
- The gate no longer holds a list of admitted files. An upgrade carries the candidate's model definitions and a
  proof; the checker inside Wasm type-checks the definitions and requires a proof of `Lawful` for them; the file
  must name the digest of those definitions in a custom section. A file made after the core was linked was admitted.
- Three refusals ran: the honest proof with a law-breaking model; a file naming a different model; a carried
  definition that redefines `Lawful`.
- One approval can be cancelled or can expire without touching any other; a cancelled intent needs a new
  owner-signed approval; a corrected outcome keeps the earlier one in the record and shows that it was corrected.
- GLM's wire claim is settled: for every valid frame (32-byte parent) byte 40 is the frame's own tag. Only a
  malformed 33-byte-parent frame gives a counterexample (`core/Tag9.lean`).

## What is NOT true (found by this seat, beyond Astra's own list)
1. **The demonstrated upgrade is a downgrade.** `FixedGenesis9.wasm` is the round-6 core with its `init` wrapped by
   a byte patch (`spike/r9/candidate.py`; my reader: code section 239 bytes larger than `Core6.wasm`, every other
   compared section the same size). So the core that checks two signatures and danger scores "upgraded" itself onto
   a file that checks Ed25519 only and has neither. The gate allowed it because:
2. **The pinned law set is round 7's** (`Laws7.Lawful`). The hybrid-signature laws, the danger-score laws, the
   stamp law, revoke and expiry are theorems about `Core9`, but a successor does not have to keep them.
3. **Model to file is still a label.** The custom section says which model a file claims. Nothing proves the file
   behaves as that model. Here the model is Lean text and the file is a patched older binary; 971 agreeing frames
   are evidence about `Core9.wasm`, not about the candidate.
4. The carried-definition language is narrow (monomorphic, nonrecursive, built from pinned pieces).
5. Unchanged: the checker takes earlier lemma statements as given; the cryptography is tested, not proved; the
   keys are raw Ed25519 and ML-DSA keys, not a passkey; nothing runs in live x6.1.

## Next
Round 10 (launched 14:52): ONE law set with everything from rounds 1 to 9, pinned in the gate; an Ed25519-only
successor refused; the admitted candidate built from the newest machine's own source; the clean `v0.1/` release.
Round 11 (brief written): evidence laws and the safe state, from the first principles of an earlier design.

## Totals after round 9
185 statements accepted by the Lean kernel and re-run by a second seat (148 through round 8, 37 here), plus 11 in
the weights side lab.
