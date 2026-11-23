UPGRADE BOUND TO BYTES: yes | EVENTS IN WASM: 13 of 13

# Round 4 · 22 November 2026

[Core4.wasm](core/Core4.wasm) is **286,807 bytes**, SHA-256 `e95a4879a37d11726dc7a51a57462aacc0df1400d49e670501a4cdec58cb80f6`. A fresh build from the local Lean sources and eight runtime units reproduced every byte. The module has zero imports and exports only functions.

## What ran

Two fresh Node instances accepted the same grant for the SHA-256 of the 209,455-byte `core/Core3.wasm`. Both received 52 chunks and the same upgrade frame.

| Bytes fed to the running core | Verdict | Core and head after the attempt |
| --- | --- | --- |
| Original file | Accepted | `core` equalled the file’s SHA-256, `b36b84988012b4169ebff84d04dbafa4d8001990be8e625d36d78831051cce8a`. The head advanced. |
| One bit flipped at byte offset 104727 | Refused | `core` remained 32 zero bytes and the head stayed at the grant. Restaging the original then succeeded. |

The module accumulates the candidate in private memory and hashes it on upgrade. The upgrade binds approval to exact candidate bytes under the SHA-256 assumption below, while the host still reports the proof verdict through `proofChecked`. Acceptance updates the core digest. The original Wasm instance continued executing after the update. Owner-signature verification also remains with the host.

## What Lean checked

- **Core changes.** Across feed, reset and submit, only an accepted upgrade can change `core`. Its computed digest must match both the claimed target and the install intent of an unspent, current-generation grant. The proof flag must be true. A genesis witness for the decoded transition establishes that the grant and upgrade can both succeed for arbitrary candidate bytes.
- **Refusal.** An unequal digest leaves the *entire* state unchanged, including staging, with no cryptographic hypothesis. For different byte strings, the theorem assumes only that equal hashes for this particular submitted and approved pair imply equal bytes. General SHA-256 conformance remains unproved.
- **One use.** After an upgrade spends a grant, every later upgrade using that intent fails until another grant for it is accepted, across arbitrary intervening commands.
- **Events and wire.** `step_decoded` connects the decoder to the byte-checked transition. Every acceptance produces precisely the round-2 ledger successor. All nine original families and all four additions ran in Wasm. Retract, mandate, spend and pass use eight wire operations, including issuance, use, read and revoke. Lean checked the `say` and `grant` encode/decode round trips for all values fitting their fields. Sequence is now unsigned 64-bit little-endian. Other numeric fields and lengths remain 16-bit, including expiry and history IDs. A frame or individual chunk is capped at 65,535 bytes.

## Trusted files and retained failures

The hand-written build and ABI files, with line counts, are `spike/r4/interface.c` 84, `spike/r4/reachable.py` 126, `spike/r4/build.sh` 49, `spike/r4/shim.c` 3, `spike/runtime-r3/shim.c` 8, `spike/runtime-r2/include/lean/config.h` 4 and `spike/r3/private-exports.py` 53. The Lean kernel, compilers, linked runtime and Node engine are trusted. Under `core/`, executable model and codec sources are `Core.lean` 506, `Core2.lean` 356, `Sha256.lean` 93, `Wire4.lean` 178, `Bound4.lean` 123 and `Stateful4.lean` 132. The test harness uses `spike/r4/call.mjs` 157 and `events.mjs` 87. Execution controls are `spike/r3/watch.py` 24 and `spike/r4/serial.py` 12.

Earlier builds exposed two missing runtime symbols, six unwanted WASI imports and a stack overflow on a valid maximum-size frame. The repaired module passed that frame and the strict UTF-8 tests. The transcript includes the failures, axiom lists, line counts for the proof modules and upstream runtime, and reproduction commands. [R4 checks](logs/R4-CHECKS.txt)
