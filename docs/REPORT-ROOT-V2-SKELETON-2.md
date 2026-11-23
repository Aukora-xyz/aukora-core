# REPORT ROOT V2 SKELETON 2 (v0.8), written by Lead 12 from the coder's final reply (23 November 2026, Mac time 13:18)

Provenance: the coder is a NEW Opus agent started by Lead 12 at 11:46 on `logs/ROOT-V2-SKELETON-2-JOB.md` (the earlier coder agent could not be resumed). Its seat
writes no report files, so Lead 12 wrote this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this:
`v0.8/aukora-core.wasm` is 7,554,007 bytes, SHA-256 starts `d0d3bfe5`; `v0.8/aukora-core-lite.wasm` is 679,046 bytes, SHA-256 starts `2f10eb8f` (both equal the coder's
claim); `v0.8/PINS.sha256` has 114 lines and `v0.8/SOURCE.sha256` 154; the build logs `logs/sk2/s1-build.log`, `s2-build.log`, `t2-build.log` end `PASS v0.8` (803.5 s,
790.1 s, 905.7 s); `logs/sk2/tests-t1.log` ends `TESTS rc=0`; the new files `Proofs/PolicyCarried.lean` (227 lines), `Forms.lean` (217), `Proofs/OldText.lean` (191)
contain no `sorry`, `native_decide` or `axiom` declaration text; `LEAN-JOB-HOLDER.txt` is absent and no `lean` process runs. NOT re-run by Lead 12: any build, kernel
check or test. Mythos verifies with his own rebuild, the twin test and his second-seat tests, and gives the CORRECT first line.

SKELETON 2: v0.8 faithful copy yes; field carried proved yes; statements restated 11; old text re-proved on reachable states 11 of 11; forced replay blocked for Lawful2 yes; behaviour unchanged (twin test) yes; laws now 44

(Lead 12's note on that line: "forced replay blocked for Lawful2" is the coder's wording from the job file; per Mythos's correction K1 the root is still
`Aukora.RootFinal.Lawful`, there is NO second structure. The coder says it never made one and `laws.env.tsv` has no `Old.` name (REPORTED, grep count 0).)

## K1 (Mythos's correction)
Nothing done conflicts with K1. A first draft put the restated laws under new names; it was dropped before anything reached `v0.8`. Each statement is restated in place at its
own layer; the old texts are kept as `Old.*` definitions.

## Step 1, faithful copy
`logs/sk2/fork8.py` copies `v0.7` to `v0.8` with `fork-release.py`'s own functions, no second build hook; 125 replacements. `SOURCE.sha256` follows v0.7's list of 147
paths, renamed, digests recomputed. REPORTED: `build.sh s1-build` PASS v0.8, peak 1,393 MiB; both Wasm digests equal v0.7's (`69e711f1...982178`, `1991baed...c119`).

## Step 2, the field is carried
New `v0.8/Proofs/PolicyCarried.lean`, kernel-checked (REPORTED): `policy_carried` (frame, feed, reset, stamp), `policy_carried_run`, `policy_carried_walk` (also seals and
continuations), `ordinary_blank`, `bound_blank` (+ `_walk`): every reachable state has `policy = {}`. Axioms propext, Classical.choice, Quot.sound only. `execute_head` in
`Proofs/RecordBinding.lean` is now public, statement unchanged (Mythos's F1). `PROVED.md` left for the second seat to word. PASS v0.8, no pin moved (110 of 110) at that point.

## Step 3, the table of forms and the restated promises
New `v0.8/Forms.lean`: `FormId`, 31 forms, fixed codes 1 to 31 (1-26 frame forms picked by the first byte and where needed the action byte at offset 41 (tag 00), offset 3350
(tag 13) or byte 43 (ff 02 29); 27-31 channels: stamp, feed, reset, seal, continuation). `formOf` reads wire bytes only; `Refused`, `RefusedIn` decidable. Kernel-checked
(REPORTED): `table` (no axioms), `all_complete`, `code_injective`, `enabled_default`, `formOf_approval`, `formOf_legacyKeyChange`. `Policy.enabled` defaults to the 31 codes
written out: an EMPTY LIST MEANS NO FORM (Mythos's decision A7: an empty list must never mean "everything allowed"). The `limits` comment says nothing may read it before limits
are designed. `Root12.Open` (`Laws.lean`) is the single escape: halted is false, owner rules permit, the input is not refused.

| Layer | Statement | How |
|---|---|---|
| Root12 (`Laws.lean`) | `SupportsWhen` (legacy Supports) | via `Open` |
| Root12 | `Replay.feedWhen` | via `Open` |
| Root12 | `Replay.resetWhen` | via `Open` (not in the job's list) |
| RootFinal (`FinalPorts.lean`) | `PublicPorts.feed`, `PublicPorts.reset` | via `Open` (not in the job's list) |
| RootFinal (`InstalledControls.lean`) | installed `Supports` (both conjuncts, five kinds) | via `Open` |
| RootFinal (`InstalledControls.lean`) | `StampSupports` | via `Open` |
| RootFinal | `PriorVerdicts`, `VersionVerdicts` (both conjuncts), `Speech` (both conjuncts), `Historical.E6` | one added `not Forms.Refused` hypothesis each |

`h5` and `Root12.E5` are untouched. Old texts kept as `Old.Open`, `Old.PriorVerdicts`, `Old.VersionVerdicts`, `Old.Speech`, `Old.E6` (used only by `BindingConflict`, the two
growth-edge theorems, the E5/E6 bridges and step 4). Two fields appended: `r_mono` (`RMono`), `id_fixed` (`IdFixed`): 44 fields. Kernel-checked: `full_lawful : Lawful fullModel` with
44 fields (propext, Classical.choice, Quot.sound). The machine is unchanged; no step reads `refused`, `enabled` or `limits`. Edits outside the Lean files: `RatchetChecker.rootNames` +2
names; `tools/build.py` package count 42 to 44; `tools/check.py` gains `Proofs.OldText`; ONE test edit: `tests/gate-final.mjs` line 11 appends `'r_mono','id_fixed'` (the test keeps its
own copy of the field names).

## Step 4, the old text on reachable states
New `v0.8/Proofs/OldText.lean` (REPORTED kernel-checked, propext, Classical.choice, Quot.sound): `old_of_lawful` (the NEW `Lawful m` gives back the old text wherever the refused
register is empty), `Reach` (reachable from the ordinary or a bound start by any history of inputs, seals and continuations), `reach_blank`, `old_lawful_reachable`, and
`old_replay`, `old_threshold`, `old_bundle`, `old_stamping`, `old_revoke`, `old_expiry`, `old_correction`, `old_e5`, `old_e6`, `old_w1`.
`BindingConflict.forced` no longer goes through (it needs `Old.PriorVerdicts`, which the root no longer contains). CHECKED by the coder: `forced_blocked`: on any state where a
frame's form is refused, a model satisfying the restated `PriorVerdicts` refuses that frame; `approval_not_forced` (tag 13) and `key_change_not_forced` (tag 14) follow.
**NOT proved:** a model satisfying all 44 laws that refuses a refused approval. Only the `PriorVerdicts` clause is shown not to force admission.

## Step 5, nothing moved
Build t1 stopped at the pin check as expected; new law identity `4815cb2e...`; genesis check PASS. The three law-bound vectors (`segments`, `record-binding`, `record-rebinding`) were
regenerated with each test's own `--write` (old copies in `logs/sk2/v08-step3-old-vectors/`). Every node test passes (`logs/sk2/tests-t1.log`, `TESTS rc=0`). Twin test v0.7 against v0.8
(REPORTED): 3,913 identical, 0 different, 0 traps, full and lite. `mythos-binding` 53/53 and `mythos-bound-edges` 30/30 on both files. The three second-seat tests are copied unchanged into
`v0.8/tests/second-seat/` with a one-line README. `PINS.sha256` 110 to 114 entries (96 of the old 110 changed); `SOURCE.sha256` regenerated last, 147 to 154. Final build t2 (LEAD READ the log
line): PASS v0.8 in 905.7 s; the coder says peak 1,093 MiB, 114 pins OK, SOURCE OK, v0.7's pins still OK.

New pins (REPORTED; the two Wasm digests' first 8 hex and sizes LEAD RAN above): `aukora-core.wasm` 7,554,007 bytes `d0d3bfe5f9111419ff4fc98dfc3dc894252d106efe630e0dfce5a2ba4bddf84b`;
`aukora-core-lite.wasm` 679,046 bytes `2f10eb8fd9adb3f25d854b642bba29ceaadcbcb2cc40a2fb05fca51f770b59e9`; judge pin (normalized executable) old `d998509e...8610` to new `1c24a647...0f23`
(full: `d998509e2cee6620be9dd71720df66151044cffb3f85f67e691d89e82d318610` to `1c24a6476ed38877ff9c949edf919ed14e1bff2a95129313c9c4e3da0bf80f23`); pinned declarations 4,245 (was 4,183).

## O2: can v0.6's judge accept v0.7 as a successor?
No (REPORTED, `logs/sk2/o2-successor.mjs`, output `logs/sk2/o2.txt`): the v0.6 core refuses v0.7's `same` package with install reason 11 (the staged-file judge comparison) before any
proof is checked; the control (v0.6's own package) is accepted with reason 0. (Lead 12 saw the log lines `candidate package (v0.7 same) witnessMask 256 installReason 11` and
`control: outgoing own package (same) grant`; the log's own ACCEPT/REFUSE word is for Mythos to read.)

## Peak memory
Largest Lean job 1,393 MiB (the step 1 build); none above 1,400 MiB (REPORTED).

## Where the coder went beyond the job file (all four to be read by the second seat)
1. `resetWhen`, `PublicPorts.feed`, `PublicPorts.reset` and the non-root `Root12.Lawful` stamping clause are restated too, because the escape lives in `Root12.Open` (K4).
2. The one-line edit to `tests/gate-final.mjs`.
3. Seal, continuation, stamp, feed and reset get forms through their input channel, not through frame bytes.
4. The `SOURCE.sha256` list follows v0.7's list; four existing files stay unlisted as in v0.7: `ENVIRONMENT-SPLIT.tsv`, `round12.json` and two vector files.
Also: the private equation lemmas for a large `UInt8` literal match could not be generated, so `formOf` reads bytes as numbers.

## NOT done
Nothing reads `refused`, `enabled` or `limits`. `PROVED.md` and `NOT-PROVED.md` lines are not written (second seat). Nothing run on another machine. Nothing published or pushed.
The coder's seat holds no lock; no Lean process runs.
