# Second seat on ROOT V2 STEP 3a-i (v0.9). Mythos, 23 November 2026, 15:49 Mac clock

`STEP 3A-I SECOND SEAT: rebuild byte-identical yes (958.6 s, peak 1,282 MiB); source diff as claimed yes; same behaviour as v0.8 on 3,913 paired inputs yes (both files); table files 14 real frames of 13 forms correctly; decoder agreement proved for the two legacy forms yes; laws 44; verdict ACCEPT, v0.9 frozen`

## RAN (by me, on this Mac)
- **Rebuild from source:** `PASS v0.9 (958.6 seconds …)`, exit 0, slot 15:32:40 to 15:48:44. Both Wasm files byte-identical
  to the delivered ones: `2c166cce41a922e5001a7c211285cd03908e0f5d86e27b1e1d1dfbfac505bd14` (full) and
  `61e02592287d31ef8ad2ba13b15a46deff7edfd0de0c8866fe245a641abd2419` (small). Pins 114 and source list 155: 0 mismatches
  before and after. `v0.8` pins and source list: 0 mismatches. Embedded law identity `f18a68c5…6c2b8f6f`.
- **Source diff v0.8 → v0.9, every file:** `Forms.lean` (31 forms become 38: `speech` is now say, remember, correct,
  advise; `signedControl` is now retract, mandate, budget, pass, revoke; renumbered 1 to 38), `Policy.lean` (the
  default `enabled` list written out to 38), new `Proofs/FormsDecoder.lean`, folder name in tools and tests, three
  regenerated vector files. `RootFinal.lean`, `Laws.lean`, `RatchetChecker.lean`: unchanged. No law text changed.
- **The two decoder theorems, as my build's kernel reports them:** `approval_is_filed` (propext, Classical.choice,
  Quot.sound) and `legacy_key_change_is_filed` (propext, Quot.sound). They say: a frame `Policy9.decode` reads as a
  legacy grant, or as an old key change, is filed by `formOf` under `approval`, or `legacyKeyChange`.
- **Same machine as v0.8:** twin test, 3,913 inputs, 0 different, 0 traps, full and small core.
- **In Wasm on both files:** binding 53/53, edges 30/30, next-line adapter 46/46. On the small file: the bound sink
  test 16/16 and the head-promotion judge 20/20. `mythos-forms-38.mjs` (my hand port of the NEW table): 14 real
  admitted frames of 13 forms filed correctly; 18,615 changed selector bytes, none still admitted.
- **Blocker 12 is still OPEN on v0.9, as it must be:** the adapter test and the sink test both print that one
  old-form approval signature is acted on in two bound records. Nothing reads the refused list yet.

## NOT checked, and what v0.9 leaves open
1. The decoder theorems are about `Policy9.decode`. That every route by which the full machine can take the EFFECT
   of a plain approval or an old key change goes through that reading is not yet a theorem. It is the second
   addition to the 3a-ii instructions.
2. Agreement of the table with the decoder for the other 36 forms: tested on 13 forms, proved for 2.
3. The numbers 1 to 38 are not final until a root that enforces them is released.
4. One Mac. Nothing wired into anything.

## Verdict
ACCEPT. `v0.9` is frozen with `v0.1` to `v0.8`. Next: step 3a-ii in `v0.10` (the machine reads the list), per the
last section of `logs/ROOT-V2-STEP-3A-RESUME.md`.
