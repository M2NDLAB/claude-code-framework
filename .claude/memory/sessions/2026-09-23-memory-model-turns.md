---
date: 2026-09-23
task: IMP-044, model and turns in the session-note frontmatter (assessment 2026-09-22, application 2026-09-23); IMP-045 deferred, IMP-046 and IMP-047 recorded
branch: feat/memory-model-turns
status: completed
model: 'claude-opus-5-5[1m]'
turns: 2
tags: [session, memory, imp, retro]
---
# Session 2026-09-23 — `model` and `turns` in the session-note frontmatter

> Small deliverable, below the heaviness threshold (5 files): no plan block (hybrid
> regime). It records the read-only assessment of 2026-09-22 — kept in the chat until
> the user's decision, as the user asked to stop there — and its application. This is
> the FIRST note that carries the two new fields.

## The fields of this very note
- `model: 'claude-opus-5-5[1m]'` — the main session throughout (the model switch
  happened before the first prompt), verbatim as the runtime exposed it. Delegated work:
  of the 11 workflow agents, the runtime-research one ran on a smaller model (it reported
  `claude-haiku-4-5-20251001`) and returned a turn-counting heuristic stated as VERIFIED
  but wrong — discarded after checking the real transcript; the other ten inherited the
  main model.
- `turns: 2` — the assessment prompt (2026-09-22) and the decisions D1-D5 (2026-09-23).
  Not counted: the local model/effort commands, one automatic self-scheduled wake-up
  that re-sent the assessment instructions, the background-task notifications. Frozen
  with this checkpoint: the `/integrate` step that follows is not counted.

## Done
- **Assessment (2026-09-22)**: scouting of `main`, a research workflow (runtime facts,
  touchpoint map, YAML + lint audit with a real parser), a draft, then an adversarial
  verification with 5 lenses (facts, design, contract, brief, completeness). The
  verification changed the draft on three points: `turns` per NOTE instead of per task,
  IMP provenance NOT traceable today (2 of 43 Origins cite a note), and single instead
  of double quotes (backslash escapes).
- **User decisions (2026-09-23)**: D1 `turns` per note, the per-deliverable value summed
  later by `branch`; D2 IMP format `Origin: [[<session note>]] — <problem>`; D3 the
  minimal format inline in `/checkpoint`; D4 the SETUP contradiction as IMP-046, OPEN
  only, separate commit; D5 MINOR v1.2.0 via `feat(memory)`, the deviation declared. S2:
  IMP-037's counter at 2 real upgrades, bookkeeping only.
- `cc628db` — IMP-044 recorded (with the excluded fields and their reasons) and IMP-045
  straight to Deferred (no N; the user's trigger; lineage IMP-027/037/042).
- `184529e` — **IMP-044 applied**: `sessions/README.md` (the two fields in the Format
  block + the section *"The `model` and `turns` fields"*), `checkpoint.md` step 3 (the
  minimal format inline), the Origin line of the IMP format in `LEARNINGS.md`.
- `dfccd29` — IMP-046 recorded as an OPEN proposal (separate commit).
- `cdf862f` — refinements from a pre-checkpoint adversarial review (3 lenses): the
  refresh formula could count a message twice; the reopen and delegated-writer cases;
  the `/checkpoint` clause completed (it is the only carrier to upgraded projects);
  IMP-045's helper counts deliverables; IMP-046 names the stranded D2 line and dates the
  contradiction to v0.5.0; the excluded fields also under *Rejected*.
- **This checkpoint** — IMP-044 moved to *Applied* with its shas; IMP-037 counter
  annotated (case #2); IMP-047 recorded by the end-of-deliverable `/retro`; this note.

## Problems encountered → cause → solution
1. The working tree was DETACHED at `v1.1.0` while `main` was 4 commits ahead, with
   IMP-043 already used → the session started from a tag checkout → everything was read
   from `main`, the branch was created from `main`, IMP numbering resumed at 044.
2. A research agent proposed counting turns from the transcript as `type:"user"` entries
   without `isMeta` → tool results are `type:"user"` entries too (dozens against a single
   real prompt) → verified on the real transcript (docs/02, *verify against real
   artifacts*); the rule counts from the conversation.
3. The draft said `turns` per task, cumulative across sessions → a note is not a task (a
   resumed deliverable got a new note here too: 2026-07-14 → 2026-07-17) and the
   cumulative rule double counts → D1.
4. A scratch cleanup with `rm -rf` was denied by `settings.json` → the deny rule working
   as intended → a fresh scratch directory instead.
5. The git hooks are not installed in this clone → commit headers checked by hand; the
   review ran the real commitlint on the first three commits: 0 errors (one
   non-blocking `footer-leading-blank` warning on `184529e`).

## Factual doc corrections (Level 1, docs/06)
- `/harvest-framework`: its block claims the format of a framework IMP, which D2 made
  stale — the harvested Origin now excludes local session-note wikilinks, and the
  framework assigns its own `[[<session note>]]` (in `cdf862f`).

## Proposals
- IMP-044 (Applied), IMP-045 (Deferred), IMP-046 (OPEN — the upgrade invariant vs the
  memory templates), IMP-047 (OPEN, from the `/retro` of this deliverable — `/integrate`'s
  "doc-only → no tag" versus the contract of a method project; recurring: v0.4.0 and
  now v1.2.0).

## Versioning
Bump: **MINOR → v1.2.0**, user decision D5 — an optional memory field is MINOR under
`docs/04`; typed `feat(memory)`, a DECLARED deviation from `integrate.md` step 2 and the
`chore(claude)` type of `docs/06` (now IMP-047). The `[1.2.0]` CHANGELOG entry also
lists IMP-043, shipped on `main` after v1.1.0 but never logged.

## Follow-up
- A dedicated retro for IMP-046 (a BUG: the contradiction), IMP-047 and IMP-037 (its
  trigger is close: 2 of 2-3 upgrades).
- IMP-045 resumes when ~20 deliverables carry `turns` (helper in the entry).
- `feat/english-translation` is still there, merged: deletable whenever the user wants.
