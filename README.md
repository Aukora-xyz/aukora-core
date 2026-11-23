# Aukora Core

Aukora Core is a small, open-source record and approval engine for AI agents. Given a record, it replays the entries and decides which frames it admits. The released version is **v0.8**. The source, compiled WebAssembly and a sample record are in this repository.

**It is a witness, not a lock.** It cannot tell whether a host left something out, told the truth, or actually carried out an action. It doesn't govern any live system.

## See it run

From a clone of this repository, with Node.js 24:

```sh
node examples/read-record.mjs examples/sample-record.txt
```

Expected output:

```text
replays: 5 lines
head e258bcc3f72d59da3307ed09a354493266f1e4c0a4185e255588c84391d4aa9f
law identity 4815cb2ee9f39f6f186d575bdf04efab2b44d31ec9e85e33e9815409ac6acddc
```

The reader pins the shipped small core before running it. It prints the computed head; **you compare it** with the expected head above or with [RELEASE.json](RELEASE.json). A shortened record may still replay. Without a head kept independently, that replay doesn't tell you whether its newest entries are missing. The sample uses throw-away lab keys; it contains public keys and signatures, not the private keys. Don't put real records or credentials into these experiments. To try a damaged record, copy `examples/sample-record.txt` somewhere outside the clone and edit the copy.

## What is proved, what is tested, and what is still open

- **Proved about the model:** Lean checked one proposition with 44 named laws about one machine. That is not a proof about the compiled Wasm, its cryptography, or how a host uses its answers. The full Wasm includes a checker for changes to law data; this does not authorize replacing the executable. The small Wasm used in the example does not include that checker. See [what is proved](v0.8/PROVED.md) and [what is not proved](v0.8/NOT-PROVED.md).
- **Open in v0.8: two old commands aren't bound to a record.** The old one-time approval and old key-change forms don't name a record or position. The lab observed the same old approval admitted and acted on in two bound records owned by the same keys. The corresponding act-level experiment was not run for the old key change. The newer approval and key-change forms sign the head; do not mistake that for a fix to old starts.
- **Open in v0.8: long histories can trap.** The runtime keeps earlier segments. One run on an earlier small build trapped after roughly 35,000 lines with 3,000 bytes per line, rather than refusing cleanly. That was not measured on these shipped bytes and is not a capacity guarantee.
- **Not supplied:** passkey login, key recovery after losing the raw owner keys, a host that must obey the core, or evidence that every action was logged. Read [the full limitations](v0.8/NOT-PROVED.md) before relying on any result.

## Try the local checks

```sh
node standalone/test.mjs
sh run-all.sh
```

The first checks the v0.8 adapter with lab keys. The second runs the bundled release and lab smoke checks, not a Lean rebuild or every experiment. Its backup check needs Python 3 and uses the system temporary directory, cleaning up what it creates. If Python is absent, the runner prints `SKIP` for that check and ends with `PASS WITH SKIPS` instead of `ALL PASS`. Read the individual results. These test commands don't install dependencies; the source rebuild below is separate.

## Experimental work alongside the release

**v0.10 is not the release.** In the tested cases, a record started in bound mode refuses the two old command forms as classified by the decoder; the timed approval still works. Old-start records remain exposed, and this doesn't establish that no other route can produce the same effect. The refused list is fixed at start. v0.10 was built once by its builder on one Apple-silicon Mac; no independent from-scratch rebuild is evidenced here.

See [the next-line guide](NEXT-LINE.md) for exact commands and evidence for v0.9, v0.10, the bound-record adapter and the lab experiments. The effect-sink rehearsal uses lab keys and is not wired into a live application. The different parts of this repository do not all have the same level of evidence.

## Check bytes or rebuild

The [release manifest](RELEASE.json) lists the full and small v0.8 Wasm fingerprints and the sample fingerprint. Compare those to the exact files you use; matching bytes do not certify what the binary does. Each Wasm file contains one build-machine path of the upstream WASI SDK (`/Users/runner/work/wasi-sdk/...`); no path of ours is in them.

The documented rebuild is for **Apple-silicon macOS**. Linux rebuilds are untried. It needs Python 3, Node 24, the Xcode command-line tools, `curl`, `unzip`, `tar` and the pinned Lean and WASI SDK toolchains. The optional fetch step uses the network and needs about 540 MB for downloads and 1.8 GB for unpacking before pruning to about 650 MB, so keep roughly 2.5 GB free. It extracts the downloads before the staged-build tool checks the per-file pins. Use a separate, empty toolchain directory and an unused build destination.

```sh
sh release-tools/fetch-toolchain.sh toolchain
python3 release-tools/build-tree.py v0.8 ../core-build --toolchain toolchain
sh ../core-build/v0.8/build.sh
```

The last step should end with `PASS v0.8`. The documented v0.8 from-scratch builds produced matching artifacts on the same Mac. The [public release commit](https://github.com/Aukora-xyz/aukora-core/commit/0aaaeff1) records no independent empty-folder rebuild of this exact export at publication. Those are different claims.

Start with [the wire format](v0.8/WIRE.md), [the proofs](v0.8/PROVED.md) and [the limitations](v0.8/NOT-PROVED.md). [NOTICE](NOTICE) identifies the bundled upstream inputs.

Licence: AGPL-3.0-or-later.
