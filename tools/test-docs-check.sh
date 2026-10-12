#!/usr/bin/env bash
# Self-test of tools/docs-check.mjs, hermetic: a throwaway clone of THIS repository under a
# mktemp directory — its tags, and its working tree as it is now, edits and new files
# included — with git configured from nothing (no global or system config, no inherited git
# environment) and no network. It runs the REAL check end to end: on the copy as it is,
# then on copies with planted defects, each of which must fail with its own line. Each
# case below names what it plants.
#
# Cases:
#   1. the repository passes — with a floor on what each family read, so an empty or
#      broken extraction cannot pass — and gives the same verdict under a hostile git
#      configuration and with CRLF line ends (a Windows checkout); a file it needs missing
#      is an environment error, exit 2, never a verdict;
#   2. the payload — a framework IMP number fails there and only there; a pointer to a file
#      a project lacks fails — by each name and section form, by a relative link or path,
#      by a session note's path, wikilink or @-import, and on a line that also labels it
#      elsewhere — unless labelled as the framework's or conditional; a slot in a short
#      form, or wrapped inside its brackets, fails;
#   3. inventories — a command no list names, a row missing from a table, a process target
#      the lists do not name, a self-test the recipe does not run, a doc the index lacks, a
#      file the README tree lacks, a command cited that does not exist, and a list the
#      check can no longer find: each fails;
#   4. tags and the CHANGELOG — a tag without its entry, a lightweight tag, an entry dated
#      after its tag, an untagged entry that is no release in preparation, a missing
#      [Unreleased], a malformed heading, entries or dates out of order, an Upgrading note
#      that starts from the wrong release, a clone without tags: each fails; the release
#      being prepared is a CHECK, dated today or tomorrow;
#   5. versions — an old version presented as current (a currency word, a marker before
#      it, a heading, a version: line, a checkout, a static badge) fails; a historical
#      mention does not;
#   6. links — a Markdown link, an anchor, a malformed escape, a wikilink (missing,
#      ambiguous, or to a missing heading), an @-import, a cited path, a section title
#      cited by any of its forms (curly quotes, a bare file name and §N included) — in a
#      doc, in a script's comment wrapped over two lines, in a script's message — that
#      resolve to nothing: each fails; an example's path does not;
#   7. lists — a slot §2 never names, a slot added with its §2 item unchanged, a payload
#      file without a class (now or at a tag), a class bullet, Step 2's pathspec, what step
#      1 and the "Outside the upgrade payload" box say is not copied, the counts and
#      numberings in prose, the sections of the backlog, the subcommands wherever listed,
#      the copy list, the commit types, the title and label tables, a minimum or
#      commitlint's pin written otherwise than the prerequisite check defines it: each fails
#      when out of step, and so does a list the check can no longer find;
#   8. language — Italian prose (by its words, or by its accents alone), an Italian file
#      name, guillemets, an Italian commit message and a legacy form declared but gone
#      fail; a quote, a legacy form, an accented name and a co-author's trailer do not;
#   9. the allow-list — an exception whose cause is gone fails, and an exception never
#      hides another finding of the same line;
#  10. read-only — a run leaves the copy exactly as it was.
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
# A git with a fixed identity and no signing, for the throwaway tags and commits.
g() { git -c user.name=self-test -c user.email=self-test@example.invalid \
          -c commit.gpgSign=false -c tag.gpgSign=false "$@"; }
# check_in <dir>: run the check in a copy, keep its output in ${out} and its exit in ${rc}.
check_in() {
  set +e
  ( cd "$1" && node "${CHECK}" ) >"${out}" 2>&1
  rc=$?
  set -e
}
# run <expected rc> <dir>: the same, and the exit code must be the expected one.
run() {
  check_in "$2"
  [ "${rc}" -eq "$1" ] || fail "docs-check in ${2##*/}: exit ${rc}, expected $1"
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
    // A Windows checkout writes the documents with CRLF: the edit reads them as LF.
    const s = fs.readFileSync(f, "utf8").replace(/\r\n/g, "\n"); const t = s.replace(new RegExp(re, "gm"), to);
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
# copy <name>: a fresh copy of the base, to break things in.
copy() { cp -R "${base}" "${workdir}/$1" && printf '%s\n' "${workdir}/$1"; }
# A session note of the framework that exists in every copy: the most recent, whose name is
# English by rule.
note="$(cd "${base}" && ls .claude/memory/sessions/2*.md | tail -1)"

# --- Case 1: the repository passes ---------------------------------------------------------
run 0 "${base}"
has "docs-check: 0 FAIL"
floor 'N commands, N process targets' 8
floor 'no framework IMP number in N payload files' 30
floor 'N pointers? out of the payload' 15
floor 'N markers in the full form' 30
floor 'N tags and N entries match' 19
floor 'N mentions of a framework release' 20
floor 'N Markdown links' 5
floor 'N wikilinks' 100
floor 'N @-imports' 15
floor 'N cited paths' 300
floor 'N section titles' 40
floor 'the class table at N tags' 19
floor 'N written minimums' 10
floor 'N text units' 3000
cp "${out}" "${workdir}/plain.log"
hostile="${workdir}/hostile.gitconfig"
printf '[color]\n\tui = always\n[core]\n\tquotePath = true\n[log]\n\tshowSignature = true\n[i18n]\n\tlogOutputEncoding = ISO-8859-1\n' > "${hostile}"
( cd "${base}" && GIT_CONFIG_GLOBAL="${hostile}" node "${CHECK}" ) > "${out}" 2>&1 || fail "the repository fails under a hostile git configuration"
diff "${workdir}/plain.log" "${out}" >/dev/null || fail "a hostile git configuration changes the verdict"
c="$(copy crlf)"
( cd "${c}" && git ls-files -z | xargs -0 node -e 'const fs = require("fs");
    for (const f of process.argv.slice(1)) {
      const b = fs.readFileSync(f); if (!b.includes(0)) fs.writeFileSync(f, b.toString("utf8").replace(/\r?\n/g, "\r\n"))
    }' )
run 0 "${c}"
diff "${workdir}/plain.log" "${out}" >/dev/null || fail "CRLF line ends change the verdict"
c="$(copy no-changelog)"
mv "${c}/CHANGELOG.md" "${c}/CHANGELOG.old"
run 2 "${c}"
has "docs-check: the check itself failed"
echo "PASS (docs-check, the repository): every check passes, above its floor, under any git configuration and with CRLF line ends; a missing file exits 2."

# --- Case 2: the payload --------------------------------------------------------------------
c="$(copy imp-number)"
printf '\nAs IMP-123 found, a rule needs its why.\n' >> "${c}/.claude/docs/02-code-quality.md"
run 1 "${c}"
fails 1 "IMP-123: a number of the framework's backlog in the payload"
c="$(copy imp-outside)"
printf '\nAs IMP-123 found.\n' >> "${c}/CONTRIBUTING.md"
printf -- '---\ndate: 2099-01-01\n---\n# A session note\n\nAs IMP-123 found.\n' > "${c}/.claude/memory/sessions/2099-01-01-a-note.md"
run 0 "${c}"
c="$(copy pointer-bare)"
printf '\nThe slots are listed in `SETUP.md`, step 2.\n' >> "${c}/.claude/docs/00-overview.md"
run 1 "${c}"
fails 1 '"SETUP.md" points at SETUP.md'
c="$(copy pointer-names)"
{
  printf '\nRead the README first.\n'
  printf '\nThe workflow is in CONTRIBUTING.md.\n'
  printf '\nRecord the release in CHANGELOG.md.\n'
  printf '\nThe LICENSE covers the copies.\n'
  printf '\nRun the checks in `tools/`.\n'
  printf '\nThen run tools/upgrade-check.sh.\n'
  printf '\nThe slots are in §2.\n'
  printf '\nThe slots are in SETUP§2.\n'
  printf '\nRead step 4 of the upgrade.\n'
  printf '\nThen the upgrade'"'"'s step 3 runs.\n'
  printf '\nAs setup step 2 says.\n'
  printf '\nSee *Hardening*.\n'
} >> "${c}/.claude/docs/00-overview.md"
run 1 "${c}"
fails 12 ".claude/docs/00-overview.md:"
for t in README CONTRIBUTING.md CHANGELOG.md LICENSE '`tools/`' tools/upgrade-check.sh §2 SETUP§ "step 4 of the upgrade" "upgrade's step 3" \
  "setup step 2" "*Hardening*"; do
  has "\"${t}\" points at"
done
c="$(copy pointer-paths)"
{
  printf '\nSee [the guide](../../SETUP.md).\n'
  printf '\nSee [a contribution](../../CONTRIBUTING.md#in-practice-for-a-proposed-change).\n'
  printf '\nRead `../../SETUP.md`, step 2.\n'
  printf '\nRead `%s`.\n' "${note}"
  printf '\nRun [the check](../../tools/docs-check.mjs).\n'
} >> "${c}/.claude/docs/02-code-quality.md"
printf '\nRead `sessions/%s` first.\n' "${note##*/}" >> "${c}/.claude/commands/retro.md"
printf '\nAs [[%s]] records.\n' "$(basename "${note}" .md)" >> "${c}/.claude/docs/02-code-quality.md"
printf '\n@%s\n' "${note}" >> "${c}/.claude/commands/sos.md"
run 1 "${c}"
nfails 8
has ".claude/commands/sos.md:"
has '"../../SETUP.md" points at SETUP.md'
has '"../../CONTRIBUTING.md" points at CONTRIBUTING.md'
has "points at ${note}"
has '"../../tools/docs-check.mjs" points at tools/docs-check.mjs'
has ".claude/commands/retro.md:"
c="$(copy pointer-mixed)"
printf '\nRead the framework'"'"'s `SETUP.md` first. Then fill the slots `SETUP.md`, step 2, lists.\n' >> "${c}/.claude/docs/00-overview.md"
run 1 "${c}"
fails 1 '"SETUP.md" points at SETUP.md'
c="$(copy pointer-labelled)"
printf '\nThe slots are listed in the framework'"'"'s `SETUP.md`, step 2.\n' >> "${c}/.claude/docs/00-overview.md"
printf '\nRecord it in the CHANGELOG, if the project keeps one.\n' >> "${c}/.claude/docs/02-code-quality.md"
run 0 "${c}"
c="$(copy slots)"
printf '\n- the release channel: [TO BE DEFINED].\n- the region: [TO BE\nDEFINED AT SETUP].\n- the zone: [TO\nBE DEFINED AT SETUP].\n' >> "${c}/.claude/docs/02-code-quality.md"
run 1 "${c}"
fails 3 "a slot the setup and upgrade greps cannot see"
echo "PASS (docs-check, payload): IMP numbers, outward pointers by name, section, link, path, wikilink or @-import, short and wrapped slots fail in the payload; a labelled or conditional pointer does not, and does not cover a bare one on its line."

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
c="$(copy inv-more)"
printf '# 07 — Extra\n' > "${c}/.claude/docs/07-extra.md"
printf 'Notes.\n' > "${c}/NOTES.md"
printf '#!/usr/bin/env bash\n' > "${c}/tools/extra.sh"
printf '\nRun `/nonexistent` first.\n' >> "${c}/README.md"
run 1 "${c}"
has "the process documentation of CLAUDE.md lacks .claude/docs/07-extra.md"
has "the Structure tree under the root lacks NOTES.md"
has "the table of tools/README.md lacks extra.sh"
has "/nonexistent: no such command"
c="$(copy inv-recipe)"
printf '#!/usr/bin/env bash\n' > "${c}/scripts/test-extra.sh"
run 1 "${c}"
has "the test-scripts recipe lacks scripts/test-extra.sh"
c="$(copy inv-guards)"
edit "${c}/CLAUDE.md" '^- Slash commands: ' '- Commands of the method: '
edit "${c}/README.md" 'commands/              /checkpoint' 'cmds/                  /checkpoint'
edit "${c}/Makefile" 'bash scripts/' 'bash scriptz/'
run 1 "${c}"
has 'no "- Slash commands:" item in Quick commands'
has "no commands/ line in the Structure tree"
has "only 0 process targets found"
echo "PASS (docs-check, inventories): commands, tables, process targets, the self-tests run, the docs index and the README tree fail when out of step with the files, and a list the check cannot find fails too."

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
# A tag below every release: the current version stays what it is.
c="$(copy cl-tag)"
settle "${c}"
g -C "${c}" tag -a v0.0.9 -m v0.0.9
run 1 "${c}"
fails 1 "v0.0.9 has no entry"
c="$(copy cl-lightweight)"
settle "${c}"
g -C "${c}" tag v0.0.9
run 1 "${c}"
nfails 2
has "v0.0.9 is a lightweight tag"
has "v0.0.9 has no entry"
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
check_in "${c}"
has "CHECK  ${next}: the release being prepared"
hasnt "has no tag"
c="$(copy cl-tomorrow)"
settle "${c}"
v="$(top_entry "${c}")"
next="${v%%.*}.$(( $(echo "${v}" | cut -d. -f2) + 1 )).0"
tomorrow="$(node -e 'const d = new Date(Date.now() + 864e5), p = (n) => String(n).padStart(2, "0");
  console.log(`${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`)')"
entry "${c}" "${next}" "${tomorrow}"
check_in "${c}"
has "CHECK  ${next}: the release being prepared"
hasnt "has no tag"
c="$(copy cl-untagged)"
settle "${c}"
entry "${c}" "9.9.9" "${today}"
run 1 "${c}"
fails 1 "9.9.9 has no tag v9.9.9"
c="$(copy cl-heading)"
edit "${c}/CHANGELOG.md" '^## \[1\.3\.4\] — ' '## [1.3.4] - '
run 1 "${c}"
has '"## [1.3.4] - '
has "v1.3.4 has no entry"
c="$(copy cl-order)"
edit "${c}/CHANGELOG.md" '^## \[1\.3\.3\] — ' '## [1.3.5] — '
run 1 "${c}"
has "1.3.4 is not above 1.3.5"
c="$(copy cl-chain)"
edit "${c}/CHANGELOG.md" '^\*\*Upgrading from 1\.3\.4\*\*' '**Upgrading from 1.3.2**'
run 1 "${c}"
fails 1 "starts from 1.3.2, but the entry below is 1.3.4"
c="$(copy cl-unreleased)"
edit "${c}/CHANGELOG.md" '^## \[Unreleased\]\n\n' ''
run 1 "${c}"
has 'the first "## " heading must be the one "## [Unreleased]"'
c="$(copy cl-dates)"
edit "${c}/CHANGELOG.md" '^## \[1\.3\.3\] — 2026-10-10$' '## [1.3.3] — 2026-10-11'
run 1 "${c}"
has "1.3.4 is dated 2026-10-10, before 1.3.3 (2026-10-11)"
c="$(copy cl-notags)"
for t in $(g -C "${c}" tag -l); do g -C "${c}" tag -d "${t}" >/dev/null; done
run 1 "${c}"
has "no vX.Y.Z tag in this clone"
echo "PASS (docs-check, CHANGELOG): tags and entries in both directions, their form, order, dates and Upgrading chain; the release being prepared, dated today or tomorrow, a CHECK."

# --- Case 5: versions -----------------------------------------------------------------------
c="$(copy version-current)"
printf '\nThe current version is v1.0.0.\n' >> "${c}/CONTRIBUTING.md"
run 1 "${c}"
fails 1 "v1.0.0 reads as the current version"
c="$(copy version-more)"
printf '\nThe latest release, v1.3.0, brings the check.\n\nversion: v1.0.0\n\n![v](https://img.shields.io/badge/version-1.3.0-blue)\n' >> "${c}/CONTRIBUTING.md"
printf '\nToday the framework ships v1.3.4.\n\n## What v1.2.0 brings\n' >> "${c}/CONTRIBUTING.md"
printf '\nPin it: `git checkout v1.3.1`, `git clone --branch v1.3.2`, `git switch v1.2.1`.\n' >> "${c}/CONTRIBUTING.md"
run 1 "${c}"
nfails 8
has "v1.3.1 reads as the current version"
has "v1.3.2 reads as the current version"
has "v1.2.1 reads as the current version"
has "v1.3.4 reads as the current version"
has "v1.2.0 reads as the current version"
has "v1.3.0 reads as the current version"
has "v1.0.0 reads as the current version"
has "a static badge reads 1.3.0"
c="$(copy version-history)"
printf '\nThe tags live on main from v1.0.0 on; v1.1.0 translated it.\n' >> "${c}/CONTRIBUTING.md"
run 0 "${c}"
echo "PASS (docs-check, versions): an old version presented as current — by a word, a marker, a heading, a version: line, a checkout, a badge — fails; a historical one does not."

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
c="$(copy links-more)"
printf '\n@.claude/docs/99-none.md\n' >> "${c}/.claude/commands/retro.md"
{
  printf '\nSee [x](a%%zz.md).\n'
  printf '\nSee docs/04, "No such title".\n'
  printf '\nSee `.claude/docs/04-git-workflow.md` ("No other title").\n'
  printf '\nRun `scripts/no-such-two.sh` before a release, e.g. at the checkpoint.\n'
  printf '\nAn example path, e.g. `scripts/an-example.sh`, names nothing.\n'
} >> "${c}/CONTRIBUTING.md"
printf '\nSee `SETUP.md` §99.\n\nSee docs/04, “No curly title”.\n\nSee SETUP.md, *No bare title*.\n' >> "${c}/CONTRIBUTING.md"
printf '# See docs/04, "No script title".\n# See docs/04, "No such\n# wrapped title".\n' >> "${c}/scripts/reset-task.sh"
printf 'echo "see docs/04, *No message title*"\n' >> "${c}/scripts/reset-task.sh"
run 1 "${c}"
nfails 11
has 'docs/04 has no section "No curly title"'
has 'SETUP.md has no section "No bare title"'
has 'docs/04 has no section "No message title"'
has "SETUP.md has no section §99"
has 'has no section "No such wrapped title"'
has "@.claude/docs/99-none.md: the import names no file"
has "a malformed %-escape"
has 'docs/04 has no section "No such title"'
has 'has no section "No other title"'
has "\`scripts/no-such-two.sh\` names no file"
has 'scripts/reset-task.sh:'
c="$(copy links-wiki)"
printf '# A component\n' > "${c}/.claude/memory/components/dup.md"
printf '# A decision\n' > "${c}/.claude/memory/decisions/dup.md"
printf '\nSee [[dup]] and [[STATE#No such heading]].\n' >> "${c}/CONTRIBUTING.md"
run 1 "${c}"
nfails 2
has "[[dup]] names more than one note"
has "[[STATE#No such heading]]: no such heading in .claude/memory/STATE.md"
echo "PASS (docs-check, links): links, anchors, escapes, wikilinks, @-imports, cited paths, titles and §N — in a doc or a script, wrapped or not — fail when they resolve to nothing; an example does not."

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
c="$(copy list-counts)"
edit "${c}/SETUP.md" 'These eight cases' 'These seven cases'
edit "${c}/SETUP.md" 'It installs three hooks' 'It installs four hooks'
edit "${c}/SETUP.md" 'the four guide READMEs' 'the five guide READMEs'
edit "${c}/README.md" '\+ 4 subfolders' '+ 5 subfolders'
edit "${c}/scripts/test-hooks-install.sh" 'Five cases:' 'Six cases:'
run 1 "${c}"
nfails 5
has '"These seven cases", but the numbered edge cases are 8'
has '"It installs four hooks"'
has '"the five guide READMEs"'
has '"+ 5 subfolders"'
has 'the header says "six cases"'
c="$(copy list-setup)"
edit "${c}/SETUP.md" '`CLAUDE\.md`, `\.claude/settings\.json`, `scripts/hooks-install\.sh`' '`.claude/settings.json`, `scripts/hooks-install.sh`'
edit "${c}/SETUP.md" 'CLAUDE\.md scripts Makefile commitlint' 'CLAUDE.md scripts commitlint'
edit "${c}/SETUP.md" '`CHANGELOG\.md`, `tools/` and `\.github/` are NOT copied' '`CHANGELOG.md`, the checks and `.github/` are NOT copied'
edit "${c}/SETUP.md" 'So are `tools/` —' 'So are the checks —'
edit "${c}/SETUP.md" '\| `## Progress` \|' '| `## Progression` |'
edit "${c}/SETUP.md" '\| `- Proposal:` \|' '| `- Proposals:` |'
edit "${c}/.claude/docs/04-git-workflow.md" '`perf`, ' ''
run 1 "${c}"
has "the HYBRID bullet lacks CLAUDE.md"
has "Step 2's diff pathspec lacks Makefile"
has "step 1 never says tools/ stays out of the copy"
has 'the "Outside the upgrade payload" box lacks tools/'
has "the title table names ## Progression"
has "the label table names Proposals"
has "the Types line lacks perf"
c="$(copy list-guards)"
edit "${c}/SETUP.md" '^## 2\. ' '## Two. '
edit "${c}/tools/upgrade-check.sh" '^classify\(\) \{' 'classify_() {'
edit "${c}/SETUP.md" '^- \*\*METHOD\*\* \(pure' '- **METHODS** (pure'
edit "${c}/SETUP.md" 'Copy into the root of the new repo' 'Copy into the new repository'
edit "${c}/SETUP.md" 'diff vX vY -- \.claude/docs' 'diff vX vY -- ./.claude/docs'
run 1 "${c}"
has "items found in §2: the extraction is wrong"
has "only 0 arms read from classify()"
has 'no "- **METHOD**" bullet in The mental model'
has "the copy list of the payload is gone"
has "Step 2's diff pathspec is gone"
c="$(copy list-tag-class)"
mkdir -p "${c}/.claude/agents"
printf 'An agent.\n' > "${c}/.claude/agents/old.md"
g -C "${c}" add .claude/agents/old.md
g -C "${c}" commit -q -m "chore: an agent definition"
g -C "${c}" tag -a v0.0.8 -m v0.0.8
rm "${c}/.claude/agents/old.md"
run 1 "${c}"
has ".claude/agents/old.md (at v0.0.8) has no class in classify()"
c="$(copy list-shapes)"
edit "${c}/SETUP.md" '`scripts/README\.md`, `commitlint\.config\.cjs`\.' '`scripts/README.md`, `commitlint.config.cjs`, `CLAUDE.md`.'
edit "${c}/SETUP.md" '^3\. \*\*Memory lines' '9. **Memory lines'
edit "${c}/scripts/test-hooks-install.sh" '^# --- Case 3 — .*\n' ''
run 1 "${c}"
has "the METHOD bullet names CLAUDE.md, which classify() puts in HYBRID"
has 'edge case 3 is numbered "9."'
has "the header lists 5 cases, the file marks 4"
c="$(copy list-sources)"
edit "${c}/tools/upgrade-check.sh" '^#   classes <rev>' '#   kinds <rev>  '
edit "${c}/tools/upgrade-check.sh" 'usage: upgrade-check\.sh classes\|' 'usage: upgrade-check.sh '
edit "${c}/tools/README.md" '`classes`, `preflight`' '`preflight`'
edit "${c}/.claude/docs/04-git-workflow.md" '\| `refactor`/`perf`/' '| `refactor`/'
edit "${c}/.claude/commands/integrate.md" '`refactor`/`perf`/`test`' '`refactor`/`test`'
edit "${c}/tools/upgrade-check.sh" '\t## Progress$' '\t## Progression'
edit "${c}/tools/upgrade-check.sh" '\t- Proposal:$' '\t- Proposals:'
run 1 "${c}"
has "the header's Subcommands lacks classes"
has "the usage line lacks classes"
has "its row lacks classes"
has "the bump table lacks perf"
has "the bump rules lacks perf"
has "TITLE_TABLE lacks ## Progress"
has "LABEL_TABLE lacks Proposal"
c="$(copy list-various)"
edit "${c}/.claude/memory/INDEX.md" 'open / applied / deferred / rejected' 'open / applied / deferred'
edit "${c}/SETUP.md" 'Its subcommands: `classes` \(the class table, file by file\), ' 'Its subcommands: '
edit "${c}/SETUP.md" '`\.gitignore`, `\.gitattributes`, `scripts/`\.' '`.gitignore`, `.gitattributes`.'
run 1 "${c}"
nfails 3
has "the backlog's sections without rejected"
has '"Its subcommands:" lacks classes'
has "the copy list lacks scripts"
c="$(copy list-minimums)"
edit "${c}/SETUP.md" '\*\*Node\.js 22\.12 or later' '**Node.js 22.11 or later'
edit "${c}/tools/README.md" 'bash 3\.2 or later' 'bash 3.1 or later'
edit "${c}/SETUP.md" '^- \*\*gitleaks 8\.0\.0 or later\*\*' '- **gitleaks 7.0.0 or later**'
edit "${c}/scripts/README.md" 'Prerequisites \(`check-prerequisites\.sh` checks them\)' 'Prerequisites (commitlint 21.1.0 pinned)'
# An IMP entry is history: the minimum it wrote then stays.
edit "${c}/.claude/memory/LEARNINGS.md" 'a dedicated MINOR release, v1\.5\.0, after v1\.4\.1\.' 'a dedicated MINOR release, v1.5.0, after v1.4.1; Node.js 14.13 or later then.'
run 1 "${c}"
nfails 4
has '"Node.js 22.11 or later", but the minimum scripts/check-prerequisites.sh defines is 22.12'
has '"bash 3.1 or later", but the minimum scripts/check-prerequisites.sh defines is 3.2'
has '"gitleaks 7.0.0 or later", but the minimum scripts/check-prerequisites.sh defines is'
has '"commitlint 21.1.0", but scripts/check-prerequisites.sh pins'
c="$(copy list-minimums-source)"
edit "${c}/scripts/check-prerequisites.sh" '^COMMITLINT=' 'PINNED='
run 1 "${c}"
nfails 1
has "no commitlint pin read from PREREQUISITES and COMMITLINT: the extraction is wrong"
echo "PASS (docs-check, lists): §2 and the slots, the class table and its bullets, Step 2, what is not copied, the counts, the sections, the subcommands, the copy list, the types, the format tables and the written minimums fail when out of step."

# --- Case 8: language -----------------------------------------------------------------------
c="$(copy lang-prose)"
printf '\nQuesto passo resta sempre manuale.\n' >> "${c}/.claude/docs/02-code-quality.md"
run 1 "${c}"
fails 1 "Italian in an artifact: Questo"
c="$(copy lang-accent)"
printf '\nCosì è, perché già.\n' >> "${c}/.claude/docs/02-code-quality.md"
run 1 "${c}"
fails 1 "Italian in an artifact: Così, è, perché, già"
c="$(copy lang-name)"
printf '# A note\n' > "${c}/.claude/memory/sessions/2099-01-01-nota-di-lavoro.md"
run 1 "${c}"
fails 1 "an Italian file name (nota, lavoro)"
c="$(copy lang-guillemets)"
printf '\nThe «hybrid» class.\n' >> "${c}/SETUP.md"
run 1 "${c}"
fails 1 "guillemets"
c="$(copy lang-commit)"
g -C "${c}" commit -q --allow-empty -m "docs: questo blocco resta com'è"
run 1 "${c}"
fails 1 "Italian in its message"
c="$(copy lang-stale)"
edit "${c}/.claude/memory/sessions/2026-09-26-client-harvest-registration.md" 'FINE RISPOSTA' 'END OF ANSWER'
run 1 "${c}"
fails 1 'the legacy string "FINE RISPOSTA" occurs nowhere'
c="$(copy lang-allowed)"
printf -- '---\ndate: 2099-01-01\n---\n# A note\n\nThe user said "questo blocco resta com'"'"'è" and we kept it.\n' > "${c}/.claude/memory/sessions/2099-01-01-a-note.md"
printf '\nA backlog older than the English labels marks it `Destinazione: framework`.\n' >> "${c}/.claude/docs/02-code-quality.md"
printf '\nThanks to José, for the café and the résumé.\n' >> "${c}/CONTRIBUTING.md"
g -C "${c}" commit -q --allow-empty -m "docs: a note" -m "Co-Authored-By: José Núñez <jose@example.invalid>"
g -C "${c}" commit -q --allow-empty -m "docs: another note" -m "Co-Authored-By: Niccolò Della Rosa <niccolo@example.invalid>"
run 0 "${c}"
echo "PASS (docs-check, language): Italian prose — by its words or its accents —, names, guillemets and commit messages fail, and so does a stale legacy form; a quote, a legacy form, an accented name and a co-author's trailer do not."

# --- Case 9: the allow-list -----------------------------------------------------------------
c="$(copy allow-stale)"
edit "${c}/SETUP.md" '`/tmp`' '`/var/tmp`'
run 1 "${c}"
fails 1 '"/tmp: no such command" matches nothing'
c="$(copy allow-subject)"
printf '\nThe pin `.claude/framework-version` is read by `scripts/no-such.sh`.\n' >> "${c}/CONTRIBUTING.md"
run 1 "${c}"
fails 1 "\`scripts/no-such.sh\` names no file"
echo "PASS (docs-check, allow-list): an exception whose cause is gone fails, and none hides another finding of its line."

# --- Case 10: read-only ----------------------------------------------------------------------
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
