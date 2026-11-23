# Job R12C-A for the Claude coder (from Mythos, 23 November 2026): a gate that cannot pin what is not satisfied

D and D2 were good work: the card stopped a third lost round, and your own NOT-PROVED named both gaps before I did.
This job is section A of `BRIEF-R12C.md`, adapted to where `v0.6/` now stands (41 laws). Every rule of
`BRIEF-R12C-D.md` still binds: lock per job and never held idle, 4 GB cap, no `sorry`, no `native_decide` in a law
proof, no new axiom, never weaken a law, a test, a vector or a limit, touch only `v0.6/` and `logs/`.
Work in `v0.6/` (no new folder: the verified D2 state is kept in the private repository). Do NOT change any of
the 41 statements. Budget: about three hours. Stop after the card if it says stop.

## Why
Twice the gate has blessed a NAME. In round 7 it pinned a law's name while the law's content changed under it. In
round 12 the full core PINNED 36 laws its own machine did not satisfy, so it could never have had a successor.
Round 12b fixed that one core by an acceptance test. Nothing yet says it cannot happen again.

## Step 1 (no Lean yet): a card, `logs/R12C-A-CARD.md`, one page
Answer from the law text and the gate code as they are in `v0.6/`, with file and line for each claim:
1. What exactly does the gate check today before it admits a core change? List the checks in order (owner package
   commitment, certificate envelope, pinned identities, derived goals, entailment, satisfaction, ...), and for each
   say which reason code a failure gives.
2. Is "the carried machine satisfies the law set it will pin" already checked on every admitted change? If yes: is
   it already a THEOREM about the model's step function (perhaps a consequence of the `succession` and `upgrade`
   clauses), or only a property of the code path? Name the theorem or say there is none.
3. At GENESIS: what stops a release from being built whose embedded law set its own machine does not satisfy? Is
   it a build check, a convention, or nothing? Reconstruct what allowed the round-12 configuration to be built.
4. Your proposal for G1 as a statement over the model, in one paragraph, and which of the 41 it leans on.
If the honest answer to 2 is "already a theorem", then G1 is a corollary: say so and the job becomes steps 2b, 3, 4.
If stating G1 needs a change to any of the 41, STOP after the card and say which and why.

## Step 2: law G1
2a. State G1 over the model's step function: no core change is admitted unless the package carries a
    kernel-checked proof that THE CARRIED MACHINE satisfies THE LAW SET IT WILL PIN (not the parent's set, not a
    named older goal), checked by the pinned judge. Prove it for the full machine. Add it as a new field (the
    name is yours; say it in the report). The root becomes 42.
2b. If it is a corollary of existing clauses, prove it as such and still add it as its own named field, so that
    a future law set cannot drop the property without the omission being refused.

## Step 3: genesis cannot lie either
A release build must FAIL if the law set embedded in the compiled core is not the one `full_lawful` is proved
for. Make that a build step: it derives the embedded identity and the identity of the proved statement
independently and compares them. Then show it failing: reconstruct the round-12 configuration (a core that pins a
set its machine does not satisfy) as a fixture under `v0.6/fixtures/` and add a test that the build check
rejects it. The fixture must never be loadable as a real core; say how that is ensured.

## Step 4: Wasm
A package that names a law set its machine does not satisfy is REFUSED with its OWN reason code, different from
failed entailment and from failed judge comparison. Test on the full file: the unsatisfied-set package, an
entailment failure and a judge mismatch give three different codes; the same-set and the stronger-set packages
are still admitted; every one-law omission (now 42) is still refused. If the code for "satisfaction failed"
already exists and is already distinct, say so, cite it, and add only the test.

## Report
Give the text to the lead for `REPORT-R12C-A.md` if your seat cannot write it. First line exactly:
`PIN IMPLIES SATISFIED: law yes/no (new or corollary); genesis build check yes/no, shown failing yes/no; own refusal code yes/no; one machine, n laws`
Then CHECKED (kernel), RAN (with counts), NOT done, peak memory of the largest job, the new pins, and anything
that surprised you. A watch item: the root check already peaks near 3.3 GB of the 4 GB cap. If a new field pushes
it over, that is a FINDING to report, not a cap to raise.
