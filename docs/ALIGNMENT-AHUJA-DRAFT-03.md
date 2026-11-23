# The Core against draft-ahuja-agent-routing-policy-03. Mythos, 23 November 2026. Private; not for publication.

Read: the full text of version -03 ("A Policy Grammar for Inter-Domain Agent Routing", S. P. Ahuja, Main Labs,
20 October 2026, individual submission, Informational, expires 23 April 2027). SOURCE for every row below is that text.
This is a reading by us, not a statement by its author. No interop is claimed: the draft has no test vectors.

## What the draft is, in one paragraph
Four attributes a domain may attach to a delegation between organisations. Three are bilateral preference signals
(deprioritise me, my ranking, an opaque tag). The fourth, the chain validity attribute, carries the rule that
matters to us: a receiver must not pass on a delegation BROADER than the one it received, judged by a relation
that a pinned, immutable profile defines. A chain is valid when every hop is no broader, each adjacent pair carries
the identical value inside an authenticated relation, every hop used the same immutable profile, and the basis
for composing hops is derived from the definition or mechanically checkable. The draft says it produces no evidence
artifacts, is not an enforcement point, and that a valid chain is not an access-control decision. It has no
revocation and no freshness or expiry. It names no hash.

## Where the Core already has the same shape
| the draft (section) | the Core | how strong the match is |
| --- | --- | --- |
| profile identity must be immutable; else content-addressed; pin the exact definition and refuse if it changed (6) | the law identity: one digest over the pinned law set and its judge; fixed at genesis; a core that does not match is refused at build (genesis check) and at install (judge mismatch) | same idea, RAN on our side |
| a receiver must not emit BROADER than it received (5.4) | a successor law set must entail its predecessor (same or stronger), checked by a proof; and since v0.8 the owner's restriction list only grows (`r_mono`) | same direction, different object: his is a delegation value, ours is a law set |
| composing hops needs a definition-derived or MECHANICALLY-CHECKABLE basis (7, 9) | the entailment proof is checked by a kernel inside the Wasm core at install time | the closest tie: ours is mechanically checked, by construction |
| adjacent hops must carry the identical value, bound in an authenticated relation; the draft's own example (1→1, then 3→2) is NOT a chain (9) | every record line names the head before it; a bound record starts at its own identifier; replay rebuilds the chain from the record alone | same idea; ours is a hash chain with owner signatures on owner lines |
| UNDECIDED must say why: `PROFILE_NOT_HELD`, `NO_COMPARISON_RELATION`; never reported as something else (4, 7) | refusals carry a reason: install reasons 7 (set not satisfied), 8 (entailment failed), 11 (judge mismatch); the lab's sink names `NO_CURRENT_EXACT_PERMIT`, `RECORD_SHORTER`, `RECORD_REWRITTEN` | same discipline; the names differ |
| basis may also be merely `asserted` (7) | our tags: PROVED (kernel), RAN, REPORTED, UNVERIFIED, and every assumption named | same honesty rule, different words |

## Where the Core has something the draft leaves out (its own list of gaps)
Evidence: a record of every admitted line, replayable cold. Refusal that is a decision: the act is refused unless an
exact approval is current. Revocation (cancel) and expiry by record line. Use-once approvals. None of these is
claimed by the draft, and it says so.

## Where there is NO match (do not claim one)
- The three bilateral attributes (5.1 to 5.3). Nothing in the Core.
- `LOCAL_ONLY` (a decided result under a relation that does not compose). No counterpart. An earlier note called it
  part of "our refusal vocabulary"; it is not a refusal at all.
- "A refusal must name its cause" is not a flat rule of the draft. The nearest text is that UNDECIDED states why.
- The draft compares delegation VALUES between ORGANISATIONS. The Core judges one owner's record. A delegation chain
  across domains is not something the Core evaluates today; a lab exhibit can record such evaluations, no more.

## The one decision asked of this track: adopt the draft's status names now, or map later
KEEP OURS IN THE CORE; MAP NOW; ALIAS IN RECEIPTS. Reasons: (1) core reason codes are numbers fixed in vectors and
law text, so renaming them is a new root, not a naming pass; (2) the draft is one individual submission among many,
at -03, with no vectors, and its names may change or lapse in April 2027; (3) the cheap, reversible place for his
names is the human-readable receipt the adapter prints, where an alias costs one table. So: this page is the map;
the adapter may print `UNDECIDED (PROFILE_NOT_HELD)` beside our own reason when a law set or judge is not held or
does not match; nothing in the core's wire or laws changes.

## What to put in front of the author (owner's contact, owner's decision)
1. This page, cut to the two tables. 2. An exhibit: delegation chains per section 9, evaluated and RECORDED in a
core record, re-checked cold by a second reader, including his own 1→1 / 3→2 example ending "not established"
(lab piece, briefed to the builder lane). 3. One question: the separate convergence work, and whether he has
vectors. Do not claim to implement the draft, and do not claim it has no implementation.
