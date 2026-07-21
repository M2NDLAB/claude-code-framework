---
date: 2026-07-14
task: registration of IMP-027..030 from the lessons of the first real graft (brownfield)
branch: chore/imp-innesto-brownfield
status: completed
tags: [session, improvement, brownfield]
---
# Session 2026-07-14 — Registration of IMPs from the first brownfield graft

## Context
First real graft of the framework onto an existing project (brew-manager, a
shell/zsh tool, brownfield): the friction was documented live in the graft note
of the host project. This session REGISTERS the lessons as IMPs (rule 6 of
CLAUDE.md: changes to rules/docs are proposed, and applied only after approval).
No rules/docs/script file touched: only LEARNINGS.md and this note.

## Done
- Verified the 10 friction points of the graft note against the REAL files of the
  framework (docs/02: never act on memory alone) — multi-agent read-only
  verification, one verifier per friction point with file:line evidence; the 2
  verifications that died to the session limit (F6 "pre-existing .claude/" and the
  sweep) redone by hand with grep. Outcome: ALL confirmed; none already covered in
  full by existing rules.
- Registered 4 OPEN IMPs in [[LEARNINGS]] (grouped, not 1:1 with the friction
  points): IMP-027 brownfield setup path (file collisions, an assessment that
  populates memory, CASE A/B criterion for a pre-existing `.claude/`,
  doc-vs-reality divergences of the host; `graft.sh` option presented with both
  sides, NOT decided); IMP-028 inherited git hygiene (lightweight tags, one-off
  gitleaks detect over the history, dormant branch topology, pre-existing hooks);
  IMP-029 language coexistence (on its own: it applies to greenfield too); IMP-030
  filling in the [TO BE DEFINED AT SETUP] markers assisted by Code (on its own: not
  brownfield).
- Hooks into existing rules declared instead of duplicated: IMP-011
  (assessment→proposal→decision pattern, to be promoted to a setup step),
  IMP-008 (parametric branch roles: the mechanics are there, the guidance for the
  choice is missing), the gitleaks baseline of docs/03 (the one-off detect is its
  completion, not a new rule), IMP-010 (hygiene of created tags ≠ inherited tags).

## Non-obvious discoveries from the verification (beyond the graft note)
1. `/integrate` on lightweight tags does NOT break: it uses `git describe --tags`,
   which accepts them silently (the "annotated because git describe uses them"
   rationale of docs/04 holds for `git describe` WITHOUT `--tags`). The degradation
   is silent, which is worse than an error.
2. docs/06 LEVEL 1 read literally prescribes the OPPOSITE of the right behaviour at
   graft time: "align the doc to reality... apply directly" does not distinguish the
   METHOD doc from the HOST doc (which is to be registered as debt, not corrected
   ex officio).
3. Hooks + husky: with `core.hooksPath` active the framework hooks would end up in
   `.git/hooks`, which git ignores — installed but inert. And the comment in
   hooks-install.sh l.6 promises less than what the script does (it overwrites ANY
   hook, not only its own).

## Problems encountered → cause → solution
1. Verification workflow failed on the first run → the `args` were not reaching the
   script (`args.frictions` undefined) → friction points embedded into the script
   and relaunched.
2. Two verifications out of 11 died halfway → session limit of the harness →
   completed by hand with grep at the reset (the 9 results that had arrived stayed
   valid).

## Proposals
- IMP-027, IMP-028, IMP-029, IMP-030 in [[LEARNINGS]] — OPEN, awaiting user
  decision.

## Follow-up
- User decisions on the 4 IMPs → application only afterwards (one commit per IMP,
  according to docs/06).
- Merge of this branch into `main`: a human action via the `/integrate` block
  (no tag: memory only → "no bump").

## APPLICATION (same date, after the user decisions)
Decisions: APPROVED 027 (without `graft.sh` → Deferred with the trigger "after 2-3
real grafts"), 028 (the two serious points b/d in separate curated commits), 029,
030. Constraint on 028(a): the correction of the docs/04 rationale is DESCRIPTIVE,
no new obligation. The pre-application completeness guard (S1-S3) passed with one
addition: the correction of the docs/04 rationale made explicit in proposal (a) of
IMP-028 before applying.

Application commits (the "one commit per IMP" plan of the Follow-up above was
refined by the decisions: 028 in three commits + one fix from the review):
- 051d02c `docs(security)` IMP-028b — one-off gitleaks detect (docs/03 + SETUP s.3)
- 1103ffb `fix(scripts)` IMP-028d — pre-existing hook guards + core.hooksPath
- ff3c2bc `feat(setup)` IMP-027 — brownfield section + docs/06 L1 perimeter +
  STATE template + README pointer
- 4cd4363 `fix(git)` IMP-028a/c — SemVer base guard in /integrate + docs/04
  rationale + inherited git hygiene checklist
- acdefcb `docs(setup)` IMP-029 — project language(s)
- 42bc00a `docs(setup)` IMP-030 — [TO BE DEFINED] by hand or in dialogue
- c623b82 `fix(scripts)` review 028d — customisations saved to .bak, symlinks never
  traversed, hooksPath hint at the correct scope
- 7fc8b8e `docs(setup)` review polish — forward pointer s.1, integrate.md checkbox
  at s.2, marker re-compacted (L1 fix), temporal boundary of the L1 perimeter
- 0662cec `chore(claude)` marking: 027..030 → Applied, graft.sh → Deferred

## Post-apply adversarial review (author ≠ judge)
Six independent lenses with a mandate to refute (pointers/orphans, greenfield
intact, docs/06 intact, agnosticity, scripts, memory). 9 findings, 0 blockers;
the well-founded ones applied in the two review commits above. The two most
serious ones, both demonstrated empirically by the reviewers on throwaway repos:
1. re-running hooks-install destroyed the customisations of the formatting block
   that the script itself asks you to make (the marker qualified them as "its
   own") → regeneration via .new + comparison + .bak;
2. FORCE_OVERWRITE on a hook symlink wrote THROUGH the link, corrupting the host's
   file outside .git/hooks → symlinks always treated as foreign, backup and removal
   of the link before writing.
Agnosticity lens: zero findings (no project name in the framework texts nor in the
commit messages).

## Problems encountered → cause → solution (application)
1. Test command denied by the permissions → it contained `rm -rf` (deny active,
   correctly) → re-run with `mktemp -d` and fresh throwaway directories.
2. The "step 2" pointer for integrate.md not resolvable → the
   [TO BE DEFINED AT SETUP] marker of integrate.md was broken across two lines,
   invisible to the grep declared by step 2 (pre-existing bug, discovered by the
   review) → re-compacted + dedicated checkbox at step 2 (7fc8b8e).

## Checkpoint (declared hybrid regime)
STATE/TREE/INDEX remain clean templates: the change to STATE.md in ff3c2bc is to
the TEMPLATE (definition of "Documentation debt"), not a population.
No component in components/ (repo of the method). Structure unchanged →
TREE.md not regenerated. CHANGELOG: [Unreleased] is filled in within /integrate.
