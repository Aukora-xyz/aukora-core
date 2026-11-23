# Integration packet for the read-only core cell (both candidate versions). Mythos, 23 November 2026, 14:31

Everything below is RAN by me on the exact files unless tagged. The card takes ONE constant block and ONE fixture
file. The fixture is the SAME file for both versions; only the constant block differs.

## The constant block (choose one; the release verdict says which)
| | v0.8 small core (primary) | v0.5 small core (fallback) |
| --- | --- | --- |
| file | `aukora-core-lite.wasm` | `aukora-core-lite.wasm` |
| bytes | 679,046 | 666,064 |
| SHA-256 (the pin) | `2f10eb8fd9adb3f25d854b642bba29ceaadcbcb2cc40a2fb05fca51f770b59e9` | `8e7cca361db0ef321450e5f5fc70c807957c9e1095314fd533bdd4806abaa311` |
| law identity, OBSERVED (`lawByte(0..31)`) | `4815cb2ee9f39f6f186d575bdf04efab2b44d31ec9e85e33e9815409ac6acddc` | `5ef62914679b64c1953be26358188b27c39449e436dbdd327c1990addd381b8f` |
| law count, DECLARED | 44 | 37 |
| where the count is declared | public tree `RELEASE.json`, field `laws` (and `v0.8/PROVED.md`) | the v0.5 tree's `core/PROVED.md` (no manifest file in that tree) |
| exports used | `input init step head lawByte` | the same five |

The law COUNT is never observed: the file reports only the 32-byte identity. The panel labels the count "declared"
and the identity "observed", and shows a mismatch between the observed identity and the constant as REFUSED.

## The fixture (one file, both versions)
`sample-record.txt`: 11,659 bytes, SHA-256 `238d52d69f50d61aa445a812e56e055320a8ab707b8cf936b838cf03704f7dce`, 7 text
lines: line 1 the header `aukora-record v0.1`, line 2 the public keys (1,984 bytes as hex), lines 3 to 7 five
frames. Throw-away keys; it holds public keys and signatures only. In the lab at `release-extras/examples/`; in the
public tree at `examples/`.
Expected on BOTH cores: start accepted, 5 of 5 frames admitted, head
`e258bcc3f72d59da3307ed09a354493266f1e4c0a4185e255588c84391d4aa9f`.

## When the panel may show the good state
ONLY when all four hold: the file's SHA-256 equals the pin; the observed law identity equals the constant; all 5
frames are admitted; the head equals the expected head. Anything else is one of the words below, never green.

## Failure words, and the cases that produce them (each RAN on the v0.8 small core with the bare reader)
| what was done | what the core does | the panel says |
| --- | --- | --- |
| core file with one changed byte, or the other version's file | not instantiated | `not the pinned core` |
| a hex character changed in file line 2 (keys) | `init()` returns 0 | `refused at the start` |
| a hex character changed in file line 4 (frame 2) | frame 2 refused | `refused at frame 2` |
| a hex character changed in file line 3 (frame 1, unsigned speech) | frame 1 ADMITTED, frame 2 refused | `refused at frame 2` |
| a hex character changed in file line 6 (frame 4, unsigned report) | frame 4 ADMITTED, frame 5 refused | `refused at frame 5` |
| a hex character changed in file line 7 (the LAST frame, unsigned) | all 5 admitted, head differs | `replayed 5 frames, head is not the fixture's` |
| file cut after line 5 | 3 frames admitted, another head | `replayed 3 frames, no continuity comparison` |
| file line 5 dropped | frame 3 refused | `refused at frame 3` |
| another header line | not attempted | `unavailable: not a record this cell reads` |
| fetch failed, digest could not be computed, a trap, a budget exceeded | stop, discard the instance | `unavailable` |
Two facts the table teaches, both known limits and both worth one help line: a change in an UNSIGNED line is caught
at the NEXT line, not at the changed one; a change in the LAST unsigned line is caught only by comparing the head
with one kept elsewhere. That is why the good state needs the expected head.

## Bounds
Record text at most 256 KiB and at most 514 lines (header, keys, 512 frames: one segment). Every hex line even in
length and lower-case hex only. Wrap each `init()` and `step()` in try/catch; after a trap, drop the instance.
One instance per replay; never reuse an instance after a refusal for a second record.

## The module's contract (browser or worker, no dependency)
```js
const PIN = '<the pin>', IDENTITY = '<the observed law identity>', EXPECTED_HEAD = '<the fixture head>';
const hex = b => Array.from(new Uint8Array(b), x => x.toString(16).padStart(2, '0')).join('');
export async function replay(coreBytes, recordText) {
  if (hex(await crypto.subtle.digest('SHA-256', coreBytes)) !== PIN) return { state: 'not the pinned core' };
  const api = (await WebAssembly.instantiate(coreBytes, {})).instance.exports;       // no imports
  const lines = recordText.trim().split('\n');
  if (lines[0] !== 'aukora-record v0.1' || lines.length > 514 || lines.slice(1).some(l => !/^(?:[0-9a-f]{2})+$/.test(l))) return { state: 'unavailable: not a record this cell reads' };
  const feed = l => { for (let i = 0; i < l.length; i += 2) api.input(parseInt(l.slice(i, i + 2), 16)); };
  const read = f => Array.from({ length: 32 }, (_, i) => f(i).toString(16).padStart(2, '0')).join('');
  try {
    feed(lines[1]); if (api.init() !== 1) return { state: 'refused at the start' };
    if (read(api.lawByte) !== IDENTITY) return { state: 'refused: not the declared law identity' };
    for (let n = 2; n < lines.length; n++) { feed(lines[n]); if (api.step() !== 1) return { state: `refused at frame ${n - 1}` }; }
    return { state: 'replayed', frames: lines.length - 2, head: read(api.head), identity: IDENTITY };
  } catch { return { state: 'unavailable' }; }
}
```
The caller turns `replayed` into the good state only for the fixture, with 5 frames and `head === EXPECTED_HEAD`.

## Clean-checkout result, licence, notices
The public tree is assembled and scan-clean (id in my verdict file when both rebuilds are in). Licence
AGPL-3.0-or-later for the files in the tree; the small core file contains code compiled from Lean 4 (Apache-2.0);
it does NOT contain the proof checker (that is the full file). Notices: the tree's `NOTICE`.
