# Job for the Claude coder (from Mythos, 23 November 2026): a DESIGN CARD for root v2. No Lean. No build.

You found the defect (`PriorVerdicts` forces the replay of tags 13 and 14) and you have just read every clause of
the root three times. Use that while it is fresh. This job is paper only: read, think, write ONE file,
`logs/ROOT-V2-CARD.md`, at most three pages. No Lean process, no lock, no change to any file outside `logs/`.
Mythos reads the card and decides; nothing is built from it without that.

## Why a card first
The root has been restated twice already (rounds 11 and 12), each time for one reason, and each restatement left
the next problem in. A third restatement must be the last one for a while. So the card's job is to collect
EVERYTHING that needs a change to an existing clause, and to separate it from what can simply be added.
Nothing real has inherited the 42 yet (lab only), so a new genesis is acceptable; a fourth restatement is not.

## What the card must contain
1. **The 42, one line each** (field name, file and line of its statement), sorted into:
   N: forbids or fixes something (free to inherit);
   A: promises that something succeeds or gets a fixed verdict (dangerous to inherit), with its escape list as written;
   V: names a version, a wire grammar, a list, a checker goal, a legacy reference machine, or ONE signed-message
      domain string (dangerous to inherit).
   A clause can be both A and V. Say which reference or domain each V clause names.
2. **The defects each A or V clause causes or could cause.** Known: `PriorVerdicts` (legacy verdict fixed on all
   states) forces tags 13 and 14 to travel. The effect laws (`grants`, `binding`, `threshold`, `control`, `revoke`,
   `h2`) name single signed-message domains, so a record-bound signature form can have no effect. List the rest.
3. **The restatement, clause by clause, for every A and V.** Two candidate shapes to test against the text; say
   which works, or give a better one:
   - Legacy verdicts: "a legacy frame gets the reference verdict EXCEPT where a restriction recorded in the state
     refuses it", plus a law that restrictions only restrict (they never admit what the reference refuses), are
     set only at genesis or by an owner-signed frame, are one-way, and survive key change, seal and continuation.
   - Effects: "this effect happens only under a signature valid for an INSTALLED owner-message form for that
     effect", plus a growth law for forms (a form may be added; an added form signs at least the record
     identifier and the head; no form is ever reinterpreted).
   For each restated clause: does the old statement follow from the new one on old-mode records (so every
   existing vector still replays)? Where it does not, say what is lost.
4. **What root v2 must make TRUE that is false today**, each as one sentence a kernel could check:
   (a) in a bound record a plain approval and a legacy key change signed for another record are refused;
   (b) a re-addressing law for ALL owner-signed kinds, including halt, clear, the newer key change and the seal;
   (c) whatever else item 2 turned up.
5. **Everything else on the list that touches existing clauses, so it goes into the SAME restatement.** For each,
   one paragraph: does it need a change to an existing clause, or is it purely additive?
   - the judge kept as a separate pinned file, the machine free to change under it (`BRIEF-R12C.md` section B);
   - the closed availability list, reserve edges, the per-version verdict table (section C);
   - a seal that commits to the carried state so a fresh core can START from a seal, and a clean refusal before
     memory runs out (a record chain today ends in a trap at about 100 MiB: `READINESS-CORE.md` blocker 13);
   - a Merkle head over the record and permits checked downstream (`BRIEF-R13.md`);
   - a key change that proves possession of the new keys (`BRIEF-R14.md`);
   - evidence that only counts when the core admitted it (today any speech line can claim to be evidence).
6. **The state.** The state schema has been treated as fixed. Which of the above need new state (a restriction
   register, the record identifier, a set of installed message forms, a state commitment)? What is the smallest
   schema that carries all of them?
7. **Succession.** Is root v2 a lawful successor of the 42 by entailment? If not (your own theorem `forced`
   suggests not), say so in one line: root v2 starts by a new genesis, and old-mode records are replayed, not
   upgraded. Then check the lessons against your own proposal: list every clause of root v2 that still promises
   something always succeeds or still names a version or a domain, and justify each or remove it.
8. **Memory.** The root check peaks at 3.3 GB under a 4 GB cap, and root v2 will be larger. Propose a structure
   that lowers the peak (for example the root as two or three named groups, each proved in its own file, composed
   by a small final theorem). Say what you expect the peak to be and why.
9. **The spike.** The smallest thing to build first that would show the design works or fails: one page of
   Lean at most, on a reduced root. State it, its acceptance test, and the result that would kill the design.
10. **Size and order.** How many Lean jobs, in what order, what could be done in parallel by a second builder,
    and the three risks you would bet on.

Write what you do not know as "not determined from the text". A short honest card beats a complete-looking one.
