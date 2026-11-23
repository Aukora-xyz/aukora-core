# REPORT R12C-A (pin implies satisfied, into v0.6), written by Lead 11 from the coder's final reply (23 November 2026)

Provenance: the coder's seat cannot write report files, so Lead 11 wrote this from its reply. Everything below is the CODER'S claim (REPORTED) unless it says LEAD RAN. LEAD RAN, and only this: `v0.6/aukora-core.wasm` is 7,386,904 bytes with SHA-256 cce58d54...a71ae; `v0.6/aukora-core-lite.wasm` is 674,376 bytes with SHA-256 3bdb8e63...f1f4 (both equal the coder's figures); `logs/R12C-D-CHECKS.txt` shows the genesis check PASS, the tests/genesis-check.mjs results and the gate-final reasons as the coder states them; `Proofs/PinSatisfied.lean` contains no `sorry`, `native_decide` or `axiom` text; `LEAN-JOB-HOLDER.txt` is released and no `lean` process runs. Lead did NOT re-run any proof or build. Mythos verifies with his own tools.

PIN IMPLIES SATISFIED: law yes (corollary, named field `pinned`); genesis build check yes, shown failing yes; own refusal code yes (existing code 7, distinct from 8 and 11); one machine, 42 laws

**CHECKED (coder; Lean kernel; axioms propext, Classical.choice, Quot.sound; no sorry, no native_decide, no new axiom)**
- `Pin.of_clauses`: for any model, the `succession` and `upgrade` clauses together imply `PinSatisfied`.
- `Pin.full_pinned`: `PinSatisfied` holds for the full machine.
- `RootFinal.full_lawful` with 42 fields, and `genuinely_stronger` and `omission_refused` with 42 drop packages.
- None of the 41 earlier statements changed.
- What `pinned` says: on every core change, the resulting state pins the package's own declared set, and the pinned checker accepted a proof that the carried machine satisfies the set it pins. Standing limit 2 still applies in the same words.

**RAN (coder)**
- `sh v0.6/build.sh` ends PASS v0.6 (768 s); all 110 pins match.
- The build check `tools/genesis-check.mjs` runs inside `build.py`. It compares two independently derived identities: the identity the core reports through `lawByte` after genesis, and `proved.id`, which `tools/ExportFinal.lean` derives from the type of `full_lawful` (its head's structure fields, the environment hash and the serialized head). Real build: passed, with embedded and proved both `0542e7a5...9699`.
- `tests/genesis-check.mjs` calls the same program three times: real core accepted; real core with ONE BYTE of the proved identity changed refused (Mythos's control); round-12 configuration refused.
- The round-12 fixture `fixtures/genesis-check/round12.json` holds v0.3's embedded identity and the identity of what v0.3 actually proved (`Supplement fullModel`). It is a JSON description, and the test asserts it is not a loadable Wasm module.
- `gate-final.mjs`: the unsatisfied-set package (root plus a law `False`, carrying the root's proof) gets reason 7 (entailment passed, satisfaction failed); entailment failure 8; judge mismatch 11; `same` and `strong` 0; all 42 omissions refused.
- `record-rebinding.mjs` still passes 32/32 on both cores.

**NOT done or not proved**
- Nothing proves that the checker's "accepted" implies the Lean proposition (standing limit 2).
- The genesis check is a build step, not a theorem.
- The vectors that depend on the law identity were regenerated with each test's own `--write`. Adding `pinned` changes the law identity, and through it the record identifier. The D2 copies are kept in `logs/r12c-d/d2-vectors/`.

**Peak memory:** 3,314 MiB in the root check job, under the 4 GB cap but tight.

**New pins:** `aukora-core.wasm` cce58d54673b5413c1401b241df8c79be091bac74cc71acd45cb7721b23a71ae; `aukora-core-lite.wasm` 3bdb8e631b3911ecfda9d28bf785b31611bb5c43bd821345a15644ce528df1f4; `drop-pinned.model` 04136d67...; `unsatisfied.model` 84e2c757...; `round12.json` a2a77484...; plus the regenerated vectors.

**What surprised the coder:** in round 12, `v0.3/tests/gate12.mjs:23` expected the `same` package to be refused with code 7. The test had written the defect down as correct behaviour.

Files: `logs/R12C-A-CARD.md`, `logs/R12C-D-CHECKS.txt`, `v0.6/Proofs/PinSatisfied.lean`, `v0.6/tools/genesis-check.mjs`, `v0.6/tests/genesis-check.mjs`, `v0.6/fixtures/genesis-check/round12.json`.
