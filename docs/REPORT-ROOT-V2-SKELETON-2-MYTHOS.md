# Second seat on ROOT V2 SKELETON 2 (v0.8). Mythos, 23 November 2026, 13:38 Mac clock

CORRECT first line (use this one, not the coder's):
`SKELETON 2: v0.8 faithful copy yes (REPORTED: the coder's step-1 build log); field carried proved yes; statements restated 11, in 10 fields of ONE structure; old text re-proved on reachable states 11 of 11; forced-replay theorem blocked for the restated PriorVerdicts clause yes; shown that the whole set of 44 permits refusing a refused approval NO; behaviour unchanged (twin test) yes; laws now 44`

Verdict: ACCEPT. `v0.8` is frozen with `v0.1` to `v0.7`. There is no `Lawful2`: the root is still
`Aukora.RootFinal.Lawful`, restated in place, with `r_mono` and `id_fixed` appended (my wording in the job was wrong,
corrected in note K1; the coder followed the note).

## RAN (by me, on this Mac)
- **Rebuild from source:** `PASS v0.8 (1062.3 seconds …)`, exit 0, whole-build peak 1,173 MiB, slot 13:17 to 13:35 (slower
  than the coder's 906 s because one of my own tests ran beside it). Both Wasm files byte-identical to the delivered
  ones: `d0d3bfe5f9111419ff4fc98dfc3dc894252d106efe630e0dfce5a2ba4bddf84b` and
  `2f10eb8fd9adb3f25d854b642bba29ceaadcbcb2cc40a2fb05fca51f770b59e9`. Pins (114) and source list (154): 0 mismatches before
  and after my build. `v0.7` pins and source list: 0 mismatches (nothing frozen moved). Law identity `4815cb2e…6acddc`
  (genesis check: real core accepted, one changed byte refused).
- **Same machine as v0.7:** `mythos-twin-cores.mjs v0.7 v0.8`, 3,913 inputs, 0 different, 0 traps, full and small core.
  Control with one damaged frame: reported.
- **Record binding:** 53/53 and 30/30 on both files. **Adapter for the next line:** 46/46 on both files, and its watch line
  still says the core admits one old-form signature in two bound records (blocker 12 OPEN, as expected: no step reads
  the refused list yet).
- **The three copies of my tests in `v0.8/tests/second-seat/`** are byte-identical to mine.
- **The table of forms against real frames (new, `logs/repro12/mythos-forms.mjs`):** `formOf` exists only in Lean, so I
  ported its 30 lines by hand. 14 frames the core admits (13 of the 31 forms: say, advise, plain approval, act, outcome,
  correction, timed approval, cancel, threshold, halt, clear, newer key change, old key change) are each filed under the
  form their builder meant. 18,615 changed selector bytes: none still admitted.

## READ (source, every changed statement)
- `Open` gained one conjunct (`¬ RefusedIn`); `PriorVerdicts`, both halves of `VersionVerdicts`, both halves of `Speech`,
  and `E6` gained one hypothesis (`¬ Refused`). Nothing else in any statement changed. `h5` and `Root12.E5` untouched.
- The old texts live on as `Old.*` definitions and are in NO pinned declaration (`ENVIRONMENT-SPLIT.tsv`: 0 names with
  `Old.`). The lesson theorems about the old root (`verdict_edge`, `legacy_verdict_edge`, the E5 and E6 bridges,
  `BindingConflict.forced`) now take the `Old.*` hypotheses, which is right: they are facts about the 42, not laws.
- `old_of_lawful` is stronger than asked: ANY model that satisfies the 44 gives back the old text wherever the refused
  list is empty, not only this machine. `reach_blank` covers the ordinary start, the bound start, seals and
  continuations.
- The one test edit (`tests/gate-final.mjs`, two names appended to the test's own list of fields) is the same kind of
  edit rounds D2 and A made. Not a weakening.

## NOT checked, and what skeleton 2 leaves open
1. **Whether the 44 as a whole permit refusing.** `forced_blocked` shows only that the restated `PriorVerdicts` no longer
   forces admission (by a model that refuses, which satisfies that ONE clause). No model is shown to satisfy all 44 and
   refuse. `h5` and `restore` are untouched and may still force the old key change (tag 14 hex). Closing this is the
   point of the next step: the real machine becomes the witness.
2. **The table against the decoder.** Nothing proves that every frame the machine admits is filed under the form whose
   effect it has. My test is 14 real frames of 13 forms; signed variants with a changed selector were not built. If
   the table and the decoder ever disagree, a refused form could be entered under another name. A law for step 3.
3. **Granularity is about to be frozen.** `speech` is say + remember + correct + advise in one form; `signedControl` is
   retract + mandate + budget + pass + revoke in one form. Refusing a standing permission would also refuse the
   owner's own retract and revoke. The numbers are "fixed for ever" only from the first released root; split them now.
4. **What may never be refused.** `Open` now lets the staging feed and reset, the stamp, and (in the table) the seal
   and continuation be refused. Harmless while nothing writes the list. Before anything can write it: halt, clear,
   the newer key change, seal and continuation must be unrefusable, and one approval form must always remain.
5. Step 1 ("faithful copy") is from the coder's build log, not from a build of mine. The O2 run (v0.6's judge refuses
   the v0.7 package with reason 11, control accepted) is the coder's, REPORTED.
6. One Mac. Blocker 2 stands. Nothing is wired into Auma.
