#!/usr/bin/env bash
# Installa i git hook locali del framework:
#   - pre-commit : secret scanning (gitleaks) — SEMPRE
#   - commit-msg : Conventional Commits (commitlint) — SEMPRE
#   - pre-commit : formattazione automatica del codice — ESEMPIO da adattare allo stack
# Idempotente sui PROPRI hook (riconosciuti dal marcatore nel file generato).
# Hook preesistenti di ALTRA origine: lo script si FERMA invece di sovrascriverli;
# override esplicito con FORCE_OVERWRITE=1, che prima li salva in <hook>.bak.
# Se core.hooksPath è impostato (es. husky), si ferma: git ignorerebbe .git/hooks
# e questi hook risulterebbero installati ma inerti.
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

# --- Guardie per un repo con hook preesistenti (innesto su progetto esistente) --
# 1. core.hooksPath attivo (es. husky): git NON legge .git/hooks, quindi gli hook
#    scritti qui sotto non verrebbero MAI eseguiti — installati ma inerti. Meglio
#    fermarsi e far decidere l'utente che dare falsa sicurezza.
hooks_path="$(git -C "${REPO_ROOT}" config --get core.hooksPath || true)"
if [[ -n "${hooks_path}" ]]; then
  echo "ERRORE: core.hooksPath è impostato a '${hooks_path}': git ignora .git/hooks," >&2
  echo "  quindi gli hook del framework non verrebbero mai eseguiti. Scegli:" >&2
  echo "  - integra i comandi di questi hook nel tuo hook manager (es. husky), oppure" >&2
  echo "  - rimuovi l'override (git config --unset core.hooksPath) e rilancia." >&2
  exit 1
fi

# 2. Hook preesistenti NON generati da questo script (nessun marcatore): non si
#    sovrascrivono alla cieca — potrebbero appartenere alla pipeline del progetto
#    ospite. Con FORCE_OVERWRITE=1 si procede, salvando prima un backup .bak.
MARKER="Hook generato da scripts/hooks-install.sh"
for hook in pre-commit commit-msg; do
  target="${HOOKS_DIR}/${hook}"
  if [[ -f "${target}" ]] && ! grep -q "${MARKER}" "${target}"; then
    if [[ "${FORCE_OVERWRITE:-0}" == "1" ]]; then
      cp "${target}" "${target}.bak"
      echo "AVVISO: hook '${hook}' preesistente salvato in ${target}.bak (FORCE_OVERWRITE=1)." >&2
    else
      echo "ERRORE: esiste già un hook '${hook}' non installato da questo script." >&2
      echo "  Integra a mano i suoi comandi con quelli del framework, oppure rilancia con" >&2
      echo "  FORCE_OVERWRITE=1 per sovrascriverlo (prima viene salvato in ${hook}.bak)." >&2
      exit 1
    fi
  fi
done

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
