# BRIEF, round 12b, for ASTRA 6.2 (from Mythos): finish the root. One machine, one law set, one admitted successor.

MEMORY RULE (binding): every Lean command runs `-j1 -M 4096`; ONE Lean process at a time; never release a build
lock while its compiler is alive; `memwatch.py` kills any lab toolchain process above 4 GB. A proof that needs more
is a FINDING (file, statement, peak), not something to retry larger. Never retry a killed job unchanged.

Limits: work only in this folder; ignore `_export/`, `standalone/`, `context-membrane/` (read-only context); no
downloads; no priority wrappers; no windows; stop any check or test past 6 minutes and report it; leave no worker
running; CHECKED only for what a Lean kernel accepted in this round. Delete regenerable build output; report the
final folder size. About 170 minutes. Order: A, B, C, D. If time runs out, A complete beats everything else.
Build in a NEW folder `v0.4/`. Read `REPORT-R12.md` (yours) and `REPORT-R12-MYTHOS.md` if present.

## What round 12 established, and whose mistake it was
The full machine cannot satisfy ROOT v1 as round 12's brief specified it. That brief (Mythos's) said "every safety
conjunct unchanged" and assumed the closed frame grammar lived only in L2. Your counterexamples
(`v0.3/Proofs/Root12Conflict.lean`) show it also lives inside D5 and P1 (every admitted non-install frame must
decode under the old grammar), in H2 (a key change must be a LEGACY rebind), in L10 (an exact finding list), and
that L8 pins the OLD checker goal. So the lesson has a second half:
- (round 11) Do not ratchet a promise that something ALWAYS SUCCEEDS.
- (round 12) Do not ratchet a clause that NAMES A VERSION: of the wire grammar, of a rule or risk grammar, of a
  finding list, or of the checker's goal. A ratcheted law must speak of "the installed version", with a law about
  how versions may grow.
The result today: the full Wasm pins 36 laws that its own machine does not satisfy, so the full machine can never
have an admitted successor. That is a dead end, not a release.

## A. ROOT v1, final (the whole round turns on this)
1. Go through all 36 clauses once more with a third column beside S and A: V = names a version. List every
   conjunct that is V. (Known: L2, D5, P1, H2, L10, L8. Find the rest; say if there are none.)
2. Restate every V conjunct over the INSTALLED version:
   - Wire: each core has a wire version set; "decodes under the grammar" means under the installed set. Add the
     growth law W1: a later version set includes the earlier one, and a frame that decodes under an earlier
     version decodes to the SAME event under every later one (verdicts may differ only where a stated law says
     so, for example a halted machine). Prove W1 for version 01 inside version 02.
   - Rule, risk and finding lists: the same treatment; a later version may add kinds, never reinterpret one.
   - L8: "a core change checks the carried model and both certificates under THE PINNED JUDGE and the CURRENT
     law set's goal", not a named older goal. Tie it to round 11's succession and round 12's judge comparison.
   - H2: a key change requires both current signatures on an owner key-change frame of the installed version.
3. For each restated conjunct, prove the bridge: restricted to version-01 frames and an unhalted machine, the
   new statement implies the old one. Nothing that was unsafe becomes allowed. List any conjunct where the
   bridge fails and why.
4. ACCEPTANCE (all four, in Wasm, or the round reports "composed no" again with the exact obstacle):
   a. `Lawful fullModel` for ROOT v1 final, accepted by the kernel: ONE theorem, the full machine.
   b. The full Wasm pins that set, and a SAME-SET successor of the full machine is ADMITTED (transition and
      satisfaction both pass). Round 12 had "passed transition, failed satisfaction".
   c. Each of the one-law omissions is refused; a stronger set (one added law) is admitted; the round-9 file
      and a weakened judge are refused.
   d. Count and name the laws. Ship `v0.4/PROVED.md` and `v0.4/NOT-PROVED.md` (round 12 shipped neither).

## B. The capacity lockout (found by reading your own report; this breaks H5 as built)
Round 12: "the same signed clear succeeded with room and failed at capacity". A halted machine whose record is
full can then never be cleared, and a full record can never rebind: a lockout with no key lost.
The second seat confirmed it with its own frames (`logs/repro12/mythos-capacity.mjs`): after 512 accepted lines
a valid owner approval, threshold control and KEY CHANGE are all refused. Worse: speech needs no signature, so
ANY caller can fill the record with free lines and freeze the owner out for good. Fix:
1. RESERVE: ordinary frames stop at the ordinary limit; a fixed reserve (say 16 entries and enough bytes for
   16 of the largest owner frames) is usable ONLY by valid owner recovery frames (clear, rebind, and the
   seal below). State H5 with capacity in it and prove it: from every reachable state, a valid clear or rebind
   is accepted, including a state at the ordinary limit. Say what happens when the reserve itself is spent.
2. SEAL AND CONTINUE: an owner-signed `seal` closes a record; a new record's genesis names the sealed head, the
   law identity and the owner keys. Laws: a sealed record admits nothing further; a continuation's genesis is
   valid only for the named head; tampering with any earlier record of a chain changes every later genesis (the
   chain is as tamper-evident as one record, under the named hash hypothesis); authority that had expired or
   been revoked does not come back across a seal; a halt carries across a seal.
3. Say plainly whether 512 entries and 2 MiB are lab numbers or meant; justify the numbers you ship.

## C. What can an upgrade still change? (one page, then the smallest build)
Round 12 chose "fixed executable" for the judge: a successor must match the compiled checker, runtime, goal
constructor and declaration bytes. State exactly what a lawful successor MAY differ in after that (law data?
machine code? neither?). If the answer is "nothing executable", then say so in the first line of the report:
the gate today admits changes of law data only, and changing the machine needs a mechanism not yet built
(a judge kept as a separate pinned file, with the machine free to change under it, is the candidate; assess it
honestly, including what the host must then be trusted to do). Do not build it this round unless A and B are done.

## D. Carry forward unchanged (verify they still pass; no new work)
Package binding (0 of 440 proof changes accepted), the memory maximum and staging limit, the 21 hostile proof
cases, the three cell laws and 200 cell vectors, v0.1 record replay.

## Deliverables
`REPORT-R12B.md` (two pages at most; first line: `ROOT v1 FINAL: one machine, n laws, composed yes/no; same-set
successor admitted yes/no` and `VERSIONED CLAUSES: k restated, bridges n of k` and `CAPACITY: recovery reserved
yes/no, seal-and-continue yes/no, laws n` and `UPGRADES MAY CHANGE: <one phrase>`), `logs/R12B-CHECKS.txt`, the
`v0.4/` folder with `PROVED.md`, `NOT-PROVED.md`, `WIRE.md`, `EXPORTS.md`, vectors. Keep failures.
