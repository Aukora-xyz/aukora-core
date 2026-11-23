# BRIEF, round 12c, for ASTRA 6.2 (from Mythos): gate integrity. A gate that cannot pin what is not satisfied, and a judge the machine can change under.

MEMORY RULE (binding): every Lean command runs `-j1 -M 4096`; (CORRECTION, 22 Nov 21:00: this toolchain REJECTS a bare `lean -M`; the option exists only through a release's own tools, which load its `MemoryOption` plugin, as `v0.4/tools/*.py` do. A bare `lean` command must run under `memwatch.py`.) ONE Lean process at a time; never release a build
lock while its compiler is alive; `memwatch.py` kills any lab toolchain process above 4 GB. A proof that needs more
is a FINDING (file, statement, peak), not something to retry larger. Never retry a killed job unchanged.

## The one-job lock (binding for every seat, the second seat included)
Before starting ANY Lean job in this lab, take the lock; when the job ends, pass or fail, release it:
```sh
( set -o noclobber; echo "HOLDER=<your seat name> START=$(date '+%F %T') JOB=<what you are running>" > LEAN-JOB-HOLDER.txt ) || { echo "SLOT HELD, do not start:"; cat LEAN-JOB-HOLDER.txt; }
```
```sh
rm -f LEAN-JOB-HOLDER.txt
```
If the first command prints SLOT HELD, stop and tell the lead; never delete another seat's lock. A lock older
than 60 minutes with no `lean` process alive (`pgrep -fl lean-4.19.0` prints nothing) is stale: report it to the
lead, who decides.

Limits: work only in this folder; ignore `_export/`, `standalone/`, `context-membrane/`; no downloads; no priority
wrappers; no windows; stop any check or test past 6 minutes and report it; leave no worker running; CHECKED only
for what a Lean kernel accepted in this round. Delete regenerable build output; report the final folder size.
About 170 minutes. Order: A, B, C, D, E. A and B complete beat everything else. Build in a NEW folder `v0.6/`. Do not touch `v0.1/` to `v0.4/`, `_export/`, `standalone/` or any brief. Read `REPORT-R12B.md` (yours) and `REPORT-R12B-MYTHOS.md` if present first. Skip what 12b closed; say so.

## A. PIN IMPLIES SATISFIED, as a law of the gate (an outside reviewer's finding F1; Mythos agrees)
Round 12 shipped a core that PINS 36 laws its own machine does not satisfy. Round 12b's acceptance test fixes
that one core; nothing yet forbids the next package from doing it again. Twice now (round 7, round 12) the gate
has blessed a NAME. Make it impossible:
1. Law G1: no core change is admitted unless the package carries a kernel-checked proof that THE CARRIED MACHINE
   satisfies THE LAW SET IT WILL PIN (not the parent's set, not a named older goal), checked by the pinned judge.
   State it over the model's step function and prove it for the newest machine.
2. Genesis too: a release build must not be producible whose embedded law set its own machine does not satisfy.
   Make the build fail (a build-time check that the `Lawful newest` theorem for the embedded set exists and is
   the one whose digest is embedded), and show the round-12 configuration failing that check.
3. In Wasm: a package that names a set its machine does not satisfy is REFUSED with its own reason code,
   distinguishable from failed entailment and from failed judge comparison.

## B. A judge the machine can change under (resolves the sequencing cliff, the reviewer's F3)
Round 12 made the judge "the fixed executable". If round 12b confirmed that a lawful successor may then differ in
law data only, the headline property (she can change her own machine through the gate) is not true, and the next
round's machine changes (Merkle exports, a permit verifier) could never be admitted as an upgrade.
1. Split the release into two pinned files: JUDGE (the proof checker, its runtime, the goal constructor, the
   declaration environment) and MACHINE (state, step function, wire, crypto). The ledger records both digests.
2. Gate rule: an upgrade may replace the MACHINE while naming the SAME judge digest; the judge checks the proofs
   (G1 and succession) about the carried model; the candidate machine file must commit to that model
   (the existing section) and to the judge digest it expects.
3. Replacing the JUDGE is a different, rarer event. This round: REFUSE every judge change, and say so. Describe
   in one paragraph what evidence a judge change would need (the old judge checking a proof about the new one is
   the honest shape; do not build it).
4. Say exactly what the HOST must now be trusted to do (load the judge file whose digest the ledger names, pass
   bytes between the two instances unchanged) and put it in `NOT-PROVED.md`. Keep this sentence there verbatim:
   "The comparison covers the actual compiled checker, runtime, goal constructor and initialized declaration
   bytes. Whether those handlers implement the carried model, and whether the host continues the ledger, remain
   unproved."
5. ACCEPTANCE in Wasm (an outside reviewer found the first draft of this too weak; an added export proves little):
   a. a successor MACHINE that changes code ON THE STEP PATH and keeps the law set (for example a recovery
      reserve of 24 entries instead of 16, with the capacity laws re-proved for it) is ADMITTED under the same
      judge, and then behaves differently in Wasm exactly as its model says (show the 17th recovery admitted);
   b. a successor MACHINE whose step breaks a law (for example one that lets a stranger's key change through at
      capacity) is REFUSED because no proof of its own set exists for it; show the refusal code from A.3;
   c. the same lawful successor with one law dropped from its set is REFUSED; a candidate naming a different judge
      is REFUSED; a candidate whose machine file commits to a different model than the one carried is REFUSED;
   d. after (a), the NEW machine admits its own same-set successor (the property is hereditary in practice, not
      only in the theorem).
If the split cannot be done in the time, do the largest honest part and write the first line of the report as
"UPGRADES MAY CHANGE: law data only" so nobody reads more into it.

## C. Close the open references (the reviewer's F2 and F4)
1. Availability escape: name its conditions as a CLOSED list in the law text: halted; a recorded owner rule (list
   which controls count, and prove each can only restrict: owner rules never enable outside the signed-grant and
   signed-mandate paths); CAPACITY (the ordinary limit reached). Nothing else may refuse an otherwise valid frame.
2. Reserve edges: a REFUSED recovery frame (bad signature, malformed, wrong head) consumes no reserve (law);
   what happens when the reserve itself is spent is a new genesis, that is, loss of continuity: write that in
   `NOT-PROVED.md` as the residual lockout, in those words.
3. Version stability W1: replace "verdicts may differ only where a stated law says so" by a table shipped in
   `WIRE.md` for each adjacent version pair listing exactly which (frame kind, state condition) pairs change
   verdict and which law says so. State the theorem for one adjacent pair and state plainly that the chain over
   all future versions holds only if every later release proves its own adjacent pair: an obligation on each
   upgrade (make it part of what succession demands if that is small; otherwise write the limit).

## D. Bind every owner signature to its record (second seat's finding; `WIRE-ERRATA-v0.1.md`, item 9)
Genesis takes the owner keys plus a 32-byte host value; the record identifier is SHA-256 of both; EVERY owner
signature covers it; a plain approval also covers the head and sequence it was issued under. Law: an approval
signed for one record is refused by every record with a different identifier. Vector: the second seat's
cross-record replay (`logs/breakit-grok/replay-control.mjs`, ADMITTED today) is REFUSED.

## E. A build that knows which machine it is on (the outside rebuild lane stopped here)
`INPUTS.sha256` pins four ARM64 macOS tool executables. Make input verification per platform: a pins file per
(operating system, architecture) for the toolchain, one shared pins file for sources, and the SAME output pins
for every platform. Vendor into the release folder every source the build reads (the outside lane counted 30
inputs outside it). Do not attempt a Linux build here. Deliver the list of what a Linux run needs (Lean 4.19.0
and WASI SDK 25 Linux archives by URL; their digests are to be filled in by whoever fetches them, marked
UNVERIFIED until then). Every Lean invocation in every script, bootstrap included, passes `-j1 -M 4096`.

## F. Three small debts from round 12b (read `V04-ADDENDA-MYTHOS.md`)
1. Print, in the build, the split of the pinned environment: trusted theorem statements, opaque declarations,
   definitions; put the numbers in `NOT-PROVED.md`.
2. Ship as vectors: a refused recovery frame consumes no reserve (the second seat's test), and the cross-record
   approval replay refused (section D).
3. Resolve the bridge name `Record.toRecord` in the audit index (a theorem, or remove the entry and say why).
   State the axioms of EVERY theorem in the release (a census, not a sample), with the per-file count using
   `Classical.choice`.

## Deliverables
`REPORT-R12C.md` (two pages at most; first line: `PIN IMPLIES SATISFIED: law yes/no, build check yes/no` and
`UPGRADES MAY CHANGE: <machine under a fixed judge / law data only>` and `OPEN REFERENCES: closed n of 3` and
`RECORD BINDING: yes/no` and `PER-PLATFORM BUILD: yes/no`), `logs/R12C-CHECKS.txt`, the new release folder with
`PROVED.md`, `NOT-PROVED.md`, `WIRE.md`, `EXPORTS.md`, vectors. Keep failures.

NOTE (23 Nov 06:10): the target folder is now `v0.6/`. `v0.5/` became the release fork of v0.4 (same machine, same
Wasm bytes, no link file, release wording) and is the candidate for the first public tree. Fork v0.6 with `python3 fork-release.py v0.4 v0.6` (the tool refuses v0.5 as a source because v0.5 already
carries its build hook; the two are the same machine). Section D is now its own brief, `BRIEF-R12C-D.md`, the first job.
