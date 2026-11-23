ROOT v1: NOT composed (and the brief that specified it was mine). Rebuilt byte-identical by a second seat. Package binding, memory limits, judge comparison and cell laws hold. New finding by the second seat: at the record limit any caller can lock the owner out.

# Round 12, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh v0.3/build.sh` from an empty work folder, under the 4 GB memory watchdog | **PASS v0.3** in 8 min 48 s, no errors, no gaps, no job over the cap (peak sampled about 200 MiB). Files matched their pins: `aukora-core.wasm` `6e5ef46d43bbc487e701707cd6984b6aaa56bd9f064072c23ba600658d4d8f2a`; `aukora-core-lite.wasm` `18b8e4670f44be221e6eef5052eb6036fca4ddd03557be09954e5fdd58b8370f`. Transcript `logs/R12-mythos-rebuild.txt` |
| My own harness: the v0.3 full core on the whole round-11 corpus | 1,838 of 1,838 frames gave the stated verdict and head. The new core behaves as the old one on every earlier frame |
| My hostile pass on the v0.3 full core | 3,617 malformed or replayed frames: 0 traps, 0 changes on a refusal, 0 out-of-place frames accepted, halt never cleared (78 tries while halted) |
| Limits, with my own adapter and frames (`logs/repro12/mythos-capacity.mjs`), both files | Staging accepted exactly 16 MiB, then refused; the core carried on. The record stopped at 512 lines; the full record replays to the same head |
| **The lockout, with my own frames** | With room: an owner approval, a cancel and a threshold control all admitted. At 512 lines: speech refused, **a valid owner approval refused, a valid threshold control refused, a valid KEY CHANGE refused.** Head unchanged |
| Source read | `v0.3/Proofs/Root12Conflict.lean`: the closed frame grammar is inside D5 and P1, a "legacy rebind" inside H2, an exact finding list inside L10, and L8 pins the old checker goal. `v0.3/` ships no `PROVED.md` or `NOT-PROVED.md` |

## What is true now
- The upgrade package is bound: the owner signs commitments to the file and both certificates. Astra's sweep
  refused 440 of 440 proof changes (my round-10 sweep had 8 of 440 accepted). I did not re-run that sweep myself.
- Memory has a ceiling (256 MiB), staging a limit (16 MiB), the record a limit (512 lines or 2 MiB).
- The judge is compared by bytes: a candidate must carry the identical compiled checker, runtime, goal
  constructor and declaration bytes. A weakened law in the embedded environment fails the comparison.
- 21 hostile proof and model cases: no trap, none over 10 seconds, with a 100,000-step budget in the checker.
- A cell-call event with three laws and 200 vectors (a synthetic session, not her cells).

## What is NOT true
1. **One machine still does not carry every law.** The full Wasm pins 36 laws that its own machine does not
   satisfy, so the full machine can never have an admitted successor. Cause: my round-12 brief said "leave every
   safety clause unchanged" and assumed the closed grammar lived only in L2. It also lives in D5, P1, H2, L10, and
   L8 names the old checker goal. Second half of the lesson: never ratchet a clause that NAMES A VERSION.
2. **Any caller can lock the owner out.** Speech needs no signature. 512 free lines fill the record; after that
   no approval, no control and no key change is accepted, and a halted machine could never be cleared. This
   breaks the no-lockout law as built. Round 12b reserves room for owner recovery and adds seal-and-continue.
3. **"Fixed executable" may mean an upgrade can change nothing executable.** If a successor must carry identical
   code, the gate admits changes of law data only. Round 12b must say so plainly or show otherwise.
4. 512 lines is a lab number: one shadow session fits, real use does not, until records can be sealed and continued.
5. Unchanged: proofs are about the model, not the bytes; "whether those handlers implement the carried model"
   is unproved (Astra's words); cryptography tested, not proved; raw keys; nothing runs in live x6.1.

## Next
Round 12b (launched 17:44): root v1 final over installed versions, with ONE admitted same-set successor as the
acceptance test; recovery reserve and seal-and-continue; what an upgrade may change. Permits (round 13) wait.
