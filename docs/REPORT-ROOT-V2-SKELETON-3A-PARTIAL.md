# REPORT ROOT V2 SKELETON 3A, PARTIAL (v0.9, NOT finished), written by Lead 12 from the coder's final reply (23 November 2026, Mac time 14:35)

Provenance: the coder (Opus agent `a30eee6cde1220545`) was told by Lead 12 at 14:25 to stop at its next step boundary so Mythos could use the Lean slot for the public-release rebuilds; it stopped at 14:33 after its c1 build. Its seat writes no report files, so Lead 12 wrote this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this (14:34): `v0.9/` and `logs/s3a/` exist; `v0.9/Proofs/FormsDecoder.lean` (230 lines) and `v0.9/Forms.lean` (261 lines) contain no `sorry`, `native_decide` or `axiom` declaration text; a build log under `logs/s3a/` ends `PASS v0.9 (959.2 seconds ...)`; the Lean lock is now held by Mythos (his isolated build of the public tree, started 14:33:36); `v0.8` was not touched (frozen). NOT re-run by Lead 12: any build or kernel check. v0.9 is NOT part of tonight's public release.

STATE: steps 1 to 3 of the job are done at the kernel level; step 2 still needs its vectors, tests and a final build; step 4 (the machine reads the refused list) has NOT started.

## Done
- **Step 1, faithful copy (RAN by the coder):** `v0.9/` forked from `v0.8` by `logs/s3a/fork9.py` (129 replacements). `sh v0.9/build.sh`: `PASS v0.9` in 959 s, peak 1,361 MiB; both Wasm digests equal v0.8's (`d0d3bfe5...ddf84b`, `2f10eb8f...0b59e9`); all 114 pins OK.
- **Step 2, table split (kernel-checked; the build is not finished):** 38 forms. `speech` became say, remember, correct, advise; `signedControl` became retract, mandate, budget, pass, revoke. Renumbered 1 to 38 (say, remember, correct, advise, report, spend, read, approval, retract, mandate, budget, pass, revoke, legacyKeyChange, then the rest as before). `table` and `enabled_default` need no axioms; `all_complete` and `code_injective` only propext. `Policy.enabled` written out 1 to 38. `full_lawful` with 44 fields passes (propext, Classical.choice, Quot.sound), 4,252 pinned declarations. The machine is unchanged.
- **Step 3, table against the decoder (kernel-checked):** new `v0.9/Proofs/FormsDecoder.lean` (added to the default list in `tools/check.py`): `approval_is_filed` (a decoded legacy grant, tag 13 hex, action byte 03 at offset 3350, is filed as `approval`) and `legacy_key_change_is_filed` (a decoded rebind, tag 14 hex, is filed as `legacyKeyChange`). No `sorry`, `native_decide` or axiom; four helper proofs use `grind`.
- **Build c1 (RAN by the coder):** stopped at the pin check as expected (the split changes the law identity); the Lean stage and the genesis check passed. New law identity `f18a68c5...2b8f6f`; new Wasm on disk, not yet pinned: full `2c166cce...05bd14` (7,583,075 bytes), lite `61e02592...bd2419`; judge pin v0.8 `1c24a647...0f23` to c1 `b4d4cb6c...a829`.

## NOT done
- After c1: the law-bound vectors are not regenerated (old copies kept in `logs/s3a/v09-old-vectors/`); no node tests, no twin test v0.8 against v0.9, no second-seat tests; so "the split changes no behaviour" is NOT yet tested. `PINS.sha256` and `SOURCE.sha256` not regenerated; no final `PASS v0.9` with new pins.
- **Step 4 not started and the large part:** making the real machine refuse means re-proving all 44 laws for a different step (nearly every proof computes through `Safe11.fullModel`'s step; about 15 laws are about whole runs). The coder's route: rename the current machine to an inner model with its proofs intact, define `fullModel` as a wrapper that refuses refused inputs, carry each law across with lemmas showing a run of the wrapper equals a run of the inner machine with each refused input replaced by a no-op frame. **Estimate (not a finding): several hours, past the job's two-hour guard.**
- `tests/second-seat/mythos-forms.mjs` is out of date because of the split; not run, not edited.

## Two deviations
1. The old 14:00-15:30 reserved-slot guard was dropped from the coder's helper scripts; only the shared lock is used (`logs/s3a/waitrun.sh` waits for the lock, never overwrites it).
2. `v0.9/tools/check.py` gains `Proofs.FormsDecoder` in its default module list.

## Next command when the coder is resumed (one at a time, each under the lock; the build's cleanup removed the work folder, so rebuild first)
`cd ~/aukora-memory/scratch/lean-core-lab-2026-11-22 && sh logs/s3a/waitrun.sh logs/s3a/build.sh c2-build`
Then: (1) regenerate the three law-bound vectors with each test's own `--write` (`chain-vectors`, `record-binding`, `record-rebinding-vectors`); (2) `sh logs/s3a/tests.sh`; (3) twin test v0.8 against v0.9 and `mythos-binding` / `mythos-bound-edges` on both files; (4) regenerate PINS (114 entries), then SOURCE (add `Proofs/FormsDecoder.lean`); (5) one final build. Then step 4, if Mythos still wants it.
Notes: `logs/R12C-D-PROGRESS.md`; scripts, drafts, logs: `logs/s3a/`.
