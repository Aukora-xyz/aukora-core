# BRIEF, round 8, for ASTRA 6.2 (from Mythos). Research lab only. Same folder and limits as round 7.

Limits: work only in this folder; downloads only from GitHub, at most 10 MB, each listed; no priority wrappers; one
compile at a time; no windows; stop any check or test that runs past 6 minutes and report it; leave no worker
running; CHECKED only for what a Lean kernel accepted in this round. Delete large regenerable build output before
you finish and report the final folder size. About 110 minutes. Fewer things finished beat more things started.

Read `REPORT-R7.md` first (your own; Mythos is re-running it). The owner's order for this round: quantum-safe
signatures for real, then the danger-score law.

## A. ML-DSA-65 verification inside the core (the main job, about 65 minutes)
Follow your own round-7 plan (FIPS 204 verification only; no key generation, no signing).
1. `core/Mldsa8.lean`: public-key and signature decoding with every malformed-input rejection you listed, SHAKE-128
   and SHAKE-256 (reuse `Shake7`), matrix expansion, NTT modulo 8,380,417, hints, and the final 48-byte comparison.
   Implemented and tested, not proved: say so. Pure Lean, no FFI.
2. Independent test vectors WITHOUT the network: this Mac's Node is v24.11.1 with OpenSSL 3.5.4, and
   `crypto.generateKeyPairSync('ml-dsa-65')`, `crypto.sign(null, message, privateKey)` and `crypto.verify` work
   (checked by Mythos: signatures are 3,309 bytes; the raw public key is the last 1,952 bytes of the SPKI DER).
   Check which signing mode Node uses (pure ML-DSA with an empty context string is the expected default) and match
   it exactly. Test in native Lean and in Wasm: at least 20 fresh random keys and messages of varied length must
   verify; one flipped bit in the signature, in the message and in the public key must each be refused; truncated
   and over-long inputs must be refused. Report the cold and warm time of one check in Wasm.
3. Wire the HYBRID rule into the stateful core (`Hybrid7` already proves it abstractly): the owner is a pair of
   keys; a grant, a rebind and every owner control need BOTH an Ed25519 and an ML-DSA-65 signature over the same
   message. Build `core/Core8.wasm`. Run: both signatures good, accepted; only Ed25519 good, refused; only ML-DSA
   good, refused; rebind signed by both old keys, accepted; after it the old pair is refused. Keep the round-7
   `Lawful` gate working on this core, or say exactly what broke.
4. Sizes: the public key and the two signatures make a grant frame several kilobytes. Report the frame size and
   the head computation time for one hybrid grant.

## B. The danger-score law (about 25 minutes, only after A.3 runs)
The owner's design: a fast model gives each proposed action a danger score; above a threshold the action needs the
owner's fingerprint; the owner may move the threshold; some actions always need it.
1. `core/Risk8.lean`, on a machine extended with: a `threshold` set only by an owner-signed control; an `assess`
   event recording, for one intent digest, a score and ONE bundle digest (the host hashes the request, the evidence,
   the reasoning summary, the witness model's verdict and the model versions into it); and a rule: an act with
   score below the threshold may be admitted under a standing mandate; at or above it, only with a fresh signed
   grant for that exact intent.
2. Laws, proved: (i) MONOTONE: raising the recorded score for an intent can never turn a refusal into an
   acceptance; (ii) FLOOR: `upgrade` and `rebind` need the owner's signature at every threshold and every score;
   (iii) the threshold changes only by an owner-signed control; (iv) an act with no assessment is treated as the
   highest score; (v) every admitted act names the bundle digest it was assessed with, so the record always shows
   what the decision rested on.
3. Add it to the Wasm core only if A is finished and green; otherwise leave it as a checked Lean model and say so.

## C. Time bracket fields (about 10 minutes, only if A and B are done)
A `stamp` event that records two opaque values for the current head: a "not before" beacon value (for example a
drand round number and its randomness) and a "not after" receipt digest (for example an OpenTimestamps proof
digest). The core does not verify either. One law: a stamp never changes authority and never changes any earlier
record entry. Say plainly that verification of these values is outside the core.

## Deliverables
`REPORT-R8.md` (two pages at most; first line: `ML-DSA-65 INSIDE: yes/no, T ms warm` and `HYBRID CORE: built
yes/no, size` and `RISK LAW: proved yes/no`), `logs/R8-CHECKS.txt`, sources, new `.wasm` files with size and
SHA-256, a one-command reproduction script with pinned hashes, and the list of hand-written trusted files with line
counts. Keep failures. Do not edit any earlier checked file.
