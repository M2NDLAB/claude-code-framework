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
#   2. the payload — a framework IMP number in its text fails; the same number outside the
#      payload (CONTRIBUTING.md, a session note of the framework) does not; a bare pointer
#      to a file a project lacks fails, labelled as the framework's or conditional it
#      does not; a slot in the short form fails;
#   3. inventories — a command no list names, a row missing from a script table, a process
#      target the lists do not name: each fails;
#   4. tags and the CHANGELOG — a tag without its entry, a lightweight tag, an entry dated
#      after its tag, an untagged entry that is no release in preparation: each fails; the
#      entry of the release being prepared is a CHECK, not a FAIL;
#   5. versions — an old version presented as the current one fails; a historical mention
#      does not;
#   6. links — a Markdown link or anchor, a wikilink, a cited path and a cited section
#      title that resolve to nothing: each fails;
#   7. lists — a slot SETUP.md §2 never names, a slot added since the latest tag with its
#      §2 item unchanged, a payload file without a class, a count in prose, the sections of
#      the backlog, the subcommands and the copy list out of step: each fails;
#   8. the allow-list — an exception whose cause is gone fails;
#   9. read-only — a run leaves the copy exactly as it was.
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
# nfails <n>: exactly n FAIL lines.
nfails() { [ "$(grep -c '^FAIL ' "${out}")" -eq "$1" ] || fail "expected exactly $1 FAIL line(s)"; }
# fails <n> <text>: exactly n FAIL lines, each carrying text.
fails() {
  [ "$(grep -c '^FAIL ' "${out}")" -eq "$1" ] || fail "expected exactly $1 FAIL line(s), carrying: $2"
  [ "$(grep '^FAIL ' "${out}" | grep -cF -- "$2")" -eq "$1" ] || fail "not every FAIL line carries: $2"
}
# floor <pattern> <n>: on the OK line the pattern matches, the number in place of its first
# N is at least n — so an empty or broken extraction cannot pass.
floor() {
  local re="${1//N/([0-9]+)}" got
  got="$(grep -E '^OK ' "${out}" | grep -oE "${re}" | head -1 | grep -oE '[0-9]+' | head -1)"
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
floor 'N commands, N process targets' 8
floor 'no framework IMP number in N payload files' 30
floor 'N pointers? out of the payload' 10
floor 'N tags and N entries match' 19
floor 'N Markdown links' 5
floor 'N wikilinks' 100
floor 'N cited paths' 300
floor 'N markers in the full form' 30
floor 'the class table at N tags' 19
hostile="${workdir}/hostile.gitconfig"
printf '[color]\n\tui = always\n[core]\n\tquotePath = true\n[log]\n\tshowSignature = true\n[i18n]\n\tlogOutputEncoding = ISO-8859-1\n' > "${hostile}"
cp "${out}" "${workdir}/plain.log"
( cd "${base}" && GIT_CONFIG_GLOBAL="${hostile}" node "${CHECK}" ) > "${out}" 2>&1 || fail "the repository fails under a hostile git configuration"
diff "${workdir}/plain.log" "${out}" >/dev/null || fail "a hostile git configuration changes the verdict"
echo "PASS (docs-check, the repository): every check passes, above its floor, under any git configuration."

# --- Case 2: the payload --------------------------------------------------------------------
c="$(copy imp-number)"
printf '\nAs IMP-123 found, a rule needs its why.\n' >> "${c}/.claude/docs/02-code-quality.md"
run 1 "${c}"
fails 1 ".claude/docs/02-code-quality.md:"
has "IMP-123: a number of the framework's backlog in the payload"
c="$(copy imp-outside)"
printf '\nAs IMP-123 found.\n' >> "${c}/CONTRIBUTING.md"
printf -- '---\ndate: 2099-01-01\n---\n# A session note\n\nAs IMP-123 found.\n' > "${c}/.claude/memory/sessions/2099-01-01-a-note.md"
run 0 "${c}"
c="$(copy pointer-bare)"
printf '\nThe slots are listed in `SETUP.md`, step 2.\n' >> "${c}/.claude/docs/00-overview.md"
run 1 "${c}"
fails 1 '"SETUP.md" points at SETUP.md'
c="$(copy pointer-labelled)"
printf '\nThe slots are listed in the framework'"'"'s `SETUP.md`, step 2.\n' >> "${c}/.claude/docs/00-overview.md"
printf '\nRecord it in the CHANGELOG, if the project keeps one.\n' >> "${c}/.claude/docs/02-code-quality.md"
run 0 "${c}"
c="$(copy short-slot)"
printf '\n- the release channel: [TO BE DEFINED].\n' >> "${c}/.claude/docs/02-code-quality.md"
run 1 "${c}"
fails 1 "a slot the setup and upgrade greps cannot see"
echo "PASS (docs-check, payload): an IMP number fails in the payload and only there; a pointer out of it fails unless labelled or conditional; so does a short slot."

# --- Case 3: inventories --------------------------------------------------------------------
c="$(copy inv-command)"
printf -- '---\ndescription: a command no list names\n---\nNothing.\n' > "${c}/.claude/commands/extra.md"
run 1 "${c}"
has "the Slash commands of Quick commands lacks /extra"
has "the Structure tree's commands/ line lacks /extra"
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

# --- Case 4: tags and the CHANGELOG ---------------------------------------------------------
# settle <dir>: the copy's topmost entry tagged, if the release it records is still being
# prepared — so every case starts from a CHANGELOG whose entries all have their tags.
top_entry() { sed -n 's/^## \[\([0-9]*\.[0-9]*\.[0-9]*\)\] — .*$/\1/p' "$1/CHANGELOG.md" | head -1; }
settle() {
  local v
  v="$(top_entry "$1")"
  g -C "$1" rev-parse -q --verify "refs/tags/v${v}" >/dev/null || g -C "$1" tag -a "v${v}" -m "v${v}"
}
# entry <dir> <version> <date>: a new topmost entry, right under [Unreleased].
entry() {
  local block
  block=$'## [Unreleased]\n\n## ['"$2"$'] — '"$3"$'\n\n### Fixed\n- A fix.\n\n'
  edit "$1/CHANGELOG.md" '^## \[Unreleased\]\n\n' "${block}"
}
today="$(date +%Y-%m-%d)"
c="$(copy cl-tag)"
settle "${c}"
g -C "${c}" tag -a v9.0.0 -m v9.0.0
run 1 "${c}"
fails 1 "v9.0.0 has no entry"
c="$(copy cl-lightweight)"
settle "${c}"
g -C "${c}" tag v9.0.0
run 1 "${c}"
has "v9.0.0 is a lightweight tag"
has "v9.0.0 has no entry"
c="$(copy cl-date)"
settle "${c}"
v="$(top_entry "${c}")"
edit "${c}/CHANGELOG.md" "^## \\[${v//./\\.}\\] — [0-9-]*$" "## [${v}] — 2099-01-01"
run 1 "${c}"
fails 1 "${v} is dated 2099-01-01, after its tag"
c="$(copy cl-pending)"
settle "${c}"
v="$(top_entry "${c}")"
next="${v%%.*}.$(( $(echo "${v}" | cut -d. -f2) + 1 )).0"
entry "${c}" "${next}" "${today}"
run 0 "${c}"
has "CHECK  ${next}: the release being prepared"
c="$(copy cl-untagged)"
settle "${c}"
entry "${c}" "9.9.9" "${today}"
run 1 "${c}"
fails 1 "9.9.9 has no tag v9.9.9"
echo "PASS (docs-check, CHANGELOG): every tag has its entry and every entry its tag, but the one release being prepared."

# --- Case 5: versions -----------------------------------------------------------------------
c="$(copy version-current)"
printf '\nThe current version is v1.0.0.\n' >> "${c}/CONTRIBUTING.md"
run 1 "${c}"
fails 1 "v1.0.0 reads as the current version"
c="$(copy version-history)"
printf '\nThe tags live on main from v1.0.0 on.\n' >> "${c}/CONTRIBUTING.md"
run 0 "${c}"
echo "PASS (docs-check, versions): an old version presented as current fails, a historical one does not."

# --- Case 6: links --------------------------------------------------------------------------
c="$(copy links)"
printf '\nSee [the guide](NO-SUCH.md), [the box](SETUP.md#no-such-anchor), [[no-such-note]],\n`scripts/no-such.sh` and `.claude/docs/04-git-workflow.md`, *No such section*.\n' >> "${c}/CONTRIBUTING.md"
printf '\nSee [Hardening](SETUP.md#hardening).\n' >> "${c}/README.md"
run 1 "${c}"
fails 5 "CONTRIBUTING.md:"
has "NO-SUCH.md does not exist"
has "has the anchor #no-such-anchor"
has "[[no-such-note]] names no note"
has "\`scripts/no-such.sh\` names no file"
has 'has no section "No such section"'
echo "PASS (docs-check, links): a link, an anchor, a wikilink, a cited path and a section title that resolve to nothing fail."

# --- Case 7: lists --------------------------------------------------------------------------
c="$(copy list-unnamed)"
printf '\nThe retro cadence is [TO BE DEFINED AT SETUP].\n' >> "${c}/.claude/commands/retro.md"
run 1 "${c}"
fails 2 ".claude/commands/retro.md:"
has "a slot SETUP.md §2 never names"
has "but its §2 item is unchanged"
c="$(copy list-tripwire)"
printf '# [TO BE DEFINED AT SETUP] — one more slot of the stack.\n' >> "${c}/.gitignore"
run 1 "${c}"
fails 1 ".gitignore:1: 1 → 2 slot markers since"
c="$(copy list-class)"
mkdir -p "${c}/.claude/agents"
printf 'An agent definition.\n' > "${c}/.claude/agents/reviewer.md"
run 1 "${c}"
has ".claude/agents/reviewer.md has no class in classify()"
c="$(copy list-count)"
edit "${c}/SETUP.md" 'These eight cases' 'These seven cases'
run 1 "${c}"
fails 1 '"These seven cases", but the numbered edge cases are 8'
c="$(copy list-various)"
edit "${c}/.claude/memory/INDEX.md" 'open / applied / deferred / rejected' 'open / applied / deferred'
edit "${c}/SETUP.md" 'Its subcommands: `classes` \(the class table, file by file\), ' 'Its subcommands: '
edit "${c}/SETUP.md" '`commitlint.config.cjs`, `.gitignore`, `scripts/`\.' '`commitlint.config.cjs`, `.gitignore`.'
run 1 "${c}"
nfails 3
has "the backlog's sections without rejected"
has '"Its subcommands:" lacks classes'
has "the copy list lacks scripts"
echo "PASS (docs-check, lists): §2 and the slots, the class table, the counts, the sections, the subcommands and the copy list fail when out of step."

# --- Case 8: the allow-list -----------------------------------------------------------------
c="$(copy allow-stale)"
edit "${c}/SETUP.md" '`/tmp`' '`/var/tmp`'
run 1 "${c}"
fails 1 '"`/tmp`" matches nothing'
echo "PASS (docs-check, allow-list): an exception whose cause is gone fails."

# --- Case 9: read-only ----------------------------------------------------------------------
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
