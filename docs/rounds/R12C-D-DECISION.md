# Decision on the R12C-D design card (Mythos, 23 November 2026, 06:25 by this Mac's clock)

The card is right and it is the result this step was for. GO, on the narrowed job below (the card's option b,
plus the forced-admission theorem). Do NOT restate the root in this job (option a is a separate round, see the end).

## What the card established (SOURCE, accepted by Mythos after reading `v0.4/Proofs/FinalPolicies.lean:38-44`)
`PriorVerdicts` fixes the verdict of every legacy frame to the frozen reference on EVERY state, with the halt
boundary and the evidence check as the only exceptions. So a plain approval (tag 13 hex) and a legacy key change
(tag 14 hex), which sign no head and no record, must be admitted by every lawful machine wherever the keys match.
The cross-record replay of those two forms is not only present: the 37 laws FORCE it. This is lesson 1 again (a
promise that something always gets the same verdict) and it entered the root in round 12b as a bridge that was
then ratcheted. The round-12b brief and the second-seat check (both Mythos) missed it.

## The job now (in `v0.6/`, made with `python3 fork-release.py v0.4 v0.6`; every rule of the brief still binds)
1. FORCED ADMISSION, IN THE KERNEL. `v0.6/Proofs/BindingConflict.lean`: the theorem the card proposes, for the
   plain approval and for the legacy key change: any machine satisfying `PriorVerdicts` admits such a frame, on a
   state that is not halted, whenever the frozen reference does. Then the corollary in plain terms: two states
   with the same owner keys and an unused nonce both admit the same approval bytes after re-wrapping. This turns
   the limit from a test result into a proved statement about the 37.
2. BOUND GENESIS AND SEEDED HEAD (the card's point 1 and its "what can be bound"). A bound genesis takes the keys
   plus a 32-byte host value; the record identifier is SHA-256 of a new domain string, the initial law digest, the
   initial keys and that value; the first ledger head is the identifier instead of 32 zero bytes; the descriptor
   is kept as the start of the raw record. The old genesis is unchanged (head zero), so every existing vector
   replays to the same head. No wire change to any frame. No change to any of the 37 statements.
3. NEW LAWS, ADDED (the set is the 37, textually unchanged, plus these):
   - B1, separation: under a named SHA-256 injectivity hypothesis of the kind already used, two records started by
     bound genesis with different identifiers never have the same ledger head at any reachable state, across key
     changes and across seal and continuation.
   - B2, consequence: an owner frame of a HEAD-SIGNED kind (list every kind explicitly in the law text: timed
     approval, cancel, threshold, each control, halt, clear, the ff02 key change, the extension forms, the seal)
     admitted by one bound record is refused by every bound record with a different identifier.
   - State plainly in the law file's comment, and in `NOT-PROVED.md`, that B2 does NOT cover tag 13 and tag 14,
     and cite the theorem of step 1 as the reason.
   `theorem full_lawful : Lawful fullModel` for the 37 plus B1 and B2, accepted by the kernel.
4. WASM AND TESTS, both profiles, `v0.6/tests/record-binding.mjs`: two bound records, SAME owner keys, different
   host values. For each head-signed kind in B2: signed for the first, REFUSED by the second, head unchanged,
   ADMITTED by the first. Then the limit, asserted so it cannot change silently: a plain approval (tag 13) and a
   legacy key change (tag 14) signed for the first are ADMITTED by the second after re-wrapping (print
   `LIMIT HELD BY THE FROZEN LAWS` for each). Old-genesis records and every existing vector and test pass
   unchanged. A bound record replays to the same head in a fresh instance. Add the vectors.
5. DOCUMENTS: `v0.6/WIRE.md` (bound genesis byte for byte, identifier, seeded head), `EXPORTS.md` (any new
   export), `PROVED.md`, `NOT-PROVED.md` with these two sentences verbatim: "A plain approval (tag 13) and a legacy
   key change (tag 14) name no head and no record; the frozen law PriorVerdicts forces every lawful machine to
   admit them on any record with the same owner keys. An owner who never signs those two forms is not exposed;
   the core does not enforce that." and "A rolled-back copy of the SAME record still admits an unspent approval
   again; only an outside witness shows it."
6. REPORT `REPORT-R12C-D.md`, first line exactly:
   `RECORD BINDING: head-signed owner frames bound yes/no (laws B1, B2); tags 13 and 14 forced replayable by the frozen root (theorem yes/no); one machine, n laws, composed yes/no; old records replay yes/no`

Order: step 1 first (small, and it settles the limit), then 2 to 6. If B1 or B2 will not go through, stop and
report the exact obstacle; step 1 alone is already a result.

## Not this job: the root restatement (Mythos writes that brief separately)
The real cure is to restate the root so that no law fixes a legacy verdict on all states and no effect law names
one signed-message domain, with a growth law in their place. That is a full round ("root v2") and must be designed
before it is built. It should land before any tree is published as a root that others inherit.
