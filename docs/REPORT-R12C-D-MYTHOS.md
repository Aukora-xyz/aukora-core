RECORD BINDING (v0.6): rebuilt byte-identical by the second seat. Owner frames that sign the head are tied to their record, shown by re-addressing in Wasm. The two old forms still travel (forced by the frozen root). TWO overstatements in the builder's first line: the new law covers identical bytes only, and the bound start is outside the proved start clauses.

# Round 12c part D, verified by Mythos · 23 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh v0.6/build.sh` from an empty work folder, under the 4 GB watchdog | **PASS v0.6** in 778.5 s; no `sorryAx`; largest process 3,486 MB resident; nothing killed. After the build all 100 output pins and all 140 source pins match. `aukora-core.wasm` 7,368,659 bytes `f6cabd7bfcb2395ed2c8a80b1bb2b198906deed3e94ab0021ee105ab359662f6`; `aukora-core-lite.wasm` 674,376 bytes `e90c2e209f3341a6cca407ae0089c51d1f33777517d425a0cba150db24131134`. Transcript `logs/R12C-D-mythos-rebuild.txt` |
| Kernel acceptance in my rebuild | `full_lawful` (39 fields), `genuinely_stronger`, `omission_refused`; `BindingConflict.forced`, `forced_approval`, `forced_key_change`, the two `reads_no_record` theorems; `RecordBinding.full_separation`, `full_refusal`, `seal_refused`. Axioms across all 283 printed theorems: only `propext`, `Classical.choice`, `Quot.sound` |
| SOURCE read | The 37 law statements are textually unchanged (`RootFinal.lean`: additions only). `b1` and `b2` are new fields. `rootNames`, the drop count (37 to 39) and the test's law-name list grew; nothing was removed |
| **My own binding test** (`logs/repro12/mythos-binding.mjs`, both files) | 32 of 32. For timed approval, cancel, threshold, signed control, halt, clear, the newer key change and the seal: A's frame presented to B unchanged is refused, AND A's frame RE-ADDRESSED to B with A's signatures is refused; B's head does not move. The plain approval and the old key change, re-addressed, are ADMITTED (the forced limit). In OLD mode a timed approval travels byte for byte to a twin record with the same keys (the defect) |
| Edges of the bound start (`mythos-bound-edges.mjs`, both files) | 30 of 30, 0 traps: seven malformed starts refused and a proper start still works after each; a second start, an old start on a bound record and a bound start on an old record are refused; the first head equals the identifier; out-of-range identifier reads give the sentinel |
| Old records and hostile inputs (my round-11 harness, v0.6 full file) | 1,838 of 1,838 frames give the stated verdict and head; 5,427 hostile frames: 0 traps, 0 stale replays accepted, halt never cleared (117 tries) |
| Adapter and limits (v0.6 small file) | Standalone adapter 34 of 34 unchanged; at 512 lines speech, approval and threshold refused, key change admitted; staging stops at 16 MiB |

## The two changes the builder asked me to judge
1. `vectors/segments.json.gz` regenerated: ACCEPTED. The file embeds the law identity, which changes when laws are added; the test's own documented option was used; the old copy is kept. So "every existing vector unchanged" has this one justified exception.
2. `tests/gate-final.mjs` law-name list gained `b1`, `b2`: ACCEPTED. Growth, nothing removed.

## What is true now
- A record started the new way has an identifier (a fingerprint of its law set, owner keys and a host value), and its first head is that identifier. B1 is proved: two such records with different identifiers never share a head, across key changes, seals and continuations, under a stated SHA-256 assumption.
- Every owner frame that signs the head is therefore useless on another record, including when an attacker re-addresses it (RAN, both files).
- The limit is now a theorem, not a test result: under the frozen 37, every lawful machine must admit a plain approval and an old key change wherever the frozen reference does.

## What is NOT true (first two correct the builder's headline; the builder's own NOT-PROVED 7b and 7c already say them)
1. **B2 is proved for identical bytes only.** Its list of head-signed kinds is not used by its proof; the same statement holds for a plain approval. That a SIGNATURE cannot be moved to another record is shown by my Wasm test, and rests on the two signature checks, tested and not proved.
2. **The bound start is outside the model's own genesis.** The clauses of the 37 that speak of the start (initial threshold, no grants, memory, outcome, floor, record view) are proved for the ordinary start only. For a bound record they are believed, not proved.
3. **The same descriptor used twice is one record started twice** (RAN): identifiers are equal and every signature travels. The host value's uniqueness is the host's job. Only an outside keeper of the head shows a fork.
4. **Tags 13 and 14 still travel.** An owner who never signs those two forms is not exposed; the core does not enforce that. The cure is the restated root (readiness blocker 12).
5. A rolled-back copy of the same record still admits an unspent approval again. The host must keep the descriptor; a lost one means the record cannot be replayed. That the identifier never changes is tested, not proved.
6. Unchanged: proofs are about the model, not the bytes; reproduced on one Mac; record end of life by growth (blocker 13); nothing runs in a live system.

## Next
Job `logs/R12C-D2-JOB.md` for the builder (short): prove the start clauses for the bound start; state the re-addressing law under a named signature assumption; ship my re-addressing test in the release. Then the adapter change (never sign tags 13 and 14; start records bound) by Mythos, and part A.

# D2, verified by Mythos · 23 November 2026, 09:05

D2: rebuilt byte-identical by the second seat. The start clauses now hold for the bound start (law b3, 6 of 6). A re-addressing LAW exists for four kinds (b4, under one named signature assumption); for halt, clear, the newer key change and the seal it is still test only. One machine, 41 laws.

| What | Result |
| --- | --- |
| `sh v0.6/build.sh` from an empty work folder, under the 4 GB watchdog | **PASS v0.6** in 835.0 s; no `sorryAx`; largest process 3,413 MB; nothing killed. All 105 output pins and 144 source pins match afterwards. `aukora-core.wasm` 7,383,169 bytes `c4684f931e93cd97f83f8922883178abb274a1d897b444ad864d163007a9e272`; `aukora-core-lite.wasm` 674,376 bytes `a3703008f145e59571cdc52e18fc81f547d25c0782622ed3603650c85c735124`. Transcript `logs/R12C-D2-mythos-rebuild.txt` |
| Kernel acceptance in my rebuild | `BoundStart.full_start`, `Rebinding.full_readdressed`, `full_lawful` (41 fields), `genuinely_stronger`; axioms only `propext`, `Classical.choice`, `Quot.sound` |
| My harnesses on the D2 files | binding 32 of 32 and start edges 30 of 30 on both files; round-11 corpus 1,838 of 1,838; 5,427 hostile frames, 0 traps; adapter 34 of 34; recovery at the 512-line limit works |
| SOURCE read | b3 restates each start clause for `Bound12c.genesis` and proves it from `genesis_old`: not empty. b4's assumption `SignatureOnce` says one pair of signatures does not verify for two different (keys, message) pairs; the proof still needs B1 to finish, so the assumption is not the conclusion. The shipped `tests/record-rebinding.mjs` differs from my test in one line (the path) |
| The builder's two judgement calls | Regenerated `segments.json.gz` and `record-binding.json.gz` (the law identity is embedded and changed with 41 laws) and the longer law-name list: ACCEPTED |

## What is NOT true after D2
1. b4 covers the timed approval, cancel, signed control and threshold. For the halt, clear, the newer key change and the seal, "the signature cannot be moved" is shown by the Wasm test only.
2. `SignatureOnce` and `NoCollision` are assumptions about Ed25519, ML-DSA-65 and SHA-256 as implemented here: tested, not proved.
3. Unchanged: tags 13 and 14 travel (forced by the frozen root; blocker 12); the same descriptor twice is one record twice; a rolled-back copy admits an unspent approval again; the host must keep the descriptor; identifier constancy is tested, not proved; end of life by growth (blocker 13); proofs are about the model.
4. A watch item: the root check peaks at 3.3 to 3.5 GB under a 4 GB cap. One more large law may not fit; that would be a finding, not a reason to raise the cap.

## Next
Job `logs/R12C-A-JOB.md` (a gate that cannot pin what is not satisfied; card first). Then the adapter (start records bound; never sign tags 13 and 14) by Mythos.
