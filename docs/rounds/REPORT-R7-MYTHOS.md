LAWS AS ONE PROOF: checked inside Wasm, verified by a second seat (all four files and both proofs rebuilt byte-identical). HYBRID RULE: proved in the model. The checker inside takes 459 earlier lemmas as given, and a manifest, not a proof, still links the model to the bytes.

# Round 7, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh spike/r7/run.sh` from the recorded sources | **PASS Round 7** in 6 min 28 s, no errors, no gaps. Every pinned hash matched: `Kernel7.wasm` 5,141,599 bytes `8b56068367afc94eaec32fa1fcce305acfe0276bc17b1c231780dc79f90eb4c1`; `Core7.wasm` 5,401,782 bytes `03c1da12cb753a8c81bd40917aabf0479eaf4ad433fa7c60bb0d870c08a8cace`; `FixedOwner6.wasm`; `Shake7.wasm`; both carried proofs; the checker's environment. Transcript `logs/R7-mythos-rebuild.txt` |
| Lean statements | 14 new named theorems (`Laws7` 3, `Advice7` 1, `Hybrid7` 7, `Upgrade7` 2, `Other7` 1), all accepted |
| `core/Laws7.lean`, read by me | `Laws` is one structure with ten fields, L1 to L10, each with a one-line plain-words comment, stated over a machine's public operations and observations only. `Lawful` quantifies over every owner key and checker context. The SHA-256 and signature assumptions are named, not hidden |

## What is true now
- Her ten laws are one proposition, `Lawful`, and the round-6 core's model is proved to satisfy it.
- That proof (110,211 bytes) is carried in an upgrade frame and checked inside Wasm in about 11 ms (Astra's
  measurement). The gate accepts a candidate only with its own `Lawful` proof, the approved bytes and the owner's
  signature. It refused another candidate's proof and it refused the round-6 proof, a true theorem about the wrong thing.
- The hybrid signature rule (both keys must sign grants and rebinds) is proved on the abstract machine.
- SHAKE-256 is implemented in Lean, 70,788 bytes of Wasm, and matched OpenSSL on every comparison Astra ran.

## What is NOT true yet
1. **The checker inside Wasm does not re-check everything.** It checks the final assembly of the ten laws against an
   environment of 3,098 declarations in which 459 earlier theorem statements are taken as given. Those lemmas were
   checked by native Lean 4.19.0 (and re-run by me), not inside Wasm.
2. **The proof is about the model.** A pinned manifest pairs each proved model with a file's SHA-256. Proving that
   the Wasm bytes behave as the model says is still open and still rated research.
3. The running core still verifies Ed25519 only; the hybrid rule is not yet in a Wasm file.
4. The checker is now 5.1 MB because of the larger environment.
5. Trusted and unproved, as before: lean4lean, the runtime subset, the interface and build files, both compilers,
   the Wasm engine, and the hash and signature implementations.

## Totals after round 7
130 statements accepted by the Lean kernel and re-run by a second seat. The newest gate requires one proof of all
ten laws for the candidate's model before her core can change.
