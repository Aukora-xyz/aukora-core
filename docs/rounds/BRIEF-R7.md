# BRIEF, round 7, for ASTRA 6.2 (from Mythos). Research lab only. Same folder and limits as round 6.

Limits: work only in this folder; downloads only from GitHub, at most 20 MB, each listed with URL, commit and bytes;
no priority wrappers; one compile at a time; no windows; stop any check or test that runs past 6 minutes and report
it; leave no worker running; CHECKED only for what a Lean kernel accepted in this round. Delete large regenerable
build output before you finish (the owner's disk is low) and report the final folder size. About 90 minutes.

Read `REPORT-R6-MYTHOS.md` first. Round 6 proved the mechanism with ONE law. This round makes the carried proof
mean "this core's model keeps her laws".

## A. Her laws as ONE statement (the main job, about 55 minutes)
1. In a new file `core/Laws7.lean`, define a single proposition `Lawful` about a machine given only by its public
   interface: a state type, a genesis, a step function on wire bytes, and observation functions (head, core,
   owner key, unspent grants, admitted intents, active lines, claims, outcomes view). `Lawful M` is the conjunction
   of L1 to L10 stated over traces of that interface (keep L6 in its corrected form: same proposals, each addressed
   to its own head; state the SHA-256 and signature assumptions as explicit parameters or hypotheses, never hidden).
   Each conjunct gets a one-line plain-words comment a non-engineer can read.
2. Prove `Lawful R6Machine` (the round-6 machine, or the newest machine if you extend it), reusing the checked
   theorems of rounds 1 to 6. If a law cannot be proved in that form, restate it, say why, and show the
   counterexample or the missing lemma. A smaller true `Lawful` beats a bigger false one.
3. Export that ONE proof and check it in the round-6 checker cell (lean4lean in Wasm). Report its size and the time.
   If lean4lean refuses it (as it refused the shard proof), find out which reduction or feature is the cause and
   report it precisely; then try the smallest change that makes the proof checkable (for example avoiding `decide`
   on large terms). Do not weaken `Lawful` to make it pass.
4. Change the upgrade gate so the certificate it requires is a proof of `Lawful` for the model named by the
   manifest entry of the candidate, not of `wrong_digest`. Build the new core and run: accepted with the right
   proof; refused with the round-6 `wrong_digest` proof (a true theorem, but the wrong one); refused with a proof of
   `Lawful` for a different manifest entry.
5. Say in one plain sentence what is now proved and what still is not (the manifest, not a proof, links the model
   to the bytes).

## B. Groundwork for post-quantum signatures (about 25 minutes, only after A)
The owner wants signatures that survive quantum computers: a grant must verify under BOTH Ed25519 AND ML-DSA-65
(FIPS 204), so breaking one is not enough.
1. Write the HYBRID RULE into the machine now, abstractly: the owner key is a pair; `verifyHybrid` is the conjunction
   of two verifier functions; re-prove the round-5 signature laws for the pair (no grant without BOTH signatures;
   rebind signed by BOTH old keys). This is pure Lean and should be quick.
2. Implement SHAKE-256 (Keccak-f[1600]) in Lean and test it against known vectors (the empty string and "abc"; say
   which you could reproduce). ML-DSA needs it. Report its speed in Wasm.
3. Do NOT attempt full ML-DSA-65 verification this round unless A and B.1 and B.2 are done with time left; instead
   write, in the report, the exact plan and size estimate for it (NTT, hint unpacking, sizes of key and signature,
   expected check time in Wasm).

## Deliverables
`REPORT-R7.md` (two pages at most; first line: `LAWS AS ONE PROOF: checked inside Wasm yes/no (size, ms)` and
`HYBRID RULE: proved yes/no`), `logs/R7-CHECKS.txt`, sources, any new `.wasm` with size and SHA-256, a one-command
reproduction script like `spike/r6/run.sh`, and the list of every hand-written trusted file with its line count.
Keep failures. Do not edit any earlier checked file.
