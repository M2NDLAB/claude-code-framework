---
date: 2026-10-09
task: v1.3.2 — quick fixes from the earlier upgrade lessons (C11, C12, C13, B8, the §2 slots, reset-task.sh's class, a backtick, the client name) and F4 (a visible error when the guard breaks in the main session); IMP-067 recorded
branch: fix/quick-fixes-1.3.2
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, imp, fixes, upgrade]
---
# Session 2026-10-09 — v1.3.2: quick fixes

> Phase 1 (verification only, no writes) then phase 2 on this branch, from `main` at
> `c230a12` (v1.3.1). Probes only under `/tmp`. Hybrid regime: no `plans/`, this note is
> the plan-pointer.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 2` — the phase-1 verification request; the decisions with the phase-2 go-ahead.

## Plan (one commit per task)
- [x] 1. This note: phase-1 findings, the user's decisions, the plan block — commit: 29df076
- [x] 2. Record IMP-067 (OPEN, MEDIUM): the framework in headless mode and via the Agent SDK — commit: 5c0426d
- [x] 3. F4: the guard's wiring prints its own first line and exits 1 in the main session; self-test; `docs/04` — commit: 1177abd
- [x] 4. C13 (`chore: wip …`), the `SETUP.md`:353 backtick, the §2 checklist (decisions README, `docs/04` merge form and public contract) — commit: 3de2cab
- [x] 5. `reset-task.sh` stays METHOD: its answer moves to the `Makefile` target; the script, `CLAUDE.md`'s quick command, `scripts/README.md`, the §2 entry — commit: 507217d
- [x] 6. B8: the prospective sentence in rule 9 of `CLAUDE.md` — commit: e1c0039
- [ ] 7. C12: `SETUP.md` edge case 3 extended to the memory's format lines read by name (the section titles of STATE and LEARNINGS) — commit: —
- [ ] 8. The client project's name anonymised in `LEARNINGS.md` and five session notes — commit: —
- [ ] 9. ONE reviewer + fixes — commit: —
- [ ] 10. `/checkpoint` — commit: —
- [ ] 11. `/integrate`: the CHANGELOG 1.3.2 entry (Errata, Upgrading with the migration table) and one additive line under 1.1.0 — commit: —

## Phase 1 — verification on `main` (`c230a12`), read-only
Every item still existed; lines moved since the lessons of 2026-09-24/26:
- C13 — `docs/04`:36, `checkpoint.md`:45 prescribe `wip:`; `commitlint.config.cjs` has no
  `wip` type: `wip: …` rc 1 (type-enum), `chore: wip …` rc 0 (commitlint 21.2.3, from
  stdin in `/tmp`).
- C11 — `CHANGELOG.md`:169-176 ([1.1.0]): "Every READER accepts the legacy Italian form",
  escalation delimiters included; `docs/05`:71-83 reads only `END OF RESPONSE`; v1.0.0's
  closers were `FINE REPORT`/`FINE RESPONSE`.
- B8 — rule 9 (`CLAUDE.md`:63-75) has no prospective clause; it lives only in
  `SETUP.md`:331-337, outside the payload; nothing covers a project that upgraded ACROSS
  v1.1.0.
- C12 — [1.1.0] (lines 148-177) says "needs no migration" and omits: the dropped format
  comment of LEARNINGS' Applied section (2 comment blocks at v1.0.0, 1 since); the
  `/checkpoint` placeholder `<branch-integrazione>` → `<integration>`; the translated
  section titles of STATE and LEARNINGS, which `checkpoint.md`, `lint-memory.md`,
  `retro.md`, `docs/03` and `docs/06` cite BY NAME. No later entry declares them.
- §2 — `SETUP.md`:79 "the complete list" misses `decisions/README.md`:12,
  `docs/04`:72 (merge form), `docs/04`:123 (public contract), `reset-task.sh`:20.
- `reset-task.sh` — filed METHOD (`SETUP.md`:376) with the `PROTECTED_BRANCHES` slot at
  lines 20-23.
- Backtick — `SETUP.md`:353, `` `docs/06* ``.
- The client name — `LEARNINGS.md`:1061, :1407, and 7 times in 5 session notes of July; in
  no commit message.
- F4 — per the hooks docs, an exit 1 shows "`<hook> hook error`" with the FIRST line of
  stderr ("Failed with non-blocking status code: …").

## The user's decisions (2026-10-09)
- C13 (a): the two lines become `chore: wip …`; commitlint untouched.
- C11 (a): an errata narrowing the 1.1.0 promise to the readers that exist.
- B8 (b): one sentence in rule 9 — it applies "from the graft, or from the upgrade that
  brought the rule, onwards"; `CLAUDE.md` is HYBRID: the Upgrading note gives the exact
  sentence.
- §2 slots and the backtick: obvious corrections.
- `reset-task.sh` (b): stays METHOD; the answer moves to the `Makefile`'s `reset-task`
  target; an Upgrading note for projects that edited the list in the script.
- The client name: anonymised in `LEARNINGS.md` AND the five notes, with one neutral,
  consistent reference that keeps IMP-036/037 readable; the note declares that the
  published history keeps the name — the anonymisation holds from here on only.
- F4: yes — the wiring captures the guard's output and prints its own clear first line;
  exit 1 on the main-session branch; the self-test updated.
- CHANGELOG: an Errata in the 1.3.2 entry + ONE additive line at the end of the 1.1.0 entry
  ("corrected in 1.3.2, Errata").
- C12, third change — CORRECTED by the user: not documentation only, a FUNCTIONAL defect.
  The commands look the titles up by name; a project that crossed v1.1.0 with an Italian
  STATE is probably not read correctly today. The Errata gives a MIGRATION STEP in the
  Upgrading note: rename STATE's section titles to the current English form (format lines;
  the CONTENT of the sections is never touched and keeps its language — the prospective
  rule); no legacy reader in the commands (consistent with C11); a table old → new title.
  If `SETUP.md`'s exception for the memory does not cover format lines, extend it
  explicitly and say so.
- IMP-067 (OPEN, MEDIUM, the retro's process block): the framework in headless mode
  (`claude -p`, CI) and via the Claude Agent SDK.
- Phase 2: this branch; probes only in `/tmp`; `make test-scripts` green; ONE reviewer;
  `/checkpoint` and the printed `/integrate` block; merge, tag and push are the user's.

## Notes taken while planning
- `SETUP.md` has no exception called "A": the only exception to the empty-diff invariant
  on `.claude/memory/` is edge case 3 (pointers broken by a doc rename, `SETUP.md`:382 and
  :634-643), which does not cover format lines → extended in task 7, declared.
- The same translated-titles defect applies to LEARNINGS (`retro.md`:22-26 and
  `docs/06`:10-11, :68 cite "OPEN", "Applied", "Deferred", "Rejected") — part of the
  same C12 change as the original finding described it ("the STATE/LEARNINGS section
  titles"); included in the migration table, declared.
