# BRIEF, round 13, for ASTRA 6.2 (from Mythos): permits a stranger can check, on a head witnesses can co-sign

MEMORY RULE (binding): every Lean command runs `-j1 -M 4096`; (CORRECTION, 22 Nov 21:00: this toolchain REJECTS a bare `lean -M`; the option exists only through a release's own tools, which load its `MemoryOption` plugin, as `v0.4/tools/*.py` do. A bare `lean` command must run under `memwatch.py`.) ONE Lean process at a time; never release a build
lock while its compiler is alive; `memwatch.py` kills any lab toolchain process above 4 GB. A proof that needs more
is a FINDING (file, statement, peak), not something to retry larger. Never retry a killed job unchanged.

Limits: work only in this folder; ignore `_export/` and `standalone/` (Mythos's); no downloads; no priority
wrappers; no windows; stop any check or test past 6 minutes and report it; leave no worker running; CHECKED only
for what a Lean kernel accepted in this round. Delete regenerable build output; report the final folder size.
About 170 minutes. Order: A, B, C, D. Fewer finished beat more started. Build on the newest release folder in a NEW
folder (next version number). Read your newest report, the second seat's newest report, `HORIZON.md` and
`STANDARDS-ALIGNMENT.md` (a research helper's report: its standards facts are REPORTED, not checked) first.

## Which line this round builds on (decided before any time is spent; an outside reviewer's finding F3)
This round changes MACHINE CODE (Merkle exports, a permit verifier). Round 12's gate compares the whole
executable, so under it this round's result could not be admitted as an upgrade. Round 12c is meant to split the
judge from the machine. So: if `REPORT-R12C.md` says "UPGRADES MAY CHANGE: machine under a fixed judge", build
this round as a real successor of the 12c machine and SHOW IT ADMITTED through the 12c gate under the same judge;
that admission is part of this round's acceptance. If 12c says "law data only", build this round as a FRESH
line with a new genesis, claim no upgrade from any earlier lab release, and write that sentence at the top of the
report. Do not build a successor that its own parent's gate must refuse without saying so.
Section E.1 and E.2 below (record identity) are round 12c's job; if 12c landed them, verify and skip.

## Why
Today the core ADMITS an act and nothing downstream is forced to look: a witness, not a lock. And a host can drop
the newest lines or show two histories. One mechanism answers both, and the core needs no secret key for it:
a Merkle-tree head over the accepted frames, which outside witnesses can co-sign, and a PERMIT for an act =
the act frame + an inclusion proof under a head.

## A. Merkle head beside the chain (in Lean, compiled, exported)
1. An RFC 6962-style Merkle tree hash over the accepted frames in order (leaf = SHA-256(0x00 || frame), node =
   SHA-256(0x01 || left || right)); exports for the root, the size, an inclusion proof for entry i under size n,
   and a consistency proof from size m to n. The hash chain head stays exactly as it is.
2. Laws (collision resistance of SHA-256 is a NAMED hypothesis wherever needed, never silent):
   M1 the root is a function of the record; M2 every accepted frame has an inclusion proof that verifies under
   every later root; M3 any two sizes of one record have a consistency proof that verifies; M4 the verifier
   accepts no inclusion proof for a frame that is not at that position (under the hypothesis); M5 a refused frame
   changes neither root nor size.
3. ALREADY BUILT, ALIGN TO IT: the owner's membrane project has a minimal RFC 6962 consistency verifier with a
   closed verdict list (APPEND_ONLY, OBSERVATION_CONFLICT, UNDETERMINED), a declared permitted claim and five
   forbidden claims. Copies are in `context-membrane/` (`verify.py`, `CLAIM.md`, `vectors/`; the second seat ran
   its self-test: 4 of 4). REQUIREMENT: for any two sizes of one record, the core's exported root and consistency
   proof, written in that verifier's JSON shape (`treeSize`, `root`, `hashAlgorithm`, `leafConvention`,
   `proofFromPrevious`), must make the UNCHANGED `context-membrane/verify.py` print `VERDICT: APPEND_ONLY`; and a
   record with one changed early frame must give `OBSERVATION_CONFLICT`. Use its leaf convention
   (`sha256(0x00 || payload)`, payload = the accepted frame bytes). Run it with `python3 -I`. Ship 20 such pairs
   as vectors. Note its documented limit at power-of-two retained sizes and say whether our laws share it. Reuse
   its verdict words in our verifier where the meaning is the same; do not invent synonyms.
   USING IT PROPERLY (the owner's standing complaint is that new repos forget this): ship `verify.py` UNCHANGED
   and pinned by its SHA-256 in the release pins; ship its own vectors beside ours; if the Rust replica is
   available in `context-membrane/` run both on every pair and require identical verdicts (if it is not there,
   say so in the first line of the report: the differential test is then owed); write no sentence in any document
   that claims more than `CLAIM.md`'s permitted claim; state that in this core the verdict is a stranger's check
   and gates nothing inside the core; and state that it checks nothing unless a head is actually retained outside
   the subject (who retains it is the witness question, not solved by this round).
4. A checkpoint text for (origin, size, root) in the three-line shape public transparency logs use (see the
   alignment file, section A), so an existing witness could co-sign it later. Do not implement witnesses.

## B. The permit and its offline verifier (the build that matters)
1. PERMIT = act frame + its position + inclusion proof + the checkpoint it verifies under + the law-set identity
   and core file digest of the admitting core. Expiry is DATA in the permit (the grant's expiry and the checkpoint
   size), never state in an issuer: a stranger who never saw the session must be able to decide "expired".
2. No sub-permits in this version: a permit names exactly one act and conveys nothing further. Say so in `WIRE.md`.
3. A VERIFIER as a separate tiny Wasm file (and the same function in Lean) with NO record access: input permit
   bytes plus a trusted checkpoint; output one of a CLOSED, fixed list of verdicts, each distinguishable offline:
   VALID, MALFORMED, NOT-INCLUDED, WRONG-CHECKPOINT (permit is under a head that is not a prefix of the trusted
   one, with the consistency proof missing or failing), EXPIRED, REVOKED-OR-SPENT-UNKNOWN (say honestly what a
   stranger CANNOT know from a permit alone and how a fresher checkpoint changes the answer), WRONG-LAW-SET.
   Laws: V1 VALID only for an act the step function admitted at that position; V2 the verdict is a total function
   of (permit, checkpoint); V3 each refusal verdict has a witness input (the list has no dead entries).
4. Refusal receipts (optional recorded event; check the alignment file's agent-receipt drafts and say whether any
   defines one): the host MAY append `refused(digest of the refused frame, reason code)`; the core admits it only
   if that exact frame IS refused in the state just before (round 11's host-halt already re-checks a quoted act;
   reuse it). Law: no refusal receipt exists for a frame the core would have admitted. A judge that records only
   what it admitted cannot be audited for what it refused.

## C. Attacks to run and report (defensive, on our own files)
A permit replayed under an older checkpoint; a permit for position i presented with the proof for position j; a
proof with one sibling changed; a checkpoint with the right root and wrong size; an act frame changed in one bit;
two different records with the same origin (split view): show what the verifier can and cannot detect without a
witness, in one paragraph.

## D. Cell results cannot be mixed across versions (from the outside reviewer; small)
If the newest folder has the `cell` event: an act that cites cell results must cite results whose pin digest all
match one recorded pin for that cell name at that point; a mismatch is REFUSED, never merged. One law, 30 vectors.
If the `cell` event does not exist yet, skip D and say so.

## E. Bind approvals to the record, and answer the outside implementer (read `WIRE-ERRATA-v0.1.md` first)
1. RECORD IDENTITY: genesis takes the owner keys plus a 32-byte value supplied by the host; the record
   identifier is SHA-256 of both; it is the checkpoint's origin in A.3; EVERY owner signature covers it. A plain
   approval also covers the head and sequence it was issued under, as the timed approval already does. Laws: an
   approval signed for one record is refused by every record with a different identifier; within a record the
   existing once-only law is unchanged. Vectors: the second seat's cross-record replay
   (`logs/breakit-grok/replay-control.mjs`: ADMITTED today) must be REFUSED.
2. Say plainly in `NOT-PROVED.md` what this cannot fix: a host that rolls a record back and replays the same
   frames gets the same admissions; a witness and a permit check are what stop a double effect.
3. `WIRE.md` must answer all 14 findings in `WIRE-ERRATA-v0.1.md` in its own text (generation start and
   increment, Ed25519 acceptance rules with vectors for non-canonical S and small-order keys, claim-id rules,
   spend/read/mandate matching and the expiry clock, direct acts always need an approval, the threshold applies
   to mandate acts, what retract and renew do, the 1b target). Add vectors for every rule the corpus does not
   pin, including a valid Ed25519 signature with a bad ML-DSA signature and the reverse.
4. Refusal words (docs only; an outside reviewer points at two Internet-Drafts on agent routing policy and
   bounded capability receipts, UNREAD by this lab): keep our closed verdict list; add one table mapping each
   verdict to the nearest term in any standard or draft YOU can cite from the alignment file; take no dependency
   on draft text nobody here has read. State in one line that the succession proofs are mechanically checked
   (a kernel-checked entailment carried with each upgrade), not asserted.

## Deliverables
`REPORT-R13.md` (two pages at most; first line: `MERKLE HEAD: laws n of 5` and `PERMIT VERIFIER: built yes/no,
bytes, verdicts k, laws n of 3` and `REFUSAL RECEIPTS: built yes/no` and `ATTACKS: n run, f findings`),
`logs/R13-CHECKS.txt`, the new release folder with `PROVED.md`, `NOT-PROVED.md`, `WIRE.md`, vectors. Keep failures.
