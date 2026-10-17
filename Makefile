# Framework process commands — stack-agnostic.
# `make` or `make help` for the list.
# The project's build/test/run targets do NOT belong here: add them in the
# project's section at the bottom.

.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

hooks-install: ## Install the git hooks (gitleaks + commitlint + the pre-push push boundary)
	bash scripts/hooks-install.sh

# [TO BE DEFINED AT SETUP] the branches reset-task must never touch: your integration and
# stable branches (docs/04). Example defaults below. A plain `=`, not `?=`: an exported
# environment variable must not silently replace the project's list; one run can still
# override it on the command line: make reset-task PROTECTED_BRANCHES="main trunk".
# YES=1 discards without asking — the user's form, never an agent's (the core's Resumption);
# make reads YES from the environment too, and any non-empty value skips the question.
PROTECTED_BRANCHES = main develop

reset-task: ## Discard the interrupted half-done task, preserving branch and commits (YES=1: no prompt)
	PROTECTED_BRANCHES="$(PROTECTED_BRANCHES)" bash scripts/reset-task.sh $(if $(YES),--yes)

# The last line runs the framework repository's own documentation check — tools/ is never
# copied into a project, where the line does nothing.
test-scripts: ## Self-test of the framework scripts (hooks-install, the agent git guard, repo-snapshot, the prerequisite check, reset-task, the STATE injection)
	bash scripts/test-hooks-install.sh
	bash scripts/test-agent-git-guard.sh
	bash scripts/test-repo-snapshot.sh
	bash scripts/test-check-prerequisites.sh
	bash scripts/test-reset-task.sh
	bash scripts/test-state-inject.sh
	@if [ -f tools/docs-check.mjs ]; then bash tools/test-docs-check.sh && node tools/docs-check.mjs; fi

# ============================================================================
# [TO BE DEFINED AT SETUP] — the project's build/test/run targets.
# Examples (adapt them to your stack):
#
# build: ## Build the project
# 	<build command>
#
# test: ## Run the tests
# 	<test command>
#
# run: ## Start locally
# 	<start command>
# ============================================================================
