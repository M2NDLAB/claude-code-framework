---
date: 2026-07-19
task: targeted retro on IMP-038 — inventories-vs-reality check in /lint-memory
branch: fix/lint-inventari-imp-038
status: completed
tags: [session, retro, lint-memory, imp-038]
---
# Session 2026-07-19 — Targeted retro on IMP-038 (approved and applied)

## Context
Targeted retro on the only OPEN proposal in the backlog: IMP-038 ("inventories vs
reality" check in `/lint-memory`). A precondition of the v1.0 assessment (you do
not declare stability with an open, unjudged IMP). Hybrid regime (IMP-024/034):
no `plans/`; deliverable BELOW the heaviness threshold → 2 well-scoped commits on
a dedicated branch, no plan block.

## PHASE 0 — read-only verification (outcomes)
- IMP-038 confirmed as the only entry under "OPEN proposals"; text presented verbatim.
- `/lint-memory` at 10 checks; number 10 (the IMP-031 sentinel) is the one with the
  known false positives handled by declared exclusion.
- Originating friction confirmed in the note [[2026-07-18-allineamento-doc-pubblica]]:
  D1/D2/D5 = three lists stuck at pre-IMP-032, fixed by hand (5cf190f).
- Historical frequency of the class: 2 events in ~5 weeks (TREE legend 5/7 →
  IMP-018; D1/D2/D5), but a persistent STRUCTURAL cause: the same inventory lives
  in up to 4 copies across public documentation that legitimately duplicates →
  de-duplication (the cure of IMP-018) not practicable → detection remains, natural
  home `/lint-memory`.
- Inventories verified ALIGNED at the time of the retro (post-v0.6.1): 8 commands,
  3 scripts + README, Makefile with 4 targets (help + 3 process ones).

## User decision
**APPROVE-AND-APPLY** with the proposed design of check 11 (enumeration, not
heuristics; bidirectional set comparison; declared exclusions). Verification
required at application time: the selection of Makefile targets must distinguish
process vs project ROBUSTLY, in client projects too.

## Applied design (check 11)
- ENUMERATED lists ↔ filesystem, in BOTH directions (exists-but-not-listed /
  listed-but-non-existent); never the mentions in prose.
- **Outcome of the required verification**: the POSITIONAL criterion of the initial
  design ("targets above the `[TO BE DEFINED AT SETUP]` banner") was fragile — at
  setup the client fills in/removes the banner and the anchor disappears. Replaced
  with a STRUCTURAL anchoring: process target = a recipe that invokes a script in
  `scripts/` (`help` excluded). Verified on the real artefacts: the 3 process
  targets invoke `bash scripts/*.sh`, `help` does not, the client examples in the
  banner invoke the stack's commands → no false positive in the client.
- Equivalences of form admitted (`make reset-task` ≡ `./scripts/reset-task.sh`).
- Excluded by declaration (as in check 10): CHANGELOG (append-only) and the IMP
  records in LEARNINGS — they record past states, not current inventories.

## Commits (branch `fix/lint-inventari-imp-038`)
1. 2f69413 `fix(process)`: check 11 in `lint-memory.md`
2. (this checkpoint) `chore(claude)`: IMP-038 → Applied with the real sha (no
   backfill), session note

## End-of-deliverable cycle
- Security gate: NOT sensitive (process documentation only) → skipped.
- `/retro`: declared no-op — the only friction (fragile positional criterion) is
  resolved and documented in the IMP-038 record; no new proposals. OPEN backlog
  now empty.
- Bump declared for `/integrate`: **PATCH → v0.6.2**. Reason: the twin precedent
  IMP-031/v0.5.1 — a lint check that closes a documented drift class is a `fix`
  ("Fixed" in the CHANGELOG), not a new method capability (→ not MINOR) nor pure
  internal work (→ not "no tag": v0.5.1 tagged PATCH for the same
  remediation+sentinel pair).

## Follow-up
- `/integrate` issued downstream of this checkpoint: bump **PATCH → v0.6.2**
  (describe at hand in the block). Merge/tag/push = user; trunk-based on
  `main` (integration = stable, pre-1.0 tag on `main`).
- **Post-integration reconciliation** (checkpoint 2026-07-19): block executed
  by the user — merge `9246cd8` on `main`, annotated tag **v0.6.2** on `main`
  (describe exactly `v0.6.2`; tag object `930eaeb` present ALSO on the remote,
  verified with `ls-remote`), feature branch deleted, `main` aligned with
  `origin/main` (branch and tag pushes done). No active branch other than
  `main`, no in-progress plan, working tree clean. IMP backlog: OPEN
  empty. Next roadmap step: **assessment of the v1.0 promotion**
  (a deliverable of its own, at the user's decision) — with no pending open IMPs.

## Links
[[LEARNINGS]] · [[2026-07-18-allineamento-doc-pubblica]] ·
[[2026-07-17-retro-periodica-backlog-lint]]
