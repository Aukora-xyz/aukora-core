# The Pentora machine: five cubes, shared corners, one body. 24 November 2026

Five organs each report the outer cells of one cube in a dodecahedron. Among the sampled outer cells, only corners
are shared. All five cubes also share the origin. When both owners of every corner agree, the five reports describe
exactly one body. Its 110 trits fit in a 22-byte address. Each organ supplies its own check results. The machine's
verdict carries no authority.

Run these commands from the repository root.

    node skunkworks/proved/pentora-machine/check.mjs
    node skunkworks/proved/pentora-machine/check.mjs control    # a planted wrong expectation must fail
    LEAN=/path/to/lean-4.19.0/bin/lean sh skunkworks/proved/pentora-machine/check.sh

## The sampled geometry

The six geometry theorems in `Pentora.lean` check the listed points and tables in exact arithmetic. Coordinates
have the form a + b·φ for integers a and b, with φ² = φ + 1.

- `twenty_vertices` checks that the 20 listed points are distinct and all have squared radius 3.
- `five_cubes` checks five lists of eight vertices. From each vertex the other seven have the cube's distance
  signature, with three at squared distance 4, three at 8 and one at 12.
- `each_corner_in_two` and `each_pair_shares_two` check both incidence counts. Each corner has two owners,
  and each pair of distinct cubes shares two corners.
- `cube_has_27` checks 12 edge midpoints, six face centres and the common origin for each cube.
  Together with the eight corners, these give 27 sampled cells per cube.
- `figure_110` checks 110 distinct outer cells. The three shells contain 30 face centres, 60 edge midpoints
  and 20 corners. These counts describe the samples. The intersection of the solid cubes is outside their scope.

## Reports, faults and the address

An organ reports 18 numbered private trits followed by eight corners. The model gives the corners geometric
indices. It leaves the assignment of individual private slots to edge midpoints or face centres unspecified.

- `gluing` proves that the reports agree at every shared corner exactly when some body has those five views.
  `view_glue` shows that the constructed body's views reproduce the reports, and `glue_unique` supplies uniqueness.
  Each pair of organs can compare two corners (`two_witnesses`).
- A **seam** is a corner whose owners disagree. With four organs truthful about one common body and one false corner,
  both owners are suspects (by the definition of `suspects`, and observed in the run). The faulty organ owns every
  disagreement (`seam_names_liar`); its co-owner contradicts a false corner (`corner_lie_caught`).
  If all disagreements involve the same neighbour, both remain suspects. A private-only change to agreeing
  reports leaves zero seams and zero suspects (`private_cells_unwitnessed`). Two owners can also report the
  same false value at a shared corner without producing a seam there.
- If the four other organs report truthfully about one common body and the only disagreements are at two corners
  whose only common owner is organ x, the machine's `suspects()` names x alone. `liar_among_suspects` proves that
  the faulty organ is among the suspects when there is a seam. `convicted` says every suspect equals the proposed
  owner; that holds trivially for an empty suspect list, and its common-owner premise holds vacuously for disjoint
  owner pairs. Neither theorem alone states the claim above, and the extra condition matters: seams at corners 0, 1
  and 8 give no suspect in the Wasm file, because no organ owns all three.
- The passed, unknown and failed tallies sum to 26 per report. Their triple is the triangle point
  (`triangle`, `organ_triangle`). Centre health is computed over the 110 cells of an agreeing body. It is 0
  when all passed, 1 when at least one is unknown and none failed, and 2 when any failed.
  `view_cell_in_body` proves that a trit value occurring in a local view occurs in the body. This carries a
  local failure to the centre. The centre has no separate address digit.
- The address encodes all 110 trits injectively. The largest address needs **175 bits** (`address_bits` states it; `fits_22_bytes` is the 22-byte bound), which fits in 22 bytes.
  Each organ can check its own 26 trits against a supplied body. Changing another organ's private trit changes
  the address while preserving the first organ's view. Equal addresses give equal bodies (`address_injective`),
  hence equal centre health (`centre_of_address`).

## What four or three reports determine

Two distinct owners per corner give four-organ coverage. Exactly two corners per pair explain why any three miss
two. For two distinct omitted organs, `blind_corner` selects a corner owned by that pair.

Given the excluded organ's index, `heal` reads all 20 global corners from the four truthful reports, including that
organ's eight corners (`four_see_all`, `heal_true`). The Wasm call reads one corner at a time and requires a fifth
valid report as filler. The excluded organ's 18 private cells remain unknown. The call writes nothing.

The **seal** is the sum of the 20 corner trits modulo three. Any four organs can read this trit from their
truthful local views. Every possible three-organ view is compatible with all three values. For each target,
`seal_hidden_from_three` sets one unseen corner to a value that gives that sum and preserves the three views.
This is possibilistic hiding.
The theorem gives no probabilities. For example, if all corners copy the same random trit `t`, even one organ can
compute the sum as `20t mod 3`. Any caller with an agreeing buffer can read `seal()` directly.
**Do not use this trit as a key or put secrets in it.**

## Sharper statements (`Sharper.lean`)

Written after outside reviews found that some prose said more than the theorems in `Pentora.lean`. Nothing in
`Pentora.lean` or `Entry.lean` changed. Each theorem here says exactly one thing.

- `convicted_alone`: if the four organs other than x report the body truly, and the reports disagree at two corners
  whose only common owner is organ x, then x is a suspect and every suspect equals x.
- `shift_unseen`, `shift_seal`, `shift_cycle`: leave out two different organs x and y, and move the lower corner
  that only they own one step. The other three organs' views are unchanged, the sum modulo three goes up by one, and
  three such moves give back the same body. (`shift_seal` and `shift_cycle` hold for any corner; only `shift_unseen`
  needs the corner that only those two organs own.) It follows, by an argument in prose that is not a Lean theorem,
  that the bodies with one given three-organ view come in cycles of three, one for each sum. This is a counting fact.
  No probability statement is made in Lean.
- `address_bits`: 3^110 < 2^175 and 2^174 < 3^110, so the address needs 175 bits.
- `judge_agrees`: if the Lean function `judge` (the one exported to the Wasm file) returns a value below 256, the input is well formed (130
  bytes of 0, 1 or 2) and the decoded reports have no disagreement.
- `view_upd`, `bump3`, `seam_code_is_large`: helpers.

## Two figures and the twelve five-point faces (`Twin.lean`)

The golden flip sends φ to 1 - φ. These statements are about lists of listed points; none is about solid cubes.
The two figures share a three-dimensional cube of 27 sampled cells. It is not a flat interface.

- `twin_is_a_pentora`: the 20 flipped points are all different, and the same five index lists pass the same
  distance test there.
- `flip_fixes_cube0`: the listed vertices unchanged by the flip are exactly the eight of cube 0.
- `two_figures_share_one_cube`: each figure's list of cell points (the corners and the middles of all corner pairs
  of each listed cube, at four times size) has 111 points. Exactly 27 points are in both lists, and all 27 are cell
  points of cube 0.
- `rational_cells_are_cube0`: exactly 27 of the figure's 111 cell points have no φ part, and all of them are cell
  points of cube 0. Which cube is "the rational one" depends on the coordinates chosen.
- `shared_corner_three_owners`: each corner of cube 0 lies in exactly one of the other four listed cubes. ("Three
  owners" in a pair of figures is arithmetic, one shared cube plus one cube of each figure; it is not a theorem
  about two figures. It would also need the shared cube to be one reporting identity across both figures, and no
  such protocol exists.)
- `majority_true`: for values a, b, c and t, if at least two of a, b, c equal t then `maj a b c = t`. No machine for
  two figures exists in Lean or in the Wasm file.
- `twelve_faces`, `face_meets_every_cube_once`, `face_has_five_pairs`, `corner_in_three_faces`: the 12 listed
  five-point sets pass a distance test (two neighbours at the edge length and two at squared distance 4); each
  shares exactly two points with each listed cube; their five points have five different owner pairs; each listed
  vertex is in three of them. Flatness (coplanarity) is not checked in Lean, and `twin.py` does not check it either. A reviewer reports
  checking outside Lean that the distance pattern gives a regular planar pentagon, and that each face plane
  holds ten sampled cells (five corners and the five midpoints of their diagonals); being a face also needs the
  other vertices on one side of that plane, which Lean does not check. "Five cells, one byte" therefore describes
  the five corners only.
- `face_fits_a_byte`: 3^5 < 256.

`twin.py` recomputes the same listed-point facts in exact arithmetic.

## The Wasm interface

`interface.c` is the handwritten shim. The shipped `pentora.wasm` is 151,039 bytes, has zero imports and exports
the 12 functions below. Its SHA-256 is `f735a7f915b97c80a7fbca9b6450ff72733f549207702aba3a8b54f8ced3596f`.

Call `reset()`, then call `input(byte)` 130 times. Send five reports in organ order, each with 18 private trits
followed by eight corners in slot order. Input codes are 0 for failed, 1 for unknown and 2 for passed.
`no_seam_one_body` applies to the **decoded reports**. Its premise tests for seams and omits `wellFormed` and
`judge`. For example, 130 bytes of value 3 decode to passes under `reportOf`, but `judge()` rejects the packet.

| Call | Result |
| --- | --- |
| `judge()` | On agreement, 0 through 242 encode the five organ healths in base three, organ 0 lowest. On disagreement, 256 plus the lowest disputed corner index. Malformed input returns `0xFFFFFFFF`. |
| `seams()` | Bit `v` is set for each disputed corner. |
| `suspects()` | Zero when there are no seams. Otherwise bit `c` is set exactly when organ `c` owns every disputed corner. Disputes with no common owner also give zero. |
| `addressByte(i)` | Byte 0 through 21 of the agreeing body's address, lowest byte first. |
| `tally(c, t)` | Number of cells with trit `t` in organ `c`'s report. |
| `seal()`, `centre()` | The corner sum modulo three and centre health, respectively. Both return `0xFFFFFFFF` on disagreement. |
| `heal(x, v)` | Corner `v` read from an owner other than the supplied index `x`. The full packet must be well formed. |
| `owner(v, w)`, `vertex(c, j)` | For corner `v`, selector zero returns its first owner and any nonzero selector returns its second owner. Vertex lookup returns the global corner at local slot `j` of organ `c`. |

## What was checked

The four Lean files declare 77 theorems, including helpers (56 in `Pentora.lean`, one in `Entry.lean`, 11 in
`Twin.lean`, 9 in `Sharper.lean`). The stored axiom audit lists 56 of them and 18 list no axioms. It lists no axioms
for the six geometry results, none for ten of the eleven `Twin.lean` results (`majority_true` lists `propext`), and
none for `address_bits`. Two audited results use `Classical.choice` (`seams_nil_iff` and `no_seam_one_body`).
The other axioms appearing in the audit are `propext` and `Quot.sound`. The Lean sources contain no `sorry`.

The checker loads only the Wasm and computes expected machine outputs in separate JavaScript. Its cube search
closely follows the Python generator. Lean checks the supplied tables. `run-all.sh` invokes both the normal run
and the control with a planted wrong verdict.

The checker recorded 11,633 passing comparisons on its normal run and zero failures. It counted five rejected
malformed cases separately. All 400 generated bodies (301 distinct) agreed and matched their expected addresses. The faulty organ
was a suspect in all 391 corner-fault cases and the sole suspect in 241. All 391 recovered the expected corners
with the faulty index supplied. Of 400 private assignments, 256 changed a trit (144 wrote the value already there) and all preserved the zero seam
mask. A review observation, not re-checked here: the
private-change check and the seal check test properties built into the examples, so on their own they cannot catch a
faulty Wasm file. Each of 400 selected triples saw identical reports for two different sums.

The lab reports compiling the executable definitions to Wasm. The Lean audit checks the source and the JavaScript
comparison exercises the shipped bytes. No live integration or outside rebuild is documented here.

## What each part determines of a field on the sphere (a RUN in exact arithmetic; not a Lean theorem)

A field here is a polynomial in x, y, z read on the unit sphere. Degree at most L means (L + 1)² independent
numbers. A set of sample directions DETERMINES degree L when two such fields that agree in every direction of the
set are the same field. `parts.py` computes this for parts of the figure, exactly, using pairs of fractions to stand for numbers of the form a + b·φ (φ the golden ratio)
(about a minute); its output is `parts.txt`.

| Sample directions | Cells | Determines degree | Numbers |
| --- | --- | --- | --- |
| all five organs | 110 | 9 | 100 |
| any four organs (all 5 choices) | 92 | 7 | 64 |
| any three organs (all 10 choices) | 72 | 7 | 64 |
| any two organs (all 10 choices) | 50 | 5 | 36 |
| any one organ (all 5 choices) | 26 | 3 | 16 |
| corners and edge middles, no face centres | 80 | 7 | 64 |
| the axis cube (one organ) without its face centres | 20 | 3 | 16 |
| the 20 corners / the 30 face centres / the 60 edge middles | 20 / 30 / 60 | 3 / 4 / 5 | 16 / 25 / 36 |

In each row the next degree is NOT determined (the script finds the rank short). Read each row as a promise with a
condition: IF the field has at most that degree, those samples fix it everywhere on the sphere.

It is NOT a coarse reading of a finer field. If the field has more detail than a part can determine, two different
fields can agree on every sample of the part and still have different averages over the sphere.
Example (exact): the degree-8 field (xy(x² - y²))² is zero at every sample of the axis cube and has a positive
average over the sphere.

What this does not say. (1) It is a computation run on one machine, not a proof in Lean. (2) It is not a better count
than other sample sets: for the same number of directions, directions in general position can determine at least as
many numbers (26 general directions determine degree 4, 25 numbers, while one organ's 26 determine degree 3, 16
numbers). A set that contains the opposite of every direction, like these, gives each opposite pair one even and one
odd reading, so 26 such directions give only 13 even readings, fewer than the 15 coefficients of a degree-4 even
part. What the figure adds is that every choice of the same number of organs gives the same highest degree, in exact
arithmetic. (3) The table gives exact recovery guarantees for fields of bounded degree from the listed samples; no
claim is made about recovering an arbitrary stored file. (4) `parts.py` assumes correct readings and supplies no
decoder for wrong reports. (5) This computation examines only the sample directions. (6) It has not been checked
for novelty.

To re-run it: `python3 skunkworks/proved/pentora-machine/parts.py` (about 45 seconds, Python 3 standard library only) and compare with `parts.txt`. It is not part of `run-all.sh`.
