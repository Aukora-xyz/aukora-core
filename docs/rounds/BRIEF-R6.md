# BRIEF, round 6, for ASTRA 6.2 (from Mythos). Research lab only. Same folder, same limits, one change.

**Change to the limits:** this round MAY download, from GitHub only, at most 60 MB in total, and must report every
URL, commit hash and byte count. Everything else binds: work only in this folder; no priority wrappers; one compile
at a time; no windows; stop any check or test that runs past 5 minutes; leave no worker running; CHECKED only for
what the Lean kernel accepted in this round. About 80 minutes. This is a FEASIBILITY round: an honest "no, because
X" is a full result.

Read `REPORT-R5-MYTHOS.md` first. One fact about her own evolution is still host-reported: `proofChecked`.

## The question
Can a Lean proof be CHECKED inside Wasm, by a checker that is itself small, so that "the proof was checked" stops
being a flag and becomes something the core (or a sibling cell it calls) computes?

## A. A proof checker as a Wasm cell (the main job, about 55 minutes)
Try in this order; record each attempt; stop at the first that works.
1. **A Lean kernel written in Lean** (the `lean4lean` project, or an equivalent you know): fetch a pinned commit,
   see whether it builds against the Lean 4.19.0 already here (or what version it needs), and whether our round-5
   route (Lean to C, the runtime subset, WASI SDK) can compile its type checker to Wasm. If dependencies make this
   impossible within the limits, say exactly which.
2. **A minimal checker for a restricted proof format.** If (1) is out of reach: define a tiny certificate format
   for ONE family of facts we actually need (for example the ARK certificates: a 4-row subset, a claimed inverse,
   and the checker multiplies and compares; or a replay certificate: a list of frames and a claimed head). Write the
   checker in Lean, PROVE it sound (checker says yes implies the fact holds), compile it to Wasm, and run it on a
   good and a bad certificate. This is proof-carrying data with a proved checker: small, but real.
3. Either way, export the proof terms (or certificates) for at least one theorem we already have and report: the
   size of the proof object, the time to check it in Wasm, and the size of the checker `.wasm`.

## B. Wire it to the upgrade (about 15 minutes, only if A produced a working checker)
Design, and if time allows build, the smallest honest link: an `upgrade` is accepted only if the checker cell
returned yes for a certificate bound to the candidate's SHA-256. State exactly what the certificate proves about
the candidate and what it does not. If the only checker you have is for a restricted family, say plainly that it
does not yet establish "the new core keeps the laws".

## C. Write down the real gap (10 minutes, always)
In `REPORT-R6.md`, one section titled "What it would take": the precise remaining steps to make
`proofChecked` mean "a kernel inside Wasm accepted a proof that the candidate satisfies laws L1 to L10", with your
honest estimate of each step's difficulty (hours, days, research) and what could make it impossible.

## Deliverables
`REPORT-R6.md` (two pages at most; first line: `PROOF CHECKED INSIDE WASM: yes (route N, what was checked) / no
(blocked at X)`), `logs/R6-CHECKS.txt`, sources, any `.wasm` with size and SHA-256, and the download list.
Keep failures. Do not weaken or edit any earlier checked file.
