// A bare reader: replay a record, compare its head, and describe its frames. No keys, no dependencies.
// Usage (from the tree root): node examples/read-record.mjs <record> --expect-head <64 hex characters> [--core <wasm file>]
import { readFileSync } from 'node:fs'; import { createHash } from 'node:crypto';
const usage = () => { console.log('usage: node examples/read-record.mjs <record> --expect-head <64 hex characters> [--core <wasm file>]'); process.exit(2); };
const args = process.argv.slice(2), record = args.shift();
let expected, core;
if (!record || record.startsWith('--')) usage();
while (args.length) {
  const arg = args.shift();
  if (arg === '--expect-head' && expected === undefined) {
    expected = args.shift();
    if (!/^[0-9a-fA-F]{64}$/.test(expected ?? '')) usage();
    expected = expected.toLowerCase();
  } else if (arg === '--core' && core === undefined) {
    core = args.shift();
    if (!core || core.startsWith('--')) usage();
  } else if (!arg.startsWith('--') && core === undefined) core = arg; // Legacy positional core.
  else usage();
}
const PIN = '2f10eb8fd9adb3f25d854b642bba29ceaadcbcb2cc40a2fb05fca51f770b59e9';
const bytes = readFileSync(core ?? new URL('../v0.8/aukora-core-lite.wasm', import.meta.url));
if (createHash('sha256').update(bytes).digest('hex') !== PIN) { console.log('not the pinned core file: refusing to run it'); process.exit(1); }
const api = (await WebAssembly.instantiate(bytes, {})).instance.exports;      // the file imports nothing
const lines = readFileSync(record, 'utf8').trim().split('\n');
if (lines[0] !== 'aukora-record v0.1') { console.log('not a record'); process.exit(1); }
const feed = hex => { for (const b of Buffer.from(hex, 'hex')) api.input(b); };
const hex32 = f => Array.from({ length: 32 }, (_, i) => f(i).toString(16).padStart(2, '0')).join('');
feed(lines[1]); if (api.init() !== 1) { console.log('the start is refused'); process.exit(1); }
lines.slice(2).forEach((line, n) => { feed(line); if (api.step() !== 1) { console.log(`frame ${n + 1} is refused by the core`); process.exit(1); } });
const head = hex32(api.head);
if (expected === undefined) {
  console.log('no expected head was given, so the reader cannot tell a complete record from a shorter valid one');
  console.log(`head ${head}`);
  console.log('For the shipped sample, use --expect-head "$(cat examples/sample-record.head)"; RELEASE.json also lists sample.head.');
  process.exitCode = 2;
} else if (head !== expected) {
  console.log(`HEAD MISMATCH: expected ${expected} but this record replays to ${head} after ${lines.length - 2} frames (a shorter or changed record)`);
  process.exitCode = 3;
} else {
  console.log('head matches the expected head');
  console.log(`replays: ${lines.length - 2} lines\nhead ${head}\nlaw identity ${hex32(api.lawByte)}`);
}

// v0.8/EXPORTS.md exposes raw recordByte, not decoded frames. The layout is defined
// in v0.2/WIRE.md (inherited by v0.8/WIRE.md), also encoded by standalone/aukora.mjs.
// Describe only admitted frames; this display decoder makes no admission decisions.
function describe(b) {
  let p = 0;
  const take = n => { if (p + n > b.length) throw Error('short field'); const v = b.subarray(p, p + n); p += n; return v; };
  const u16 = () => take(2).readUInt16LE();
  const blob = () => take(u16());
  const text = v => JSON.stringify(new TextDecoder('utf-8', { fatal: true, ignoreBOM: true }).decode(v));
  const payload = v => { try { return text(v); } catch { return `hex ${v.toString('hex')}`; } };
  const intent = () => {
    const kind = take(1)[0];
    const body = kind === 0 ? `deliver ${payload(blob())}` : kind === 1 ? `install sha256 ${take(32).toString('hex')}` : null;
    if (body === null) throw Error('unknown intent');
    return `${body}, audience ${text(blob())}, generation ${u16()}, nonce ${u16()}`;
  };
  try {
    if (b[0] === 0x18) {
      p = 41; const expiry = take(8).readBigUInt64LE();
      return `owner approval (both signatures): ${intent()}, through frame ${expiry} inclusive`;
    }
    if (b[0] === 0x13 && b[3350] === 0x03) {
      p = 3351; return `owner approval (both signatures, one use): ${intent()}`;
    }
    if (b[0] === 0x00 && b[41] === 0x00) { p = 42; return `statement: ${text(blob())}`; }
    if (b[0] === 0x17 && b[73] === 0x04) { p = 74; return `direct act: ${intent()}`; }
    if ((b[0] === 0x00 || b[0] === 0x1a) && b[41] === 0x05) {
      p = 42; const subject = intent(), result = ['confirmed', 'failed', 'unknown'][take(1)[0]];
      if (result === undefined) throw Error('unknown result');
      return `${b[0] === 0x1a ? 'corrected' : 'reported'} outcome: ${result}; ${subject}`;
    }
  } catch { /* An unsupported display must never be guessed. */ }
  return '(kind not decoded by this reader)';
}
lines.slice(2).forEach((line, n) => console.log(`frame ${n + 1}: ${describe(Buffer.from(line, 'hex'))}`));
