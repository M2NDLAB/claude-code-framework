---
date: 2026-10-10
task: v1.4.0 — the upgrade's verification script outside the payload (IMP-037 (b)), the memory templates and the closed list of allowed touches (IMP-046), the per-file strategy driven by measurement and the marker comparison (IMP-050 points 3-4), titles AND field labels renamed (rule 9); IMP-070 recorded
branch: feat/upgrade-verification-1.4.0
status: completed
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
- [x] 7. `post`: METHOD files and modes at `vY`, orphans, markers, hooks; the read-only proof — commit: b057262
- [x] 8. The trial, read-only, on the client project's three real upgrades; what it finds is fixed — commit: 37fbc22
- [x] 9. `SETUP.md` (the box, the classes, the Precondition, Steps 0-6, edge case 3) and rule 9 (titles AND field labels) — commit: 5648df0
- [x] 10. ONE reviewer + fixes — commit: 4e5e50c
- [x] 11. `/checkpoint` — commit: 8328765
- [x] 12. `/integrate`: the CHANGELOG 1.4.0 entry; the two blocks — commit: the CHANGELOG commit (its own sha cannot be written in it)

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

## The trial on the client project's three real upgrades (task 8), read-only
The client's `main` read through `git -C <client> bundle create` into `/tmp`, cloned
there; each upgrade checked out in the throwaway clone at its starting point (for
`preflight` and `inventory`) and just before its checkpoint (for `invariant`), the
framework read by tag from this repository.

| Upgrade | What the script reports | Against the client's notes |
| --- | --- | --- |
| U3 v1.0.0 → v1.2.0 | `CLAUDE.md`: 3 conflicts, **161 of 197** lines in conflict; edge case 7 on docs/00-04, docs/06, `harvest-framework.md`, `lint-memory.md`, `reset-task.sh`; the pin `version: 1.0.0` an error, `v1.0.0` suggested; the §2 checklist re-worded as a whole; 10 titles and 56 label lines to rename. At `3a4fe9b`, before the checkpoint: the IMP entries **unchanged**; the four customised templates (the answered ADR slot, the pruned sessions README, the project's own header paragraph, the reworded format comment) shown as CHECK; the 11 FAILs are the titles and labels the upgrade kept — the rename is mandatory only from now | the same 161/197 the client measured; the files it rebuilt; the same "identical normalised body" its own script found |
| U1 v0.2.0 → v0.5.1 | edge case 6 on `hooks-install.sh`, changed in **v0.3.0 and v0.5.1**; edge case 7 on docs/03 and docs/04 (and docs/00, docs/02, `reset-task.sh`); before the checkpoint the entries unchanged | the two per-version bases the client needed; the two docs it treated as hybrids |
| U2 v0.5.1 → v1.0.0 | edge case 7 on `lint-memory.md` (and the docs); `post` shows `sessions/README.md` still differing from v1.0.0's | the file the client caught by a baseline diff; the guide README that never arrived (IMP-046) |

What the trial changed in the script (task 8's commit):
- the markers of `LEARNINGS.md` are counted in its header only — the framework's file is
  live, and its entries name the marker in prose (a false "+4 slots");
- a §2 checklist re-worded as a whole (a translation) is ONE check, not thirty;
- an upgrade's own decision record added under `decisions/` is allowed: `docs/01` records
  structural choices before the plan, and an upgrade can have them;
- fewer comment blocks than `vY`'s format is a CHECK, more is a FAIL — only an extra block
  can hide an entry;
- old-form labels are to rename only when `vY`'s format uses the new ones — before
  v1.1.0 the Italian labels WERE the format;
- `invariant` says where it runs: Step 5, before the checkpoint, whose retro may add IMP
  entries (at U3's checkpoint the client added IMP-012 to IMP-020, and a decision).

During the trial the client project's repository moved, by an integration outside this
session: one of its feature branches was merged into `main` and pushed. This session
only read it (`git -C`) and wrote the bundle into `/tmp`, removed afterwards.

## Writing the procedure (task 9) — one more finding
Rehearsing the header recipe of `LEARNINGS.md` on a copy of the client's file showed that
the header region includes the frontmatter, whose `updated:` is the project's own date —
a VALUE, not the template. The script blanks that line in its header comparisons (it
would otherwise report a template difference at every upgrade), and the procedure says
the date stays the project's.

## Review (task 10) — one reviewer, dispositions
One independent reviewer over `def609d..bb47cda` and the CHANGELOG draft, about nineteen
minutes; both repositories identical before and after. Verdict: not ready — two HIGH,
seven MEDIUM, fifteen LOW. Both self-tests had passed: none of them could see these.

| Finding | Severity | Disposition |
| --- | --- | --- |
| H1 — `labels_renamed`: `grep -q` on a pipe under `pipefail`; past the pipe's buffer `git show` dies of SIGPIPE (141), so for a `vY` from v1.3.0 on the label rename was never checked | HIGH | REPRODUCED under bash (141 at v1.3.4 and HEAD, 0 at v1.2.0). FIXED: the whole stream is read. RED then GREEN: the fixture's `vY` LEARNINGS now exceeds 128 KB, and `inventory` stopped asking for the rename on the old script |
| H2 — the pointer check parsed `git diff` under the user's configuration: with `color.ui=always` or a `diff.external`, no line starts with `+`/`-`, every note edit passed | HIGH | REPRODUCED (10 lines plain, 0 with either setting). FIXED: every git call runs with colour off, no external diff, unquoted paths and the default conflict style; the self-test runs a violation under a hostile config |
| M1 — the pointer check accepted any line carrying a pointer | MEDIUM | FIXED: per hunk, as many lines removed as added, each pair equal once the pointers are masked; a fact changed on a pointer line and a pointer line deleted now fail. Building the case found a second bug: an emptied line was not reported (an empty string is false in awk) — fixed |
| M2 — STATE, TREE and INDEX were only INFO at Step 5 | MEDIUM | FIXED: before the checkpoint they too change only by pointer repairs and the renamed titles and labels; STATE overwritten by the template fails |
| M3 — a project's own shortened title, renamed as SETUP says, failed the entries comparison | MEDIUM | FIXED: the titles become one placeholder in that comparison (the format check covers them); an entry moved across sections still fails |
| M4 — a slot removed by `vY` made the "slot opened again" test fail falsely | MEDIUM | FIXED: compared against max(0, added) |
| M5 — the restore point was never validated: HEAD made everything pass on nothing | MEDIUM | FIXED: an ancestor of HEAD, a payload that differs since, its pin read vX (a CHECK otherwise); Step 1 records its sha in the session note |
| M6 — `post` showed a file left at vX like a reconciled one | MEDIUM | FIXED: a METHOD, TEMPLATE or HYBRID file still at `vX` when `vY` changed it fails |
| M7 — the note named a branch of the client project, revealing its domain, in a commit not yet pushed | MEDIUM | FIXED in history: the local feature branch was rebased to make the sentence generic in the commit that introduced it (task 8 is now `37fbc22`, task 9 `5648df0`); the published history never carried it |
| L1-L3 — a bare FW; the copy that runs only a CHECK; T unchecked | LOW | FIXED: a bare FW has no working tree to run from; the wrong copy is a FAIL; T must be absolute and outside both repositories |
| L4-L9 — comments matched anywhere; a half-renamed `\| Origine:`; the obsolete Applied format comment; edge case 6 on the live LEARNINGS; the §2 items cut at their first line; markers counted per line | LOW | FIXED |
| L10, L14 — the header recipe's exit status; the format comment "by hand" against the decision | LOW | FIXED: the recipe chains `cat` and `awk`; the format comment is reconciled 3-way like the header, with a recipe rehearsed on a copy of the client's file (its rewording kept) |
| L11 — conflict markers left by a merge | LOW | FIXED: `post` fails on them, the LEARNINGS header included |
| L12, L13 — the read-only proof blind to the index, the config and the hooks, and to a run that died; missing cases | LOW | FIXED: fingerprints of the three, each run's summary line asserted; the cases added (an entry deleted, added, moved; a hostile config; a large `vY`) |
| L15 — IMP-070 without a `Proposal:` label | LOW | FIXED |
| I1-I4 — non-ASCII paths quoted; a CRLF pin; renames over the live notes; a long line, CASE A's class list | INFO | FIXED |

After the fixes, the trial was run again on two of the client's upgrades: the same
verdicts, with one more CHECK where it belongs (the restore point's pin lacks its `v`).

## Done
- `21617c5` IMP-070 and the plan; `c5a1873` the measurements and the design; `b40b76a`
  the script's skeleton and class table; `11381b5` `preflight`; `75e7fb4` `inventory`;
  `d32ef1a` `invariant`; `b057262` `post` and the read-only proof; `37fbc22` the trial's
  fixes; `5648df0` `SETUP.md` and rule 9; `4e5e50c` the review applied; this checkpoint;
  the CHANGELOG 1.4.0 entry at `/integrate`.
- LEARNINGS: IMP-037 (option b), IMP-046 and IMP-050 (points 3-4) Applied — IMP-050 is
  closed in all its points; IMP-048 annotated (titles and labels applied, the discipline
  open); IMP-070 and IMP-068 open.
- Verification: `bash tools/test-upgrade-check.sh` six of six PASS and `make test-scripts`
  five of five after every task; the trial on three real upgrades, run twice.
- Edits to `.claude/` went through shell one-offs (Python), as in v1.3.3 and v1.3.4.

## Retro
Candidate lessons — offered, not recorded (the user listed this block's IMPs):
- **A fixture at toy size hides size-dependent bugs.** `grep -q` under `pipefail` failed
  only past a pipe's buffer: the self-test's tiny LEARNINGS passed, the framework's own
  132 KB file did not. A fixture should carry at least one artefact of real size.
- **A sterile git configuration in a self-test hides the user's.** The tests run with
  `GIT_CONFIG_GLOBAL=/dev/null` for good reasons, and so never saw `color.ui=always` or
  an external diff driver. A script that parses git's output needs one run under a
  hostile configuration.
- **The failure paths again, for the third release in a row** — v1.3.3's restore,
  v1.3.4's block 1, v1.4.0's emptied line and wrong restore point — all found by the
  reviewer, none by the author's rehearsal. The candidate of
  [[2026-10-10-integrate-two-blocks-1.3.4]] now has three cases.

## Follow-up
- `/integrate`: v1.4.0, a MINOR (`feat` commits; `tools/` and `SETUP.md` reach the
  projects at the tag, IMP-047's criterion); merge, tag and push are the user's.
- Next: v1.4.1 — the payload's purity (IMP-049) and the mechanical documentation checks
  (IMP-068), a PATCH; then v1.5.0, multi-platform (IMP-070).
- The client project's upgrade, at the end of the cycle, runs this script from its first
  step: `preflight` will stop on its pin (`version: 1.2.0`, without the `v`).

