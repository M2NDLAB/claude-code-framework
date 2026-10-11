#!/usr/bin/env bash
# Self-test of tools/docs-check.mjs, hermetic: a throwaway clone of THIS repository under a
# mktemp directory — its tags, and its working tree as it is now, edits and new files
# included — with git configured from nothing (no global or system config, no inherited git
# environment) and no network. It runs the REAL check end to end: on the copy as it is,
# then on copies with one defect each, which must fail with exactly the expected lines.
#
# Cases:
#   1. the repository passes — with a floor on what the check read, so an empty or broken
#      extraction cannot pass — and gives the same verdict under a hostile git
#      configuration;
#   2. inventories — a command no list names, a row missing from a script table, a process
#      target the lists do not name: each fails;
#   3. the allow-list — an exception whose cause is gone fails;
#   4. read-only — a run leaves the copy exactly as it was.
# Run it from anywhere: bash tools/test-docs-check.sh
set -euo pipefail

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${TOOLS_DIR}/.." && pwd)"
CHECK="${TOOLS_DIR}/docs-check.mjs"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT
# No repository above the throwaway ones may be discovered by accident.
export GIT_CEILING_DIRECTORIES="${workdir}"
out="${workdir}/out.log"

fail() {
  echo "FAIL (docs-check): $1" >&2
  [ -f "${out}" ] && { echo "--- last output ---" >&2; cat "${out}" >&2; }
  exit 1
}
# A git with a fixed identity and no signing, for the throwaway tags.
g() { git -c user.name=self-test -c user.email=self-test@example.invalid \
          -c commit.gpgSign=false -c tag.gpgSign=false "$@"; }
# run <expected rc> <dir>: run the check in a copy, keep its output in ${out}.
run() {
  local expected="$1" dir="$2"
  set +e
  ( cd "${dir}" && node "${CHECK}" ) >"${out}" 2>&1
  rc=$?
  set -e
  [ "${rc}" -eq "${expected}" ] || fail "docs-check in ${dir##*/}: exit ${rc}, expected ${expected}"
}
has()   { grep -qF -- "$1" "${out}" || fail "expected a line with: $1"; }
hasnt() { ! grep -qF -- "$1" "${out}" || fail "unexpected line with: $1"; }
# fails <n> <text>: exactly n FAIL lines, each carrying text.
fails() {
  [ "$(grep -c '^FAIL ' "${out}")" -eq "$1" ] || fail "expected exactly $1 FAIL line(s), carrying: $2"
  [ "$(grep '^FAIL ' "${out}" | grep -cF -- "$2")" -eq "$1" ] || fail "not every FAIL line carries: $2"
}
# floor <regex> <n>: the first number the OK line matching regex reports is at least n.
floor() {
  local got
  got="$(grep -E "^OK .*$1" "${out}" | head -1 | grep -oE '[0-9]+' | head -1)"
  [ -n "${got}" ] && [ "${got}" -ge "$2" ] || fail "the OK line for \"$1\" reports ${got:-nothing}, expected at least $2"
}
# edit <file> <regex> <replacement>: change one file of a copy in place, with Node.js (which
# the check needs anyway); a regex that matches nothing stops the test, never passes it.
edit() {
  node -e 'const fs = require("fs"); const [f, re, to] = process.argv.slice(1);
    const s = fs.readFileSync(f, "utf8"); const t = s.replace(new RegExp(re, "gm"), to);
    if (t === s) { console.error(`edit: nothing matches ${re} in ${f}`); process.exit(1) }
    fs.writeFileSync(f, t)' "$1" "$2" "$3" || fail "the test's own edit of $1 matched nothing"
}

# --- The base: this repository as it is now, tags included -------------------------------
base="${workdir}/base"
git clone -q --no-hardlinks "${REPO_ROOT}" "${base}"
# The working tree's own state over the clone of HEAD: edits and new files in, deletions out.
( cd "${REPO_ROOT}" && git ls-files -z --cached --others --exclude-standard \
    | while IFS= read -r -d '' p; do [ -f "${p}" ] && printf '%s\0' "${p}"; done \
    | tar --null -T - -cf - ) | tar -C "${base}" -xf -
( cd "${REPO_ROOT}" && git ls-files -z --deleted ) | ( cd "${base}" && xargs -0 rm -f -- )
# copy <name>: a fresh copy of the base, to break one thing in.
copy() { cp -R "${base}" "${workdir}/$1" && printf '%s\n' "${workdir}/$1"; }

# --- Case 1: the repository passes ---------------------------------------------------------
run 0 "${base}"
has "docs-check: 0 FAIL"
floor 'commands, .* process targets' 8
hostile="${workdir}/hostile.gitconfig"
printf '[color]\n\tui = always\n[core]\n\tquotePath = true\n[log]\n\tshowSignature = true\n[i18n]\n\tlogOutputEncoding = ISO-8859-1\n' > "${hostile}"
cp "${out}" "${workdir}/plain.log"
( cd "${base}" && GIT_CONFIG_GLOBAL="${hostile}" node "${CHECK}" ) > "${out}" 2>&1 || fail "the repository fails under a hostile git configuration"
diff "${workdir}/plain.log" "${out}" >/dev/null || fail "a hostile git configuration changes the verdict"
echo "PASS (docs-check, the repository): every check passes, above its floor, under any git configuration."

# --- Case 2: inventories --------------------------------------------------------------------
c="$(copy inv-command)"
printf -- '---\ndescription: a command no list names\n---\nNothing.\n' > "${c}/.claude/commands/extra.md"
run 1 "${c}"
fails 2 "lacks /extra"
c="$(copy inv-table)"
edit "${c}/scripts/README.md" '^\| `reset-task\.sh` \|.*\n' ''
run 1 "${c}"
fails 1 "the table of scripts/README.md lacks reset-task.sh"
c="$(copy inv-target)"
printf '\nlint-docs: ## A process target nobody lists\n\tbash scripts/repo-snapshot.sh\n' >> "${c}/Makefile"
run 1 "${c}"
has "Quick commands lacks lint-docs"
has "the Structure tree's Makefile line lacks lint-docs"
has "the brownfield Makefile row lacks lint-docs"
echo "PASS (docs-check, inventories): a command, a table row and a process target missing from their lists fail."

# --- Case 3: the allow-list -----------------------------------------------------------------
c="$(copy allow-stale)"
edit "${c}/SETUP.md" '`/tmp`' '`/var/tmp`'
run 1 "${c}"
fails 1 '"`/tmp`" matches nothing'
echo "PASS (docs-check, allow-list): an exception whose cause is gone fails."

# --- Case 4: read-only ----------------------------------------------------------------------
c="$(copy read-only)"
fingerprint() {
  ( cd "$1" && bash "${REPO_ROOT}/scripts/repo-snapshot.sh" && git --no-optional-locks status --porcelain=v1 -uall \
    && cksum .git/index && find . -path ./.git -prune -o -type f -print | sort | xargs cksum )
}
fingerprint "${c}" > "${workdir}/before.txt"
run 0 "${c}"
fingerprint "${c}" > "${workdir}/after.txt"
diff "${workdir}/before.txt" "${workdir}/after.txt" >/dev/null || fail "a run changed the copy it checked"
echo "PASS (docs-check, read-only): a run leaves the repository exactly as it was."
