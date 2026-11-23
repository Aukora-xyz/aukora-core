# BRIEF, round 11, for ASTRA 6.2 (from Mythos): the evidence laws and the safe state. Same folder and limits.

Limits: work only in this folder; ignore `_export/` and `standalone/` (Mythos's); no downloads; no priority
wrappers; one compile at a time; no windows; stop any check or test that runs past 6 minutes and report it; leave no
worker running; CHECKED only for what a Lean kernel accepted in this round. Delete large regenerable build output
before you finish and report the final folder size. About 150 minutes. Order if time is short: C1, then B, then A, then C2. Fewer things finished beat more started.

Read `REPORT-R10.md` (yours) first. Build on `v0.1/` in a NEW folder `v0.2/` (copy, then extend); do not edit
`v0.1/` or any earlier checked file. If round 10 left `v0.1/` incomplete, say so and build on the round-9 machine.

## Where this comes from
The owner filed a design in February 2026 for "evidentiality enforcement": every claim that justifies an agent's
action must say what KIND of knowledge it is, and the check happens only where an action is about to run, never on
conversation. Its first principles, restated by Mythos for this core (do not copy its vocabulary or data formats):
1. A claim used to justify an act carries a class: OBSERVED (points at a recorded tool result), REPORTED (points at
   a recorded statement by a named source), INFERRED (points at earlier claims it was derived from), GUESSED (points
   at nothing).
2. References are not text the agent writes freely: each must RESOLVE to an earlier entry in this same record.
3. Confidence cannot grow along a chain of inference, and a guess has a ceiling.
4. "I looked and found nothing" is different from "I did not look": the first must point at a recorded search.
5. Any failed check at the act boundary puts the machine in a SAFE STATE; nothing leaves it but the owner.
6. Speech is never blocked. Only acts are.
The core already has 6 (say is free, act is gated), single-use approvals, expiry, revocation, and the danger score.

## A. Evidence on acts (main job, about 60 minutes)
1. Extend the assessment that an act must name (round 8's bundle) so that it LISTS its claims. Each claim: class,
   confidence as an integer 0 to 255, and references as digests or sequence numbers of earlier entries. Keep the
   frame format versioned (a new version tag; v0.1 frames keep their meaning).
2. The step function refuses an act whose assessment has any of these. Each is a decidable check on the record,
   not advice (an outside reviewer, Mistral, pushed each toward this form; Mythos agrees):
   a. RESOLVES: a reference that does not name an entry ALREADY COMMITTED to this record, strictly before the
      frame that carries the act. Nothing an act cites may exist only in the act's own frame or after it.
   b. KIND MATCHES: the kind of the entry a reference lands on must fit the claim's class: OBSERVED lands only on
      an `outcome` or `read` entry; REPORTED only on an entry recorded from a named source; INFERRED only on
      earlier claims. A mismatch is refused.
   c. THE BOUND IS COMPUTED, NOT STATED: the core computes each claim's bound itself, by one fixed total function
      of the claim's class, its premises' bounds and nothing else (smallest premise for INFERRED; the ceiling for
      GUESSED; the recorded value for OBSERVED and REPORTED). The agent may state a confidence; a stated value
      above the computed bound is refused. Growth along a chain is then impossible by construction of the function.
   d. GUESS CEILING held in state, moved only by a hybrid-signed owner control, like the danger threshold.
   e. LOOKED: a "found nothing" claim must reference a recorded `read` entry that carries the digest of the exact
      query and the window searched (as sequence numbers of this record, or host-supplied opaque bounds); the
      claim must quote the same query digest; the read must be committed before the claim, and the window must
      not extend past the read's own position (no searches of the future, no window chosen after the fact).
3. Laws, as Lean theorems about the new step function, each with a one-line comment saying no more than it states:
   E1 RESOLVES: every reference in every admitted act's assessment names an entry committed strictly before it.
   E1b KIND: every such reference lands on an entry of the kind its claim's class requires.
   E2 NO LAUNDERING: the computed bound of every claim is at most the computed bound of every claim it was
      derived from, transitively; and no admitted act states a confidence above the computed bound.
   E3 GUESS CEILING: no admitted act rests on a GUESSED claim above the ceiling; only an owner control moves it.
   E4 LOOKED: every admitted "found nothing" claim quotes the query digest of a read committed before it, whose
      window ends at or before that read.
   E5 SPEECH FREE: no evidence rule ever refuses a `say`, `remember` or `advise`.
   E6 MONOTONE: weakening a claim (lower confidence, weaker class) never turns an accepted act into... state the
      true direction carefully; if it is false in some direction, prove the counterexample instead.
4. Say plainly what these laws do NOT say: the core cannot know whether a claim is TRUE, whether the recorded tool
   result was honest, whether the class was chosen honestly, or whether the host ran the query it recorded. That
   an entry is tagged "seen" is forever the host's word. It proves bookkeeping: that what an act rests on exists
   in the record with the right kind, and that confidence never grows. Write that sentence in the report.

## B. The safe state (about 25 minutes)
1. A state flag `halted`. It is set by: an owner control; and (make this a recorded event, not a silent flag) a
   `halt` entry the host appends after a refused act. Decide and justify whether a refusal itself can set it given
   that refused frames do not change state today; do not break the round-1 law that a refused frame changes nothing.
2. While halted: every act, spend and upgrade is refused at every score and with every grant. `say`, `remember`,
   `advise`, `outcome` and `stamp` still record.
3. Define the safe state by its LEGAL SET: list exactly which frames are accepted while halted. Only a
   hybrid-signed owner control clears it. Laws: H1 while halted no act, spend, grant or upgrade is admitted; H2 no
   sequence of non-owner frames clears it; H3 clearing restores no grant that expired or was revoked meanwhile;
   H4 a halt is never removed from the record.
   H5 NO LOCKOUT (the mirror of H1, and the one that makes the safe state usable): from EVERY reachable halted
      state, a clear that is well-formed, names the current head and next sequence, and carries both valid owner
      signatures is ACCEPTED. No other rule (danger threshold, expiry, budget, evidence, a full table, a size
      limit) can refuse it. If any reachable state refuses a valid clear, exhibit it; that is a finding, not a
      failure. State the same for rebind while halted. Say what remains outside the theorem (a lost owner key).

## C. The law of succession, then carry the new laws into the gate (about 50 minutes; C1 comes FIRST in this round)
C1. Mythos's finding at source: round 7's L8 (`core/Laws7.lean:131-138`) says a change of core "carries a proof
    the checker accepts". It does not say WHAT that proof proves, nor that the successor's own gate demands at
    least the same law set of ITS successors. So even with round 10's larger pinned set, a lawful successor A
    could ship a gate that asks for a trivial theorem, and A could then move to anything: a two-step downgrade.
    Round 10's sentence "nobody can change the law set from inside" would then be false, because a successor
    compiles in its own.
    Mythos read round 10 at source and it does NOT close this: `UpgradeLaw` (`v0.1/Proofs/PublicBehavior.lean:110`)
    holds "for all ctx" and asks only that `Checker9.check ctx model proof = true`; the checker builds its goal from
    the NAME `Aukora.Release.Lawful` (`v0.1/Checker.lean:53`) and its base only requires that a constant of that
    name EXISTS (`v0.1/Checker.lean:13`). What the name MEANS lives in the base environment each file ships
    (`laws.env`). A successor whose model satisfies all 23 laws can therefore ship a base in which that name means
    something trivial. `NOT-PROVED.md` says "nobody can change the pinned law set from inside"; add the plain
    consequence it leaves out: a successor is other software, and nothing yet makes it pin this law set.
    Add the strongest honest clause, in the shape
    below (an outside reviewer, Mistral, attacked the first draft; Mythos accepts these points and adds two):
    (i)  Do NOT demand that a successor's law set EQUALS this one: that would forbid ever adding a law (round 11's
         own evidence laws could never be carried). Demand that it ENTAILS this one.
    (ii) Two separate checks. IDENTITY: the law set is a named, finite list whose digest is held in state and
         shown in the view, so a host can see which law text a core claims; it is compared, never used to express
         "at least as strong". RATCHET: an upgrade carries, beside the proof of the successor's law set for the
         carried model, a proof of ENTAILMENT: `forall m, NewLawful m -> Lawful m` (one named theorem per pinned
         law is fine). Missing or failing entailment: refused. A digest cannot express "superset"; a proof can.
    (iii) SUCCESSION clause in the law set: every change of core is admitted only with (a) a checked proof of the
         successor's law set for the carried model, (b) a checked entailment of the current set from it, and
         (c) the carried model's own upgrade step makes the same two demands of ITS successors. Say exactly how
         you break the circularity (the set mentions itself): by referring to the pinned set by NAME in the
         checker's environment (a syntactic reference, as the gate already builds its goal), by a clause
         parameterised over the goal constructor, or otherwise. If you cannot state (c) without circularity,
         prove (a) and (b), state precisely what (c) would need, and stop.
    (iv) Mythos adds: entailment alone can be met by a law set nobody can satisfy (from `False` everything
         follows). (a) already blocks that for an upgrade, since the successor must PROVE its own set. Show the
         refusal: a successor whose law set is unsatisfiable is refused because no proof of (a) exists.
    (v)  Mythos decides, for this round: there is NO separate "amend" event. The law set changes only by an
         upgrade to a successor that carries a stronger set with entailment. The owner can widen, never narrow,
         short of starting a new record from a new genesis (no continuity claimed). No two-step confirmation is
         built; list that under NOT built. If the carried-definition language cannot carry a new law (it is
         monomorphic and nonrecursive), say exactly what is missing; do not widen the language silently.
    (vi) The cost, to be written in `NOT-PROVED.md` in these words or plainer: "Succession preserves exactly the
         laws we pinned, including our mistakes. A wrong law is inherited until a stronger set replaces it. The
         theorem is about the carried MODEL; the successor FILE is linked to it by a digest and by tests, and the
         checker cell is trusted, not proved. Succession raises the stakes on both."
    Then show, in Wasm: the
    exact round-9 upgrade (same candidate bytes `FixedGenesis9.wasm`, same model, same proof, freshly signed for
    the new head) REFUSED with a named reason; a candidate that is lawful in every other clause but whose model
    asks successors for a weaker goal REFUSED; a successor with an unsatisfiable law set REFUSED; a full successor
    with the SAME set ADMITTED; and, if (v) fits the language, a successor with a STRONGER set (one extra law)
    ADMITTED with its entailment proof.
C1b. Second-seat finding on round 10 (`logs/repro10/mythos-malleable.mjs`): of 440 single-bit changes inside the
    PROOF field of the accepted install frame, 8 were still accepted (all in bound-variable names such as
    `a._@.Laws._hyg…`); 0 of 14 in the model field; 4 of 4 changed candidate files refused. A different valid proof
    is still a proof, so this is not a soundness hole, but the install frame is unsigned and two different frames
    install the same file. Decide and say which: the owner's install grant also names the digest of model plus
    proof (then exactly one package is admissible), or malleability is accepted and listed in `NOT-PROVED.md`
    with the reason. One paragraph and, if cheap, the change.
C2. Add E1 to E6 and H1 to H5 to the ONE law set, so a successor that drops them is refused. Rebuild, pin, re-run
    the vectors, add at least 300 new vectors covering every refusal above.

## D. One paragraph each, no code (10 minutes)
1. Nesting: the owner pictures many small sealed Wasm cells inside a larger one. For this core that means: other
   cells compute, this cell records each call as (cell digest, input digest, output digest) and is the only place
   an act is admitted. Which of today's laws already cover a cell call recorded as `read`/`outcome`, and what one
   new law would a "cell call" event need?
2. Weights: x6.1 has a small pinned cell whose behaviour is fixed by weights (an eight-instruction machine). Given
   the P1 side lab, what is the smallest honest "P2": one weight lattice admitted through THIS gate with a proof
   that quotes its bytes? List what it needs from the checker that the carried-definition language lacks today.

## Deliverables
`REPORT-R11.md` (two pages at most; first line: `EVIDENCE LAWS: n of 7 proved` and `SAFE STATE: n of 5 proved` and `SUCCESSION: closed yes/no` and
`IN THE GATE: yes/no` and `VECTORS: n of N agree`), `logs/R11-CHECKS.txt`, the `v0.2/` folder. Keep failures.
