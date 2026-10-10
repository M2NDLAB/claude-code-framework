#!/usr/bin/env bash
# Self-test of tools/upgrade-check.sh, hermetic: throwaway repositories under a mktemp
# directory, git configured from nothing (no global or system config, no inherited git
# environment), no network. It runs the REAL script end to end.
#
# Cases:
#   1. classes — every payload file of THIS repository's HEAD has a class (with a floor on
#      the counts, so an empty or broken listing cannot pass), and a file added to the
#      payload without one makes it fail.
#   2. preflight — on a throwaway framework (tags v1.0.0, v1.0.1, v1.1.0) and a project
#      grafted at v1.0.0: a sound pin passes; a version without its v, a commit that is
#      the tag object, a commit of another release, an unset FW or FW = the project fail;
#      a tag on the pinned commit is suggested, never applied.
# Run it from anywhere: bash tools/test-upgrade-check.sh
set -euo pipefail

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${TOOLS_DIR}/.." && pwd)"
CHECK="${TOOLS_DIR}/upgrade-check.sh"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT
# No repository above the throwaway ones may be discovered by accident.
export GIT_CEILING_DIRECTORIES="${workdir}"
out="${workdir}/out.log"

fail() {
  echo "FAIL (upgrade-check): $1" >&2
  [ -f "${out}" ] && { echo "--- last output ---" >&2; cat "${out}" >&2; }
  exit 1
}
# A git with a fixed identity and no signing, for the throwaway commits and tags.
g() { git -c user.name=self-test -c user.email=self-test@example.invalid \
          -c commit.gpgSign=false -c tag.gpgSign=false "$@"; }
# run <expected rc> <cwd> <args...>: run the script, keep its output in ${out}.
run() {
  local expected="$1" dir="$2"
  shift 2
  set +e
  ( cd "${dir}" && bash "${CHECK}" "$@" ) >"${out}" 2>&1
  rc=$?
  set -e
  [ "${rc}" -eq "${expected}" ] || fail "upgrade-check $* (in ${dir}): exit ${rc}, expected ${expected}"
}
has()  { grep -qF -- "$1" "${out}" || fail "expected a line with: $1"; }
hasnt() { ! grep -qF -- "$1" "${out}" || fail "unexpected line with: $1"; }

# --- Case 1: classes ------------------------------------------------------------------
FW="${REPO_ROOT}" run 0 "${workdir}" classes HEAD
for class in METHOD HYBRID TEMPLATE LEARNINGS PROJECT-MEMORY; do
  grep -q "^${class} " "${out}" || fail "classes HEAD: no file of class ${class}"
done
[ "$(grep -c '^METHOD ' "${out}")" -ge 15 ] || fail "classes HEAD: fewer than 15 METHOD files"
[ "$(grep -c '^HYBRID ' "${out}")" -ge 8 ] || fail "classes HEAD: fewer than 8 HYBRID files"
[ "$(grep -c '^TEMPLATE ' "${out}")" -eq 4 ] || fail "classes HEAD: not exactly 4 TEMPLATE files"
hasnt "NONE"
mkdir -p "${workdir}/fw-new/.claude/agents"
g init -q "${workdir}/fw-new"
echo x > "${workdir}/fw-new/CLAUDE.md"
echo x > "${workdir}/fw-new/.claude/agents/reviewer.md"
g -C "${workdir}/fw-new" add -A
g -C "${workdir}/fw-new" commit -q -m "chore: a payload file without a class"
FW="${workdir}/fw-new" run 1 "${workdir}" classes HEAD
has "FAIL   no class for .claude/agents/reviewer.md"
echo "PASS (upgrade-check classes): every payload file of HEAD has a class; a new one without fails."

# --- The fixture: a throwaway framework with three releases, a project grafted at v1.0.0
FWD="${workdir}/fw"
PRJ="${workdir}/project"
T_DIR="${workdir}/T"
mkdir -p "${T_DIR}"
# put <root> <path> <content>: write a file, creating its directory.
put() { mkdir -p "$(dirname "$1/$2")"; printf '%b' "$3" > "$1/$2"; }

g init -q -b main "${FWD}"
put "${FWD}" CLAUDE.md '# Index\nStack: [TO BE DEFINED AT SETUP]\nRule A: the framework first wording.\nRule B: unchanged text.\n'
put "${FWD}" Makefile 'reset-task:\n\tbash scripts/reset-task.sh\n'
put "${FWD}" .gitignore '.env\n'
put "${FWD}" commitlint.config.cjs 'module.exports = {};\n'
put "${FWD}" .claude/settings.json '{}\n'
put "${FWD}" .claude/docs/00-overview.md '# 00\nThe method.\n'
put "${FWD}" .claude/docs/04-git-workflow.md '# 04\nMerge form: [TO BE DEFINED AT SETUP]\n'
put "${FWD}" .claude/commands/checkpoint.md 'checkpoint, first version\n'
put "${FWD}" .claude/commands/sos.md 'sos\n'
put "${FWD}" .claude/memory/STATE.md '# STATE\n\n## Stato avanzamento\n- template\n\n## Branch attivi\n- template\n'
put "${FWD}" .claude/memory/TREE.md '# TREE\n'
put "${FWD}" .claude/memory/INDEX.md '# INDEX\n'
put "${FWD}" .claude/memory/LEARNINGS.md '# Learnings\nHeader, first version.\n\n## Proposte APERTE (in attesa di decisione utente)\n\n<!-- Formato di una proposta:\n### IMP-001 — <titolo>\n- Data: YYYY-MM-DD | Origine: <sessione>\n- Problema osservato: <...>\n-->\n\n## Applicate\n\n## Rimandate (non respinte — si riprendono al momento giusto)\n\n## Rifiutate (con motivo — per non riproporle)\n'
put "${FWD}" .claude/memory/components/README.md 'components, first version\n'
put "${FWD}" .claude/memory/plans/README.md 'plans, first version\n'
put "${FWD}" .claude/memory/sessions/README.md 'sessions, first version\nThe plan block of the framework repo.\n'
put "${FWD}" .claude/memory/decisions/README.md 'decisions\nADR home: [TO BE DEFINED AT SETUP]\nend\n'
put "${FWD}" scripts/reset-task.sh '#!/usr/bin/env bash\n# [TO BE DEFINED AT SETUP] the protected branches\nPROTECTED_BRANCHES="main develop"\necho reset\n'
put "${FWD}" scripts/hooks-install.sh '#!/usr/bin/env bash\nfor hook in pre-commit commit-msg pre-push; do\n  :\ndone\n'
put "${FWD}" scripts/test-repo-snapshot.sh 'echo removed in 1.1.0\n'
put "${FWD}" SETUP.md '# SETUP\n## 2. Fill in the slots\n- [ ] CLAUDE.md: the stack\n- [ ] docs/04: the merge form\n## 3. Hooks\n'
put "${FWD}" CHANGELOG.md '# Changelog\n\n## [1.0.0] — 2026-01-01\n- First release.\n'
g -C "${FWD}" add -A && g -C "${FWD}" commit -q -m "feat: 1.0.0" && g -C "${FWD}" tag -a v1.0.0 -m v1.0.0

put "${FWD}" CLAUDE.md '# Index\nStack: [TO BE DEFINED AT SETUP]\nRule A: the framework first wording.\nRule B: fixed in 1.0.1.\n'
put "${FWD}" CHANGELOG.md '# Changelog\n\n## [1.0.1] — 2026-01-02\n- Rule B fixed.\n\n**Upgrading from 1.0.0**: CLAUDE.md, rule B.\n\n## [1.0.0] — 2026-01-01\n- First release.\n'
g -C "${FWD}" commit -q -am "fix: 1.0.1" && g -C "${FWD}" tag -a v1.0.1 -m v1.0.1

put "${FWD}" CLAUDE.md '# Index\nStack: [TO BE DEFINED AT SETUP]\nRule A: the framework second wording.\nRule B: fixed in 1.0.1.\n'
put "${FWD}" Makefile '# [TO BE DEFINED AT SETUP] the branches reset-task must never touch\nPROTECTED_BRANCHES = main develop\nreset-task:\n\tPROTECTED_BRANCHES="$(PROTECTED_BRANCHES)" bash scripts/reset-task.sh\n'
put "${FWD}" scripts/reset-task.sh '#!/usr/bin/env bash\nPROTECTED_BRANCHES="${PROTECTED_BRANCHES:-main develop}"\necho reset\n'
chmod +x "${FWD}/scripts/reset-task.sh"
put "${FWD}" .claude/docs/00-overview.md '# 00\nThe method, revised.\n'
put "${FWD}" .claude/memory/sessions/README.md 'sessions, second version\nThe plan block of the framework repo.\n'
put "${FWD}" .claude/memory/STATE.md '# STATE\n\n## Progress\n- template\n\n## Active branches\n- template\n'
put "${FWD}" .claude/memory/LEARNINGS.md "# Learnings\nHeader, second version.\n\n## OPEN proposals (awaiting the user's decision)\n\n<!-- Format of a proposal:\n### IMP-001 — <title>\n- Date: YYYY-MM-DD | Origin: <session>\n- Observed problem: <...>\n-->\n\n## Applied\n\n## Deferred (not rejected — resumed at the right time)\n\n## Rejected (with the reason — so they are not re-proposed)\n"
rm "${FWD}/scripts/test-repo-snapshot.sh"
put "${FWD}" SETUP.md '# SETUP\n## 2. Fill in the slots\n- [ ] CLAUDE.md: the stack\n- [ ] docs/04: the merge form\n- [ ] Makefile: PROTECTED_BRANCHES\n## 3. Hooks\n'
put "${FWD}" CHANGELOG.md '# Changelog\n\n## [1.1.0] — 2026-01-03\n- The protected branches move to the Makefile.\n\n**Upgrading from 1.0.1**: move your protected branches to the Makefile first.\n\n## [1.0.1] — 2026-01-02\n- Rule B fixed.\n\n**Upgrading from 1.0.0**: CLAUDE.md, rule B.\n\n## [1.0.0] — 2026-01-01\n- First release.\n'
mkdir -p "${FWD}/tools" && cp "${CHECK}" "${FWD}/tools/upgrade-check.sh"
g -C "${FWD}" add -A && g -C "${FWD}" commit -q -m "feat: 1.1.0" && g -C "${FWD}" tag -a v1.1.0 -m v1.1.0

# The project: v1.0.0's payload, its answers and customisations, its own memory.
mkdir -p "${PRJ}"
g -C "${FWD}" archive v1.0.0 -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore scripts | tar -x -C "${PRJ}"
put "${PRJ}" CLAUDE.md '# Index\nStack: bash\nRule A: the project own wording.\nRule B: unchanged text.\n'
put "${PRJ}" .claude/docs/00-overview.md '# 00\nThe method, our way.\n'
put "${PRJ}" scripts/reset-task.sh '#!/usr/bin/env bash\n# the protected branches: main and dev\nPROTECTED_BRANCHES="main dev"\necho reset\n'
put "${PRJ}" .claude/memory/decisions/README.md 'decisions\nADR home: docs/adr\nend\n'
put "${PRJ}" .claude/memory/sessions/README.md 'sessions, first version\n'
put "${PRJ}" .claude/memory/STATE.md '# STATE\n\n## Stato avanzamento\n- the project is under way\n\n## Branch attivi\n- main\n'
put "${PRJ}" .claude/memory/LEARNINGS.md '# Learnings\nHeader, first version.\n\n## Proposte APERTE (in attesa di decisione utente)\n\n### IMP-001 — A lesson of the project\n- Data: 2026-01-02 | Origine: a session\n- Problema osservato: something recurs\n- Proposta: do it once\n\n<!-- Formato di una proposta:\n### IMP-001 — <titolo>\n- Data: YYYY-MM-DD | Origine: <sessione>\n- Problema osservato: <...>\n-->\n\n## Applicate\n\n## Rimandate\n\n## Rifiutate (con motivo — per non riproporle)\n'
put "${PRJ}" .claude/memory/sessions/2026-01-02-start.md '# The first session\nSee [[STATE]] and docs/04-git-workflow.md.\nA fact of the project.\n'
FW_V100_SHORT="$(g -C "${FWD}" rev-parse --short 'v1.0.0^{commit}')"
put "${PRJ}" .claude/framework-version "# The provenance pin.\nversion: v1.0.0     # the framework tag\ncommit: ${FW_V100_SHORT}\ngrafted: 2026-01-02\n"
g init -q -b main "${PRJ}"
g -C "${PRJ}" add -A && g -C "${PRJ}" commit -q -m "chore: graft the framework v1.0.0"
pin() { put "${PRJ}" .claude/framework-version "$1"; }
pin_good="$(cat "${PRJ}/.claude/framework-version")"

# --- Case 2: preflight ----------------------------------------------------------------
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" preflight v1.0.0 v1.1.0
has "OK     version: v1.0.0"
has "OK     commit: ${FW_V100_SHORT}"
has "INFO   releases from v1.0.0 to v1.1.0: v1.0.1 v1.1.0"
has "OK     this copy of upgrade-check.sh is v1.1.0's"
pin "version: 1.0.0\ncommit: ${FW_V100_SHORT}\ngrafted: 2026-01-02\n"
FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" preflight v1.0.0 v1.1.0
has "it must read 'version: vX.Y.Z'"
has "SUGGESTION, not applied: the tag on the pinned commit is v1.0.0"
grep -q '^version: 1.0.0$' "${PRJ}/.claude/framework-version" || fail "preflight changed the pin"
pin "version: v1.0.0\ncommit: $(g -C "${FWD}" rev-parse --short v1.0.0)\ngrafted: 2026-01-02\n"
FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" preflight v1.0.0 v1.1.0
has "is a TAG OBJECT, not a commit"
pin "version: v1.0.0\ncommit: $(g -C "${FWD}" rev-parse --short 'v1.0.1^{commit}')\ngrafted: 2026-01-02\n"
FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" preflight v1.0.0 v1.1.0
has "is not the commit of v1.0.0"
has "SUGGESTION, not applied: the pinned commit carries v1.0.1"
pin "version: v1.0.0\ncommit: n/d\ngrafted: n/d (retrofit 2026-01-02)\n"
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" preflight v1.0.0 v1.1.0
has "CHECK  the commit is not recorded ('n/d')"
has "CHECK  grafted reads 'n/d (retrofit 2026-01-02)'"
printf '%s\n' "${pin_good}" > "${PRJ}/.claude/framework-version"
T="${T_DIR}" run 2 "${PRJ}" preflight v1.0.0 v1.1.0
has "FW is not set"
FW="${PRJ}" T="${T_DIR}" run 2 "${PRJ}" preflight v1.0.0 v1.1.0
echo "PASS (upgrade-check preflight): a sound pin passes; a malformed or foreign one fails with its correction; a tag is suggested, never applied."
