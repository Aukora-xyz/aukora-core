# Aukora Core v0.8: four columns, kept apart. Mythos, 23 November 2026

A claim may be read only in the column it sits in. "Observed" means run in WebAssembly on the shipped bytes on one
Mac. "Not established" is not a footnote: it is the fourth column.

| Subject | Proved in Lean (about the model) | Built and byte-pinned | Observed running | Not established |
| --- | --- | --- | --- | --- |
| The law set | 44 named laws hold for one machine (`full_lawful`), kernel-accepted in two independent builds | the full file embeds that set's identity `4815cb2e…6acddc`; a build check compares it with the proved statement | the file reports that identity when run | that the compiled file behaves as the model |
| Record chain | every admitted line names the head before it; accepted bytes are recorded exactly | both Wasm files pinned by SHA-256 | a changed, dropped or reordered earlier line is refused on replay | a dropped or edited LAST line (needs a head kept elsewhere) |
| Approvals | a spend needs a current approval, logs it, consumes it; expiry and cancel are exact | same | no approval, a changed byte, reuse, expiry, cancel: refused (adapter and sink rehearsal) | that anything downstream obeys; that the old one-time form is tied to a record (it is NOT: observed travelling) |
| Record binding | two bound records with different identifiers never share a head; four kinds of signed frame cannot be re-addressed (under two named assumptions) | same | 53 re-addressing attempts refused, both files | the same for halt, clear, the newer key change, seal (tested only); old-start records |
| Self-change | a successor set must entail the pinned one; the pin implies the carried machine satisfies it | the checker inside the full file is pinned | wrong judge, failed entailment, unsatisfied set: each refused with its own reason | change of the MACHINE through the gate (law data only); the checker's own correctness |
| Owner's restriction list | promises restated "unless refused"; registers never change; old text holds wherever the list is empty | same | v0.8 behaves as v0.7 on 3,913 paired inputs | any machine that refuses; agreement of the form table with the decoder |
| Cryptography | nothing | implementations in Lean, compiled | vectors and adapter runs; a second toolchain agrees on one small unrelated program | Ed25519, ML-DSA-65, SHA-2, SHAKE correctness; side channels |
| Rebuild | not applicable | pins for every toolchain file and every output | two from-scratch builds on one Mac give identical bytes; isolated build from the public tree: see the verdict file | Linux; a second machine; the toolchain download step from an empty folder until run |
| Limits of a record | segment limits and the recovery reserve are in the model | same | 512 lines per segment refused beyond; chain ends by trap near 35,000 lines (earlier small core) | a clean refusal at the end of life; start from a seal |

Dependencies and licences: the tree's `NOTICE`. Executable upgrade limit: row "Self-change", last column. Where the
proofs stop: at cryptography, at compilation and at the host, which is believed for time, assessments and digests.
