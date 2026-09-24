---
date: 2026-09-24
task: verify on the source and record the 16 lessons of a client project's third real upgrade (v1.0.0 → v1.2.0) — IMP-049..053 recorded, IMP-046 and IMP-037 annotated, four factual defects listed for the user
branch: main
status: completed
model: 'claude-opus-5-5'
turns: 1
tags: [session, imp, upgrade, verification]
---
# Session 2026-09-24 — Lessons of the third real upgrade: verification and recording

> Verification + recording only (user constraint): nothing applied, no `docs/` touched,
> no `plans/` (hybrid regime). Two files, so no plan block. The lessons were relayed
> second-hand from the client's upgrade session, so each one was verified on the
> source BEFORE being recorded; a non-reproducible one would have been declared and
> left out (none was).

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session throughout. Delegated work: 15
  workflow agents (6 verifiers, 6 adversarial skeptics, 3 pre-commit reviewers), all
  inheriting the main model.
- `turns: 1` — the recording prompt. Not counted: the background-task notifications,
  and the two IMP-048 messages earlier in this same session (2026-09-23), whose work is
  recorded in `bf83956`, not in this note.

## Done
- **Verification** (one workflow): 6 verifiers by group of lessons, each followed by a
  skeptic mandated to overturn every verdict in BOTH directions (a CONFIRMED the source
  does not support, a NOT REPRODUCIBLE the verifier under-searched). Read-only on this
  repo and on the client's clone; experiments only in a throwaway directory (3-way
  merges with the real templates, `hooks-install.sh` in a linked worktree, commitlint
  run offline).
- **Outcome**: 0 not reproducible; 8 CONFIRMED, 8 PARTIALLY CONFIRMED (the core holds,
  the wording or the scope was corrected before recording — see the table).
- **Pre-commit review** (a second workflow, 3 reviewers: facts of the entries, facts of
  this note, fidelity + format): 20 must-fix findings (several raised by more than one
  reviewer), all corrected before the commit, and the nits applied — wrong counts, a
  motive attributed to the client that its own records contradict, churn figures that
  mixed churn with conflict mass, an incomplete account of B4.
- **Recorded in [[LEARNINGS]]** (OPEN): IMP-049 payload purity (A1-A3), IMP-050 upgrade
  procedure hardening (B4, B5, B6, B9, B10), IMP-051 memory one merge behind (D15),
  IMP-052 verify before continuing after an interruption (D14), IMP-053 gate verdict
  always written (D16). Annotated: IMP-046 (evidence B7), IMP-037 (case #3 — counter
  3 of 2-3, trigger fired on the count, decision at the retro; B6 as input).

## Verification, lesson by lesson
Line refs are on `main` (= v1.2.0 for every file except `LEARNINGS.md`) unless a tag is
given.

| Lesson | Verdict | Recorded as | Key evidence — and the correction applied |
| --- | --- | --- | --- |
| A1 | CONFIRMED | IMP-049 (1) | `settings.json`:31, `lint-memory.md`:46,50,52, `docs/03`:10, `docs/06`:28,80,100, `CLAUDE.md`:110; also `harvest-framework.md`:73, `docs/01`:82, `LEARNINGS.md` header. Not new in v1.2.0: present since v0.x, back with every upgrade that touches the file. No CI in any tag. |
| A2 | CONFIRMED | IMP-049 (2) | 10 occurrences, 6 numbers, 4 files; `harvest-framework.md`:13 cites IMP-009. The client pruned that cite at its first upgrade, when it was only an orphan; v1.2.0 re-proposes it, and it now COLLIDES with the client's own IMP-009 (recorded after that upgrade). |
| A3 | PARTIAL | IMP-049 (3) | `docs/01`:80-97 and :155-158, `sessions/README.md`:99-117. "At every upgrade" → only when `vY` touches them. The blocks self-scope; the client drops them as framework-repo-specific (its own recorded decision), and they also carry A1/A2's pointers and numbers. |
| B4 | CONFIRMED | IMP-050 (1) | `SETUP.md`:361-363 ("two checkouts (or exports)"), :394-397 (CHANGELOG read, no ref). Reflog: 22:31:15 detached at `v1.2.0`, 22:54:36 back to `main` + commit — see below. |
| B5 | PARTIAL | IMP-050 (2) | No `$FW`/`-C` in `SETUP.md`; the client has tags `v1.2.0`, `v1.3.0`, `v1.4.0`; a bare `git show v1.2.0:<path>` from its directory returns ITS file. "Every command" → every FRAMEWORK-side command. |
| B6 | CONFIRMED | IMP-050 (3) | No churn/strategy/inventory in `SETUP.md`; v1.0.0→v1.2.0 = 31 payload files, +1801/−1701; `CLAUDE.md` 3-way: 161 of 197 lines in conflict. Not "drop the 3-way": a strategy per file, measured. |
| B7 | CONFIRMED | IMP-046 evidence | Client `sessions/README.md` = template blob of v0.2.0-v0.5.0; client `decisions/README.md` answers the ADR slot (template :12) → a HYBRID filed by `SETUP.md` as both METHOD and PROJECT-MEMORY. |
| B8 | CONFIRMED | factual defect | The prospective boundary of rule 9 is only in `SETUP.md`:284-290; `CLAUDE.md`:63-75 has none for docs/memory. |
| B9 | PARTIAL | IMP-050 (4) | One slot, not "new slots": the marker-less bullet `CLAUDE.md`:104-106 under the heading marker :86. CHANGELOG 1.1.0 names it (:46-48) and Step 2 reads the CHANGELOG — the link to Step 4 is what is missing. |
| B10 | PARTIAL | IMP-050 (5) | `hooks-install.sh`:16-17 hard-codes `.git/hooks`. Linked worktree: loud abort; the false green comes from the workarounds. Rollback: `FORCE_OVERWRITE=1` OR manual removal of the hooks (safer: FORCE clobbers the pre-upgrade `.bak`). |
| C11 | PARTIAL | factual defect | The promise is in `CHANGELOG.md`:58-65 ([1.1.0]), NOT in `docs/05`. Only the closers were legacy (`FINE REPORT` / `FINE RESPONSE`); `docs/05`:71-83 shows one form; `91f0ca7` never touched `docs/05`. Not IMP-020 class: worst case is a request to paste again. |
| C12 | PARTIAL | factual defect | Materially undeclared in the CHANGELOG: two changes beyond translation (the Applied-section format comment dropped, `0c50dad`; the `/checkpoint` placeholder standardised to `<integration>`, only in the `46f6bb1` body) and one behaviour-bearing translation (the STATE/LEARNINGS section titles, cited by name elsewhere, absent from 1.1.0's "needs no migration" list). The H1 titles and the plan headings are cosmetic translations. |
| C13 | CONFIRMED | factual defect | `docs/04`:35-36 and `checkpoint.md`:45-46 prescribe `wip:`; `commitlint.config.cjs`:4-10 rejects it (`wip: test` → rc=1, commitlint 21.2.3 offline); since v0.1.0. `chore: wip …` passes. |
| D14 | PARTIAL | IMP-052 | The status/`git log` half exists (`docs/01` RESUMPTION); missing: syntax/build, tests, design comparison, and in-session interruptions. `/sos` is the wrong home (it ends in STOP). |
| D15 | PARTIAL | IMP-051 | This repo: `95e43bd`, `d8d4036`, `b576f37`, `21ab017` (+ `eaefae3`/`ec59010`, `48fe236`). Here the session notes lag, not STATE (a template). Declined once at v0.3.0 — the recurrence is the new fact. |
| D16 | CONFIRMED | IMP-053 | `docs/00`:76-80 "skip it"; 4 of the 13 earlier notes record the verdict; one sensitive client deliverable has no gate record. |

## B4 — this repo's own part in the incident
The "parallel session that moved HEAD mid-upgrade" was, on this repo's side, THIS
session, during its earlier IMP-048 prompt (2026-09-23). At 22:39 it found the repo
detached at `v1.2.0` (detached at 22:31 to prepare the upgrade) and reported it; from
22:41 it edited `LEARNINGS.md`; it proposed `git switch main`, and at 22:53 the user
explicitly ordered the switch and the commit, run at 22:54 (`bf83956`). Neither side
knew the upgrade was reading that working tree — which is the point of IMP-050 (1):
nothing marks the framework's tree as in use, so even a human-approved switch breaks
the read. Nothing an upgrade transfers changed (`bf83956` only adds an OPEN entry to
`LEARNINGS.md`, a hybrid whose IMP entries are never carried over). Today's recording
prompt made no checkout in this repo and did not touch the client's.

## Factual defects — awaiting the user's decision (NOT applied)
- **B8** — the prospective boundary of rule 9 (approved in IMP-040) lives only in
  `SETUP.md`, outside the payload. Copying it next to rule 9 syncs the docs with an
  approved decision (Level 1 candidate), but it edits `CLAUDE.md` rule 9 → the user
  decides. Beyond the lesson: the clause is phrased for GRAFTS ("from the graft
  onwards"); it says nothing about a project that upgrades ACROSS v1.1.0, whose
  post-graft artifacts predate rule 9 — that part needs a decision.
- **C11** — a choice: narrow the 1.1.0 CHANGELOG sentence to the readers that exist
  (Level 1: a doc that lies), or add a dual-form clause to `docs/05` *HOW to handle the
  answer* (Level 2).
- **C12** — Level 1 candidate: an "Upgrading" note for 1.1.0, like the one 1.2.0
  carries, listing the dropped Applied format comment, the placeholder standardisation
  and the section titles cited by name.
- **C13** — a choice: add `wip` to the type-enum (config, Level 2; then `docs/04`'s type
  list and bump table too), or reword `docs/04`:35-36 and `checkpoint.md`:45-46 to an
  allowed type (`chore: wip …`).
- **Side finding** (verified, not in the reported list): `SETUP.md` §2 calls its
  checklist "the complete list, grouped by file" (:72), yet four setup slots of the
  payload are in none of its items: `decisions/README.md`:12 (where formal ADRs live),
  `docs/04`:72 (which merge form the project adopts), `docs/04`:123 (what the public
  contract is), `scripts/reset-task.sh`:20 (the protected branches). Only the generic
  grep catches them — Level 1.

## Problems encountered → cause → solution
1. This session's verification brief assumed the third upgrade had left no trace in
   the client's clone → true of that upgrade's read-only PHASE 1, from which the
   lessons were relayed; its PHASE 2 (the execution, authorised in the other session)
   ran on a new branch while the verification ran (plan + tasks 1-13 of 13) → the
   client-side verdicts cite the client's `main`; the upgrade branch is corroboration
   only, never the source of a verdict.
2. Three skeptics lowered a CONFIRMED to PARTIAL (A3, B5, B10): each verifier had listed
   the lesson's overstatements in its own corrections yet kept CONFIRMED → the entries
   record the corrected scope, not the relayed wording.
3. The first draft of the entries carried errors that only an independent review caught
   (see *Done*) → a pre-commit review workflow, author ≠ judge, before committing.

## Security gate
Not sensitive (process memory only) → `/security-review` skipped.

## Follow-up
- Retro over the open backlog, in priority order: the upgrade cluster first (IMP-050
  points 1-2 before the client's next upgrade, IMP-046, IMP-037 with its trigger fired,
  IMP-049), then the quick fixes (C13, C11, B8, C12, the `SETUP.md` §2 slots), then the
  process IMPs (IMP-053, IMP-048 with the IMP-043 unification question, IMP-051,
  IMP-052, IMP-047).
- Push of this commit: the user's.
