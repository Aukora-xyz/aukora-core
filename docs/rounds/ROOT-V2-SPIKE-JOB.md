# Job for the Claude coder (from Mythos, 23 November 2026): the root v2 spike. Small. Then stop.

Your card (`logs/ROOT-V2-CARD.md`) is ACCEPTED as the design basis. It found more than was asked: `h5` pinning the
old key-change forms (which would have blocked the possession-proving key change), `e5` fixing the speech verdict
on every state, the five promises that escape only through `Open`, the closed kinds, and that the 3.3 GB peak is
not the root. Six amendments from Mythos, then the job.

## Amendments to the card (they bind the spike and everything after it)
A1. **Old mode stays in the MODEL, not in the release.** Keep the ordinary start and the reference clause so the
    whole corpus still replays. But the compiled release of root v2 exposes only the bound start; the ordinary
    start is reachable in test builds only. Nobody should be able to start an unbound record with a released core.
A2. **A form is code.** `F` is the ENABLED subset of the forms the installed machine implements. An owner frame can
    enable a form the machine already implements; a new form arrives with a new machine, never as data.
A3. **`R` is one-way, so it must never hold a permission that may later be granted.** Whether the machine may
    change under a fixed judge is a parameter fixed at genesis, not a restriction in `R`.
A4. **No big bang.** After the spike, the first build is a SKELETON: the schema field, `R`, `F`, and every A and
    V clause restated, with NO change of behaviour (`R` empty, `F` equal to today's forms at the ordinary start).
    Its acceptance is that every existing vector and test passes unchanged and each of the 42 old statements
    follows from its restated form on states reachable from the ordinary start. Features come after, one small
    job each: bound start refuses tags 13 and 14; the possession-proving key change; start from a seal and the
    clean memory refusal; the judge as a separate file.
A5. **Memory step 0 is one theorem, not a file split.** `Proofs/Evidence11.lean:331` `weaker_class_can_fail` is a
    counterexample proved by plain `decide` under 1,500,000 heartbeats. That single elaboration is the 3.3 GB.
A6. **The restated no-lockout clause is the heart of it.** The spike must try to break it, not only state it.

## The job
Work in a NEW folder `spike-root-v2/` in the lab (not a release folder; nothing in `v0.1/` to `v0.6/` changes,
except the measurement in step 0, which you revert). Core Lean only, no imports from the release: the reduced
machine is self-contained, so each check is seconds and a few hundred MiB. Lock per job as always.

**Step 0 (measurement, 15 minutes).** In a scratch copy of `Proofs/Evidence11.lean` under `spike-root-v2/`,
replace the proof of `weaker_class_can_fail` by `decide +kernel` (no axiom is added by that; say what
`#print axioms` reports). If it is accepted, record the peak for checking that file against the built imports.
If it is refused, try stating the two halves as two theorems, or evaluating `scoreAt` on the literal by `rfl`.
Report the peak before and after. Do NOT change `v0.6/` or its pins in this job.

**Step 1 (the spike, one page of Lean, at most about 150 lines).** A reduced machine with:
- two approval forms: a legacy one (signs keys and intent only) and a bound one (signs the record identifier and
  the head as well); two key-change forms: an old one, and one that also needs the new keys' signature; one clear;
  speech; a halt flag;
- the registers: `id : Option Digest`, `refused : List FormId` (one-way), `enabled : List FormId`;
- two starts: ordinary (`id = none`, nothing refused, the legacy forms enabled) and bound (`id = some I`, the
  legacy approval refused);
- signatures as an abstract `valid : Keys → Message → Sig → Bool` with a hypothesis in the style of `SignatureOnce`.

Prove, each kernel-checked, no `sorry`:
1. `ref_unless_refused`: a legacy frame gets the reference verdict unless its form is in `refused`.
2. `old_follows`: on every state reachable from the ordinary start, the OLD statement (reference verdict, no
   exception) holds.
3. `refused_mono`: no step removes anything from `refused`; key change keeps `id`, `refused` and `enabled`.
4. `bound_refuses_legacy`: from a bound start, the legacy approval is refused at every reachable state, also
   when re-addressed (this is sentence 4a of the card).
5. `no_lockout`: from EVERY state, with a valid signature, the clear is admitted and at least one enabled
   key-change form is admitted.
6. `cannot_refuse_last`: a frame that would put the last enabled key-change form, or the clear, into `refused`
   is itself refused.
7. THE ATTACK ON YOUR OWN CLAUSE: write the machine variant in which the owner may refuse the old key-change form
   while the new one is enabled (the round-14 case), and show 5 and 6 still hold; then write the variant in which
   a restriction is allowed to refuse BOTH, and show `no_lockout` is FALSE there (a counterexample theorem). If
   you cannot produce the counterexample, the clause is weaker than it looks: say so.

**Step 2 (half a page of prose in the report).** From what the spike showed: is the schema of card section 6
enough? Does anything in A1 to A4 not survive contact with Lean? Name the first three jobs of the skeleton (A4)
with their acceptance in one line each.

## Report
Give the text to the lead for `REPORT-ROOT-V2-SPIKE.md`. First line exactly:
`ROOT V2 SPIKE: memory step 0 peak before/after n/n MiB; spike theorems n of 7 kernel-checked; no-lockout survives its attack yes/no; design stands yes/no`
Then what is CHECKED, what is NOT, the peak of the largest job, and what surprised you. Then stop.
