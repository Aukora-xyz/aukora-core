# Second seat on ROOT V2 SKELETON 1 (v0.7). Mythos, 23 November 2026

`SKELETON 1 SECOND SEAT: rebuild byte-identical yes (807.9 s, peak 1,389 MiB); source diff as claimed yes; same behaviour as v0.6 on 3,913 paired inputs yes (both files); record-binding checks 53/53 and 30/30 (both files); verdict ACCEPT, v0.7 frozen`

## RAN (by me, on this Mac)
- **Rebuild from source:** `sh v0.7/build.sh`, `PASS v0.7 (807.9 seconds across separately bounded stages)`, exit 0, largest resident size of the whole build 1,389 MiB (v0.6 was 3,335 MiB), slot held 11:28 to 11:44, log `logs/ROOT-V2-SK1-mythos-rebuild.txt`. Digests after my build: `aukora-core.wasm`
  `69e711f1450448564054950a60dbffac399645e955a8c2562c7e0c1e0c982178`, `aukora-core-lite.wasm` `1991baed9d058e95b799ea6bc00cc40e2c77ee29d2c54eeeeca36cb87f27c119`. Both equal the coder's figures, byte for byte. Pins and source list re-checked after my build: 0 mismatches.
- **Pins as delivered:** `v0.7/PINS.sha256` 110 entries, `v0.7/SOURCE.sha256`, and `v0.6/PINS.sha256`: 0 mismatches each.
- **Source diff v0.6 → v0.7, every file:** `Policy.lean` (+17 lines for `structure Policy`, +1 field
  `policy : Policy := {}`, 1 changed line in `submit` that carries `s.policy`); `Proofs/Evidence11.lean` (the proof of
  `weaker_class_can_fail` is `decide +kernel`, two `set_option` lines gone); one `{}` added to the blank state in
  `Proofs/FinalStrict.lean`, `Proofs/Round11Safe.lean` and `tools/ExportFinal.lean`; folder name in four tools and
  four tests. `RootFinal.lean` and every law definition are byte-identical. No `sorry`, no `native_decide`, no axiom.
- **Exports and imports:** the same 26 exports and 0 imports in both files as v0.6. Sizes 7,386,904 → 7,390,811
  and 674,376 → 676,440 bytes.
- **Same machine? (new test, `logs/repro12/mythos-twin-cores.mjs`):** two cores, same keys, same ordinary start,
  the SAME bytes into both; after every input the verdict, head, installed-core digest, halt flag and ceiling are
  compared. Eight kinds of real signed frame (two timed approvals, cancel, threshold, signed control, halt, clear,
  key change), each also with 160 single-bit flips, six truncations, one extra byte and a replay, then garbage with
  every leading byte and every `ff VV tag`. v0.6 against v0.7: **3,913 identical, 0 different, 0 traps**, full and
  small core; v0.7 full against v0.7 small: the same. CONTROL: with one frame damaged for one core only, the test
  reports 2 differences; against v0.1 the run stops at the first frame the old core does not admit. (v0.2, v0.3 and v0.4 also agree with v0.7
  on these inputs, which is what backward compatibility of these eight kinds predicts.)
- **Record binding:** `mythos-binding.mjs` 53/53 and `mythos-bound-edges.mjs` 30/30 with 0 traps on both v0.7 files,
  driven by the v0.6 test library unchanged (so the wire format did not move).
- **The three regenerated vector files** (`segments`, `record-binding`, `record-rebinding`) against the kept
  previous copies: same structure and lengths, the same expected verdicts; only heads, keys, host values and
  signature bytes differ (15, 75 and 91 changed fields). They are regenerated with fresh keys, so the diff cannot
  show "only the identity moved"; the unchanged verdict fields and the twin test carry that claim.

## NOT checked, and what skeleton 1 leaves open
1. **Nothing proves the new field is carried.** I read every place that rebuilds a state (all use `{s with …}`),
   but that is inspection. One future constructor without `with` would silently empty the owner's restrictions and
   no test could see it, because no export reads the field. First law of the next step (`policy_carried`).
2. **The schema change is already a new root.** The law identity moved (`0542e7a5…` → `cda3b670…`) although no
   statement changed, because the state type is part of the pinned environment. UNVERIFIED by a run, SOURCE
   `ReleaseInterface.lean` ("all candidates share the public state schema"): a v0.6 record cannot be upgraded in
   place into v0.7. The coder is asked to confirm by run. Old records are replayed or started from a seal.
3. **"Empty means everything".** The comments define `enabled := []` and `limits := []` as "today's forms / limits".
   Harmless while nothing reads them; a trap the day something does. Decision A7 in the next job: registers are
   written out in full.
4. The field is not covered by any head, seal or export. Right for now (nothing writes it); before a record can
   start from a seal, the seal must commit to it (blocker 13 design).
5. The memory figure (3,313 → 975 MiB for the one file; largest job now `KernelCell.lean`) is the coder's
   per-file measurement, REPORTED. My whole-build peak is in the first line above.
6. Not run on another machine. Blocker 2 stands.

## Verdict
ACCEPT. v0.7 is frozen with v0.1 to v0.6. Next job: `logs/ROOT-V2-SKELETON-2-JOB.md` (new folder `v0.8`).
