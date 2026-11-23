# Next rounds (kept by Mythos; updated 22 Nov 2026 after round 7 and the GLM 5.3 review)

## Round 9 candidates, in order
1. **Grant expiry and single-grant revocation** (GLM): a grant unspent past its stated expiry, or revoked by the
   owner, admits nothing, without cancelling any other grant. Today the only cancel is a rebind that kills all.
2. **Outcome correction** (GLM): a later, labelled outcome may supersede an earlier one; the earlier one stays in
   the record; the view shows the newest and says it was corrected.
3. **Confirm or refute GLM's tag claim** with a test: can any ordinary frame have 7 or 17 at byte 40? (Mythos's
   reading from `Wire5.frameField` and `Upgrade6.lean:26-33`: no, byte 40 is the frame's own tag.)
4. **Save-point seal** (the owner): an owner-signed `seal` event naming a head; law: at most one sealed successor per
   seal id; the core records an outside single-use reference (for example a Bitcoin outpoint) and does not verify
   it. Design and proof only; no real transaction.
5. **Passkey-format verifier** (P-256 ECDSA with the WebAuthn message wrapping), so his real fingerprint drives it.
6. **Selective disclosure**: prove one event is in the record without showing the others (a Merkle path over
   frame digests, with a proved checker).
7. **Payments as intents** (the owner): a spend intent names amount, destination and asset; the cap law already
   exists (`Core2`); the outcome carries a transaction id reported by the destination. The core authorises and
   records; it never holds a wallet key. Design only.
8. **Shadow mode in x6.1**: the core beside one real organ, deciding nothing; needs Auma's card.
9. **Second independent checker** over all proofs; a clean-machine reproduction by another seat.

## Standing honesty items
- The proofs are about the model; a manifest links model to bytes (research).
- The in-Wasm checker takes earlier lemmas as given.
- Cryptography is tested, not proved.
- Reports must say "the verifier is a parameter of the laws; the Wasm core supplies the concrete one".

## Added after GLM 5.3's round-7 review (verified at source by Mythos: `core/Upgrade7.lean:27-41`)
0. **Weld the proof to the candidate (now the first target).** The gate admits two hardcoded digests. Target: the
   upgrade carries the candidate's own model declarations and its own `Lawful` proof; the checker type-checks both
   and derives the goal from what was carried, so any lawful successor can be admitted; the candidate file embeds
   the digest of its model declarations (a custom section) and the gate compares it. This removes the fixed list;
   it does not close the model-to-bytes gap, which stays research.
0b. **Differential testing from the model:** generate vectors from the Lean function, replay them against the Wasm
   exports, complete on tags and length boundaries. Behavioural evidence for the model-to-bytes link, one round.
- Wording to fix in `Laws7.lean` comments: L1 ("recover the same state" is replay-filter insensitivity), L2 (holds
  from `start`), L4 ("exactly once unless re-granted": the `NoIssue` condition), L8 (the goal-to-candidate binding
  lives in the gate's lookup, not in the law).

## Added 22 Nov, afternoon: the "max line" proposal (GLM 5.3, pasted by the owner) and how it is being handled
- **Proof-carrying weights:** being assessed by a parallel Astra job, brief `BRIEF-P1.md` in
  `~/aukora-memory/scratch/lean-core-pcw-2026-11-22/` (one tiny integer lattice, an interpreter in Lean, a proof that
  quotes the exact weights, mutant counts). Prior work exists (TorchLean; proof-carrying ReLU verification over
  rationals): no novelty claim, and no claim about large models.
- **"Boundaried"** (no internal state reaches an outward proposal except through the checked path): a real
  information-flow law; statement asked of Astra in P1. The Markov-blanket wording is an analogy, not physics.
- **Metabolism laws (DHFI and the seven states):** properties of a formula and a state machine are easy Lean
  theorems, but they belong to the product's metabolism spec, not to the small core. Parked until v0.1 exists.
- **In-weight CPU, a browser operating system, WebNN:** not lab scope. Parked.
- Order kept: round 9 (gate as a rule, revoke and expiry), then the v0.1 consolidation, then shadow mode.

## Added 22 Nov, 14:50: the first principles of an earlier design, the Kyber cell, nested cells, and the order after round 10
- **An earlier design ("evidentiality enforcement"), read in full by Mythos.** Its first
  principles that fit a small proved core: every claim an act rests on has a class (observed, reported, inferred,
  guessed); references must resolve to entries already in the record; confidence never grows along a chain; "looked
  and found nothing" differs from "did not look"; any failed check at the act boundary means a safe state only the
  owner clears; speech is never blocked. Already in the core: speech free and acts gated, validate-then-execute,
  single-use approvals, expiry. Not in the core: evidence classes, resolving references, the safe state.
  Brief written: `BRIEF-R11.md` (evidence laws E1 to E6, safe state H1 to H4, carried into the gate, `v0.2/`).
  Limit to repeat: the core can prove the bookkeeping, never that a claim is TRUE.
- **Kyber CPU cell (x6.1 `docs/auma/kyber-cpu.md`, AUM-450):** a pinned 9,750-byte cell whose behaviour is fixed by
  weights, with a skill record naming cell, program and weights by digest. It is the natural subject for P2: one
  weight lattice through the real gate with a proof that quotes its bytes. Asked of Astra as a paragraph in round 11;
  build only after v0.1 and the evidence laws.
- **Nested cells:** x6.1 already runs 28 pinned zero-import cells and journals each call's input and output digests
  in memory (`docs/auma/cells.md`). The bridge is small: the core records each cell call and stays the only place an
  act is admitted. This is the shadow-mode step; it needs Auma's card.
- **Order:** round 10 (one law set in the gate, v0.1) -> round 11 (evidence laws and safe state, v0.2) -> P2 (one
  lattice through the gate) -> shadow mode beside x6.1.
- **Second-seat finding on round 9:** the admitted example candidate is the round-6 core with a byte-patched `init`
  (`spike/r9/candidate.py`): the demonstrated "upgrade" lands on an Ed25519-only file. Round 10 item A fixes it.

## Added 22 Nov, 15:10: Mistral's four pushes (pasted by the owner) and what was done with each
1. **Round 10's bar is the downgrade itself:** the exact round-9 upgrade (same candidate bytes, model and proof,
   freshly signed) replayed against the round-10 gate must be REFUSED with a named reason, while a full successor
   passes. Round 10 was already running with "the Ed25519-only successor is refused"; the exact replay is the second
   seat's own test when it lands, and is written into round 11 C1.
2. **Mythos's finding while checking this (`core/Laws7.lean:131-138`):** L8 says a change of core carries "a proof
   the checker accepts", not WHAT it proves, and nothing makes a successor's own gate demand the same law set. So a
   lawful successor could ship a weaker gate: a two-step downgrade. A larger pinned set alone is not a ratchet.
   Round 11 C1 asks for the law of SUCCESSION (hereditary) and says what the model-to-bytes gap leaves untrue.
3. **Round 11 sharpened to decidable checks** (`BRIEF-R11.md`): references resolve only to entries committed before
   the act; kind must match class; the confidence bound is COMPUTED by the core, not stated; a "found nothing"
   claim quotes the query digest and a window that ends at or before the recorded read; the safe state is defined
   by its legal set, with H5 NO LOCKOUT: a valid owner clear is accepted from every reachable halted state.
4. **Kyber lattice (P2), brief written:** `~/aukora-memory/scratch/lean-core-pcw-2026-11-22/BRIEF-P2.md`, weights
   copied from x6.1 main `e590076f` (10,608 bytes, digest `6856c5fc…`, 177 inputs, 384 nodes, 17 outputs, integers
   only). Bar: certificate accepted for the exact bytes, one changed byte refused; then how far the KERNEL gets on
   the 2.1 million transitions; then the freedom count (how many single-scalar changes leave the function the same).
5. **Journal admission (round 12, not written as a brief yet):** every sealed cell call is one frame: cell digest,
   input digest, output digest, no bodies, in order, replayable; the core is the sole place an act is admitted.
   Law to prove: no act cites a cell result that is not a committed cell-call frame (this is E1 for cell calls).
   The x6.1 side (28 cells, in-memory journal) connects in shadow mode with no live authority; needs Auma's card.
- **Order:** round 10 -> round 11 -> P2 -> round 12 with shadow mode.

## Added 22 Nov, 16:05: after round 10, Mistral's second review, and the second seat's break-it pass
- **Break-it pass on v0.1 (`BREAKIT-V01-MYTHOS.md`, RAN):** about 13,300 hostile inputs, 0 traps, 0 changes on a
  refusal, 0 lite/full disagreements, 0 of 9,062 changed signed frames accepted. Gap found: no memory maximum, no
  staging limit (96 MiB accepted), the whole record in memory. Goes to round 12 B.
- **Third leg of succession (Mistral, agreed):** the JUDGE must be byte-compared too (checker code, pinned
  environment, goal constructor); otherwise a lenient judge fakes entailment. Round 12 A.
- **Install-frame malleability:** Mistral says bind (the grant names the package digest). Mythos agrees; round 11
  C1b asked Astra to decide; if it only listed it, round 12 binds it.
- **Shadow mode:** `SHADOW-SPEC.md` written with the pass condition fixed in advance; uses the lite core, digests
  only, bounded sessions. Needs Auma's card. The cell-call event is round 12 D.
- **Order now:** round 11 (running) -> round 12 (`BRIEF-R12.md`) -> P2 (Kyber weights) -> shadow session in x6.1.

## Added 22 Nov, 16:25: the horizon (see `HORIZON.md`), and the memory rule
- `HORIZON.md`: permits checked downstream (the step that makes the record a lock), witnessed heads, key
  pre-commitment and recovery, which bytes the host runs, two cores meeting, a second implementation from the
  documents alone, forgetting. `STANDARDS-ALIGNMENT.md` is being written by a research job (web sources only).
- Memory rule since 16:06: `memwatch.py` kills any lab toolchain job above 4 GB; every brief carries it.
- Candidate rounds after 12: R13 permits (design + laws + a verifier a stranger can run); R14 witnessed head in a
  standard checkpoint format; R15 key pre-commitment and passkey signatures; a side job: second implementation.

## Added 22 Nov, 16:30: verdicts from `STANDARDS-ALIGNMENT.md` (research helper, primary pages fetched today; Mythos
## spot-checked two RFC numbers by search: RFC 9964 and RFC 10073 exist as stated; the rest is REPORTED)
What changes in our plan, in order of value:
1. **Permits and witnessed heads are ONE round, and the core needs no key for it.** Outside witnesses co-sign
   Merkle-tree checkpoints (C2SP `tlog-checkpoint` / `tlog-witness`), not hash chains. So: add an RFC 6962-style
   Merkle root over the accepted frames beside the hash chain; a PERMIT for an act is then "the act frame + an
   inclusion proof + a co-signed checkpoint", checkable offline by a stranger, and expressible as a COSE receipt
   (RFC 9942, REPORTED). Laws to prove: the Merkle root is a function of the record; every accepted frame has an
   inclusion proof under every later root; any two roots of one record have a consistency proof; no inclusion
   proof exists for a frame that was not accepted (under collision resistance, a named assumption).
   One agent-receipt Internet-Draft (draft-noa-scitt-ai-agent-receipt, REPORTED) already shapes "one signed
   statement per agent action" this way: align, cite, claim nothing new.
2. **Key change, checked against the update-framework rules (TUF 1.0.37, REPORTED):** a rebind today is signed by
   the OLD keys only (`v0.1/WIRE.md`, "Rebind in 14"). Add: the NEW keys must sign too (proof of possession, so a
   typo cannot brick the record); the generation must be exactly previous + 1 (already a law: check the wording);
   and each key event commits to a digest of the NEXT key set (KERI pre-rotation, REPORTED), so a thief of today's
   keys cannot name the successor. Then run the rest of that framework's attack list (rollback, freeze,
   mix-and-match) against the upgrade gate item by item and write down each answer.
3. **Both signatures as one composite (RFC 10073 exists, checked; details REPORTED):** ours requires both and
   refuses either alone (RAN), but each half is an ordinary signature over the same message. The composite
   construction binds the halves with a label so neither half stands alone elsewhere. Align before the wire format
   is called v1.
4. **Passkey approvals:** WebAuthn Level 3 is a W3C Recommendation (REPORTED); passkeys sign with classical
   algorithms only, so a passkey approval sits beside the ML-DSA key, not instead of it. Needs a P-256 verifier in
   Lean and "challenge = hash of the exact approval bytes".
5. **Model-to-bytes gap:** a 2026 workshop poster "Verifying Compiler-Emitted WebAssembly in Lean" is REPORTED:
   proving properties of the COMPILED module with a Lean semantics of Wasm. That is the nearest route for us;
   read it before promising anything. Verified ML-DSA does not exist as a whole (REPORTED: only parts in libcrux).
6. **Cite, do not adopt:** OpenTimestamps (keep the opaque stamp; no format spec found), RFC 3161, DID/VC, MCP
   authorization (an adapter concern), remote attestation (ask hosts for it; the core cannot enforce it).
- **Round order after 12 (briefs not written yet):** R13 Merkle head + permits + offline verifier; R14 key-change
  hardening (new-key possession, pre-rotation) + the update-framework attack list; R15 composite signature +
  passkey verifier. Side job any time: a second implementation from `WIRE.md` and the vectors alone.

## Added 22 Nov, 16:55: built by Mythos, and Mistral's fifth push
- **BUILT and RAN (Mythos):** `standalone/` rebuilt on the v0.1 core: `aukora.mjs` (adapter with both-signature
  approvals, timed approvals, cancel, outcomes, threshold, export, replay), `store.mjs`, `cli.mjs`,
  `mcp-server.mjs` (never reads the owner key), `test.mjs` (29 of 29 end-to-end checks), `README.md` with its
  limits. Every frame built from `WIRE.md` alone was accepted by the pinned core at the first attempt, which is
  early evidence that the document is implementable by a second party.
- **Mistral push 5, where each item went:** (1) owner rules may only restrict, and no rule can forbid a clear:
  to check at source when round 12 lands (v0.2's H5 already quantifies over EVERY state, so a recorded rule cannot
  forbid a clear; "owner rules only restrict" is not yet a stated law) and to go into round 12b; (2) permits:
  closed refusal list, expiry as data, no sub-permits: in `BRIEF-R13.md`; (3) the pre-commitment window and racing
  key events: in `BRIEF-R14.md`; (4) no mixing cell results across pins: `BRIEF-R13.md` D; (5) the judge sentence:
  already required by round 12 A.4; (6) refusal receipts: `BRIEF-R13.md` B.4.
- **Root v1 is not final until the release tag.** Round 12 pins a restated root in the lab; anything Mistral's
  attack 1 finds can still change it before anything is public.

## Added 22 Nov, 17:05: the owner's earlier work, read by Mythos, and what each changes here
- **Membrane minimal verifier (`aukora-membrane` `552f4f41`, `minimal/verify.py`, a Rust replica beside it):**
  ALREADY BUILT: RFC 6962 append-only checking with closed verdicts and declared forbidden claims. RAN its
  self-test (4 of 4) and two vector pairs. Round 13 now must emit heads and proofs that this unchanged verifier
  accepts. Copies in `context-membrane/`. This is also a second implementation of the Merkle half for free.
- **Recursion and lineage reports (`aukora-genesis`, September 2026):** nine receipted model generations, a
  judge whose prediction was locked before the outcome, a small risk judge. For the core: a model generation is
  a recorded change with digests and an outcome; "locked before the outcome exists" is exactly a recorded line
  plus a not-before and a not-after stamp; the risk judge is the host-supplied danger score, which our laws
  already treat as advice that can never grant. Their truncation finding (a decisive fact at the end of the input
  flips a judge) argues for the assessment naming the digest of the FULL input, which law D5 already requires.
- **Deterministic inference (DeepInfer, public):** identical outputs for identical inputs with a fixed seed.
  Direction, not built: a model call becomes a re-checkable cell call (model digest, input digest, seed, output
  digest), turning some "told" evidence into "seen". Needs GPUs; note it in the cell-call event's design.
- **A CPU compiled into weights (Qwenputer, public):** the large relative of the Kyber cell. At that size one
  proves the COMPILER that computes the weights, not the weights. The Kyber job (P2) stays the honest small step.
- **Ornith plan (`aukora-prime`, proposed, not run):** an untrusted capable worker inside containment; "capability
  from anywhere, authority only from the owner's key". The standalone plug-in built today is that boundary in
  small: the worker may speak, propose and ask; only the owner's two keys approve.

## Added 22 Nov, 17:45: round 12 verified; the root is still not composed; a lockout found
- Round 12 (v0.3) rebuilt and attacked by the second seat: see `REPORT-R12-MYTHOS.md`. Holds: package binding,
  memory ceiling, staging limit, judge compared by bytes, hostile proofs, cell event.
- NOT composed, and the specifying brief was Mythos's: "leave safety clauses unchanged" kept version-naming
  clauses (D5, P1, H2, L10, L8). Lesson two: never ratchet a clause that names a version.
- Lockout (RAN, own frames): at 512 lines a valid approval, control and key change are refused; speech is free,
  so any caller can fill the record. Breaks no-lockout as built.
- Round 12b launched (`BRIEF-R12B.md`): root v1 final over installed versions, acceptance = one admitted
  same-set successor of the full machine; recovery reserve; seal-and-continue; what an upgrade may change.
- Release consequence: "one machine carries every law" is not true tonight. If 12b fails too, the honest release
  candidate is the v0.1 core (23 laws, coherent, downgrade refused, not hereditary) with the memory limits added,
  and everything later described as lab work in progress.
- Order now: 12b -> 13 (permits, Merkle head, membrane-compatible) -> 14 (key change) -> P2.

## Added 22 Nov, 17:55: the crew's first results (Linear AUM-398) and what was done with each
- **Second implementation (outside seat, TypeScript, documents only):** 1,165 of 1,167 frames match, 1,160 on the
  merits; the two misses are the install frame it could not check and the frame after it. 14 documentation
  findings, answered in `WIRE-ERRATA-v0.1.md`. REPORTED by that seat; its code is not in this lab.
- **Finding from its item 9, confirmed by the second seat (RAN, `logs/breakit-grok/`):** a plain approval is not
  bound to a record. Within one record a used or cancelled approval cannot be replayed; across two records with
  the same owner keys, or a rolled-back copy, the same signature is admitted again. Fix written into
  `BRIEF-R13.md` E (record identity at genesis, every owner signature covers it).
- **Rebuild on a second machine (outside seat):** not done yet. 30 inputs outside the release folder, not 14; six
  lab outputs had no retrievable copy (now in `input-mirror/` of the private repo); the four tool pins are Mac
  executables, so a Linux rebuild needs per-platform pins and a build script that knows it. Stays a release blocker.
- **Public front page draft and 19 verified standards facts (outside seat):** Linear comment 2f4fce5e. Not copied
  here; to be merged into `RELEASE-README.md` and `STANDARDS-ALIGNMENT.md` when the release tree is final.
- **Outside reviewer's standards brief (two Internet-Drafts, one unread):** taken as a docs-only mapping table in
  round 13 E.4; no dependency on unread draft text.

## Added 22 Nov, 18:05: Pentora, read at the owner's question (does it help the core?)
- READ and RAN (Mythos): `golden-horizon-principle` at `989c61fc`, folder `review/astra-2026-10-30/pentora-exact-instrument`.
  Files match the folder's own SHA256SUMS; its test file passes 33 of 33 groups here (standard-library Python,
  exact integer and fraction arithmetic, 5 seconds).
- WHAT IT IS (SOURCE: its README and SPEC): 110 directions on a sphere in three shells (30, 60, 20) with exact
  weights 800, 512, 729 over 69300. For any polynomial of degree at most five, the weighted sum over the 110
  points equals the true average over the whole sphere EXACTLY (all 364 moments through degree eleven match; a
  degree-twelve control fails by exactly 29/640640). It also ships its own blind spots: a degree-25 polynomial
  that is zero at all 110 points, and a rule that an outside field's remainder stays "unknown" unless proved.
- DOES IT HELP THE CORE? Not as security: nothing in the record, approvals, gate or permits needs a spherical
  rule, and as a storage code the live system's own notes say plain bytes plus ordinary error correction carried
  the same payload smaller. As a point count it is not ahead of the standard tables either (my recollection,
  supported only indirectly by a search today: the classical 50-point rule reaches degree 11 and the 110-point
  one degree 17; UNVERIFIED against a primary table).
- WHAT IS REAL IN IT FOR US: (1) it is the same discipline the core needs everywhere: an exact claim INSIDE a
  declared class, a named blind spot, "unknown" outside, refusals for anything else; (2) it is the ideal subject
  for the core's METHOD: every one of its claims is a finite exact computation, so the Lean kernel can check them
  and the same text can compile to a sealed Wasm cell. "Pentora, kernel-checked" would be a small complete
  example of a proved instrument, and a proof-carrying cell beside the Kyber weights job.
- CANDIDATE SIDE JOB P3 (not briefed, not started; behind 12b, 13, 14, P2): in Lean, the 110 directions in
  Q(sqrt2, sqrt3, sqrt5), the 364 moment identities through degree eleven, the degree-twelve failure, the
  degree-25 blind-spot polynomial, compiled to a zero-import cell whose vectors match `reference.py`.
- NOT judged here: the companion Riemann operator paper, and whether the geometry has a deeper use.

## Added 22 Nov, 18:10: the outside reviewer's five findings on round 12, and Auma's corrections to the shadow spec
- F1 (a gate that pins without satisfying; twice now it blessed a name), F2 (reserve edges), F4 (open references
  in the version law) and the second seat's record-binding finding: all in a NEW round, `BRIEF-R12C.md`, which
  also splits the JUDGE from the MACHINE so an upgrade can change machine code under a fixed judge (F3, the
  sequencing cliff), and makes the build per-platform for the outside rebuild lane.
- `BRIEF-R13.md` now states up front which line it builds on, depending on what 12c reports.
- `SHADOW-SPEC.md` corrected from Auma's paragraph: her field names, no loss counter, only the newest 32 lines
  kept, match by her running root where possible, `n` and `caller` in the canonical line. Her card scope accepted.
- Order now: 12b (running) -> 12c (gate integrity, separable judge, record binding, per-platform build) ->
  13 (Merkle head, permits) -> 14 (key change) -> P2 (Kyber weights) -> P3 (Pentora, kernel-checked).

## Added 22 Nov, 18:25: round 12b stopped unfinished; the builder is out of allowance until 23 Nov 14:30
- Astra (Codex CLI) hit its usage limit at 18:17: "try again at Nov 23rd, 2026 2:30 PM". No `REPORT-R12B.md`.
  Nobody presses a purchase.
- Left in `v0.4/` (UNFINISHED, unpinned): about 25 new Lean files (`RootFinal`, `Versions`, `SegmentFinal`,
  `SessionFinal`, `Proofs/Final*`, `Proofs/Installed*`, `ReserveAuth`, `Rollover`, `ChainFinal`), a
  `VERSION-AUDIT.md`, new exports (`seal`, `continueRecord`, `journalByte`, `sealByte`, `witnessMask`), and interim
  Wasm files copied to `logs/interim-v04/` (`aukora-core.wasm` `65ea767e…`, `aukora-core-lite.wasm` `c87a4050…`).
- REPORTED from Astra's run notes: Lean accepted the revised upgrade law; an interim full Wasm admitted a
  same-set successor (37 laws) and a stronger one (38); a signed clear was admitted after 512 ordinary entries;
  a seal was accepted after all 16 recovery slots were spent; continuation preserves halt. It was finishing the
  version bridges before a from-scratch rebuild.
- RAN by Mythos on the interim files, own frames (`logs/repro12/mythos-capacity-v04-interim.txt`): at 512 lines
  a valid KEY CHANGE is admitted (it was refused in v0.3); speech, a plain approval and a threshold control are
  still refused there; the full record replays to the same head; staging still stops at 16 MiB.
- Not done: final rebuild, pins, `PROVED.md`, `NOT-PROVED.md`, the report, any second-seat verification.
- Running: the tree's own build under the watchdog, to see which Lean files check (`logs/R12B-mythos-state-check.txt`).
- To resume when the builder returns: "Read BRIEF-R12B.md and logs/R12B.log's last notes; `v0.4/` is your own
  unfinished work from 22 November; finish it and write REPORT-R12B.md", then round 12c.

## Added 22 Nov, 18:45: round 12b finished by the second seat; ONE machine now carries every law
- `REPORT-R12B-MYTHOS.md`: all 96 Lean files accepted in two from-scratch builds, both Wasm files identical across
  the two builds (`aukora-core.wasm` `138170cc…`, lite `8e7cca36…`), `RootFinal.full_lawful` = one machine, 37 laws;
  same-set and stronger successors pass, every one-law omission fails; key change admitted at a full record.
- The finisher was the second seat (pins, regenerated chain vectors, PROVED and NOT-PROVED). No Lean edited.
  OWED: an independent re-run by a seat that did not finish it.
- Still not true: upgrades may change law data only (round 12c B); no law against pinning an unsatisfied set in
  general (12c A); approvals not bound to a record (12c D); no witness, no permits (13).
- Resume note for the builder is superseded: `v0.4/` is complete as a lab release; start from `BRIEF-R12C.md`.

## Added 22 Nov, 19:15: v0.4 reproduced by an independent seat; builders change
- `REPORT-R12B-RERUN-CARBON.md`: Carbon (a different model, same Mac) ran `sh v0.4/build.sh` from an empty work
  folder in ONE uninterrupted run, 18:55 to 19:07: PASS v0.4, 98 pin lines OK, 0 errors, both Wasm digests equal to
  the pins, the regenerated chain vectors equal to the final pin, sources unchanged, 37 of 37 omissions refused,
  peak about 3.2 GB, no watchdog kill. v0.4 may now be described as: reproduced once by an independent seat, on
  one Mac. (REPORTED by Carbon; the second seat read the report, did not re-run it.)
- Builders: the Codex/Astra seat is gone (credits spent). The owner is testing Dot (chat, no build) writing a
  diff, Carbon applying and building it in the lab under the lock and the watchdog, the second seat judging.
  Piece 1 posted on Linear AUM-398 (comments ef752b04 and correction 21140a4a): `fork-release.py` (a clean,
  checked fork of `v0.4/` to `v0.5/` whose build must give the SAME Wasm digests) and `env-split.py` (the split
  of the checker's 4,143 pinned declarations into trusted theorems, opaque constants, definitions, axioms).
- The Opus builder for round 12c is on hold (the owner's Claude allowance is the scarce one).

## Added 22 Nov, 19:45: the outside builder lane, first result
- Piece 1 (Dot's `fork-release.py` and `env-split.py`): applied clean, self-tests pass, stopped at a symlink the
  brief never mentioned (`v0.4/tools/watch.py` -> `memwatch.py`), leaving nothing behind. Decision by Mythos:
  the fork dereferences such a link into a regular file under strict conditions. Pieces 1b and 2 posted on Linear
  AUM-398 (comment 01dfec15, under 7fd3736d). `DOT-QUALITY-LOG.md` keeps one line per piece for two rounds.
- v0.4 finding (f) in `V04-ADDENDA-MYTHOS.md`: that link was missing from `v0.4/SOURCE.sha256`.

## Added 22 Nov, 21:00: governed organ optimisation v0 built and run; a correction to the memory rule
- `governed-rsi-v0/` and `REPORT-GOVERNED-RSI-V0.md`: the owner's SPEC-BRIEF-04, fixture version, PASS in 9 seconds
  (`sh governed-rsi-v0/run.sh`). The score-only arm takes a law-breaking candidate; the governed arm refuses it on
  a kernel-checked refutation over its exact bytes; a dropped law and an altered judge are refused for distinct
  reasons; cold replay reproduces every decision. The core's gate did NOT check the weights (host script + native
  kernel). Independent run by another seat owed.
- CORRECTION to the lab's memory rule: a bare `lean -M 4096` is rejected by this toolchain; the option works only
  through a release's own tools (they load a plugin). Briefs corrected. Bare commands run under `memwatch.py`.

## 23 November, 06:10 (release day; Mythos)
- Overnight fork checked by me (RAN): `v0.5/` = v0.4's machine, Wasm byte-identical, pins match, v0.4 untouched.
- Scope decided: the first public tree is `v0.5/` with its limits on the first screen; round 12c moves to `v0.6/`
  and is NOT attempted before the release (a full Lean round with a wire change cannot be proved, rebuilt and
  re-run by a second seat in six hours with no Lean builder seat that has ever landed one).
- Built: the adapter runs unchanged on the current small core (34 of 34, RAN); `make-release.sh` ships that core
  with the adapter, runs the 34 checks, blocks on link files and a missing front page, prints one TREE value.
- Owed today: wording diffs (Dot) approved line by line by me; front page; SOURCE list regenerated at the
  14:00 freeze; Carbon's exact-tree rebuild and scan; Carbon's run of piece 2 and of the governed-organ fixture;
  the outside reviewer's attack on the fixture; then, after the freeze, back to strengthening (12c D first).
- 06:10 update: the owner said "not yet", so the core is NOT released today; the day is strengthening
  plus readiness and the 14:00 rebuild is a rehearsal. Order: (1) record binding, `BRIEF-R12C-D.md`, one Claude
  coder into `v0.6/`; (2) a build a stranger can run (Dot writes, Carbon runs); (3) the existing minimal verifier
  on the standalone record, built by Mythos, no Lean; (4) pin implies satisfied; (5) a long seal-and-continue test.
- Built by Mythos (RAN, no Lean): `standalone/checkpoint.mjs` + `aukora checkpoint <dir> [earlier]` + 
  `standalone/checkpoint-test.mjs`. The membrane project's minimal verifier is USED UNCHANGED (pinned
  `039aa899…`, its self-test and three own vectors run first; only the printed `VERDICT: APPEND_ONLY` counts).
  23 of 23: honest growth passes; a FORKED record that replays in the core gives OBSERVATION_CONFLICT; a record
  CUT at the end is not a pass; 820 honest pairs all pass, 3,835 damaged proofs and 666 forks never pass.
  Parity: verifier USED UNCHANGED, display only (gates nothing); second-implementation differential NOT YET;
  signed checkpoints and an outside witness NOT YET; nothing of this is inside the core or the Lean laws.
- 06:25: the coder's design card (`logs/R12C-D-CARD.md`) stopped as briefed: `PriorVerdicts` forces cross-record
  admission of tags 13 and 14. Decision `logs/R12C-D-DECISION.md`: go on a narrowed job (forced-admission theorem;
  bound genesis with a seeded head; laws B1, B2; the limit asserted in the test). Root v2 is a separate round,
  to be designed before it is built; readiness blocker 12.
- Long chain (RAN, `logs/repro12/mythos-long-chain.mjs`): 40 full segments (20,480 lines) sealed and continued in
  one instance, fresh replay to the same head and journal; cost per line grows with total history (0.05 s for
  segment 1, 0.52 s for segment 40).
- 06:28 FINDING (RAN): end of life by growth. 3,000-byte lines: trap inside record 69 after 34,991 lines / 102.1 MiB;
  repeatable in a fresh core after replay; after the stop even a valid owner seal traps. Readiness blocker 13.
- 08:00: v0.6 (record binding) verified by the second seat: `REPORT-R12C-D-MYTHOS.md`. Rebuilt byte-identical (778.5 s);
  my re-addressing test 32 of 32 on both files; two overstatements corrected (B2 is same-bytes only; bound start
  outside the proved start clauses); new limit: the same descriptor twice is one record twice. Next: job D2.
- 08:50: Carbon's independent exact-tree rebuild of v0.5 matches my TREE value; blocker 11 closed for that tree.
  Review document for the outside reviewer filed on Linear (slug a9e8c186876c). Side lab: Dot's piece 4b adopted.
- 09:05: D2 verified (41 laws; rebuilt byte-identical in 835 s; b3 start clauses 6 of 6; b4 re-addressing law for four
  kinds under `SignatureOnce`). Next for the coder: `logs/R12C-A-JOB.md`.
- 09:54: part A delivered by the coder (42 laws, field `pinned`, genesis build check); my harnesses pass on its files;
  my rebuild is queued behind Carbon's piece-3 build. Root v2 card accepted with amendments; spike job written
  (`logs/ROOT-V2-SPIKE-JOB.md`). Memory: the 3.3 GB peak is one `decide` proof, not the root.
- 10:10: part A verified (42 laws; rebuilt byte-identical in 798 s; genesis check accepted the real core and refused
  one changed byte). `v0.6/SOURCE.sha256` refreshed (one stale entry). The slot is free for the coder's spike.
- 10:20: root v2 spike re-checked by me (kernel, 2.2 s) and accepted. Two theorems of mine show what it leaves open:
  the old key change still travels from a bound start (so a bound start must refuse BOTH legacy forms and every open
  form must sign identifier and head); approvals can be refused for ever (so the guard protects approval too).
  Memory fix measured by the coder: 3,149 MiB to 944 MiB with `decide +kernel`. Next: `logs/ROOT-V2-SKELETON-1-JOB.md`.
- 11:46: root v2 skeleton 1 (`v0.7`) verified and frozen. Rebuilt byte-identical in 808 s, whole-build peak 1,389 MiB
  (v0.6: 3,335). Source diff exactly as claimed. New second-seat test `logs/repro12/mythos-twin-cores.mjs`: the same
  3,913 inputs into v0.6 and v0.7, 0 different, both files; control with one damaged frame is reported. Binding tests
  53/53 and 30/30. Left open and put into the next job (`logs/ROOT-V2-SKELETON-2-JOB.md`, folder `v0.8`): the new
  field is carried only by inspection; the schema change alone is already a new root; "empty means everything"
  must go (A7). Blocker 13 has a design brief from the source (`logs/B13-DESIGN-BRIEF.md`): the state is the whole
  record and three summaries are recomputed over all history on every step.
- 11:54: the adapter for the next line exists in the lab (`standalone-next/`, the released `standalone/` untouched):
  bound start, the newer stop / clear / key change, bound replay, and it refuses to SIGN the two old forms in a
  bound record. 47 of 47 on v0.6 and v0.7, both files; the released adapter's 34 checks pass through it in old mode.
  Its test carries a WATCH line that shows blocker 12 is still open in the core (one old-form signature acted on in
  two bound records) and becomes the acceptance for the root v2 step that closes it.
- 13:39: root v2 skeleton 2 (`v0.8`) verified and frozen. Rebuilt byte-identical (1,062 s beside one of my tests; peak
  1,173 MiB). Twin test against v0.7: 0 different, both files. 44 laws in ONE structure: 11 statements restated "unless
  refused" (one conjunct in `Open`, one hypothesis in four others), `r_mono` and `id_fixed` appended, the old text
  re-proved for any lawful model wherever the refused list is empty. NOT shown: that the 44 as a whole permit
  refusing (only the `PriorVerdicts` clause is unblocked). New test `logs/repro12/mythos-forms.mjs` (the table of forms
  against 14 real frames). Blocker 12 still open in the core. Next for the coder: `logs/ROOT-V2-SKELETON-3A-JOB.md`
  (folder `v0.9`): the machine reads the refused list and a bound start refuses both old owner forms. That is the
  first behaviour change and the step that closes blocker 12 for bound records.
- 13:43: direction from the owner via Lead 12: every move toward takeoff, the core merged into Auma where it enforces
  something, starting with ONE effect sink (her promotion path) that refuses without a current, exact core permit.
  Answered the lead on what the core can back today, and built it as a rehearsal: `bailiff-rehearsal/` (41 lines
  over the released adapter, 25 of 25 on the v0.5 small and full cores, LAB KEYS). New and not existing anywhere:
  the wiring in x6.1 and proof that the sink is the only writer; who holds the owner's two keys; where the
  acknowledged head lives. Where the core tree lives for her runner is the owner's yes/no (the lead carries it).
- 14:02: builder-lane pieces 9 and 10 judged GOOD (side lab; code stays in the lab, not in this repository): the
  delegation exhibit for the outside draft's author, and the backup-checker reference. The same backup law, proved in
  Lean and compiled to Wasm with the core's own SHA-256, agrees with both reference implementations on 1,938 cases.
  Direction from the owner: get the core solid, then bring it into x6.1 as Auma detaches from the crew, with him as the
  boundary. Order on this track: v0.9 (bound records refuse the two old forms) → the bailiff on bound records →
  her own runner builds and checks the core → the owner's key path (his decision).
- 15:49: root v2 step 3a-i (`v0.9`) verified and frozen: the form table split to 38 (one per effect) and the two
  decoder proofs, no behaviour change. Rebuilt byte-identical (959 s, peak 1,282 MiB); twin test against v0.8, 0
  different. Blocker 12 still open. Earlier this afternoon, for x6.1: the read-only core cell packet
  (`CORE-CELL-PACKET.md`), the head-promotion judge and its slice (`X61-BAILIFF-SLICE.md`, revised after review),
  and a kernel-checked lemma for the machine change (`spike-root-v2/second-seat/Wrapper.lean`). The public tree is
  parked at `tree-r2` until about 18:30; one fix is owed there (the fetch script must prune the Lean folder to the
  pinned files). Next for the coder: 3a-ii in `v0.10`.
