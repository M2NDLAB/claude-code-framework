# [PROJECT NAME] — Claude Code Index

Stack: [TO BE DEFINED AT SETUP] | Repo: [TO BE DEFINED AT SETUP]

> This file is the **index** Claude Code reads to get its bearings: it points to the
> process documentation and to the persistent memory, and it fixes the
> non-negotiable rules. The rules below are about PROCESS (stack-agnostic); the
> project's technical rules go in the last section.

## Process documentation — load ONLY the files relevant to the task
- @.claude/docs/00-overview.md            — the method, the end-of-deliverable cycle, selective loading
- @.claude/docs/01-task-planning.md       — task plan for heavy prompts, resilient resumption
- @.claude/docs/02-code-quality.md        — comments, error handling, Definition of Done
- @.claude/docs/03-security-gate.md       — mandatory review on sensitive components
- @.claude/docs/04-git-workflow.md        — when to commit, branch, merge, rollback
- @.claude/docs/05-escalation-protocol.md — structured report when you get stuck
- @.claude/docs/06-self-improvement.md    — doc corrections, IMP backlog, retrospective

## Persistent memory — MANDATORY in every session
- AT THE START of a session: read @.claude/memory/STATE.md (injected by the
  SessionStart hook) and the .claude/memory/components/ notes of the components the
  task actually touches; read TREE.md before exploring the filesystem by hand. Check
  whether an in-progress plan exists in .claude/memory/plans/ for the requested
  prompt (see rule 7).
- AT THE END of a task: session note in memory/sessions/, update the components/
  notes you touched, rewrite STATE.md, regenerate TREE.md if the structure changed.
  **A task without updated memory is NOT done.**
- Use the /checkpoint slash command to do memory + docs + commit in one go.

## Non-negotiable global rules (process)
1. **No secrets in plaintext** in the code or in committed config — only a secret
   manager or environment variables. The gitleaks hook blocks commits that violate
   this rule (it is the baseline; see also the security gate, rule 8).
2. **Code quality** per 02-code-quality.md: the WHY in comments, no swallowed
   exceptions, validation at the edge, Definition of Done respected.
3. **Git** per 04-git-workflow.md: a branch for every feature, commits at logical
   checkpoints and BEFORE risky changes, Conventional Commits, never push without
   the user's confirmation.
4. **Escalation** per 05-escalation-protocol.md: stuck after 2 reasoned attempts, or
   facing a fork the docs and recorded decisions do not cover? Do NOT push on
   blindly: produce an ESCALATION REPORT and stop. The answer comes back as an
   ARCHITECT RESPONSE block — carry it out per the protocol.
5. **Documentation updated** TOGETHER with the change: a change that touches user
   features, procedures, APIs or deployment is not done until the documentation is
   aligned (where the project documentation lives: [TO BE DEFINED AT SETUP]). Same
   logic as the memory. Until the project documentation exists, record the debt in
   STATE.md.
6. **Self-improvement** per 06-self-improvement.md: FACTUAL corrections to the docs
   (in demonstrable disagreement with reality) you apply immediately; changes to
   RULES and process you PROPOSE in memory/LEARNINGS.md (IMP-nnn) and apply only
   after the user approves. **Never rewrite your own rules on your own initiative.**
7. **Task planning** per 01-task-planning.md: at the start of EVERY prompt judge its
   heaviness yourself; if it is heavy, produce a PLAN of atomic tasks in
   .claude/memory/plans/, commit it, then run ONE COMMIT PER TASK (`[task N/T]` in
   the message) ticking the plan as you go. If a session is interrupted: do NOT
   start over and do NOT delete the branch — discard only the uncommitted half-done
   task (scripts/reset-task.sh) and resume from the first unticked task. The commits
   of completed tasks are never touched.
8. **Security gate** per 03-security-gate.md: on sensitive components
   ([TO BE DEFINED AT SETUP]) run /security-review BEFORE the PR; HIGH/CRITICAL
   findings resolved, MEDIUM resolved or accepted as debt in STATE.md (with the
   reason), LOW at least recorded.
9. **Language** — two axes, and only one of them is yours to choose:
   - **ARTIFACTS: always English.** Everything that lands in the repo — code,
     comments, documentation, memory, future commit messages, IMP entries, session
     notes — is written in English. This is deliberately NOT a
     [TO BE DEFINED AT SETUP] slot. The framework is opinionated here on purpose:
     English artifacts are the universal practice of open source, and they keep a
     project readable, greppable and portable beyond the people who started it. The
     trade-off is stated openly rather than hidden — on this one axis the framework
     imposes instead of staying agnostic, and it accepts the cost.
   - **INTERACTION: yours.** The language the agent speaks with you in session is a
     [TO BE DEFINED AT SETUP] slot in the technical rules below. Talking to you in
     your own language costs the repo nothing, so nothing is imposed.
   Past git history is never translated: it is immutable (see 04-git-workflow.md).

## Quick commands
- Slash commands: `/checkpoint`, `/integrate`, `/sos`, `/retro`, `/security-review`,
  `/new-component`, `/lint-memory`, `/harvest-framework`
- `make hooks-install` — install the git hooks (gitleaks + commitlint)
- `make test-scripts` — self-test of the framework scripts (hooks-install)
- `./scripts/reset-task.sh` — discard the interrupted half-done task (keeps commits)

---

## Project-specific technical rules: [TO BE DEFINED AT SETUP]

> This is where the technology choices and the conventions the framework does NOT
> impose belong. Fill it in when you set the project up. Examples of what to
> document (remove the ones that do not apply, add your own):
>
> - **Stack**: language(s), frameworks, runtime, versions.
> - **Build & run**: build, test, lint and local-start commands (as Makefile targets
>   too).
> - **Standard structure of a component** (for /new-component): module layout,
>   packaging conventions.
> - **Code conventions** specific to the language (formatter/linter used by the
>   hook, naming, idioms).
> - **API design**: versioning, error format, pagination, date/money formats, etc.
> - **Data**: datastores in use, naming conventions, migration handling.
> - **Tests**: framework, coverage thresholds, what requires an integration test.
> - **Sensitive components** subject to the security gate (rule 8).
> - **Where the project documentation lives** (rule 5).
> - **Interaction language**: which language the agent speaks with you in session
>   (rule 9). The language of the ARTIFACTS is not configurable — it is always
>   English; only this axis is yours.
> - **Deployment**: production artifact format, target environment.
> - **Project licence**: which licence THIS project adopts and who holds the
>   copyright. The framework does not impose one: its own `LICENSE` (MIT) covers the
>   framework itself, NOT the projects that use it — see `SETUP.md`.
