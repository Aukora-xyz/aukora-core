OWNER SIGNATURE INSIDE: yes, verified by a second seat with keys and signatures made by Node's own Ed25519. REBUILD: one command, PASS, same hash. The only fact the core still takes from the host about its own evolution is "the proof was checked".

# Round 5, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `./rebuild.sh` from zero (every Lean module re-checked, Lean's own crypto tests run, the runtime recompiled from the vendored source, the core relinked, the Node tests run) | **PASS**, 15.5 s, exit 0, no errors, no gaps. SHA-256 `d74a5e0170299d62e8349496b9c0e31b2a4091b51273ef8bf82204b39222350a`, 355,910 bytes: the pinned value. Transcript `logs/R5-mythos-rebuild.txt` |
| Lean statements | 27 new named theorems (`Bound5` 10, `Stateful5` 12, `Kira5` 5), all accepted; axioms `propext` and `Quot.sound` only |
| My own test, written from `core/Wire5.lean` only, with fresh random keys and signatures from **Node's built-in Ed25519** (`logs/repro5/mythos-signature-test.mjs`) | all eleven lines as expected (below). The Lean-written verifier therefore agrees with an independent implementation on keys it has never seen |

| Step in my test | Verdict |
| --- | --- |
| genesis with a fresh owner key | accepted |
| grant with one bit flipped in the signature | refused |
| grant signed by a stranger's key | refused |
| grant with the right signature but a changed intent | refused |
| head after those three refusals | unchanged |
| grant signed by the owner | accepted; head equals SHA-256 of the whole signed frame |
| rebind to a new key, signed by a stranger | refused |
| rebind to a new key, signed by the current owner | accepted |
| grant after the rebind, signed by the OLD key | refused |
| grant after the rebind, signed by the NEW key | accepted |

## The laws as checked (`core/Bound5.lean`, `core/Kira5.lean`)
- `new_grant_requires_signature`: no grant enters the unspent set unless the verifier accepted a signature by the
  stored owner key over that exact intent (with a label, the generation and the nonce).
- `owner_change_only`: the owner key changes only by a rebind whose signature verifies under the OLD key; it empties
  the grant pool.
- `control_verified`: retract, mandate, budget, pass and revoke each need the owner's signature over their fields,
  the generation, the parent and the sequence.
- The round-4 laws of the head hold on this machine (`core_change_only`, `wrong_digest`, `different_bytes`).
- L9 and L10 (Kira): claims stay an ordered prefix; a correction keeps both claims; a claim names an earlier accepted
  event; the view says "confirmed" exactly when a confirmed outcome event exists.

## What is NOT true yet
1. **The proof check is still a flag.** `proofChecked` on an upgrade is filled in by the host. This is the last fact
   about her own evolution that the core takes on trust, and it is the hard one.
2. **The owner key is Ed25519, not a passkey.** the owner's fingerprint is a WebAuthn passkey (P-256 with its own message
   wrapping). The core does not verify that format yet; a bridge key or a P-256 verifier is needed.
3. **Ed25519, SHA-512 and SHA-256 are implemented and tested, not proved.** Agreement with Node on fresh keys and
   with the RFC vectors is strong testing, not proof. No law assumes their strength silently.
4. Trusted hand-written files: about 350 lines (`interface.c` 102, `reachable.py` 122, `rebuild.sh` 57,
   `private-exports.py` 53, shims 11, config 4), plus a subset of Lean's runtime and the two compilers.
5. Outside-reader authentication and destination outcomes are still host-reported; replay protection is per instance.

## Totals after round 5
112 statements accepted by the Lean kernel and re-run by a second seat. The newest core, `Core5.wasm`: all 13 event
families, her state, SHA-256, the byte-bound upgrade and owner-signature checking, in 355,910 bytes, rebuilt from
zero by one command to a pinned hash.
