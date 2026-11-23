# REPORT ROOT V2 STEP 3A-I (v0.9: table split, no behaviour change), written by Lead 12 from the coder's final reply (23 November 2026, Mac time 15:33)

Provenance: the coder (Opus agent `a30eee6cde1220545`) was resumed by Lead 12 at about 14:56 on Mythos's exact words ("Read logs/ROOT-V2-SKELETON-3A-JOB.md, then logs/ROOT-V2-STEP-3A-RESUME.md, and do 3a-i exactly; every rule of BRIEF-R12C-D.md still binds."). Its seat writes no report files, so Lead 12 wrote this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this (15:32): `v0.9/aukora-core.wasm` is 7,583,075 bytes with SHA-256 starting `2c166cce41a922e5001a7c21`, `v0.9/aukora-core-lite.wasm` 679,634 bytes starting `61e02592287d31ef8ad2ba13` (both equal the coder's claim); `v0.9/PINS.sha256` has 114 lines and `v0.9/SOURCE.sha256` 155; build logs under `logs/s3a/` end `PASS v0.9 (959.2 seconds ...)` and `PASS v0.9 (908.9 seconds ...)`; `logs/s3a/tests-c2.log` ends `TESTS rc=0`; `v0.9/Proofs/FormsDecoder.lean` and `v0.9/Forms.lean` contain no `sorry`, `native_decide` or `axiom` declaration text; the Lean lock is free and no `lean` process runs. NOT re-run by Lead 12: any build, kernel check or test. v0.9 is NOT part of any public release; v0.8 is untouched.

STEP 3A-I: v0.9 table split 38 forms; table agrees with decoder for the two legacy forms yes; behaviour unchanged (twin test) yes; laws 44; PASS v0.9 yes

## CHECKED (kernel, REPORTED)
- Table split: `v0.9/Forms.lean` has one form per effect, 38 forms: `speech` became say 1, remember 2, correct 3, advise 4; `signedControl` became retract 9, mandate 10, budget 11, pass 12, revoke 13; the rest follow (report 5, spend 6, read 7, approval 8, legacyKeyChange 14, ... continuation 38). `table` and `enabled_default` use no axioms; `all_complete` and `code_injective` propext only. `Policy.enabled` written out 1 to 38.
- Table against the decoder, new `v0.9/Proofs/FormsDecoder.lean`: `approval_is_filed` (a decoded legacy grant is filed as `approval`; axioms propext, Classical.choice, Quot.sound) and `legacy_key_change_is_filed` (a decoded rebind is filed as `legacyKeyChange`; axioms propext, Quot.sound). Four helper proofs use `grind`; no `sorry`, `native_decide` or new axiom.
- Root law: `full_lawful` still 44 fields (propext, Classical.choice, Quot.sound); the pinned environment holds 4,252 declarations. The machine is unchanged.

## RAN (by the coder, REPORTED)
- Builds: step 1 PASS 959 s with Wasm identical to v0.8; c1 and c2 stopped at the pin check as expected and produced identical Wasm; final c3 `PASS v0.9 (908.9 s)`, peak 1,228 MiB, 114 pins OK, SOURCE 155 OK; genesis check passes with law identity `f18a68c583b8e354f41b24eb94271ea2f21686af05c4f695be5e613a6c2b8f6f`.
- Vectors `segments`, `record-binding`, `record-rebinding` regenerated with each test's own `--write` (old copies in `logs/s3a/v09-old-vectors/`).
- Tests: all node tests pass (`TESTS rc=0`, 0 FAIL, `logs/s3a/tests-c2.log`); twin test v0.8 against v0.9: 3,913 identical, 0 different, 0 traps, full and lite; `mythos-binding` 53/53 and `mythos-bound-edges` 30/30 on both files; v0.8's pins and source list still check with 0 mismatches.

## New pins (REPORTED; sizes and first hex LEAD RAN)
`aukora-core.wasm` 7,583,075 B `2c166cce41a922e5001a7c211285cd03908e0f5d86e27b1e1d1dfbfac505bd14`; `aukora-core-lite.wasm` 679,634 B `61e02592287d31ef8ad2ba13b15a46deff7edfd0de0c8866fe245a641abd2419`; judge pin (normalized executable) `b4d4cb6c1e410351d95b9fefd770a471bd2b65ec027cbcb6ef8a5f8bd970a829` (v0.8: `1c24a647...0f23`). Largest job peak 1,389 MiB (c1).

## Out of date / NOT done / differences
- `tests/second-seat/mythos-forms.mjs` is out of date (it carries the v0.8 hand port of the merged `speech`/`signedControl` forms); on v0.9 against that old port it reports 14 of 14 admitted frames filed as meant and 0 of 18,615 changed selector bytes admitted; the coder did not edit it.
- NOT done: steps 4 and 5 (3a-ii, the new folder `v0.10`); `standalone-next/bound-test.mjs` and the bailiff test not run (they belong to 3a-ii); blocker 12 is still OPEN in this core.
- Differences from the job text: helper scripts rely only on the shared lock (wait, never overwrite; no old 14:00-15:30 reservation); `v0.9/tools/check.py` lists `Proofs.FormsDecoder` by default.
- Next, after Mythos's verdict: fork `v0.10` from the frozen v0.9 and start 3a-ii; the coder's first job there is to test Mythos's hint that a run of the refusing wrapper equals a run of the inner machine with the inputs refused at the starting state removed, and report that before carrying any family of laws. Notes: `logs/R12C-D-PROGRESS.md`; scripts and logs: `logs/s3a/`.
