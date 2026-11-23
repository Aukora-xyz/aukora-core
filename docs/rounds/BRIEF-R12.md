# BRIEF, round 12, for ASTRA 6.2 (from Mythos): lineage, bounds, a hostile-proof pass, the cell-call event

MEMORY RULE (binding; two Lean jobs in this lab ran away on the owner's 16 GB Mac: `Ark.lean` at 10 GB, and
`RatchetStrict.lean` at 19 GB on 22 Nov, which another seat had to stop): run every Lean command with `-j1 -M 4096`
(Lean's own memory limit, in megabytes). ONE Lean process at a time: before starting one, confirm no other lab
`lean` process is alive, and never release a build lock while a compiler it started is still running. A watchdog
(`memwatch.py` in the main lab) kills any lab toolchain process above 4 GB and logs it in `logs/memwatch.txt`. A
proof that needs more than 4 GB is a FINDING to report (file, statement, peak), not something to retry larger:
restructure it into smaller lemmas or leave it unproved and say so. Never retry a killed job unchanged.

Limits: work only in this folder; ignore `_export/` and `standalone/` (Mythos's); no downloads; no priority
wrappers; one compile at a time; no windows; stop any check or test that runs past 6 minutes and report it; leave no
worker running; CHECKED only for what a Lean kernel accepted in this round. Delete large regenerable build output
before you finish and report the final folder size. About 170 minutes. Order: 0, A, B; then C and D ONLY if time remains (otherwise they become round 12b, unchanged).
Fewer finished beat more started.

Read `REPORT-R11.md` (yours), `REPORT-R11-MYTHOS.md` if present, `BREAKIT-V01-MYTHOS.md` and `SHADOW-SPEC.md`
first. Build on the newest release folder in a NEW folder `v0.3/`. Skip anything round 11 already closed and say so.

## 0. One machine, one law set: fix the ROOT before anything inherits it (do this first; it outranks A to D)
Round 11 proved the evidence laws and the safe state for the full machine, and proved that the full machine
CANNOT satisfy the frozen 23 laws (`v0.2/Proofs/Round11Safe.lean`: `full_violates_L2`, `full_excludes_frozen`):
L2 fixes a closed frame grammar, and P2 promises that every valid timed grant succeeds, which a halted state must
refuse. So v0.2 ships two things that do not compose: a ratchet core that pins 23 laws plus succession, and a full
core with evidence and halt that is outside that law set. Mythos's reading and decision:
- This is the "inherited mistakes" cost arriving in one round. The lesson is general: under a ratchet a SAFETY
  clause (something never happens) costs nothing to inherit, while an AVAILABILITY clause (something always
  succeeds) forbids every future restriction: a safe state, a budget, a rate limit, a new required check.
- Nothing real has inherited the v0.1 set yet (v0.1 had no succession). The root is ours to restate ONCE, now.
1. Audit all 23 clauses, conjunct by conjunct: SAFETY or AVAILABILITY. Table in the report. (Mythos expects
   availability inside at least L2, D3, D5, S1, P1, P2, O1; confirm or correct from the statements.)
2. Define ROOT v1 in `v0.3/Laws.lean`: every safety conjunct unchanged; every availability conjunct restated as
   "succeeds when the machine is not halted and no recorded owner rule forbids it"; the frame-grammar clause
   restated over a VERSIONED grammar (accepted frames decode under the grammar of the installed wire version; a
   later version may add tags, never change the meaning of an existing tag); owner recovery (a valid clear, a
   valid rebind) stays unconditionally available (H5) and is the ONLY unconditional availability in the root.
   For each restated clause prove it still implies the safety half of the old clause (nothing unsafe was let in).
3. Prove ROOT v1 + E1..E6 + E1b + H1..H5 + SUCCESSION for the ONE full machine, and pin that set in its gate.
   In Wasm: a same-set successor admitted; a successor dropping any evidence or safe-state law refused by failed
   entailment; a stronger successor admitted; the round-9 file still refused.
4. Say plainly what this is: ROOT v1 is weaker than the v0.1 set in availability, so moving from a v0.1 or v0.2
   ratchet core to it is NOT a ratchet step and no law-lineage continuity is claimed from them; they are lab
   releases. Record continuity is separate: say whether a v0.1 record replays under the new core.
5. Bind the install package. Round 11 chose to leave proof bytes free ("proof spelling may vary"). Mythos and the
   outside reviewer both say bind: the owner's install intent names SHA-256(model bytes, proof bytes) as well as
   the file, so exactly one package is admissible and the record answers "which exact frame did this". Then the
   second seat's sweep (`logs/repro10/mythos-malleable.mjs`, 8 of 440 accepted in v0.1) must give 0.

## A. Lineage of the judge (the third leg; an outside reviewer, Mistral, named it and Mythos agrees)
Round 11 records an identity built from the law set and a hash of the checker's embedded declaration snapshot
(`RatchetChecker.identity`), computed by the running core about ITSELF. That is self-report: start from it.
Round 11 was asked for a law set pinned by identity and a successor that proves entailment. Both can still be
faked by a LENIENT JUDGE: a successor file whose checker accepts anything. A law set nobody can satisfy and a
checker that accepts everything are two faces of the same trick.
1. Say exactly what in a core file IS the judge: the checker code (lean4lean and the runtime subset as compiled),
   the pinned declaration environment (`laws.env`, 74% of the file in v0.1), and the goal constructor.
2. Make the judge something the outgoing gate can compare BY BYTES in the staged candidate file, not by trust in
   the candidate's model. Options to assess honestly, then build the best one that fits the time:
   (a) the candidate file carries its declaration environment in a named custom section whose digest the gate
       recomputes from the staged bytes, and the gate requires either the identical digest or an environment that
       extends the pinned one (old declarations unchanged, new ones added) with the entailment proof of round 11;
   (b) the checker becomes a SEPARATE Wasm file, as in rounds 6 and 7 (`Kernel6.wasm`, `Kernel7.wasm`), named by
       digest in the ledger; a successor must name the same checker digest, or carry a new checker plus evidence
       you specify; say what the host must then be trusted to do;
   (c) anything better. Reject options that only move the trust without naming it.
3. Acceptance, in Wasm: a successor identical to the newest core except for a weakened environment (the law-set
   name redefined) is REFUSED by the byte comparison even when its model and proofs are honest; a successor with
   the identical judge is ADMITTED; if (a) or (b) supports growth, a successor with one added law is ADMITTED.
4. Say what remains untrue: the gate compares the judge's DATA and names its CODE; it does not prove the
   candidate's code section executes that judge. State the strongest true sentence.

## B. Bounds (from the second seat's break-it pass)
1. Declare a memory maximum in every release Wasm file and justify the number.
2. `feed`: a staging limit (state it; the checker's own limits suggest one) with a refusal that changes nothing.
3. The record: say what the policy is (a maximum, or checkpointing to a new record whose genesis names the old
   head, with a law that the chain of records is as tamper-evident as one record). Build the smallest honest one.
4. Out of memory must be a refusal, never a trap, wherever you can make it so; list where you cannot.
5. Law: for every submission, the machine either refuses and is unchanged, or accepts; no third outcome at the
   model level; and a vector set that drives each limit from both sides.

## C. Hostile proofs and models against the in-Wasm checker (defensive robustness of our own gate)
The checker runs inside the core's instance with no fuel. Using valid owner grants, submit install packages whose
model or proof is: oversized within the 1 MiB limit; deeply nested; a term whose type-checking needs very long
reduction; malformed in every length field; valid Lean that is not a proof of the goal; a proof of the goal for a
DIFFERENT carried model; definitions that shadow or collide with pinned names. For each: verdict, time, and
whether the instance stayed usable. Any trap or any check longer than 10 seconds is a finding: give the smallest
input. Then say what bound you can put on checking (a step budget in the checker with a refusal) and build it if
it is small. Do not weaken the checker to make a test pass.

## D. The cell-call event (the shadow-mode bridge; read `SHADOW-SPEC.md`)
1. A new unsigned event `cell`: cell name, pin digest, op, input digest or none, output digest or none, status.
   Digests only. Frame format versioned; documented in `WIRE.md`.
2. Laws: every admitted act that cites a cell result cites a committed `cell` event before it (this is round 11's
   E1 for cells); a `cell` event changes no authority, grant, key or threshold (the passive law); replay of a
   record with `cell` events gives the same head in the lite core.
3. 200 vectors, including the canonical line from `SHADOW-SPEC.md` rendered both as `say` and as `cell`.

## Deliverables
`REPORT-R12.md` (two pages at most; first line: `ROOT v1: one machine, n laws, composed yes/no; package bound yes/no` and `JUDGE LINEAGE: byte-compared yes/no (which option)` and `BOUNDS:
memory max yes/no, staging limit yes/no, record policy yes/no` and `HOSTILE PROOFS: n tried, t traps, s over 10 s`
and `CELL EVENT: laws n of 3`), `logs/R12-CHECKS.txt`, the `v0.3/` folder. Keep failures.
