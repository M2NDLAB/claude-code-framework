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
- [x] 1. Record IMP-070 (OPEN, HIGH): multi-platform support; this note and its plan — commit: 21617c5
- [x] 2. Assessment, read-only: the field-label lines of the client project, the label table, the payload's layout across the tags, the script's design — commit: c5a1873
- [x] 3. `tools/`: the script's skeleton (arguments, `FW`/`T`, the class table) and the self-test that fails when a payload file has no class; `tools/README.md`, `CONTRIBUTING.md` — commit: b40b76a
- [x] 4. `preflight`: the Precondition's checks, the pin (an explicit error, a tag on the same commit only suggested) — commit: 11381b5
- [x] 5. `inventory`: the per-file triage and measurement, the edge-case flags, the marker delta and the §2 checklist diff, the *Upgrading* notes in order — commit: 75e7fb4
- [x] 6. `invariant`: the closed list of allowed touches on `.claude/memory/`, the LEARNINGS body normalised (titles, labels, format comments) — commit: d32ef1a
- [x] 7. `post`: METHOD files and modes at `vY`, orphans, markers, hooks; the read-only proof — commit: (this one)
- [ ] 8. The trial, read-only, on the client project's three real upgrades; what it finds is fixed — commit: —
- [ ] 9. `SETUP.md` (the box, the classes, the Precondition, Steps 0-6, edge case 3) and rule 9 (titles AND field labels) — commit: —
- [ ] 10. ONE reviewer + fixes — commit: —
- [ ] 11. `/checkpoint` — commit: —
- [ ] 12. `/integrate`: the CHANGELOG 1.4.0 entry; the two blocks — commit: —

## Assessment (task 2) — read-only measurements
- **Field labels** (the user asked for the count). The client project's `LEARNINGS.md`
  on `main`: 32 entries; 10 of them keep the labels of v1.0.0, 21 have the English ones.
  The Italian label lines are **56**: 30 in its OPEN section, 21 in Applied, 5 in
  Deferred. One of them is a lone `- Origine:` line; the others follow the template.
  Its single format comment is already the English one.
- **The label table** (the format comment of v1.0.0 against v1.1.0's):

  | Until 1.0.0 | Since 1.1.0 |
  | --- | --- |
  | `- Data: … \| Origine: …` | `- Date: … \| Origin: …` |
  | `- Origine:` (alone) | `- Origin:` |
  | `- Problema osservato:` | `- Observed problem:` |
  | `- Proposta:` | `- Proposal:` |
  | `- Beneficio atteso / rischio:` | `- Expected benefit / risk:` |
  | `- Trigger di ripresa:` | `- Resumption trigger:` |
  | `- Destinazione:` | `- Destination:` |

- **The payload's layout is stable**: the same file names from v0.2.0 to v1.3.4 (files are
  added — `harvest-framework.md` at v0.5.0, `test-hooks-install.sh` at v0.5.1, the guard,
  the snapshot and their self-tests at v1.3.0 — never renamed). A class table by path
  holds on every tag.
- **The pin.** Every `SETUP.md` since v0.6.0 prescribed `version: vX.Y.Z`; the client's
  `version: 1.2.0` is a deviation. `n/d` was the prescribed placeholder until v1.0.0
  (Italian), `n/a` since. The example lines carry trailing `# …` comments: a parser
  strips them.
- **The other formats.** §2 is found by `^## 2\.` … `^## 3\.` in both languages, with
  18 checklist items at v0.2.0, 20 at v1.0.0, 22 at v1.3.4. The *Upgrading* paragraphs
  open with `**Upgrading from …`, in releases from 1.3.0 on; older entries carry their
  migration text elsewhere. The releases between two tags come from
  `git tag --list 'v*' --sort=v:refname --merged vY --no-merged vX`.
- **The trial points** (the client project, read-only): U1 v0.2.0 → v0.5.1, from
  `b929a23` to `e3563c2` (merge `45bf4bc`); U2 v0.5.1 → v1.0.0, from `5867137` to
  `3bf0629` (merge `126bc7d`); U3 v1.0.0 → v1.2.0, from `e7c3a56` to `9b813e7` (merge
  `0725ae6`). The history is read through a bundle written by `git -C <client> bundle
  create` into `/tmp`, cloned there: nothing touches the client's repository.
- **The machine's only bash is 3.2** (`/bin/bash`): the script stays compatible — no
  associative arrays, no `mapfile`, no case conversion in expansions.

## The script's design (declared choices, inside the user's decisions)
- **Where.** `tools/upgrade-check.sh`, its self-test `tools/test-upgrade-check.sh`,
  `tools/README.md`. `tools/` is not in setup's copy list: never copied into a project,
  read at the tag `vY` by an upgrade (shipped by IMP-047's criterion). Its self-test runs
  with `bash tools/test-upgrade-check.sh`, not from the payload's `Makefile` (a line
  there would ship a framework-only target to every project, IMP-049).
- **How it runs.** From the project root, with the procedure's `FW` and `T`:
  `git -C "${FW:?}" show vY:tools/upgrade-check.sh > "${T:?}/upgrade-check.sh"`, then
  `FW="$FW" T="$T" bash "${T:?}/upgrade-check.sh" <subcommand> vX vY`. Never from the
  framework's working tree.
- **What it does.** It reads the framework only by tag (`git -C "$FW"`), the project
  read-only (`--no-optional-locks`), and writes only under `"$T/upgrade-check/"`. It
  decides nothing: each line is `OK`, `FAIL` or `CHECK` (a human reads it), and the exit
  code is 1 when any line is `FAIL`. `git merge-file -p` measures the conflicts without
  writing.
- **Subcommands.** `classes` (the class of every payload file at a tag; the table lives
  in the script and is the authority file by file), `preflight` (the Precondition, the
  pin), `inventory` (the per-file triage and measurement, the edge-case flags, the
  markers, the §2 diff, titles and labels, the *Upgrading* notes in order), `invariant`
  (the closed list of allowed touches on `.claude/memory/` against the restore point),
  `post` (METHOD files and modes at `vY`, orphans, markers, hooks, titles and labels).
- **The classes.** METHOD, HYBRID (`CLAUDE.md`, `settings.json`, `.gitignore`,
  `Makefile`, `hooks-install.sh`, the three commands customised at setup), TEMPLATE (the
  four guide READMEs; the header region of `LEARNINGS.md`), LEARNINGS, PROJECT-MEMORY
  (everything else under `.claude/memory/`, `STATE.md`, `TREE.md` and `INDEX.md`
  included — never reconciled 3-way, decision 4), GRAFT-STATE (the pin). Files are named
  one by one outside `.claude/memory/`, so a new payload file has NO class until someone
  decides it: the self-test fails on it.

