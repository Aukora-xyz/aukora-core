UPGRADE BOUND TO BYTES: yes, verified by a second seat; her core accepts a successor only by its exact bytes, with a matching approval, and refuses one flipped bit. ALL 13 EVENT FAMILIES are inside the Wasm core. The proof check and the owner's signature are still host-reported.

# Round 4, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos; transcript `logs/R4-mythos-rebuild.txt`)
| What | Result |
| --- | --- |
| `sh spike/r4/build.sh repro`: every Lean module re-checked, the eight runtime units recompiled from source, the core relinked | exit 0, no errors, no gaps; the result is **byte-identical** to Astra's `core/Core4.wasm`: 286,807 bytes, SHA-256 `e95a4879a37d11726dc7a51a57462aacc0df1400d49e670501a4cdec58cb80f6`. This time the rebuild is from source, runtime included |
| Lean statements | 22 new named theorems in the round-4 files, all accepted; axioms `propext`, `Quot.sound`, one use of `Classical.choice` |
| My own test, written from `core/Wire4.lean` only (`logs/repro4/mythos-upgrade-test.mjs`), candidate = `Core4.wasm` itself | all nine lines as expected (below) |

| Step in my test | Verdict |
| --- | --- |
| grant for the SHA-256 of `Core4.wasm` | accepted |
| upgrade with one bit flipped in the candidate | refused; core and head unchanged |
| upgrade with the exact bytes but `proofChecked = false` | refused; core unchanged |
| upgrade with the exact bytes and `proofChecked = true` | accepted; `core` now equals the SHA-256 of `Core4.wasm` |
| the same grant used a second time | refused |
| a fresh instance, exact bytes, no grant at all | refused |

## The three laws of the head, as checked (`core/Bound4.lean`)
- `core_change_only`: if `core` changed, the event was an upgrade whose target is the digest **the core itself computed**
  from the bytes it was fed, with `proofChecked = true` and a matching unspent grant of the current generation.
- `wrong_digest`: if the computed digest differs from the approved one, the event is refused and the whole state is
  unchanged. No assumption about SHA-256 is needed for this one.
- `different_bytes`: different bytes are refused, under ONE stated assumption (the two byte strings in question do
  not share a SHA-256). `upgrade_facts` adds: the grant is spent by the upgrade.

## What this shows and what it does not
It shows: approval is bound to exact bytes inside the core. A host cannot swap the successor after the owner
approved a digest, and cannot reuse an approval.
It does not show: that any proof was checked. `proofChecked` and `ownerVerified` are still fields a host fills in.
SHA-256 is still implemented and tested, not proved. Hand-written trusted files are now about 330 lines
(`interface.c` 84, `reachable.py` 126, `build.sh` 49, `private-exports.py` 53, two shims 11, a 4-line config), plus
a subset of Lean's runtime and the two compilers. Sequence numbers are 64-bit; other counts are still 16-bit.

## Totals after round 4
85 statements accepted by the Lean kernel and re-run by a second seat. Four Wasm files from proved Lean text:
82 bytes, 664 bytes, 209,455 bytes, 286,807 bytes. The newest holds all 13 event families, her state, SHA-256 and
the byte-bound upgrade.
