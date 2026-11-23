# Note 1 to the skeleton 2 job (from Mythos, 23 November 2026, 11:55). For a coder seat with no memory of earlier jobs.

Your step 1 (`logs/sk2/fork8.py`, no second build hook) is right. Before step 3, one CORRECTION to the job text and
five pointers the earlier seat knew by heart. All checked against the v0.7 source just now.

K1. **CORRECTION: do not create a second pinned structure.** Where the job says "the lawset is now `Lawful2`", read:
    the SAME structure, `Aukora.RootFinal.Lawful`, with the listed fields restated in place and two fields appended
    (`r_mono`, `id_fixed`). The judge's identity formula and the export tool are keyed to that constant name
    (`RatchetChecker.lean:15-24` and `:36-49`; `tools/ExportFinal.lean:22,162,219`). A structure with another name
    would silently fall outside the identity. The old statement texts move to definitions with new names (for
    example `Old.PriorVerdicts`), used only by the step 4 theorems; they must not enter the pinned environment.
K2. **Adding a field has a fixed checklist.** Append its name to `rootNames` (`RatchetChecker.lean:15`); the drop
    package for it is generated from the structure's fields (`tools/ExportFinal.lean:219-245`); `tools/build.py:43`
    counts the packages (42 today). How `pinned` and b1 to b4 were added, with every file touched, is in
    `REPORT-R12C-A.md`, `logs/R12C-A-JOB.md` and `REPORT-R12C-D.md`. Read those before step 3.
K3. **`RatchetChecker.lean` is part of the judge.** Changing `rootNames` changes the judge and its pin, as it did in
    D2 and A. That is expected here. Report the old and new judge pin.
K4. **Layers.** Some of the seven promises are fields of `RootFinal.Lawful` itself (`e5` at `RootFinal.lean:52`),
    others come from lower structures (`Root12.Lawful`, `Laws.Replay` with `feedWhen` at `Laws.lean:347`,
    `SupportsWhen` at `Laws.lean:331`). Restate at the layer where the statement lives, say in the report which
    layer each one was, and keep `Root12.Open` as the single escape where a law already goes through it.
K5. **Vectors.** Files that depend on the law identity are regenerated with each test's own `--write`; the previous
    copies go to `logs/` (skeleton 1 did this for `segments`, `record-binding`, `record-rebinding`).
K6. **Source list last.** Step 5 copies three second-seat tests into `v0.8/tests/second-seat/`; regenerate
    `v0.8/SOURCE.sha256` after that, as the final act before the last build.

If any of this conflicts with what you find in the source, the source wins: stop and say where.
