---
date: 2026-07-18
task: public doc alignment to v0.6.0 — README/SECURITY/CONTRIBUTING + badges
branch: docs/allineamento-doc-pubblica-v0.6.0
status: completed
tags: [session, docs, readme, badge, allineamento]
---
# Session 2026-07-18 — Public doc alignment + badges (v0.6.0)

## Context
Last substantial deliverable before the v1.0 assessment: aligning the public doc
(README, SECURITY, CONTRIBUTING) to the real state after the 5 deliverables
v0.3.0→v0.6.0, plus 2 badges. ALIGNMENT work (Level 1 where the doc diverged
from reality), not a rewrite. Hybrid regime (IMP-024/034): no
`plans/`, this note is the journal; BELOW the heaviness threshold → 4 direct,
well-scoped commits on a dedicated branch, no plan block.

## PHASE 0 — read-only assessment (approved by the user)
7 misalignments: **D1** CLAUDE.md "Quick commands" without `make test-scripts`
(drift of the "TREE legend 5/7" class); **D2** README "Structure" — `scripts/` 3/4
(missing `test-hooks-install.sh`), Makefile line at 2 targets; **D3** README stuck
at v0.2 — "What it includes" without brownfield graft/upgrade-in-place/pin/bridge,
step 1 without the creation of the pin; **D4** badges absent; **D5**
`scripts/README.md` table 2/3; **D6** SECURITY baseline without the one-off scan
of the history (IMP-028b, v0.3.0); **D7** CONTRIBUTING without the cross-link
to the hybrid regime's plan block (debt DECLARED in IMP-034: "deferred to the
README/CONTRIBUTING deliverable" — settled here).
Declared OK and NOT touched: SETUP.md (fresh from v0.6.0), CHANGELOG
(append-only: the historical v0.1.0 list stays at 7 commands, it was correct then),
the rest of SECURITY/CONTRIBUTING, memory templates, settings.json, docs/00-06.

## Decisions
- **Badges**: repo verified PUBLIC (anonymous GitHub API → 200, tags readable)
  → DYNAMIC version `github/v/tag?sort=semver` linked to /tags; static licence
  → LICENSE. Labels in Italian (consistency with the README). Only the 2 real
  ones: no CI/size/community — they would reflect non-existent facts.
- **Project→framework bridge**: it extends the "Self-improvement (IMP)" entry of
  "What it includes" (its natural home), NOT a new entry; "Philosophy" stays the
  narrative. Single new entry: "Graft and update" (greenfield, brownfield,
  upgrade `vX→vY`, provenance pin).
- **Bump: PATCH** (user agreed) — the set contains a `fix` (documentation
  drift, like the previous v0.5.1); pure `docs` on their own = no tag;
  no new capability of the method → not MINOR.

## Commits (branch `docs/allineamento-doc-pubblica-v0.6.0`)
1. 5cf190f `fix(docs)`: command/script lists aligned (D1+D2+D5)
2. c7d870e `docs(readme)`: badges + v0.3–v0.6 capabilities + pin in step 1 (D3+D4)
3. e25c066 `docs(security)`: baseline completed with the one-off on the history (D6)
4. 00902de `docs(contributing)`: cross-link to the hybrid regime plan block (D7)

## DoD (verified outcomes)
- Dynamic badge RESOLVES `v0.6.0` (curl to shields.io — verified on the real
  thing, not presumed from theory).
- Slot sentinel (`"DA DEFINIRE AL$"`): only the 3 KNOWN false positives of
  IMP-031, pre-existing; the new text introduces neither slots nor markers.
- Agnosticity: 0 client-project names in the `main..HEAD` diff and in the commits.
- Constraints respected: LICENSE intact, no new sections, no v1.0.
- Security gate: not sensitive (documentation only) → skipped.

## /retro
- **IMP-038 registered (OPEN)**: an "inventories vs reality" check in
  `/lint-memory` — SECOND recurrence of the partial-list class (TREE 5/7 →
  IMP-018; today D1/D2/D5 born from IMP-032 not propagated to the lists). Decision
  deferred to the periodic retro. No other friction.

## Follow-up
- `/integrate` issued downstream of this checkpoint: bump **PATCH → v0.6.1**
  (describe at hand in the block). Merge/tag/push = the user; trunk-based on
  `main` (integration = stable, pre-1.0 tag on `main`).
- **Post-integration reconciliation** (checkpoint 2026-07-18): block executed
  by the user — merge `ad65ac7` on `main`, annotated tag **v0.6.1** on `main`
  (describe exactly `v0.6.1`; tag object `f143ec8` present ALSO on the remote,
  verified with `ls-remote`), feature branch deleted, `main` aligned to
  `origin/main` (branch and tag pushes done — including the checkpoint `95e43bd`
  of the previous session, as anticipated in the block). The README's version
  badge now resolves v0.6.1 from the GitHub tags. No active branch besides `main`,
  no in-progress plan, working tree clean. Next roadmap step:
  assessment of the v1.0 promotion (a deliverable in its own right, on the user's decision).

## Links
[[LEARNINGS]] · [[2026-07-18-retro-mirata-imp-036-037]] ·
[[2026-07-17-harvest-framework-ponte]]
