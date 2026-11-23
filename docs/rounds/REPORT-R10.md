LAW SET: one, 23 laws, proved for the newest machine yes | RELEASE: v0.1 built yes, one-command PASS, core 6,310,580 B / lite 552,182 B / fixed successor 6,323,987 B | DOWNGRADE: Ed25519-only successor refused yes

### What the gate admitted

With a valid hybrid install grant for each file, the lab Wasm produced these results. [Gate transcript](logs/r10/gate-wasm-final.txt)

| Candidate bytes | Observed result |
| --- | --- |
| The newest machine went through the ordinary Lean → C → Wasm build with both fixed genesis keys compiled in. A final custom section records the model digest. | **Admitted.** The host loaded that digest in a fresh instance. The published grant passed with both fixed-owner signatures and failed with either signature removed. |
| The exact round-nine example came from the round-six Ed25519-only Wasm with a byte-patched initializer and a model commitment. | **Refused.** The archived file itself still accepted a grant signed with Ed25519 alone. |
| The same historical executable retained every instruction. Only its custom-section digest changed to identify its model through the release interface. | **Refused.** Lean proved this model violates H1 by computing an Ed25519-only grant that it adds. |

The gate also refused the exact round-seven proof on the admissible new file. The same install grant then succeeded with the new proof. Nobody can change the pinned law set from inside this gate. Its proof covers the carried Lean model. Whether arbitrary Wasm bytes implement that model remains unproved. [Proof controls](logs/r10/gate-native-final.txt) · [Trust and checker assumptions](v0.1/NOT-PROVED.md)

### What Lean proved and Wasm reproduced

The kernel accepted all 23 fields for the newest machine, its fixed-genesis successor and the replay-only core. All ten earlier laws have counterparts. L10's old confirmed/unknown result describes whether a confirmation ever occurred. The current query can return corrected-to-failed while the earlier confirmation remains in the record. [Law statements, proofs and assumptions](v0.1/PROVED.md)

The full core embeds its checker. Its pinned environment occupies **4,671,639 bytes (74.03%)**. Lite omits the checker, refuses every install, and reproduces full replay with install submissions removed. A host replaying a history with an accepted install needs the full core. [Lite trace theorem](v0.1/Proofs/LiteTrace.lean)

Lean and full Wasm agreed on the verdict and all 32 head bytes for **1,167 of 1,167 frames**, including a successful install. There were 195 acceptances and 972 refusals. [Corpus and replay command](v0.1/vectors/README.md) · [Wire format](v0.1/WIRE.md) · [All 15 exports](v0.1/EXPORTS.md)

The offline build `sh v0.1/build.sh` passed in **510 seconds** and reproduced every pinned output. After cleanup the working lab occupied **779 MiB**, including **14.0 MiB** for v0.1, excluding the two out-of-scope folders. [Check record](logs/R10-CHECKS.txt) · [Build transcript](logs/r10/clean-build.txt)
