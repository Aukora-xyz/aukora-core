# BRIEF, round 3, for ASTRA 6.2 (from Mythos). Research lab only. Same folder and limits as before.

Limits reminder: work only in this folder; **download nothing at all this round** (the owner's disk is low); no
priority wrappers; one compile at a time; no windows; never write CHECKED for what the Lean kernel did not accept in
this round. If a Lean check runs longer than 5 minutes, stop it yourself and report it as not finished; never leave
a worker running at cutoff. About 75 minutes of work.

Read `REPORT-R2-MYTHOS.md` first. Round 2 gave a proved gate that trusts the host for state and hashing. This round
puts the state inside.

## A. A self-contained core in Wasm (the main job, about 50 minutes)
Goal: one `.wasm` whose exports are roughly `init`, `step(envelope bytes) -> verdict`, `head() -> 32 bytes`, and
which keeps her authority state in its own memory, so a host can only feed envelopes and read the head.
Try in this order; record each attempt honestly; stop at the first that works.
1. **Runtime with emulated signals.** Rebuild Lean's runtime for WASI using what the SDK already ships:
   `-D_WASI_EMULATED_SIGNAL` with `-lwasi-emulated-signal`, `-D_WASI_EMULATED_PROCESS_CLOCKS`, `-D_WASI_EMULATED_MMAN`
   as needed, and the runtime's own single-threaded or Emscripten code paths if its sources have them
   (look for `LEAN_EMSCRIPTEN`, `LEAN_MULTI_THREAD`). Skip or stub only stack-overflow detection and threads.
   If it links: export a function over `ByteArray` and call it from Node. Report the size.
2. **A minimal trusted shim.** If the runtime will not build: write the smallest C file that provides exactly the
   `lean_*` functions the generated C for the core needs (allocation, constructors, arrays or byte arrays, small
   naturals). It must be short, listed line by line in the report as TRUSTED AND UNPROVED, and never grow silently.
3. **Fixed-capacity words.** If both fail: restate the state itself over fixed machine words (for example eight
   grant slots, like the live system's cap) so the scalar route still works, with the state passed in and out and a
   refinement theorem for the whole transition, not only the verdict. Say plainly that the host then still holds
   the state.
Whichever route works: the transition must be the Lean function (or one proved equal to `Aukora.next`), and you run
from Node: genesis, one grant, one act (accept), the same act again (refuse), a stale parent (refuse), and print the
head after each. Then run the same envelope list in a second fresh instance and show the heads are equal.
Hashing: if a real SHA-256 in Lean is too much for this round, use a simple stand-in digest INSIDE the core, name
it STAND-IN in every output, and say what must replace it.

## B. ARK with the real matrix (about 15 minutes, hard stop)
`reference/sealed-shards.mjs` is the live file. Its coding matrix for k = 4, n = 10: rows 0 to 3 are the identity;
row `index` for index 4 to 9 has entry `gfInv(index XOR column)` for column 0 to 3, in GF(256) with polynomial
0x11d. Prove in Lean that every 4 distinct rows of the 10 form an invertible matrix (210 subsets). Round 2's attempt
did not finish in the kernel: use a kernel-friendly encoding (for example carry-less multiplication on `Nat` with
`Nat.xor` and shifts, or 210 small independent theorems with a supplied inverse each), and time one subset first.
If the whole set cannot finish in the time, report how many subsets were CHECKED and stop.

## Deliverables
`REPORT-R3.md` (two pages at most; first line: `SELF-CONTAINED CORE WASM: yes/no, route N, size` and
`ARK: k of 210 subsets CHECKED`), `logs/R3-CHECKS.txt`, sources under `core/` and `spike/`. Keep failures.
