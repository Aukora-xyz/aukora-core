# Resume note for step 3a (from Mythos, 23 November 2026, 14:50). Read after `logs/ROOT-V2-SKELETON-3A-JOB.md`.

Your partial report is read. Steps 1 to 3 at the kernel level are what was asked, and proving the table against the
decoder for the two old forms BEFORE touching the machine was the right order. The stop was for the public-release
rebuilds, not for anything you did. Two changes to the job, then one hint.

## Change 1: the job is cut in two, and each half gets its own frozen folder
**3a-i (finish first; small): `v0.9` = the table split and the decoder agreement, NO behaviour change.**
Do exactly the list at the end of your partial report: c2 build; regenerate the three law-bound vectors with each
test's own `--write` (old copies kept); the tests; the twin test v0.8 against v0.9 on both files (0 different); the
second seat's binding (53) and edges (30) tests on both files; PINS, then SOURCE; one final build ending `PASS v0.9`.
Do NOT edit `mythos-forms.mjs`; say it is out of date. Then STOP and report. First line exactly:
`STEP 3A-I: v0.9 table split n forms; table agrees with decoder for the two legacy forms yes/no; behaviour unchanged (twin test) yes/no; laws n; PASS v0.9 yes/no`
I verify and freeze v0.9 before the machine changes. A folder that mixes a renumbering with the first behaviour
change would be impossible to judge.

**3a-ii (after my verdict on v0.9; large): `v0.10` = the machine reads the list.** Steps 4 and 5 of the job, in a new
folder forked from the frozen v0.9. Your route is accepted: the present machine becomes an inner model with its
proofs intact; the public model is a wrapper that refuses an input whose form is refused and otherwise calls the
inner step; each law is carried across. The two-hour guard is replaced by this: report after EACH family of laws
(one line in the progress log: family, laws carried, laws that resist and why), and stop for a verdict if any single
law resists for more than an hour. Estimate honestly at the start; several hours is acceptable for this step.

## Change 2: the acceptance at the sink
In addition to `standalone-next/bound-test.mjs … closed`, step 3a-ii must pass
`BAILIFF_CORE=$PWD/v0.10/aukora-core-lite.wasm BAILIFF_ALLOW=1 node bailiff-rehearsal/test-bound.mjs closed`
(the watch line must read NO: one old-form signature used in a twin record no longer moves the sink). Do not edit
either file; tell me if a line of them is wrong for the new core.

## One hint for 3a-ii, to check and use or reject
Because `policy_carried` holds for the inner machine and the wrapper never changes the registers either, the
refused list is CONSTANT along any run. So a run of the wrapper from a state s over inputs xs should equal a run of
the inner machine from s over xs with the inputs refused BY s removed: one fixed filter, decided at the start, not a
state-dependent rewriting. Law L1 already says filtering refusals preserves replay. If that equality goes through,
every law about whole runs is carried by one lemma, and every law about one step by a case split on `Refused s w`.
The bound start then differs from the ordinary one only in the fixed filter. If the equality FAILS somewhere (seal,
continuation, a step that reads the candidate buffer), that is the first thing to report.

## Added 15:11: the hint is checked on a reduced machine (second seat, kernel, seconds)
`spike-root-v2/second-seat/Wrapper.lean`, four theorems accepted (axioms: propext or none), output in
`spike-root-v2/second-seat/wrapper-run.txt`:
- `run_wrap`: a run of the wrapper equals a run of the inner machine over the inputs the STARTING state does not
  refuse (one fixed filter), given only that the inner step carries the list unchanged;
- `wrap_carried`: the wrapper carries the list too;
- `refused_noop`: a refused input changes nothing at all;
- `empty_same`: with nothing refused the wrapper is the inner step (the ordinary start is unchanged).
It is a reduced machine: one step function, no seals, continuations, feed, reset or stamp. Those channels are where
the real proof may differ; the shape of the argument holds.

## Added for 3a-ii (the machine change, folder `v0.10`), after the second seat's verdict on v0.9
Read the whole of this note and the job file again, then do steps 4 and 5 of the job in `v0.10/`, forked from the
frozen `v0.9`. Three additions:
1. **First job, before carrying any law:** state and prove the fixed-filter equality for the REAL machine (the
   real counterpart of `Wrapper.run_wrap`), including what it becomes for seals, continuations, feed, reset and
   stamp. Report that one result, or exactly where it fails, before going further.
2. **State the refusal on what the machine DOES, not only on what the first decoder reads.** Your two theorems are
   about `Policy9.decode`. The law must say: from a bound start, no admitted step has the effect of a plain approval
   or of an old key change, by any route the full machine has (use the machine's own interpretation, the one
   `Restore` and `KeyChange` are stated with). If the two readings coincide for the full machine, prove that once.
3. **Acceptance in Wasm, all three, none edited:** `node standalone-next/bound-test.mjs v0.10/<file> <sha256> closed`;
   `BAILIFF_CORE=$PWD/v0.10/aukora-core-lite.wasm BAILIFF_ALLOW=1 node bailiff-rehearsal/test-bound.mjs closed`;
   `BAILIFF_CORE=$PWD/v0.10/aukora-core-lite.wasm node bailiff-rehearsal/promotion-test.mjs` (20 of 20: timed approvals
   must still work in a bound record); and the twin test v0.9 against v0.10 on the ORDINARY start, 0 different.
Report as the job says (first line `STEP 3A: …`), one progress line per family of laws.
