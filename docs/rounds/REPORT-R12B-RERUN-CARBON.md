RE-RUN v0.4: PASS, digests match yes, sources unchanged yes (independent second seat: Carbon)

Independent clean-build re-run of `v0.4` (Round 12b) on this Mac from an empty work folder, following `CARBON-RERUN-BRIEF.md` Steps 1–7 in one uninterrupted run (`2026-11-22 18:55:38` to `19:07:07 WITA`). What a pass means: on this Mac, from an empty work folder, the same sources reproduce the same two Wasm files and every proof and test passes (`NOT` a claim about a second machine).

| Step | Actual Output | Expected | Status |
|---|---|---|---|
| 1. Lock & idle check (`RAN`) | Lock `HOLDER=CARBON JOB=v0.4-rerun` acquired (`18:55:38`); `pgrep -fl "lean-4.19.0\|tools/build.py"` printed nothing | Lock acquired; empty `pgrep` | OK |
| 2. Watchdog (`RAN`) | `memwatch.py 4096 900` started & verified (`PID 22448`) | Running watchdog | OK |
| 3. Pre-build sources & list SHAs (`RAN`) | Bad sources `0`; `SOURCE.sha256` `95fff03ee598002c80d0f43d04cf8a2524d3ec55e7f8e958d4f9143233ba13c1`; `PINS.sha256` `24e778e58098756d450afc57e581b27d698474cbf5bb1523e05ad8aaf3cb5c50` | `0` bad; exact list SHA-256 match | OK |
| 4. Build (`RAN`) | `sh v0.4/build.sh` -> `logs/R12B-carbon-rerun.txt` exited `0` in one uninterrupted run (`676.3s` across stages; wall-clock `11:16.55`, `631.22s` user, `111.70s` sys) | Exit `0` (~12 min) | PASS |
| 5a. Result & pin counts (`RAN`) | Tail: `PASS v0.4 (676.3 seconds across separately bounded stages)`; `: OK` count `98`; error/`FAILED`/`sorryAx` count `0` | `PASS v0.4 (`; `>= 95` `: OK`; `0` errors | OK |
| 5b. Wasm digests (`RAN`) | `v0.4/aukora-core.wasm` `138170cca2e079d3b8cc72fa89fc42f396c7b3cad00371c3928a7809ba52817d`; `v0.4/aukora-core-lite.wasm` `8e7cca361db0ef321450e5f5fc70c807957c9e1095314fd533bdd4806abaa311` | Exact match on both Wasm files | OK |
| 5c. Mistral `segments.json.gz` check (`RAN`) | `v0.4/vectors/segments.json.gz` SHA-256 `b647b4b8f1ca171a071e8e8014fe54e0707a936c7f791252adc7402117d4f084` matches `v0.4/PINS.sha256` verbatim and logged `v0.4/vectors/segments.json.gz: OK` during Step 4 | Digest present in `v0.4/PINS.sha256` & `OK` | OK |
| 5d. Gate & omissions (`RAN`) | `same` (`own=true, transition=true`), `strong` (`own=true, transition=true`), `strong-next` (`own=true, transition=true`), `wrong-own` (`own=false, transition=true`); `37` `drop-* transition=false` omissions refused | Exact flags; `37` refused | OK |
| 6. Post-build sources & watchdog (`RAN`) | Bad sources `0`; `KILLED` count in `logs/memwatch.txt` `0` | `0`; `0` | OK |
| 7. Lock release (`RAN`) | `rm -f LEAN-JOB-HOLDER.txt` verified (`LOCK_RELEASED`) | Lock removed | OK |
| 8. Optional test (`NOT RUN`) | Not attempted | Optional | NOT RUN |

- **Peak memory (`RAN`):** Highest stage `peak sampled` across 539 sampled stages in `logs/R12B-carbon-rerun.txt` was `3169.1 MiB` (below the `4096 MB` watchdog cap; 0 kills).
- **Surprises / notes (`RAN`):** None — unlike Mythos's second build (which hit a stale vector file before regenerating it), this independent run completed cleanly from start to finish against the regenerated `v0.4/vectors/segments.json.gz` and final `PINS.sha256` with 0 retries and 0 surprises.
