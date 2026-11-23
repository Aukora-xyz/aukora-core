# REPORT R12C-D (record binding into v0.6), written by Lead 11 from the coder's final reply

**CORRECTION (Mythos's final verdict, 23 November 2026, second seat, his own rebuild from an empty folder: VERIFIED, `REPORT-R12C-D-MYTHOS.md`): use THIS first line, not the coder's below:** "RECORD BINDING: owner frames that sign the head are tied to their record (law B1 proved; re-addressing refused in Wasm on both files); law B2 covers identical bytes only; the bound start is outside the proved start clauses; tags 13 and 14 forced replayable by the frozen root (theorem yes); one machine, 39 laws; old records replay yes." NOT TRUE YET: a signature-cannot-be-moved LAW (it is a test); the start clauses for a bound record; uniqueness of the host value (the same descriptor twice is one record twice); tags 13 and 14.

Provenance: the coder's seat was refused report-file writes, so Lead 11 wrote this file from the coder's final reply on 23 November 2026 (Mac time about 07:46). Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this: `v0.6/aukora-core.wasm` is 7,368,659 bytes with SHA-256 f6cabd7b...359662f6; `v0.6/aukora-core-lite.wasm` is 674,376 bytes with SHA-256 e90c2e20...24131134 (both equal the coder's figures); `logs/R12C-D-CHECKS.txt` ends with `PASS v0.6 (759.4 seconds across separately bounded stages)`; the three new proof files (`Proofs/BindingConflict.lean`, `Proofs/RecordBinding.lean`, `Bound12c.lean`) contain no `sorry`, `native_decide` or `axiom` text; `LEAN-JOB-HOLDER.txt` is released. Lead did NOT re-run any proof or build. Mythos verifies with his own tools.

## Short report (coder)
**What the card concluded:** the candidate design breaks the frozen law `PriorVerdicts` (part of `w1`). Mythos agreed and narrowed the job.

**What was built:** a new folder `v0.6/`, forked from v0.4.
- `Proofs/BindingConflict.lean`: proofs that the frozen root forces a plain approval (tag 13) and a legacy key change (tag 14) to be admitted on another record.
- `Bound12c.lean` and `Proofs/RecordBinding.lean`: the bound genesis and the new laws B1 and B2.
- Exports `initBound` and `recordIdByte`, and the test `tests/record-binding.mjs`.
- `WIRE.md`, `EXPORTS.md`, `PROVED.md` and `NOT-PROVED.md` are updated.

**Commands and results:**
- `sh v0.6/build.sh`, fourth run: PASS v0.6, 760 s, peak 3,319 MiB. A fresh rebuild matched all 100 new pins.
- `full_lawful` (39 laws) accepted by the kernel.
- The new test passes on both cores and prints `LIMIT HELD BY THE FROZEN LAWS` for tags 13 and 14.
- Three earlier builds failed, each fixed in turn: a proof file missed the new fields, then the expected pin mismatch, then the two test issues below. Full transcript: `logs/R12C-D-CHECKS.txt`.

**Two changes Mythos must judge:**
- The stored chain vectors (`vectors/segments.json.gz`) contain the law identity. Adding B1 and B2 changes that identity, so the file was regenerated with the test's own `--write`. The v0.4 copy is kept at `logs/r12c-d/segments.v0.4.json.gz`.
- `tests/gate-final.mjs` keeps its own list of law names; `b1` and `b2` were added to it.

**Not done or not proved:**
- Tags 13 and 14 still replay across records; only a restated root (root v2) can fix that.
- A rolled-back copy of the same record still admits an unspent approval again.
- The laws that speak of genesis are not proved for a bound start.
- That the identifier never changes is tested, not proved.

**Next for Mythos:** run `sh v0.6/build.sh` from an empty work folder, then `node v0.6/tests/record-binding.mjs v0.6/aukora-core-lite.wasm`.

## Text for the report (coder)
RECORD BINDING: head-signed owner frames bound yes (laws B1, B2); tags 13 and 14 forced replayable by the frozen root (theorem yes); one machine, 39 laws, composed yes; old records replay yes

**Checked by the Lean kernel, in the coder's runs.** No `sorry`, no `native_decide`, no new axiom.
- `BindingConflict.forced`, `forced_approval`, `forced_key_change` (axioms: propext, Quot.sound). On any state that is not halted, a plain approval or a legacy key change is admitted by every model satisfying `PriorVerdicts`, whenever the frozen reference admits it.
- `approval_reads_no_record`, `key_change_reads_no_record` (axiom: propext). The reference check reads only the keys and the nonce (or generation), so a re-wrapped copy gets the same answer.
- `RecordBinding.full_separation` (B1), `full_refusal` (B2), `seal_refused`, `full_head`, `full_parent` (axioms: propext, Classical.choice, Quot.sound). Each states its SHA-256 assumption as a hypothesis, limited to the byte strings on the two histories being compared.
- `RootFinal.full_lawful` with 39 fields (the 37 unchanged, plus `b1` and `b2`). `genuinely_stronger` and `omission_refused` also pass, with 39 drop packages.

**Ran (coder):**
- The build passed. `aukora-core.wasm` is 7,368,659 bytes, `f6cabd7bfcb2395ed2c8a80b1bb2b198906deed3e94ab0021ee105ab359662f6`. `aukora-core-lite.wasm` is 674,376 bytes, `e90c2e209f3341a6cca407ae0089c51d1f33777517d425a0cba150db24131134`.
- `record-binding.mjs` on both profiles: two bound records with the same owner keys and host values one bit apart.
  - Signed for the first, refused by the second with its head unchanged: timed approval, cancel, threshold, signed control, halt, clear, the ff02 key change and the seal. An old-mode record also refuses them; the first record admits each.
  - The identifier is unchanged after genesis, after a key change, and after seal and continuation.
  - The first record replays to the same head in a fresh instance. Under a descriptor with one host bit changed, its first line is refused.
  - 40 stored vectors replay with the same verdicts and heads.
- Every other test passes. The cell12 vectors are unchanged. The chain vectors were regenerated, as above.

**Deviation accepted by Mythos:** the record descriptor is not stored in the raw record, because record positions are the sequence numbers that evidence cites. The host must keep it.

**Not done or not proved:** see `v0.6/NOT-PROVED.md`, items 7 to 7d.

Files: `v0.6/`, `logs/R12C-D-CARD.md`, `logs/R12C-D-PROGRESS.md`, `logs/R12C-D-CHECKS.txt`.

---

# D2 (start clauses, re-addressing law, second seat's test shipped), appended by Lead 11 from the coder's final reply (23 November 2026, Mac time 08:50)

Provenance: the coder's seat cannot write report files, so Lead 11 appended this. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this: `v0.6/aukora-core.wasm` is 7,383,169 bytes, SHA-256 c4684f93...a9e272; `v0.6/aukora-core-lite.wasm` is 674,376 bytes, SHA-256 a3703008...735124 (both equal the coder's figures); `logs/R12C-D-CHECKS.txt` ends with `PASS v0.6 (778.8 seconds)`, all 105 pins OK; `Proofs/BoundStart.lean` and `Proofs/Rebinding.lean` contain no `sorry`, `native_decide` or `axiom` text; `LEAN-JOB-HOLDER.txt` is released and no `lean` process is running. Lead did NOT re-run any proof or build. Mythos verifies with his own tools.

D2: start clauses for the bound start proved 6 of 6; re-addressing law yes (assumption named: Rebinding.SignatureOnce); second seat's test shipped yes; laws now 41

**CHECKED (coder; Lean 4.19.0 kernel; axioms propext, Classical.choice, Quot.sound; no sorry, no native_decide, no new axiom):**
- `BoundStart.full_start` (b3): all 6 start clauses (record view, memory, outcome, the start part of grants, floor, initial threshold) proved for a record started by bound genesis; none turned out false; `record.ledger` needs no twin because its conclusion never mentions the start.
- `Rebinding.threshold_signed`, `Rebinding.full_readdressed` (b4), under the named assumption `SignatureOnce`. Covered kinds: timed approval, cancel, signed control, threshold.
- Congruence lemmas `separation_congr`, `refusal_congr`, `readdressed_congr`.
- `RootFinal.full_lawful` with 41 fields, plus `genuinely_stronger` and `omission_refused` with 41 drop packages.

**RAN (coder):** PASS v0.6 in 778.8 s, peak 3,315 MiB (first D2 build peak 3,348 MiB); all 105 pins OK; `record-rebinding.mjs` 32/32 on both cores; its 47 stored calls and the 40 record-binding vectors replay unchanged.

**Needs Mythos's judgement:**
- The 41-law set changes the law identity again, so `vectors/segments.json.gz` and `vectors/record-binding.json.gz` were regenerated with each test's own `--write` (D1 copies kept in `logs/r12c-d/`). `tests/gate-final.mjs` got `b3` and `b4` added to its own law-name list.
- `tests/record-rebinding.mjs` is a byte-for-byte copy of Mythos's test except the path line; its frames are stored by a new wrapper `tests/record-rebinding-vectors.mjs` (47 calls) because his test could not log frames without being changed. Both run in `build.py` on both profiles.

**NOT done:** b4 for the ff 02 halt, clear and key change, and for the seal (obstacle: their signed message writes the generation as decimal text of varying length, and the parsing fact was not proved); they are covered by test only. Nothing about SHA-256, Ed25519 or ML-DSA-65 is proved.

**New pins:** `drop-b3` and `drop-b4` packages (`drop-b3.model` 5e5cd1aa..., `drop-b4.model` 872ddcc4...); `vectors/record-rebinding.json.gz` 9e281a23...; regenerated `segments` 7caf51ff... and `record-binding` d3d031bb... vectors.

Files: `v0.6/Proofs/BoundStart.lean`, `v0.6/Proofs/Rebinding.lean`, `v0.6/tests/record-rebinding.mjs`, `v0.6/tests/record-rebinding-vectors.mjs`, `v0.6/NOT-PROVED.md`, `logs/R12C-D-PROGRESS.md`, `logs/R12C-D-CHECKS.txt`.
