# What x6.1 decides today, and which core event would decide it (Mythos, 22 Nov 2026)

First principles only: this lists the DECISIONS the live system makes, so the Lean core can be checked against
what Auma actually needs. Sources are the x6.1 files I read during today's red team (main `00bd6206`), named so a
reader can look; the core takes nothing from that code.

| Decision the system makes | Where x6.1 makes it today | Core event and law |
| --- | --- | --- |
| Is this new line accepted, and where does the conversation end? | `deploy/cloudflare/src/thread-log.mjs` (append at the exact end, parent must match) | `say`; L2, L3 |
| Which browser may write? | `world-lease.mjs`, `world-holder.mjs` (one lease, one body, key proof) | the envelope's `parent` and `seq`: a second writer is simply stale; L3 |
| May the active view lose lines? | `thread-log.mjs` retract (kept beside) | NOT in the scaffold yet: needs a `retract` event that keeps the removed lines addressable |
| Did the owner approve this exact action, once? | `aumlok.mjs` (challenge bound to audience, method, path, body; single use; 5 minutes) | `grant`, `act`; L4 |
| Does a restore or a new device bring authority back? | `cold-archive.mjs` restore writes the whole owner row; `aumlok.mjs` generation | `rebind`; L7 (the scaffold is stricter than x6.1 is today) |
| May her code change? | `head-do.mjs` promotion (parent, epoch, passkey or scoped grant) | `upgrade`; L8 |
| May she act while he is away, within limits? | `owner-mandate.mjs`, `night-grant.mjs` (closed scopes, counts, expiry, revoke) | NOT in the scaffold yet: a `mandate` event with a count and an expiry, and a law that it can never cover `upgrade` or `rebind` |
| What did an outside service actually do? | receipts; "unknown, never retry blind" | `outcome`; L10 |
| What does she remember, and from where? | Kira cells; memory chain files | `remember`, `correct`; L9 |
| Does advice change a decision? | Kyber cells are advisory | `advise`; L6 |
| How much may be spent? | `provider-budget.mjs`, `runner-budget.mjs`, `world-budget.mjs` | NOT in the scaffold yet: a `spend` event against a cap set by a `grant`; law: total admitted spend never exceeds the cap |
| Which outside host may read her? | nothing yet (the Core door design) | NOT in the scaffold yet: a `pass` event (scope, expiry) and `revoke`; law: a revoked or expired pass admits nothing |
| Can the record be rebuilt from pieces? | `sealed-shards.mjs` (4 of 10) | separate file; L11 |
| When did this state exist? | `witness.mjs`, `ots.mjs` (outside stamps) | outside the core: a witness attests a head, it decides nothing |

## Four gaps this map exposes in the scaffold (for round 2)
1. `retract`: without it the core cannot express what the live log already does.
2. `mandate`: bounded standing permission, the thing that lets her work while he sleeps.
3. `spend`: money and budgets are decisions too.
4. `pass` and `revoke`: how Claude Code or Grok is admitted and cut off.

## What never enters the core
Voice, screens, model calls, storage engines, network, key storage, the passkey ceremony itself. They are hosts and
doors. The core only sees events and the facts hosts report about them.
