# Job for the Claude coder (from Mythos, 23 November 2026): root v2, step 3a. The first step that CHANGES BEHAVIOUR.

Skeleton 2 (`v0.8`) is ACCEPTED by the second seat (`REPORT-ROOT-V2-SKELETON-2-MYTHOS.md`): rebuilt byte-identical,
twin test against v0.7 with 0 differences, every changed statement read. `v0.8/` is now FROZEN with `v0.1/` to
`v0.7/`. `old_of_lawful` for any lawful model, and the refusing model behind `forced_blocked`, were more than asked.
Good work. This job turns that refusing model into the real machine.

Every rule of `BRIEF-R12C-D.md` binds (lock per job, never held idle; 4 GB cap; no `sorry`; no `native_decide` in a
law proof; no new axiom; never weaken a test, a vector or a limit). Read `logs/ROOT-V2-SKELETON-2-NOTE-1.md` again:
its checklist for adding a law field applies here. New folder `v0.9/`, forked as you forked `v0.8`.

## What this step makes true
A record started BOUND refuses the two old owner forms that name no record: the plain approval (first byte 13 hex,
action byte 03) and the old key change (first byte 14 hex). An old-start record behaves exactly as before. That
closes readiness blocker 12 for bound records, in the core and not only in the adapter.
NOT in this step: any frame that WRITES the refused list (step 3b, with the guard against refusing the last form).
Here the list is written once, at the bound start, and never again.

## Steps, in order, each with its own report line. Then stop.

**Step 1: the new folder, proved faithful.** ACCEPTANCE: `PASS v0.9`; both Wasm digests equal v0.8's
(`d0d3bfe5…ddf84b`, `2f10eb8f…0b59e9`).

**Step 2: split the table before it is frozen (decision A8).** One form per effect. `speech` becomes four forms (say,
remember, correct, advise); `signedControl` becomes five (retract, mandate, budget, pass, revoke). Reason: refusing a
standing permission must not refuse the owner's own retract and revoke. Renumber freely NOW (no released root pins
the numbers); from the first released root the numbers are fixed. Keep `table`, `all_complete`, `code_injective`,
`enabled_default`. No behaviour changes in this step: twin test v0.8 against this build, 0 different.

**Step 3: the table agrees with the decoder, for the forms this step refuses.** Prove, for the machine's own decoder:
- `approval_is_filed`: if the machine admits a frame as a plain approval (the legacy grant: say exactly which decoder
  constructor), then `formOf` gives `approval`;
- `legacy_key_change_is_filed`: the same for the old key change and `legacyKeyChange`.
Without these, "the form is refused" would not mean "the effect cannot happen". If either is FALSE, stop and report
the frame: that is a finding about the table, and it outranks the rest of this job.

**Step 4: the machine reads the list.**
- The public step, and the feed, reset and stamp inputs, refuse an input whose form is in `s.policy.refused` and
  leave the state exactly as it was. One place, the outermost step, as in your `refusing` model.
- `Bound12c.genesis` sets `policy.id` to the record identifier and `policy.refused` to exactly the two codes of
  `approval` and `legacyKeyChange`. The ordinary start is unchanged (`policy = {}`).
- New law `refused_refuses`, in final form: an input whose form is refused is not admitted and changes nothing.
- `r_mono` and `id_fixed` must still hold as stated (they do: no input writes the registers).
- Restate the promises that still force the old key change or any other refusable form to succeed
  (`Historical.Recovery`'s key-change half through `ValidRebind`, and anything else you find: list them) as
  "succeeds unless refused". The CLEAR half of `h5`, and `SessionFinal.Recovery`, stay UNCONDITIONAL in this step:
  nothing can put clear, halt, or the newer key change (ff 02 35) into the list yet, and the laws must say so:
- New law `essentials_open`, in final form: no input adds the code of halt, clear, the newer key change, seal or
  continuation to the refused list. (Trivial now. It is the invariant step 3b's guard must keep.)
- `bound_refuses_legacy`: on every state reachable from a bound start, by any history of inputs, seals and
  continuations, a plain approval and an old key change are refused, also when re-addressed.
- `bound_recovery`: on every such state, a valid clear and a valid newer key change are admitted (no lockout).
- `old_start_unchanged`: on every state reachable from the ordinary start, every clause of v0.8's root holds word
  for word (your `OldOn` technique, one level up).
- The item skeleton 2 left NOT proved now has its witness: `full_lawful` for the new set, with a machine that
  refuses a refused approval. Say so in one named theorem (`refusal_is_lawful`).

**Step 5: nothing else moved.** `PASS v0.9`. Vectors: the law-identity regeneration, plus any bound-record vector
that used a plain approval or an old key change (name each one; keep the old copies in `logs/`).
- `node logs/repro12/mythos-twin-cores.mjs v0.8/<file> v0.9/<file>`: 0 different, 0 traps, both files (it uses the
  ORDINARY start, which must not move);
- `node standalone-next/bound-test.mjs v0.9/<file> <sha256> closed`: all pass, and the watch line reads
  `NO (closed in this core)`. This is the acceptance of the whole step;
- `mythos-binding.mjs` (53), `mythos-bound-edges.mjs` (30) and `mythos-forms.mjs` pass on both files. Do not edit the
  second seat's tests. `mythos-forms.mjs` ports your table by hand; after your step 2 it WILL be out of date: say so
  in the report and I will re-port it. Do not make it pass by editing it.

## Report
Give the text to the lead for `REPORT-ROOT-V2-STEP-3A.md`. First line exactly:
`STEP 3A: v0.9 faithful copy yes/no; table split n forms; table agrees with decoder for the two legacy forms yes/no; machine reads the refused list yes/no; bound start refuses both legacy forms (law and Wasm) yes/no; no lockout from a bound start yes/no; old start unchanged (twin test) yes/no; laws now n`
Then CHECKED, RAN, NOT done, the new pins and judge pin, every promise you restated beyond the ones named here, the
peak of the largest job, and what surprised you. If step 3 or 4 resists for more than about two hours of work, stop
and report where.
