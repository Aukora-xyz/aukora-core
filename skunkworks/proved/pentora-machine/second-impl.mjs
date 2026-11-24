// A second implementation of the twelve calls of pentora.wasm, written from README.md alone (before EXPORTS.md and
// ASSUMPTIONS.md existed), compared with the shipped file on 100,000 seeded packets. It reads only the owner and
// vertex tables from the wasm (the README does not print the corner numbering) and checks the README's incidence laws
// on them. `node second-impl.mjs` must exit 0; `node second-impl.mjs --control` plants a wrong expectation and must
// exit 1. This is a comparison on generated packets, not a proof of equivalence.
import fs from "node:fs";
import path from "node:path";

// Run from any folder: the shipped file sits beside this script.
const WASM_PATH = new URL("./pentora.wasm", import.meta.url);
const controlMode = process.argv.includes("--control");

// Deterministic PRNG (Mulberry32) so the 100,000 packets are 100% reproducible.
function makeRng(seed) {
  let a = seed >>> 0;
  return function next() {
    a |= 0;
    a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const rng = makeRng(0x20261124);
const randInt = (n) => Math.floor(rng() * n);

// Load pentora.wasm (read-only oracle to compare our independent README implementation against).
const wasmBytes = fs.readFileSync(WASM_PATH);
const wasmMod = new WebAssembly.Module(wasmBytes);
const imports = WebAssembly.Module.imports(wasmMod);
if (imports.length !== 0) {
  throw new Error(`Expected 0 imports, got ${imports.length}`);
}
const wasm = new WebAssembly.Instance(wasmMod).exports;

// Step A: Query vertex(c, j) and owner(v, w) once to obtain the README's labeled vertex table
// (note: README.md does not print the raw numbering of the 20 corners or per-organ 8-slot permutation),
// and independently check ALL README incidence laws on those extracted tables.
const ownerTable = Array.from({ length: 20 }, (_, v) => [wasm.owner(v, 0), wasm.owner(v, 1)]);
const vertexTable = Array.from({ length: 5 }, (_, c) =>
  Array.from({ length: 8 }, (_, j) => wasm.vertex(c, j))
);

// Build corner lookup map (organ, corner) -> slot j strictly from vertexTable, and assert every axiom.
const slotOf = Array.from({ length: 5 }, () => new Map());
for (let c = 0; c < 5; c++) {
  if (new Set(vertexTable[c]).size !== 8) {
    throw new Error(`Organ ${c} does not have 8 distinct corners`);
  }
  for (let j = 0; j < 8; j++) {
    const v = vertexTable[c][j];
    if (v < 0 || v >= 20) throw new Error(`Invalid vertex ${v}`);
    slotOf[c].set(v, j);
  }
}
for (let v = 0; v < 20; v++) {
  const [a, b] = ownerTable[v];
  if (a < 0 || a >= 5 || b < 0 || b >= 5 || a === b) {
    throw new Error(`Corner ${v} invalid owners [${a}, ${b}]`);
  }
  const actualOwners = [];
  for (let c = 0; c < 5; c++) {
    if (slotOf[c].has(v)) actualOwners.push(c);
  }
  if (actualOwners.length !== 2 || actualOwners[0] !== Math.min(a, b) || actualOwners[1] !== Math.max(a, b)) {
    throw new Error(`Corner ${v} owner mismatch between vertex() and owner()`);
  }
}
// Every pair of distinct organs shares exactly 2 corners.
let pairSharedCounts = new Map();
for (let a = 0; a < 5; a++) {
  for (let b = a + 1; b < 5; b++) {
    let shared = [];
    for (let v = 0; v < 20; v++) {
      const [o0, o1] = ownerTable[v];
      if ((o0 === a && o1 === b) || (o0 === b && o1 === a)) shared.push(v);
    }
    if (shared.length !== 2) {
      throw new Error(`Pair (${a},${b}) shares ${shared.length} corners, expected 2`);
    }
    pairSharedCounts.set(`${a}-${b}`, shared);
  }
}

// Precompute 3^0 .. 3^109 in BigInt for independent base-3 address encoding.
const POW3 = [1n];
for (let i = 1; i <= 110; i++) POW3.push(POW3[i - 1] * 3n);

// Step B: Independent Second Implementation from README.md alone.
// Input: Uint8Array or Array of bytes.
// Packet layout (README): 130 bytes, 5 organs * 26 bytes each (18 private slots + 8 corner slots).
// Input codes: 0=fail, 1=unknown, 2=pass.
function runRef(pkt) {
  const wellFormed = pkt.length === 130 && pkt.every((b) => b === 0 || b === 1 || b === 2);
  if (!wellFormed) {
    return {
      wellFormed: false,
      judge: 0xffffffff,
    };
  }

  // Decode each organ's 26 cells and compute tallies & organ health.
  const tally = Array.from({ length: 5 }, () => [0, 0, 0]);
  const organHealth = new Array(5);
  for (let c = 0; c < 5; c++) {
    const base = c * 26;
    for (let k = 0; k < 26; k++) {
      tally[c][pkt[base + k]]++;
    }
    if (tally[c][0] + tally[c][1] + tally[c][2] !== 26) {
      throw new Error("organ_triangle invariant violated in reference!");
    }
    // 0 when all passed, 1 when at least one unknown and none failed, 2 when any failed.
    organHealth[c] = tally[c][0] > 0 ? 2 : tally[c][1] > 0 ? 1 : 0;
  }

  // Check seams across the 20 corners.
  let seams = 0;
  let lowestSeam = -1;
  const cornerVal = new Array(20);
  for (let v = 0; v < 20; v++) {
    const [o0, o1] = ownerTable[v];
    const v0 = pkt[o0 * 26 + 18 + slotOf[o0].get(v)];
    const v1 = pkt[o1 * 26 + 18 + slotOf[o1].get(v)];
    cornerVal[v] = v0;
    if (v0 !== v1) {
      seams |= 1 << v;
      if (lowestSeam === -1) lowestSeam = v;
    }
  }

  // Suspects: 0 when no seams; otherwise bit c set iff organ c owns EVERY disputed corner.
  let suspects = 0;
  if (seams !== 0) {
    for (let c = 0; c < 5; c++) {
      let ownsAll = true;
      for (let v = 0; v < 20; v++) {
        if ((seams & (1 << v)) !== 0) {
          const [o0, o1] = ownerTable[v];
          if (o0 !== c && o1 !== c) {
            ownsAll = false;
            break;
          }
        }
      }
      if (ownsAll) suspects |= 1 << c;
    }
  }

  // Judge: base-3 encoding of organ healths (organ 0 lowest) on agreement, or 256 + lowest seam.
  let judge;
  if (seams !== 0) {
    judge = 256 + lowestSeam;
  } else {
    judge =
      organHealth[0] +
      organHealth[1] * 3 +
      organHealth[2] * 9 +
      organHealth[3] * 27 +
      organHealth[4] * 81;
  }

  // Centre health, seal, and 22-byte base-3 address when agreeing (else 0xFFFFFFFF sentinels for seal/centre).
  let seal = 0xffffffff;
  let centre = 0xffffffff;
  let addressBytes = null;
  if (seams === 0) {
    let cornerSum = 0;
    let hasFail = false;
    let hasUnknown = false;
    let addr = 0n;
    let idx = 0;

    // 90 private cells: organs 0..4, private slots 0..17
    for (let c = 0; c < 5; c++) {
      const base = c * 26;
      for (let k = 0; k < 18; k++) {
        const t = pkt[base + k];
        if (t === 0) hasFail = true;
        else if (t === 1) hasUnknown = true;
        if (t !== 0) addr += BigInt(t) * POW3[idx];
        idx++;
      }
    }
    // 20 shared corners: v = 0..19
    for (let v = 0; v < 20; v++) {
      const t = cornerVal[v];
      cornerSum += t;
      if (t === 0) hasFail = true;
      else if (t === 1) hasUnknown = true;
      if (t !== 0) addr += BigInt(t) * POW3[idx];
      idx++;
    }

    if (addr >= POW3[110]) throw new Error("Address >= 3^110");
    seal = cornerSum % 3;
    centre = hasFail ? 2 : hasUnknown ? 1 : 0;
    addressBytes = new Array(22);
    for (let i = 0; i < 22; i++) {
      addressBytes[i] = Number((addr >> BigInt(8 * i)) & 0xffn);
    }
  }

  // Heal(x, v): corner v as reported by one owner other than x (first owner unless x is first owner).
  function heal(x, v) {
    const [o0, o1] = ownerTable[v];
    const chosen = o0 === x ? o1 : o0;
    return pkt[chosen * 26 + 18 + slotOf[chosen].get(v)];
  }

  return {
    wellFormed: true,
    judge,
    seams,
    suspects,
    tally,
    seal,
    centre,
    addressBytes,
    heal,
  };
}

// Helper to encode a 110-cell body (90 private + 20 corners) into 5 agreeing organ reports.
function encodeBody(priv, corn, mutator = null) {
  const pkt = new Array(130);
  for (let c = 0; c < 5; c++) {
    const base = c * 26;
    for (let k = 0; k < 18; k++) pkt[base + k] = priv[c * 18 + k];
    for (let j = 0; j < 8; j++) pkt[base + 18 + j] = corn[vertexTable[c][j]];
  }
  if (mutator) mutator(pkt);
  return pkt;
}

function makePacket(index) {
  if (index < 40000) {
    // Cohort 1 (40,000): Random agreeing bodies
    const priv = Array.from({ length: 90 }, () => randInt(3));
    const corn = Array.from({ length: 20 }, () => randInt(3));
    return { cohort: "agreeing_random", pkt: encodeBody(priv, corn), truthCorn: corn, faulty: -1 };
  }
  if (index < 65000) {
    // Cohort 2 (25,000): Single-organ fault packets (1 organ corrupts 1..8 corners; possibly private too)
    const priv = Array.from({ length: 90 }, () => randInt(3));
    const corn = Array.from({ length: 20 }, () => randInt(3));
    const faulty = randInt(5);
    const numFlip = 1 + randInt(8);
    const pkt = encodeBody(priv, corn, (buf) => {
      const slots = [0, 1, 2, 3, 4, 5, 6, 7];
      for (let i = 0; i < numFlip; i++) {
        const pick = i + randInt(8 - i);
        [slots[i], slots[pick]] = [slots[pick], slots[i]];
        const pos = faulty * 26 + 18 + slots[i];
        buf[pos] = (buf[pos] + 1 + randInt(2)) % 3;
      }
      if (randInt(2) === 1) {
        const pSlot = randInt(18);
        buf[faulty * 26 + pSlot] = (buf[faulty * 26 + pSlot] + 1 + randInt(2)) % 3;
      }
    });
    return { cohort: "single_organ_fault", pkt, truthCorn: corn, faulty };
  }
  if (index < 90000) {
    // Cohort 3 (25,000): Uniformly random 130-byte well-formed packets (dense multi-seam disagreements)
    const pkt = Array.from({ length: 130 }, () => randInt(3));
    return { cohort: "uniform_random_130", pkt, truthCorn: null, faulty: -1 };
  }
  if (index < 95000) {
    // Cohort 4 (5,000): Edge / boundary agreeing packets (all-0, all-1, all-2/go, single flips, max/min addr)
    const sub = index - 90000;
    const priv = new Array(90);
    const corn = new Array(20);
    if (sub === 0) {
      priv.fill(0); corn.fill(0);
    } else if (sub === 1) {
      priv.fill(1); corn.fill(1);
    } else if (sub < 500) {
      // Mostly all-2 ('go') with 0, 1, or 2 flips to test go/veto boundaries
      priv.fill(2); corn.fill(2);
      if (sub > 10) {
        const pos = randInt(110);
        const val = randInt(2); // 0 or 1
        if (pos < 90) priv[pos] = val; else corn[pos - 90] = val;
      }
    } else if (sub < 2500) {
      // Heavy pass-biased agreeing bodies (~90% pass -> mixes judge=0..242 and centre=0/1/2)
      for (let i = 0; i < 90; i++) priv[i] = randInt(10) === 0 ? randInt(2) : 2;
      for (let i = 0; i < 20; i++) corn[i] = randInt(10) === 0 ? randInt(2) : 2;
    } else {
      // Sparse single/pair active cells in all-0 or all-2 backgrounds
      const bg = sub % 2 === 0 ? 0 : 2;
      priv.fill(bg); corn.fill(bg);
      const count = 1 + (sub % 5);
      for (let k = 0; k < count; k++) {
        const pos = randInt(110);
        const val = randInt(3);
        if (pos < 90) priv[pos] = val; else corn[pos - 90] = val;
      }
    }
    return { cohort: "edge_agreeing", pkt: encodeBody(priv, corn), truthCorn: corn, faulty: -1 };
  }
  // Cohort 5 (5,000): Malformed packets (bad lengths or invalid byte codes 3..255)
  const sub = index - 95000;
  if (sub < 2500) {
    const lengths = [0, 1, 2, 128, 129, 131, 132, 200];
    const len = lengths[sub % lengths.length];
    const pkt = Array.from({ length: len }, () => randInt(3));
    return { cohort: "malformed_len", pkt, truthCorn: null, faulty: -1 };
  }
  const pkt = Array.from({ length: 130 }, () => randInt(3));
  const badChoices = [3, 4, 10, 127, 254, 255];
  const flips = 1 + randInt(3);
  for (let k = 0; k < flips; k++) {
    pkt[randInt(130)] = badChoices[randInt(badChoices.length)];
  }
  return { cohort: "malformed_byte", pkt, truthCorn: null, faulty: -1 };
}

const TOTAL = 100000;
const stats = {
  total: 0,
  agreeing: 0,
  disagreeing: 0,
  malformed: 0,
  judgeZero: 0,
  singleSuspectConfirmed: 0,
  healTruthChecked: 0,
  mismatches: 0,
  exportsChecked: 0,
  cohorts: {},
};
const mismatchSamples = [];

const t0 = performance.now();

for (let idx = 0; idx < TOTAL; idx++) {
  const { cohort, pkt, truthCorn, faulty } = makePacket(idx);
  stats.total++;
  stats.cohorts[cohort] = (stats.cohorts[cohort] || 0) + 1;

  const ref = runRef(pkt);
  if (controlMode && idx === 0) {
    // Planted wrong expectation to prove comparator catches mismatches.
    ref.judge = (ref.judge + 1) % 243;
  }

  wasm.reset();
  for (let i = 0; i < pkt.length; i++) wasm.input(pkt[i]);

  const wJudge = wasm.judge() >>> 0;
  stats.exportsChecked++;
  if (wJudge !== ref.judge) {
    stats.mismatches++;
    if (mismatchSamples.length < 10) {
      mismatchSamples.push({ idx, cohort, fn: "judge", wasm: wJudge, ref: ref.judge });
    }
    continue;
  }

  if (!ref.wellFormed) {
    stats.malformed++;
    continue;
  }

  if (ref.judge === 0) stats.judgeZero++;

  const wSeams = wasm.seams() >>> 0;
  const wSuspects = wasm.suspects() >>> 0;
  const wSeal = wasm.seal() >>> 0;
  const wCentre = wasm.centre() >>> 0;
  stats.exportsChecked += 4;

  const diffs = [];
  if (wSeams !== ref.seams) diffs.push(["seams", wSeams, ref.seams]);
  if (wSuspects !== ref.suspects) diffs.push(["suspects", wSuspects, ref.suspects]);
  if (wSeal !== ref.seal) diffs.push(["seal", wSeal, ref.seal]);
  if (wCentre !== ref.centre) diffs.push(["centre", wCentre, ref.centre]);

  for (let c = 0; c < 5; c++) {
    for (let t = 0; t < 3; t++) {
      const wt = wasm.tally(c, t);
      stats.exportsChecked++;
      if (wt !== ref.tally[c][t]) diffs.push([`tally(${c},${t})`, wt, ref.tally[c][t]]);
    }
  }

  if (ref.seams === 0) {
    stats.agreeing++;
    for (let i = 0; i < 22; i++) {
      const wb = wasm.addressByte(i);
      stats.exportsChecked++;
      if (wb !== ref.addressBytes[i]) diffs.push([`addressByte(${i})`, wb, ref.addressBytes[i]]);
    }
    // Check all 100 heal(x, v) pairs on every agreeing packet (100 * 45k = 4.5M checks, tiny in Wasm).
    for (let x = 0; x < 5; x++) {
      for (let v = 0; v < 20; v++) {
        const wh = wasm.heal(x, v);
        stats.exportsChecked++;
        if (wh !== ref.heal(x, v) || wh !== truthCorn[v]) {
          diffs.push([`heal(${x},${v})`, wh, ref.heal(x, v)]);
          break;
        }
      }
      if (diffs.length > 0 && diffs[diffs.length - 1][0].startsWith("heal")) break;
    }
  } else {
    stats.disagreeing++;
    if (cohort === "single_organ_fault") {
      // Faulty organ must always appear in suspects bitmask.
      if ((wSuspects & (1 << faulty)) === 0) {
        diffs.push([`faulty_in_suspects(${faulty})`, wSuspects, 1 << faulty]);
      }
      if (wSuspects === 1 << faulty) stats.singleSuspectConfirmed++;
      // Verify heal(faulty, v) recovers ground-truth corner values for ALL 20 corners!
      for (let v = 0; v < 20; v++) {
        const wh = wasm.heal(faulty, v);
        stats.exportsChecked++;
        stats.healTruthChecked++;
        if (wh !== ref.heal(faulty, v) || wh !== truthCorn[v]) {
          diffs.push([`heal_truth(${faulty},${v})`, wh, truthCorn[v]]);
          break;
        }
      }
    } else {
      // On dense multi-seam packets, still check heal(x, v) matches ref.heal(x, v) for all 100 pairs.
      for (let x = 0; x < 5; x++) {
        for (let v = 0; v < 20; v++) {
          const wh = wasm.heal(x, v);
          stats.exportsChecked++;
          if (wh !== ref.heal(x, v)) {
            diffs.push([`heal(${x},${v})`, wh, ref.heal(x, v)]);
            break;
          }
        }
        if (diffs.length > 0 && diffs[diffs.length - 1][0].startsWith("heal")) break;
      }
    }
  }

  if (diffs.length > 0) {
    stats.mismatches++;
    if (mismatchSamples.length < 10) {
      mismatchSamples.push({ idx, cohort, diffs });
    }
  }
}

const elapsedMs = performance.now() - t0;

console.log(`MODE: ${controlMode ? "CONTROL (planted bug)" : "NORMAL"}`);
console.log(`WASM: ${WASM_PATH} (${wasmBytes.length} bytes)`);
console.log(`PACKETS: ${stats.total} in ${elapsedMs.toFixed(1)} ms (${(stats.total / (elapsedMs / 1000)).toFixed(0)} pkt/s)`);
console.log(`EXPORTS_CHECKED: ${stats.exportsChecked}`);
console.log(`BREAKDOWN: agreeing=${stats.agreeing} (judge==0: ${stats.judgeZero}), disagreeing=${stats.disagreeing}, malformed=${stats.malformed}`);
console.log(`COHORTS: ${JSON.stringify(stats.cohorts)}`);
console.log(`SINGLE_ORGAN_HEAL_CORNERS_VERIFIED: ${stats.healTruthChecked} (sole suspect: ${stats.singleSuspectConfirmed} / ${stats.cohorts.single_organ_fault})`);
console.log(`MISMATCH_PACKETS: ${stats.mismatches}`);
if (mismatchSamples.length > 0) {
  console.log("FIRST_MISMATCHES:", JSON.stringify(mismatchSamples, null, 2));
}

if (stats.mismatches !== 0) {
  process.exit(1);
}
