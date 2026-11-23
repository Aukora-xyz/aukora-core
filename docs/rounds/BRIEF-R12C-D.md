# BRIEF, round 12c part D, for ONE Claude coder (from Mythos, 23 November 2026): bind every owner signature to its record

You are the Lean builder for this one job. Mythos (the core's specialist seat) verifies your result afterwards with
its own harness; another seat rebuilds it. Write only what a Lean kernel accepted as CHECKED. Plain words in reports.

## The defect you are closing (RAN by Mythos on v0.1 and v0.3; the wire for it is unchanged in v0.4/v0.5)
An owner approval is not tied to one record. The owner's two signatures on an approval (tag 13) cover a domain
string, the owner keys and the intent, and nothing that names the record. A second record started with the same
owner keys admits the same approval bytes. Reproducer: `logs/breakit-grok/replay-control.mjs` (prints ADMITTED).
Background: `WIRE-ERRATA-v0.1.md`, `V04-ADDENDA-MYTHOS.md`, `v0.5/NOT-PROVED.md` item on record binding,
`BRIEF-R12C.md` section D (this brief replaces that section and narrows it).

## Rules that bind you (read all of them before the first command)
- Work only in `~/aukora-memory/scratch/lean-core-lab-2026-11-22`. Build in a NEW folder `v0.6/`.
  Make it with `python3 fork-release.py v0.4 v0.6` (fork from v0.4, NOT from v0.5: the tool refuses a source that
  already carries its build hook; v0.4 and v0.5 are the same machine). Do not touch `v0.1/` to `v0.5/`, `_export/`,
  `standalone/`, `context-membrane/`, `governed-rsi-v0/`, any brief, or anything outside this folder. No git
  commands that change anything. No downloads. No windows. Publish nothing. Do not open any key, `.env` or
  recovery-word file anywhere on this machine.
- ONE Lean process at a time on this Mac, shared with other seats. Take the lock before any Lean job and release
  it when that job ends, pass or fail. Never hold it while you are reading or thinking. Never delete a lock that
  is not yours; if it is held, wait and re-check, and tell the lead if it is older than 60 minutes.
  ```sh
  ( set -o noclobber; echo "HOLDER=CODER START=$(date '+%F %T') JOB=<what>" > LEAN-JOB-HOLDER.txt ) || { echo "SLOT HELD"; cat LEAN-JOB-HOLDER.txt; }
  ```
  ```sh
  rm -f LEAN-JOB-HOLDER.txt
  ```
- Memory: 4 GB per Lean job. Use the release's own tools (`v0.6/tools/*.py`, `sh v0.6/build.sh`), which load the
  memory option. A bare `lean -M 4096` is REJECTED by this toolchain; a bare `lean` run must have
  `python3 memwatch.py 4096 600 &` running first. A proof that needs more than 4 GB is a FINDING (file, statement,
  peak), not something to retry larger. Never retry a killed job unchanged. `-j1` always.
- Stop any single check or test that passes 12 minutes and report it. The full build takes about 11 minutes.
- Never weaken a law, a test, a vector or a limit to get a pass. Never use `sorry`, `native_decide` in a law
  proof, or a new axiom. If something cannot be proved, say so with the exact obstacle; that is a result.
- Two lessons this lab paid for twice: never ratchet a promise that something ALWAYS SUCCEEDS; never ratchet a
  clause that NAMES A VERSION. Read `REPORT-R11-MYTHOS.md` and `REPORT-R12-MYTHOS.md` (ten minutes) before you
  design; this job can repeat both mistakes.

## Step 1 (no Lean yet): a design card, written to `logs/R12C-D-CARD.md`, one page
The 37 laws of `v0.4/RootFinal.lean` must hold UNCHANGED of the new machine, and old records must still replay
(growth law W1: a frame that decoded under an earlier wire version decodes to the same event later). So the new
machine may not simply refuse the old unbound owner frames everywhere. Say how binding composes. The candidate
Mythos expects to work, to be confirmed or refuted against the actual law text:
1. RECORD IDENTIFIER. A bound genesis takes the owner keys plus a 32-byte host value. The identifier is SHA-256
   of a new domain string, the initial law digest, the initial keys and that value. It never changes for the life
   of the record: not on a key change, not on a seal and continuation (the continuation descriptor carries it).
2. BOUND OWNER FRAMES. A new wire dialect for EVERY owner-signed frame (approval, timed approval, cancel,
   threshold, key change, halt and clear, install intent, seal): same fields, and both signatures cover the
   record identifier under new domain strings, so a signature of one form can never verify as the other.
3. BINDING AS A ONE-WAY OWNER RULE. A record in bound mode refuses every unbound owner frame. A record started
   by a bound genesis is in bound mode from its first line. This must enter through the laws' existing
   availability exception for a recorded owner rule (rules only restrict), not by redefining what a valid frame
   is. A record started the old way stays in the old mode (so every existing vector replays to the same head);
   whether such a record may switch to bound mode by a signed owner frame is OPTIONAL: do it only if it is small.
4. NOT IN THIS JOB: binding an approval to the head it was issued under. Unsigned speech could then starve
   approvals. Write two sentences in the card on the alternative (the approval names a head that must be an
   ancestor of the current one) and what state it would cost. Do not build it.
The card ends with: which of the 37 statements mention owner frames, and for each, one line on why it still holds
with the bound dialect added. If the candidate cannot satisfy a statement, STOP after the card and say which one.

## Step 2: the machine, the law, the proofs (in `v0.6/`)
- Law R1 (new, added to the set; the set becomes the 37 plus the new ones, the 37 textually unchanged): in a
  record in bound mode, an owner frame is admitted only if both signatures verify over that record's identifier;
  so an owner frame signed for a record with a different identifier is refused. State it over the model's step
  function. Add R2 if you need it: the identifier is constant along every reachable history, across key change
  and across seal and continuation.
- `theorem full_lawful : Lawful fullModel` for the new set, accepted by the kernel. One machine, one theorem.
- The hash assumptions you use are named hypotheses, as in the existing files; no new axiom.

## Step 3: Wasm, vectors, tests
- `sh v0.6/build.sh` ends `PASS v0.6` with new pins. Both profiles (full and lite).
- Every existing vector and test of the release passes UNCHANGED (old-mode records replay to the same heads).
- New vectors and one Node test `v0.6/tests/record-binding.mjs`, on both profiles: two bound records with the
  SAME owner keys and different host values; an approval, a timed approval, a cancel, a threshold change, a key
  change and a seal signed for the first are each REFUSED by the second, head unchanged; each is ADMITTED by the
  first; an unbound owner frame is REFUSED by a bound record; a bound frame is refused by an old-mode record; a
  bound record replays to the same head in a fresh instance; the identifier is the same before and after a key
  change and after seal and continuation.
- `v0.6/WIRE.md` documents the dialect byte for byte, with the per-version table of which (frame kind, state)
  pairs change verdict and which law says so. `v0.6/EXPORTS.md` documents any new export.

## Deliverables
- `REPORT-R12C-D.md`, one page. First line exactly:
  `RECORD BINDING: law yes/no; one machine, n laws, composed yes/no; old records replay yes/no; cross-record replay refused yes/no`
  Then: what is CHECKED (kernel), what RAN (Wasm tests with counts), what is NOT done, peak memory of the largest
  job, every theorem you added with its axioms, and anything you could not prove with the exact obstacle.
- `logs/R12C-D-CARD.md`, `logs/R12C-D-CHECKS.txt` (the commands and their last lines), the `v0.6/` folder with
  `PROVED.md` and `NOT-PROVED.md` updated (move the record-binding item from not proved to proved only if
  `full_lawful` was accepted; add "a rolled-back copy of the SAME record still admits an unspent approval again;
  only an outside witness shows it" to `NOT-PROVED.md` in those words).
- Leave no process running and no lock held. Delete `v0.6/.work` only if the report records the final digests.
If time or allowance runs short: the card, R1 stated, and an honest report beat a half-built folder.
