# v0.4 addenda from the second seat, answering the outside reviewer's five points on round 12b (22 November 2026)
Kept outside `v0.4/` on purpose: a third seat is re-running that folder and checks that its sources do not change.
These lines move into the next release's documents.

(a) **Are the regenerated chain vectors pinned?** Yes. `v0.4/vectors/segments.json.gz` is one of the 95 pins, with
    digest `b647b4b8f1ca171a071e8e8014fe54e0707a936c7f791252adc7402117d4f084` (RAN: file and pin agree). Exact
    order of events: build 2 matched the 95 pins as they then stood, INCLUDING the stale vector file; the chain test
    then failed on it; the second seat regenerated the file with the test's own `--write` step and replaced that one
    pin. So no build has yet matched the FINAL 95 pins end to end. The third seat's re-run is the first that can.
    Also true: those vectors are captured from the full Wasm and checked against the lite Wasm and against the
    test's own recomputation of the journal; they are not generated from the Lean model.
(b) **"A refused recovery frame consumes no reserve" is now a test, not only a design claim** (RAN, own frames,
    `logs/repro12/mythos-reserve.mjs`, both files, each checked against its pin before loading): at the 512-line
    limit, 40 key changes signed by a stranger: 0 admitted; then exactly 16 valid key changes admitted (the whole
    reserve, so the 40 refusals used none of it); the 17th valid one refused; speech refused; the 528-line record
    replays to the same head. This should become a shipped vector in the next release.
(c) **The unresolved bridge name** is `Record.toRecord` (already named in `v0.4/PROVED.md`). The other 39 names in
    `VERSION-AUDIT.md`'s bridge index exist as declarations. Whether it is a renamed theorem or a function that was
    listed by mistake is not determined.
(d) **How many earlier statements does the checker inside Wasm take as given in v0.4?** NOT derived. What the build
    prints (SOURCE: `logs/R12B-mythos-rebuild2.txt`): the pinned environment is 5,517,244 bytes and holds 4,143
    declarations "excluding candidate and complete Lawful theorems". The split into trusted theorem statements,
    opaque declarations and definitions is not printed (it was 506 and 21 in v0.2). Owed: the builder prints the
    split in the next round.
(e) **Classical.choice, by module** (SOURCE: the axiom lines the build prints for 265 theorems, my build 2; no
    theorem reports any axiom other than `propext`, `Quot.sound`, `Classical.choice`): 127 of the 265 use
    `Classical.choice`. Uses over printed, by module: RootFinal 31/38, Root12 22/32, Evidence11 8/11, Hybrid7 6/7,
    Core9PolicyLaws 6/6, Safe11 6/17, Ratchet11 5/6, Policy9 5/14, ChainFinal 5/5, Cell12 5/5, Upgrade6 4/4,
    Round11 4/4, Release 3/3, Upgrade7 2/2, Risk8 2/7, Upgrade9 2/2, RiskWire8 2/2, OnlyGate9 2/2, SessionFinal 2/8,
    Checker9 1/1, Core9 1/1, GrantOrigin9 1/1, Stamp8 1/2, SegmentFinal 1/8. None in Bounds12, Bound4, Bound5,
    Events4, Kira5, Stateful5 and the round-1 and round-2 laws. Limit: the build prints axioms for 265 of the 725
    theorems, so this is a sample chosen by the build scripts, not a census.

(f) **A file the build runs was missing from the source list** (found by the third seat while applying an outside
    builder's fork tool, 22 November 19:39): `v0.4/tools/watch.py` is a symbolic link to `memwatch.py`, the only
    link in the release. `v0.4/SOURCE.sha256`, written by the second seat with a files-only walk, does not list
    it, yet `tools/build.py`, `check.py`, `test-lean.py` and `bootstrap.sh` all run it and two of them take a lock
    on it. The link's target IS listed, so the bytes that run are covered; the link itself is not. For the next
    release: no links in a release folder (the fork writes a regular file), and the source list is made by a walk
    that fails on anything that is not a regular file.
