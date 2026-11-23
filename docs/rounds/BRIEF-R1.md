# BRIEF, round 1, for ASTRA 6.2 (from Mythos, with the owner's go). Research lab only.

Read `SCAFFOLD.md` first. It is a proposal, not scripture: where a law is wrong or badly stated, say so and fix the
statement. `reference/` holds your own two checked files from this morning; reuse what helps.

## Goal of this round
R0 and R1 of the scaffold, in this order. Stop when both are done or after about 60 minutes of work, whichever is first.

### R0. The toolchain question (do this first; it decides the whole shape)
Can a Lean 4 function become a small Wasm file that a host calls?
1. Put the official Lean 4 release for this machine (macOS, Apple silicon) inside `toolchain/` in THIS folder.
   Verify its SHA-256 against the published one where one exists; record what you verified.
2. Write `spike/Add.lean`: one exported pure function over fixed-width integers or a byte array
   (for example a function that takes a parent digest and a body length and answers accept or refuse).
3. Try, in order, and record each attempt honestly:
   a. Lean's C output (`lean -c`) plus the Lean runtime, built to Wasm with an official wasi-sdk or emscripten release.
   b. If the runtime is too heavy or will not build: the same function restricted so that the emitted C needs
      little or none of the runtime (unboxed scalars only), built to Wasm.
   c. If both fail: say exactly why, and propose the best alternative that keeps "the proved text is the source of
      the running bytes" (for example Lean emitting WAT for a small first-order subset). Do not silently switch to
      "a model beside handwritten code".
4. If a `.wasm` exists: call it from Node (already on this Mac) with three inputs and print the answers.
   Report the `.wasm` size in bytes, the total download size, and the exact commands.

### R1. `core/Core.lean`
The types, `next`, `replay`, and laws L1 to L8 from the scaffold, proved. Plain Lean 4, no Mathlib.
- No `sorry`, no `axiom`, no `unsafe`, no `partial`. `#print axioms` after every theorem.
- Every host-reported fact is an explicit hypothesis or event field, never hidden.
- Include one non-vacuity theorem per law family (the good case really is accepted), so "always refuse" does not pass.
- If time is short, prove fewer laws completely rather than more laws partly. List what is left.

## Deliverables (all inside this folder)
- `spike/` and `core/` sources.
- `logs/R1-CHECKS.txt`: Lean version, each exact command, its exit code, the full `#print axioms` output, SHA-256 of each source file.
- `REPORT-R1.md`, at most two pages: the R0 verdict in the first line (WASM: yes / partly / no, and the route);
  which laws are CHECKED and which are UNCHECKED; any law you had to restate and why; sizes; what you did not verify;
  the one thing in the scaffold you think is wrong.

## Limits (binding)
- Work ONLY inside this folder. No sudo, no global installs, no Homebrew, no changes to shell profiles, no Keychain,
  no other repository, no git push, no messages to anyone.
- Network: downloads only, only from official release hosts (github.com/leanprover, github.com/WebAssembly,
  github.com/emscripten-core and their release storage). At most 2 GB on disk in total; report the total.
- This Mac has 16 GB and its owner is working on it: one build at a time, `nice -n 10`, no parallel jobs (`-j1`).
- Open no windows and no browser. Node and the command line only.
- Never write CHECKED for something the Lean kernel did not accept in this round. Keep failures in the report.
