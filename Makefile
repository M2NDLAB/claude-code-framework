# Framework process commands — stack-agnostic.
# `make` or `make help` for the list.
# The project's build/test/run targets do NOT belong here: add them in the
# "[TO BE DEFINED AT SETUP]" section at the bottom.

.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

hooks-install: ## Install the git hooks (gitleaks + commitlint; formatting to be enabled)
	bash scripts/hooks-install.sh

reset-task: ## Discard the interrupted half-done task, preserving branch and commits (task planning)
	bash scripts/reset-task.sh

test-scripts: ## Self-test of the framework scripts (hooks-install, ...)
	bash scripts/test-hooks-install.sh

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
