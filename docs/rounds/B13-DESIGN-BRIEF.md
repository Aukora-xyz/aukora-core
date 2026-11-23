# Blocker 13, design brief from the second seat (Mythos, 23 November 2026). NOT a job yet.

The problem, as measured (RAN, `logs/repro12/mythos-long-chain.mjs`, `READINESS-CORE.md` item 13): a running core
traps after about 35,000 lines of 3,000 bytes; a valid owner seal traps too; time per segment grows from 0.23 s
to 1.01 s over 45 segments (`logs/repro12/long-chain-lite-3000.txt`).

## Why, from the source (SOURCE, v0.7; not yet shown by a profile)
The machine's state IS its whole record. Sealing changes the journal and the quota, never `base.record`.
- `Safe11.halted s` folds the entire record: `Safe11.lean:30`.
- `Evidence11.ceiling s` folds the entire record: `Evidence11.lean:150`.
- `Ratchet11.current s` (the installed pin) folds the entire record: `Ratchet11.lean:20`.
- every admitted frame is pushed onto it: `Machine.lean:16`, `Policy.lean:174,185-188`, `Safe11.lean:132`,
  `Evidence11.lean:299`.
- evidence is graded against EARLIER LINES by position: `Evidence11.lean:256-264`, `Root12.lean:13-54`
  (`s.base.record[r-1]?`).
So memory grows without bound by construction, and the halt flag, the ceiling and the pin cost one pass over all
history on every step. `SegmentFinal.resume` (`:109`) continues with the SAME machine; nothing can start cold.

## The cure, in four parts (each a small job after the root v2 skeleton; none started)
C1. **Carried summaries.** The three folds become fields updated per step (`halted`, `ceiling`, `pin`), each with
    a theorem that the field equals the old fold on every reachable state. Per-step cost stops growing. This is
    a schema change, so it belongs to root v2 (same family as the `policy` field), not to the 42.
C2. **A seal commits to the carried state.** Carried state = everything a later step can read: head and next
    sequence, owner keys and generation, installed core and law identity, rules, outcomes, the open approvals
    with their expiries, risk state, the three summaries of C1, the recovery slots, the record identifier and the
    `policy` registers. One canonical encoding, one digest, inside the signed seal. Law `resume_equal`: the state
    after replaying a whole record equals the state after starting from a seal's carried state and replaying
    only the lines after it, on every field a step can read.
C3. **Old lines by proof, not by possession.** After C2 a core no longer holds lines before the seal, but
    evidence may cite them. The seal therefore also commits to a Merkle root over the sealed segment's lines; a
    frame that cites an old line carries the line and its path. Two honest choices to weigh in the card:
    (a) citations across a seal are refused (simple; evidence must be restated in the new segment), or
    (b) admitted with an inclusion proof. The side lab already has the tree, the inclusion proof and the growth
    proof with tests (`skunkworks/onion`, `growth-test.mjs`); (b) would be their first use inside the core, and
    the proof would have to be ported to Lean. Start with (a). Say so in NOT-PROVED.
C4. **Refuse, never trap.** Limits counted in the model (lines and bytes per segment already exist:
    `Bounds12.lean:12-15`), plus a tested reserve so that at the limit a seal, a halt, a clear and a key change
    are still admitted and anything else gets a clean refusal with its own reason. Memory inside Wasm is not
    modelled in Lean, so "the seal always fits" is a TEST with a stated margin, not a theorem. Say so.

## What this does NOT give
A cold start trusts the seal it starts from. Someone must have replayed each segment once (bounded memory per
segment after C1 to C3) or the chain of seals back to the bound genesis. That is the normal light-client position;
it must be written down, not implied. Key changes inside a segment mean a seal is signed by the keys at its END,
so a seal chain is checked seal by seal, each against the carried keys of the one before plus that segment.

## Order
After root v2 skeleton step 3 (the no-lockout law), because C2's carried state must include the registers and
C4's reserve must agree with the "last usable form" guard. First deliverable: a card by the coder against this
brief, as for root v2. First measurement before any design is frozen: a profile showing which of the three folds
dominates the per-step time (cheap: time a step at 500, 5,000 and 30,000 lines with and without a halt).
