# BRIEF, round 10, for ASTRA 6.2 (from Mythos): the v0.1 consolidation ("the diamond"). Same folder and limits.

Limits: work only in this folder; ignore `_export/` and `standalone/` (Mythos's); no downloads; no priority
wrappers; one compile at a time; no windows; stop any check or test that runs past 6 minutes and report it; leave no
worker running; CHECKED only for what a Lean kernel accepted in this round. Delete large regenerable build output
before you finish and report the final folder size. About 130 minutes. If you cannot finish everything, finish A
completely, then as much of B as is clean; never leave a half-renamed tree.

Read `REPORT-R9.md` (yours) first. Nine rounds built the pieces in layers. This round pulls one clean release out
of them. Do not edit any earlier checked file: build the release in a NEW folder `v0.1/`.

## A. One law set for everything, pinned in the gate (do this first)
Your round-9 report notes that the gate's pinned contract is `Laws7.Lawful`, which permits an Ed25519-only
successor: a lawful upgrade could DROP the quantum-safe signature, the danger-score rules, revoke and expiry. That
must not be possible.
1. `v0.1/Laws.lean`: ONE proposition `Lawful` for the newest machine's public interface that contains, each with a
   one-line plain-words comment that says no more than its statement: L1 to L10 (with round 9's corrected
   comments); the hybrid-signature laws (no grant, rebind or owner control without BOTH verifiers accepting); the
   five danger-score laws; the stamp law; single-grant revocation and expiry; outcome correction and retention.
2. Prove `Lawful` for the newest machine (the round-9 machine), reusing every checked theorem. List any law you
   could not carry over, with the reason.
3. The gate pins THIS `Lawful`. Show: a candidate that is the round-9 machine with a fixed genesis key is admitted;
   a candidate that verifies Ed25519 only (the round-9 example successor) is now REFUSED because no proof of the new
   `Lawful` exists for it (prove `¬ Lawful` for it, or show exactly which conjunct fails); the round-7 `Lawful` proof
   is refused as the wrong theorem.
   Mythos's second-seat note on round 9: the admitted example, `FixedGenesis9.wasm`, is the ROUND-6 core with its
   `init` wrapped by a byte patch (`spike/r9/candidate.py`). So the demonstrated upgrade moved a hybrid,
   danger-scoring core onto an Ed25519-only round-6 file. In this round the admitted candidate must be built from
   the newest machine's own Lean source by the normal build route (fixed genesis key compiled in or wrapped, say
   which), and the report must say in one line how each candidate's bytes were produced.
4. State the limit plainly: who may change the pinned law set itself? Today nobody can from inside (it is compiled
   in). Say so; do not invent a mechanism this round.

## B. One clean tree, one build, one file (the release)
1. `v0.1/` layout, small modules with clear names: `Types`, `Wire` (the frozen frame format), `Crypto/` (Sha256,
   Sha512, Shake, Ed25519, Mldsa), `Machine` (state and the one step function), `Laws`, `Gate` (upgrade and proof
   check), `Checker` (the lean4lean cell glue), `Interface.c`, and the build scripts. No file named by round number.
   Old round folders stay as history.
2. `v0.1/build.sh`: one command that checks every Lean file, rebuilds the Wasm from source, compares with pinned
   hashes in `v0.1/PINS.sha256`, runs the tests, prints PASS or FAIL. It may reuse the vendored sources already here.
3. Outputs: `v0.1/aukora-core.wasm` (the core with the gate) and, if separate, `v0.1/aukora-checker.wasm`. Report
   sizes. Say honestly how much of the size is the checker's pinned environment and whether a core WITHOUT the
   in-Wasm checker (for hosts that only record and replay) is worth shipping as a second, small file; if it is cheap,
   build it too as `v0.1/aukora-core-lite.wasm` and say exactly which laws still hold for it.
4. `v0.1/WIRE.md`: the frozen frame format, byte by byte, for every event, with one hex example each, and a version
   byte or tag so a future format can be told apart. `v0.1/EXPORTS.md`: every Wasm export, its arguments and results.
5. `v0.1/vectors/`: at least 1,000 frames generated from the Lean model with verdict and resulting head, replayed
   against the Wasm file (as in round 9), shipped as the conformance corpus for other implementations.
6. `v0.1/PROVED.md`: every law: the plain sentence, the theorem name and file, and the assumptions it names.
   `v0.1/NOT-PROVED.md`: everything trusted or untested, including the model-to-bytes gap, the lemmas the in-Wasm
   checker takes as given, the cryptography, the hand-written files with line counts, and the limits of the
   carried-definition language (monomorphic, nonrecursive, built from pinned pieces).

## Deliverables
`REPORT-R10.md` (two pages at most; first line: `LAW SET: one, N laws, proved for the newest machine yes/no` and
`RELEASE: v0.1 built yes/no, one-command PASS/FAIL, sizes` and `DOWNGRADE: Ed25519-only successor refused
yes/no`), `logs/R10-CHECKS.txt`, and the `v0.1/` folder. Keep failures.
