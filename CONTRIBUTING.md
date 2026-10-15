# Contributing to claude-code-framework

Collaboration is WELCOME, not required: the [MIT](LICENSE) licence lets you use,
copy and modify the framework without owing anything in return. But if you do
want to give something back — a correction, a process lesson, an improvement to
the method — this file says how, in the way the framework itself uses on itself.

> Want to USE the template in a project of your own rather than contribute to it?
> Start from [SETUP.md](SETUP.md).

## This repo's workflow

This repo applies to itself the method it describes (`.claude/docs/`):

- **Feature branch** for every significant change (`feat/...`, `fix/...`,
  `docs/...`): never work directly on the integration branch.
- **Conventional Commits**, checked by the commit-msg hook: types in
  `commitlint.config.cjs`, format and rules in
  `.claude/docs/04-git-workflow.md`. Install the hooks with `make hooks-install`
  (requires gitleaks and Node.js).
- **End-of-deliverable cycle** (`.claude/docs/00-overview.md`): [if under the gate]
  `/fw:security-review` → `/fw:retro` → `/fw:checkpoint` → `/fw:integrate`.
- **Every framework command lives under `.claude/commands/fw/`**, and is invoked as
  `/fw:<name>`. A command file directly under `.claude/commands/` takes a bare name, and a
  bare name can be one of Claude Code's own: a project command replaces the built-in
  command of the same name, and was measured hiding a built-in's alias too — silently, in
  every project that copies it, and a later built-in can do the same the other way round. A
  new command goes under `fw/` only: Claude Code's built-in commands are listed on its
  [commands page](https://code.claude.com/docs/en/commands). The documentation check
  fails a command file outside `fw/`.
- **Changes to the RULES go through an IMP proposal** in
  `.claude/memory/LEARNINGS.md` (`.claude/docs/06-self-improvement.md`): first the
  proposal, then the human decision, then the application in a dedicated commit.
- **Non-negotiable agnosticism**: the template contains no project-specific
  instances (stack, names, concrete values); where concreteness is needed, use
  `[TO BE DEFINED AT SETUP]`.
- **The setup marker marks slots only.** In the payload the literal marker is written only
  in a slot step 2 of `SETUP.md` lists: prose calls it the setup marker, and code that must
  match it writes a split form (`TO BE DEFINED A[T] SETUP`), so every line the setup and
  upgrade greps print from the framework's files is a slot to fill. The documentation check
  fails a marker in a METHOD file, which an upgrade would overwrite.
- **`tools/` holds this repository's own tools**, outside the payload: the upgrade's
  verification script, the documentation check and their self-tests (`tools/README.md`).
  `make test-scripts` runs the documentation check here, after its self-test: what it
  finds is fixed in the release that brings it. Its guarded line in the `Makefile`, the
  comment above it and the conditional line at the top of `docs/01` are the only text of
  the payload that holds only here: in a project, where `tools/` is absent, the line does
  nothing.
  The CI runs `bash tools/test-upgrade-check.sh` on every push too, after
  `make test-scripts` (*The CI, before the merge*, below): it fails when a payload file has
  no class.
- **Every commit is gated on the suite, in the same command**:
  `make test-scripts && bash tools/test-upgrade-check.sh && git commit …` — the self-tests,
  the documentation check and the upgrade check's self-test, not only the test of the file
  touched; the generated hooks with the real tools (`tools/test-real-hooks.sh`) run in the
  CI. The one exception is the `chore: wip` commit `docs/04` allows on a feature branch
  before a session closes. The suite reads the working tree, not the index: a commit of
  part of the tree is green only if the rest is too.
- **A change to a HYBRID file keeps away from the slots** (the classes: `SETUP.md`, *The
  mental model: the classes of file, and the graft state*). Between the lines a change
  touches and a line a project answers at setup — a `[TO BE DEFINED AT SETUP]` marker, a
  placeholder setup replaces, an answer with no marker (`SETUP.md` §2) — at least one line
  stays unchanged: a change on the adjacent line conflicts in every project's 3-way merge,
  one unchanged line in between merges cleanly (measured with `git merge-file`, git 2.54.0).
  A blank line is a weak separator, which the diff may align on either side of a change.
  Where a change must land on such a line, the CHANGELOG's *Upgrading* note names the
  conflict and its resolution. Every release that changes a HYBRID file rehearses the
  upgrade before `/fw:integrate`, on a project with every setup answer in place, with LF and
  with CRLF line ends.

## This repo's git model (a declared exception)

The default the framework DESCRIBES has two branches (`.claude/docs/04`), but the
framework repo itself is **trunk-based on `main`**: the doc's two ROLES —
integration branch and stable branch — COINCIDE here (a case the doc itself
foresees). Concretely:

- deliverables go through a feature branch merged into `main` with `--no-ff` via
  the `/fw:integrate` block, run by a human (a PR to yourself adds no control);
- annotated tags live on `main` in BOTH regimes (trunk-based: integration and
  stable coincide). Up to `v0.6.2` the repo was pre-1.0 (`v0.x.y`); **from
  `v1.0.0` it is in the post-1.0 regime** — the method's contract is declared
  stable and only the bump semantics change (a breaking change costs a MAJOR);
- in the shared history (commits, merges, tags) no specific project or client
  names — see the rule in docs/04, *Commit format*: for a template, agnosticism
  applies to the messages too, because pushed history is not rewritten.

**The CI, before the merge — block 0.** The CI (`.github/workflows/test.yml`) runs
`make test-scripts`, the upgrade check's self-test, the prerequisite check and the generated
hooks with the real gitleaks and commitlint (`tools/test-real-hooks.sh`) on macOS, Linux and
Windows, on what is pushed — and a deliverable's branch otherwise stays local until
`/fw:integrate`. So, in
this repository, the human runs a block 0 before `/fw:integrate`'s block 1: push the feature
branch (`git push -u origin <branch>`) and wait until the CI is green on the three
platforms. Block 1 then checks that the tree it merges is the one the CI tested — the merge
commit's tree equal to the pushed branch's —, and block 2 deletes the remote branch in the
same atomic push that publishes `main` and the tag
(`git push --atomic origin main vX.Y.Z :<branch>`), before the local `git branch -d`.
Atomic means all or nothing: if the remote branch is already gone, git refuses the whole
push and publishes nothing — drop `:<branch>` and run it again. A
project's `/fw:integrate` knows nothing of this: a project's CI is the project's own.

**No required status checks on `main` — a motivated choice.** The ruleset of `main` does
not require the CI's checks. `/fw:integrate`'s merge commit is new — block 1 creates it
locally, with `--no-ff` — and the CI has no result for it when block 2 pushes it: a
required check would refuse that push. The gate is block 0 instead, with block 1's check
that the merged tree is the tested one.

**What counts as a breaking change for this framework** (what, post-1.0, triggers
a MAJOR): removing or renaming a command, an incompatible change to the memory
format or to the `[TO BE DEFINED AT SETUP]` markers, or a structural change that
breaks grafts or upgrades already under way on a project. It is an API's promise
of stability, applied to a method — the general, agnostic criterion is in
`.claude/docs/04-git-workflow.md`, *Versioning*.

**What this framework ships — the test of a release** (IMP-047, decided on 2026-10-10;
the general rule is `.claude/docs/04-git-workflow.md`, *Versioning*, "When the
documentation IS the product"). A deliverable is a release, with a tag, when it changes
what projects receive:
- the PAYLOAD that setup copies (`SETUP.md`, step 1): `.claude/` as setup copies it —
  commands, docs, settings and the memory's starting files, not the framework's own IMP
  entries and session notes —, `CLAUDE.md`, `Makefile`, `commitlint.config.cjs`,
  `.gitignore`, `.gitattributes`, `scripts/`; and the `SECURITY.md` scaffold setup offers;
- what a project's setup and upgrade take from this repo at a tag without copying it:
  `SETUP.md`'s procedures and the upgrade's verification script, `tools/upgrade-check.sh`,
  which runs in its version at the tag `vY` (IMP-037). An upgrade targets a tag: a change to
  them that cut no tag would reach no project.

The bump is at least a PATCH; a MINOR or a MAJOR by the criteria of `docs/04`,
*Versioning*. A change confined to the framework's own memory (`LEARNINGS.md`'s entries,
`sessions/`) or to files that serve this repo only (`README.md`, this file, `LICENSE`,
the checks and the CI that run only here) is no tag.

## This repo's memory: the "declared hybrid" regime

The repo uses on itself only PART of its own memory system:

- **LIVE**: `.claude/memory/LEARNINGS.md` (the framework's IMP backlog — it is the
  loop from the README's *Philosophy*: lessons from use flow back into the
  template) and `.claude/memory/sessions/` (the journal of work on the framework).
- **Clean templates**, never populated here: `STATE.md`, `TREE.md`, `INDEX.md`,
  `components/`, `decisions/`, `plans/` — they stay ready to copy. So an open thread that
  awaits the user, which `/fw:checkpoint` carries into a project's `STATE.md`, lives here in
  the newest session note and in `LEARNINGS.md`, where the resumption looks (below).

This is not an oversight: it is the choice that keeps the template copyable
without giving up the self-improvement loop. Whoever copies the template into
their own project EMPTIES the live part (instructions in `SETUP.md`, step 2).

### A heavy deliverable here: the plan lives in the session note

`.claude/docs/01-task-planning.md` keeps the plan of a heavy deliverable in `plans/` and
its structural decision in `decisions/`; here both would dirty the templates, and the doc
says so in one line. The plan and the assessment live elsewhere, with the SAME resumption
checkpoints:

- WHAT/WHY (plan + decision) → an IMP entry in `LEARNINGS.md` and/or the session note;
- PHASES and resumption context → the session note, in a **standardised plan block**
  (below): the note is plan-pointer and journal at once;
- resumption GRANULARITY → the `[task N/T]` commits (`docs/01`, PHASE 3, unchanged);
- COMPLETION (`docs/01`, PHASE 4) → `status: completed` in the frontmatter of the session
  NOTE, not of a plan file.

This specific rule prevails over the general one (`plans/`) in this repository only; in a
project the framework is grafted onto, `plans/` and `decisions/` remain fully valid. At
the start of a session the in-progress plan is the **plan block of the most recent
session note**: `plans/` stays empty here, and looking only there would wrongly conclude
"nothing in progress".

**The plan block** has the structure of the `plans/` checklist — a checkbox, an atomic
task and its sha, one per task:

```markdown
## Plan (one commit per task)
- [x] 1. <atomic task> — commit: <sha>
- [ ] 2. <atomic task> — commit: —
```

Commit the note, with the block's skeleton, as the FIRST task: it is the plan-pointer
resilient to an immediate crash — the equivalent of `plans/`'s `chore: plan for …`. On
completion: `status: completed` in the note's frontmatter.

**The `Destination: framework` attribute is moot here**: every IMP of this backlog is
already a lesson about the framework, so no entry carries it, and `/fw:harvest-framework` —
a command for the projects that use the framework — has nothing to collect.

## In practice, for a proposed change

A proposal can arise from work on this repo, or **come up from a client
project**: there the lesson is marked `Destination: framework` and
`/fw:harvest-framework` produces a copyable block (already anonymised) to bring here
(see `.claude/docs/06-self-improvement.md`, *"The bridge to the framework"*).
Either way it becomes an IMP entry in `LEARNINGS.md`.

**A harvested lesson counts once.** Each entry of the block carries the project's entry
number and its source note's date. Before recording it, look for that pair among the
lessons already received — the session notes of earlier recordings list them, with a
neutral label for the project, never its name: a repeat is evidence on the existing entry,
never a new entry nor a second occurrence. The project's number is written as "the
project's entry 012", never as an IMP number, which would collide with this backlog's.

1. Open a feature branch from `main`.
2. Conventional commits, hooks installed, no secrets (gitleaks blocks them anyway).
3. If the change touches the method's rules or docs: attach the IMP entry (problem
   → proposal → benefit/risk) in `LEARNINGS.md`.
4. No references to specific projects or stacks in the template's files.

To report a vulnerability: [SECURITY.md](SECURITY.md).
