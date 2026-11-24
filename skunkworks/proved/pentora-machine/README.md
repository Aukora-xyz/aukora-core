# The Pentora machine: five cubes, shared corners, one body. 24 November 2026

A dodecahedron holds five cubes. Each cube has 27 cells; each cell holds one of three values. The cubes overlap only
at their corners, and that overlap has an exact shape. This folder builds the figure in exact arithmetic, proves its
shape in the Lean kernel, proves what the overlap is good for, and compiles the result to a WebAssembly file anyone
can run.

    node skunkworks/proved/pentora-machine/check.mjs            # the compiled file against plain code (Node only)
    node skunkworks/proved/pentora-machine/check.mjs control    # must FAIL
    LEAN=/path/to/lean-4.19.0/bin/lean sh check.sh              # the proofs again, about ten seconds

## The figure (`Pentora.lean`, part 1; these six theorems use NO axioms)
Coordinates are numbers a + b·φ with whole a and b (φ² = φ + 1). No decimals, no rounding.
- `twenty_vertices`: 20 different points, all at the same distance from the centre.
- `five_cubes`: each of the five listed sets of eight is a cube (every corner sees three others at an edge, three
  across a face and one across the body).
- `each_corner_in_two`: every corner belongs to exactly two cubes.
- `each_pair_shares_two`: every two cubes share exactly two corners.
- `cube_has_27`: each cube has 12 edge middles, 6 face centres, 8 corners and one centre, the same centre for all.
- `figure_110`: the 90 edge and face cells are all different points and different from the 20 corners, so the figure
  has 110 outer cells and ONLY the corners are shared; they lie on three shells (30, 60 and 20 cells).

## The machine (`Pentora.lean`, part 2)
Five organs. Each reports its own cube: 18 private cells and 8 corners, every cell failed, unknown or passed. A corner
is therefore reported twice, once by each of the two organs that share it.
- `gluing`, `view_glue`, `glue_unique`: five reports agree at the shared corners exactly when ONE body stands behind
  all five, and then there is only one such body.
- `two_witnesses`: every two organs share exactly two corners, so every pair of organs checks each other twice.
- `corner_lie_caught`: an organ that misreports a corner is contradicted there by the corner's other owner, if that
  owner reports truly.
- `seam_names_liar`, `liar_among_suspects`: if only one organ misreports, every disagreement is at one of its
  corners, and it is always among the suspects (the organs that own every disagreeing corner).
- `convicted`: two disagreeing corners with one common owner leave that owner as the only suspect.
- `private_cells_unwitnessed`: THE LIMIT. Agreement reads only the corners. What an organ says about its 18 private
  cells is its own word and no other organ can contradict it.
- `triangle`, `organ_triangle`: passed + unknown + failed is always 26 for an organ: its health is a point in a
  triangle (a fixed total split three ways). `health_zero_iff`, `health_two_iff`: health 0 means every cell passed,
  health 2 means some cell failed.
- `address_injective`, `address_lt`, `fits_22_bytes`: the 110 cells of the body read as one number in base three
  fit in 22 bytes (and not in 21), and the number IS the state: two bodies with the same address are the same body.
## Three levels of knowing (`Pentora.lean`, part 3)
A private cell has one owner. A corner has exactly two. The centre belongs to all five cubes. From "exactly two":
- `four_see_all`, `heal_true`: SELF-HEALING. Any four organs hold every one of the 20 corners. If one organ lies, is
  broken or is silent, the other four give back all 20 true corners.
- `seal_known_to_four`, `seal_hidden_from_three`: THE SEAL. Let the seal be the sum of the 20 corners, counted in
  threes. Any four organs know it. Any three do not: whatever three organs see, there is a body that looks exactly
  the same to them with ANY seal you name. So a value can be kept by the five so that no three of them, a majority,
  can read it, and any four can. This is a known construction (replicated secret sharing, four of five); what is
  proved here is that this figure carries it, because every two organs own a corner nobody else owns (`blind_corner`).
- `centre_zero_iff`, `local_fail_reaches_centre`, `centre_of_address`: THE CENTRE. The one cell of all five cubes has
  no digit in the address. It is read off the other 110: clear exactly when every cell passed, failed as soon as any
  one organ sees a failure, and fixed by the address, so nothing can set it by itself.
39 theorems in all; axioms `propext`, `Quot.sound`, and `Classical.choice` in two (`check.txt`). No `sorry`.

## The compiled file (RAN)
`pentora.wasm`: 151,039 bytes, no imports, SHA-256
`f735a7f915b97c80a7fbca9b6450ff72733f549207702aba3a8b54f8ced3596f`, compiled from `Pentora.lean` and `Entry.lean`
by the same route as the core's small file (Lean to C to WebAssembly; `interface.c` is all the C that was written).
Input: 130 bytes, five reports of 26 cells (0 failed, 1 unknown, 2 passed). `judge()` answers 0 to 242 (the reports
agree; the five healths in base three), 256 + v (the two owners of corner v disagree), or 0xFFFFFFFF (not that
shape). `seams()`, `suspects()`, `addressByte(i)`, `tally(c, t)`, `seal()`, `centre()`, `heal(x, v)`, `owner(v, w)`,
`vertex(c, j)` give the rest.
`check.mjs` rebuilds the five cubes on its own, in exact arithmetic, and compares: 11,633 checks, 0 failed, on 400
generated bodies, 391 single liars (each among the suspects, 241 convicted alone, all 391 healed by the other four),
400 private changes (unseen, as the limit says), 400 seals hidden from three organs, 5 malformed inputs; a planted wrong expectation is reported. The figure is thus computed by three
programs: `gen.py`, `check.mjs` and the Lean kernel.

## What this is for
One word of 22 bytes that says how a five-part system stands, that each part can check from its own cube, in which a
single false part is named by its neighbours and repaired by them, and whose shared layer can hold a value that no
three parts can read. It fits in a line of a record.

## NOT proved, NOT done
1. The laws are about the Lean text. The compiled file is compared with plain code; that is evidence, not proof.
2. The seal here is one value of three per body. `seal_hidden_from_three` says three organs' views rule no value
   out; it does not speak of probabilities, of timing, or of what the organs learn another way. It is not a new kind
   of cryptography and it is not a hash: the address is the state itself, 174 bits and no more.
3. Two organs that both own a corner can misreport it together, unseen. With disagreements at one neighbour only,
   there are two suspects, not one. `liar_among_suspects` assumes every other organ reports truly.
4. Any layout in which every shared cell has exactly two owners has the gluing and fault laws. What this figure adds,
   and what is proved for it, is that every pair has exactly two witnesses, with nothing shared three ways. It is not
   claimed that this beats another layout with the same property.
5. It is an instrument. A verdict carries no authority, the core's record machine does not use it, and it is wired
   into no live system. What the cells MEAN (which checks an organ runs) is not part of this file.
6. The WebAssembly file was built in the lab; the build needs the lab's small runtime, which is not in this tree.
   Nobody outside has rebuilt it.
