#!/bin/sh
# Run the tests in this tree. Needs Node 24; the backup line also needs python3 and uses the system temporary folder
# (removed afterwards), and is skipped with a SKIP line if python3 is missing. No install, no network. Exit 0 only if every line passes.
cd "$(dirname "$0")" || exit 1; fail=0; skips=0; L=v0.10/aukora-core-lite.wasm
run() { label="$1"; shift; if text=$("$@" 2>&1); then echo "PASS  $label: $(printf '%s' "$text" | tail -1)"; else fail=1; echo "FAIL  $label: $(printf '%s' "$text" | tail -2 | tr '\n' ' ')"; fi; }
echo "== the release, v0.8 =="
run "adapter, 34 end-to-end checks" node standalone/test.mjs
run "sample record replays" node examples/read-record.mjs examples/sample-record.txt --expect-head "$(cat examples/sample-record.head)"
run "reader checks the expected head" node examples/read-record-test.mjs
run "re-addressing (old forms still admitted: the open defect)" node v0.8/tests/independent/readdress.mjs v0.8/aukora-core-lite.wasm
run "bound edges" node v0.8/tests/independent/bound-edges.mjs v0.8/aukora-core-lite.wasm
echo "== the next line, v0.10: a bound record refuses the two old forms =="
run "re-addressing, closed (56 checks)" node v0.10/tests/independent/readdress.mjs $L closed
run "the same on the full core" node v0.10/tests/independent/readdress.mjs v0.10/aukora-core.wasm closed
run "bound edges" node v0.10/tests/independent/bound-edges.mjs $L
run "v0.9 and v0.10 agree on an old-start record" node v0.10/tests/independent/twin-cores.mjs v0.9/aukora-core-lite.wasm $L
run "adapter for bound records" node standalone-next/bound-test.mjs $L c924c72aec0214b59f1f9405ac2c7467b86e2d96985540570ad1896db3c25d93 closed
echo "== an effect refused when the core says no (rehearsal, lab keys) =="
run "effect sink, bound record" env BAILIFF_CORE=$L node bailiff-rehearsal/test-bound.mjs closed
run "promotion judge" env BAILIFF_CORE=$L node bailiff-rehearsal/promotion-test.mjs
run "the core's own record of its verdicts" env BAILIFF_CORE=$L node bailiff-rehearsal/own-record-test.mjs
echo "== lab pieces =="
if command -v python3 >/dev/null 2>&1; then run "backup only ever grew" node skunkworks/backup/test.mjs; else skips=$((skips+1)); echo "SKIP  backup only ever grew: needs python3"; fi
run "totals tree" node skunkworks/onion/onion-test.mjs
run "delegation receipts" node skunkworks/delegation-exhibit/test.mjs
if [ "$fail" != 0 ]; then echo "SOMETHING FAILED"; exit 1; elif [ "$skips" != 0 ]; then echo "PASS WITH SKIPS ($skips skipped)"; else echo "ALL PASS"; fi
