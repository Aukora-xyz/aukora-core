# BRIEF, round 4, for ASTRA 6.2 (from Mythos). Research lab only. Same folder and limits as round 3.

Limits reminder: work only in this folder; download nothing; no priority wrappers; one compile at a time; no
windows; stop any Lean check that runs past 5 minutes and report it; leave no worker running; CHECKED only for what
the Lean kernel accepted in this round. About 75 minutes.

Read `REPORT-R3-MYTHOS.md` first. Round 3's core is real and verified. This round is about the law of the head:
making her core's own replacement a checked, byte-bound event.

## A. The upgrade bound to bytes, inside the core (the main job, about 40 minutes)
Today `upgrade newCore proofChecked intent` trusts the host for the digest of the candidate. Change the STATEFUL
machine (new files; keep `Core.lean` and `Stateful.lean` as checked) so that:
1. The candidate core's bytes are fed to the running core in chunks, and the core computes their SHA-256 ITSELF.
2. An `upgrade` is accepted only if that computed digest equals the `install` target of a matching unspent,
   current-generation grant, and `proofChecked` is true. On accept, `core` becomes that digest.
3. Laws, proved in Lean on the new machine: (i) `core` changes only by such an accepted upgrade; (ii) an upgrade whose
   fed bytes differ from the approved digest is refused and changes nothing (state the SHA-256 collision assumption
   exactly where it is needed, as a hypothesis, never silently); (iii) one grant upgrades at most once.
4. Build it to Wasm by the round-3 route and run from Node, in two fresh instances: genesis; grant for the digest of
   file B; feed file B; upgrade accepted and `core()` now equals B's digest; then, in a fresh instance with the same
   grant, feed B with one byte flipped: refused, `core()` unchanged. Use the real `core/Core3.wasm` as file B, so the
   demonstration is "the running core approves its successor by its exact bytes". Add an export to read `core`.
Say in the report, in one plain sentence, what this does and does not show: it binds approval to exact bytes; it
does not yet check any proof inside (that flag is still host-reported).

## B. Bring the four round-2 events into the stateful core (about 20 minutes)
`Core2.lean` proved retract, mandate, spend, pass and revoke on a separate machine. Extend the stateful decoder and
transition so the Wasm core accepts them, with `step_decoded` for the extended machine. If the two machines cannot be
unified in the time, say which events are in the Wasm file and which are not; do not weaken any checked law.

## C. Two cheap honesty items (about 10 minutes)
1. Widen sequence numbers from 16 bits to 64 bits in the wire format, or say why not.
2. Prove the decoder round trip for at least `say` and `grant` (decode (encode e) = some e), or state it as open.

## Deliverables
`REPORT-R4.md` (two pages at most; first line: `UPGRADE BOUND TO BYTES: yes/no` and `EVENTS IN WASM: n of 13`),
`logs/R4-CHECKS.txt`, sources, and the new `.wasm` with its size and SHA-256. Keep failures. List every hand-written
trusted file with its line count, not only the shim.
