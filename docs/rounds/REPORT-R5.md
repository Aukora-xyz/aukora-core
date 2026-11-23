OWNER SIGNATURE INSIDE: yes, 8.785 ms per check (median) | REBUILD: one command, PASS

# Round 5 · 22 November 2026

[Core5.wasm](core/Core5.wasm) is **355,910 bytes**, SHA-256 `d74a5e0170299d62e8349496b9c0e31b2a4091b51273ef8bf82204b39222350a`. `./rebuild.sh` reproduced it byte for byte in a separate directory with only project sources and the two supplied toolchains. Node verified zero Wasm imports and private memory. [Rebuild instructions](REBUILD.md) · [Checks, timings and retained failures](logs/R5-CHECKS.txt)

## What the module decided

Genesis accepts a valid Ed25519 public key once. The owner signs a grant label plus the canonical body, audience, generation and nonce. Rebind has its own label and signs the current generation and replacement key. Retract, mandate, budget, pass and revoke also used owner Booleans. Their signatures now cover the fields, generation, parent and sequence. The head hashes the complete signed frame.

| Fresh-instance test | Observed result |
| --- | --- |
| Grant with the owner's signature | Accepted. Refused a flipped signature bit, a changed intent, another signer and the legacy Boolean. |
| Rebind with an outstanding grant | Accepted the current owner's signature and cleared the grant. For the same fresh intent, the old key failed and the new key passed. |
| Upgrade with a signed install grant | Accepted the module's exact bytes. Refused one flipped candidate bit, a false proof flag, a spent grant and replay of its signature. |
| RFC 8032 §7.1 TEST 1, 2, 3 | Lean and Wasm accepted all three recalled vectors and refused signature-bit and message-bit mutations. From the seeds, Node independently reproduced all public keys and signatures. |

Three warm Wasm `verify()` calls took **8.656, 8.785 and 9.303 ms** on the isolated rebuild. Each timed RFC TEST 2 from staged input through key validation and return. The maximum 65,535-byte signed grant also passed.

## What the Lean kernel checked

**CHECKED this round.** Every newly unspent grant requires a successful call to the explicit verifier. Every owner-key change requires verification under the old key and empties the grant pool. The Wasm step uses the concrete Lean verifier. Only an accepted upgrade changes the core digest. It requires a matching staged digest, a current-generation grant and a true proof flag. A digest mismatch preserves the entire state. A signed grant that funded an upgrade cannot fund another across any command suffix.

**L9 and L10.** Existing claims remain an ordered prefix. A correction appends its record and preserves both claims. Each claim names an accepted source preceding its remember event. The Lean model view returns confirmed exactly when accepted history contains a confirmed outcome for that intent, and unknown otherwise.

**Trust assumptions.** Ed25519 and SHA-512 are implemented and tested. Their cryptographic correctness is unproved. Owner attribution assumes Ed25519 unforgeability, secret-key custody and authentic genesis provisioning. Replay protection applies within an instance's accepted history. Different-byte refusal assumes that the specific submitted and approved byte strings have different SHA-256 digests. The host still supplies the upgrade proof verdict, outside-reader authentication and destination outcome reports.

## Hand-written files and line counts

| Scope | Files (lines) |
| --- | --- |
| Machine and cryptography, under `core/` | `Core.lean` 506, `Core2.lean` 356, `Sha256.lean` 93, `Wire4.lean` 178, `Bound4.lean` 123, `Sha512.lean` 109, `Ed25519.lean` 110, `Wire5.lean` 108, `Bound5.lean` 201, `Stateful5.lean` 244 |
| Proof modules, under `core/` | `Events4.lean` 66, `Kira5.lean` 201 |
| ABI and build | `rebuild.sh` 57, `spike/r5/interface.c` 102, `spike/r5/reachable.py` 122, `spike/r4/shim.c` 3, `spike/runtime-r3/shim.c` 8, `spike/runtime-r2/include/lean/config.h` 4, `spike/r3/private-exports.py` 53 |
| Test and execution controls | `core/Crypto5Tests.lean` 59, `spike/r5/rfc8032.txt` 4, `spike/r5/call.mjs` 188, `spike/r4/events.mjs` 87, `spike/r3/watch.py` 24 |

The kernel, compilers, linked runtime and Node engine are trusted. The transcript inventories the unmodified upstream source subset by file and line count. It retains the failed development proofs, launcher error and first unpinned build.
