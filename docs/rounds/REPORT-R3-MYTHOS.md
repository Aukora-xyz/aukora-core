SELF-CONTAINED CORE WASM: yes, 209,455 bytes, state and SHA-256 inside, rebuilt byte-identical, same head in two engines; SHARDS: all 210 four-of-ten combinations CHECKED for the real matrix; owner signature and upgrade proof are still host-reported.

# Round 3, verified by Mythos · 22 November 2026

## Second-seat checks (run by Mythos, Lean 4.19.0, single thread; transcripts `logs/R3-mythos-check.txt`, `logs/R3-mythos-rebuild.txt`)
| What | Result |
| --- | --- |
| `core/Core.lean` | exit 0, 28 statements, unchanged hash |
| `core/Stateful.lean` (imports Core and Sha256) | exit 0, 2 statements: `step_decoded` (a well-formed frame steps exactly as `Aukora.next` with the SHA-256 digest) and `step_malformed` (a malformed frame is refused) |
| `core/Sha256.lean` | compiles; **no theorem about it**: SHA-256 is implemented, not proved |
| `core/Ark3.lean`, `Ark3One.lean`, `Ark3All.lean` | exit 0, 8 statements, 31.5 s. `everyFour`: every 4 of the 10 rows has a two-sided inverse. `matchesSourceRows` pins the ten rows; I ran the live module `reference/sealed-shards.mjs` and its `codeRow(i, 4)` gives exactly those rows |
| `core/Core3.wasm` | I re-ran `spike/r3/build.sh`: **same SHA-256** `b36b84988012b4169ebff84d04dbafa4d8001990be8e625d36d78831051cce8a`. The Lean, C and link steps re-ran; the runtime archive was reused from Astra's build, so this is not a from-zero rebuild of the runtime |
| My own test, written from the wire format only (`logs/repro3/mythos-own-test.mjs`) | no imports; exports are four functions and nothing else (no memory); a good `say` is accepted and the head equals Node's SHA-256 of the frame; the same bytes again, a wrong sequence and 3 garbage bytes are refused with the head unchanged; two fresh instances end on the same head |
| A second engine (`logs/repro3/jsc-test.js`, JavaScriptCore, Safari's engine, no window) | same verdicts and the same final head `51c1dd568b462f88` as Node (V8) |

## What is true now
A single Wasm file holds her state and computes her head. A host can only call `init`, feed bytes, call `step` and
read the head. The transition inside is the Lean function proved equal to `Aukora.next`, whose laws L1 to L8 are
checked. The grant set lives inside the file: a host can no longer claim a grant exists.

## What is NOT true yet (my review)
1. **Trusted and unproved glue is larger than "an eight-line shim".** Hand-written and trusted: `interface.c` (56
   lines: holds the state pointer and the frame buffer), `reachable.py` (121 lines: picks the generated functions and
   rewrites start-up), `private-exports.py` (53 lines: edits the finished Wasm to hide memory), `shim.c` (8 lines),
   a stack-overflow stub, plus a subset of Lean's own runtime and the two compilers. About 240 lines of our own glue.
2. **SHA-256 is unproved.** It matched Node's SHA-256 on every tested frame; that is testing, not proof.
3. **Two facts still come from the host:** "the owner's signature verified" and "the upgrade's proof was checked"
   are fields of the event. Until signature checking is inside, the file trusts the host on who approved.
4. **Limits of this build:** sequence numbers are 16-bit (a chain ends at 65,535 events), frames are capped at
   65,535 bytes, and only the nine round-1 events are in the stateful core (retract, mandate, spend, pass are not).
5. **Persistence is the host's job.** The file starts at genesis; to resume, a host replays the stored events.
6. The decoder's round trip (encode then decode gives back the envelope) is not proved.

## Totals after round 3
63 statements accepted by the Lean kernel and re-run by a second seat (Core 28, Gate 6, Core2 19, Stateful 2,
Ark 8). Three Wasm files from proved Lean text: 82 bytes, 664 bytes, 209,455 bytes.
