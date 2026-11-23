# BRIEF, round 5, for ASTRA 6.2 (from Mythos). Research lab only. Same folder and limits as round 4.

Limits reminder: work only in this folder; download nothing; no priority wrappers; one compile at a time; no
windows; stop any Lean check or test that runs past 5 minutes and report it; leave no worker running; CHECKED only
for what the Lean kernel accepted in this round. About 75 minutes.

Read `REPORT-R4-MYTHOS.md` first. The core now trusts the host for exactly two facts. This round removes the first.

## A. The owner's signature checked INSIDE the core (the main job, about 50 minutes)
Today `grant` and `rebind` carry `ownerVerified : Bool`, filled in by the host. Replace that flag:
1. State holds the owner's public key (set at genesis; `init` takes it, or a first `bind` event sets it once).
2. A `grant` carries a signature over the canonical bytes of its intent (domain-separated: include a fixed label,
   the generation and the nonce). The core verifies it against the stored key itself. `rebind` is signed by the
   CURRENT owner key over the new key and the generation.
3. Algorithm: Ed25519 (RFC 8032), written in Lean, using the SHA-512 it needs (write it; reuse the SHA-256 file's
   structure). It will be implemented and tested, not proved: say so. Test it in Lean and in the Wasm build against
   the RFC 8032 section 7.1 test vectors (at least TEST 1, 2, 3) and at least two negative cases (one flipped bit in
   the signature, one in the message). You have no network: take the vectors from memory and CHECK them by
   self-consistency (a keypair you derive must verify its own signature); if you cannot reproduce an RFC vector
   exactly, say so plainly rather than adjusting it.
4. Laws, proved in Lean on the new machine, with signature verification as an explicit function `verify`:
   (i) no grant enters the unspent set unless `verify ownerKey (intentBytes i) sig = true`;
   (ii) `rebind` changes the owner key only with a signature that verifies under the old key, and kills unspent grants;
   (iii) the round-4 laws of the head still hold on this machine. Do not assume anything about Ed25519's strength in
   a proof; unforgeability is a named assumption in the report, never a hidden one.
5. Build to Wasm and run from Node in a fresh instance: a correctly signed grant is accepted; the same grant with one
   bit flipped in the signature is refused; a grant signed by a different key is refused; a signed rebind works and
   an old-key grant after it is refused. **Report the time one signature check takes in Wasm** (milliseconds, three
   runs). If it is slower than 2 seconds, say so and stop optimising; correctness first.

## B. One command from zero (about 15 minutes)
Write `REBUILD.md` and a single `rebuild.sh` at the lab root that, given only the two toolchain folders already
here, checks every Lean file of the newest core, rebuilds its Wasm from source and compares the SHA-256 to a pinned
value, then runs the Node tests. A stranger should need one command and see PASS or FAIL with the hash.

## C. If time remains
State, as Lean theorems on the newest machine, the two Kira laws that are still only sentences: L9 (claims only
grow; a correction never removes what it corrects; a claim's source is an earlier accepted event) and L10 (the view
shows "confirmed" only if a confirmed outcome event exists).

## Deliverables
`REPORT-R5.md` (two pages at most; first line: `OWNER SIGNATURE INSIDE: yes/no, T ms per check` and
`REBUILD: one command, PASS/FAIL`), `logs/R5-CHECKS.txt`, sources, and the new `.wasm` with its size and SHA-256.
Keep failures. List every hand-written trusted file with its line count.
