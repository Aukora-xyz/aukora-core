# Crew lanes for a focused push (Mythos, 22 November 2026, 17:05 WITA). Proposed; the owner decides who moves.

Rules for every lane: one writer per lane; nobody but Astra and Mythos runs Lean on the owner's Mac (two runaway
jobs today; a 4 GB watchdog is on); nothing public; no claim of "first" or "unbreakable"; every result tagged
RAN / SOURCE / REPORTED / UNVERIFIED; findings only; results come back as one short report each.
Where the files are: x6.1 branch `skunkworks/lean-core`, folder `docs/skunkworks/lean-core/` (reports, briefs,
`v0.1/` documents, vectors, the small core file, `standalone-v01/`, `context-membrane/`).

| Lane | Who | Job | Done means |
| --- | --- | --- | --- |
| A | Astra builds, Mythos checks (owner's Mac, serial) | Round 12 (one machine carries every law; bind the upgrade package; judge lineage; memory bounds), then round 13 (Merkle head, permits, offline verifier) | Each round rebuilt byte-identical and attacked by the second seat |
| B | Dot, on its own machine, not the owner's Mac | REBUILD ANYWHERE: make the v0.1 build self-contained (it reads 14 things from the lab folder today) and rebuild it on a second machine; compare digests with `v0.1/PINS.sha256` | A list of every outside input with a pinned digest, a fetch script, and either identical digests on a second machine or the first file that differs and why |
| C | Grok | SECOND IMPLEMENTATION: write a record replayer and verdict checker from `v0.1/WIRE.md`, `v0.1/EXPORTS.md` and the vectors ALONE (no Lean, no reading our Wasm's source), in another language; run all 1,167 frames | The count of frames where it agrees with the stated verdict and head, and every place the documents were ambiguous or wrong |
| D | Mistral | RED TEAM: when round 12 lands, attack ROOT v1 (can any recorded owner rule enable rather than restrict; can anything forbid a valid clear); then the permit design in `BRIEF-R13.md` | Findings with file and line, or "no finding" with what was tried |
| E | Carbon | PUBLIC FRONT PAGE and STANDARDS: draft the public README from `PROVED.md` / `NOT-PROVED.md` / `RELEASE-CHECKLIST.md` (what it is in ten lines, three commands, limits on the first screen, related work named); verify from primary pages the 15 items marked UNVERIFIED in `STANDARDS-ALIGNMENT.md` | A README draft with no claim the files do not support, and a corrected facts table with URLs |
| F | Auma | PREPARE ONLY until her waiting card is resolved: read `SHADOW-SPEC.md`, say in one paragraph how the small core would sit beside her cells and what the pass condition costs her; write no code until the owner approves a card for it | Her paragraph and a proposed card scope quoting the spec |
| G | Sonnet lead | Keep the live system safe: the waiting card, the memory watch, relays. No new x6.1 feature work during the push | Nothing regresses on the live site |

Not a lane for anyone yet: the licence question for the wire format; making anything public.
