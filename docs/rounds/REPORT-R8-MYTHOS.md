ML-DSA-65 INSIDE: yes, verified by a second seat against Node/OpenSSL on fresh keys. HYBRID CORE: rebuilt byte-identical. RISK LAWS: 18 new theorems accepted. The gate still admits only two listed candidates, and the cryptography is tested, not proved.

# Round 8, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos)
| What | Result |
| --- | --- |
| `sh spike/r8/run.sh` from the recorded sources | **PASS Round 8** in 6 min 13 s, no errors, no gaps. Pinned hashes matched: `Core8.wasm` 5,535,664 bytes `3a3952bf1e76e03373ccf439bf8d0ac5270eabe4364b1f0ee019381e22f52d04`; `Mldsa8.wasm` 142,148 bytes `d0613bcdb04ff787191d543971b0ef5a9126b63f58df5f5d2a59d59b1ef3e94e`. Transcript `logs/R8-mythos-rebuild.txt` |
| Lean statements | 18 new named theorems (`Risk8` 8, `Floor8` 6, `RiskWire8` 2, `Stamp8` 2), all accepted |
| My own test of the Lean-written ML-DSA-65 verifier (`logs/repro8/mythos-mldsa-test.mjs`), six fresh key pairs from Node's OpenSSL 3.5.4, messages of 0 to 5,000 bytes | valid signatures accepted 6 of 6; refused 42 of 42: a flipped signature bit, a changed message, a flipped key bit, another key, a signature one byte short or long, a key one byte short. About 7.5 ms per check including byte transfer |

## What is true now
- A grant, a rebind and every owner control need BOTH an Ed25519 and an ML-DSA-65 signature, verified inside the
  Wasm core. Astra's runs refused every single-signature case; after a rebind the old pair and both mixed pairs fail.
- Five danger-score laws are theorems: raising a score never turns a refusal into an acceptance; upgrade and rebind
  need the owner's signatures at every score and threshold; only a dual-signed control moves the threshold; an act
  with no assessment counts as score 255; every admitted act names the bundle digest it was assessed with.
- A `stamp` event attaches an opaque beacon value and receipt digest to a head; it can change neither authority nor
  any earlier entry. The core does not verify either value.

## What is NOT true yet
1. ML-DSA-65, like Ed25519 and the SHA functions, is implemented and tested, not proved.
2. The upgrade gate still admits only the two candidates listed by digest (round 9's first job).
3. The owner keys are raw Ed25519 and ML-DSA keys, not a passkey; biometric capture is outside the core.
4. Bundle digests are computed by the host; the core records what it is given.
5. The core is 5.5 MB, mostly the proof checker's environment.

## Totals after round 8
148 statements accepted by the Lean kernel and re-run by a second seat.
