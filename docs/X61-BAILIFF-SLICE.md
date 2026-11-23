# The next x6.1 slice after the core cell: the bailiff in SHADOW at the real head promotion. Mythos, 23 November 2026

Goal: every real head promotion on main gets a verdict from the real core, recorded in the same transaction, without
blocking anything. Then, in an isolated world only, the same code in ENFORCE refuses a promotion with no permit.
Keys are LAB keys: every screen and receipt says "rehearsal". Nothing here is anyone's consent.

## What exists and is tested (RAN, 19 of 19, v0.8 small core, lab keys)
`bailiff-rehearsal/core-bailiff.mjs` (5 KB, no dependency, no file access, no key, no signing, no network; runs in a
Worker, a browser or Node): `judgePromotion(core, { recordText, ack, ballId, parentBallId, epoch })`.
It replays a BOUND core record in the pinned core, checks it is the record this sink serves and that it extends what
was acknowledged, then asks the core to admit ONE act frame built from the promotion's own ids. Returns `ADMIT` with
the grown record and the new acknowledgment, or one word: `NO_CURRENT_EXACT_PERMIT`, `RECORD_NOT_BOUND`,
`RECORD_NOT_THIS_ONE`, `RECORD_SHORTER`, `RECORD_REWRITTEN`, `RECORD_DOES_NOT_REPLAY`, `UNAVAILABLE`.
`bailiff-rehearsal/promotion-fixture.json` (27 KB): one record made with throw-away keys, and five cases with their
expected words (one ADMIT, four refusals), for a gate test that holds no key.
Tested refusals: no approval; a stranger's approval; another manifest; another parent; another epoch; a cancelled
approval; the same approval twice; a record rolled back; an early line changed; a twin record of the same owner
holding a valid approval; an old-start record; a malformed id; a changed core file.

## What the permit binds (this answers "a patch hash alone is not that binding")
The intent is: the 32 bytes of `ball.ballId` (the canonical id of the manifest the transaction selects), the 32 bytes
of the parent it replaces, all 64 bits of the candidate's epoch, the audience `x6.1/head-promotion/v1`, the owner
generation, and the epoch's low 16 bits as the approval's number. NOT a patch hash. (The whole epoch went into the
payload after review: two epochs 65,536 apart no longer share an intent; tested.) If `ballId` is not the canonical id of the exact module bytes
selected, the binding is only as strong as that id: Auma states which it is (SOURCE on main: `manifestIdCanon(ball)
!== ball.ballId` is already refused at staging).

## Where it goes, and the three duties of the wiring (revised after an outside review of this page)
SOURCE: `deploy/cloudflare/src/head-do.mjs` at main a0741e0a, around line 1560: the publish transaction whose line
`await tx.put('head', ball.ballId)` is the effect. Not at staging, not in the UI. All existing gates stay.
The module is pure: it cannot block, pin or bind anything by itself. The wiring must do three things.
1. **PIN at the caller.** The module runs whatever core module it is handed. The pin (`2f10eb8f…0b59e9`) is a gate
   test on the statically imported file in the bundle; say so in the card.
2. **The parent is the LIVE head.** Pass as `parentBallId` the head the publish transaction itself reads, never
   the value the requester names. The core binds the approval to whatever parent it is told; only the sink knows
   the true one.
3. **Mode decides where the judgement runs.**
   - SHADOW: never inside the publish transaction and never growing the record. After the publish has committed,
     judge a COPY of the stored record against the promotion that just happened and write the verdict as its own
     small record (`core:shadow:last`, and optionally into a log). An ADMIT in shadow is reported and DISCARDED:
     the stored record and acknowledgment do not change, so no approval is spent by a mode that enforces nothing.
     A failure or a slow judgement cannot touch a publish.
   - ENFORCE (isolated world only): judge BEFORE opening the transaction, against the record and acknowledgment
     read just before; then INSIDE the transaction, in this order: re-read the stored acknowledgment and the live
     head and refuse (`CORE_STALE`, retry from the top) unless both are exactly what was judged; refuse
     `CORE_PERMIT_REQUIRED` unless the verdict was ADMIT; put the grown record and the new acknowledgment; then
     `tx.put('head', …)`. The heavy work stays outside the transaction; record, acknowledgment and head still change
     together or not at all. A refusal leaves effect and authority state byte-identical.
The verdict is also written into the outcome object: `coreBailiff = { mode, verdict, rehearsal: true }`.

## The switch
`CORE_BAILIFF`: `off` (default; code path not entered), `shadow` (compute and record, never block), `enforce`
(refuse without ADMIT). On the live face: `shadow` only. `enforce` only in an isolated world with its own storage,
until the owner's key path exists.

## Facts Auma needs, and limits
- In a Worker the core file must be a STATIC import (`import coreModule from './aukora-core-lite.wasm'`); runtime
  compilation of fetched bytes is not available there. So the digest check is a GATE TEST on the file in the
  bundle (pin `2f10eb8f…0b59e9`), not a runtime check. The asset already landed for the core cell is the same file.
- Cost, measured on this Mac: 3 ms to compile, 80 to 140 ms per judgement for a record of 4 lines with 3 signed
  frames. Each signed line adds roughly 30 ms here and more in a Worker. The record must stay short: this sink's
  record holds approvals and acts for promotions only, and is sealed and restarted long before the 512-line limit.
- Seed for shadow on main: the fixture record (lab keys). Every real promotion then gets `NO_CURRENT_EXACT_PERMIT`,
  which is the true statement today: no core permit exists for it. The ADMIT path is shown by the gate test.
- OPEN in this core (v0.8): an old-form approval names no record, so one such signature could be reused across
  records. The sink test for that is `bailiff-rehearsal/test-bound.mjs` and it prints "still open" until v0.10.
- The pilot governs ONE transaction in ONE Durable Object. It does not govern GitHub, the Cloudflare control plane,
  bootstrap or any other write, and no text may say it does.

## Acceptance, in order
1. Gate test (no keys): the five fixture cases give their expected words; a changed fixture line gives a RECORD word.
2. Shadow on main: after one real promotion, `core:shadow:last` carries the promotion's ids,
   `verdict = NO_CURRENT_EXACT_PERMIT`, `mode = shadow`, `rehearsal = true`; the head moved as before; the stored core
   record and acknowledgment are byte-identical before and after; with the judgement made to throw, the publish
   still succeeds and the shadow record says `UNAVAILABLE`.
3. Isolated world, enforce: a promotion with no approval is refused `CORE_PERMIT_REQUIRED` and the head, the staged
   record and the core record are byte-identical before and after; with the fixture's approved ids it is admitted
   ONCE and the second attempt is refused; a request that NAMES the approved parent while the live head is another
   is refused; two concurrent attempts on one approval admit exactly one (the other gets `CORE_STALE` or a refusal).
