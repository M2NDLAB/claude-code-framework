#!/usr/bin/env bash
# Installa i git hook locali del framework:
#   - pre-commit : secret scanning (gitleaks) — SEMPRE
#   - commit-msg : Conventional Commits (commitlint) — SEMPRE
#   - pre-commit : formattazione automatica del codice — ESEMPIO da adattare allo stack
# Idempotente: sovrascrive gli hook precedenti installati da questo script.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_DIR="${REPO_ROOT}/.git/hooks"

# --- Prerequisiti -----------------------------------------------------------
if ! command -v gitleaks >/dev/null 2>&1; then
  echo "ERRORE: gitleaks non installato (è la regola 1 di CLAUDE.md, non opzionale)." >&2
  echo "  macOS: brew install gitleaks   |   altri: https://github.com/gitleaks/gitleaks" >&2
  exit 1
fi
if ! command -v npx >/dev/null 2>&1; then
  echo "ERRORE: npx (Node.js) non installato — serve per commitlint." >&2
  exit 1
fi

mkdir -p "${HOOKS_DIR}"

# --- pre-commit -------------------------------------------------------------
cat > "${HOOKS_DIR}/pre-commit" <<'HOOK'
#!/usr/bin/env bash
# Hook generato da scripts/hooks-install.sh — non modificare a mano.
set -euo pipefail

# 1. Secret scanning sui file staged (regola 1: nessun secret committato). SEMPRE.
gitleaks protect --staged --redact -v

# 2. FORMATTAZIONE AUTOMATICA — [DA DEFINIRE AL SETUP].
#    Decommentare e adattare al/i linguaggio/i del progetto. L'idea: applicare il
#    formatter ai SOLI file staged e ri-stagearli, così non si accumula drift e non
#    servono commit di sola formattazione. Esempi (scegline uno o più, adattali):
#
#    # --- Esempio A: formatter "di linguaggio X" su tutti i file staged di un tipo ---
#    # staged="$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(EXT)$' || true)"
#    # if [[ -n "${staged}" ]]; then
#    #   echo "${staged}" | xargs <formatter> --write     # es. comando del tuo formatter
#    #   echo "${staged}" | xargs git add                 # ri-stagea i file riformattati
#    # fi
#
#    # --- Esempio B: formatter per-pacchetto (monorepo), con cwd nel pacchetto ---
#    # per risolvere config e plugin locali del pacchetto:
#    # for pkg_bin in <dir>/*/node_modules/.bin/<formatter>; do
#    #   [[ -x "${pkg_bin}" ]] || continue
#    #   pkg_dir="${pkg_bin%/node_modules/.bin/<formatter>}"
#    #   staged="$(git diff --cached --name-only --diff-filter=ACM \
#    #     | grep -E "^${pkg_dir}/.*\.(EXT)$" || true)"
#    #   if [[ -n "${staged}" ]]; then
#    #     rel="$(echo "${staged}" | sed "s#^${pkg_dir}/##")"
#    #     ( cd "${pkg_dir}" && echo "${rel}" | xargs ./node_modules/.bin/<formatter> --write )
#    #     echo "${staged}" | xargs git add
#    #   fi
#    # done
#
#    Nota: il linter (es. eslint, ruff, ecc.) di solito resta il GATE della CI,
#    non gira nell'hook — qui si fa solo la formattazione (veloce, deterministica).
HOOK

# --- commit-msg -------------------------------------------------------------
cat > "${HOOKS_DIR}/commit-msg" <<'HOOK'
#!/usr/bin/env bash
# Hook generato da scripts/hooks-install.sh — non modificare a mano.
# Conventional Commits, config in commitlint.config.cjs.
set -euo pipefail
npx --yes --package @commitlint/cli --package @commitlint/config-conventional \
  commitlint --edit "$1"
HOOK

chmod +x "${HOOKS_DIR}/pre-commit" "${HOOKS_DIR}/commit-msg"
echo "OK: hook pre-commit (gitleaks) e commit-msg (commitlint) installati."
echo "    Ricorda di abilitare la formattazione automatica nell'hook pre-commit (vedi commenti)."
