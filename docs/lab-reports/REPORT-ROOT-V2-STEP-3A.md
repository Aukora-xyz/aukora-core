# REPORT ROOT V2 STEP 3A (v0.10: the refusing wrapper), written by Lead 12 from the coder's final reply (23 November 2026, Mac time 17:35)

Provenance: the coder (Opus agent `a30eee6cde1220545`) finished step 3a-ii at about 17:30. Its seat writes no report files, so Lead 12 filed this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this (17:34): `v0.10/aukora-core.wasm` is 7,620,299 bytes with SHA-256 `1d642eac3fd35032d8cf71e2ad015486eae4d866ff34e6e6cf715d60bcd0695f`; `v0.10/aukora-core-lite.wasm` is 690,873 bytes with SHA-256 `c924c72aec0214b59f1f9405ac2c7467b86e2d96985540570ad1896db3c25d93` (both equal the coder's claim); `v0.10/PINS.sha256` 118 lines, `SOURCE.sha256` 161 lines; the last build log under `logs/s3b/` ends `PASS v0.10 (964.0 seconds across separately bounded stages)`; no `sorry` or `native_decide` text in `Refusal.lean`, `Proofs/WrapRuns.lean`, `Proofs/BoundRefuses.lean`, `Proofs/PublicLawful.lean`; no axiom declaration lines in `Refusal.lean` or `Proofs/*.lean`; the Lean lock file is gone and no `lean` or `lake` process runs. NOT re-run by Lead 12: any build, kernel check or test. v0.10 is NOT part of any public release; v0.8 is untouched.

STEP 3A: v0.10 faithful copy yes; table split 38 forms (in v0.9); table agrees with decoder for the two legacy forms yes (v0.9); machine reads the refused list yes; bound start refuses both legacy forms (law and Wasm) yes; no lockout from a bound start yes; old start unchanged (twin test) yes; laws now 46

## CHECKED (kernel, REPORTED)
- **Fixed-filter equality (first job):** `run_wrap` (a run of the wrapper equals a run of the inner machine over the inputs the starting state does not refuse), `full_walk_wrap` (same with seals and continuations, which are never filtered and carry the register), `refused_noop` (a refused feed, reset or stamp leaves the state unchanged). No failure found.
- **Design decision for Mythos to judge: the essential forms are never refused.** Refused only if in the register and not essential; essential = halt, clear, the newer key change (ff 02 35), seal, continuation (decision C2). Reason: `h5` and `SessionFinal.Recovery` cover every state, including ones whose register lists clear.
- **Machine change:** the v0.9 machine is renamed `Safe11.innerModel` (35 files; proofs untouched; its 44 laws kept as `Lawful44`). The public `Safe11.fullModel` is `Refusal.wrap innerModel`; `Proofs/PublicModel.lean` checks by `rfl` that it equals the new exports in `Public.lean`. Exports `r11_step`, `r12_lite_step`, `r9_feed`, `r9_reset`, `r9_stamp` refuse first. `Bound12c.seed` sets `policy.id` and `policy.refused` to `[8, 14]`; the ordinary start is unchanged.
- **Laws carried, all with propext, Classical.choice, Quot.sound:** family A (one admitted step, about 20 laws), B (availability), C (whole runs by the fixed filter), D (`VersionAdvice` restated: promised only for aligned inputs that are not refused), E (v0.5 supplement `Root12.E5`, `E6` gain one hypothesis "not refused"). Old texts kept under `Old.*`, none pinned.
- **New:** fields `refused_refuses` and `essentials_open` (46 laws); `full_lawful : Lawful fullModel`; `refusal_is_lawful`; `Proofs/BoundRefuses.lean`: `bound_refuses_legacy`, `bound_recovery`, `old_start_unchanged`; `genuinely_stronger` witnessed by the public machine with a constant genesis.

## RAN (by the coder, REPORTED)
- Build `PASS v0.10 (964.0 s)`, 118 pins and 161 source entries OK; pins and source lists of v0.8 and v0.9 still check. Peak of the largest job 1,381 MiB.
- Twin test v0.9 against v0.10 on the ordinary start: 3,913 identical, 0 different, 0 traps, both files.
- `standalone-next/bound-test.mjs closed` 47/47 on both files (watch line "NO (closed in this core)"); bailiff `test-bound.mjs closed` 16/16; bailiff `promotion-test.mjs` 20/20; all release tests `TESTS rc=0`; `mythos-bound-edges` 30/30 on both files.
- Vectors `segments`, `record-binding`, `record-rebinding` regenerated (old copies in `logs/s3b/v010-old-vectors/`).

## New pins (REPORTED; sizes and hashes LEAD RAN)
`aukora-core.wasm` 7,620,299 B `1d642eac...0695f`; `aukora-core-lite.wasm` 690,873 B `c924c72a...5d93`; judge pin (normalized executable) `6d65ad3360c98c9fc5571efbcad71b0f020014e7068e7f2c406195e2e666752d`; law identity `dc0aa949c8cf8f08fba868595be6ef6f046b16542a9f7784ed0a113fa118690c`; 4,276 pinned declarations.

## Test edits and breakage (REPORTED)
- Edited (old copies in `logs/s3b/`): `tests/record-binding.mjs` and `tests/record-rebinding.mjs` (they asserted the limit this step closes; now expect refusal); `tests/gate-final.mjs` (two field names appended).
- `logs/repro12/mythos-binding.mjs` NOT edited and now fails at lines 44, 46, 48 BY DESIGN (it expects a bound record to admit the plain approval and re-addressed old forms). `mythos-forms.mjs` is still out of date from the v0.9 table split.

## NOT done
- **Addition 2 (the refusal stated on what the machine does):** not attempted. The machine's own interpretation files both old forms under `.legacy`, not as `KeyChange` or approval meanings, so the law needs a statement about owner changes and new grants across every route of the full machine; the coder did not prove it coincides with the decoder statement. Blocker 12 is therefore closed only in the sense of the bound start refusing the two forms in the decoder's terms.
- `refused_refuses` and `essentials_open` not yet in `PROVED.md`; nothing in `WIRE.md` or `EXPORTS.md` changed. Nothing writes the refused register except the bound start (step 3b).
- Not touched: Linux, the 35,000-line trap (blocker 13), any x6.1 use.

Notes: `logs/R12C-D-PROGRESS.md`; scripts and logs `logs/s3b/`.
