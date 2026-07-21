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
- **End-of-deliverable cycle** (`.claude/docs/00-overview.md`): [if sensitive]
  `/security-review` → `/retro` → `/checkpoint` → `/integrate`.
- **Changes to the RULES go through an IMP proposal** in
  `.claude/memory/LEARNINGS.md` (`.claude/docs/06-self-improvement.md`): first the
  proposal, then the human decision, then the application in a dedicated commit.
- **Non-negotiable agnosticism**: the template contains no project-specific
  instances (stack, names, concrete values); where concreteness is needed, use
  `[TO BE DEFINED AT SETUP]`.

## This repo's git model (a declared exception)

The default the framework DESCRIBES has two branches (`.claude/docs/04`), but the
framework repo itself is **trunk-based on `main`**: the doc's two ROLES —
integration branch and stable branch — COINCIDE here (a case the doc itself
foresees). Concretely:

- deliverables go through a feature branch merged into `main` with `--no-ff` via
  the `/integrate` block, run by a human (a PR to yourself adds no control);
- annotated tags live on `main` in BOTH regimes (trunk-based: integration and
  stable coincide). Up to `v0.6.2` the repo was pre-1.0 (`v0.x.y`); **from
  `v1.0.0` it is in the post-1.0 regime** — the method's contract is declared
  stable and only the bump semantics change (a breaking change costs a MAJOR);
- in the shared history (commits, merges, tags) no specific project or client
  names — see the rule in docs/04, *Commit format*: for a template, agnosticism
  applies to the messages too, because pushed history is not rewritten.

**What counts as a breaking change for this framework** (what, post-1.0, triggers
a MAJOR): removing or renaming a command, an incompatible change to the memory
format or to the `[TO BE DEFINED AT SETUP]` markers, or a structural change that
breaks grafts or upgrades already under way on a project. It is an API's promise
of stability, applied to a method — the general, agnostic criterion is in
`.claude/docs/04-git-workflow.md`, *Versioning*.

## This repo's memory: the "declared hybrid" regime

The repo uses on itself only PART of its own memory system:

- **LIVE**: `.claude/memory/LEARNINGS.md` (the framework's IMP backlog — it is the
  loop from the README's *Philosophy*: lessons from use flow back into the
  template) and `.claude/memory/sessions/` (the journal of work on the framework).
- **Clean templates**, never populated here: `STATE.md`, `TREE.md`, `INDEX.md`,
  `components/`, `decisions/`, `plans/` — they stay ready to copy.

This is not an oversight: it is the choice that keeps the template copyable
without giving up the self-improvement loop. Whoever copies the template into
their own project EMPTIES the live part (instructions in `SETUP.md`, step 2).

Operational consequence of the regime: a heavy deliverable here does NOT create a
file in `plans/` — the plan lives in the session note as a standardised plan
block, one commit per task (see `.claude/docs/01-task-planning.md`, the box on the
hybrid regime, and `.claude/memory/sessions/README.md`).

## In practice, for a proposed change

A proposal can arise from work on this repo, or **come up from a client
project**: there the lesson is marked `Destination: framework` and
`/harvest-framework` produces a copyable block (already anonymised) to bring here
(see `.claude/docs/06-self-improvement.md`, *"The bridge to the framework"*).
Either way it becomes an IMP entry in `LEARNINGS.md`.

1. Open a feature branch from `main`.
2. Conventional commits, hooks installed, no secrets (gitleaks blocks them anyway).
3. If the change touches the method's rules or docs: attach the IMP entry (problem
   → proposal → benefit/risk) in `LEARNINGS.md`.
4. No references to specific projects or stacks in the template's files.

To report a vulnerability: [SECURITY.md](SECURITY.md).
