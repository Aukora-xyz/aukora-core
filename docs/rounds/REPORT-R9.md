GATE: rule yes | REVOKE AND EXPIRY: proved yes | DIFFERENTIAL: 971 of 971 agree

### The upgrade gate

Core9 admitted a candidate with a new genesis key. The lab host loaded the ledger-selected bytes into a fresh Wasm instance. It refused grants from the supplied key and the previous fixture key, then accepted one from RFC 8032 key 2. The gate also admitted a file whose digest was generated after linking. Both runs used lab instances. [Gate transcript](logs/r9/clean-reproduction.txt)

The upgrade frame carries the model definitions, proof, staged-file digest and install intent. The checker type-checks each definition, then constructs `Lawful` applied to the final definition. It accepts up to 64 fresh monomorphic, nonrecursive definitions and 1 MiB of combined model and proof. Lean proved that every change of installed digest takes this route and spends a grant verified with both current owner keys. [Constructed-goal proof](core/Goal9.lean) · [Gate exclusivity](core/OnlyGate9.lean) · [Grant provenance](core/GrantOrigin9.lean)

With valid grants, Core9 refused the honest proof against a model that confirms an empty history, a file committing to a different model, and a declaration redefining `Lawful`. Lean proved `¬ Lawful` for the false-confirmation model. The gate requires a single `aukora.model.sha256` custom section matching the carried declarations. This stops silent model substitution for an approved file. The host validates Wasm instructions. Whether the file behaves as the model remains unproved. [Candidate theorems](core/Candidate9.lean) · [Section reader](core/ModelSection9.lean)

The checker trusts earlier lemma statements. The pinned contract permits the example candidate’s Ed25519-only successor policy. The verifier is a parameter of the signature laws. The Wasm gate supplies the concrete Ed25519 and ML-DSA-65 verifiers. Their cryptographic correctness remains unproved. [Trusted files](logs/r9/trusted-files.txt)

### Grants, outcomes and wire results

A grant remains usable through its expiry sequence. Revocation removes exactly one eligible grant and preserves every other grant and the generation. A revoked or expired intent cannot pass a direct act, mandate or install without a fresh hybrid-signed grant. Rebind clears all grants. A labelled correction must match the original intent. The Wasm view returned **5** for confirmed then corrected to failed, and **1** for an original failure. The first report remained readable. Lean proved retention across arbitrary command histories. [Policy laws](core/Policy9Laws.lean) · [Replay and query proofs](core/Core9PolicyLaws.lean) · [Wasm tests](logs/r9/policy-wasm-2.txt)

With a 32-byte parent, byte 40 is always the inner frame’s own tag. No valid ordinary frame is caught by the upgrade-tag test. The unrestricted encoder claim has a checked counterexample. A 33-byte parent can put a sequence byte of 7 at offset 40 in an encoded `say` event. [Tag proofs](core/Tag9.lean) · [Four corrected law comments](core/Laws9.lean)

Lean and Wasm agreed on every verdict and all 32 head bytes across 99 acceptances and 872 refusals. The corpus covers all 256 inner and outer tag values, length boundaries and an accepted install. [Vectors](logs/r9/vectors) · [Checks](logs/R9-CHECKS.txt)

| Wasm artifact | Bytes | SHA-256 |
| --- | ---: | --- |
| [Core9](core/Core9.wasm) | 5,614,804 | `2b5334497f16f1cc299236c15d7498c00f93a3f9e049b92373cd2c60ab76a7eb` |
| [FixedGenesis9](core/FixedGenesis9.wasm) | 1,970,929 | `497d493c8cf6c6f1fcb2517b721cb1c12f25446f8f85a91d6434447b95f0b649` |

The clean offline rebuild matched both Wasm hashes and the archived vectors. Reproduce with `sh spike/r9/run.sh`. Downloads totaled **0 bytes**. Final lab size was **791 MiB**.
