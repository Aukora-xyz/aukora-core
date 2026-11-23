# AUKORA CORE, Lean-first: the scaffold (Mythos, 22 Nov 2026)

A side lab. It touches nothing in x6.1. It starts from what x6.1 is trying to do, not from its code.

## The paradigm in four lines
1. Auma is an append-only list of events plus ONE pure function `next : State -> Envelope -> Option State`.
2. That function is written in Lean 4. Her laws are theorems about it. No `sorry`, no custom axioms.
3. The same function is compiled to one small Wasm file. Every host runs that file.
4. Hosts decide nothing: they store bytes, deliver events, show screens, hold keys and report facts.

## State (all of it derivable by replaying the events)
`head` (digest of the last accepted envelope), `seq`, `generation`, `core` (digest of the running core),
`lines` (conversation), `claims` (memory, with source and what each corrects), `grants` (unspent approvals),
`admitted` (approvals that were used), `outcomes` (what a destination reported), `advice` (recorded scores).

## Envelope and events (a closed list)
Envelope = `{ parent : Digest, seq : Nat, event : Event }`. Refused unless `parent = head` and `seq` is next.
Digests are opaque values compared by equality; no law may assume a hash cannot collide.
Facts a host reports (for example "the owner's signature over this exact intent verified") arrive as
fields of the event and are named as ASSUMPTIONS in every theorem that uses them.

| Event | Organ | Meaning |
| --- | --- | --- |
| `say line` | Aura | append one conversation line |
| `remember claim source text` | Kira | a memory; `source` must be an earlier accepted event |
| `correct old new reason` | Kira | a correction; the old claim stays, the view changes |
| `grant intent ownerVerified` | Aumlok | the owner approved one exact intent (body, audience, generation, nonce) |
| `act intent` | Aumlok | spend the matching unspent grant; record it as admitted |
| `outcome intent result` | Aura | confirmed, failed or unknown, as the destination reported |
| `advise cell score` | Kyber | advice is recorded; it can never change a decision |
| `upgrade newCore proofChecked intent` | head | change the running core; needs a matching unspent grant AND a passed proof check |
| `rebind newOwner ownerVerified` | Aumlok | new owner binding or a restore: generation + 1, all unspent grants die |

## The laws (each is one plain sentence, then a Lean theorem)
- L1 Replay: the state is a function of the accepted events; two hosts with the same events hold the same head.
- L2 Aura: every accepted event extends the record; nothing accepted earlier is changed or reordered, for any run.
- L3 One head: an envelope naming a stale parent is refused and changes nothing.
- L4 Once: one grant admits at most one act; after it, no run without a new owner-verified grant admits it again.
- L5 Memory is not authority: `say`, `remember`, `correct`, `advise`, `outcome` never change grants, generation or core.
- L6 Advice only: two runs that differ only in advice scores agree on grants, admitted, generation and core.
- L7 Restore kills authority: after `rebind`, no grant issued before it can be used (acts carry the generation).
- L8 Law of the head: `core` changes only by an `upgrade` with a matching unspent grant and `proofChecked = true`.
- L9 Kira: claims only grow; a correction never removes what it corrects; a claim's source is an earlier event.
- L10 Honest outcome: the view shows "confirmed" only if a confirmed outcome event exists; otherwise unknown.
- L11 ARK (separate file): for the fixed 10x4 matrix over GF(256), every 4 distinct rows of 10 decode what was encoded.

## Build order
- R0 Toolchain: one Lean function compiled to Wasm and called from Node. Report the route, sizes, what broke.
- R1 `Core.lean`: the types, `next`, `replay`, and L1 to L8 proved. `#print axioms` on every theorem.
- R2 `Kira.lean` (L9, L10) and `Ark.lean` (L11).
- R3 The core as Wasm plus a host shim of at most 150 lines: feed events, print the head. Same head in two runtimes.
- R4 The refusal: a candidate core that asks for a new power is refused by the old core before any owner approval.
- R5 Self-hosting: the proof check for `upgrade` done by a small independent Lean checker compiled to Wasm.

## What stays outside every proof (say it on every page)
Cipher strength; where keys live; hosts and screens; the compiler from Lean to Wasm; whether these are the right laws.

## Honesty rules for every round
CHECKED means a Lean kernel accepted it in that round's transcript. UNCHECKED means it did not.
Keep failures. A law that turns out false is a result: show the counterexample and restate the law.
