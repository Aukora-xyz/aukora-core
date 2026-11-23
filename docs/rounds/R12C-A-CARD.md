# R12C-A design card: the gate cannot pin what is not satisfied (Claude coder, 2026-11-23, WITA)
All claims SOURCE (read in `v0.6/` as verified at D2); no Lean run for this card. **Verdict: GO.** G1 needs no change to
any of the 41. It is a corollary of `succession` (with `upgrade` for "core change"), so the job is steps 2b, 3 and 4.

## 1. What the gate checks before a core change, in order (`Ratchet11.lean` `reason`/`packageReason`, lines 41-62; `Interface.c` `step`)
0. Full adapter, before the model: staged file equals the outgoing executable outside custom sections (`staged_judge_matches`, `Interface.c` step) -> **11**.
1. Tag 27 but the package does not decode (`reason`) -> **9**. Owner intent's audience does not commit to these model/proof bytes (`Upgrade9.ownerBound`) -> **10**.
2. Checker foundation missing, or differs from the recorded one (`basisAndSet`) -> **1**.
3. Certificate witnesses missing -> **2**. Wrong foundation in certificate -> **3**. Wrong parent law identity -> **4**.
4. Candidate law declaration or manifest does not parse (`RatchetChecker.spec`) -> **5**. Goals cannot be built in the extended environment (`RatchetChecker.goals`) -> **6**.
5. Transition witness (universal entailment new set => old set, and grammar preservation) fails -> **8** (checked first, comment at line 54).
6. **Satisfaction**: the carried machine's proof of its OWN declared set fails -> **7**.
7. A predecessor law label is missing (`retainsNames`) -> **13**. Then `step` still requires the exact unspent install grant, quotas and the staged digest (`Core9.step`, `Gate.lean`).
Lite refuses all installs -> **12**. Codes from `EXPORTS.md` "Install reason" table.

## 2. Is "the carried machine satisfies the set it will pin" checked on every admitted change, and is it a theorem?
Yes, on the code path. Yes, as a theorem about the step function, at the level of the pinned checker's verdict.
- `RatchetChecker.goals` (`RatchetChecker.lean:130`) builds `own := .app newSet (.const name [])`, where
  `newSet := expression (spec model)` and `name := Checker9.machineName model` (the machine carried in the package).
- `Ratchet11.Demands` (`RatchetModel.lean`, before `Succession`) includes `spec u.model = some next`,
  `current t = some (b, next)`. So the pin after admission IS `next`, the same bytes the own goal is built from.
  It also includes `goals … = some g` and `verifies g.env g.own g.cert.own = true`.
- `Ports.Succession` (`Proofs/InstalledPorts.lean:120`), which is root field `succession`: every admitted
  installation satisfies `Demands`. `Ports.UpgradeInstalled` (field `upgrade`): every change of the installed core
  is an installation. `Ratchet11.goal_shapes` (`RatchetModel.lean:31`) fixes `g.own = .app next (.const name [])`.
- So, today, there is a THEOREM that every core change pins `next` and carries a checker-verified proof of `next`
  for the named machine. It is spread across three statements and not named. A future law set that drops
  `succession` would lose it; omission is refused only because `succession` is a named field.
- Not proved (standing limit 2): that the checker's `verifies` implies the Lean proposition, and that the named
  machine is the compiled one. The judge comparison (code 11) covers the second by bytes.

## 3. Genesis: what stops a release that pins a set its machine does not satisfy?
- At genesis the pin is `rootSpec` (`RatchetChecker.lean:36`), the bytes of the NAME `Aukora.RootFinal.Lawful`. The identity is SHA-256 of
  `rootManifest` (field names), the embedded environment hash, and those bytes (`Ratchet11.lawDigest`).
- The build checks the following (`tools/ExportFinal.lean` run_cmd):
  - the structure fields equal `rootNames`;
  - the serialized root equals `rootSpec`;
  - `expanded RootFinal.full_lawful` exists (a Lean elaboration error otherwise).
- The tests check that the `same` package (own = `full_lawful`) is admitted with code 0 (`tests/gate-final.mjs`,
  `tests/GateFinalChecks.lean`).
- Nothing compares "the identity embedded in the compiled core" with "the identity of the statement proved".
  Satisfaction at genesis is only a TEST EXPECTATION.
- Round 12 reconstruction (`v0.3`):
  - `rootSpec` named `Root12.Contract`, with no theorem `Contract fullModel`.
  - The `same` package carried `full_supplement` as its own proof (`v0.3/tools/Export12.lean:206`).
  - `v0.3/tests/gate12.mjs:23` EXPECTED `same` -> 7 and `strong` -> 7. The refusal was written into the test as
    correct behaviour, and the build passed.

## 4. Proposal for G1 (field `pinned`)
For every step that changes the installed core, or admits an installation:
- the decoded package's declared set `next` is the pin of the resulting state (`current t = some (b, next)`);
- the pinned checker's goal for satisfaction is exactly `next` applied to the machine the package carries;
- the pinned checker accepts the package's proof of that goal (`verifies … = true`).

It is stated over `m.step`, `Upgrade9.decode`, `RatchetChecker.spec/goals/verifies` and `Ratchet11.current`, and
leans on `succession` and `upgrade`. It is proved for the full machine as a corollary of those two clauses plus
`goal_shapes`, and added as its own field so that dropping it is refused (omission package `drop-pinned`). Root: 42.

**Step 3 plan.** A build step computes two identities and compares them byte for byte; any difference fails the
build.
- (i) Embedded: from `aukora-core.wasm`, `lawByte` 0..31 after `init`.
- (ii) Proved: in Lean, from the TYPE of `RootFinal.full_lawful`. It must be literally
  `RootFinal.Lawful Safe11.fullModel`. Its head is serialized, its structure's field names give the manifest, and
  the environment snapshot hash is taken as written.

The fixture is the round-12 configuration (v0.3's root name and 23+13 manifest, proved statement `Supplement fullModel`)
as a JSON description under `v0.6/fixtures/genesis-check/`, not a Wasm file. It can never be loaded as a core, and
the check rejects it.

**Step 4.** Code 7 already exists and is distinct from 8 (entailment) and 11 (judge). I add only a test:
- an unsatisfied-set package (root plus a law `False`, carrying the root's proof) -> 7;
- an entailment failure -> 8, and a judge mismatch -> 11;
- `same` and `strong` -> 0;
- all 42 omissions refused.
