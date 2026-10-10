---
date: 2026-07-17
task: periodic retrospective on the whole IMP backlog (031-037) + /lint-memory of the framework memory
branch: chore/retro-backlog-imp
status: completed
tags: [session, improvement, retro, lint]
---
# Session 2026-07-17 — Periodic retro of the IMP backlog + lint-memory

## Context
Deliverable unrelated to the previous ones (repo at `v0.5.0`, clean working tree). NOT the light
end-of-deliverable `/retro`: **periodic retrospective** on the whole backlog (6 open IMPs:
031, 032, 034, 035, 036, 037), together with `/lint-memory` (health-check after 5 deliverables
and 5 merges). Reason for the order: the retro comes before D3 (upgrade of the client project `v0.2→v0.4`,
another repo) because ≥4 of the 6 IMPs touch D3 — enter the trial run with a clean backlog.

This note is the **plan-pointer** (interim resolution of **IMP-034**, which this very
deliverable ratifies at task 4): in the framework repo under the hybrid regime the plan does NOT live in
`plans/` but here, as a **standardised plan block** + `[task N/T]` commits. Small declared
recursion: we apply the exception while ratifying it (3rd occurrence, after harvest and upgrade).

## PHASE 1 — Retro: adversarial verification (multi-agent workflow)
6 parallel verifiers (one per IMP, mandate to CONFIRM/REFUTE the claims against the real files) +
1 design analyst for IMP-034. Outcome: **all claims confirmed** against the real files. 2
minor clarifications (034: committing=PHASE 2, ticking=PHASE 3; 035: "recurring" is hypothetical, 1
occurrence). Table presented to the user → decisions taken.

## User decisions (PHASE 1 → application)
1. **IMP-031** → APPROVED. Convention "marker on a single physical line" + `/lint-memory` sentinel
   that EXCLUDES the 3 references in prose (false positives).
2. **IMP-032** → APPROVED. Fix `[[ -e ]]` + RED→GREEN test, `rm -f` common to both branches.
3. **IMP-034** → **A+C, NO D, NO B**. A ratifies the exception AND repairs the RESUMPTION step
   (docs/01:129, which today only looks in `plans/`); C standardises the plan block in the note. It applies
   to the CLASS (`plans/` AND `decisions/`). D discarded (lex specialis = premature abstraction from
   n=1, a drift vector); B discarded (`git rm` is forgettable). IN-SCOPE: docs/01 +
   sessions/README; do NOT touch CONTRIBUTING (cross-link noted for the README/CONTRIBUTING deliverable).
4. **IMP-035** → RESOLVE. One line next to IMP-026 in LEARNINGS. No glossary (overload 1×).
5. **IMP-036** → DEFERRAL CONFIRMED. Trigger: after the 1st real upgrade (D3).
6. **IMP-037** → DEFERRAL CONFIRMED. Trigger: after 2-3 real upgrades.
Bump for the deliverable: **PATCH** (031/032 are `fix`; the rest is docs/chore).

## Plan (one commit per task)
- [x] 1. Branch + this note (plan-pointer, plan block) — commit: d7194de
- [x] 2. IMP-031: convention in SETUP.md + sentinel in `/lint-memory` — commit: f02e6bb
- [x] 3. IMP-032: fix `hooks-install.sh` (dangling) + RED→GREEN test + `make test-scripts` — commit: d061f6c
- [x] 4. IMP-034 (A+C): docs/01 box + RESUMPTION patch + plan block in sessions/README — commit: da0e158
- [x] 5. IMP-035: terminology note next to IMP-026 — commit: ee5b0f8
- [x] 6. Move IMP-036/037 to "Deferred" with their triggers — commit: 954d72d
- [x] 7. PHASE 2 `/lint-memory` + `/checkpoint` (backfill shas, finalise note) — commit: (this one)

## PHASE 2 — /lint-memory
Health-check on the live memory (hybrid regime IMP-024: live `LEARNINGS` + `sessions/`;
STATE/TREE/INDEX are templates). Outcome **GREEN**, 0 mechanical corrections needed:
- **Links** — all the `[[wikilinks]]` in notes and LEARNINGS resolve (4 existing dated notes +
  INDEX/LEARNINGS/STATE/TREE). No broken links. (The `[[ -e … ]]` in the IMP-032 comments are
  bash syntax, not wikilinks.)
- **LEARNINGS consistent** — OPEN empty, Applied 001-035, Deferred 023/026/027-graft/036/037;
  numbering 001-037 complete; shas of the 4 new Applied entries filled in at the checkpoint.
- **References to the moved IMPs** — in the live non-LEARNINGS artefacts only correct
  references (docs/01 = ratification of IMP-034; CHANGELOG [0.5.0] cites IMP-036/037 as history of the
  release, immutable). No stale claim to correct.
- **STATE/TREE/INDEX templates** — confirmed by-design (IMP-024), not a finding.
- **Orphans** — none; this note is the most recent one and links to the previous ones.
- **Observation (non-IMP, judgement call)**: under the hybrid regime check 9 of
  `/lint-memory` (LEARNINGS↔STATE consistency) is structurally inert, because STATE is a template
  and there is no live dashboard injected at SessionStart reflecting an imminent IMP trigger (e.g.
  036/037→D3). It is a KNOWN and accepted consequence of IMP-024 (the backlog lives in LEARNINGS,
  consulted on-demand), not a defect — not opened as an IMP unless the user says otherwise.

## Factual doc corrections (Level 1, docs/06)
- None: the deliverable APPLIES decided IMPs (Level 2); it does not correct docs in disagreement with
  reality (the IMP-031 convention PREVENTS, it does not correct an instance).

## Follow-up
- Cross-link CONTRIBUTING ↔ docs/01 (hybrid regime / plan block) → **deferred to the
  README/CONTRIBUTING deliverable** (out of scope here, by user decision).
- `/integrate`: PATCH bump → `v0.5.0` → `v0.5.1`. Merge + tag + push = human.

## Links
[[LEARNINGS]] · [[2026-07-17-upgrade-in-place-procedura]] · [[2026-07-17-harvest-framework-ponte]]
