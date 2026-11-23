# REPORT ROOT V2 SPIKE, written by Lead 11 from the coder's final reply (23 November 2026, Mac time 10:18)

Provenance: the coder's seat cannot write report files, so Lead 11 wrote this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this: `spike-root-v2/Spike.lean` exists (270 lines) with the named theorems present and no `sorry`, `native_decide` or `axiom` text; the coder's progress log shows `lean spike-root-v2/Spike.lean -> exit 0 in 2 s, max RSS 258.7 MiB` at 10:11:25 and the step-0 runs below; `v0.6/aukora-core.wasm` still has digest prefix cce58d54 (unchanged); `LEAN-JOB-HOLDER.txt` is released and no `lean` process runs. Lead did NOT re-run any proof. Mythos verifies with his own tools.

ROOT V2 SPIKE: memory step 0 peak before/after 3149/944 MiB; spike theorems 7 of 7 kernel-checked; no-lockout survives its attack yes; design stands yes

**CHECKED (coder; `spike-root-v2/Spike.lean`, core Lean only, 270 lines, max RSS 259 MiB; no sorry, no native_decide, no axiom declared)**
1. `ref_unless_refused`: a legacy frame gets the reference verdict unless its form is in `refused`.
2. `old_follows`: from the ordinary start, through frames of the old grammar, the old statement holds with no exception.
3. `refused_mono` and `keychange_keeps`: no step removes a restriction, and a key change keeps `id`, `refused` and `enabled`.
4. `bound_refuses_legacy`: from a bound start, the legacy approval is refused at every reachable state, whatever its bytes.
5. `no_lockout`: from any usable state, a validly signed clear is admitted, and so is at least one open key-change form; `usable_run` shows every state reachable from either start is usable.
6. `cannot_refuse_last`: a frame that would refuse the clear, or the last usable key-change form, is itself refused.
7. The attack: `round14` (the owner refuses the old key change and the new one still works); `weak_locks_out` (no axioms): with a guard that protects only the clear, two signed refusals leave no key-change form (the counterexample); `strong_keeps_one`: the real guard refuses the second of those refusals.

**Step 0 (memory)**, measured standalone against the built imports: `weaker_class_can_fail` with plain `decide` peaks at 3,149 MiB (7.3 s); with `decide +kernel` 944 MiB (2.8 s); `#print axioms` reports only `propext` for both. The fix is MEASURED, not applied: `v0.6/Proofs/Evidence11.lean` is unchanged.

**NOT done or not proved:** no-lockout is proved for reachable states, not for arbitrary ones; the `SignatureOnce` hypothesis was never needed, so the spike does not test it; the spike is 270 lines, not the asked-for 150.

**Step 2 (prose, coder):** the card's section 6 schema is enough; `enabled` worked as the switch for forms the machine already has (A2); `old_follows` holds only for frames of the old grammar (the precise form of A1); A3 survived: `refused` holds forms only, never permissions. First three skeleton jobs (A4): (1) add the `policy` field with empty registers (acceptance: every vector, pin and test unchanged except the identity); (2) restate `PriorVerdicts`, `Supports`, `e5` and `StampSupports` as "unless refused" (acceptance: each old statement follows on old-grammar histories from the ordinary start); (3) replace `h5` with the usable-form version plus the guard (acceptance: the old `h5` follows when only the legacy forms are enabled).

**What surprised the coder:** a guard that protects only the clear really does allow self-lockout: two signed refusals are enough, so the "last usable form" guard is essential.

Files: `spike-root-v2/Spike.lean`, `spike-root-v2/step0/Evidence11Scratch.lean`, `logs/R12C-D-PROGRESS.md`.
