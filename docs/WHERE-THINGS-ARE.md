# Where things are

Start with [the sample replay](../README.md#aukora-core). The folder names below are preserved because the rebuild stages selected files from those exact paths. A folder's presence is not a claim that its entire contents are covered by CI.

| Area | Folder | What's inside and how to read it |
| --- | --- | --- |
| Release | [v0.8](../v0.8/) | Release model, wire format, lite/full Wasm, fingerprints, tests, and the proved/not-proved ledger. |
| Release | [standalone](../standalone/) | Node adapter, CLI and MCP server; the adapter check is in the smoke suite. No production-host claim. |
| Release | [examples](../examples/) | Public sample and bare replay reader; compare the result with RELEASE.json. Lab keys only. |
| Release | [release-tools](../release-tools/) | Stages the macOS arm64 build and checks the pinned toolchain files. Not a CI rebuild or a Linux build. |
| Release support | [LICENSES](../LICENSES/) | Third-party license texts; see NOTICE for upstream inputs. |
| Release support | [.github](../.github/) | Linux smoke workflow for shipped bytes, not compiler or rebuild validation. |
| Release support | [release-extras](../release-extras/), [release-patches](../release-patches/), `rebuild.sh`, `fork-release.py`, `memwatch.py` | Release-assembly tooling and public-release patches. Lab tooling; not needed to run the sample. |
| Experimental | [v0.9](../v0.9/) | Decoded-command table work. See NEXT-LINE for evidence; inherited proof-page headings aren't v0.9 results. |
| Experimental | [v0.10](../v0.10/) | Bound-record refusal of two old forms in tested cases; built twice on one Mac by two builders, byte-identical; no outside rebuild evidenced. |
| Experimental | [standalone-next](../standalone-next/) | Node adapter for the bound-record formats; selected checks, not a deployed integration. |
| Experimental | [bailiff-rehearsal](../bailiff-rehearsal/) | Effect sink, promotion judge and verdict record rehearsed with lab keys; not a production lock. |
| Experimental | [skunkworks](../skunkworks/) | Backup, totals tree, delegation and other lab pieces. Some run in the smoke suite; some need a separately pinned Lean toolchain. |
| Experimental | [pcw](../pcw/), [context-membrane](../context-membrane/), [governed-rsi-v0](../governed-rsi-v0/), [spike-root-v2](../spike-root-v2/) | Small lab experiments (a Lean lattice and refusal proof, an append-only context check, a governed self-improvement rehearsal, a Lean spike for the next root theorem). No release claim and no live effect. |
| Research history | [v0.2](../v0.2/) to [v0.7](../v0.7/) | Earlier research builds with their Lean proofs, fixtures and tests, kept so earlier results can be rechecked. Not releases. |
| Research history | [docs](../docs/), [evidence](../evidence/) | Working notes, round briefs and specs written during the research, and break-it attempts, tests and proof outputs. Working material, not documentation of the release: read the README and v0.8/NOT-PROVED.md first. |
| History / input | [v0.1](../v0.1/) | Older fixtures and vectors. The v0.8 build reads selected files; no modern release claim. |
| History / input | [spike](../spike/) | Earlier compiler/runtime experiments and selected support files still staged by the v0.8 build. |
| History / input | [core](../core/) | Historical core artifacts, including a pinned genesis build input; not the v0.8 API entry point. |
| History / input | [input-mirror](../input-mirror/) | Lab outputs that v0.1's pins need and that had no other retrievable copy. |
| History / input | [logs](../logs/) | Historical build inputs, including upstream archives and selected model/proof artifacts. Not a production audit log. |
| History / input | [toolchain](../toolchain/) | Bundled upstream source input. The pinned executable toolchains are fetched separately. |

See [NEXT-LINE](../NEXT-LINE.md) and [the actual staged input list](../release-tools/build-tree.py).
