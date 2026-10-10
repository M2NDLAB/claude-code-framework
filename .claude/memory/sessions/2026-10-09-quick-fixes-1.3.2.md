---
date: 2026-10-09
task: v1.3.2 — quick fixes from the earlier upgrade lessons (C11, C12, C13, B8, the §2 slots, reset-task.sh's class, a backtick, the client name) and F4 (a visible error when the guard breaks in the main session); IMP-067 recorded
branch: fix/quick-fixes-1.3.2
status: completed
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
- [x] 7. C12: `SETUP.md` edge case 3 extended to the memory's format lines read by name (the section titles of STATE and LEARNINGS) — commit: 1f1bc9f
- [x] 8. The client project's name anonymised in `LEARNINGS.md` and five session notes — commit: ebe5122
- [x] 9. ONE reviewer + fixes — commit: 5afe3fe
- [x] 10. `/checkpoint` — commit: the checkpoint commit (its own sha cannot be written in it)
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

## Review (task 9) — one reviewer, dispositions
One independent reviewer over `c230a12..ebe5122` and the CHANGELOG draft (kept in `/tmp`
until task 11). It wrote nothing in the repo (snapshot identical before and after); the
live guard refused its git writes even in `/tmp`, by design. Verdict: fit to merge after
the two MEDIUM items.

| Finding | Severity | Disposition |
| --- | --- | --- |
| MEDIUM-1 — the unattended path (`--yes`) could not get the Makefile's list: `make` cannot pass `--yes`, an agent has no terminal for the prompt, so it would run the script directly on the defaults; rule 7 and `docs/01` still named the script | MEDIUM | FIXED: `make reset-task YES=1`; the script REFUSES `--yes` without `PROTECTED_BRANCHES`; rule 7, `docs/01`, the quick command and `scripts/README.md` point to `make reset-task`; checked in `/tmp` (protected `trunk` refused with `YES=1`; direct `--yes` refused; a feature branch cleaned) |
| MEDIUM-2 — the draft's Upgrading note missed: the guard's self-test (it must come with `settings.json`), `checkpoint.md` (customised HYBRID), `docs/04` (METHOD with slots: edge case 7), "no `make hooks-install`" true only from 1.3.1, the `Makefile` recipe to REPLACE (an additive union runs the script twice) | MEDIUM | FIXED in the draft: listed by class, the recipe and the quick-command line given in full |
| LOW-1 — Errata C11: "the method reads only one delimiter" ignores the opener (unchanged by 1.1.0); "gets a request" overstates | LOW | FIXED: "of the two delimiters 1.1.0 renamed", "can get" |
| LOW-2 — the guard's contract comment still said "a pass otherwise" | LOW | FIXED (exit 1, shown) |
| LOW-3 — `SETUP.md`: the PROJECT-MEMORY bullet unqualified; the upgrade window silent on the new notices | LOW | FIXED |
| LOW-4 — edge case 3 restated an exclusivity IMP-046 shows to be false; LEARNINGS' titles ambiguous between Step 3 and (b) | LOW | FIXED: "declared exceptions" for the PROJECT's memory lines, IMP-046 named for the method's own files; Step 3 sends LEARNINGS' titles to (b); IMP-046 annotated |
| LOW-5 — §2 still missed `SECURITY.md`'s slots and the sensitive list `docs/00` points to | LOW | FIXED |
| INFO — exported env overrode the Makefile's list (`?=`) | INFO | FIXED: plain `=`, command-line override kept |
| INFO — how an exit 1 is shown was not measured | INFO | MEASURED (below) |
| INFO — the unparseable-input path says "cannot run" though the guard ran; C12 wording; the "v1.1.0" reference in `SETUP.md`; plan bookkeeping | INFO | Wording and bookkeeping fixed; the unparseable-input message left as is (unreachable in practice) |

**F4, measured** (a nested `claude -p` session on this branch's payload, the guard file
removed): the main session's Bash call ran; the session transcript records an attachment
`hook_non_blocking_error`, `hookName` `PreToolUse:Bash`, whose stderr begins
"Failed with non-blocking status code: agent-git-guard: cannot run (exit 1): delegated
agents are blocked until it is repaired; this session is not". The model itself was not
shown it (its answer reported no warning): the notice is for the human, as intended.

## The anonymisation (task 8) — what it does and does not do
- Nine occurrences replaced by one neutral reference, "the client project" (or "the
  client's" for a possessive): `LEARNINGS.md` IMP-036 (Applied) and IMP-037 (Deferred),
  and five session notes of July 2026 (one heading included — cited nowhere by name). A
  confidentiality correction, not a rewrite of what the notes record; the append-only
  notes are touched for this reason only.
- **The published history keeps the name.** Every release tag from v0.3.0 to v1.3.1
  still carries it in `.claude/memory/` (checked with `git grep` per tag), and the
  repository is public: the anonymisation holds from v1.3.2 on only. Removing it from the
  history would mean rewriting published history — not done, and not proposed here. No
  commit message ever carried the name.

## Done
- `29df076` this note and the plan; `5c0426d` IMP-067; `1177abd` F4 (the wiring, its
  self-test, `docs/04`); `3de2cab` C13, the backtick, three §2 slots; `507217d`
  `reset-task`'s list moves to the `Makefile`; `e1c0039` B8 (rule 9); `1f1bc9f` C12
  (edge case 3 extended); `ebe5122` the anonymisation; `5afe3fe` the review applied; this
  checkpoint; the CHANGELOG 1.3.2 entry at `/integrate`.
- Verification: `make test-scripts` 4 of 4 PASS after every task; F4 RED on the v1.3.1
  wiring, then GREEN, then measured in a nested session's transcript; `reset-task` in
  throwaway repositories under `/tmp` (project list, `YES=1`, the direct `--yes` refusal,
  a feature branch cleaned); C13 on the real commitlint; the anonymisation by `git grep`
  on the tree and on every release tag.

## Problems encountered → cause → solution
1. A `cd` inside a compound command moved the session's working directory into
   `sessions/` → the shell keeps state between calls → absolute paths from then on.
2. A `reset-task` probe "did not clean" → `| head -1` closed the pipe and SIGPIPE killed the
   script before `git clean` → re-run without truncating the output.
3. A commit body line starting with "branches:" drew a commitlint warning (read as a
   trailer) → harmless; bodies avoid "word:" at the start of a line.
4. The phase-1 table missed two setup slots (`SECURITY.md`'s, the list `docs/00` points
   to) and the unattended `reset-task` path → found by the reviewer → fixed in task 9.

## Retro
Candidate lessons — offered, not recorded (the user listed this block's IMPs):
- **A "complete list" claim deserves a mechanical check.** The §2 checklist calls itself
  complete; twice now its gaps were found by hand. A `/lint-memory`-style check — every
  `[TO BE DEFINED AT SETUP]` marker of the payload named by a §2 item — would catch the
  next one when it is written (kin of IMP-038's inventory checks and IMP-049's (d)).
- **Moving an answer means checking every entry point.** The `reset-task` answer moved to
  the `Makefile`, and the direct, the `make` and the unattended (agent) paths each needed
  their own check — the reviewer found the third.

## Follow-up
- `/integrate`: v1.3.2 (PATCH); merge, tag and push are the user's.
- IMP-067 (headless, Agent SDK) and IMP-063..066 wait for the retro.

## Notes taken while planning
- `SETUP.md` has no exception called "A": the only exception to the empty-diff invariant
  on `.claude/memory/` is edge case 3 (pointers broken by a doc rename, `SETUP.md`:382 and
  :634-643), which does not cover format lines → extended in task 7, declared.
- The same translated-titles defect applies to LEARNINGS (`retro.md`:22-26 and
  `docs/06`:10-11, :68 cite "OPEN", "Applied", "Deferred", "Rejected") — part of the
  same C12 change as the original finding described it ("the STATE/LEARNINGS section
  titles"); included in the migration table, declared.
