# BRIEF, round 14, for ASTRA 6.2 (from Mythos): changing the owner's keys without a window

MEMORY RULE (binding): every Lean command runs `-j1 -M 4096`; (CORRECTION, 22 Nov 21:00: this toolchain REJECTS a bare `lean -M`; the option exists only through a release's own tools, which load its `MemoryOption` plugin, as `v0.4/tools/*.py` do. A bare `lean` command must run under `memwatch.py`.) ONE Lean process at a time; never release a build
lock while its compiler is alive; `memwatch.py` kills any lab toolchain process above 4 GB. A proof that needs more
is a FINDING, not something to retry larger. Never retry a killed job unchanged.

Limits: as in round 13 (work only here; ignore `_export/` and `standalone/`; no downloads, wrappers or windows;
6-minute stop; CHECKED only for kernel-accepted statements; clean up; report size). About 150 minutes. Order A, B,
C. Build on the newest release folder in a NEW folder. Read the newest reports and `STANDARDS-ALIGNMENT.md`
sections D, E, G first (REPORTED facts).

## A. The key change, hardened
Today a rebind is signed by the OLD keys only (`WIRE.md`, "Rebind"). Three holes, three fixes, each with its law:
1. POSSESSION: the new keys must sign the rebind too (both new signatures over the same message), so a typo or a
   key nobody holds cannot become the owner. Law: after any accepted rebind, signatures by the new keys over that
   rebind exist in the record.
2. PRE-COMMITMENT: genesis and every rebind commit to SHA-256 of the NEXT key set. A rebind must reveal keys
   matching the standing commitment. Law: no accepted rebind installs keys that do not match the commitment made
   before it. So a thief of today's keys cannot name the successor.
3. THE WINDOW BETWEEN THEM (an outside reviewer's attack, accepted): a pre-committed next key is a liability held
   early. If it was made on a compromised device, its thief inherits the chain. So: the CURRENT keys can REPLACE
   the standing commitment (a signed "recommit" naming a new digest), without revealing either key set; and a
   rebind is valid only against the LATEST commitment. Law: after a recommit, a rebind to the previously committed
   keys is refused. State plainly what this does not solve: a thief who holds today's keys AND acts first can
   recommit; that race is exactly what a witness or a delay is for. Offer the smallest honest delay rule (a
   recommit takes effect only after k further accepted lines, during which the old commitment still works and a
   SECOND recommit by the same keys cancels the first) and prove what it buys; build it only if it is small.
4. ORDER: two valid key events racing for the same position. Show that the record admits exactly one (the parent
   and sequence in the signed bytes decide), that the generation is part of the signed bytes of every owner
   operation, and that replay can never produce two heads from one record. Vectors for each.
5. NO LOCKOUT still holds: H5 for clear and rebind with the new rules; and say whether a halted machine can
   recommit (it should).

## B. The update-framework attack list against the upgrade gate
For each named attack in the alignment file's section D (rollback, freeze, mix-and-match, plus arbitrary-package,
endless-data, wrong-target and key-compromise as that framework's own threat list names them: use its text if it
is in the file, otherwise the standard meanings): a short paragraph: does the gate already stop it (cite the
theorem), partly (say which half), or not (propose the smallest change). Build the two smallest fixes found.
Expected finding to confirm or deny: FREEZE is not stopped (nothing forces a core to ever see a newer law set or
head), and is a witness's job.

## C. One composite signature (only if A and B are done)
Assess replacing "two independent signatures over the same bytes" by the composite construction in the alignment
file's section G (a labelled pre-hash so neither half verifies alone as an ordinary signature of the message).
Say exactly what attack the current scheme allows that the composite does not (a half lifted into another
protocol), whether it changes any law, and what it costs in bytes. Build it behind a new wire version only if it
is small; otherwise write the decision and stop.

## Deliverables
`REPORT-R14.md` (two pages at most; first line: `KEY CHANGE: possession yes/no, pre-commitment yes/no, recommit
yes/no, laws n` and `UPDATE ATTACKS: s stopped, p partly, n not` and `COMPOSITE: built/decided`),
`logs/R14-CHECKS.txt`, the new release folder. Keep failures.
