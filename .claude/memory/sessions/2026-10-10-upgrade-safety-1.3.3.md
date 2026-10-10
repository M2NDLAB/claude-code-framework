---
date: 2026-10-10
task: the upgrade block — phase 1 (read-only analysis of IMP-050 points 3-5, IMP-046, IMP-037, IMP-049 and the v1.3.x migrations, with the user's decisions) and v1.3.3, the upgrade's safety fixes
branch: fix/upgrade-safety-1.3.3
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, upgrade, imp, plan]
---
# Session 2026-10-10 — the upgrade block: phase 1 and v1.3.3

> Phase 1 (analysis only: no branch, no write in either repository) on `main` at
> `5b21770` (v1.3.2); then v1.3.3 on this branch, from the same commit. Probes only under
> `/tmp`; the client project read only with `git -C`. Hybrid regime: no `plans/`, this
> note is the plan-pointer. The phase-1 analysis is condensed here because its working
> copy lived under `/tmp`.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session; phase 1 also ran four delegated analysts
  in one workflow (no stall, about eight minutes).
- `turns: 2` — the phase-1 request; the decisions with the v1.3.3 go-ahead.

## Plan (one commit per task)
- [x] 1. Record IMP-068 (OPEN, a list that declares itself complete), the moved-answer note in IMP-048, the phase-1 decisions (this note, a dated line in each IMP they decide) — commit: 90aa776
- [x] 2. `hooks-install.sh` resolves the hooks directory with `--git-common-dir` (a linked worktree, a subdirectory, outside a repository); self-test case 3, RED then GREEN — commit: 9cf7cb3
- [x] 3. Upgrade Step 4: check that every generated hook is installed; the hooks directory is shared by the worktrees — commit: 331f390
- [x] 4. Upgrade Step 1 photographs the hooks; edge case 4 restores the photograph (the destructive lines in their own block) — commit: a3a9836
- [x] 5. Upgrade Step 2: the *Upgrading* notes between `vX` and `vY` become a checklist (different topics add up; on the same topic the latest wins) — commit: 3ef8915
- [x] 6. Upgrade Step 3: the `Makefile` through the 3-way, only `.gitignore` additive; edge case 8, a slot that moves to another file — commit: 2c6dd7f
- [x] 7. Section titles: rule 9 separates the memory's format from its content; edge case 3 (b) by set comparison, the rename mandatory, the project's tests in the same commit, the table with the short forms — commit: 77dc84e
- [x] 8. Prerequisites (git 2.31, Node.js 14.13); the upgrade's execution boundary (delegated agents read-only on git); Step 4, `settings.json` and the guard's self-test check each other — commit: b511da2
- [x] 9. IMP-047: a tag when a change reaches what projects receive; `integrate.md` and `docs/04` aligned; `CONTRIBUTING.md` names the framework's shipped files — commit: cd6e820
- [x] 10. ONE reviewer + fixes — commit: (this one)
- [ ] 11. `/checkpoint` — commit: —
- [ ] 12. `/integrate`: the CHANGELOG 1.3.3 entry — commit: —

## Phase 1 — findings (framework `main`, `5b21770`; the client project's `main` only)
- **IMP-050 point 3 — open.** Step 3 picks the strategy by file NAME ("additive union" for
  `.gitignore` and `Makefile`), while CHANGELOG [1.3.2] tells upgraders the `Makefile` is
  "not additive this time": procedure and release notes disagree on the same file. A real
  `git merge-file` of the client's next hop (base v1.2.0, theirs v1.3.2, mine its `main`):
  `Makefile`, `.claude/settings.json`, `CLAUDE.md`, `docs/04` clean; `scripts/reset-task.sh`
  1 conflict, 21 lines. The near-total conflicts of the third upgrade belonged to the
  translation release; this hop is surgical — but the `Makefile` merges clean and WRONG
  (point 4).
- **IMP-050 point 4 — open, with a new variant: a slot that moves.** v1.3.2 moved the
  protected branches from `reset-task.sh` to the `Makefile`. The clean 3-way lands the
  default `PROTECTED_BRANCHES = main develop`, while the client's answer (`main dev`) sits
  in the `reset-task.sh` conflict: its `dev` branch would lose the protection. Nothing in
  `SETUP.md` says the answer lives in the old file; edge case 7 ("treat it as hybrid")
  points the other way.
- **IMP-050 point 5 — open, worse since v1.3.0.** Measured in `/tmp`: v1.3.2's script run
  from a linked worktree fails (`mkdir: …/.git: Not a directory`, rc 1); with
  `--path-format=absolute --git-common-dir` it installs the three hooks into the common
  directory. `--git-path hooks` is relative in a main worktree: rejected. Inferred from the
  code, not measured: Step 4's proofs exercise only `pre-commit` and `commit-msg`, so a
  missing `pre-push` passes for green; rolling back by re-running `vX`'s script leaves
  `vY`'s `pre-push` when `vX` < 1.3.0; `FORCE_OVERWRITE=1` overwrites the pre-upgrade
  `.bak`; Step 1 never photographs the hooks.
- **IMP-046 — open.** The contradiction is still in the text (the guide READMEs METHOD;
  Step 2 excludes `memory/`; Step 5 demands an empty diff; `decisions/README.md` in two
  classes), with a third side: rule 7 writes the upgrade's own plan into `memory/plans/`.
  The client customised three of these files (the `decisions/` slot answered,
  `sessions/README.md` pruned, a project paragraph in the LEARNINGS header): a wholesale
  overwrite would destroy real data. Real `git merge-file`: the slot edited by `vY` gives
  1 conflict, an edit elsewhere merges clean, `vY` pruned as the client pruned merges clean
  and identical to the client's file. Not blocking the next hop (no memory template
  changed from v1.2.0 to v1.3.2). The client's IMP-020 invariant script was never
  committed: lost.
- **IMP-037 — the count trigger fired** (three real upgrades, all of the same project).
  Across them the judgement differed every time; the mechanics were the same (diff against
  `vX` by tag, edge-7 detection, the memory invariant). The third rebuilt them with about
  forty delegated agents and a script that was then lost. `SETUP.md` changed in 7 of the
  11 releases since the procedure exists.
- **IMP-049 — the payload's impurity grows.** v1.2.0 → v1.3.2: pointers to files outside
  the payload 13 → 14 lines (9 → 10 files); framework IMP numbers 10 → 23 occurrences
  (4 → 9 files), all thirteen new ones from v1.3.0. IMP-009 and IMP-024 already collide
  with the client's numbering, IMP-032 collides with its next entry. Every METHOD file the
  client prunes becomes a permanent hybrid.
- **The v1.3.0-v1.3.2 migrations live in the CHANGELOG, not in the procedure.** Step 2
  reads the CHANGELOG as an index only; the *Upgrading* notes are per hop and contradict
  each other across a jump (1.3.0 "the guard first", 1.3.1 "any order"). The title table
  is only in [1.3.2] and misses the client's short forms (`## Rimandate`, `## Rifiutate`);
  edge case 3 (b) fires only "if `vY` renames". The `Makefile` REPLACE is only in the
  CHANGELOG while Step 3 says union (measured: the script runs twice, or `make` overrides
  silently). The coupling of `settings.json` and the guard's self-test is enforced by
  `make test-scripts` and explained nowhere; Node.js 14.13 is not in `SETUP.md` §0; the
  upgrade's execution boundary does not say delegated agents are read-only on git.
- Coverage gaps, declared: not run — the full dry run of the client's next upgrade, the
  rollback experiments, the coupled-test failure text, the inventory back-test on the
  first two upgrades, the class coverage across every tag. The analysts used `diff3`
  (the guard refuses `git merge-file` to delegated agents); the main session re-ran the
  merges that matter with `git merge-file`. One analyst listed the directory of another
  session's scratchpad once, by mistake, and opened no file in it.

## The user's decisions (2026-10-10)
- **The split: v1.3.3 → v1.4.0 → v1.4.1.** v1.3.3 (this branch): the hooks fix and its
  self-test, Step 4's hook check, Step 1's photograph and edge case 4, the `Makefile` 3-way,
  the moved slot, the *Upgrading* notes as a checklist, the prerequisites and the execution
  boundary. v1.4.0: IMP-046 with the closed list of allowed touches, the upgrade
  verification script outside the payload, the per-file strategy and the marker delta in
  `SETUP.md`, IMP-037 re-scoped, the "No automation" box updated. v1.4.1: the payload
  pruning (IMP-049), the purity check and the complete-list check at the end of the cycle.
- **Context.** The client's upgrade will NOT follow v1.3.3: it comes at the end of the
  cycle, in one hop to the final version. The full dry run on a throwaway clone happens
  then, as its acceptance test — not now.
- **Correction — the *Upgrading* notes.** "The latest wins" holds ONLY for notes on the
  SAME topic (the order of the guard and `settings.json` between 1.3.0 and 1.3.1).
  Migrations on DIFFERENT topics ADD UP: 1.3.2's title rename applies even if no later
  note mentions it. Step 2 says so.
1. **IMP-037 → option (b), yes.** The "No automation" box is updated (Level 2, in v1.4.0).
   The script reads the framework by tag with `git -C "${FW:?}"`: the "no cross-repo git"
   note was about writes and `FW`'s working tree, not reads by tag (the v1.2.1 rule). It
   lives OUTSIDE the payload, is never copied into the project, and runs in its version AT
   the tag `vY`, never from the framework's working tree. Option (a) stays deferred, with
   a new trigger: the first upgrade of a second project.
2. **Titles → the rename is MANDATORY, no map** (against the recommendation). A map is a
   configurable legacy reader that every present and future command would have to
   consult: permanent complexity against a one-off cost. Rule 9 is about the memory's
   CONTENT; the section titles the commands look up are FORMAT, and format is method —
   written plainly in rule 9, because the ambiguity is real. The project's tests that cite
   the titles are updated in the same upgrade commit (the project's responsibility). The
   table includes the short forms (`## Rimandate`).
3. **A "Slots changed" field in the CHANGELOG → no.** The script derives changed or moved
   slots mechanically, comparing the markers and the §2 checklist between the tags; a
   hand-written field that can diverge is the class of C11/C12. A slot that changes file
   is flagged by the script; if the answer must move, it is a migration and goes into the
   *Upgrading* note.
4. **`STATE.md`, `TREE.md`, `INDEX.md` are NOT memory templates:** in a project they are
   compiled memory, never reconciled 3-way; a change to their format arrives only as a
   declared migration.
5. **IMP numbers → out of all the payload's text, the scripts' header comments included;**
   the why in prose, the provenance in the CHANGELOG, `LEARNINGS.md` and the commits.
   `docs/04`'s "as this framework is": generalise it, or move it to `CONTRIBUTING.md` if
   only the framework needs it.
6. **The pin → an explicit error with the correcting instruction,** no silent
   normalisation. If a tag sits on the pinned commit the script may SUGGEST it, never
   apply it.
7. **IMP-047 → the criterion "does it change the payload?"** If yes, it is a release with a
   tag (in a method framework the documentation is the product); if it touches only the
   framework's memory or files outside the payload, no tag. So v1.4.1 is a PATCH. Record
   the decision and close the contradiction between `integrate.md` and `docs/04` — done in
   this release (task 9), whose own bump the criterion already governs.
- **Go-ahead for v1.3.3:** the first commit carries the two recordings asked for before
  phase 1 (IMP-068; the note in IMP-048); a dedicated branch from `main`; probes only in
  `/tmp`; the client only read, with `git -C`; ONE reviewer; `/checkpoint` and the
  `/integrate` block; merge, tag and push are the user's.

## Review (task 10) — one reviewer, dispositions
One independent reviewer over `5b21770..cd6e820` and the CHANGELOG draft (kept outside the
repository until task 12), about fifteen minutes. It wrote nothing in either repository:
both snapshots identical before and after. Verdict: fit to merge after the six MEDIUM
items; nothing HIGH. Every snippet changed below was then extracted from `SETUP.md` and
run as written in throwaway repositories under `/tmp` (bash and zsh for the Step 4 loop).

| Finding | Severity | Disposition |
| --- | --- | --- |
| M1 — the restore's `rm` stopped on a subdirectory of the hooks directory, after deleting the hooks: no hooks left, nothing restored | MEDIUM | FIXED: the installed hooks are moved aside into `T` and the photograph copied back; rehearsed with a subdirectory and a relative symlink |
| M2 — a failed photograph still created its directory, so the restore wiped the hooks and said "restored"; a second Step 1 merged `vY`'s hooks into the photograph | MEDIUM | FIXED: a `.partial` name renamed only on success, never over an existing photograph, a success line |
| M3 — "Node.js 14.13 … used by commitlint" is wrong: npx fetches commitlint's latest, whose 21.x line declares Node 22.12 (verified in the local npx cache); the guard's `node:` imports need 14.13.1 | MEDIUM | FIXED: §0 names the two floors; `scripts/README.md` says 14.13.1 |
| M4 — the presence check was said to catch a forgotten re-run; it catches a missing or foreign hook only | MEDIUM | FIXED: the wording of Step 4 and of edge case 4 (a) |
| M5 — the no-photograph fallback would delete working hooks that Step 4 rewrote unchanged | MEDIUM | FIXED: hook by hook — a WARNING's `.bak` back, a new hook removed, the rest left |
| M6 — `CONTRIBUTING.md` claimed upgrades read `SETUP.md` by tag, which `SETUP.md` never says, and stated as decided what the note calls an interpretation | MEDIUM | FIXED in part: the reason is now that an upgrade targets a tag (the script runs at `vY` by decision 1). That `SETUP.md` and the script count as shipped stays an interpretation for the user to confirm before the merge — recorded in IMP-047 |
| L1 — `CONTRIBUTING.md` and `docs/04` gave the bump by different criteria | LOW | FIXED: `CONTRIBUTING.md` points to `docs/04`. v1.3.3 stays a PATCH, as the user's split decided |
| L2 — `diff -r` follows symlinks | LOW | FIXED: `--no-dereference` |
| L3 — rule 9 said "the upgrade that changes them", edge case 3 (b) "every upgrade" | LOW | FIXED in `CLAUDE.md` and the draft |
| L4 — "the SAME commit" ambiguous next to the separate `docs(memory)` commit | LOW | FIXED: the same commit as the rename |
| L5 — no top-level check (a copy inside another working tree installs into it); a missing git misreported | LOW | FIXED: both checks, the hooks directory in the OK line; case 3d RED on `9cf7cb3` (the enclosing repository got the hooks), GREEN now |
| L6 — IMP-037 moved whole, its deferred half out of the *Deferred* section | LOW | FIXED: split into option (b), open, and option (a), deferred with the new trigger |
| L7, L8, L9 — the self-test row of `scripts/README.md`; the draft's `REPO_ROOT` line and "moves"; `.git/hooks/pre-push.local` from a linked worktree | LOW | FIXED: the row; the draft; the refusal names the absolute path, Step 4 says "the same hooks directory" |
| I1 — case 3b is a regression guard, not a RED proof | INFO | As the test says; no change |
| I2 — the Step 4 loop hard-coded the hook list (IMP-068's shape) | INFO | ADOPTED: the list is read from the script's loop, with a line that stops on an empty list |
| I3 — `SECURITY.md`, `README.md`, "memory TEMPLATES" in `CONTRIBUTING.md` | INFO | FIXED wording |
| I5, I6 — `T` under `/tmp`; the 1.3.3 rule-9 note anchors on lines 1.3.2 added | INFO | ADOPTED |

## Open points — recorded, not decided
- **Field labels.** `/harvest-framework` reads the IMP field labels by name (Origin,
  Observed problem, Proposal, Benefit/risk). By decision 2's principle they are format;
  v1.3.3 applies the decision as given, to the section titles. The client's entries use
  Italian labels. To settle before v1.4.0, whose script could flag them.
- **What "the payload" means for decision 7 — an interpretation, to confirm.** Read
  literally, "files outside the payload → no tag" leaves `SETUP.md` and v1.4.0's
  verification script untagged: neither is copied into a project. But the upgrade reads
  both AT the tag `vY`, so a change that cut no tag would never reach an upgrade, and
  v1.4.0 — decided as a MINOR — could not be released. Task 9 counts them as shipped
  (`CONTRIBUTING.md`, *What this framework ships*).
