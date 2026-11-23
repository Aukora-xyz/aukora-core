# The next line and the lab: what else is in this tree, and how far each piece is checked

The release in this tree is v0.8. Everything on this page is NEWER and LESS CHECKED than v0.8. It is here because
we would rather show the work than a polished subset. Where a folder's own pages disagree with this page, this
page is the later one. `v0.9/PROVED.md`, `v0.9/NOT-PROVED.md` and the same two pages in `v0.10/` are carried lab
pages: their headings still name earlier versions, and they do not yet describe what v0.9 and v0.10 added.

## v0.10: the core that refuses the two old command forms
v0.8's first open defect is that two old command forms (first byte 13 hex, the plain approval; 14 hex, the old key
change) name no record, so one signature is good in more than one record. In `v0.10/` a record that starts BOUND
starts with those two forms on its refused list, and one place in the machine (`Public.lean`) reads that list.

- The law set is 46 laws: the 44, restated where needed, plus `refused_refuses` (a refused form is refused, state
  unchanged) and `essentials_open` (halt, clear, the newer key change, seal and continuation can never be put on
  the list, so the owner cannot be locked out by it).
- RAN on the compiled small core `v0.10/aukora-core-lite.wasm` (SHA-256
  `c924c72aec0214b59f1f9405ac2c7467b86e2d96985540570ad1896db3c25d93`) and on the full core: in a bound record both
  old forms are refused, signed for that very record or re-addressed from a twin (56 checks,
  `v0.10/tests/independent/readdress.mjs <core> closed`); the timed approval still works; a record started the old
  way behaves exactly as under v0.9 (3,913 steps compared, `twin-cores.mjs`).
- v0.10 was rebuilt from scratch a second time, by a second builder, from an isolated staged folder on the same Apple-silicon
  Mac; both files came out byte-identical to the pinned digests (23 Nov 2026, the second builder's report). NOT DONE: a rebuild on
  other hardware or by someone outside the project.
- NOT PROVED: the refusal is proved for the forms as the decoder classifies them. It is not proved that no other
  route produces the same effect. No frame can yet CHANGE the list; a record's list is fixed at its start.
- An old-start record is exactly as exposed as in v0.8.

## v0.9: the table of forms agrees with the decoder
`v0.9/` (SHA-256 of the small core `61e02592287d31ef8ad2ba13b15a46deff7edfd0de0c8866fe245a641abd2419`) grows the
table to 38 forms and proves in `Proofs/FormsDecoder.lean` that the table and the decoder agree. Two independent
from-scratch builds on one Mac gave the same bytes. The machine still admits every form everywhere.

## `standalone-next/`: the adapter for bound records
The released adapter plus the bound start, the newer owner commands, and a refusal to SIGN the two old forms in a
bound record. `node standalone-next/bound-test.mjs v0.10/aukora-core-lite.wasm <its SHA-256> closed`.

## `bailiff-rehearsal/`: an effect that is refused when the core says no
A rehearsal of one effect sink that applies nothing without a current, exact approval admitted by the core; a pure
judge for one kind of promotion (`core-bailiff.mjs`); and a record the core keeps of its own verdicts
(`core-own-record.mjs`). LAB KEYS, made as the tests run. It is wired into nothing. It shows the shape of a lock;
it is not one, because nothing forces a real system to route through it.

## `skunkworks/`: lab pieces, each small, each with its own test
- `proved/backup-checker/`: "this backup only ever grew" as a Lean law (`append_only_iff`) and the same text as a
  72 KB Wasm checker. `backup/` is the plain-code twin with 435 stored vectors.
- `proved/onion-lean/` and `onion/`: a totals tree (a count kept at every level of a hash tree, so that a removed
  region cannot hide) as Lean laws, as Wasm, and as plain code, compared with each other.
- `proved/governed-organ/`: a small numeric part whose rule is proved in Lean, compiled to Wasm, and replaced only
  through a judged upgrade.
- `proved/cordis-lean/`: five small theorems about revertible effects, a sketch written while reading published
  work on the idea. It is ours, it is a sketch, and it claims nothing about anyone else's system.
- `delegation-exhibit/`, `bubble/`, `alibi/`: exhibits of delegation receipts and of two ways to show what a record
  did NOT contain.

The check scripts under `skunkworks/proved/` expect a pinned Lean toolchain at a path you set (`LAB`); they were
run in the lab and NOT from this tree. The plain-code tests run from this tree with Node 24; the backup test also needs Python 3 and uses your system's temporary folder (it removes what it makes).
None of this is used by any live system.
