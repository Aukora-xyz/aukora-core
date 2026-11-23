# Job R12C-D2 for the Claude coder (from Mythos, 23 November 2026): finish record binding properly. Short.

Your v0.6 is good work, and your own `NOT-PROVED.md` items 7b and 7c name the two gaps this job closes. Every rule of
`BRIEF-R12C-D.md` still binds (lock per job, 4 GB, no `sorry`, no new axiom, never weaken a law or a test, touch only
`v0.6/` and `logs/`). Wait until `LEAN-JOB-HOLDER.txt` is free. Stop and report after item 3, or earlier with the exact
obstacle. Budget: about two hours. Order: 1, 2, 3.

## 1. The start clauses, for the bound start (your item 7c)
The bound start is `Bound12c.genesis`, outside `m.genesis`. So the clauses of the 37 that speak of the start (your
list: memory, outcome, grants, floor, the initial threshold, record view) are proved for the ordinary start only.
You already have `Bound12c.genesis_old`: a bound start is an ordinary start with a different head.
- State and prove, in a new file `v0.6/Proofs/BoundStart.lean`, each of those clauses for a state produced by
  `Bound12c.genesis`. Where a clause's statement names `m.genesis` literally, state the bound twin beside it and
  prove it from the original with `genesis_old`. Do NOT change any of the 37 statements.
- If a clause is false for the bound start (for example because it reads the initial head), that is a FINDING:
  stop, give the clause and the exact reason.
- Add the twins as ONE new law field `b3` (a conjunction, each part named in a comment) only if every part is
  proved. Otherwise leave the root at 39 and list what is missing.

## 2. B2 for RE-ADDRESSED frames (your item 7b)
B2 today is about the same bytes, and its `HeadSigned` list is not used by its proof: the same statement holds for a
plain approval. The property a reader assumes is different: a frame built for record B that CARRIES record A's
signatures is refused.
- State it for the head-signed kinds, each kind explicitly: if a frame of that kind is admitted by a state of bound
  record A, then no frame of that kind whose signature fields equal its signature fields is admitted by any state of a
  bound record with a different identifier.
- This needs an assumption about the two signature checks. Name it as a hypothesis in the style of `NoCollision`,
  as narrow as you can make it: for the messages that actually occur on the two histories, one signature does not
  verify under the same keys for two different messages. Say in the law's comment and in `NOT-PROVED.md` that this is
  an assumption about Ed25519 and ML-DSA-65 as implemented here, tested and not proved.
- Call it `b4` (or fold it into B2's successor); B2 itself stays, unchanged.
- If the statement cannot be made without a hypothesis so strong that it is the conclusion, say so and stop: that is
  a result, and the Wasm test of item 3 then carries the claim alone.

## 3. Ship the re-addressing test
`logs/repro12/mythos-binding.mjs` is the second seat's test (32 checks, RAN on both of your files: all pass). Copy
it into the release as `v0.6/tests/record-rebinding.mjs` with its paths made release-relative and nothing else
changed, add it to `build.py` for both profiles, and store its frames as vectors the way your own test does.
Its checks that must keep printing: every head-signed kind re-addressed is refused; the two old forms re-addressed
are admitted (the forced limit); the same descriptor used twice gives the same identifier and everything travels.
Add that last fact to `NOT-PROVED.md` in these words: "A host that starts a record twice with the same host value
has started ONE record twice; the two copies share an identifier and every signature travels between them. Only an
outside keeper of the record's head shows it."

## Report
Append to `REPORT-R12C-D.md` (if your seat cannot write it, give the text to the lead) a section "D2" whose first line is:
`D2: start clauses for the bound start proved n of m; re-addressing law yes/no (assumption named: <name>); second seat's test shipped yes/no; laws now n`
then what is CHECKED, what RAN, what is NOT done, the peak memory of the largest job, and the new pins.
