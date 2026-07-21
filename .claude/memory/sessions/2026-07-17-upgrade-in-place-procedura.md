---
date: 2026-07-17
task: deliverable D2 — in-place upgrade procedure for an already-grafted framework (third case, alongside greenfield/brownfield)
branch: feat/upgrade-in-place-procedure
status: completed
tags: [session, upgrade, setup, brownfield]
---
# Session 2026-07-17 — In-place upgrade procedure (`vX→vY`)

## Context
New deliverable unconnected to the previous ones (repo at `v0.4.0`). Real problem not covered:
`SETUP.md` guides greenfield and brownfield (graft onto a project WITHOUT the framework, IMP-027), but
the **third case** is missing: a project that has ALREADY got a version of the framework grafted and must be
upgraded to a new one, PRESERVING the accumulated project memory (expected case:
brew-manager `v0.2.0` → `v0.4.0`, which is D3, another repo, later — NOT here).

Deliverable with STRUCTURAL CHOICES → docs/01 PHASE 2 pattern: read-only assessment → proposal
with alternatives → **user decision** → execution. This note is the **plan pointer**
(interim resolution of **IMP-034**, declared hook not resolved: on the framework repo in
hybrid regime the plan does NOT live in `plans/` but as a session note + `[task N/T]` commits).

## Assessment (read-only, multi-agent workflow)
6 parallel readers (taxonomy of the 41 files, anatomy of the hybrids, markers, what-changed,
security, precedents) + adversarial panel of 3 approaches + completeness critic.

**Key structural insight:** filling in the `[TO BE DEFINED AT SETUP]` slots is **destructive** — once
setup is done the file is an indistinguishable mash of framework-prose + project-answers, with no
grep-able boundary. For the hybrids with interleaved ownership (`CLAUDE.md`, `settings.json`,
`hooks-install.sh`) the only robust mechanism is the **3-way merge** with `base = template@vX`.
But the project **does not record which `vX` it started from** (no provenance pin; the tags live
only in the framework repo) → the 3-way has no certain base. This is the heart of the deliverable.

## User decisions (3 forks)
1. **Machinery = Approach A (doc-only)**: ZERO new artefacts for now; `provenance-pin` and
   `/upgrade-framework` deferred as OPEN IMPs (trigger: 1st real upgrade), twins of
   IMP-027 `graft.sh`. Reason: 1 graft, 0 upgrades → premature automation; binding
   precedent IMP-027 ("document first, prove in the field, automate after 2-3 cases").
2. **Placement = Mix**: pointer stub in brownfield CASE A + **dedicated section**
   `## Upgrading the framework (vX→vY)` in `SETUP.md`.
3. **Edge cases = all 7 mandatory** in the prose of the procedure.

## Upgrade model (taxonomy)
- **METHOD** (→ `vY`): `docs/00-06`, pure commands, the 4 READMEs of `memory/*/`, `reset-task.sh`,
  `scripts/README.md`, `commitlint.config.cjs`.
- **PROJECT-MEMORY** (untouched, invariant: empty `diff` on `memory/`): filled-in `STATE`/`TREE`/`INDEX`,
  `sessions/*`, and in the client `components/decisions/plans/*`.
- **HYBRID** (3-way `base=vX`): `CLAUDE.md` (HIGH), `settings.json` (medium), `hooks-install.sh`
  (HIGH, requires `make hooks-install` post-merge), `LEARNINGS.md` (do-not-touch on the entries),
  `.gitignore`/`Makefile` (MERGE IN), `checkpoint`/`integrate`/`new-component.md` (light).
- **What-changed**: framework-side (the only one with the tags) = per-version CHANGELOG (index) +
  `git diff vX vY -- <method, excluding .claude/memory>` (exact text). Never a blind `git apply`.

## 7 edge cases the procedure MUST cover
1. A file **deleted** in `vY` stays orphaned (overwrite ≠ sync) → apply the deletes too + anti-orphan check.
2. A **renamed/renumbered** file produces a duplicate → rename handling (`git diff -M`).
3. **Tension `empty-diff-on-memory` ↔ broken wikilinks** from doc renames → way out: explicit exception + declared separate commit.
4. Hooks `.git/hooks/*` **outside the git graph**: `make hooks-install` has effects that a branch-based rollback does not undo → verification/uninstallation step.
5. The **`0.x→1.0`** regime of `docs/04`: updating a process doc changes live semantics → "rule-change" warning.
6. **Multi-version jump** `v0.1→v0.4`: the diff between the endpoints collapses non-commutative migrations → order by version.
7. **Pre-flight** pure/hybrid: `docs/02/03/04` are METHOD EXCEPT for inline fills → inspect before overwriting.

## Plan (one commit per task) — COMPLETED
- [x] 1. Branch + this note (plan pointer) — commit: bd7bc7b
- [x] 2. `SETUP.md` dedicated section `## Upgrading the framework (vX→vY)` — commit: 8eb3107
- [x] 3. `SETUP.md` the 7 edge cases in the procedure — commit: 3d40c4b
- [x] 4. `SETUP.md` pointer stub in CASE A — commit: add83db
- [x] 5. `LEARNINGS.md` IMP-036 (provenance-pin) + IMP-037 (`/upgrade-framework`) OPEN — commit: 3a017c7
- [x] 6. `CHANGELOG` `[Unreleased]` + README cross-link + `/checkpoint` — commit: (this one)

## /retro (end-of-deliverable reflection)
- **IMP-034 recurred a 2nd time** (after the /harvest-framework deliverable): this heavy
  deliverable on the framework repo too had to apply the interim resolution (plan
  as a session note, no `plans/`). The recurrence STRENGTHENS the ratification of IMP-034 —
  to be assessed at the next periodic retrospective on the backlog. No new IMP: no
  friction beyond what is already tracked.
- No Level 1 factual correction (the deliverable ADDS a procedure, it does not correct
  docs at odds with reality). STATE.md/TREE.md untouched (hybrid regime, IMP-024).

## Hooks into open IMPs (declared, not resolved)
- **IMP-031** (broken markers escape the grep) → the upgrade inherits the dependency for detecting the new markers of `vY`.
- **IMP-032** (`hooks-install` fix) → the upgrade is the vehicle by which the fix reaches existing projects.
- **IMP-034** (docs/01 ↔ hybrid regime) → building this procedure IS a heavy deliverable on the framework repo: it follows the interim resolution (this note as plan pointer, no `plans/`).
- **IMP-035** ("command" naming) → any future `/upgrade-framework` will be a "command", not the Skills feature.
- **Deferred** sibling: IMP-027 `graft.sh` option.

## Follow-up
- **Security gate**: not sensitive (documentation) → `/security-review` skipped.
- **`/integrate`**: bump to be assessed (consistency with the previous brownfield `[0.3.0]` MINOR). CHANGELOG `[Unreleased]` filled in inside `/integrate`. Merge + tag + push = human.
- **Scope discipline**: expand CASE A without rewriting the existing graft rules; the 2 IMPs kept separate from the procedure.

## Links
[[LEARNINGS]] · [[STATE]] · [[2026-07-17-harvest-framework-ponte]]
