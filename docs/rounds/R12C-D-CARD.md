# R12C-D design card: binding owner signatures to one record (Claude coder, 2026-11-23 06:20 WITA)

**Verdict: STOP after the card. The candidate cannot hold with the 37 laws of `v0.4/RootFinal.lean` unchanged.**
The statement that breaks first is `w1`, second conjunct `PriorVerdicts` (`v0.4/Proofs/FinalPolicies.lean:40`).
Every claim below is SOURCE (read in v0.4); nothing here was run in Lean yet.

## The blocking statement, in plain words
`PriorVerdicts m`: for EVERY state `s` and every legacy frame `w` (first byte not ff, not an install 1b),
`m.step` admits `w` exactly when the frozen reference `Policy9.step w s` does. The only exceptions are the halt
allowlist and, for an act (tag 23), the evidence check `Historical.allows` (`Proofs/InstalledEvidence.lean:165`),
which reads assessments only. There is no owner-rule, mode or record exception.
- The plain approval (0x13) is a legacy frame. `Policy9.step` accepts it when both signatures verify over
  `Hybrid7.grantMessage (owner s) i` (domain `AUKORA/R7/hybrid/grant`, keys, intent; `Hybrid.lean:53`), the nonce is
  unused and the frame names the current head. Nothing in that message, and nothing else it checks, names a record.
- So in a bound record B with the same keys, an approval re-wrapped from record A is accepted by `Policy9.step`,
  and `PriorVerdicts` FORCES every lawful machine to admit it. The act that spends it is forced the same way.
  The legacy key change (0x14, `rebindMessage`: keys, generation, new keys, no head) is forced the same way.
- So candidate point 3 ("a bound record refuses every unbound owner frame") is impossible for 0x13 and 0x14
  under the 37. This is the record-binding defect, and the frozen root makes it a law.

## The other three candidate points against the text
- **Point 2 (new domain strings).** The effect laws name the old signed messages: `grants`/`GrantSource`
  (pool grows only via `grantMessage` or `issueMessage`), `binding` (owner changes only via `rebindMessage`,
  `Safe11.Both … 53` or `futureRebindMessage`), `threshold`/`SignedThreshold` (`thresholdMessage`), `control` and
  `revoke` (`cancelMessage`, `controlMessage`), `h2` (only a `ValidClear` under `AUKORA/R11/safe` may lift a halt).
  `VersionVerdicts` lets a new ff 04+ dialect do only the same typed effects with the same messages. A
  bound frame signed under a new domain can therefore have no effect at all. It can only be passive.
- **Point 3 (owner rule).** `Open` exempts only tag-23 acts and installs, via `s.rules`. The rule language is
  `Directive.cancel/issue` per intent. It has no "binding" rule, and `ruleEffect`/`Restore` empty the rules on every key
  change. A rule-held mode would not survive a key change (fails R2).
- **Point 1 (identifier).** This part fits. The state schema is fixed, but the raw record keeps its prefix forever
  (`RawRecordLaw` and H4 history are both relative to the start). Continuation changes only the head, and no law
  fixes the initial head. A bound genesis could store a descriptor as `record[0]` and seed the initial ledger head
  with the identifier.

## What CAN be bound under the 37 (useful, not the asked result)
Every owner signature except 0x13 and 0x14 already covers the current ledger head. That includes the timed
approval 24, the cancel 25, threshold 22, the controls, ff02 halt/clear/key change, and the extension forms. The
seal covers the head and the journal. Today every record starts at head 0, so a frame signed at the same prefix
replays. Seeding the head with the identifier binds all of these to the record with no wire or law change. That
rests on a named SHA-256 injectivity hypothesis, the same kind as in existing files. Plain approvals and legacy
key changes would stay replayable across records, and the laws would force that.

## Point 4 (not built)
An approval naming a head that must be an ancestor of the current one survives unsigned speech in between. It
costs a set of every past head (or an accumulator with membership proofs) in state. Under `PriorVerdicts` it
would also have to be a new ff 04+ form, and so it hits the same "old messages only" wall.

## The 37 statements and owner frames (one line each)
Mention owner frames, and how they fare under the bound design:
- **w1 (PriorVerdicts): BREAKS.** Legacy verdicts are fixed on all states (above).
- **w1 (VersionVerdicts, Lineage, W1):** new dialect may only reuse typed effects with old messages; blocks point 2.
- **grants:** pool entries need `grantMessage`/`issueMessage` signatures; a new domain cannot add grants. Blocks point 2.
- **binding:** owner keys change only under old key-change messages. Blocks point 2 for the key change.
- **threshold, revoke, expiry, correction, bundle** (Supports): valid old-dialect frames must be admitted. They
  are head-signed, so seeding holds them.
- **h5** (Recovery, SessionFinal.Recovery): old clear and ff0253 key change must always succeed. They are
  head-signed and hold.
- **h1, h2, h3, h4:** they hold if the clear stays the old ff0251. A new-domain clear lifting a halt breaks h2.
- **control:** controls and cancels must carry their old messages. Head-signed, holds.
- **floor:** installs, legacy key changes and acts need old signatures. These hold; nothing new is added.
- **restore:** a key change empties rules and pool. Holds, but it is why a rule-held mode cannot work.
- **once, stale:** they hold. Seeding changes only which head is current.
- **succession, upgrade:** they hold, unchanged.
- **record, replay:** they hold. A record[0] descriptor and a seeded head are compatible with start-relative laws.
- **Other laws:** stamping, missing, monotone, memory, outcome, retention, advice, passive and e1–e6 are about
  evidence, speech or upgrades. No owner-frame change.

## Next step needs a decision (Mythos and the owner)
(a) Restate the root once, so `PriorVerdicts` exempts owner frames refused by a record-bound mode stored at
genesis. This removes an always-same-verdict promise, which is lesson 1 again. Or (b) ship only the head seed
under the 37 and record "0x13/0x14 cross-record replay is forced by PriorVerdicts" as a proved limit.
First Lean job, if told go: `v0.6/Proofs/BindingConflict.lean`, proving `PriorVerdicts m → Policy9.step w s = some t
→ Legacy w → tag ≠ 27 → ¬halted s → (w not an act) → (m.step ctx w s).isSome`. That puts the forced admission in
the kernel. It is about 60 lines, one `lean` job under memwatch, and needs the v0.6 fork first.
