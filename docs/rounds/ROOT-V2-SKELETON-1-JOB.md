# Job for the Claude coder (from Mythos, 23 November 2026): root v2, skeleton step 1. Behaviour must not change.

The spike is ACCEPTED: the design stands. I re-checked `spike-root-v2/Spike.lean` with the kernel myself (exit 0,
2.2 s, 284 MB) and added two theorems of my own (`spike-root-v2/second-seat/Attack.lean`, both accepted). They show
two things the spike leaves open. Both are DESIGN DECISIONS for later jobs, not work for this one:
C1. `old_key_change_travels`: in the spike's bound start the old key change is still open, and it signs neither the
    identifier nor the head, so one frame is admitted by two bound records with different identifiers. DECISION:
    a bound start refuses BOTH legacy forms (plain approval and legacy key change), and every form left open in
    a bound record signs the identifier and the head. The spike's possession key change signs neither; the real
    one must.
C2. `approvals_can_be_refused_for_ever`: with the strong guard the owner can still end with no approval form at
    all, permanently, while the state counts as usable. DECISION: the guard protects the last open form of each
    ESSENTIAL kind: clear, key change, seal, and approval. A record that should stop taking approvals is sealed;
    it is not frozen through the restriction list.

## This job: three steps, in this order, each with its own report line. Then stop.
Every rule of `BRIEF-R12C-D.md` binds (lock per job and never held idle, 4 GB cap, no `sorry`, no `native_decide`
in a law proof, no new axiom, never weaken a law, a test, a vector or a limit). `v0.1/` to `v0.6/` are frozen:
do not change a byte in them.

**Step 1: the new folder, proved faithful.** Make `v0.7/` as a copy of `v0.6/` without `.work`, with the folder
name replaced in exactly the file classes `fork-release.py` rewrites (`build.sh`, `tools/`, and `tests/*.lean`,
`tests/*.mjs`), and `PINS.sha256` and `SOURCE.sha256` rewritten for the new paths (source list AFTER the pin
list). Change nothing else. Then `sh v0.7/build.sh`. ACCEPTANCE: `PASS v0.7`, and both Wasm files have the same
SHA-256 as v0.6's (`cce58d54673b5413c1401b241df8c79be091bac74cc71acd45cb7721b23a71ae` and
`3bdb8e631b3911ecfda9d28bf785b31611bb5c43bd821345a15644ce528df1f4`). If they differ, STOP: the copy is not faithful.

**Step 2: the memory fix.** In `v0.7/Proofs/Evidence11.lean` replace the proof of `weaker_class_can_fail` by
`decide +kernel` and remove the two `set_option` lines above it if it no longer needs them. Rebuild. Report the
peak of every Lean job above 1,500 MiB, before and after (the per-file peaks file you kept in part A is the
"before"). The pinned environment changes, so the Wasm digests and the law-identity vectors change: regenerate
those vectors with each test's own `--write`, as before, and keep the old copies in `logs/`. ACCEPTANCE: `PASS
v0.7`; no statement of any of the 42 changed; the largest Lean job is below 2,000 MiB, or you name the next
heaviest declaration with its file and line.

**Step 3: the state field, with nothing in it.** Add ONE field to the state, as in your card's section 6
(`policy : Policy := {}` with `id`, `refused`, `enabled`, `limits`, `judge`), with the default equal to today's
behaviour. No register is READ by any step yet. Repair the proofs that build states by anonymous constructor.
ACCEPTANCE, all of it:
- `PASS v0.7`; `full_lawful` with the same 42 fields; the text of every one of the 42 statements unchanged
  (show the diff of the statement files against v0.6: proofs may change, statements may not);
- every existing test passes with NO change to any test or vector other than the law-identity regeneration;
- `logs/repro12/mythos-binding.mjs` and `mythos-bound-edges.mjs` pass on both new files (they are the second
  seat's; do not edit them);
- report how many proof lines the schema change touched and where (this was the card's first risk).
If the schema change will not go through within about two hours of work, stop and report where it resists.

## Report
Give the text to the lead for `REPORT-ROOT-V2-SKELETON-1.md`. First line exactly:
`SKELETON 1: v0.7 faithful copy yes/no; memory fix peak before/after n/n MiB; policy field added with no change of behaviour yes/no; 42 statements unchanged yes/no; proof lines touched n`
Then CHECKED, RAN, NOT done, the new pins, and what surprised you.
