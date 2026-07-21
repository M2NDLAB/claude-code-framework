---
date: 2026-07-11
task: framework consolidation — assessment (PHASE 1), IMP registration (PHASE 2), application (PHASE 3)
branch: feat/consolidamento
status: completed
tags: [session, consolidamento, assessment]
---
# Session 2026-07-11 — Consolidation: assessment and IMP registration

## Context
Consolidation prompt in three phases: (1) read-only assessment of the whole
framework; (2) registration of the proposals as IMPs in [[LEARNINGS]], WITHOUT
applying them; (3) application of only the IMPs approved by the user. This note
persists the PHASE 1 assessment so that PHASE 3 can POINT here without redoing
the work (a future session restarts from this note + the approved IMPs).

## Done
- Read ALL the files in the repo (31 tracked files): CLAUDE.md, docs/00..06, the 7
  commands, memory (STATE/TREE/INDEX/LEARNINGS + 4 READMEs), scripts/*,
  settings.json, commitlint.config.cjs, Makefile, SETUP.md, README.md, .gitignore.
- Verified the ABSENCE of: LICENSE, SECURITY.md, CONTRIBUTING.md,
  CODE_OF_CONDUCT.md, CHANGELOG.md, `.github/`, `.claude/skills/`.
- Real git state at the time of the assessment: `main` = `origin/main` = annotated
  tag `v0.1.0` on `6a1fe9e` (merge commit with two parents); `git describe
  --tags --long` = `v0.1.0-0-g6a1fe9e`; a stale `origin/master` leftover exists
  (→ `3b4f6d8`, pre-template); local git hooks NOT installed in this repo.
- Registered IMP-009..026 in [[LEARNINGS]] (12 mechanical + 6 requiring a user
  decision). Created the `feat/consolidamento` branch; commit of the registration
  only (registering ≠ applying).

## Assessment — INPUT 1 (22 conventions): summary of the mapping
- PRESENT in substance: A7 (one task = one commit, docs/01 PHASE 3).
- PRESENT IN PARTIAL/DIFFERENT FORM → filled by the indicated IMPs:
  A1 execution boundary (implicit in docs/04 + /integrate, never stated) → IMP-009;
  A2 real values in user blocks (only inside /integrate) → IMP-009;
  A4 ASCII tag hygiene (partial in /integrate §4; rev-parse/conditional tag -d missing) → IMP-010;
  A5 pre-push verification (git log origin/.. used only for the bump) → IMP-010;
  B6 upstream phases (decisions/README says WHERE, no doc says WHEN) → IMP-011;
  C10 prompts-that-point (mechanics present in plans/, principle unwritten) → IMP-013;
  C13 triggers on debts (exists only for Deferred IMPs, not for STATE) → IMP-014;
  D20 executor≠user placeholders (implicit in /integrate) → IMP-009.
- ABSENT → IMP: A3 isolated destructive commands (IMP-009); B8 scope discipline and B9
  /clear hygiene (IMP-012); C11-C12 persistence before /clear/model switch (IMP-013);
  C14 survival of debts across STATE rewrites (IMP-014); D15-D17
  verification on real artifacts, RED→GREEN, invariants (IMP-015); D18-D19 adversarial
  review by radius of propagation, finding completeness (IMP-016); E21
  model per task (IMP-017); E22 resumption without wasted turns (IMP-013).

## Assessment — INPUT 2 (re-verification on the real files)
- `/lint-memory` with no declared trigger: CONFIRMED (00-overview and
  lint-memory.md do not say WHEN to run it) → IMP-018.
- TREE.md legend 5/7 commands: CONFIRMED (line 35: /integrate and
  /lint-memory missing) → IMP-018 (Level 1 fix tracked there).
- Dogfooding: CONFIRMED and broader than expected — LEARNINGS real but
  STATE/TREE/INDEX template, sessions/ empty despite ~14 real commits, whoever
  copies inherits the framework's IMPs, git hooks not installed in the repo → IMP-024
  (OPEN with 3 options, recommended "declared hybrid").
- `/new-component` inert: CONFIRMED in an attenuated form (SETUP.md §2 already has the
  checklist; only the inertness warning is missing) → IMP-018.
- Git history "linear with no merge": PARTLY DISPROVED — the two-parent merge
  `6a1fe9e` does exist; what remains: local merge without a PR (tension with docs/04 →
  IMP-019), branching model NEVER declared, merge message not in the proper format
  + the specific name "VORTEX" in the shared history (not rewritable,
  avoidable in future), `origin/master` leftover → IMP-025 (OPEN).

## Assessment — found BEYOND the inputs (PHASE 1.4)
- INTERNAL CONTRADICTION: docs/04 "Merge: ALWAYS via PR, never a direct local
  merge" vs the LOCAL merge block printed by /integrate → IMP-019.
- The gitleaks PreToolUse hook in settings.json is DECORATIVE: the `||` swallows even
  a found leak, exit always 0 (never blocks), the --staged target is wrong at the
  moment of Write/Edit → IMP-020.
- No tension between the INPUT 1 conventions and the existing rules, with two
  notes on consistency: B9 (unrelated doc on a separate branch) does NOT conflict with
  rule 5 of CLAUDE.md (which concerns the doc TIED to the change); E21 must be
  written tool-agnostic so it does not age (taken up in IMP-017).

## Assessment — INPUT 3/4 (project files and Skills)
- All the project files are ABSENT. Two-level classification: LICENSE =
  real in the repo + placeholder in the template (IMP-021, decision); SECURITY =
  placeholder scaffold useful at both levels, CONTRIBUTING and CHANGELOG =
  framework-repo level with real content (IMP-022, decision); CoC and
  .github/ = defer with a trigger, anti-hype filter (IMP-023, decision).
- Skills: `.claude/skills/` does not exist; sceptical evaluation = NOT justified
  now (no observed friction; the commands + selective loading cover the
  function); defer with an explicit trigger (IMP-026, decision; interpretation
  of the mandate declared and to be confirmed).

## Conceptual lint of the memory (PHASE 1.6)
- Wikilinks of the template files ([[STATE]], [[TREE]], [[INDEX]], [[LEARNINGS]]):
  all resolvable. No broken links in the real files.
- Stale claim: TREE.md legend (above). Regime contradiction: LEARNINGS
  alive vs the rest template (above, dogfooding). STATE.md/INDEX.md deliberately not
  touched in this session: they are pure templates and filling them would PRE-judge
  the IMP-024 decision.
- README/SETUP consistent with the real structure; the cycle cited in README §"Come si
  usa" aligned with 00-overview.

## Problems encountered → cause → solution
1. Risk of pre-judging IMP-024 by updating STATE/INDEX with real data →
   chose NOT to touch them until the user decides the dogfooding regime;
   the memory of this session lives in this note + LEARNINGS.

## Proposals
- IMP-009..026 in [[LEARNINGS]] — 12 mechanical (009-020) + 6 requiring a user
  decision (021-026: licence, community files, CoC/.github, dogfooding, repo
  branching, skills).

## Follow-up
- PHASE 3 ONLY after the user's decisions on the IMPs: one commit per applied
  IMP, then /checkpoint and /integrate (expected bump: 009-020 alone are
  docs/chore → NO tag; if IMP-021/022 pass — substantial new project files
  — → MINOR, v0.1.0→v0.2.0).
- The removal of `origin/master` (if approved in IMP-025) is a USER action on
  shared history: separate block with a preventive check, never inline.

## PHASE 3 — application (same date, resumed from the note above)
User decisions: APPLIED 009-022 + 024-025 (021: MIT, holder "M2NDLAB", 2026;
024: option 3 "declared hybrid"; 025: declared trunk-based). DEFERRED
023 and 026 with their trigger. Application: one commit per IMP on the branch
`feat/consolidamento` — shas in [[LEARNINGS]], Applied section. Marking in a
separate commit (58c107e): the sha of a commit cannot live inside itself
(same precedent as IMP-001..008).

Execution notes:
1. IMP-020 demonstrated RED→GREEN on the real chain (throwaway repo with a fake
   AWS secret): PreToolUse hook command → exit 0 with a misleading warning
   despite `leaks found: 1` (bare gitleaks: exit 1); pre-commit hook of
   hooks-install.sh → commit BLOCKED. Choice: removal of the decorative hook
   (an honest fix would require jq/JSON parsing and gitleaks stdin modes that are
   version-dependent, outside the template baseline); the defence declared by
   rule 1 is the pre-commit, which works.
2. IMP-019 extended to ALL THREE occurrences of the contradiction (Merge, branching
   model line 19, Versioning/promotion to 1.0.0): resolved, not moved.
3. Post-change consistency verified by grep: no "SEMPRE via PR" leftovers,
   no orphan reference to the PreToolUse hook (only the HISTORICAL citations
   in this note and in LEARNINGS remain, which are correct), /integrate numbering
   consistent after inserting the CHANGELOG step (1-5 + release variant).
4. Checkpoint according to option 3: STATE.md/TREE.md/INDEX.md NOT populated (they
   remain clean templates — filling them would violate the regime just decided); the
   real map of the repo is the structure diagram in the README (updated by
   IMP-021/022); the TREE.md legend was realigned by IMP-018.
   The closing prompt's instruction "regenerate TREE.md" was resolved this way,
   declaring it: TREE is a template, the hybrid regime does not count it among the
   live ones.

## Problems encountered → cause → solution (PHASE 3)
1. IMP-020 demo command denied by the permissions → it contained `rm -rf` (deny
   active, correctly) → re-run without deletions, new throwaway directory.
