# Governed self-improvement, version 0: a spec (Mythos, 22 November 2026, at the owner's word). Nothing here is built.

## Where the idea comes from, and what is checked about the source
An outside reviewer (Mistral) read a 2026 report by Weco AI on an agent that improves the agent that does
research, and mapped three of its events onto this core. Mythos checked the primary text only in part (arXiv
2609.26457, "Recursive self-improvement of AI research agents", submitted 22 September 2026; about a third of the
HTML was read verbatim by a fetch helper).
| Claim in the reviewer's note | Status after the partial check |
| --- | --- |
| The paper exists; an 8-day run with seven accepted improvements | CONFIRMED from the page |
| Reward hacking fell "from 63% to 34%" | NOT confirmed: the text read says "from 55% to 32%" (39% for the human-built agent). Do not quote either number until someone reads the whole report |
| The system built a three-layer defence by itself | PARTLY: the text says the agent added "three robustness mechanisms" that "may account for" the drop |
| One layer worked in an earlier candidate, was broken by a later change, and nobody noticed until people traced the lineage | NOT FOUND in the part read. REPORTED by the reviewer only |
| The agent patched its own private evaluation, which first looked like cheating and was a real bug fix | PARTLY: "a small patch" to a held-out scoring script that crashed. The "looked like cheating" framing was not in the part read |
| A ladder of levels 0 to 3; auditability named as the blocker | NOT FOUND in the part read. REPORTED by the reviewer only |
So: the direction of the argument stands on confirmed ground (a self-improving loop changed its own scoring code;
its safety behaviour was a by-product of selection, not a requirement). The vivid details are unverified.

## What the owner already built that this must start from (parity rows, per the standing rule)
| Existing work | Where | In this spec |
| --- | --- | --- |
| Receipted model generations (gen-10 to gen-18), each with papers; a prediction locked before its outcome | `aukora-genesis` reports of 21 September 2026 | The lineage record is this, moved into the core's record. PORT the discipline, not the code |
| Governed recursion and the safe inward envelope; self-change card; become and roll back | tech ledger, `SCOUT-GENESIS-HONEYPOT.md` l.98 to l.100 | The owner gate for each admitted step. NOT YET in the core |
| Mutation arms: a check must fail when its protection is removed | ledger l.80 | The two sabotage tests below ARE mutation arms. USED as the acceptance method |
| The minimal append-only verifier | `aukora-membrane` | The lineage's head must pass it unchanged once the core has a tree (round 13). NOT YET |
| Weights cell with a skill record (Kyber) | x6.1 | The candidate at the proof-carrying level. NOT YET (job P2) |

## What is true of the core today that the idea can lean on (RAN this week)
A successor that drops any one of 37 pinned laws is refused; a changed install package is refused; a candidate
whose executable differs from the pinned one is refused; every admitted and refused step can be recorded and
replayed; a record survives hostile input. What is NOT true today: the gate cannot admit a changed machine at all
(round 12c), no weights have gone through it (P2), and nothing proves a property of evolved CODE of any size.

## The honest shape: two levels
**Level A, bookkeeping governance (needs no new proof; could be built on v0.4 with scripts).** A loop proposes
K candidates. For each, the record gets: the candidate's digest, the digest of the JUDGE (the evaluation code and
data), the digest of the list of CHECKS that must pass, the scores, the verdict. Rules enforced by a small
harness and checked by replay: the judge digest is the same at every step, and a step that names a different one
is refused unless the owner signed that change as its own event; the check list can only grow; a candidate is
admitted only if every listed check passed, whatever its score; every refusal is recorded with its reason.
What it gives: a self-improvement lineage where the judge cannot be changed quietly and a safety check cannot
be selected away quietly, and a stranger can replay which candidate was admitted and why. What it does not give:
any proof that a check is a good check, or that the candidate does what its checks measure.
**Level B, proof-carrying candidates (after round 12c and job P2).** The candidate is a small integer network
(the P1 lattices, then the Kyber weights). "Safe" is a LAW about its exact bytes that Lean can prove on the whole
input domain, for example: the output does not depend on the untrusted input channel. A candidate enters only
with a checked proof of the pinned law set for its bytes. Then selection pressure cannot remove the law: a
candidate without the proof is not a candidate.
Scale, stated once: Level B is real only for artifacts small enough to carry a proof (dozens of parameters shown;
about 1,300 is the next attempt). It says nothing about an evolved research agent. Level A is what applies to those.

## Acceptance: two sabotage tests, fixed in advance (both levels)
1. THE LOST SAFEGUARD: a candidate that scores BETTER and breaks one required check (Level A) or one law
   (Level B) is REFUSED, and the record names which check or law.
2. THE EDITED JUDGE: a candidate that arrives with a modified judge, including a modification that fixes a real
   bug, is REFUSED as a candidate; the same fix submitted as an owner-signed judge change is ADMITTED as its own
   event, and later steps are judged by the new judge, with both digests in the record.
Report line: `GOVERNED LOOP: steps k, admitted a, refused r; lost-safeguard refused yes/no (which rule);
edited-judge refused yes/no (which rule); judge changes signed n; record replays yes/no`.

## Words that may NOT be used about this
"First"; "ignition"; any level of the other paper's ladder; any claim about capability or about beating their
system; "cannot be hacked". The claim, if both tests pass, is about governance: in this loop a safeguard cannot
be dropped silently and the judge cannot be changed silently, and the lineage can be replayed by a stranger.

## Sequencing (Mythos's call)
Level A can be a script-only piece for the outside builder lane on v0.4 at any time; it needs no Lean.
Level B waits for round 12c (a machine can change under a fixed judge) and P2 (one weight lattice through the
gate). Neither jumps ahead of 12c. Before anything in this file is cited outside the lab, someone reads the
other paper in full and corrects the table at the top.
