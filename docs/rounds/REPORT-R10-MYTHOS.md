LAW SET: one proposition, 23 laws, rebuilt and re-checked by a second seat. RELEASE v0.1: byte-identical from source. DOWNGRADE: the exact round-9 upgrade is refused. NOT closed: a successor does not have to pin this law set, so the gate is not yet a ratchet.

# Round 10, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh v0.1/build.sh` from source, starting from an empty work folder | **PASS v0.1** in 8 min 46 s, no errors, no gaps (`sorryAx` 0). All three files matched their pins: `aukora-core.wasm` 6,310,580 bytes `50f291fb7a38e0ea7f310cd8647eb48f6a74665774ae6b12be33a81bd2f9b6d4`; `aukora-core-lite.wasm` 552,182 bytes `3311f461aa3ff63ae0d47e97e3840b3fe918d70b4c1d1ad59b88614acba9c841`; `fixtures/fixed-genesis.wasm` 6,323,987 bytes `6e0f8964b68f568ebca32f61338441fb31a96f313a807c2e52826b17c1c97980`. Transcript `logs/R10-mythos-rebuild.txt` |
| Lean | 67 release files, 9,725 lines, 438 `theorem` lines, all accepted in my run. `Lawful` (`v0.1/Laws.lean`) has 23 fields: L1 to L10, H1 to H3 (both signatures), D1 to D5 (danger score), S1 (stamp), P1 and P2 (cancel and expiry), O1 and O2 (outcomes) |
| The downgrade, in my rebuild's gate run | The exact round-9 file with its original model and proof: **refused**. The same file with a new model and a proof for a lawful machine: **refused**. The round-7 proof on the new candidate: **refused**. The newest machine built by the normal route with fixed keys: **admitted**, and a grant then needed both signatures |
| My own harness (`logs/repro10/mythos-v01-test.mjs`, written from `EXPORTS.md` and the corpus README, none of Astra's test code) | Full core: 1,167 of 1,167 frames gave the stated verdict and 32-byte head (195 accepted). Lite core: 1,165 of 1,167; the two differences are the install it refuses by design and the frame after it. One changed bit in the staged candidate file: refused 4 of 4. The round-9 downgrade file staged under the v0.1 grant: refused |
| My own mutation test of the accepted install frame (`logs/repro10/mythos-malleable.mjs`) | 462 single-bit changes in all: 454 refused (state checked unchanged on the first 62); **8 accepted, all in the proof field** (8 of 440 tried there, in bound-variable names). 0 of 14 in the model field; 0 of 8 in the header, target and intent |

## What is true now
- One law set. A successor that verifies one signature only is refused, with a Lean proof that its model breaks H1.
- One clean tree and one build command; a frozen wire format with a reserved escape for future versions; 15
  documented exports; 1,167 conformance frames; `PROVED.md` and `NOT-PROVED.md`.
- A small replay-only core (552 KB) that records and replays everything but refuses every upgrade. The full core is
  6.3 MB; 74% of it is the proof checker's pinned environment.

## What is NOT true (found by this seat)
1. **The gate is not yet a ratchet.** `UpgradeLaw` (`v0.1/Proofs/PublicBehavior.lean:110`) holds "for every
   checker context" and asks only that the checker accepted. The checker builds its goal from the NAME
   `Aukora.Release.Lawful` (`v0.1/Checker.lean:53`), and its base only requires that a constant of that name exists
   (`:13`). What the name means lives in the environment file each core ships. So a successor whose model keeps all
   23 laws could ship an environment where that name means something trivial, and its own successors could then be
   anything. `NOT-PROVED.md` says nobody can change the pinned set "from inside"; that is true of this file and
   says nothing about the next one. Round 11 C1 (the law of succession, by entailment) is aimed at this.
2. **The install frame can be altered and still pass.** It is unsigned, and a proof with renamed bound variables
   is still a proof. The owner's grant names the file, not the package. Not a soundness hole; two different frames
   can install the same file. Raised in round 11 C1b.
3. **Model to file is still a label plus tests.** 1,167 agreeing frames are evidence about `aukora-core.wasm`.
4. ML-DSA's two rejection-sampling loops are `partial` definitions (`v0.1/Crypto/Mldsa.lean:104,115`): Lean
   reasons about nothing inside them. Consistent with "cryptography tested, not proved"; stated here for exactness.
5. Unchanged: the in-Wasm checker takes earlier lemma statements as given; the carried-definition language is
   narrow; raw keys, not a passkey; the host supplies assessments and is believed; nothing runs in live x6.1.

## Totals after round 10
`v0.1/` stands on its own: 438 theorem lines re-checked from source in one command. (Earlier rounds counted 185
statements cumulatively; v0.1 re-proves and reorganises them, so the two numbers are not added.)

## Next
Round 11 (launched 15:50): the law of succession, the evidence laws, the safe state with no lockout, `v0.2/`.
