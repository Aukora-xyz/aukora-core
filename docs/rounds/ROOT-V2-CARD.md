# ROOT v2 design card (Claude coder, 2026-11-23, WITA). Paper only: no Lean run, no lock.
Read from `v0.6/` as verified at part A (42 fields, `RootFinal.lean:18-82`). Claims are SOURCE unless marked.
Verdict: **root v2 is not a successor of the 42 by entailment.** It needs a new genesis and ONE state-schema change.
Old-mode records are replayed, not upgraded.

## 1. The 42, sorted
N = forbids or fixes. A = promises success or a fixed verdict (escape list in brackets). V = names a version, grammar,
list, checker goal, reference machine or one signed-message domain. Sub-clauses separated by `/`.
- `replay` Laws.lean:343 / Proofs/FinalPorts.lean:17. **A+V.** feed/reset succeed [Open = not halted ∧ ownerPermits;
  quota closed]. Names the limits `Bounds12.maxInput`, `maxStaged` and the quota `charge`.
- `record` Laws.lean:350, Proofs/FinalPolicies.lean:27. **V.** `Grammar.Preserves installed`, `later.length ≤ 253`, the legacy decoder `projected`.
- `stale` Proofs/FinalHistory.lean:23. **N.**
- `once` Proofs/FinalPolicies.lean:98. **N.**
- `passive` Proofs/FinalHistory.lean:64. **N** (+V: the passive payload list).
- `advice` Proofs/VersionAdvice.lean:123. **N** (verdict equality across aligned histories).
- `restore` Proofs/FinalHistory.lean:198. **N+V** (legacy `Tracked … .rebind`, `KeyChange` forms).
- `upgrade` Proofs/InstalledPorts.lean:123. **N+V** (`PackageFacts`: identical executable).
- `memory`, `outcome` Proofs/FinalHistory.lean:83, Versions.lean:218. **N**; quantify `m.genesis`.
- `grants` Proofs/Versions.lean:93. **V**: `grantMessage` (`AUKORA/R7/hybrid/grant`), `issueMessage` (`AUKORA/R9/grant`),
  `GrantOrigin9.Signed`.
- `binding` Versions.lean:207 (`bindingEffect`:147). **V**: `rebindMessage` (`…/rebind`), `AUKORA/R11/safe` op 53, `futureRebindMessage`.
- `control` Proofs/FinalPolicies.lean:132, Proofs/Authority.lean:42. **V**: `controlMessage` (`…/control` + `AUKORA/R5/control`), `cancelMessage` (`AUKORA/R9/revoke`).
- `monotone` Proofs/InstalledPorts.lean:90. **N.**
- `floor` Proofs/InstalledPorts.lean:110. **V** (`GrantOrigin9.Signed` = grant domain, legacy `rebindMessage`).
- `threshold` Proofs/Versions.lean:121 / Proofs/InstalledControls.lean:37 / genesis 0. **A+V.** `Supports .threshold`
  [Open] against the reference `Policy9.step`. `thresholdMessage` (`AUKORA/R8/threshold`).
- `missing` Proofs/InstalledPorts.lean:95. **N+V** (fixed default digest text and score 255).
- `bundle` Proofs/InstalledPorts.lean:101. **A+V** (`Supports .assessment` [Open], reference `Policy9.append`).
- `stamping` Proofs/Versions.lean:180, Proofs/InstalledControls.lean:68. **A+V** (`StampSupports` [Open]; `decodeSidecar`).
- `revoke` Proofs/FinalPolicies.lean:139. **A+V** (`Supports .cancel` [Open]; `cancelMessage`; rule language `Directive` via `Rules`).
- `expiry` Proofs/FinalPolicies.lean:113. **A+V** (`Supports .issue` [Open]; `issueMessage`).
- `correction` Proofs/FinalPolicies.lean:155. **A** (`Supports .report` [Open]).
- `retention` Proofs/PublicBehavior.lean:238. **N.**
- `e1 e1b e2 e4` Proofs/InstalledEvidence.lean:104-129. **N.**
- `e3` Proofs/InstalledEvidence.lean:121. **N+V** (`ceilingMessage` domain).
- `e5` Proofs/Versions.lean:196. **A+V.** Tag-0 verdict equals `speechReference` on EVERY state [none].
- `e6` Proofs/InstalledEvidence.lean:136. **A** (a weaker readdressed act remains available).
- `h1` Proofs/FinalPolicies.lean:209. **N+V** (`allowedOrdinary` list).
- `h2` Proofs/InstalledRecovery.lean:121. **N+V** (only a `ValidClear` under `AUKORA/R11/safe` lifts a halt).
- `h3` Proofs/InstalledRecovery.lean:127, `h4` Root12.lean:91. **N.**
- `h5` Proofs/InstalledRecovery.lean:142, SessionFinal.lean:54, Proofs/Rollover.lean:8. **A+V.** Every valid clear and
  every valid key change (R11/safe 51/53, futureRebind) succeeds from every state [none; the reserve only in SessionFinal].
- `succession` Proofs/InstalledPorts.lean:120 (`Ratchet11.Demands`). **V** (checker goals and `verifies`, `rootSpec`).
- `w1` Versions.lean:180, Proofs/FinalPolicies.lean:40, Proofs/InstalledEvidence.lean:254, Proofs/InstalledVerdicts.lean:44. **A+V.**
  - `W1`: grammar growth from `Versions.v01`.
  - `PriorVerdicts`: legacy verdict = `Policy9.step` on every state [halt allowlist, act evidence].
  - `VersionVerdicts`: ff02/ff03 verdict = `prefixVerdict`; ff04+ iff decode ∧ ready.
- `b1 b2` RecordBinding.lean. **N+V** (the `AUKORA/R12C/record` descriptor; the R12B seal and genesis formats).
- `b3` Proofs/BoundStart.lean. **N.**
- `b4` Proofs/Rebinding.lean. **N+V** (four message functions, `SignatureOnce`).
- `pinned` Proofs/PinSatisfied.lean. **N+V** (checker goals, `verifies`).

## 2. Defects, known and new
Known:
- `PriorVerdicts` forces tags 13 and 14 to travel between records (`BindingConflict.forced_*`).
- The effect laws (`grants`, `binding`, `control`, `revoke`, `threshold`, `h2`, `floor`, `e3`) each name one domain.
  A signature form bound to the record can therefore have no effect.

New in this reading:
- (i) `h5`, with no escape, pins two key-change forms. A key change that must prove possession of the new keys
  (round 14) cannot be the only form: the old ff0253 form must keep succeeding. Inherited forever.
- (ii) `e5` fixes the speech verdict on every state, so no rule can ever refuse speech. A record-filling defence or
  a speech quota inside the model is impossible (today the quota lives outside the model, in `SessionFinal`).
- (iii) `Supports` (5 kinds) escapes only through `Open`. That is the halt flag plus `ownerPermits`, which reads
  rules for acts and installs only. Any future refusal of a cancel, threshold, issue, report or assessment form
  (for example "bound records accept only bound forms") is impossible.
- (iv) `ExtensionKind` (ReleaseInterface.lean:20) and `Directive` (Policy.lean:13) are closed types. An effect or
  rule outside them cannot be expressed in the frozen schema.
- (v) `upgrade`/`PackageFacts` requires an identical executable, so the machine cannot change (BRIEF-R12C B).
- (vi) The `m.genesis` clauses cover only `m.genesis`. Any second start (bound genesis today, start-from-seal later)
  needs twin clauses (b3 was one).
- (vii) `replay`/`PublicPorts` names fixed numeric limits. That is lesson 2 in a quieter form.

## 3. The restatement, per A or V clause
**Shape 1, legacy verdicts**, kept with one change:
- Restated form: "reference verdict, EXCEPT where the state's restriction register `R` refuses".
- Law `R-mono`: `R` only removes admissions. It is set at genesis or by an owner-signed frame, it is one-way, and
  key change, seal and continuation carry it unchanged.
- Old-mode: `R` is empty at an ordinary genesis, so the old `PriorVerdicts` follows on every state reachable from it.
- Lost: `PriorVerdicts` on ARBITRARY states (it quantified all states). Every vector replays, because vectors start
  at genesis.
- Same treatment for `VersionVerdicts`, `Speech` (e5), `Supports` (5 kinds), `StampSupports`, `replay.feedWhen`,
  and `e6`: each "succeeds" becomes "succeeds unless `R` refuses".

**`h5` (no lockout) must NOT become "unless R refuses"**, or the owner can lock himself out. Proposed restated form:
- "from every state, at least one installed recovery form for clear and one for key change is admitted when validly
  signed";
- plus a law that `R` can never disable the last installed recovery form.

This keeps the promise without naming a domain.

**Shape 2, effects**, works:
- Restated form: "this effect happens only under a signature valid for an INSTALLED form for that effect".
- The installed forms are a register `F` in state. At an ordinary genesis `F` = today's domains, so each old
  statement follows on old-mode records.
- Law `F-grow`: a form may be added by an owner-signed frame. An added form signs at least the record identifier,
  the head and a fixed-width generation, so b4 extends to it without parsing decimals. No form is reinterpreted or
  removed; refusal of a form goes through `R`, not by deleting it from `F`.

**V that names a checker goal** (`succession`, `pinned`): keep the shape, but name a judge identity carried in state
rather than `rootSpec`; see 5a. **V that names a limit** (`replay`): the limits become state fields, set at genesis,
that can only shrink.

## 4. What root v2 makes true (kernel-checkable sentences)
- (a) In a record with identifier I, a frame of tag 13 or 14 is refused unless `R` permits legacy forms, and a
  bound genesis sets `R` to refuse them.
- (b) Re-addressing, for every kind in `F` including halt, clear, key change and seal: a frame carrying the
  signature fields of a frame admitted at record I is refused at every record I' ≠ I, under `NoCollision` and
  `SignatureOnce`. This needs the fixed-width generation in new forms. For the legacy ff02 forms it needs a lemma
  that decimal text is prefix-free; that lemma is not proved yet.
- (c) A key change installs the new keys only if the new keys also signed (possession).
- (d) An act cites only lines the core admitted as evidence, never a speech line (5f).
- (e) No lockout: from every state some installed recovery form is admitted (replaces `h5`).

## 5. Everything else that touches existing clauses
- **(a) Judge as a separate pinned file, machine free to change** (BRIEF-R12C B). This CHANGES `upgrade`
  (`PackageFacts`, identical executable), `succession` and `pinned` (goals built against the judge carried in state),
  and the identity formula (`RatchetChecker.identity` uses `rootManifest`). It is not additive.
- **(b) Closed availability list, reserve edges, per-version verdict table** (BRIEF-R12C C). The availability list
  IS the set of A clauses above, so it goes into this restatement (shape 1 plus the `h5` form). The per-version
  table is documentation and is additive.
- **(c) Seal committing to the carried state, start-from-seal, clean refusal before memory runs out** (blocker 13).
  - Start-from-seal is a second genesis, so it touches every `m.genesis` clause. Make genesis a SET of start
    functions, with b3 as the pattern.
  - The state commitment needs new state.
  - The memory refusal changes `replay`/`PublicPorts` (feed and frame promises). It must be an `R`-style escape
    "unless a resource limit in state refuses", and it must not touch `h5`'s reserve.
- **(d) Merkle head and downstream permits** (BRIEF-R13). Additive if the Merkle root is an extra accumulator
  beside the chain head. If it replaced the head, `stale`, b1, b2 and b4 (all of which read the head) would change.
  Recommendation: additive.
- **(e) Key change proving possession** (BRIEF-R14). CHANGES `h5`, `binding`, `restore`, `floor`: all four name the
  legacy and ff0253 forms. It is covered by shape 2 plus the new `h5`.
- **(f) Evidence only when admitted.** Probably ADDITIVE: e1/e1b already fix kind and position, and a new law that
  cited lines were admitted as evidence only restricts. The text does not settle whether `e5` (speech verdict
  fixed) blocks it.

## 6. State
New state needed:
- the record identifier (today adapter-only);
- `R` (restrictions);
- `F` (installed forms);
- resource limits;
- the judge identity (5a);
- a state commitment (5c), which can be derived rather than stored.

Smallest schema: ONE new field on `Policy9.Machine`, `policy : Policy := {}`, where `Policy` holds
`id : Option Digest`, `refused : List FormId`, `forms : List FormId`, `limits : Limits`, `judge : Digest`.
`{}` is today's ordinary state.

Cost: every statement quantifying State keeps its text, but proofs that build states by anonymous constructor
(for example `FinalStrict.blank`, `ExportFinal.LineageControl.blank`) must be updated. How many of the 15k proof
lines are hit is not determined from the text.

## 7. Succession and the two lessons
- Not a successor: `BindingConflict.forced` shows that any model with `PriorVerdicts` admits the cross-record 13/14
  replay, and root v2 refuses it. So root v2 starts at a new genesis; old-mode records are replayed, not upgraded.
- Clauses of root v2 that still promise or name something, and why each stays:
  - **No-lockout (4e)**: promises success. Justified: it names no form, only "some installed form", and `R` cannot
    remove the last one.
  - **Reference verdicts minus `R`**: names the reference machine `Policy9.step`. Justified only for old-mode replay.
    Mark it as the old-mode clause; new forms never go through it.
  - **`F-grow`**: names fields a form must sign (identifier, head, generation width). That names a format family,
    not a version. Acceptable.
  - **Manifest tag `R12B/1`** in the identity: names a version. Move it out of the law into the build check.

## 8. Memory
SOURCE plus RAN in part A (peaks from `logs/r12c-d/a-peaks.txt`):
- The 3.3 GB peak is NOT the root. It is `Proofs/Evidence11.lean` at 3,313 MiB.
- `RootFinal`, `tools/ExportFinal.lean` and `tests/GateFinalChecks.lean` each peak at about 550 MiB.

So more root fields are cheap. The risk is in heavy individual proof files.

Proposal:
- Prove root v2 as three groups (Core and legacy, Evidence and halt, Binding and succession), each a structure in its
  own file, composed by a small final theorem.
- Split `Proofs/Evidence11.lean` before adding to it.
- Expected peaks: the groups under 1 GB; `Evidence11` unchanged at about 3.3 GB unless split. That exceeds the cap the
  moment the evidence clauses change, so splitting it is step 0.

## 9. The spike (at most one page of Lean)
- **Build:** a reduced machine with one owner form (plain approval) and one recovery form (clear), the register `R`,
  and a bound genesis that refuses legacy 13. Prove on it:
  - restated `PriorVerdicts` (reference unless `R`);
  - `R-mono`;
  - the new no-lockout clause;
  - (a) for the approval.
- **Acceptance:** all four are kernel-checked, and the old `PriorVerdicts` follows for `R` empty.
- **Kills the design:** if no-lockout plus `R-mono` cannot both hold. That happens if some restriction the owner
  needs (refusing legacy 13) also refuses the only recovery form. Or if restated `PriorVerdicts` does not imply the
  old one on states reachable from an ordinary genesis.

## 10. Size and order
Jobs:
- 0: split `Evidence11`.
- 1: the spike.
- 2: schema field plus repairs to the anonymous constructors.
- 3: registers `R` and `F` with their two growth laws.
- 4: restate the A clauses (shape 1 plus the new `h5`).
- 5: restate the effect laws (shape 2).
- 6: new forms with a fixed-width generation, then (a)–(c).
- 7: judge as a separate file (5a).
- 8: start sets and seal start (5c).
- 9: Wasm, vectors, new genesis identity.

About 10–14 Lean jobs. A second builder can take 0, 7 and the Wasm side of 9 in parallel.

Three risks I would bet on:
1. The schema change touches far more proofs than expected.
2. `h5` with forms and `R` is subtler than it looks; a self-lockout slips through.
3. 5a (machine free to change) collides with `PriorVerdicts`-as-old-mode, because a new machine's reference verdicts
   must still be the old ones for replay.

Not determined from the text: the number of proof lines touched by the schema change; whether `e5` blocks 5f; the
in-Wasm judge's memory with a larger environment.
