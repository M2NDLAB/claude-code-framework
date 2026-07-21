# Claude Code Framework

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/github/v/tag/M2NDLAB/claude-code-framework?label=version&sort=semver)](https://github.com/M2NDLAB/claude-code-framework/tags)

A reusable working framework for projects run with Claude Code, **agnostic to the
technology stack**. It contains no application code and no technology choices: what
it carries is the *method* — how to structure the collaboration with Claude Code so
that it is resilient, traceable and self-improving.

Extracted from a real project (an enterprise platform) and refined over dozens of
sessions, this framework captures what works regardless of the domain: e-commerce,
SaaS, data pipelines, anything.

## What it includes

- **Persistent memory system** — STATE, TREE, INDEX, sessions, decisions,
plans, improvement backlog, with a consistency health-check (`/lint-memory`).
Claude Code keeps context across sessions.
- **Resilient task planning** — heavy prompts are broken into atomic tasks with
one commit each; an interruption never costs you a restart from scratch.
- **Escalation protocol** — when Claude Code gets stuck at a fork, it produces
a structured report instead of pushing on blindly.
- **Self-improvement (IMP)** — process lessons become improvement proposals
approved by the human, never self-applied; the ones useful to any project travel
back up to the template through the project→framework bridge (`/harvest-framework`).
- **Security gate & git workflow** — mandatory review on sensitive components,
conventional commits, SemVer versioning on annotated tags, a paste-ready "ready for
integration" block, pre-commit hooks (secret scan + formatting).
- **Grafting and upgrading** — it starts from scratch (greenfield), grafts onto an
existing project (brownfield) and upgrades in place (`vX → vY`) preserving the
memory accumulated so far, with the `.claude/framework-version` provenance pin as a
certain baseline for the upgrade (procedures in `SETUP.md`).

## What it does NOT include (by design)

No specific technology. No languages, no frameworks, no databases. Those are added
by each project at setup, in the spots marked `[TO BE DEFINED]`.

## How to use it

In short (the full guide, with the list of every `[TO BE DEFINED AT SETUP]` to fill
in, is in **[SETUP.md](SETUP.md)**):

1. **Copy** the framework contents into the root of your new project (the
   `.claude/` folder, plus `CLAUDE.md`, `Makefile`, `commitlint.config.cjs`,
   `.gitignore`, `scripts/`), then create the provenance pin
   `.claude/framework-version` with the version you just copied (`SETUP.md`, step 1).
2. **Fill in the `[TO BE DEFINED AT SETUP]`** — above all in `CLAUDE.md` (project
   name, stack, technical rules, sensitive components) and in the spots listed in
   `SETUP.md`. By hand, or in dialogue with Claude Code, which interviews you and
   writes the answers down (see `SETUP.md`, step 2).
3. **Install the hooks**: `make hooks-install` (requires `gitleaks` and Node.js for
   commitlint). Enable automatic formatting in the hook for your language.
4. **First command to Claude Code** — have it read `CLAUDE.md` and the docs in
   `.claude/docs/`, then initialise the memory (`STATE.md`, `TREE.md`). The exact
   suggested command is in `SETUP.md`.

From there on you work with the cycle described in `.claude/docs/00-overview.md`:
plan → execute task by task → [if sensitive] `/security-review` → `/retro` →
`/checkpoint` → `/integrate` (push decided by the human); if you get stuck, `/sos`.

> Grafting the framework onto an **existing** project (brownfield)? The steps are
> the same, with the differences — reconciling colliding files, an initial
> assessment that populates the memory, inherited git hygiene — covered in the
> dedicated section at the end of `SETUP.md`.
>
> Do you instead need to **upgrade** to a newer version a project that already has
> the framework grafted, preserving the memory accumulated so far? That is the third
> case, with its own procedure (*"Evolving the framework"*), also at the end of
> `SETUP.md`.

### Structure

```
.
├── CLAUDE.md                  index + process rules + technical rules [TO BE DEFINED]
├── README.md                  this file
├── SETUP.md                   how to start from scratch, list of the [TO BE DEFINED]
├── LICENSE                    MIT — covers the framework, not the projects using it
├── CONTRIBUTING.md            how to contribute TO the framework (the repo's real workflow)
├── SECURITY.md                security policy (real for the repo + scaffold [TO BE DEFINED])
├── CHANGELOG.md               Keep a Changelog, wired to the versioning of docs/04
├── Makefile                   process targets only (hooks-install, reset-task, test-scripts)
├── commitlint.config.cjs      Conventional Commits types
├── .gitignore                 baseline (secrets + IDE/OS) + [TO BE DEFINED] section
├── scripts/
│   ├── hooks-install.sh       gitleaks + commitlint (always) + formatting (example)
│   ├── reset-task.sh          surgical cleanup of the interrupted task
│   ├── test-hooks-install.sh  self-test of hooks-install (make test-scripts)
│   └── README.md
└── .claude/
    ├── settings.json          SessionStart hook (injects STATE.md) + permissions (secret scan: pre-commit hook)
    ├── docs/                  00-overview, 01-task-planning ... 06-self-improvement
    ├── commands/              /checkpoint /integrate /sos /retro /security-review /new-component /lint-memory /harvest-framework
    └── memory/                STATE, TREE, INDEX, LEARNINGS (template) + 4 subfolders
```

## Philosophy

The framework improves with use: every project you build on top of it generates
process lessons that come back here as improvements for the next one. In the
project those lessons are marked `Destination: framework`, and `/harvest-framework`
collects them into a block ready to be re-proposed here (see
`.claude/docs/06-self-improvement.md`, *"The bridge to the framework"*).
