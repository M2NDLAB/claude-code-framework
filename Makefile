# Comandi di processo del framework — agnostici allo stack.
# `make` o `make help` per la lista.
# I target di build/test/run del progetto NON stanno qui: aggiungili nella
# sezione "[DA DEFINIRE AL SETUP]" in fondo.

.DEFAULT_GOAL := help

help: ## Mostra questo help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

hooks-install: ## Installa gli hook git (gitleaks + commitlint; formattazione da abilitare)
	bash scripts/hooks-install.sh

reset-task: ## Scarta il mezzo-task interrotto, preservando branch e commit (task planning)
	bash scripts/reset-task.sh

test-scripts: ## Self-test degli script del framework (hooks-install, ...)
	bash scripts/test-hooks-install.sh

# ============================================================================
# [DA DEFINIRE AL SETUP] — target di build/test/run del progetto.
# Esempi (da adattare allo stack):
#
# build: ## Builda il progetto
# 	<comando di build>
#
# test: ## Esegue i test
# 	<comando di test>
#
# run: ## Avvia in locale
# 	<comando di avvio>
# ============================================================================
