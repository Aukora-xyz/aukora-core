PROOF CHECKED INSIDE WASM: yes (route 1, lean4lean checked the Lean proof of R5’s `Aukora.Bound5.wrong_digest` against a pinned environment).

Wasm accepted the **7,641-byte proof exported from Lean**. Its theorem says that if the staged digest differs from the intent’s install target, R5 refuses the upgrade and retains its state. The cell accepted a second, 8,556-byte proof of the same proposition. It refused a term of the wrong type, the proposition itself, a reference to the target theorem, and truncated or extended proofs.

| Measurement | Lab observation |
| --- | --- |
| Check time, three fresh instances sharing one compiled module | 7.746, 1.016, 0.966 ms (median **1.016 ms**). Input preloaded. Environment initialization took 18.038–39.916 ms and was timed separately. |
| [Standalone checker](core/Kernel6.wasm), including its environment | 1,727,501 bytes · SHA-256 `4d7b16eff23693cb412a22561e247dbdb3187322204b493943454ebfade028b9` |
| [Core with the upgrade gate](core/Core6.wasm) | 1,970,635 bytes · SHA-256 `92baf60040e4800c4dfd0040bbc32eff869ea865d6285b8f054776e940aed1f5` |

**What the checker trusts.** The cell decodes the proof, infers its type and checks definitional equality with a private 909-byte goal. It trusts a 561,099-byte snapshot of 925 declarations, including 72 earlier theorem statements such as `Bound5.upgrade_facts`. The snapshot excludes the target theorem. Both Wasm modules have private memory and zero imports. The checker, its C++ primitives, the C extraction and initialization code, the toolchains and the Wasm engine remain trusted. [Exported proof](logs/r6/wrong_digest.proof.expr) · [Environment inventory](logs/r6/wrong_digest.env.tsv)

**Route 1.** The pinned lean4lean and Batteries revisions target Lean 4.19.0. I rebuilt 369 missing modules serially. Linking the checker against the R5 runtime left 15 missing symbols, including substitution and level equality. Adding 11 upstream C++ units and correcting a fatal-error adapter’s Wasm ABI produced the standalone cell. Native lean4lean refused the initial ARK proof at a definitional-equality check, although Lean 4.19 accepted it. Both accepted the R5 proof. Four GitHub downloads totaled **435,461 bytes**. [Download list with revisions and sizes](logs/R6-DOWNLOADS.txt) · [Checks and failed attempts](logs/R6-CHECKS.txt)

**Upgrade.** Tag 17 carries the proof. One manifest entry pairs the published `Core5.wasm` SHA-256 with this theorem. R6 computed the staged digest and proof verdict internally, consumed the signed grant, and set the ledger head to SHA-256 of the entire proof-bearing frame. The old true flag, a wrong-typed proof and the same proof relabelled for a different signed candidate were refused. Retrying the valid frame then succeeded. The native Lean kernel accepted the four R6 gate theorems with `propext`, `Classical.choice` and `Quot.sound`. The manifest supplies the association between these bytes and the R5 model. Whether the executable keeps L1–L10 remains open. R5 itself still reads a host proof flag on its next upgrade. [Transition and theorems](core/Upgrade6.lean) · [Offline reproduction](spike/r6/run.sh)

## What it would take

1. **Days.** Define one proposition for L1–L10 over the candidate's public execution traces, including staging, refusal and successful witnesses. Preserve L6's comparison at each run's own head and L10's dependence on recorded outcomes.
2. **Days to weeks.** Pin the law version, allowed axioms and kernel rules. Validate the declaration closure, including inductives, recursors and prior proofs, or audit a fixed trusted base. Unsupported reductions can reject valid proofs, as the ARK attempt illustrates.
3. **Research.** Prove that the exact Wasm bytes refine the model, through Wasm semantics or translation validation covering the compiler, C interface, runtime and initialization. Unspecified host behavior or unmodelled foreign code can prevent this proof.
4. **Days once those pieces exist.** Construct the expected proposition inside the current core from the staged bytes. Enforce resource limits and install those same bytes only after proof and owner authorization succeed. This lab observed a ledger digest change. Loader enforcement, resource exhaustion and recovery still need testing.
