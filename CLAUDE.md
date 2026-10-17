# [PROJECT NAME] — Claude Code Index

Stack: [TO BE DEFINED AT SETUP] | Repo: [TO BE DEFINED AT SETUP]

> This file is the PROJECT's: the answers the method reads and the project's technical
> rules. The method itself — the rules that hold in every session — is
> `.claude/rules/fw-core.md`, which Claude Code loads at every launch; its docs in
> `.claude/docs/` are read when a task needs them, its procedures are the commands under
> `.claude/commands/fw/`, and the memory's `STATE.md` reaches the session through the
> SessionStart hook. Nothing here imports them.

## The answers the method reads

> One line per answer the method's rules and docs read; setup fills each in place of its
> setup marker (the framework's `SETUP.md`, step 2), and an answer may run on to the lines
> below its own.

- **Documentation** — where the project documentation lives (the core's rule 5; `docs/02`, DoD point 7): [TO BE DEFINED AT SETUP]
- **Sensitive components** — the components under the security gate (the core's rule 8; `docs/03`): [TO BE DEFINED AT SETUP]
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
>   (the core's rule 9). The language of the ARTIFACTS is not configurable — it is always
>   English; only this axis is yours.
> - **Deployment**: production artifact format, target environment.
> - **Project licence**: which licence THIS project adopts and who holds the
>   copyright. The framework does not impose one: the framework's own `LICENSE` (MIT)
>   covers the framework itself, NOT the projects that use it.
