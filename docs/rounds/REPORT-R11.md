EVIDENCE LAWS: 7 of 7 proved | SAFE STATE: 5 of 5 proved | SUCCESSION: closed yes (carried model) | IN THE GATE: no (E/H) | VECTORS: 1,860 of 1,860 agree

**The full machine cannot satisfy the frozen contract.** Lean exhibited an admitted halt outside round ten’s L2 grammar. P2 also requires every valid timed grant to succeed, including in a halted state where H1 forbids it. With identical genesis keys and law identities, the full Wasm accepted a signed halt and its admitted successor refused the same bytes. That successor cannot replay a history containing the halt. [Kernel counterexample](v0.2/Proofs/Round11Safe.lean) · [Selected-file test](logs/r11/safe-recovery-selection-final.txt)

### What survives succession

The gate pins the original 23 laws plus succession. Its view exposes a digest identifying the named clauses and checker foundation. Each install must prove the child model satisfies its set **and** prove `∀ m, NewLawful m → CurrentLawful m`. Succession requires the child model’s own gate to make both checks. Naming the root syntactically breaks the definition cycle. Round ten’s successor was other software, free to pin another meaning. Round eleven covers the carried model under a continued record and trusted checker. [Succession proofs](v0.2/RatchetModel.lean) · [Full outgoing gate](v0.2/Proofs/FullSuccession.lean)

| Staged file and certificate, each with a fresh hybrid install grant | Wasm verdict |
| --- | --- |
| Exact round-nine file, model and proof | Refused, missing two-witness certificate |
| Model satisfying all 23 original laws, with a weaker successor gate | Refused, failed entailment. Claiming the current set instead failed satisfaction. |
| Unsatisfiable set | Refused, failed satisfaction. Its entailment proof passed separately. |
| Same set, then a stronger set requiring standard genesis | Both admitted. Returning to the old set failed entailment. Another strong successor was admitted. |

Proof spelling may vary. The owner signs for the file, which commits the model. The core checks and records the submitted proof bytes. No separate amendment or two-step confirmation exists. [Wasm verdicts](logs/r11/successor-replay-final.txt) · [Trust and costs](v0.2/NOT-PROVED.md)

### Evidence and recovery

Act references must predate their assessment. Observations cite reads or outcomes, reports cite named statements, inferences cite earlier claims, and guesses cite nothing. Direct claims use recorded values, inferences take the smallest premise bound, and guesses use a ceiling changed only by a hybrid-signed owner control. An absence claim quotes an earlier empty-result read’s query digest, with its window ending by that read. Lowering stated confidence preserves admission with other checks fixed. Keeping a reference while changing an observation to a guess fails. Speech keeps its ordinary rules. Legacy assessments list no claims. [Evidence laws](v0.2/Proofs/Evidence11.lean)

The core cannot know whether a claim is true, the tool result was honest, the class was chosen honestly, or the host ran the query. A “seen” tag is the host’s word. It proves bookkeeping: that what an act rests on exists in the record with the right kind, and that confidence never grows. This last guarantee concerns computed bounds. [Exact statements](v0.2/PROVED.md)

A refused act preserves state. The host can append it inside a halt entry for rechecking, or omit the halt and continue. The owner can halt directly. Only a dual-signed clear resumes acts. Speech, outcomes, stamps and recovery remain available. Clear preserves expiry and revocation. Valid clear and rebind both worked after failed staging. Lost keys remain outside H5. [Exact halted legal set](v0.2/WIRE.md) · [Recovery test](logs/r11/safe-recovery-selection-final.txt)

**Nesting.** H4 preserves the full cell’s recorded bytes and their order. E1 and E1b resolve a versioned read or outcome cited by an act. One new law would bind the cell, input and output digests in the cited receipt to that recorded call. Execution remains the host’s assertion.

**Weights.** P2 would admit one literal lattice and prove that its pinned eight-instruction interpreter produces only allowed proposals over a finite input domain. The checker needs a goal quoting the weight bytes and a commitment binding interpreter, program and weights to the file. The carrier supports pinned definitions. New recursion, inductive types and reduction rules are outside it. [Lab design context](NEXT.md)

The clean build reproduced both binaries and all 32 output pins. The cleaned lab occupies **796.4 MiB**, including **15.7 MiB** for v0.2, excluding the two out-of-scope folders. An interrupted optional proof briefly overlapped an interim build. The final watchdog keeps the serial lock with its child process. [Failures and final checks](logs/R11-CHECKS.txt)
