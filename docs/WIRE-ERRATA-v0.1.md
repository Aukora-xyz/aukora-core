# v0.1 wire documents: answers to an outside implementer's 14 findings (Mythos, 22 November 2026)
An outside seat wrote a second replayer from `WIRE.md`, `EXPORTS.md` and the vectors alone, in another language,
without reading the Lean or using our Wasm to decide: 1,165 of 1,167 frames matched (1,160 on the merits; the 7
valid install frames need the proof checker and were skipped). It listed 14 places where the documents are
silent or wrong. This file answers what the second seat could settle by test (RAN, scripts in
`logs/breakit-grok/`), and marks the rest for the next `WIRE.md`. Nothing here changes the v0.1 files.

| # | Finding | Answer |
| --- | --- | --- |
| 1 | Files the documents reference were not in the shared folder | True of the shared copy, not of the release tree. The clean export must ship every file a document names, or the document must not name it |
| 2 | Initial owner generation, and that a key change increments it, are unstated | RAN: generation starts at 0; after one key change an approval must name generation 1 (`standalone/test.mjs`). To be written into `WIRE.md` |
| 3 | Ed25519 mode unspecified (strict or not; checks on a new key) | NOT settled. No vector distinguishes them. Needs a statement and vectors (non-canonical S, small-order keys, a rebind to a bad key) |
| 4 | Rules for claim ids in remember/correct unwritten | True. The vectors pin them; the document must state them |
| 5, 6 | Spend, read, mandate matching and the clock for expiries unwritten; u16 expiry against u64 sequence | True. Expiry is measured in record sequence numbers (SOURCE: round-9 brief and laws). The rest must be written and given vectors |
| 7 | "Effective assessment", score against threshold, whether a direct act needs an approval | RAN: a direct act with NO approval is refused at score 0 with threshold 0, at score 10 with threshold 50, and at score 51 with threshold 50. A direct act always needs the owner's approval; the threshold matters only for acts under a mandate. To be written |
| 8 | An assessment is unsigned: anyone can post score 0 | RAN: true, and it grants nothing (see 7). This is law D1 at the byte level: a score never turns a refusal into an acceptance |
| 9 | A tag-13 approval signs the intent only, with no head and no generation outside the intent: can the signature be re-wrapped? | RAN, two results. WITHIN one record: a used approval, re-wrapped under the new head and submitted by anyone, is REFUSED, and so is a cancelled one. ACROSS records: the same signature, re-wrapped, is ADMITTED by a different record owned by the same keys, and the act runs there. **An approval is not bound to a record.** See below |
| 10, 11 | "Recent lines" in retract; renew; which approvals a cancel can reach | True, unwritten |
| 12 | An outcome is accepted for an intent never acted on | True by the vectors. Decide whether that is meant (an outcome is a report, not authority) and say so |
| 13 | The 1b "target" is undefined | It is the SHA-256 of the staged file (SOURCE: `WIRE.md` row for 1b says the intent must name it; the field itself is not defined). To be written |
| 14 | Corpus gaps: blob-bound frames refused before the blob is read; no vector with a valid Ed25519 and a bad ML-DSA | Partly answered by the second seat's own tests (0 of 9,062 one-bit changes to signed frames accepted, including inside each signature), but those are not in the shipped corpus. Vectors to add |

## The finding that matters: approvals are not bound to a record (9)
A tag-13 approval signs `domain("grant")`, the owner keys and the intent. It names no record and no position.
- If one pair of owner keys owns two records, one signature approves the act on both.
- A record that is copied or rolled back to before the approval can admit the same public signature again. Inside
  one history "once" holds; across copies of a history it does not. (A timed approval, tag 18, signs the head and
  sequence and so is bound to its position; the plain approval is not.)
- Genesis carries only the two public keys, so two records with the same keys are indistinguishable at birth.
Smallest fix, for the next wire version: genesis carries a record identifier (keys plus a fresh random value);
every owner signature covers it; a plain approval also covers the head it was issued under, as the timed one
does. What no wire format can fix alone: a host that rolls a record back and replays the same frames gets the
same admissions. Only a head remembered or co-signed outside, and a permit checked downstream, stop a double effect.
