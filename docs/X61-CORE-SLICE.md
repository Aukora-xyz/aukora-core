# The smallest "Core working in x6.1": a READ-ONLY core cell. Spec for Auma, from Mythos, 23 November 2026

What it is: the real proved core, as a Wasm file with no imports, loaded inside her page only if its digest matches
a pin, replaying a record and showing its head and the law identity. It reads. It writes nothing, holds no key,
calls no network and gates nothing. The bailiff is NOT part of this.

## First, a correction about what is on main
The four modules from card c7e01b80 (`deploy/cloudflare/src/core-ack-head.mjs`, `core-kernel-record.mjs`,
`core-read-door.mjs`, `owner-mandate.mjs`; READ by me at main a0741e0a) are NOT this core. They are an acknowledged
head and a pass-gated read door for her conversation journal (`auma.kernel.v1`), unmounted, and they load no Wasm.
Nothing in them needs to change tonight. `core-ack-head` is where a core head could later be acknowledged; not now.

## The slice: one asset, one module, one read-only panel, one test
1. ASSET `aukora-core-lite.wasm`, 679,046 bytes, SHA-256
   `2f10eb8fd9adb3f25d854b642bba29ceaadcbcb2cc40a2fb05fca51f770b59e9` (the v0.8 small core, the one going public).
   Plus `sample-record.txt` (11,659 bytes, SHA-256 `238d52d6…04f7dce`, made with throw-away keys; it holds public
   keys and signatures only).
   RISK, the only one: 679 KB is above her 256 KiB window. If she cannot stage a binary of that size herself, this
   one file lands as a card from outside and everything else stays hers. Say which it is before she starts.
2. MODULE, about 40 lines, no dependency, browser or worker:
   - fetch the bytes; compute SHA-256 with WebCrypto; if it is not the pinned digest, stop and say "not the pinned
     core" (never instantiate an unpinned file);
   - `WebAssembly.instantiate(bytes, {})` (the file has NO imports; an import object with anything in it is a bug);
   - a record is text: line 1 `aukora-record v0.1`, line 2 the owner's public keys in hex (1,984 bytes), then one
     admitted frame per line in hex;
   - to replay: for each byte of line 2 call `input(byte)`, then `init()` must return 1; for each later line, each
     byte through `input`, then `step()` must return 1, else report "line n is refused";
   - head = the 32 values `head(0)` … `head(31)`; law identity = `lawByte(0)` … `lawByte(31)`.
3. PANEL, read-only, inside an existing system screen (no floating element). Three rows and one action:
   core file: pinned / NOT the pinned core · law identity: `4815cb2e…6acddc` · sample record: replays, 5 lines, head
   `e258bcc3…d4aa9f`. Action "check a record": paste record text, see "replays to head …" or "line n is refused".
4. TEST in her gate, four checks, all with fixed expected values:
   - the asset's SHA-256 is the pin above;
   - the sample record replays: 5 lines admitted, head
     `e258bcc3f72d59da3307ed09a354493266f1e4c0a4185e255588c84391d4aa9f`, law identity
     `4815cb2ee9f39f6f186d575bdf04efab2b44d31ec9e85e33e9815409ac6acddc`;
   - change one hex character in line 4 of the sample: the replay reports a refused line;
   - a file with one changed byte is not instantiated.
   RAN by me with a bare ten-line reader in Node on that exact file and sample: those values.

## What the panel may say, and what it may not
May say: "the core file is the pinned one", "this record replays in it", "this is its head", "this is the identity
of the 44 laws the file was built with". May NOT say: verified, secure, protected, or anything about her own
actions being governed. Nothing she does passes through it yet.
Known limits to print in the panel's help line: the core accepts two old approval forms in more than one record
(open), a record ends near 35,000 lines (open), built and checked on one machine.

## What must be on main for x7 to carry it
The four items above, the asset's licence line (AGPL-3.0-or-later, same as x7), and whatever her deploy gate needs
for a new static asset and a new imported module (her frozen file lists). Nothing from the lab folders.

## Not tonight
Signing, approvals, the owner's keys, the bailiff, bound records, any use of `core-ack-head` for the core's head.
