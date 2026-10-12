#!/usr/bin/env bash
# The generated hooks, run with the REAL tools — this repository's own test, outside the
# payload: the self-tests that ship with scripts/ stub gitleaks and npx. Six cases: the
# user's four, and one for each defect observed since, none more without one
# (tools/README.md):
#   1. the pre-commit hook refuses a staged secret — one built at run time, so that no file
#      of this repository holds it (its own pre-commit would refuse the file) — see "Case 1";
#   2. it lets a staged change with nothing secret through;
#   3. the commit-msg hook — commitlint at the version scripts/check-prerequisites.sh pins —
#      accepts a conforming message;
#   4. it refuses a message without a type;
#   5. the pre-commit hook refuses the secret when the user's git config forces colour, which
#      left gitleaks an empty diff to scan;
#   6. it refuses the secret when a textconv driver, assigned in .gitattributes, masks the
#      values in what `git diff` shows gitleaks.
# The git configuration is emptied below; cases 5 and 6 set theirs, each checked to take hold.
# Each hook runs as git runs it, from the repository's root, so a case fails for its own hook
# only. It needs gitleaks, Node.js with npx, and the network the first time npx fetches
# commitlint. The CI installs gitleaks at a fixed version, its archive checked against a
# fixed SHA-256 (.github/workflows/test.yml); elsewhere it runs the gitleaks on the PATH.
#   bash tools/test-real-hooks.sh
set -euo pipefail

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${TOOLS_DIR}/.." && pwd)"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT
out="${workdir}/out"
rc=-

fail() {
  echo "FAIL (real hooks): $1" >&2
  if [[ -f "${out}" ]]; then
    echo "--- its output (exit ${rc}) ---" >&2
    cat "${out}" >&2
  fi
  exit 1
}

# A project as setup leaves it, for what the hooks read: the installer, the prerequisite
# check it runs and reads commitlint's pin from, and commitlint's configuration.
repo="${workdir}/project"
git init -q "${repo}"
git -C "${repo}" config user.name self-test
git -C "${repo}" config user.email self-test@example.invalid
mkdir -p "${repo}/scripts"
cp "${REPO_ROOT}/scripts/hooks-install.sh" "${REPO_ROOT}/scripts/check-prerequisites.sh" "${repo}/scripts/"
cp "${REPO_ROOT}/commitlint.config.cjs" "${repo}/commitlint.config.cjs"
bash "${repo}/scripts/hooks-install.sh" >"${out}" 2>&1 || fail "hooks-install.sh did not install the hooks"
# Not vacuous: the hooks are the generated ones, at the pin, and gitleaks is a real one.
grep -q 'gitleaks protect --staged' "${repo}/.git/hooks/pre-commit" \
  || fail "the pre-commit hook does not run gitleaks protect --staged"
grep -q '^add_config color.diff never$' "${repo}/.git/hooks/pre-commit" \
  || fail "the pre-commit hook does not turn git's colour off for gitleaks"
pin="$(bash "${repo}/scripts/check-prerequisites.sh" --commitlint-version)"
grep -qF "@commitlint/cli@${pin}" "${repo}/.git/hooks/commit-msg" \
  || fail "the commit-msg hook does not run commitlint at the pin, ${pin}"
version="$(gitleaks version 2>&1)" || fail "gitleaks does not run: ${version}"

# run_hook <hook> [argument]: the hook as git runs it, from the repository's root.
run_hook() {
  set +e
  (cd "${repo}" && bash ".git/hooks/$1" "${@:2}") >"${out}" 2>&1
  rc=$?
  set -e
}

# --- Case 1 — the pre-commit hook refuses a staged secret ------------------------------------
# An AWS access key ID, put together here: its two halves never meet in this file.
key="AKIA""J5XK2QW7NB4RT6YP"
printf 'aws_access_key_id = %s\n' "${key}" > "${repo}/leak.txt"
git -C "${repo}" add leak.txt
run_hook pre-commit
[[ ${rc} -ne 0 ]] || fail "a staged secret: the pre-commit hook let it through"
grep -q 'leaks found: [1-9]' "${out}" || fail "a staged secret: the refusal is not gitleaks' finding"
git -C "${repo}" rm -q --cached leak.txt

# --- Case 2 — the pre-commit hook lets a change with nothing secret through -------------------
printf 'nothing secret here\n' > "${repo}/clean.txt"
git -C "${repo}" add clean.txt
run_hook pre-commit
[[ ${rc} -eq 0 ]] || fail "a clean change: the pre-commit hook refused it"
grep -q 'no leaks found' "${out}" || fail "a clean change: gitleaks did not report its scan"

# --- Case 3 — the commit-msg hook accepts a conforming message ---------------------------------
# The message where git leaves it, passed as git passes it.
printf 'chore: a conforming message\n' > "${repo}/.git/COMMIT_EDITMSG"
run_hook commit-msg .git/COMMIT_EDITMSG
[[ ${rc} -eq 0 ]] || fail "a conforming message: the commit-msg hook refused it"

# --- Case 4 — the commit-msg hook refuses a message without a type ----------------------------
printf 'a message without a type\n' > "${repo}/.git/COMMIT_EDITMSG"
run_hook commit-msg .git/COMMIT_EDITMSG
[[ ${rc} -ne 0 ]] || fail "a message without a type: the commit-msg hook accepted it"
grep -q 'type-empty' "${out}" || fail "a message without a type: the refusal is not commitlint's type-empty rule"

# --- Case 5 — the secret, with a colour the user's git config forces -------------------------
# color.ui "always" colours `git diff` even into a pipe: gitleaks found no file in the output,
# printed "no leaks found" and let the commit through.
printf '[color]\n\tui = always\n' > "${workdir}/colour.gitconfig"
git -C "${repo}" add leak.txt
export GIT_CONFIG_GLOBAL="${workdir}/colour.gitconfig"
git -C "${repo}" diff --staged | grep -q "$(printf '\033')\[" \
  || fail "a forced colour: git diff is not coloured, so the case would prove nothing"
run_hook pre-commit
export GIT_CONFIG_GLOBAL=/dev/null
[[ ${rc} -ne 0 ]] || fail "a forced colour: the pre-commit hook let the staged secret through"
grep -q 'leaks found: [1-9]' "${out}" || fail "a forced colour: the refusal is not gitleaks' finding"
git -C "${repo}" rm -q --cached leak.txt

# --- Case 6 — the secret, behind a textconv driver that masks the values ----------------------
# `git diff` shows a textconv's conversion instead of the staged text: a driver that masks the
# values hid the key from gitleaks.
git -C "${repo}" config diff.mask.textconv "sed -e 's/=.*/= ***/'"
printf 'leak.txt diff=mask\n' > "${repo}/.gitattributes"
git -C "${repo}" add .gitattributes leak.txt
git -C "${repo}" diff --staged -- leak.txt | grep -q '^+aws_access_key_id = \*\*\*$' \
  || fail "a masking textconv: git diff does not show the masked line, so the case would prove nothing"
run_hook pre-commit
[[ ${rc} -ne 0 ]] || fail "a masking textconv: the pre-commit hook let the staged secret through"
grep -q 'leaks found: [1-9]' "${out}" || fail "a masking textconv: the refusal is not gitleaks' finding"

echo "PASS (real hooks): with gitleaks ${version} and commitlint ${pin}, the pre-commit hook refuses a staged secret — also with a colour the user's git config forces and behind a textconv that masks it — and lets a clean change through; the commit-msg hook accepts a conforming message and refuses one without a type."
