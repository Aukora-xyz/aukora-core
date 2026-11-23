# Aukora Core

[![tests](https://github.com/Aukora-xyz/aukora-core/actions/workflows/tests.yml/badge.svg)](https://github.com/Aukora-xyz/aukora-core/actions/workflows/tests.yml)

Aukora Core is an open-source way to replay an AI agent's record and check which actions its owner approved in that record, without trusting the agent's summary.

From this checkout with Node.js 24, run:

```sh
node examples/read-record.mjs examples/sample-record.txt --expect-head "$(cat examples/sample-record.head)"
```

```text
head matches the expected head
replays: 5 lines
head e258bcc3f72d59da3307ed09a354493266f1e4c0a4185e255588c84391d4aa9f
law identity 4815cb2ee9f39f6f186d575bdf04efab2b44d31ec9e85e33e9815409ac6acddc
frame 1: statement: "a sample record: every line below was admitted by the core"
frame 2: owner approval (both signatures, one use): deliver "send the weekly report to the team", audience "mail", generation 0, nonce 1, through frame 6 inclusive
frame 3: direct act: deliver "send the weekly report to the team", audience "mail", generation 0, nonce 1
frame 4: reported outcome: confirmed; deliver "send the weekly report to the team", audience "mail", generation 0, nonce 1
frame 5: statement: "the end"
```

This checks the record you were given. It does not show that any outside action actually happened, and a reader that has no independently kept expected head cannot tell a complete record from a shorter valid one. Here the expected head ships in the same repository, so this run only shows the mechanism. In real use the expected head must come from a source the sender of the record does not control.

A **frame** is one encoded entry. The **head** is the resulting record fingerprint, and the **law identity** identifies the rule set the core reports. The reader checks the small Wasm file against a pinned digest; for the shipped sample, the command above checks the published expected head (also in [RELEASE.json](RELEASE.json)) and exits non-zero on a mismatch. For your own records, obtain the expected head independently of the record you are handed; the sample head here is a demo fixture, not independent attestation of a live record.

**A witness, not a lock.** A valid replay is not proof the host logged everything, told the truth, or carried out an external action. Core does not govern a live system. The sample uses lab keys and includes no private signing material.

## What is proved / what is not

- **Released v0.8:** Lean checked one proposition with 44 named laws for one model. Read [the laws](v0.8/PROVED.md) and [their limits](v0.8/NOT-PROVED.md). The proofs do not establish compiler or cryptographic correctness, absence of side channels, or that the compiled engine and host behave like the model.
- **Two builds, two uses:** The small Wasm replays records. The full Wasm includes a checker for changes to rule data; it does not authorize replacing the executable. The checker/runtime comparison is evidence, not a proof of their correspondence to the model.
- **Scope:** Raw signing keys, not passkeys; no recovery if the owner loses the required signing keys. A shorter record can replay cleanly unless a reader independently retained an expected head. The lab engine's finite capacity matters.

## Open defects in v0.8

1. **Two old command forms are not tied to a record.** An old one-time approval was accepted and acted on in two bound records owned by the same keys. The old key-change format also lacks the binding; that corresponding act-level run was not made on v0.8. The newer approval and key-change forms sign the head; that does not repair old starts.
2. **Long histories can trap.** The shipped v0.8 small core trapped after 34,987 lines of 3,000 bytes each (102.1 MiB) in one measurement on one Mac, and the experimental v0.10 small core after 34,988. That is one observation, not a capacity limit.

Experimental **v0.10** refused both old decoded forms in the tested bound records while still admitting the timed approval. The refused list is fixed at start; old-start records remain exposed. That test does not establish that another route cannot produce the same effect. v0.10 was built twice from scratch on one Apple-silicon Mac by two builders and both files came out byte-identical (the second builder's report); there is no rebuild on other hardware or by anyone outside the project. [Experimental evidence and limits](NEXT-LINE.md).

## Where things are

Start with [the repository map](docs/WHERE-THINGS-ARE.md). The v0.8 release, later experiments, the earlier research builds and the preserved build inputs are intentionally separate. The host adapter and sample run without installing npm packages. The effect-sink rehearsal is not wired into production.

Corrections to frozen pages are in [ERRATA.md](ERRATA.md). The v0.10 proofs are indexed in [docs/V0.10-PROOF-INDEX.md](docs/V0.10-PROOF-INDEX.md). The evidence from the first hardening round is in [NEXT-LINE.md](NEXT-LINE.md#hardening-round-1-23-to-24-november-2026).

## Check it yourself

```sh
node standalone/test.mjs
sh run-all.sh
```

The first runs the v0.8 adapter's checks. The second runs selected release and lab checks, not a Lean rebuild or every experiment. Its backup check needs Python 3 and writes a temporary folder it later removes. Without Python the suite reports `PASS WITH SKIPS` when its remaining checks succeed. The [Linux checks](https://github.com/Aukora-xyz/aukora-core/actions/workflows/tests.yml) exercise the shipped artifacts; they do not rebuild them.

[RELEASE.json](RELEASE.json) has the expected fingerprints for both v0.8 files and the sample. Those pins identify bytes, not behavior. The Wasm files include an upstream WASI SDK build-machine path. To explore refusal, edit a disposable copy of the public sample, never a real record. See [contributing](CONTRIBUTING.md) or [private security reporting](SECURITY.md).

## Rebuild

The documented source rebuild targets **Apple-silicon macOS**, not Linux. Two documented v0.8 builds on the same Mac matched, but an independent empty-folder rebuild of the exact public export is not evidenced here. The platform's CI smoke checks are a separate result.

You'll need Node 24, Python 3, the Xcode command-line tools, and the pinned Lean and WASI SDK toolchains. The optional fetch uses `curl`, `unzip` and `tar`, downloads about 540 MB and needs about 2.5 GB free. It extracts the downloads before the later per-file pin check. Use a separate empty directory for the toolchain and an unused build destination.

```sh
sh release-tools/fetch-toolchain.sh toolchain
python3 release-tools/build-tree.py v0.8 ../core-build --toolchain toolchain
sh ../core-build/v0.8/build.sh
```

Expect `PASS v0.8` at the end. Keep the result and file digests with the exact revision and platform. Source and third-party terms are documented in [LICENSE](LICENSE) and [NOTICE](NOTICE).
