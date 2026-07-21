---
date: 2026-07-17
task: deliverable /harvest-framework + project→framework bridge (command + marking + bridge doc)
branch: feat/commands-harvest-framework
status: completed
tags: [session, improvement, harvest, ponte]
---
# Session 2026-07-17 — `/harvest-framework` + project→framework bridge

## Context
New deliverable, unrelated to the previous one (v0.3.0). Born out of real friction: the
lessons that concern the FRAMEWORK but emerge while working on a CLIENT project were
carried over by hand, with no procedure and no marking. Deliverable with STRUCTURAL
CHOICES → followed the docs/01 PHASE 2 pattern: read-only assessment → proposal with
alternatives → user decision → execution. Recorded as [[LEARNINGS]] IMP-033.

## Done
- **Read-only assessment** (multi-agent workflow, 5 parallel readers + adversarial
  gap-check): session-note structure, marking convention, model commands, relevant IMPs
  (009/021/026/027-032), cross-repo boundary, memory topology and project-side adoption.
  Source of the 4 decisions.
- **4 structural decisions by the user**: (1) mechanism = COMMAND in `.claude/commands/`
  (not Skill → does not reopen IMP-026); (2) marking = `Destination: framework` attribute on
  the IMP entry (single grep-able line); (3) perimeter = the whole `LEARNINGS.md` backlog,
  narrowable with `$ARGUMENTS`; (4) boundary = read-and-print-only, confirmed.
- **6 tasks, one commit each** `[task N/T]`: IMP-033 recorded (c66acae) → attribute in the
  IMP format (d2856be) → "The bridge to the framework" subsection in docs/06 (c0df16c) →
  `harvest-framework.md` command (f50816f) → registration in CLAUDE.md/README + cross-link
  SETUP §5/CONTRIBUTING/README Philosophy (534b41d) → this checkpoint.
- **Command demonstrated on a fixture** (in the framework repo it is moot): grep selects only
  the marked IMP, ignores the project ones; case with no marker → anti-vacuity (0 matches, no
  empty block).

## Problems encountered → cause → solution
- **Wrong premise in the prompt**: the user believed the framework lessons were already
  marked as free text ("material for the FRAMEWORK") in the notes. → CAUSE: the marking
  never existed (grep on the 4 candidate terms = 0 occurrences; verification on real
  artefacts, docs/02). → SOLUTION: the correction was declared in the assessment; the marking
  became part of the deliverable (designed from scratch as an IMP attribute).
- **Where the "plan" lives (docs/01 vs hybrid regime)**: docs/01 mandates a file in `plans/`,
  but IMP-024 keeps `plans/` template-clean in the framework repo. → CAUSE: docs/01 does not
  foresee a heavy deliverable on the framework repo. → SOLUTION (decided with the user):
  IMP-024 (specific to the framework repo) prevails over docs/01 (general) within its scope;
  the plan lives as IMP-033 + this note + `[task N/T]` commits, same resumption checkpoints.
  Process gap recorded as IMP-034 (to be assessed with a cool head, not resolved here).

## Factual doc corrections (Level 1, docs/06)
- None: the deliverable ADDS conventions/docs, it does not correct docs at odds with reality.

## Proposals
- IMP-033 (in [[LEARNINGS]]): `/harvest-framework` command + `Destination: framework`
  attribute + bridge in docs/06 — **APPLIED** in this deliverable.
- IMP-034 (in [[LEARNINGS]]): docs/01 ↔ hybrid regime on `plans/` for heavy deliverables on
  the framework repo — **OPEN** (deferred, to be assessed with a cool head, as indicated by
  the user).
- IMP-035 (in [[LEARNINGS]]): "skill" overloaded (command / Skills feature IMP-026 / the
  harness's `Skill` tool) — **OPEN** (low impact).

## Process note (not an IMP)
- Disambiguation persisted for the next session: in this repo an invocable is a COMMAND
  (a file in `.claude/commands/`); the Skills feature (`.claude/skills/`, not adopted) is the
  subject of IMP-026 (deferred); the harness calls project commands "skills" too (platform
  naming). On the creation of `harvest-framework.md` the harness immediately exposed it as a
  "skill" — confirmation of the overload, tracked in IMP-035.

## Follow-up
- **`/integrate`**: expected bump **MINOR** (there is a `feat` — command + attribute), pre-1.0
  → tag `v0.4.0` on `main` (declared trunk-based regime, IMP-025). CHANGELOG `[Unreleased]` is
  filled in inside `/integrate`. Merge + tag + push = human action.
- Anonymisation finished: recalled inside the command itself (no action needed here).

## Links
[[LEARNINGS]] · [[2026-07-17-audit-preintegrate-closeout-v0.3.0]]
