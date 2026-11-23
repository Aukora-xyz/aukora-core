# BRIEF P2 for ASTRA 6.2 (from Mythos, at the owner's word): one real weight lattice, quoted by its exact bytes

MEMORY RULE (binding; two Lean jobs in this lab ran away on the owner's 16 GB Mac: `Ark.lean` at 10 GB, and
`RatchetStrict.lean` at 19 GB on 22 Nov, which another seat had to stop): run every Lean command with `-j1 -M 4096` (CORRECTION, 22 Nov 21:00: this toolchain REJECTS a bare `lean -M`; the option exists only through a release's own tools, which load its `MemoryOption` plugin, as `v0.4/tools/*.py` do. A bare `lean` command must run under `memwatch.py`.)
(Lean's own memory limit, in megabytes). ONE Lean process at a time: before starting one, confirm no other lab
`lean` process is alive, and never release a build lock while a compiler it started is still running. A watchdog
(`memwatch.py` in the main lab) kills any lab toolchain process above 4 GB and logs it in `logs/memwatch.txt`. A
proof that needs more than 4 GB is a FINDING to report (file, statement, peak), not something to retry larger:
restructure it into smaller lemmas or leave it unproved and say so. Never retry a killed job unchanged.

Run this only when no other Astra job is compiling in the main lab. Work only inside THIS folder
(`~/aukora-memory/scratch/lean-core-pcw-2026-11-22/`). You may RUN the Lean binary and the WASI SDK in the main lab's
`toolchain/` and READ the main lab's `v0.1/` (or `v0.2/` if present) and `core/Sha256.lean`; write nothing there.
No downloads. No priority wrappers. One compile at a time. No windows. Stop any check that runs past 6 minutes and
report it. CHECKED only for what the Lean KERNEL accepted here; a result that rests on compiled evaluation
(`native_decide`, `#eval`, a Node run) must be labelled so and never called CHECKED. About 100 minutes.

Lean: `~/aukora-memory/scratch/lean-core-lab-2026-11-22/toolchain/lean-4.19.0-darwin_aarch64/bin/lean -j1`
Read first: `REPORT-P1.md` (yours), `context-p2/kyber-cpu.md`, `context-p2/cpu-weights.json`,
`context-p2/countdown.json`.

## The subject (copied by Mythos from the live system's repository, commit in `context-p2/SOURCE-COMMIT.txt`)
`cpu-weights.json`: 10,608 bytes, SHA-256 `6856c5fcdb0d50ebb8b1e402afa85385e307c58d1922a3bf7f73462539acf61c` (the
digest the shipped skill record names). Schema `finite-affine-relu.v1`: 177 inputs, 384 nodes, 17 outputs, integers
only, each node `[bias, relu flag, [[source, weight], ...]]`; the record counts 1,329 scalars. It is said to
compute one step of an eight-instruction machine: two 4-bit registers, a 3-bit program counter, a halt bit, eight
10-bit ROM words (`kyber-cpu.md` gives the instruction list and the word encoding `op + 8*imm + 128*target`). The
live system's tests report agreement with a plain oracle on all 2,097,152 active transitions and 2,048 halted ones
(REPORTED, not run here). Work out the input and output encodings from the files; if they cannot be determined
from what is in `context-p2/`, say exactly what is missing and stop that part; do not guess an encoding.

## A. The plain bar first (an outside reviewer, Mistral, asked for exactly this; do it before anything else)
1. `p2/Lattice.lean`: the lattice as a Lean literal generated mechanically from the JSON, a total evaluator, and a
   canonical byte serialization `bytes : Lattice -> ByteArray` with a checked statement that `bytes kyber` hashes
   to a stated SHA-256 (your serialization's digest; also record how it relates to the JSON file's digest above:
   the same bytes, or a different canonical form, and why).
2. A `Certificate` whose statement QUOTES the lattice bytes (or their digest plus the literal): for the oracle
   `step` written plainly in Lean, `forall` inputs in the declared domain, `eval kyber (encode x) = encode (step x)`.
3. The bar: the certificate is ACCEPTED for the exact lattice; the SAME proof presented for a lattice with ONE
   byte changed is REFUSED, and say for which reason at which check (digest mismatch, or the theorem is false).
   Run it through the same check path as the main lab's gate as far as you can without editing the main lab
   (the carried-definition language there is monomorphic and nonrecursive: say plainly whether this lattice and
   its proof FIT that language today, and list what the checker would need if not).

## B. How far the kernel gets on the full domain (the honest number)
The full domain is about 2.1 million transitions. Report, in this order, what you actually achieved:
1. Kernel-checked on the whole domain (by a structured proof: per-instruction lemmas, bit-level decomposition,
   or reflection with a checked evaluator), or
2. kernel-checked on a stated sub-domain (for example one instruction, or all states for a fixed ROM), with the
   rest covered by compiled evaluation and labelled as such, or
3. compiled evaluation only.
Give times. Do not report 2 or 3 as 1. A partial kernel result with an exact boundary is a good result.

## C. The freedom count (one experiment; the reviewer's addendum, and P1's 2-of-18 at real size)
For every scalar in the lattice (all 1,329, or a stated subset if time runs out), change it by +1 and by -1, and
count how many mutants compute EXACTLY the same function on the whole domain. Use compiled evaluation (label it);
then for a handful of surviving mutants, try for a kernel proof that the mutant equals the original on a
sub-domain. Report: survivors of N, which nodes they sit in (dead inputs, slack before a ReLU, redundant paths),
and one sentence on what the number means and does not mean. It is a count for THIS lattice and THIS mutation
set, not a statement about large models.

## D. One paragraph, no code
What a "weights upgrade" frame would be in the main lab's gate: carried lattice bytes, the spec named by digest,
the proof, the owner's signatures. Which of the main lab's laws apply unchanged, and what stays untrue (the
interpreter's own model-to-bytes gap; a spec the owner cannot read is not a spec).

## Deliverables
`REPORT-P2.md` (two pages at most; first line: `KYBER LATTICE: certificate accepted for exact bytes yes/no;
one-byte change refused yes/no (reason)` and `DOMAIN: kernel-checked n of N transitions; compiled evaluation m of
N` and `FREEDOM: s of M single-scalar mutants compute the same function`), `logs/P2-CHECKS.txt`, sources under
`p2/`. Keep failures. End with "What a formal-methods or ML-verification expert would say is naive here".
