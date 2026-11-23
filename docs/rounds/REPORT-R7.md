LAWS AS ONE PROOF: checked inside Wasm yes (110,211 bytes, 10.858 ms median) | HYBRID RULE: proved yes

The Core6 model keeps all ten stated laws, and Core7 checked their combined proof in Wasm for that candidate, while the link from the model to its executable bytes still rests on a manifest.

## What the gate accepted

With the matching bytes staged and an unspent signed grant, Core7 accepted each candidate’s own proof. It refused the round-six `wrong_digest` proof and both candidates’ proofs when exchanged. Each refusal preserved the head and core digest. The second candidate fixes the genesis owner to a public test key. The two candidate binaries demonstrably accepted grants from different keys. Core6 would use its older certificate policy on its own next upgrade. [Gate transcript](logs/r7/gate-test-1.txt)

Three fresh Wasm instances checked the primary certificate in 26.363, 10.858 and 10.605 ms, excluding initialization and input transfer. The alternate proof was 110,570 bytes. Both exceeded the old two-byte length field. A new frame carries the original proofs intact with a four-byte length and a 1 MiB cap. The round-six checker source is unchanged. [Checker transcript](logs/r7/kernel-check-1.txt) · [Primary proof](logs/r7/model.proof.expr)

## What the proof covers

`Lawful` states L1–L10 over public model operations and observations for every initial key and checker context. Replay retains accepted wire bytes and staging commands. Lean checked that omitting a single feed loses a byte even when both event logs are empty. The statement explicitly identifies the SHA-256 second-preimage assumption and the assumption needed to infer that a verified message was signed by the owner. [Laws and proof](core/Laws7.lean)

L6 compares the same proposals at each run’s own head. A control signs its header, so the two local signatures must have the same verification result. In two Core6 instances, different advice scores produced different heads. Copying a mandate signature let only one run admit the act. Signing the other header allowed the second run to admit it too. [Trace proof](core/Advice7.lean) · [Wasm witness](spike/r7/advice.mjs)

The checker pins a 40-byte goal and a 3,975,882-byte environment of 3,098 declarations. It checks the carried proof against 459 trusted theorem statements, including 17 round-seven helpers checked by native Lean. Neither complete `Lawful` theorem is in that environment. The checker, runtime, adapters, compilers, Wasm engine and cryptographic implementations remain trusted. [Declaration inventory](logs/r7/laws.env.tsv) · [Hand-written files and line counts](logs/r7/trusted-lines.txt)

## Hybrid signatures and SHAKE-256

Native Lean proved that every new grant needs both verifiers on the same message. Both old keys must verify a rebind that names the current generation and both replacement keys. Rebinding clears the grants. These rules govern the abstract hybrid machine. The Core7 Wasm artifact uses Ed25519. [Hybrid model](core/Hybrid7.lean) · [Kernel results](logs/r7/hybrid-2.txt)

SHAKE-256 reproduced the 64-byte empty-string and `abc` vectors in Wasm and matched OpenSSL in 72 further comparisons. Median times were 0.036 ms for empty input to 64 bytes and 1.056 ms for 4,096 bytes to 64 bytes, excluding JavaScript byte transfer. [Implementation](core/Shake7.lean) · [Measurements](logs/r7/shake-attempt1.txt)

**ML-DSA-65 implementation plan.** Decode the 1,952-byte public key and 3,309-byte signature. Unpack the 48-byte challenge, five 640-byte response polynomials and 61-byte hint field. Reject unordered or duplicate hint indices, excess hints, nonzero padding and response norms ≥524,092. Add SHAKE-128 to expand the 6×5 matrix. Implement length-256 forward and inverse NTTs modulo 8,380,417, compute `Az − c·2¹³t₁`, apply the hints and rehash the reconstructed high bits with the FIPS 204 context-bound message digest. Compare all 48 challenge bytes. Test against independent positive, negative and malformed vectors before wiring the verifier into the hybrid machine. [Pinned reference implementation](https://github.com/pq-crystals/dilithium/blob/d35ba3fe5449bee3e6d43e1f296c3ca818bd36be/ref/sign.c)

Budget **400–800 Lean lines, 20–80 KiB of additional Wasm and 8–40 ms per cold short-message check**. This is an engineering estimate. About 150 Keccak permutations for matrix expansion alone would take roughly 5 ms at the measured SHAKE rate, before 18 transforms, polynomial arithmetic, unpacking and other hashes. Full ML-DSA verification remains future work.

The clean offline rebuild passed with `sh spike/r7/run.sh`. All four Wasm files and both proofs matched their pinned hashes. [Checks and retained failures](logs/R7-CHECKS.txt) · [Every Wasm SHA-256](spike/r7/pins.sha256)

| New Wasm file | Bytes |
| --- | ---: |
| [Proof checker](core/Kernel7.wasm) | 5,141,599 |
| [Upgrade gate](core/Core7.wasm) | 5,401,782 |
| [Fixed-owner candidate](core/FixedOwner6.wasm) | 1,970,872 |
| [SHAKE-256](core/Shake7.wasm) | 70,788 |

Seven GitHub responses totaled 67,951 bytes. After cleanup the lab occupies 740 MiB. [URLs, commits and byte counts](logs/r7/references/downloads.txt)
