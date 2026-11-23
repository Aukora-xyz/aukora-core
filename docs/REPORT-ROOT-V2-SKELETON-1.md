# REPORT ROOT V2 SKELETON 1 (v0.7), written by Lead 11 from the coder's final reply (23 November 2026, Mac time 11:27)

Provenance: the coder's seat cannot write report files, so Lead 11 wrote this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this: `v0.7/aukora-core.wasm` is 7,390,811 bytes with SHA-256 69e711f1...982178; `v0.7/aukora-core-lite.wasm` is 676,440 bytes with SHA-256 1991baed...c119 (both equal the coder's figures); the coder's progress log ends `PASS v0.7 (804.0 seconds ...)` at 11:25:46 and `SKELETON-1 FINAL ... 110 pins OK` at 11:25:59; `v0.7/Policy.lean` contains no `sorry`, `native_decide` or `axiom` text; `v0.6/aukora-core.wasm` still has digest prefix cce58d54673b (unchanged). Lean lock at 11:26: HOLDER=MYTHOS (his own job). Lead did NOT re-run any proof or build. Mythos verifies with his own tools.

SKELETON 1: v0.7 faithful copy yes; memory fix peak before/after 3313/975 MiB; policy field added with no change of behaviour yes; 42 statements unchanged yes; proof lines touched 4

**Step 1, faithful copy.** `v0.7/` copied from `v0.6/` without `.work`. The folder name was replaced only in `tools/` and in `tests/*.lean` and `tests/*.mjs` (8 files); `build.sh` contained no folder name. `PINS.sha256` rewritten first, then `SOURCE.sha256`. PASS v0.7 with both Wasm digests identical to v0.6 (`cce58d54...`, `3bdb8e63...`).

**Step 2, memory fix.** `weaker_class_can_fail` now uses `decide +kernel` and its two `set_option` lines are removed (axioms: propext). PASS v0.7. No Lean job is above 1,500 MiB any more: `Proofs/Evidence11.lean` went from 3,313 to 975 MiB; the heaviest file is now `KernelCell.lean` at 1,382 MiB. Pins and Wasm digests did not change (the pinned environment keeps theorem statements, not proofs), so no vectors were regenerated in this step.

**Step 3, the state field.** `Policy9.Machine` gains `policy : Policy := {}` with `id`, `refused`, `enabled`, `limits`, `judge`; no step reads it. Changed lines in existing code: the state-building line in `Policy9.submit` and the three blank-state constructors in `FinalStrict`, `Round11Safe` and `ExportFinal` (4 changed lines, plus 17 added for the structure). No other proof needed repair. No statement file changed: `RootFinal.lean` and every law definition are byte-identical to v0.6. `full_lawful` kernel-accepted with 42 fields (axioms propext, Classical.choice, Quot.sound); the pinned environment holds 4,183 declarations.

**RAN (coder):** PASS v0.7 in 805 s with 110 pins (peak 1,364 MiB); genesis check passes with embedded identity `cda3b670...`; every test passes with no test edits; the second seat's `mythos-binding.mjs` 32/32 and `mythos-bound-edges.mjs` 30/30 with 0 traps on both v0.7 files (neither edited). Three stored vector files depend on the law identity, which the new field changes; regenerated with each test's own `--write`: `segments.json.gz` (aeb0de3e...), `record-binding.json.gz` (d77df70b...), `record-rebinding.json.gz` (ba76fb11...); previous copies in `logs/r12c-d/v07-step2-vectors/`; the cell12 vectors are unchanged.

**New pins:** `aukora-core.wasm` 69e711f1450448564054950a60dbffac399645e955a8c2562c7e0c1e0c982178; `aukora-core-lite.wasm` 1991baed9d058e95b799ea6bc00cc40e2c77ee29d2c54eeeeca36cb87f27c119.

**NOT done:** nothing reads `policy` yet; `enabled` and `limits` default to empty, meaning "today's forms and limits". v0.1-v0.6 unchanged; v0.6's pins still all check OK.

**What surprised the coder:** the schema change touched only 4 lines, and the memory fix changed no pins.

Files: `v0.7/Policy.lean`, `v0.7/Proofs/Evidence11.lean`, `v0.7/PINS.sha256`, `logs/R12C-D-PROGRESS.md`.
