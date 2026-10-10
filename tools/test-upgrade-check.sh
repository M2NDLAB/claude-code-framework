#!/usr/bin/env bash
# Self-test of tools/upgrade-check.sh, hermetic: throwaway repositories under a mktemp
# directory, git configured from nothing (no global or system config, no inherited git
# environment), no network. It runs the REAL script end to end.
#
# Cases:
#   1. classes — every payload file of THIS repository's HEAD has a class (with a floor on
#      the counts, so an empty or broken listing cannot pass), and a file added to the
#      payload without one makes it fail.
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
