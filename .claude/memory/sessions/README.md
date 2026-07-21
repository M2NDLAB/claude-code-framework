# sessions/ — working journal (append-only)

One note for every significant **working session**. It is the project's narrative
memory: *what was done, what went wrong and how it was solved, what was decided on
the fly*. Unlike `STATE.md` (which gets rewritten and is a dashboard of the
present), session notes are **append-only**: they are not modified after the fact,
they accumulate. They are the first line of defence against "why on earth did we do
it this way?" — and the best source of improvement proposals (see
`docs/06-self-improvement.md`).

## When to write one
At the end of a task/session, typically inside `/checkpoint`. An escalation
(`docs/05`) is recorded here too, with its ID. And ALWAYS before a `/clear` or a
model switch, if the chat holds expensive work not yet persisted (an assessment, a
review, decisions taken on the fly): the chat context is lost, the note is not —
and the next prompt will be able to POINT at the note instead of rebuilding it.

## Naming
`YYYY-MM-DD-<short-slug>.md` — e.g. `2026-06-14-setup-iniziale.md`,
`2026-06-15-modulo-pagamenti.md`. The leading date keeps the chronological order.

## Format
```markdown
---
date: YYYY-MM-DD
task: <what was being done>
branch: <git branch>
status: completed | in-progress | blocked
tags: [session, <area>]
---
# Session YYYY-MM-DD — <title>

## Done
- <itemised list of what was produced, with the relevant commits/shas>

## Problems encountered → cause → solution
1. <symptom> → <root cause> → <fix>

## Factual doc corrections (Level 1, docs/06)
- <doc aligned to reality, if it happened>

## Proposals
- IMP-nnn (in LEARNINGS.md): <any improvement proposal that emerged>

## Follow-up
- <any open threads picked up at a later date>
```

## Plan block — the framework repo's hybrid regime

In the *framework* repo heavy deliverables do NOT use `plans/` (clean template,
IMP-024): the session note acts as a **plan-pointer**, hosting the plan in a
STANDARDISED block — so plan and journal live in a single artefact and resumption
always finds it in the same place (see the "Hybrid regime" box in
`docs/01-task-planning.md`). In client projects `plans/` is used instead.

Same structure as the `plans/` checklist: checkbox + atomic task + sha, one per task.

```markdown
## Plan (one commit per task)
- [x] 1. <atomic task> — commit: <sha>
- [ ] 2. <atomic task> — commit: —
```

Commit the note (with the block's skeleton) as the FIRST task: it is the
plan-pointer resilient to an immediate crash — the equivalent of `plans/`'s
`chore: plan for …`. On completion: `status: completed` in the note's frontmatter.

> This README stays as a guide; the session notes live alongside it.
