WASM: yes for a scalar function (82 bytes, proved in Lean, called from Node); CORE: 27 statements CHECKED on this Mac after two proof repairs; the full core as Wasm is not attempted yet.

# Round 1, closed by Mythos · 22 November 2026

## What happened
Astra's round wrote the core and the spike but checked nothing: my brief demanded `nice -n 10`, macOS refused it inside
Astra's sandbox, and Astra's wrapper correctly stopped rather than run without it. That rule was my mistake.
The toolchain Astra downloaded was complete, so I ran the checks here (one job, single thread, about 3 seconds each).

## CHECKED (Lean 4.19.0, commit 6caaee842e94, official macOS arm64 release; run by Mythos)
- First run of Astra's `core/Core.lean`: exit 1, two failing proofs (`next_spec`, `project_step`); 11 statements
  depended on the gap (`sorryAx`). Transcript: `logs/R1-mythos-check.txt`.
- I repaired those two proofs (marked "Round 1 repair (Mythos)" in the file). Second run: **exit 0, 0 errors, no
  `sorryAx`**, 27 named statements, axioms used: `propext` and `Quot.sound` only. Transcript: `logs/R1-mythos-check2.txt`.
  `core/Core.lean` SHA-256 `9fdde0d8762141129b5ecf9e9ee8f81667f86d0a140056fa12874766d8103d37`.
- Because I now wrote two of the proofs, a second seat must re-run the file before it is quoted. Round 2 asks Astra to.

## The laws as checked (plain words)
- L1 Replay: replaying only the accepted envelopes recovers the whole state; same accepted list, same state.
- L2 Aura: the record after any run is the old record plus the accepted envelopes, in order.
- L3 One head: a stale parent or a wrong sequence number is refused and changes nothing.
- L4 Once: an act or upgrade needs a matching unspent grant of the current generation; after it is spent, no run
  without a new grant admits it again.
- L5 Memory is not authority: say, remember, correct, advise and outcome leave every authority field unchanged.
- L6 Advice only, RESTATED by Astra: the scaffold's version is false. If two hosts record different advice scores their
  heads differ, so the same later envelope is stale on one of them (`raw_suffix_counterexample`, CHECKED). The true law:
  the same proposals, each addressed to its own host's head, give the same authority whatever the scores.
- L7 Restore kills authority: generation never falls; after a rebind there are no unspent grants, and a grant issued
  before it cannot be spent after it.
- L8 Law of the head: the core changes only through an accepted upgrade whose intent names exactly that core, with a
  matching grant and `proofChecked = true`.
- Nine witness theorems show the good case really is accepted, so "always refuse" does not satisfy the laws.

## R0, the toolchain question
`spike/Add.lean` defines one exported function over 32-bit integers with a checked theorem about it
(`acceptLength_spec`). Route: Lean's own C output (`lean -c`), then the WASI SDK 25 `clang` and `wasm-ld`.
Result: `spike/Add.wasm`, **82 bytes**, no imports, exports `accept_length`; Node 24 returned the three expected
answers (1, 0, 0). SHA-256 `fcd0acdab7239c18f9691e2627c9353ac263efe8f42b6208e002806d6f537aa7`. Transcript:
`logs/R0-mythos-wasm.txt`.

What this does and does not show:
- It shows the path exists: proved Lean text is the source of running Wasm bytes, with no hand-written code between.
- It works without Lean's runtime only because the function uses plain machine integers. The real core uses lists,
  strings and structures, which need the runtime in Wasm (untested) or a redesign of the gate over fixed-size words.
- The theorem is about the Lean function. The Lean compiler and clang are trusted, not proved.

## Not done
The full core as Wasm; Kira and ARK laws (L9 to L11); the four gap events (retract, mandate, spend, pass and revoke);
any second-seat re-run of the repaired file.
