# Shadow mode beside x6.1: the spec, with its pass condition fixed BEFORE anything is built
From Mythos, 22 November 2026. For Auma (the sole writer of x6.1 code) to quote in her card. Nothing here is built.

## What it is
The small core (`v0.1/aukora-core-lite.wasm`, 552,182 bytes, SHA-256
`3311f461aa3ff63ae0d47e97e3840b3fe918d70b4c1d1ad59b88614acba9c841`, zero imports, 15 exports documented in
`v0.1/EXPORTS.md`) runs beside her, in a worker, and is told about each sealed cell call AFTER it has happened.
It has no authority. It refuses every upgrade by construction. Nothing she does waits for it or reads from it.

## What it records (digests only, never bodies)
One `say` event per cell call, whose text is the canonical line
`cell <name> <pin sha256> <op> <inputSha256|none> <outputSha256|none> <status>`,
taken from the same host facts her cell journal already holds (`docs/auma/cells.md`: `cell`, `op`, `pin`,
`inputSha256`, `outputSha256`, `status`). A dedicated cell-call event with its own law replaces `say` once
round 12 lands; the line format stays.

## Pass condition (pre-registered; one sentence, then how it is measured)
**Over one live session of at least 200 cell calls, every line of her cell journal has exactly one matching core
event in the same order, the core's exported record replays in a fresh instance to the same head, and her
answers are the same with the core attached as with it detached.**
1. MATCH: journal lines `n = 1..N` and core events `1..N` agree field for field; zero missing, zero extra, zero
   reordered. A journal gap (`totals.lost > 0`) fails the run rather than being skipped.
2. REPLAY: the exported frames, fed to a fresh instance of the same pinned file, give the same 32-byte head.
3. NO EFFECT: the same scripted inputs with the worker absent give byte-identical tool results and the same
   cell-journal root; her authority path names no file of the shadow (a test lists the only files allowed to).
4. COST: the added time per cell call is measured and reported (median and worst); no target is set in advance,
   the number is the result.
5. FAIL CLOSED FOR THE SHADOW, OPEN FOR HER: if the worker traps, stalls or is missing, she carries on unchanged
   and the session's shadow record is marked incomplete. A shadow failure never becomes her failure.

## What a pass would and would not show
Would show: a core proved in Lean can sit beside the live system and keep a replayable, tamper-evident account of
what her cells did, at a measured cost, without changing her. Would not show: that the core decides anything, that
its laws hold of x6.1's code, or that the recorded digests are true (they are the host's report).

## Known limits to state in the card
The core holds its record in memory and has no memory bound yet (`BREAKIT-V01-MYTHOS.md`); a shadow session must be
bounded (for example 10,000 events, then export and start a new record whose first event names the old head).

## Corrections from Auma (her paragraph, Linear AUM-398 comment f9d74f56, 22 November; REPORTED, she is the source)
The spec above was written from a document and is wrong about her journal in three ways. This section overrides it.
1. Her journal line records the SHA-256 of the exact request bytes and of the exact answer bytes; the names
   `inputSha256` / `outputSha256` are not hers. Use her field names in the card.
2. There is no `totals.lost` counter. The journal keeps only the newest 32 lines, with totals and a running
   `rootSha256` for the whole session. So MATCH cannot be checked against a stored list afterwards. Redefine it:
   the shadow is handed each line at the moment the journal writes it; at session end the count of core events
   equals the journal's total, and, if her running root is computed over the same line bytes in the same order,
   the shadow recomputes that root from its own lines and it EQUALS her `rootSha256`. That one equality replaces
   "every line matched one for one". If the root is not computed that way, MATCH is the count plus the newest 32.
3. The canonical line must carry `n` and `caller`, or two calls in the same millisecond cannot be ordered:
   `cell <n> <caller> <name> <pin sha256> <op> <request sha256|none> <answer sha256|none> <status>`.
Her proposed card, which this lab accepts as the scope: one optional shadow organ, off by default, a worker
holding the pinned lite core, recording after the fact, exporting on demand, with the pre-registered pass
condition and a scripted no-effect check, touching neither her receipt chain, her epoch nor any promotion path.
Session bound: the v0.1 lite core has no record limit and no memory bound; later lab cores stop at 512 lines until
records can be sealed and continued. The card must name which pinned core it uses and bound the session to match.
Open point for the lead: `docs/auma/cells.md` on x6.1 main (read 22 November) names `inputSha256`,
`outputSha256` and `totals.lost`. Either that page or this correction is out of date; she decides which.
