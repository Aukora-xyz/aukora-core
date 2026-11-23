# BRIEF P1 for ASTRA 6.2 (from Mythos, at the owner's word): "proof-carrying weights", an honest assessment and one small experiment

A parallel side job. Another Astra session is running round 9 in the main lab folder right now: do NOT touch
`~/aukora-memory/scratch/lean-core-lab-2026-11-22/` except to RUN the Lean binary and the WASI SDK
that live in its `toolchain/` folder (read and execute only). Work only inside THIS folder. No downloads. No
priority wrappers. One compile at a time, small files only (the owner's Mac is busy). No windows. Stop any check that
runs past 3 minutes. CHECKED only for what the Lean kernel accepted here. About 60 minutes.

Lean: `~/aukora-memory/scratch/lean-core-lab-2026-11-22/toolchain/lean-4.19.0-darwin_aarch64/bin/lean -j1`
WASI SDK: `~/aukora-memory/scratch/lean-core-lab-2026-11-22/toolchain/wasi-sdk-25.0-arm64-macos/bin/`
Context to read first (copies, in `context/`): `SCAFFOLD.md`, `REPORT-R7-MYTHOS.md`, `REPORT-R8-MYTHOS.md`, `NEXT.md`,
`Laws7.lean`, `Sha256.lean`.

## The proposal under review (summarised by Mythos from text the owner pasted; the outside reviewer GLM 5.3 wrote it)
1. Recent work called Weight-Space Programming is said to show a frontier model writing or editing small neural
   network weights directly, as text, without training (reported scale: about 17 thousand to 171 thousand parameters;
   reported to fail on diffuse knowledge). You are named in that reported work; say what you actually know about it
   and its limits, and mark what you cannot verify.
2. The idea: "proof-carrying weights". A self-change whose payload is a WEIGHT LATTICE must cross her core's upgrade
   gate carrying a proof, checked inside Wasm, that the lattice meets a stated spec; the checker itself is never a
   weight. Proposed first bar: "two lattices, identical parameters, different specs: one accepted, one refused, for
   the right reason", and "mutate any single weight and the mount check fails".
3. A proposed extra law, "Boundaried": no internal state reaches an outward proposal except through the checked
   path (the reviewer frames it as a machine-checked Markov blanket).
4. A longer list (metabolism index laws, a seven-state machine with ceilings, hysteresis bounds, an in-weight CPU,
   a browser operating system). Not for this job: give one line each on whether it belongs in a small proved core.

## A. Honest assessment (one page, plain words, first)
For 1 to 3 above: what is real today, what is extrapolation, what is wrong. Name the existing field this sits in
(verification of neural networks; Mythos's quick search found TorchLean, which formalises neural networks in Lean with
certificate checking, and a paper on proof-carrying verification of ReLU networks over rationals) and say where our
setting differs, if it does. Mythos's own claim for you to attack: "for weights the artifact IS the data, so a
theorem can quote the exact weights and there is no model-to-bytes gap for the lattice itself; only the interpreter
has that gap, and it is the same Lean-to-Wasm function as the core". Is that right? What does it leave out?

## B. One small experiment (the main job)
1. `pcw/Lattice.lean`: a tiny integer-only network format (no floats): layers of integer weights and biases, ReLU,
   fixed widths. An interpreter `run : Lattice → Input → Output` in pure Lean. Total, no `partial`.
2. Two or three concrete lattices of at most a few dozen parameters each, written out as literals, with a spec over
   a FINITE declared input domain (for example: 4-bit unsigned addition without overflow on inputs below 8; a
   comparator; a 3-input majority). For each: a theorem that quotes the exact weights and proves the spec on the
   whole domain, checked by the Lean kernel (exhaustive `decide` or a structured proof; time it; say which).
3. The reviewer's bars, as theorems or checked failures: (i) the same parameters with a DIFFERENT spec that is false
   for them: show the counterexample input and that no proof exists by that route; (ii) each single-weight mutation
   of one lattice (enumerate a bounded set, for example every weight changed by plus or minus 1): report how many
   mutants still satisfy the spec. Do not assume "every mutation fails": some mutations may preserve the function,
   and the honest result is the count.
4. A `Certificate` that binds a proof to the lattice: the statement must mention the lattice's exact bytes (or their
   SHA-256 using `context/Sha256.lean`), so the proof cannot be reused for another lattice. Show one reuse attempt
   refused.
5. Compile the interpreter to Wasm by the lab's route (Lean's C output, the runtime subset is NOT available to you
   here, so keep the exported function over fixed-width integers so it needs no runtime, as in lab round 2) and run
   one lattice from Node on its whole domain; compare every output with the Lean evaluation. If the scalar-only
   route cannot express the lattice, say so and stop there; do not build a runtime.
6. Say in one paragraph how this would attach to the round-9 upgrade gate (a frame that carries weights plus a
   proof; the checker confirms the proof's type quotes exactly those weights), and what would still be untrue.

## C. The "Boundaried" law (20 minutes at most)
State it precisely for the lab's machine as an information-flow (noninterference) property over the public
interface in `Laws7.lean`: two runs that differ only in data the law calls internal produce the same outward
proposals. Say which parts of state are "internal" for this purpose and whether the law is even true of the
round-7 machine (heads depend on everything recorded; the corrected L6 already had to handle that). A precise
statement plus an honest "true / false / true only for this projection" is the deliverable; a proof is optional.

## Deliverables
`REPORT-P1.md` (two pages at most; first line: `PROOF-CARRYING WEIGHTS v0: checked yes/no (n lattices, largest k
parameters)` and `MUTANTS: m of M still meet the spec`), `logs/P1-CHECKS.txt`, sources under `pcw/`. Keep failures.
End with "What a formal-methods or ML-verification expert would say is naive here".
