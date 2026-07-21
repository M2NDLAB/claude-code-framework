---
date: 2026-07-21
task: Targeted retro on IMP-043 (cross-file section titles) — registration, evaluation, application in reduced form
branch: main
status: completed
tags: [session, retro, imp, docs, process]
---
# Session 2026-07-21 — Targeted retro on IMP-043

> Short deliverable, below the heaviness threshold: three direct commits on `main`,
> no plan block (hybrid regime — see `01-task-planning.md`). It closes the last
> residue of the v1.1.0 translation ([[2026-07-20-language-rule-phase1]]): the lesson
> left behind by its single broken cross-reference.

## Done
- **`c97118b`** — registered IMP-043 as an OPEN proposal, in the form the deliverable
  suggested at first: pin the cross-file section titles in a canonical MAP before
  starting, as an artifact preceding the tasks in PHASE 2.
- **`ff7fbb6`** — applied IMP-043 in REDUCED form after the targeted retro: ~5 lines
  extending the coherence review that already existed in `01-task-planning.md`
  (*"Special case — cross-module refactor"*). No canonical-map artifact, no new
  planning step.
- **This checkpoint** — IMP-043 moved to *Applied* in [[LEARNINGS]] with the date and
  the sha, its rejected heavy version replaced by what actually went in, plus this note.

## The retro — what changed the proposal, and on which facts
The user asked for the evaluation to run through the anti-hype filter (how often does
this class of work really occur?). Checking the repo instead of arguing from memory
moved the recommendation away from what had been registered:

1. **Frequency: one occurrence in 122 commits.** The v1.1.0 translation is the only
   deliverable that renamed section titles across files. The closest candidate,
   [[2026-07-18-allineamento-doc-pubblica]], was alignment to reality (7 pinpointed
   divergences) and renamed nothing. → the conditional placement is mandatory; a step
   that fires on every deliverable would cost more than the friction it prevents.
2. **The gap was not awareness.** `e00efad` says it outright: *"That is exactly the
   broken-cross-reference risk flagged in phase 1"*. The risk analysis had predicted
   it with no rule telling it to, and the defect passed anyway — caught late by the
   fan-out agents' reports. → what was missing is a MECHANICAL check, not a warning.
   That sentence is now the justification carried by the doc.
3. **The "canonical map" is a query, not a file.** One grep enumerates the whole
   surface (~11 titles cited by name across `docs/`, README, SETUP, CONTRIBUTING);
   it was produced in a single command during the retro. → maintaining an artifact to
   replay a query is ceremony; the heavy version of the proposal was discarded.
4. **The right home already existed.** `01-task-planning.md:137` demanded "the shared
   API used the same way everywhere" — a model that already covers titles cited by
   name; only the text did not. → extend the existing check instead of adding a step.

## Problems encountered → cause → solution
1. Registering an IMP straight after a deliverable captures the lesson while the
   friction is still warm, but ALSO the first shape that comes to mind — here an
   artifact — → cause: the proposal was written with the deliverable's frustration in
   view, not with the frequency of the class of work → solution: the targeted retro
   was run against repo facts (commit counts, the actual cause of the defect, the cost
   of the alternative), and the proposal was applied in a reduced form. Registration
   and evaluation are two distinct moments on purpose; this deliverable is the case
   that shows why.

## Proposals
- No new IMP. The retro produced no residual friction: the two-step OPEN → evaluated →
  Applied cycle worked exactly as `06-self-improvement.md` describes it (the agent
  proposes, the human disposes — and here the human's decision reshaped the proposal).
- The DEFERRED entries were deliberately left untouched: their triggers have not fired,
  which is their correct state, not a backlog to work off.

## Versioning
Bump: **none**. Three commits, all `docs`/`chore`, no `feat` and no `fix`: per
`04-git-workflow.md` (*Versioning*) it is internal work, not a release. The public
contract of the method is unchanged — a conditional clarification inside a check that
already existed adds no capability and removes none. The version stays **v1.1.0**.

## Follow-up
- `feat/english-translation` is merged into `main` and can be deleted whenever the user
  wants; it is kept for now as the trace of the v1.1.0 deliverable.
- The next time a deliverable renames cross-file titles, the coherence review of
  `01-task-planning.md` is what must fire — and it is the occasion to check whether the
  grep really does prevent the defect that awareness alone did not.
