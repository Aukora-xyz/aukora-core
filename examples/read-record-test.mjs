// Dependency-free reader checks; disposable records stay in one temporary folder.
import { readFileSync, writeFileSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import { escapeText } from './read-record-display.mjs';
const root = fileURLToPath(new URL('../', import.meta.url));
const sample = readFileSync(new URL('./sample-record.txt', import.meta.url), 'utf8');
const head = readFileSync(new URL('./sample-record.head', import.meta.url), 'utf8').trim();
const dir = mkdtempSync(join(tmpdir(), 'aukora-reader-'));
const run = (...args) => spawnSync(process.execPath, ['examples/read-record.mjs', ...args], { cwd: root, encoding: 'utf8', timeout: 15000 });
const report = (label, ok) => {
  console.log(`${ok ? 'PASS' : 'FAIL'} ${label}`);
  if (!ok) process.exitCode = 1;
};
const check = (label, result, predicate) => {
  const ok = !result.error && result.signal === null && predicate(result);
  report(label, ok);
  if (!ok) console.log(result.error ?? `${result.status}: ${result.stdout}${result.stderr}`);
};
try {
  const args = ['--expect-head', head];
  const matched = run('examples/sample-record.txt', ...args);
  check('sample matches its expected head', matched, r =>
    r.status === 0 && r.stdout.includes('head matches the expected head') &&
    r.stdout.includes('frame 2: owner approval (both signatures, one use): deliver "send the weekly report to the team", audience "mail", generation 0, nonce 1, through frame 6 inclusive') &&
    (r.stdout.match(/^frame /gm) ?? []).length === 5);
  check('sample frame 2 approval says one use', matched, r => /^frame 2: .*one use.*$/m.test(r.stdout));
  const changed = sample.trim().split('\n');
  const frame = Buffer.from(changed[2], 'hex'); frame[frame.length - 1] ^= 1;
  changed[2] = frame.toString('hex');
  const changedFile = join(dir, 'changed.txt'); writeFileSync(changedFile, changed.join('\n') + '\n');
  check('changed frame cannot match', run(changedFile, ...args), r =>
    !r.stdout.includes('head matches') && ((r.status === 1 && r.stdout.includes('is refused by the core')) || (r.status === 3 && r.stdout.includes('HEAD MISMATCH:'))));
  const shorterFile = join(dir, 'shorter.txt'); writeFileSync(shorterFile, sample.trim().split('\n').slice(0, -1).join('\n') + '\n');
  const shorter = run(shorterFile, ...args);
  check('shorter valid record has a head mismatch', shorter, r =>
    r.status === 3 && r.stdout.includes('HEAD MISMATCH:') && r.stdout.includes('after 4 frames (a shorter or changed record)') && !r.stdout.includes('head matches'));
  check('shorter record labels every frame UNVERIFIED', shorter, r =>
    (r.stdout.match(/^UNVERIFIED frame \d+: /gm) ?? []).length === 4 && !/^frame /m.test(r.stdout));
  const missing = run('examples/sample-record.txt');
  check('missing expected head exits 2', missing, r =>
    r.status === 2 && r.stdout.includes('no expected head was given') && r.stdout.includes(`head ${head}`) &&
    r.stdout.includes('examples/sample-record.head') && r.stdout.includes('RELEASE.json') && !r.stdout.includes('head matches'));
  check('missing expected head labels every frame UNVERIFIED', missing, r =>
    (r.stdout.match(/^UNVERIFIED frame \d+: /gm) ?? []).length === 5 && !/^frame /m.test(r.stdout));
  const escaped = escapeText('\u202e\u200b');
  report('display escapes direction overrides and invisible characters',
    escaped === '"\\u202e\\u200b"' && !/[\u202e\u200b]/.test(escaped));
  report('display escapes non-ASCII UTF-16 code units',
    escapeText(' ~\u007f\u00e9\ud83d\ude00') === '" ~\\u007f\\u00e9\\ud83d\\ude00"');
  check('different Wasm is refused by the pin', run('examples/sample-record.txt', ...args, '--core', 'v0.8/aukora-core.wasm'), r =>
    r.status === 1 && r.stdout.trim() === 'not the pinned core file: refusing to run it');
} finally { rmSync(dir, { recursive: true, force: true }); }
