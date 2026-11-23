# Rung 2 packet: Auma's OWN core record (rehearsal, witness-only). Mythos, 23 November 2026

What this rung makes true: every real promotion of her head adds ONE line to a bound core record that is hers, and
her panel replays that record in the pinned core. It is the first record that is hers and not a sample.
What it does not make true: nothing is approved, refused or governed by it. It WITNESSES. The record's owner keys
are public keys whose private halves were never stored, so no approval, control, stop, key change or seal can ever
be signed in it. Every label says "rehearsal, witness-only".

## Files (both small text; RAN 20 of 20 on the v0.8 small core)
- `bailiff-rehearsal/core-own-record.mjs`: the pure module. No dependency, no file access, no key, no signing, no network; Worker-safe.
- `bailiff-rehearsal/own-record-fixture.json`: the rehearsal PUBLIC keys (3,968 hex characters), and a test record
  of three promotions with the expected identifier and the expected head after each line.
Their sizes and SHA-256 are in the message that carries this page.

## Constants
- core file: the same pinned small core as the cell (`2f10eb8f…0b59e9`), statically imported in a Worker. THE CALLER pins it.
- `publicKeysHex`: from the fixture, top level. The same for every installation.
- host value: 32 random bytes drawn ONCE per installation and stored with the record. It makes her record's
  identifier hers. (The fixture's test uses `11…11` only so the expected values are fixed.)
- a line is the text `aukora.promotion/1 ball=<64 hex> parent=<64 hex> epoch=<n>` in an unsigned speech frame.

## The three functions
- `startRecord(core, { publicKeysHex, hostValueHex })` → `{ verdict: 'STARTED', recordText, ack }`. Once.
- `appendPromotion(core, { recordText, ack, ballId, parentBallId, epoch })` → `{ verdict: 'APPENDED', recordText, ack, line }`.
- `readRecord(core, { recordText, ack })` → `{ verdict: 'REPLAYED', id, lines, head, promotions, continuous }`.
`ack` is `{ id, lines, head }`: the identifier, the line count and the head as last stored. Store `recordText` and
`ack` together. Failure words: `RECORD_NOT_BOUND`, `RECORD_NOT_THIS_ONE`, `RECORD_SHORTER`, `RECORD_REWRITTEN`,
`RECORD_DOES_NOT_REPLAY`, `RECORD_FULL`, `UNAVAILABLE`. Anything unexpected is `UNAVAILABLE`.

## Wiring (same rules as the shadow slice, after the outside review)
1. NEVER inside the publish transaction and never able to fail a publish. After the publish has committed, in its
   own small step: read the stored record and ack, call `appendPromotion` with the ids of the promotion that just
   happened (ball = the new head, parent = the head it replaced, as the transaction read them), and store the
   returned record and ack together only if the stored ack is still the one that was read.
2. If the append fails or is skipped, do NOT hide it and do not retry blindly. The next line will name a parent
   that is not the previous line's ball, and `readRecord` then reports `continuous: false`. That is the honest
   signal that a promotion was not witnessed.
3. Behind a switch, default off: `CORE_OWN_RECORD = off | on`.

## The panel (second card of the same screen as the cell)
"Her own record (rehearsal, witness-only)": the identifier, the number of lines, the head, the last five
promotions, and `continuous: yes / no`. The good state needs ALL of: `REPLAYED`; the identifier equals the stored
one; the head equals the stored ack's head; `continuous` is true. Any failure word is shown as itself, never green.
It may say: "N of her promotions are recorded here; the record replays in the pinned core; nothing was changed in
what was acknowledged." It may NOT say she is governed, approved or protected by it.

## Bounds and limits (each RAN unless marked)
- 512 lines, then `RECORD_FULL`. A full record is 223,491 bytes of text and reads in 58 ms on this Mac. One append
  replays the whole record first: filling all 512 one by one took 21 s in total here; a Worker will be slower.
- When it is full, a NEW record is started with a new host value, and its first line should name the old record's
  identifier and head (words to be fixed in that card; not in this module).
- A change in the LAST line is caught only because the ack keeps the head: with no kept head it replays. A change in
  an earlier line never replays.
- The same keys and the same host value give the same identifier. The host value must be drawn once and kept.
- The lines are what the SINK says happened. The core does not know whether a promotion really took place.

## Acceptance
1. Gate test (no keys): the fixture's test record gives its identifier, and the expected head after each of the
   three lines; one changed character gives a RECORD word; an old-start record gives `RECORD_NOT_BOUND`.
2. On main with the switch on: after one real promotion the stored ack's line count has grown by exactly one; the
   new line's ball is the new head and its parent is the head before; the panel shows it; `continuous` is yes.
3. With the append made to throw: the publish still succeeds, and after the NEXT promotion the panel says
   `continuous: no`.
4. Rung 4 preview: the exported record text replays outside her, in the independent owner tool, to the same head
   and identifier (RAN in my test).
