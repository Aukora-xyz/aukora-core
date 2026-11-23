ML-DSA-65 INSIDE: yes, 7.205 ms warm | HYBRID CORE: built yes, 5,535,664 bytes | RISK LAW: proved yes

### Signatures and upgrades

Core8 verified both signatures inside Wasm before accepting a grant, a rebind or an owner control. It refused each single-signature case for all five inherited controls and the new threshold control. Both old keys authorized a rebind. Afterward, the new pair could issue a grant, and the old pair and both mixed pairs failed. The core observes signatures. Biometric capture is outside it. [Hybrid tests](logs/r8/core-final-hybrid-1.txt) · [Threshold tests](logs/r8/core-final-risk-1.txt)

The pure Lean ML-DSA-65 verifier is **implemented and tested**. Its cryptographic correctness remains unproved. The compiled native Lean executable and Wasm agreed on all 108 cases from 22 fresh Node/OpenSSL key pairs, covering messages of 0–4,096 bytes. They accepted 23 signatures and refused 85 cases, including one-bit changes, length errors, response norms at the rejection boundary, and malformed hints encoding the same signed set. Node’s default matched pure ML-DSA with an empty context. A nonempty-context signature failed in the empty-context verifier. [Lean source](core/Mldsa8.lean) · [Public vectors](logs/r8/public-vectors.tar.gz) · [Native results](logs/r8/native-check-1.txt)

On the clean rebuild, the first Wasm verification of the archived 32-byte message took **12.087 ms**, and the median of 11 warm checks was **7.205 ms**. The timer excludes module loading and host byte transfer. The measured grant frame was **3,432 bytes**. Its head took **0.161 ms** to compute in Core8, and its full accepted step took 17.594 ms. Genesis supplied the 1,984 public-key bytes, which both signatures bind into the grant message. A rebind carried the replacement keys in its 5,399-byte frame. [Clean rebuild and timings](logs/r8/clean-reproduction.txt)

The round-seven gate accepted each staged candidate with its own `Lawful` proof and dual-signed installation grant. It refused a swapped proof, the old `wrong_digest` theorem and mismatched staged bytes. The manifest still links those proofs to the two older Ed25519-only candidates. A gate acceptance records the candidate digest in the lab ledger. [Gate transcript](logs/r8/core-final-hybrid-1.txt)

### Danger scores and time brackets

Lean proved all five requested risk laws. Raising only the score preserves refusal. In Wasm, a mandate admitted an act at 63 with threshold 64, then failed at 64 and 65. At or above threshold, an accepted act spends a fresh dual-signed grant for that exact intent. Upgrade and rebind retain their signature floor at every score. Only a dual-signed control can change the threshold, which starts at zero. [Model laws](core/Risk8.lean) · [Wire-level proofs](core/Floor8.lean) · [Runtime results](logs/r8/core-final-risk-1.txt)

Each admitted act names its effective bundle. The host hashes the request, evidence, reasoning summary, witness verdict and model versions. The core records the supplied assessment. Missing assessments receive score 255 and an intent-specific digest that identifies the missing evidence. A grant can admit that case. Earlier bundle bytes remain readable after reassessment. [Admission and threshold proofs](core/RiskWire8.lean) · [Host encoding](spike/r8/test-host.mjs)

A stamp attaches an opaque beacon value and receipt digest to the current head. Lean proved that it preserves the hybrid state, risk state and earlier entries. Two stamps at the same head left a mandate usable at its original expiry. **Verification of both time values is outside the core.** [Stamp law](core/Stamp8.lean) · [Wasm run](logs/r8/core-final-stamp-1.txt)

| Wasm artifact | Bytes | SHA-256 |
| --- | ---: | --- |
| [Core8](core/Core8.wasm) | 5,535,664 | `3a3952bf1e76e03373ccf439bf8d0ac5270eabe4364b1f0ee019381e22f52d04` |
| [Standalone verifier](core/Mldsa8.wasm) | 142,148 | `d0613bcdb04ff787191d543971b0ef5a9126b63f58df5f5d2a59d59b1ef3e94e` |

The clean offline rebuild matched both pinned hashes. Run `sh spike/r8/run.sh` to repeat it. Downloads totaled **0 bytes**. After cleanup the lab occupied **770 MiB**. [Checks and retained failures](logs/R8-CHECKS.txt) · [Trusted files and line counts](logs/r8/trusted-lines.txt)
