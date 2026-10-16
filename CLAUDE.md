# [PROJECT NAME] — Claude Code Index

Stack: [TO BE DEFINED AT SETUP] | Repo: [TO BE DEFINED AT SETUP]

> This file is the **index** Claude Code reads to get its bearings: it points to the
> process documentation and to the persistent memory, and it fixes the
> non-negotiable rules. The rules below are about PROCESS (stack-agnostic); the
> project's technical rules go in the last section.

## Process documentation — imported below, so loaded whole at every launch
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
- If STATE.md was NOT injected at the start, the project's settings did not load — the
  session started outside the repository's root —, or its hooks are off: the boundary's
  wiring does not run (04-git-workflow.md). Say so to the user before anything else, and
  advise restarting Claude Code from the repository's root.
- AT THE END of a task: session note in memory/sessions/, update the components/
  notes you touched, rewrite STATE.md, regenerate TREE.md if the structure changed.
  **A task without updated memory is NOT done.**
- Use the /fw:checkpoint slash command to do memory + docs + commit in one go.

## Non-negotiable global rules (process)
1. **No secrets in plaintext** in the code or in committed config — only a secret
   manager or environment variables. The gitleaks hook refuses a `git commit` when it
   finds a secret in the staged changes (it is the baseline, with the limits that
   03-security-gate.md declares; see also the security gate, rule 8).
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
   aligned (where the project documentation lives: the answer **Documentation**, below). Same
   logic as the memory. Until the project documentation exists, record the debt in
   STATE.md.
6. **Self-improvement** per 06-self-improvement.md: FACTUAL corrections to the docs
   (in demonstrable disagreement with reality) you apply immediately; changes to
   RULES and process you PROPOSE in memory/LEARNINGS.md (IMP-nnn) and apply only
   after the user approves. **Never rewrite your own rules on your own initiative.**
7. **Task planning** per 01-task-planning.md: at the start of EVERY prompt judge its
   heaviness yourself; if it is heavy, produce a PLAN of atomic tasks in
   .claude/memory/plans/, commit it, then run ONE COMMIT PER TASK (`[task N/T]` in
   the message) ticking the plan as you go. If a session dies mid-task: do NOT
   start over and do NOT delete the branch — discard only the uncommitted half-done
   task (`make reset-task`) and resume from the first unticked task. The commits
   of completed tasks are never touched.
8. **Security gate** per 03-security-gate.md: on sensitive components
   (the answer **Sensitive components**, below) run /fw:security-review BEFORE the PR; HIGH/CRITICAL
   findings resolved, MEDIUM resolved or accepted as debt in STATE.md (with the
   reason), LOW at least recorded.
9. **Language** — two axes, and only one of them is yours to choose:
   - **ARTIFACTS: always English.** Everything that lands in the repo — code,
     comments, documentation, memory, future commit messages, IMP entries, session
     notes — is written in English. This is deliberately NOT a
     setup slot. The framework is opinionated here on purpose:
     English artifacts are the universal practice of open source, and they keep a
     project readable, greppable and portable beyond the people who started it. The
     trade-off is stated openly rather than hidden — on this one axis the framework
     imposes instead of staying agnostic, and it accepts the cost.
   - **INTERACTION: yours.** The language the agent speaks with you in session is a
     setup slot in the technical rules below. Talking to you in
     your own language costs the repo nothing, so nothing is imposed.
   The rule applies from the graft, or from the upgrade that brought it, onwards: to
   the method's artifacts and to the new ones the project produces; what already
   exists is never bulk-translated (translating it is a task the user decides). That
   protects the memory's CONTENT. Its FORMAT is method: the section titles and the
   field labels the commands look up by name take the method's form, and every upgrade
   brings the project's to it, leaving the content under them as it is — never a map
   from old to new, which every command would have to consult.
   Past git history is never translated: it is immutable (see 04-git-workflow.md).
10. **File tools for the method's files**: every edit to a file setup copies, the memory
    included — an answer, a resolved conflict, a renamed title — is made with the file
    tools on the text it changes, never with `sed -i`, a line number or a script, whatever
    the permission mode suggests (04-git-workflow.md, *Operating rules for Claude Code*).

## Quick commands
- Slash commands: `/fw:plan`, `/fw:checkpoint`, `/fw:integrate`, `/fw:sos`, `/fw:retro`,
  `/fw:security-review`, `/fw:new-component`, `/fw:lint-memory`, `/fw:harvest-framework`
- `make hooks-install` — install the git hooks (gitleaks + commitlint + the pre-push push boundary)
- `make test-scripts` — self-test of the framework scripts (hooks-install, the agent git guard, repo-snapshot, the prerequisite check, reset-task, the STATE injection)
- `make reset-task` — discard the interrupted half-done task (keeps commits; the
  protected branches are the Makefile's `PROTECTED_BRANCHES`; `YES=1` without asking)

## The answers the method reads

> One line per answer the method's rules and docs read; setup fills each in place of its
> setup marker (the framework's `SETUP.md`, step 2), and an answer may run on to the lines
> below its own.

- **Documentation** — where the project documentation lives (rule 5; `docs/02`, DoD point 7): [TO BE DEFINED AT SETUP]
- **Sensitive components** — the components under the security gate (rule 8; `docs/03`): [TO BE DEFINED AT SETUP]
- **Branches** — the integration and the stable branch, and the branching model if it is not the default (`docs/04`, *Branching model*): [TO BE DEFINED AT SETUP]
- **Merge** — via Pull Request or via the `/fw:integrate` block (`docs/04`, *Merge*): [TO BE DEFINED AT SETUP]
- **Public contract** — what the project promises its consumers, whose breaking is a MAJOR (`docs/04`, *Versioning*): [TO BE DEFINED AT SETUP]
- **Doc comments** — the language's documentation-comment tool (`docs/02`, *Comments*): [TO BE DEFINED AT SETUP]
- **Error format** — the structured, stable error format exposed to clients (`docs/02`, *Error handling*): [TO BE DEFINED AT SETUP]
- **Formatter / linter** — what the pre-commit hook runs (`docs/02`; `scripts/hooks-install.sh`): [TO BE DEFINED AT SETUP]
- **Production artifact** — its format for a deployable component (`docs/02`, DoD point 9): [TO BE DEFINED AT SETUP]

---

## Project-specific technical rules: [TO BE DEFINED AT SETUP]

> This is where the technology choices and the conventions the framework does NOT
> impose belong. Fill it in when you set the project up. Examples of what to
> document (remove the ones that do not apply, add your own):
>
> - **Stack**: language(s), frameworks, runtime, versions.
> - **Build & run**: build, test, lint and local-start commands (as Makefile targets
>   too).
> - **Standard structure of a component** (for /fw:new-component): module layout,
>   packaging conventions.
> - **Code conventions** specific to the language (formatter/linter used by the
>   hook, naming, idioms).
> - **API design**: versioning, error format, pagination, date/money formats, etc.
> - **Data**: datastores in use, naming conventions, migration handling.
> - **Tests**: framework, coverage thresholds, what requires an integration test.
> - **Interaction language**: which language the agent speaks with you in session
>   (rule 9). The language of the ARTIFACTS is not configurable — it is always
>   English; only this axis is yours.
> - **Deployment**: production artifact format, target environment.
> - **Project licence**: which licence THIS project adopts and who holds the
>   copyright. The framework does not impose one: the framework's own `LICENSE` (MIT)
>   covers the framework itself, NOT the projects that use it.
