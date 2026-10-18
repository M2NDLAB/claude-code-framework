#!/usr/bin/env bash
# Self-test of tools/rehearsal-project.sh, and the CI's run of the shipped self-tests inside a
# project grafted from HEAD (IMP-125): here every slot is open and the memory is this
# repository's own, so a self-test that reads them only as they are here passes in no project
# but this one — the class of three defects in two releases, all found by a rehearsal, none by
# the CI. Throwaway directories under mktemp; git configured from nothing.
#
# Cases:
#   1. answered, at HEAD — every bracketed marker answered, and fw/checkpoint.md's two
#      placeholders, the paragraph that marks them gone; the protected branches `main dev`;
#      the project's rule at the end of the allow list, the file still JSON; STATE.md past
#      8,000 characters in HEAD's titles, in their order; LEARNINGS.md's four titles, its format
#      comment and the project's two entries; the pin; two commits and a clean tree; the
#      scripts executable in the index; its clone with core.autocrlf=true, which HEAD's
#      .gitattributes holds to LF, and a line that says so — not one that claims CRLF.
#   2. the shipped self-tests inside that project — `make test-scripts` green, and each self-test
#      its Makefile runs printed its own PASS line: a run that ends green without them is no
#      run. At least six of them.
#   3. legacy, at v1.2.0, with its CRLF clone — the pin without its v and no graft date; the
#      memory's titles and the entries' labels in their form before v1.1.0; no .gitattributes;
#      the integrate and checkpoint commands' placeholders replaced; reset-task.sh's default
#      answered; a
#      branch `dev`; the clone with CRLF line ends, counted in the line printed, its `dev`,
#      and no remote.
#   4. refusals — an existing directory, a revision FW lacks, a directory inside FW: each
#      refused, nothing written; and a build that fails half-way leaves nothing behind.
# Run it from anywhere: bash tools/test-rehearsal-project.sh
set -euo pipefail

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${TOOLS_DIR}/.." && pwd)"
GEN="${TOOLS_DIR}/rehearsal-project.sh"
# Resolved, as the generator prints it: on macOS a temporary directory sits behind a link.
workdir="$(cd "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "${workdir}"' EXIT
out="${workdir}/out.log"

fail() {
  echo "FAIL (rehearsal project): $1" >&2
  [ -f "${out}" ] && { echo "--- last output ---" >&2; tail -n 40 "${out}" >&2; }
  exit 1
}
# The marker, built so this file never carries it as a slot would.
M="[TO BE DEFINED A""T SETUP]"
# A count of a file's characters, as Node.js counts them — the unit of the hook's budget.
chars() { node -e 'process.stdout.write(String(require("fs").readFileSync(process.argv[1], "utf8").length))' "$1"; }
# The old form of a title, from upgrade-check.sh's table read from new to old.
eval "$(sed -n "/^TITLE_TABLE='/,/'\$/p" "${TOOLS_DIR}/upgrade-check.sh")"
old_title() { T="${TITLE_TABLE}" X="$1" awk 'BEGIN { n = split(ENVIRON["T"], l, "\n"); for (i = 1; i <= n; i++) { split(l[i], kv, "\t"); if (kv[2] == ENVIRON["X"] && r == "") r = kv[1] } print r }'; }

# --- Case 1: answered, at HEAD ----------------------------------------------------------------
P="${workdir}/answered"
FW="${REPO_ROOT}" bash "${GEN}" HEAD "${P}" answered crlf > "${out}" 2>&1 || fail "the build at HEAD failed"
grep -q "^rehearsal-project: ${P} — answered at " "${out}" || fail "the build at HEAD printed no line of what it built"
grep -qF "; with core.autocrlf=true, no file with CRLF line ends — HEAD's .gitattributes holds them all to LF: ${P}.crlf" "${out}" \
  || fail "the line of the clone at HEAD does not say its files are LF"
[ "$(git -C "${P}.crlf" ls-files --eol | awk '$2 == "w/crlf"' | wc -l | tr -d ' ')" = 0 ] \
  || fail "the clone at HEAD has a file with CRLF, which HEAD's .gitattributes should hold to LF"
left="$(grep -rlF --exclude-dir=.git -- "${M}" "${P}" || true)"
[ -z "${left}" ] || fail "slots left open: ${left}"
! grep -qE '<integration>|<pattern-to-ignore-for-the-stack>|^Setup replaces the placeholders below' "${P}/.claude/commands/fw/checkpoint.md" \
  || fail "fw/checkpoint.md keeps a placeholder, or the paragraph setup deletes"
grep -qF 'git branch --merged main' "${P}/.claude/commands/fw/checkpoint.md" || fail "fw/checkpoint.md's integration branch is not answered"
grep -qxF 'PROTECTED_BRANCHES = main dev' "${P}/Makefile" || fail "the Makefile's protected branches are not main dev"
node -e '
const allow = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).permissions.allow;
if (allow[allow.length - 1] !== "Bash(make test)") process.exit(1);
' "${P}/.claude/settings.json" || fail "settings.json is not JSON, or its allow list does not end with the project's rule"
[ "$(chars "${P}/.claude/memory/STATE.md")" -gt 8000 ] || fail "STATE.md is not past the 8,000 characters of the hook's budget"
git -C "${REPO_ROOT}" show HEAD:.claude/memory/STATE.md | grep '^## ' > "${workdir}/titles.head"
grep '^## ' "${P}/.claude/memory/STATE.md" | cmp -s "${workdir}/titles.head" - || fail "STATE.md's titles are not those of HEAD's template, in its order"
[ "$(grep -c '^## ' "${P}/.claude/memory/LEARNINGS.md")" -eq 4 ] || fail "LEARNINGS.md has not its four titles"
grep -q '^<!-- Format of a proposal' "${P}/.claude/memory/LEARNINGS.md" || fail "LEARNINGS.md lost its format comment"
awk '/^## /{s++} /^### IMP-001 /{a = s} /^### IMP-002 /{b = s} END { exit !(a == 1 && b == 2) }' "${P}/.claude/memory/LEARNINGS.md" \
  || fail "the project's two IMP entries are not in the first and the second section"
grep -qE '^version: v' "${P}/.claude/framework-version" && grep -q '^grafted: 2026-01-10$' "${P}/.claude/framework-version" \
  || fail "the pin is not the one step 1 writes"
[ "$(git -C "${P}" rev-list --count HEAD)" -eq 2 ] || fail "not the empty start and the graft's commit"
[ -z "$(git -C "${P}" status --porcelain)" ] || fail "the project's tree is not clean"
[ "$(git -C "${P}" ls-files -s scripts/hooks-install.sh | cut -c1-6)" = 100755 ] || fail "scripts/hooks-install.sh is not executable in the index"
n_answers="$(sed -n 's/.*: \([0-9][0-9]*\) slots answered.*/\1/p' "${out}")"
[ "${n_answers:-0}" -ge 10 ] || fail "fewer than ten slots answered at HEAD"

# --- Case 2: the shipped self-tests, inside that project ---------------------------------------
( cd "${P}" && make test-scripts ) > "${out}" 2>&1 || fail "make test-scripts failed inside the project grafted from HEAD"
# Each self-test the project's Makefile runs: make echoes its line, and its PASS line follows
# before the next one.
sed -n 's/^\tbash \(scripts\/test-[a-z-]*\.sh\)$/\1/p' "${P}/Makefile" > "${workdir}/tests"
n_tests="$(grep -c . "${workdir}/tests" || true)"
[ "${n_tests}" -ge 6 ] || fail "the project's Makefile runs ${n_tests} self-tests, fewer than six"
while IFS= read -r t; do
  awk -v c="bash ${t}" '$0 == c { on = 1; next } /^bash scripts\// { on = 0 } on && /^PASS / { f = 1 } END { exit !f }' "${out}" \
    || fail "${t} printed no PASS line inside the project"
done < "${workdir}/tests"
echo "PASS (rehearsal project, answered): built at HEAD with ${n_answers} slots answered and the memory past its budget, its clone with core.autocrlf=true all LF, as its line says; the ${n_tests} shipped self-tests pass inside it, each with its own PASS line."

# --- Case 3: legacy, at v1.2.0, with its CRLF clone ---------------------------------------------
git -C "${REPO_ROOT}" rev-parse -q --verify 'refs/tags/v1.2.0^{commit}' >/dev/null \
  || fail "no tag v1.2.0 in this repository: the CI's checkout fetches every tag (fetch-depth: 0)"
L="${workdir}/legacy"
FW="${REPO_ROOT}" bash "${GEN}" v1.2.0 "${L}" legacy crlf > "${out}" 2>&1 || fail "the legacy build at v1.2.0 failed"
grep -qxF 'version: 1.2.0' "${L}/.claude/framework-version" && grep -q '^grafted: n/d' "${L}/.claude/framework-version" \
  || fail "the legacy pin has its v, or a graft date"
git -C "${REPO_ROOT}" show v1.2.0:.claude/memory/STATE.md | grep '^## ' > "${workdir}/titles.120"
n_titles=0
while IFS= read -r t; do
  o="$(old_title "${t}")"
  [ -n "${o}" ] || fail "no old form for v1.2.0's title '${t}' in upgrade-check.sh's table"
  grep -qxF -- "${o}" "${L}/.claude/memory/STATE.md" || fail "STATE.md lacks the old title '${o}'"
  n_titles=$((n_titles + 1))
done < "${workdir}/titles.120"
[ "${n_titles}" -ge 6 ] || fail "fewer than six titles in v1.2.0's STATE.md template"
! grep -q '^## Caution' "${L}/.claude/memory/STATE.md" || fail "STATE.md keeps a title in its new form"
[ "$(chars "${L}/.claude/memory/STATE.md")" -gt 40000 ] || fail "the legacy STATE.md is not at the scale of a memory never condensed"
grep -q '^- Data: 2026-01-12 | Origine: ' "${L}/.claude/memory/LEARNINGS.md" || fail "the legacy entries' labels are not in their old form"
! grep -q '^## Applied' "${L}/.claude/memory/LEARNINGS.md" || fail "LEARNINGS.md keeps a title in its new form"
[ ! -e "${L}/.gitattributes" ] || fail "the legacy project keeps a .gitattributes"
! grep -qE '<integration>|<stable>' "${L}/.claude/commands/integrate.md" || fail "the integrate command keeps its branch placeholders"
! grep -qE '<integration>|<pattern-to-ignore-for-the-stack>' "${L}/.claude/commands/checkpoint.md" || fail "the checkpoint command keeps its placeholders"
grep -qxF 'PROTECTED_BRANCHES="${PROTECTED_BRANCHES:-main dev}"' "${L}/scripts/reset-task.sh" || fail "reset-task.sh's protected branches are not answered"
git -C "${L}" rev-parse -q --verify refs/heads/dev >/dev/null || fail "no branch dev in the legacy project"
grep -q $'\r$' "${L}.crlf/CLAUDE.md" || fail "the CRLF clone's CLAUDE.md has no CRLF line end"
n_crlf="$(git -C "${L}.crlf" ls-files --eol | awk '$2 == "w/crlf"' | wc -l | tr -d ' ')"
[ "${n_crlf}" -gt 0 ] && grep -qF "; with core.autocrlf=true, ${n_crlf} files with CRLF line ends: ${L}.crlf" "${out}" \
  || fail "the line of the legacy clone does not count its ${n_crlf} files with CRLF"
git -C "${L}.crlf" rev-parse -q --verify refs/heads/dev >/dev/null || fail "no branch dev in the CRLF clone"
[ -z "$(git -C "${L}.crlf" remote)" ] || fail "the CRLF clone keeps a remote"
echo "PASS (rehearsal project, legacy): at v1.2.0 the pin without its v, ${n_titles} titles and the labels in their old form, the memory never condensed, no .gitattributes, the placeholders and the protected branches answered, a dormant dev; its clone with ${n_crlf} files with CRLF line ends, counted in its line."

# --- Case 4: refusals, and nothing left of a failed build ----------------------------------------
mkdir "${workdir}/exists" && echo keep > "${workdir}/exists/file"
if FW="${REPO_ROOT}" bash "${GEN}" HEAD "${workdir}/exists" > "${out}" 2>&1; then fail "a build over an existing directory went on"; fi
[ "$(cat "${workdir}/exists/file")" = keep ] && [ "$(ls -A "${workdir}/exists" | wc -l | tr -d ' ')" = 1 ] \
  || fail "the refused build touched the existing directory"
if FW="${REPO_ROOT}" bash "${GEN}" v0.0.0-none "${workdir}/norev" > "${out}" 2>&1; then fail "a revision FW lacks was built"; fi
[ ! -e "${workdir}/norev" ] || fail "the refused revision left a directory"
if FW="${REPO_ROOT}" bash "${GEN}" HEAD "${REPO_ROOT}/.rehearsal-inside" > "${out}" 2>&1; then fail "a build inside FW went on"; fi
[ ! -e "${REPO_ROOT}/.rehearsal-inside" ] || fail "the refused build inside FW left a directory"
# A framework whose payload lacks the scripts: the build stops half-way, after it has written.
FX="${workdir}/fw-without-scripts"
git init -q "${FX}" && echo x > "${FX}/CLAUDE.md" && mkdir -p "${FX}/.claude" && echo '{}' > "${FX}/.claude/settings.json"
git -C "${FX}" add -A && git -C "${FX}" -c user.name=t -c user.email=t@example.invalid commit -q -m "chore: a payload without scripts"
if FW="${FX}" bash "${GEN}" HEAD "${workdir}/half" > "${out}" 2>&1; then fail "a payload without its scripts was built"; fi
grep -q 'lacks its scripts' "${out}" || fail "the half-way failure did not say why"
[ ! -e "${workdir}/half" ] || fail "a build that failed half-way left its directory"
echo "PASS (rehearsal project, refusals): an existing directory, a revision FW lacks and a directory inside FW refused before anything is written; a build that fails half-way leaves nothing behind."
