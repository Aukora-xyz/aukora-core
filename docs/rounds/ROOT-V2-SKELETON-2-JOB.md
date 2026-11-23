# Job for the Claude coder (from Mythos, 23 November 2026): root v2, skeleton step 2. Behaviour must not change.

Skeleton 1 (`v0.7`) is ACCEPTED by the second seat: rebuilt here, source diff read (21 added lines, 4 changed,
the one proof replaced), 53 + 30 checks on both files, and a new side-by-side test, `logs/repro12/mythos-twin-cores.mjs`,
which feeds the SAME bytes to two cores from the same ordinary start and compares verdict, head, installed core,
halt flag and ceiling after every input: v0.6 against v0.7, 3,913 comparisons, 0 different, on both files.
`v0.7/` is now FROZEN with `v0.1/` to `v0.6/`. Do not change a byte in it.

Two things skeleton 1 leaves open. Both are in this job.
O1. **Nothing proves the new field is carried.** Every place that rebuilds a state uses `{s with …}` today, so it
    is carried, by inspection. One future `{ base := … }` without `with` would silently reset the owner's
    restrictions to empty, and no test could see it (no export reads the field). It must be a theorem.
O2. **The schema change is already a new root.** `ReleaseInterface.lean` says all candidates share the public
    state schema. Say in the report, from the source or by one run, whether v0.6's own judge can accept v0.7 as
    a successor, and with which refusal if not. Expected: no. Nobody may assume a v0.6 record upgrades in place.
O3. **"Empty means everything" must not survive.** Skeleton 1 documents `enabled := []` as "today's forms" and
    `limits := []` as "today's limits". That encoding is a trap: anything that empties the list would switch
    every form on. DECISION (amendment A7, binds from now on): a register says what it means in full. Once the
    form table exists (step 3) the default of `enabled` is the full list of today's forms, written out, and an
    empty `enabled` means no form. `limits` keeps its empty default only until limits are designed, and the
    comment must say that no step may read it before then.

Every rule of `BRIEF-R12C-D.md` binds (lock per job and never held idle, 4 GB cap, no `sorry`, no `native_decide`
in a law proof, no new axiom, never weaken a test, a vector or a limit). This job DOES change four or more law
statements, on purpose and only as written below. That is the one licensed exception to "never weaken a law":
each changed statement must have its old text proved again as a theorem on reachable states (step 4).

## Steps, in this order, each with its own report line. Then stop.

**Step 1: the new folder, proved faithful.** `v0.8/` from `v0.7/` with `fork-release.py`, as before.
ACCEPTANCE: `PASS v0.8`; both Wasm digests equal v0.7's (`69e711f1…982178`, `1991baed…c119`).

**Step 2: the field is carried (O1).** In a new proof file:
- `policy_carried : ∀ ctx s c, (execute fullModel ctx s c).policy = s.policy` (all four inputs: frame, feed,
  reset, stamp), and the same for a run;
- `ordinary_blank` and `bound_blank`: every state reachable from the ordinary start, and from `Bound12c.genesis`,
  has `policy = {}`;
- make `execute_head` (now private in `Proofs/RecordBinding.lean`) a public named theorem, statement unchanged
  (review finding F1; it gets a line in `PROVED.md`, which the second seat will word).
No statement of the 42 changes in this step. Report whether any pin moved.

**Step 3: forms and the restated promises.** One new file holds the form table:
- `FormId` numbers for the forms the machine implements TODAY, in one closed list, each number fixed for ever
  (legacy approval tag 13, legacy key change tag 14, timed approval, cancel, threshold, signed control, report,
  assessment, speech, the ff 02 halt, clear and key change, the seal; you know the full list better than I do:
  name every one, and say which wire bytes select it);
- `formOf : ByteArray → Option FormId`, a function of the WIRE BYTES ONLY. It must not read the state: what a
  restriction means may never shift under the record. A kernel-checked table theorem pins the numbering;
- `Refused s w : Prop` := the frame's form is in `s.policy.refused`; decidable.
- `Policy.enabled` now defaults to the full table (O3), and `ordinary_blank` / `bound_blank` of step 2 are restated
  for that default. Nothing reads `enabled` yet.
Then restate, each by adding the single hypothesis `¬ Refused s w` and nothing else:
`PriorVerdicts`, `VersionVerdicts`, `Speech` / `E5`, `Supports` (all five kinds, both the legacy and the installed
definition), `StampSupports`, `replay.feedWhen`, `e6`. Where a law already goes through `Root12.Open`, fold the
new hypothesis into ONE definition so there is one escape and not two; say which you did. `h5` is NOT touched
in this job (it is step 3 of the skeleton, with its guard, and it must never become "unless refused").
Add two laws in their final form, both true today by step 2:
- `r_mono`: no input removes anything from `refused` (`s.policy.refused ⊆ (execute m ctx s c).policy.refused`);
- `id_fixed`: no input changes `policy.id`.
The lawset is now `Lawful2` (44 fields, or say the number). The machine is not changed: no step reads `refused`.

**Step 4: the old promises still hold where records live.** For EVERY statement changed in step 3, a theorem
that the OLD text, word for word, holds on every state reachable from the ordinary start and on every state
reachable from the bound start (use step 2). Name them `old_<field>`. Then one theorem, `old_lawful_reachable`,
that collects them. Also state plainly, as a theorem or a two-line argument, whether `BindingConflict.forced`
still goes through for `Lawful2` on a state with tag 13 in `refused`: it must NOT (that is the point of the
restatement). If it still does, stop and report: the restatement is not doing its work.

**Step 5: nothing moved.** `PASS v0.8`. Vectors: only the law-identity regeneration, old copies kept in `logs/`.
- every existing test passes with no test edited;
- `node logs/repro12/mythos-twin-cores.mjs v0.7/<file> v0.8/<file>` for both files: 0 different, 0 traps;
- `mythos-binding.mjs` (53) and `mythos-bound-edges.mjs` (30) pass on both new files. Do not edit the three
  second-seat tests; copy them unchanged into `v0.8/tests/second-seat/` with a one-line README saying they
  import the v0.6 test library by absolute path and are run from the lab.

## Not this job (do not start them)
The usable-form `h5` and its guard over clear, key change, seal and approval (C2); the bound start refusing BOTH
legacy forms (C1); any step that READS or WRITES `refused` or `enabled`; the seal carrying the registers (a seal
must commit to `policy` before any record can start from one: noted for the blocker-13 design); the judge as a
separate file.

## Report
Give the text to the lead for `REPORT-ROOT-V2-SKELETON-2.md`. First line exactly:
`SKELETON 2: v0.8 faithful copy yes/no; field carried proved yes/no; statements restated n; old text re-proved on reachable states n of n; forced replay blocked for Lawful2 yes/no; behaviour unchanged (twin test) yes/no; laws now n`
Then CHECKED, RAN, NOT done, the new pins, the answer to O2, the peak of the largest job, and what surprised you.
If step 3 or 4 resists for more than about two hours of work, stop and report where: a restated law that cannot
give back its old text on reachable states is a finding, not a failure.
