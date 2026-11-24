# What a verdict tells you

Five organs each report 18 private cells and eight shared corners. Each corner has two owners, and every pair of organs shares exactly two corners (`homes`, `two_witnesses`). A *body* assigns one value to each of the 90 private cells and 20 shared corners. A *truthful report* gives that organ's values from one specified body. When a result assumes four truthful reports, there must be one body whose corresponding views equal all four reports. The packet contains no timestamps, so readings taken at different times can satisfy this premise or fail it; two accurate readings taken either side of a change can disagree.

## Reading five reports

The Lean function `judge` accepts a packet as well formed when it contains exactly 130 bytes, each 0 (failed), 1 (unknown) or 2 (passed). A result below 256 implies the packet is well formed and the two owners agree at every corner (`judge_agrees`). With that agreement, exactly one body fits the reports (`no_seam_one_body`). Agreement alone says nothing about whether this body matches the world. Two owners can give the same wrong value.

Each organ's three counts add to 26 regardless of who told the truth (`organ_triangle`). For agreeing reports, the address identifies the body described by those reports (`address_injective`), and its centre is zero exactly when all 110 cells passed (`centre_zero_iff`).

The five-report **stamp** is, for the Lean function and a byte array `b`, the statement `judge b = 0`. That holds exactly when the packet is well formed, every shared corner agrees and every reported cell passed (`judge_zero_iff`, `go_iff`). If all five report truthfully, this says every cell of the actual body passed (`honest_go`). A single reported failure or unknown stops the stamp, even if the report is wrong (`any_part_can_stop`).

## When one organ may report anything

Suppose the four organs other than **x** report truthfully about the same body. If x gives a wrong value for a shared corner, its other owner exposes the disagreement, called a *seam* (`corner_lie_caught`, `corner_lie_caught'`). Any seam puts x among the suspects (`liar_among_suspects`). A single disputed corner leaves both owners as suspects. Two disputed corners with only x in common identify x alone (`convicted_alone`). With no seams there are no suspects.

With those same four truthful reports, a failed or unknown corner in the body prevents the stamp from passing, whatever x says (`one_part_cannot_force_go`). If the caller supplies x's index, `heal` reads the true value at any of the 20 corners from another owner (`four_see_all`, `heal_true`). The byte interface still needs a valid fifth report as filler. The caller must already know which organ to leave out. Its 18 private cells are undetermined by the four reports.

Two limits have concrete examples. **Two owners together** can report pass at their failed corner and obtain a stamp with the other three truthful (`two_owners_can_force`). **One private cell** has only one reporter. Changing private values leaves corner agreement unchanged (`private_cells_unwitnessed`). An owner can conceal an unknown private value and obtain a stamp with the other four truthful (`private_fault_can_be_hidden`).

## When one organ is offline

The four-report rule `go4` ignores the named offline organ. It requires all online entries to pass and both owners to agree wherever both are online (`go4_iff`). With four truthful online reports, acceptance means exactly that all 20 corners and all online private cells passed. It says nothing about the offline organ's private cells (`honest_go4`).

If one online organ may also report falsely, assume the other three are truthful. A failed or unknown corner still forces rejection whenever one of those three owns it (`one_part_cannot_force_go4`). Each online organ shares exactly two corners with the offline one (`two_unwitnessed_corners`). At those two corners, that online partner is the only reporter left. In the example proved by `offline_neighbour_can_force`, the partner hides a failed corner and the four-report rule accepts.

## What the seal and executable establish

The **seal** is the sum of the 20 corner values modulo three. Four truthful views determine it (`seal_known_to_four`). For any three views drawn from one body, a corner unseen by those three can be changed to produce each possible seal while keeping their views identical (`seal_hidden_from_three`). The theorem assigns no probabilities to those possibilities. The seal has no role as a key.

The proofs describe the Lean functions. No proof here equates the compiled Wasm bytes with those functions. The JavaScript checks exercise selected packets, and the shipped file has no four-report export. Outside the stated cases, the results give no general way to identify wrong reports or recover the true body. Nothing forces a real system to call the judge or act on its answer.

Every all-pass body has the same address, 3^110 − 1 (all 110 base-three digits are 2), so the address cannot distinguish two all-pass runs; the evidence is the reports, not the address.
