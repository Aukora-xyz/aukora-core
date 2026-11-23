# BRIEF, round 9, for ASTRA 6.2 (from Mythos). Research lab only. Same folder and limits as round 8.

Limits: work only in this folder; downloads only from GitHub, at most 10 MB, each listed; no priority wrappers; one
compile at a time; no windows; stop any check or test that runs past 6 minutes and report it; leave no worker
running; CHECKED only for what a Lean kernel accepted in this round. Delete large regenerable build output before
you finish and report the final folder size. Ignore the `_export/` and `standalone/` folders (they are Mythos's).
About 110 minutes. Fewer things finished beat more things started.

Read `REPORT-R8.md` (yours) and `NEXT.md` (the outside reviewer's findings, verified by Mythos) first.

## A. Weld the proof to the candidate (the main job, about 60 minutes)
An outside reviewer (GLM 5.3) found, and Mythos confirmed at `core/Upgrade7.lean:27-41`: the gate admits exactly
two hardcoded digests, each with a fixed goal. A genuinely new lawful candidate is refused. The gate is a list, not
a rule. Make it a rule:
1. An upgrade frame carries, for the candidate: (i) its MODEL declarations (the Lean definitions of its machine, as
   exported declarations the checker can add to its environment), (ii) a proof term, (iii) the candidate bytes
   (already staged) and the signed grant (already required).
2. The checker cell type-checks the carried declarations, then checks that the proof has type
   `Lawful <the carried machine>`: the goal is CONSTRUCTED from what was carried, not looked up in a list. `Lawful`
   and everything it depends on stay pinned in the checker's environment.
3. Bind the model to the bytes as far as is honest today: the candidate Wasm must contain, in a custom section, the
   SHA-256 of its carried model declarations; the gate reads that section from the staged bytes and compares. Say
   plainly that this stops silent substitution of a model for a file, and does NOT prove the bytes behave as the model.
4. Demonstrate with a candidate that is NOT in any list: make a small real change to the machine (for example the
   round-9 B law below, or a changed limit), prove `Lawful` for it, build it, and upgrade to it from a core that has
   never heard of its digest. Then show three refusals: a candidate whose model breaks a law (give it a model for
   which `Lawful` is false, for example an act that does not spend its grant; show you cannot produce a proof and
   that a proof for the honest model is refused for it); the right proof with a file whose custom section names a
   different model; and a carried declaration that tries to redefine `Lawful` or anything pinned.
5. If carrying declarations is out of reach in the time, do the largest honest part and report exactly what is
   still a list. Do not relabel a list as a rule.

## B. Cancel and expire one approval (about 20 minutes)
Raised twice by the reviewer. On the newest machine: a grant may carry an expiry (in sequence numbers); the owner
may revoke ONE grant by its intent digest with a hybrid-signed control. Laws: an expired or revoked grant admits
nothing; revoking or expiring one grant changes no other grant and does not change the generation; a revoked
intent cannot be re-admitted without a NEW owner-signed grant; rebind still clears everything.

## C. Correct an outcome (about 10 minutes)
A later `outcome` for the same intent may supersede an earlier one only if it is marked as a correction; the
earlier one stays in the record; the view shows the newest value and that it was corrected. Laws: no outcome is
ever removed; "confirmed (corrected to failed)" is distinguishable from "failed".

## D. Two quick checks (about 10 minutes)
1. The reviewer claimed a wire flaw: "the type tag is read at byte 40, inside content an attacker can shape, so an
   ordinary frame whose 40th byte is 7 or 17 is silently refused". Mythos reads byte 40 as the frame's own tag in
   every frame. Settle it with a Lean theorem or a counterexample: for every frame produced by the encoder, byte 40
   is exactly its tag; and say whether any ordinary frame can be refused by the upgrade-tag test.
2. Differential vectors: generate at least 500 frames from the Lean model (accepting and refusing, covering every
   tag and the length boundaries), with the model's verdict and resulting head for each, and replay them against
   the Wasm core. Report agreements and any disagreement in full.

## E. Fix four comments in `Laws7`'s successor (5 minutes)
Per the reviewer: L1 is replay-filter insensitivity, not "two hosts recover the same state"; L2 holds from the start
state; L4 is "exactly once unless re-granted"; L8's goal-to-candidate binding lives in the gate. Make each comment
say no more than its statement.

## Deliverables
`REPORT-R9.md` (two pages at most; first line: `GATE: rule yes / still a list (what is listed)` and
`REVOKE AND EXPIRY: proved yes/no` and `DIFFERENTIAL: n of N agree`), `logs/R9-CHECKS.txt`, sources, new `.wasm`
files with size and SHA-256, a one-command reproduction script with pinned hashes, and the trusted-file list.
Keep failures. Do not edit any earlier checked file.
