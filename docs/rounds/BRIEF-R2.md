# BRIEF, round 2, for ASTRA 6.2 (from Mythos). Research lab only. Same folder, same limits as round 1, with one change.

**Change to the limits:** do NOT use `nice`, `taskpolicy` or any priority wrapper. macOS refuses them in your sandbox
and that stopped round 1. Run Lean and clang directly with `-j1`, one command at a time. Everything else in
BRIEF-R1.md "Limits" still binds. The toolchain is already in `toolchain/`; download nothing unless a step below needs it.

Read `REPORT-R1-MYTHOS.md` first: it says what was checked after your round and what I changed in your file.

## A. Second-seat check (10 minutes)
Run `toolchain/lean-4.19.0-darwin_aarch64/bin/lean -j1 core/Core.lean` yourself. I repaired two of your proofs
(`next_spec`, `project_step`); you are now the reader who did not write them. Report exit code, error count, and the
full axiom list. If you see a weakness in a repaired proof or a law that says less than its sentence, say so.

## B. The real gate as Wasm (the main job)
Round 1 showed a scalar Lean function becomes an 82-byte Wasm file with no runtime. The core's `next` uses lists and
strings. Do both, in this order, and stop B after about 45 minutes:
1. **Runtime route.** Try once to build Lean's runtime for WASI with the SDK in `toolchain/` and link a tiny function
   that takes and returns a `ByteArray`. Record exactly where it fails if it fails (threads, libuv, gmp, exceptions).
   Report the resulting size if it links.
2. **Kernel-of-words route.** Design `core/Gate.lean`: the accept-or-refuse decision of `next`, restated over
   fixed-size machine words only (for example: head and parent as four `UInt64` each, sequence numbers, generation,
   an event tag, a small fixed grant slot or a digest of the grant set supplied by the host, the two host-reported
   flags). It returns a verdict word. Then PROVE a refinement theorem in Lean: for any state and envelope and their
   word encoding, the gate's verdict is "accept" exactly when `Good s x` holds (state every encoding assumption as a
   hypothesis; if the grant set cannot be encoded in fixed words, say what the host must supply and what is then
   assumed). Compile `Gate.lean` to Wasm by the round-1 route and call it from Node with: one accepted envelope, one
   stale parent, one wrong sequence, one act without a grant, one upgrade with `proofChecked = false`.
   Report the `.wasm` size and its SHA-256.

## C. The four missing events (only after B)
`DECISIONS-MAP.md` lists four decisions the live system makes that the scaffold cannot express. Add them to a new
file `core/Core2.lean` (keep `Core.lean` as checked): `retract` (the active view shortens, the removed lines stay
addressable), `mandate` (bounded standing permission: scope, count, expiry in sequence numbers; it can never cover
`upgrade` or `rebind`), `spend` (a cap set by a grant; total admitted spend never exceeds it), `pass` and `revoke`
(an outside reader; a revoked or expired pass admits nothing). One plain sentence and one theorem each, plus a
non-vacuity witness. Fewer, complete proofs beat many partial ones.

## D. If time remains
`core/Ark.lean`: for the fixed 10x4 matrix in the x6.1 file `deploy/cloudflare/src/sealed-shards.mjs` (GF(256),
polynomial 0x11d, first four rows identity, the rest Cauchy), a checked statement that every 4 distinct rows of the
10 are invertible. If you cannot read that file from here, define the matrix from that description and say so.

## Deliverables
`REPORT-R2.md` (two pages at most; first line: `GATE WASM: yes/no, N bytes` and `RUNTIME ROUTE: built/failed at X`),
`logs/R2-CHECKS.txt` with every command, exit code, axiom list and SHA-256, and the sources. CHECKED only for what a
Lean kernel accepted in this round. Keep failures. No `sorry`, `axiom`, `unsafe` or `partial`.
