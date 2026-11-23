PIN IMPLIES SATISFIED (v0.6, part A): rebuilt byte-identical by the second seat. The law is a corollary, now a named field; the build fails if the compiled core reports other laws than the ones proved, shown failing on one changed byte. One machine, 42 laws.

# Round 12c part A, verified by Mythos · 23 November 2026, 10:10

| What | Result |
| --- | --- |
| `sh v0.6/build.sh` from an empty work folder, under the 4 GB watchdog | **PASS v0.6** in 798.3 s; no `sorryAx`; largest process 3,497 MB; nothing killed. All 110 output pins match afterwards. `aukora-core.wasm` 7,386,904 bytes `cce58d54673b5413c1401b241df8c79be091bac74cc71acd45cb7721b23a71ae`; `aukora-core-lite.wasm` 674,376 bytes `3bdb8e631b3911ecfda9d28bf785b31611bb5c43bd821345a15644ce528df1f4`. Transcript `logs/R12C-A-mythos-rebuild.txt` |
| Kernel acceptance in my rebuild | `Pin.full_pinned`, `full_lawful` (42 fields); axioms across the printed theorems only `propext`, `Classical.choice`, `Quot.sound` |
| The genesis check, in my rebuild | real core accepted (embedded and proved identity both `0542e7a5…9699`); the same core with one byte of the proved identity changed REFUSED; the round-12 description refused |
| My own control | a 37-law core (v0.5) reports identity `5ef62914…` and is not accepted against the 42-law identity; the full and small v0.6 files report the same identity |
| My harnesses on the part-A files | binding 32 of 32 and start edges 30 of 30 on both files; round-11 corpus 1,838 of 1,838; 5,427 hostile frames, 0 traps; adapter 34 of 34 |
| SOURCE read | `pinned` is stated over the step function and proved for ANY model from `succession` and `upgrade` (`Pin.of_clauses`), then for the full machine. Wording correct: "the pinned checker accepted a proof", never "the machine satisfies". The check derives its two identities independently (the compiled core's own report; the type of `full_lawful`) |

## Corrections and limits
1. `v0.6/SOURCE.sha256` was stale by one entry (`PINS.sha256` was rewritten after it). Refreshed by the second seat; 147 entries, all match. The build does not read that list.
2. The round-12 fixture test shows only that two different GIVEN identities are refused; its two values are stated in the file, not recomputed. The changed-byte control on the real core is the evidence that the check can fail.
3. The genesis check is a build step, not a theorem. A release built by another script would not run it.
4. Standing limit 2 is unchanged: the checker's "accepted" is not proved to imply the Lean proposition.
5. The largest job still peaks at 3.3 to 3.5 GB. Cause now known (SOURCE and the per-file peaks): one counterexample proved by plain `decide` at `Proofs/Evidence11.lean:331`, not the root, whose check peaks near 550 MiB.
6. Everything in `REPORT-R12C-D-MYTHOS.md` "What is NOT true" still stands, above all blocker 12: these 42 laws need one more restatement (`logs/ROOT-V2-CARD.md`).
