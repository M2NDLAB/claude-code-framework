---
date: 2026-07-19
task: promotion of the framework to v1.0.0 (first stable release)
branch: docs/promozione-v1.0.0
status: completed
tags: [session, release, versioning]
---
# Session 2026-07-19 — Promotion to v1.0.0

Transition from the pre-1.0 regime (0.x, no stability promised) to post-1.0 (stable
method contract; breaking → MAJOR). Deliverable handled with an assessment, not
mechanically: v1.0 is a public PROMISE, not a higher tag. Base: v0.6.2.

## Readiness assessment (PHASE 1, read-only) — outcome: READY
- Backlog: OPEN = none; deferred 023/026/027-graft/037, all post-1.0 roadmap with their
  trigger (no blocking debt). Numbering 001–038 with no gaps.
- Contradictions: none. IMP-034 ratified and closed (CONTRIBUTING cross-link settled in
  v0.6.1); the "No automation" box in `SETUP.md` is consistent (pin promoted = IMP-036;
  only `/upgrade-framework` = IMP-037 remains deferred).
- `/lint-memory` 11 checks: zero drift. Check 11 (inventories) aligned: 8 commands ↔
  CLAUDE.md/README; 3 process targets in the Makefile; 3 scripts ↔ `scripts/README`. STATE/TREE/
  INDEX = clean templates (correct under the hybrid regime).
- Tags: v0.1.0…v0.6.2 all ANNOTATED, clean SemVer. `git describe` = base v0.6.2.
- docs/04: the post-1.0 bump table was already there; what was MISSING were the definition of
  breaking change and the reframing of 1.0-as-future → raised to blocking GAP 1 (rightly so).

## Done
- **GAP 1** (`4604da4`, `docs(process)`): `docs/04` — agnostic definition of «breaking
  change» as the MAJOR criterion (public contract; examples for code projects and for
  method/tooling projects) + reframing of the regimes as a permanent method and of 1.0 as the act
  that activates the promise. `CONTRIBUTING.md` — git model at post-1.0 (tag on `main` in both
  regimes, trunk-based) + concrete breaking-change promise for the framework.
- **GAP 2** (`e8b7ad3`, `docs(changelog)`): entry `[1.0.0] — 2026-07-19`, first stable
  release, with a summary of the 0.1→1.0 path (consolidated capabilities) and the definition as
  part of the promise.
- **Checkpoint** (this commit, `chore(claude)`): IMP-039 in `LEARNINGS.md` (Applied) +
  this note. STATE/TREE/INDEX untouched (templates, hybrid regime).

## Plan (one commit per task)
- [x] 1. GAP 1 — docs/04 (breaking change + post-1.0 reframing) + CONTRIBUTING (post-1.0 git model + promise) — commit: 4604da4
- [x] 2. GAP 2 — CHANGELOG entry [1.0.0] — commit: e8b7ad3
- [x] 3. Checkpoint — IMP-039 in LEARNINGS + this note — commit: ea49091

## Decisions made (not obvious)
1. **Where «we are at 1.0» lives.** `docs/04` is a TEMPLATE file copied into client projects
   (which may be at 0.x): it cannot assert that the framework IS at v1.0 without breaking
   agnosticity. So the definition of breaking change in `docs/04` is AGNOSTIC (with the
   method/tooling case as an example), while the assertion "the framework IS post-1.0" +
   the concrete promise live in `CONTRIBUTING.md`/`CHANGELOG.md`, which are NOT templates.
   That way the versioning docs do not contradict reality and the template stays clean.
2. **The v1.0.0 tag is a DELIBERATE promotion, not an auto-computed bump.** The deliverable's
   commits are `docs`/`chore` → the automatic bump of `/integrate` would say "no
   tag". The MAJOR v1.0.0 is decided by the user (the "1.0.0 release" regime of docs/04, "the
   final decision remains the user's"). The `/integrate` block states it explicitly.

## Retro (end-of-deliverable reflection)
- Friction: the initial assessment had declared docs/04 "already fine" because the bump
  table was there, missing that the load-bearing DEFINITION of breaking change was absent and
  that the prose framed 1.0 as future. Lesson: the presence of a rule ≠ its
  completeness; on a release-as-promise you must verify the spirit (framing + load-bearing
  definition), not just the mechanics. Decision: NO new IMP — it is n=1 on a rare
  event (MAJOR promotion), formalising a "promotion checklist" now would be premature
  (same anti-hype filter as IMP-027/037). If MAJOR promotions recur, a future retro
  will be able to distil it.

## Integration closure (performed by the user)
v1.0.0 integration completed and verified against reality (this post-integration checkpoint):
- Merge `--no-ff` `e3f1f51` (`docs(process): merge promozione v1.0.0 in main`) onto `main`.
- **Annotated tag `v1.0.0`** on the merge — `git describe` = exactly `v1.0.0` — **pushed**
  (present on `origin`, `refs/tags/v1.0.0`; tag object `74a9741`).
- `main` == `origin/main` == `e3f1f51`; feature branch `docs/promozione-v1.0.0` deleted.
  No active branch other than `main`.
- **The framework is officially at v1.0.0** — post-1.0 regime in force (breaking → MAJOR).

## Links
[[LEARNINGS]] · [[2026-07-19-retro-mirata-imp-038]] · [[2026-07-18-allineamento-doc-pubblica]]
