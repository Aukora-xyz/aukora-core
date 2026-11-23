ROOT FINAL: ONE machine, 37 laws, composed YES (kernel-accepted in three builds); same-set and stronger successors pass both gate checks; every one-law omission is refused. LOCKOUT: fixed for owner recovery. FINISHED BY THE SECOND SEAT: an independent re-run is owed. UPGRADES MAY CHANGE: law data only.

# Round 12b, finished and checked by Mythos · 22 November 2026

## How this round ended
The builder (Astra) ran out of usage allowance at 18:17, about 33 minutes in, with the Lean work written and
before any final rebuild, pins, PROVED or NOT-PROVED file, or report. There is NO builder report for this round.
The second seat ran the tree's own build to see its state, found every proof accepted, and finished the
packaging. So the usual separation (one seat builds, another checks) does not hold for the packaging of this
round. Everything below marked RAN was run by the finisher. A seat that did not finish it must re-run it.

## What the second seat did to the tree (all of it)
1. Wrote `v0.4/PINS.sha256` (95 entries) from its first from-scratch build.
2. Regenerated `v0.4/vectors/segments.json.gz` with the test's own documented `--write` step: the stored chain
   vectors had been captured from an interim build and named an older law identity (the only failing test).
   The stale file is kept at `logs/repro12/segments-stale-from-interim.json.gz`.
3. Wrote `v0.4/PROVED.md` (generated from `RootFinal.lean` and Astra's `VERSION-AUDIT.md`) and `v0.4/NOT-PROVED.md`.
No Lean file, script or test was edited.

## Checks (RAN by Mythos, under the 4 GB memory watchdog; no job over the cap)
| What | Result |
| --- | --- |
| Build 1, from an empty work folder | All 96 Lean files accepted, 725 `theorem` lines, no error, no `sorryAx`; both Wasm files built; stopped at the missing pins file. 11 min 15 s |
| Build 2, from an empty work folder, against the pins from build 1 | All 95 pins matched: `aukora-core.wasm` 7,331,989 bytes `138170cca2e079d3b8cc72fa89fc42f396c7b3cad00371c3928a7809ba52817d`; `aukora-core-lite.wasm` 666,064 bytes `8e7cca361db0ef321450e5f5fc70c807957c9e1095314fd533bdd4806abaa311`. Reproducible across two builds on one machine. 12 min 28 s |
| The round's own Wasm tests in build 2 | 28 of 29 test runs passed (gate, judge, capacity on both files, package binding, record compatibility, bounds on both files, checker controls, cell vectors). The 29th (chain vectors) failed on the stale corpus and passes after step 2 above, on both files |
| ONE machine, one law set | `theorem full_lawful : Lawful fullModel` (`v0.4/RootFinal.lean:58`), 37 named laws: the 23 of v0.1 restated over installed versions, 7 evidence laws, 5 safe-state laws, succession, and the version law W1 |
| The gate, in the Lean gate checks of both builds | `same` (37 laws): own satisfied, transition satisfied. `strong` and `strong-next` (38 laws): both satisfied. `wrong-own`: own NOT satisfied. All 37 one-law omissions: transition NOT satisfied |
| The lockout, my own frames (`logs/repro12/mythos-capacity.mjs`) | At 512 lines: speech, a plain approval and a threshold control refused; a valid KEY CHANGE **admitted** (refused in v0.3); the full record replays to the same head; staging stops at 16 MiB |
| My own harness, v0.4 full core on the whole round-11 corpus | 1,838 of 1,838 frames give the stated verdict and head |
| My hostile pass | 3,617 malformed or replayed frames: 0 traps, 0 changes on a refusal, 0 out-of-place frames accepted, halt never cleared |
| Approval replay and unsigned scores (`logs/breakit-grok/`) | Within one record a used or cancelled approval cannot be replayed; an unsigned score grants nothing. Cross-record replay not re-run on v0.4 |

## What is true now (for the first time)
One machine carries every law the lab has proved, in its own gate; a successor that keeps the set, or strengthens
it, passes both checks; a successor that drops any one law fails. A record can be sealed and continued; owner
recovery works at a full record; a halt carries across a seal (Astra's theorems, accepted in my builds).

## What is NOT true (see `v0.4/NOT-PROVED.md`, 20 items)
1. **Upgrades may change law data only.** The successor must carry the identical executable. The machine cannot
   change through this gate. This was round 12b's section C, which the builder did not reach; the sentence here is
   the second seat's reading of rounds 12 and 12b, and round 12c is written to fix it.
2. Nothing yet forbids a FUTURE package or build from pinning a set its machine does not satisfy (round 12c A).
3. The version law has no table a reader can check; one of 40 bridge names in the audit index was not found.
4. An approval is not bound to a record; the newest lines can be dropped; nothing downstream checks a permit.
5. The model-to-bytes gap, the compared-not-proved judge, tested-not-proved cryptography, raw keys: unchanged.
6. Reproduced on one machine by one seat. v0.4 is a lab release, not a release candidate.

## Next
An independent re-run of `sh v0.4/build.sh`. Then round 12c (`BRIEF-R12C.md`): pin implies satisfied, the judge
split from the machine, closed references, record binding, a per-platform build.
