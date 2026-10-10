---
date: 2026-10-10
task: v1.4.0 — the upgrade's verification script outside the payload (IMP-037 (b)), the memory templates and the closed list of allowed touches (IMP-046), the per-file strategy driven by measurement and the marker comparison (IMP-050 points 3-4), titles AND field labels renamed (rule 9); IMP-070 recorded
branch: feat/upgrade-verification-1.4.0
status: in-progress
model: 'claude-opus-5-5'
turns: 1
tags: [session, upgrade, tools, imp, plan]
---
# Session 2026-10-10 — v1.4.0: the upgrade's verification script

> A dedicated branch from `main` at `def609d` (v1.3.4). Probes only under `/tmp`; the
> client project only read, with `git -C`. Hybrid regime: no `plans/`, this note is the
> plan-pointer. The brief is the one persisted in
> [[2026-10-10-integrate-two-blocks-1.3.4]] (*Received for later blocks*), on the
> decisions of [[2026-10-10-upgrade-safety-1.3.3]].

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 1` — the user's go-ahead for v1.4.0 (with v1.3.4 integrated: `def609d`, tag
  v1.3.4 signed; the user confirmed the reconciliation in the session note, and cleaned
  up the reviewer's scratch directory and the merged branch `feat/english-translation`).

## Plan (one commit per task)
- [ ] 1. Record IMP-070 (OPEN, HIGH): multi-platform support; this note and its plan — commit: —
- [ ] 2. Assessment, read-only: the field-label lines of the client project, the label table, the payload's layout across the tags, the script's design — commit: —
- [ ] 3. `tools/`: the script's skeleton (arguments, `FW`/`T`, the class table) and the self-test that fails when a payload file has no class; `tools/README.md`, `CONTRIBUTING.md` — commit: —
- [ ] 4. `preflight`: the Precondition's checks, the pin (an explicit error, a tag on the same commit only suggested) — commit: —
- [ ] 5. `inventory`: the per-file triage and measurement, the edge-case flags, the marker delta and the §2 checklist diff, the *Upgrading* notes in order — commit: —
- [ ] 6. `invariant`: the closed list of allowed touches on `.claude/memory/`, the LEARNINGS body normalised (titles, labels, format comments) — commit: —
- [ ] 7. `post`: METHOD files and modes at `vY`, orphans, markers, hooks; the read-only proof — commit: —
- [ ] 8. The trial, read-only, on the client project's three real upgrades; what it finds is fixed — commit: —
- [ ] 9. `SETUP.md` (the box, the classes, the Precondition, Steps 0-6, edge case 3) and rule 9 (titles AND field labels) — commit: —
- [ ] 10. ONE reviewer + fixes — commit: —
- [ ] 11. `/checkpoint` — commit: —
- [ ] 12. `/integrate`: the CHANGELOG 1.4.0 entry; the two blocks — commit: —
