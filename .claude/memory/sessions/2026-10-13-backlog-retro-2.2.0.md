---
date: 2026-10-13
task: v2.2.0 — the retro over the backlog, decided and applied — the recovery block given only after a failed check, a LOW finding declared as a limit, a backlog small enough to grow only from the projects' real use
branch: feat/backlog-retro-2.2.0
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, retro, imp, plan, security-gate]
---
# Session 2026-10-13 — v2.2.0: the retro over the backlog

> A dedicated branch from `main` at `00f8349` (v2.1.0, its tag signed). Probes only in the
> session's scratchpad. Hybrid regime: no `plans/`, this note is the plan-pointer. The retro's
> phase 1, read-only on `main`, the same day; then the user's decisions.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 2` — the user's report of v2.1.0's integration, with the brief of the retro; the
  user's decisions on the retro.

## The brief — persisted so a /clear does not lose it
- v2.1.0 integrated and published by the user (`00f8349`, the tag v2.1.0 signed, the branch
  deleted locally and on GitHub); this repository's hooks regenerated with
  `make hooks-install`.
- An incident at that integration, for the first commit of the next release: the recovery
  block (`git tag -d v2.1.0`, "only if …") was printed with blocks 1 and 2, and the user ran it
  after an integration that had succeeded. The local tag was deleted and recovered with
  `git fetch` — no damage, a ruleset protects the remote tag. A condition written above a
  copyable block does not work as a condition. Checked here: `/integrate` printed that block
  only "if (and ONLY if)" the tag existed and its check had failed; the tag was free when the
  blocks were printed, so the agent printed it against the command's text, following its own
  v2.0.0 precedent — IMP-102.
- Phase 7 of the cycle, the retro over the backlog — phase 1, analysis only, no write in the
  repository, no branch, the aim to DECIDE: every OPEN or deferred IMP of `LEARNINGS.md`,
  the oldest included, with its number, title, priority, date and trigger; for each, one of
  four outcomes with a one-line reason — APPLY (an observed defect, a proportionate cost),
  REJECT (overtaken, covered by something else, or costing more than it gives), DEFER (on a
  VERIFIABLE trigger, an observable event), MERGE (a duplicate or the same family).
- The context of the evaluations: at the end of the cycle the repository becomes private and
  for personal use (IMP-086); after this cycle the framework develops only from the lessons
  the projects' real use brings, through `/harvest-framework`, so the backlog that remains is
  small and motivated; v2.1.0's two lenses — *Claims*, 14 findings nearly all LOW; *The real
  path*, 9, the only HIGH among them.
- Deliver the table, the totals by outcome, the minimum number of releases for the APPLY set
  with the EXPECTED bump, and apart the entries that touch the two projects using the
  framework and are worth having before their upgrades (phases 9 and 10); then STOP.

## The retro — phase 1 (read-only, on `main` at `00f8349`)
- The inventory: 38 OPEN entries (IMP-048 to IMP-101), 6 deferred, no open part left inside
  the Applied ones (searched), and the new IMP-102: 45.
- APPLY (19): IMP-051, 052, 053, 057, 060, 061, 074, 075, 078, 082, 083, 085, 086, 088, 091,
  092, 094, 099, 102. MERGE (9): IMP-063 into 060, 064 into 067, 065 into 075, 079 into 083,
  093 into 092, and 096, 097, 098, 101 into 095, the hooks' group. DEFER (10): IMP-026,
  037 (option a), 045, 062, 067, 077, 089, 090, 095, 100. REJECT (7): IMP-023, 027, 042, 048,
  072, 080, 081. Each outcome, with its reason and trigger, is in `LEARNINGS.md`.
- One release, v2.2.0, a MINOR expected: new rules enter the payload; the generated hooks do
  not change, so a project's upgrade regenerates them once; two HYBRID files change,
  `integrate.md` and `checkpoint.md`. IMP-086 is not a release: it is applied at the switch.
- The lenses' data, used: *The real path* gave the only HIGH (H1, IMP-090) and two of the
  four MEDIUMs (M2, IMP-092; M3, IMP-093) — there the decisions are the most careful: IMP-090
  deferred on a trigger the user verified, IMP-092 and IMP-093 declared, no new mechanism.
  *Claims* gave the other two MEDIUMs (M1, IMP-091; M4, IMP-094), both applied, and 12 LOW.
  Of the 11 IMPs v2.1.0's review opened, 6 came from LOW findings — the datum behind IMP-103.

## The decisions (the user's, 2026-10-13)
- The retro approved, the outcomes as proposed: 19 APPLY, 9 MERGE, 10 DEFER, 7 REJECT.
- No cut: IMP-083, IMP-082 and IMP-088 stay in v2.2.0.
- IMP-099 does not wait for the decision on the CI's matrix: the check declares as verified
  the platforms the CI's workflow LISTS, read from there — one place — instead of written by
  hand, so it stays true whatever IMP-086 decides.
- The proposal on LOW findings adopted now, in `docs/03`: a LOW finding that a line of text
  does not close becomes a limit declared where its claim lives, not an IMP — IMP-103, on the
  datum above.
- IMP-102's fix is STRUCTURAL, not only textual: in its normal sequence `/integrate` does not
  print the recovery block; it produces it only when the user reports a failed check.
  `docs/04`'s rule 3 of the blocks is aligned.
- What the user verified on the two projects using the framework (it updates triggers only):
  git-lfs absent from both; Claude Code run non-interactively in neither; one has no deploy,
  the other builds its services' container images with the repository's root as the build
  context, copying specific paths — IMP-085's check at its upgrade; an IDE's integrated
  terminal to be confirmed, the user pushes from macOS's Terminal.
- v2.2.0, the bump EXPECTED a MINOR, computed again on the content at `/integrate`. The first
  commit records IMP-102 and the retro's outcomes in `LEARNINGS.md` — the rejected and the
  merged closed with their reason, the deferred with a verifiable trigger — and what the user
  verified. Then the usual flow: a dedicated branch; block 0, the CI green on the three
  systems on every pushed state; the upgrade of the HYBRID files rehearsed with LF and CRLF;
  ONE reviewer with the two lenses; `/checkpoint`; blocks 1 and 2 WITHOUT a recovery block in
  advance.

## Plan (one commit per IMP applied)
- [x] 1. The retro's registrations — the 45 outcomes in `LEARNINGS.md`, IMP-102 and IMP-103, what the user verified on the two projects — and this note with its plan — commit: 5ddaa56
- [x] 2. `/integrate` and the cycle's close: apply IMP-102 (the recovery block produced only after a failed check is reported; `docs/04`'s rule 3), IMP-074 (the bump computed on the content), IMP-051 (the reconciliation after a merge is the next deliverable's first step) — commit: 2d82446, a25e17e, 8c58dc0
- [x] 3. Resumption: apply IMP-094 (`reset-task.sh`: the fix, a self-test red first, `docs/01`'s manual form) and IMP-052 (verify before continuing) — commit: 2cb04dd, 14d09fc
- [x] 4. Process: apply IMP-053 (the gate's verdict always written), IMP-057 (an invariant over a known debt), IMP-060 with IMP-063 (delegation), IMP-078 (a body line read as the footer), IMP-103 (a LOW finding declared as a limit) — commit: 8cf45b1, 3bfc446, 85c7fbe, c62e58d, and IMP-103's (its own sha cannot be written in it)
- [ ] 5. Harvest: apply IMP-061 (the source note's date in the block; each lesson counted once at recording) — commit: —
- [ ] 6. The boundary's claims: apply IMP-092 with IMP-093 and IMP-097's IDE terminal, IMP-083 with IMP-079, IMP-075 with IMP-065 — commit: —
- [ ] 7. `SETUP.md`: apply IMP-091 (the scan's known limits, IMP-095's and IMP-096's with them) and IMP-085 (the framework's files out of deploy artifacts) — commit: —
- [ ] 8. The platform: apply IMP-099 (the platforms the CI's workflow lists, one place) — commit: —
- [ ] 9. The framework's own workflow: apply IMP-082 and IMP-088 (`CONTRIBUTING.md`) — commit: —
- [ ] 10. The CI's rounds (block 0, the user's pushes): green on the three systems on every pushed state — commit: —
- [ ] 11. ONE reviewer, read-only on git, the snapshot before and after, the two lenses on the payload and on the sets its claims name: HIGH fixed here; MEDIUM resolved or accepted with its reason; LOW per IMP-103 — commit: —
- [ ] 12. `/retro` and `/checkpoint`: the upgrade 2.1.0 → 2.2.0 rehearsed on the final payload, the HYBRID files with LF and with CRLF — commit: —
- [ ] 13. `/integrate`: the CHANGELOG 2.2.0 entry, claiming only what was measured; the bump computed on the content against the expected MINOR and declared before the tag; the final block 0; blocks 1 and 2, without a recovery block in advance — commit: —

Each applying commit carries its IMP's part of the text and moves the entry to Applied, its
heading dated; the shas go into the headings with a later commit, as in v2.1.0. Task 10 may
take several commits, one per round of the CI; each round needs the user's push.

## Resumption notes
- Open before task 8 (IMP-099): the CI's workflow, `.github/workflows/test.yml`, is not in
  the payload, and `check-prerequisites.sh` runs in the projects too — where there is no such
  workflow to read. The user's form is to be settled with the user before task 8.
- The payload names no IMP number: the documentation check's `imp-number` refuses one; the
  why goes in prose.
- `integrate.md` and `checkpoint.md` are HYBRID: their changes keep unchanged lines between
  themselves and a slot's line, and the rehearsal of task 12 measures the 3-way merge.
- Delegated agents read only: the snapshot before and after each delegation.
- Next: task 2.
