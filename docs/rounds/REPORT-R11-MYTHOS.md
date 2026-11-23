EVIDENCE LAWS and SAFE STATE: proved and rebuilt byte-identical by a second seat; 9,300 hostile inputs found nothing. SUCCESSION: works for the 23-law core. But the two halves do not compose: the machine with the new laws cannot satisfy two of the 23 frozen ones, so the new laws are NOT in any gate yet.

# Round 11, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh v0.2/build.sh` from an empty work folder, under the 4 GB memory watchdog | **PASS v0.2** in 12 min 54 s, no errors, no gaps (`sorryAx` 0), no job over the cap. Both files matched their pins: `aukora-core.wasm` 6,433,989 bytes `6287623dd3bbf7c9e23aaaaccd3a5edb93578a586abc52187f69b9295d98ed82`; `fixtures/ratchet-core.wasm` `9fb736c414c22e76a7eff36966d5633d0ebf302e89a3ef81982272b3b7fc84f4`. Transcript `logs/R11-mythos-rebuild.txt` |
| Model against file, in my rebuild | 1,860 of 1,860 frames agree in Lean and Wasm, including the new groups: evidence 90, field truncations 520, safe state 66, installs 17 |
| My own harness on the full core (`logs/repro11/mythos-v02-test.mjs`; the install groups excluded) | 1,838 of 1,838 frames gave the stated verdict and head |
| My hostile pass, same rules as on v0.1 | 5,427 malformed or replayed frames across seven groups, then 3,899 more on the safe-state session: **0 traps, 0 changes on a refusal, 0 other-row frames accepted out of place, the true next frame correct every time** |
| The safe state under attack | 2,456 hostile frames submitted while `halted()` was 1: **the halt was never cleared by any of them** |
| Source read | Succession (`v0.2/RatchetModel.lean:48`): an install must carry a checked proof of the child's own law set AND a checked proof that the child's set entails the current one, and the child's own gate makes the same demand. The law refers to itself by name, which avoids a circular definition. The five safe-state laws (`v0.2/Proofs/Round11Safe.lean:14`) include H5: a valid clear or rebind succeeds from every state |

## What is true now
- Seven evidence laws: what an act cites must already be in the record, of the right kind; the core computes the
  confidence bound itself; "found nothing" must quote a recorded search; speech is never blocked.
- Five safe-state laws, including no lockout: a valid owner clear or key change always works, even with staging
  in a failed state (ran). Lost keys stay outside the theorem.
- Succession on the 23-law core, in Wasm: the round-9 file refused; a model that keeps all 23 laws but weakens its
  own gate refused; a law set nobody can satisfy refused; the same set admitted; a stronger set admitted, and
  going back to the weaker set afterwards refused.

## What is NOT true
1. **The new laws are in no gate.** Lean proved the full machine (evidence plus safe state) is NOT lawful under
   the frozen 23 (`full_violates_L2`, `full_excludes_frozen`). L2 fixed a closed list of frame kinds; P2 promised
   every valid timed approval succeeds, which a halted machine must refuse. v0.2 therefore ships two cores that do
   not compose: a ratchet core with 23 laws, and a full core outside that law set. In Wasm, a full core accepted a
   signed halt and its admitted successor refused the same bytes, so that successor cannot replay the history.
2. **Why, in one line:** under "laws can only be added", a rule saying something NEVER happens is free to
   inherit, and a rule saying something ALWAYS succeeds forbids every later restriction. v0.1 froze several of the
   second kind. Nothing real has inherited them yet, so the root can still be restated once. Round 12 section 0
   does that first.
3. **The upgrade frame is still not unique.** Astra left proof bytes free. Round 12 binds them.
4. **The judge is self-reported.** The law identity includes a hash of the checker's declarations, computed by the
   running core about itself. A candidate file's checker is not compared by bytes. Round 12 A.
5. My hostile pass accepted 262 changed frames; all were unsigned events that became a different valid unsigned
   event. I did NOT classify the 38 accepted changes to evidence frames by meaning (for example whether a changed
   class or bound could still pass); the Lean laws cover it, a byte-level check of mine does not yet.
6. Unchanged: no memory bound (round 12 B); proofs are about the model, not the bytes; cryptography tested, not
   proved; the checker trusts 506 earlier theorem statements; raw keys; nothing runs in live x6.1.

## Next
Round 12 (launched 16:42): root v1 so ONE machine carries every law, package binding, judge lineage, bounds.
