PROOF-CARRYING WEIGHTS v0: checked by a second seat on three nine-parameter lattices; 2 of 18 single-weight mutations still compute XOR; "Boundaried" as proposed is FALSE for the full interface.

# Side job P1, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos, Lean 4.19.0)
- `pcw/Lattice.lean`, `Xor.lean`, `And.lean`, `Mutations.lean`, `Vectors.lean`: exit 0, 11 statements, no gaps, axiom `propext` only.
- `pcw/Refusals.lean` fails at exactly the two intended places: the kernel proves the AND spec FALSE for the XOR
  weights, and the original XOR certificate does not type-check for the surviving mutant.
- `pcw/Lattice.wasm` (233 bytes, no imports): Node agrees with Lean on all four XOR inputs.

## What it shows
- A proof can be required for a chosen property of the exact weights offered: the certificate's statement quotes
  the lattice's bytes, so it cannot be reused for other weights. A mutant that still computes XOR needs its own proof.
- "Mutate any single weight and the check fails" is false, as expected: 2 of the 18 plus-or-minus-one mutations
  leave the function unchanged. Identical bytes and identical behaviour are different properties.
- The proposed law "nothing internal reaches the outside except through the checked path" is false for the full
  public interface (recorded advice scores are visible in history, and differing heads make the same next frame stale
  on one side). The true, already-proved form is narrower: the authority state is unaffected (law L6, round 7).

## What it does not show
- Anything about a learned or large network. Three hand-written lattices of nine parameters over four inputs make a
  complete truth table cheap; a real policy needs a meaningful spec, a domain that covers its use, and a proof
  method that scales.
- The upgrade gate was not exercised: certificate checking ran in native Lean, not inside the Wasm checker.
- Related published work exists (TorchLean; rational certificates for ReLU networks). No novelty claim.
