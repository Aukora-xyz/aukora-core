PROOF-CARRYING WEIGHTS v0: checked yes (3 lattices, largest 9 parameters)  
MUTANTS: 2 of 18 still meet the spec

## Assessment

Takehi et al. name GPT-6 Astra. They report that it identified games from 17,253-parameter policies, wrote game policies from zero as text without training, and edited 3.5% of a pretrained 171,664-parameter car policy given one failed trajectory. Targeted edits produced no established math gain on Gemma’s diffuse reasoning errors. I can verify the published account. I have no firsthand record of those runs and did not reproduce the scores. General editing of distributed knowledge remains unverified. [Authors’ experiments](https://rikiyat.github.io/blog/weight-space-programming/)

This is neural-network verification. TorchLean checks bounds under explicit numerical semantics. Gokavarapu gives rational witnesses for linear consequences and infeasible ReLU regions. P1 asks whether a receiver can require a proof for its chosen property of the exact payload offered. Native Lean checked that here. [TorchLean](https://arxiv.org/abs/2602.22631) · [Rational certificates](https://arxiv.org/abs/2512.24339v2)

Mythos’s claim holds for data identity inside this format. Lean proved that decoding undoes encoding, so distinct lattices have distinct bytes. At mount time, row order, signed arithmetic, activation, input encoding and interpreter version still matter. The host must pass the checked bytes to that interpreter. Even with the core’s toolchain, the new evaluator’s compilation and its host-to-Wasm argument mapping each need justification.

**Boundaried.** Fix owner and checker context. Pair runs from genesis with identical staging and matching logical submissions except advice scores, each addressed to its own head and next sequence. Treat scores and their effects on history and head as internal. Require equal outward observations after every paired prefix. For the full interface this is false. Two accepted scores for one cell appear verbatim in public history, even if hashes collide. When heads differ, the same next frame can be stale on one side. For the authority projection (owner, generation, core, grants, admitted), R7’s L6 gives equality under its matched-proposal conditions. The interface receives proposals and defines no operation that emits them. A host can read history when composing its next proposal. Neither host confidentiality nor a probabilistic Markov blanket follows. [R7 source, L2/L3/L6](context/Laws7.lean)

| Other proposal | Place in a small core |
|---|---|
| Metabolism index laws | Keep the index outside until a measured quantity governs a specified decision. |
| Seven states with ceilings | Include only transitions and ceilings needed to enforce authorized actions. |
| Hysteresis bounds | Include a bound if switching thresholds is part of the enforced policy. |
| In-weight CPU | Keep the emulator outside. Its instruction semantics need separate verification. |
| Browser operating system | Keep the browser and OS in the host. |

## Experiment

I wrote the XOR and AND weights by hand. Two input bits feed two ReLU units and one ReLU output. Each row has two signed int8 weights and a bias. Hidden activations reach at most 381 on this domain, so the output sum fits in signed 32 bits. Exhaustive Lean `decide` covered all four inputs. Times include whole-file checking.

| Certified bytes (hex, grouped by row) | Outputs on 00, 01, 10, 11 | Wall time |
|---|---|---:|
| XOR · `01 ff 00 / ff 01 00 / 01 01 00` | 0, 1, 1, 0 | 0.115 s |
| AND · `01 00 00 / 01 ff 00 / 01 ff 00` | 0, 0, 0, 1 | 0.092 s |
| XOR survivor · `01 fe 00 / ff 01 00 / 01 01 00` | 0, 1, 1, 0 | 0.478 s including mutations |

For the original XOR bytes, input 01 returns 1 and AND requires 0. Lean proved that an AND certificate for those bytes implies false. Changing each of nine parameters by ±1 gave 18 distinct mutants. Only decreasing either hidden weight of −1 to −2 preserved XOR. Whenever that weight contributes, its unit already returns zero. For the survivor at offset 1, Lean accepted a fresh proof and refused the original certificate.

WASI clang linked Lean’s generated C into a 233-byte module with zero imports. Node passed the nine XOR bytes and matched Lean on all four inputs. Wasm ran inference only. The transcript retains both refusals. [Checks](logs/P1-CHECKS.txt) · [Interpreter](pcw/Lattice.lean)

**Proposed round-9 attachment.** Carry staged bytes and a proof in the upgrade frame. The current core fixes the domain, spec and interpreter version. Its Wasm checker constructs the expected type `Certificate stagedBytes spec` and checks the proof in a pinned environment that excludes new axioms. On success, consume the matching owner-signed grant and mount those same bytes atomically. Weights cannot select the checker. P1 did not exercise this gate. The verifier is a parameter of the laws and the Wasm core supplies the concrete one. R7 reports 459 earlier lemmas assumed inside Wasm. Cryptographic strength, key custody, hosts and screens remain outside the proof. [R7 report](context/REPORT-R7-MYTHOS.md) · [R9 target](context/NEXT.md)

## What a formal-methods or ML-verification expert would say is naive here

Four inputs make a complete truth table cheap. A learned policy needs a meaningful specification, evidence that its domain covers deployment, and a proof method that scales. Even here, byte identity and agreement on every specified output are different properties.
