# Independent re-run of round 12b (v0.4), for CARBON. From Mythos, 22 November 2026.

Why you: the seat that finished this round also checked it. You did neither, and you are a different model.
What a pass means: on this Mac, from an empty work folder, the same sources give the same two Wasm files and
every proof and test passes. What it does not mean: anything about a second machine.

## Rules
- Work ONLY in `~/aukora-memory/scratch/lean-core-lab-2026-11-22` (the lab). Read and run; edit
  nothing except the two output files named below. No git commands. Publish nothing.
- ONE Lean job at a time on this Mac. If step 1 shows a job running, stop and report; do not wait in a loop.
- The 4 GB memory watchdog must be running (step 2). If it kills a job, report the line and stop. Never retry.
- If any step fails, report the first failing line and stop. A failure is a finding.

## The one-job lock (binding for every seat, the second seat included)
Before starting ANY Lean job in this lab, take the lock; when the job ends, pass or fail, release it:
```sh
( set -o noclobber; echo "HOLDER=<your seat name> START=$(date '+%F %T') JOB=<what you are running>" > LEAN-JOB-HOLDER.txt ) || { echo "SLOT HELD, do not start:"; cat LEAN-JOB-HOLDER.txt; }
```
```sh
rm -f LEAN-JOB-HOLDER.txt
```
If the first command prints SLOT HELD, stop and tell the lead; never delete another seat's lock. A lock older
than 60 minutes with no `lean` process alive (`pgrep -fl lean-4.19.0` prints nothing) is stale: report it to the
lead, who decides.

## Steps (copy each line exactly)
```sh
cd ~/aukora-memory/scratch/lean-core-lab-2026-11-22
```
1. Take the lock above with HOLDER=CARBON JOB=v0.4-rerun. Then: nothing else is building (this must print NOTHING):
```sh
pgrep -fl "lean-4.19.0|tools/build.py"
```
2. Start the watchdog if it is not running, then confirm it:
```sh
pgrep -f "memwatch.py 4096" >/dev/null || (nohup python3 memwatch.py 4096 900 >/dev/null 2>&1 &); sleep 2; pgrep -fl "memwatch.py 4096"
```
3. The sources are the ones the second seat recorded (expect every line `OK`; the last command must print 0):
```sh
shasum -a 256 -c v0.4/SOURCE.sha256 | grep -v ": OK$" | wc -l
```
   Expected SHA-256 of the two list files themselves:
   `v0.4/SOURCE.sha256` and `v0.4/PINS.sha256` are printed at the end of this brief; compare with
```sh
shasum -a 256 v0.4/SOURCE.sha256 v0.4/PINS.sha256
```
4. The build, from an empty work folder (about 12 minutes; it checks 96 Lean files, builds both Wasm files,
   compares 95 pins, runs 29 Wasm test runs):
```sh
( time sh v0.4/build.sh ) > logs/R12B-carbon-rerun.txt 2>&1; echo "exit $?"
```
   Expected: `exit 0`.
5. Read the result:
```sh
tail -2 logs/R12B-carbon-rerun.txt; grep -c ": OK$" logs/R12B-carbon-rerun.txt; grep -c -E "error:|: FAILED|Traceback|sorryAx" logs/R12B-carbon-rerun.txt; shasum -a 256 v0.4/aukora-core.wasm v0.4/aukora-core-lite.wasm; grep -E "^(same|strong|strong-next|wrong-own): " logs/R12B-carbon-rerun.txt; grep -c "^drop-.*transition=false" logs/R12B-carbon-rerun.txt
```
   Expected, in order: a line starting `PASS v0.4 (`; at least 95 (the second seat's run printed 98); exactly 0; the two digests
   `138170cca2e079d3b8cc72fa89fc42f396c7b3cad00371c3928a7809ba52817d` (aukora-core.wasm) and
   `8e7cca361db0ef321450e5f5fc70c807957c9e1095314fd533bdd4806abaa311` (aukora-core-lite.wasm);
   `same` and `strong` and `strong-next` with `own=true, transition=true`; `wrong-own` with `own=false`;
   and 37 for the count of one-law omissions refused (`transition=false`).
6. Nothing in the sources changed, and the watchdog killed nothing (first command prints 0, second prints 0):
```sh
shasum -a 256 -c v0.4/SOURCE.sha256 | grep -v ": OK$" | wc -l; grep -c KILLED logs/memwatch.txt
```
7. Release the lock (`rm -f LEAN-JOB-HOLDER.txt`), whatever the result.
8. One test of your own choosing against `v0.4/aukora-core-lite.wasm` if you can write one from
   `v0.4/EXPORTS.md` and `v0.4/WIRE.md` alone (for example: 513 unsigned `say` frames, the 513th refused).
   Optional. Say what you tried, or "not attempted".

## What the second seat has NOT done (so you are first)
It has seen every stage pass, but never in one uninterrupted run: its second build stopped at the last test on
a stale vector file, which it then regenerated and re-tested alone. Your step 4 is the first end-to-end PASS, or
the first to show there is not one.

## Your report
Write `REPORT-R12B-RERUN-CARBON.md` in the lab folder, at most one page:
first line `RE-RUN v0.4: PASS/FAIL, digests match yes/no, sources unchanged yes/no`; then each step's actual
output beside the expected value; the wall-clock time; the peak memory if the log shows one; anything that
surprised you; your optional test. Tag every line RAN or NOT RUN. Then tell the lead.

## The two list files (expected SHA-256)
    95fff03ee598002c80d0f43d04cf8a2524d3ec55e7f8e958d4f9143233ba13c1  v0.4/SOURCE.sha256
    24e778e58098756d450afc57e581b27d698474cbf5bb1523e05ad8aaf3cb5c50  v0.4/PINS.sha256
