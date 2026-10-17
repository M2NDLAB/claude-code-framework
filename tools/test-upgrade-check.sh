#!/usr/bin/env bash
# Self-test of tools/upgrade-check.sh, hermetic: throwaway repositories under a mktemp
# directory, git configured from nothing (no global or system config, no inherited git
# environment), no network. It runs the REAL script end to end.
#
# Cases:
#   1. classes — every payload file of THIS repository's HEAD has a class (with a floor on
#      the counts, so an empty or broken listing cannot pass), and a file added to the
#      payload without one makes it fail; each label of the answers a release moved opens a
#      line of HEAD's CLAUDE.md.
#   2. preflight — on a throwaway framework (tags v1.0.0, v1.0.1, v1.1.0) and a project
#      grafted at v1.0.0: a sound pin passes; a version without its v, a commit that is
#      the tag object, a commit of another release, an unset FW or FW = the project fail;
#      a tag on the pinned commit is suggested, never applied.
#   3. inventory — on the same pair: the measured 3-way of a co-edited hybrid, the edge
#      cases (7, 1, 6, a mode), a slot that moved (edge case 8), the §2 diff, the titles
#      and labels to rename, the Upgrading notes in release order; a doc the project
#      answered inline, docs/04, is METHOD and edge case 7's on an upgrade that crosses no
#      move of its slot.
#   4. invariant — an upgrade that touched the memory only as allowed passes (templates at
#      vY, titles and labels renamed, a pointer repaired, its own note, plan and decision
#      added); each violation fails with exactly one FAIL: an IMP entry edited, deleted,
#      added or moved across sections, an entry hidden in an extra comment, a note edited
#      beyond its pointers (a fact on a pointer line, a pointer line deleted), a note
#      deleted, STATE.md overwritten, a title or a label left in the old form, a file
#      added to components/, a slot the project had answered opened again; the same holds
#      under a hostile git configuration; a restore point after which nothing changed
#      fails.
#   5. post — a reconciled project passes, with the reconciled METHOD file and the moved
#      slot shown to a human, docs/04 answered inline among them; an orphan, a wrong mode, a
#      missing hook, a missing METHOD file, a METHOD file left at vX, conflict markers and
#      a marker broken by a wrap fail.
#   6. line ends — the graft, the upgraded memory and the reconciled project, rebuilt in a
#      copy whose files all have CRLF line ends (core.autocrlf=true: a Windows checkout),
#      print the very lines they print with LF, for inventory, invariant and post; git
#      itself confirms each copy's line ends, so the comparison cannot be LF against LF.
#   7. the line-end step of SETUP.md, Step 3 — read from SETUP.md, run on the project as
#      Git for Windows checks it out: on a clean tree it leaves no framework file with CRLF
#      and the project's own files as they were; with a change not yet committed on a
#      framework file — unstaged, staged, staged only, or hidden from git diff by an
#      assume-unchanged or skip-worktree mark — it refuses and keeps the change and the
#      index; before .gitattributes holds the framework's files to LF, it refuses too.
#   8. read-only — the four subcommands run to their end and leave the project and the
#      framework exactly as they were (scripts/repo-snapshot.sh, the tracked files, the
#      index, the config, the hooks).
#   9. renames and marker lines — on a throwaway framework whose v2.0.0 moves its commands
#      under .claude/commands/fw/, as the real one's v3.0.0 does, and in CLAUDE.md drops a
#      mention of the marker while it adds a slot: inventory names each rename by what the
#      project holds (a customised copy with its merge's measure, an untouched one to bring
#      over), never as a deletion — a command a release in between rewrote included, which
#      git pairs release by release and not across the jump, and one renamed in two
#      releases, also with a backslash in T's path —, and shows the slot the unchanged count
#      would hide; post asks for that slot's answer, fails while an old command file
#      remains, and passes the orphans once they are gone.
#  10. the marker grep — read from SETUP.md's step 2 and run as a project runs it: it prints
#      the slots, the legacy one included, and none of the records it excludes (a kept
#      SETUP.md, the backlog, a dated session note) nor the hooks the install generates in
#      .git/, with the platform's own grep.
#  11. step 1 of a greenfield graft — its blocks read from SETUP.md and run on a throwaway
#      framework, each in a shell of its own, as a user's: the repository starts with its
#      empty commit; the copy is the tag's, not a later commit's nor a file the framework
#      does not track, keeps the scripts executable and leaves the framework's memory out but
#      for LEARNINGS.md's template, with the platform's own tar; run again with a mistyped
#      tag, it stops before writing.
#  12. the answers v4.0.0 moved — on a throwaway framework whose v3.0.0 writes the slot lines
#      of docs/02, docs/04 and CLAUDE.md's rule 5 as the real one does, and whose v4.0.0
#      moves them to CLAUDE.md's *The answers the method reads*: inventory names each slot
#      the project answered, with its answer and its new line, and leaves the open one alone —
#      with a trailing blank or re-flowed too —; edge case 7 only for a doc whose moved slots
#      are all open; a release whose slot lines the table does not know (v2.9.0 here, as the
#      Italian ones before v1.1.0) never reads as nothing moved; invariant fails while an
#      answer the restore point held has its new line still open, asks while the line does
#      not hold it word for word — two answers on one label, one carried —, and passes once
#      each is carried; post names edge case 8 for a doc left as it was.
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
# The table of the answers a release moved, against HEAD: each of its labels opens a line of
# HEAD's CLAUDE.md, so a label renamed in the template fails here, not in a project's upgrade.
labels="$(grep -oE "CLAUDE\.md '[^']+'" "${CHECK}" | sed -E "s/^CLAUDE\.md '(.*)'\$/\1/" | sort -u)"
[ "$(printf '%s\n' "${labels}" | grep -c .)" -eq 9 ] || fail "moved_slots: not the 9 labels of CLAUDE.md's answers read from the script"
git -C "${REPO_ROOT}" show HEAD:CLAUDE.md > "${workdir}/claude-head.md"
while IFS= read -r label; do
  grep -qF -- "- **${label}**" "${workdir}/claude-head.md" || fail "moved_slots: no line **${label}** in HEAD's CLAUDE.md"
done <<< "${labels}"
echo "PASS (upgrade-check classes): every payload file of HEAD has a class; a new one without fails; each label of the moved answers opens a line of HEAD's CLAUDE.md."

# --- The fixture: a throwaway framework with three releases, a project grafted at v1.0.0
FWD="${workdir}/fw"
PRJ="${workdir}/project"
T_DIR="${workdir}/T"
mkdir -p "${T_DIR}"
# put <root> <path> <content>: write a file, creating its directory.
put() { mkdir -p "$(dirname "$1/$2")"; printf '%b' "$3" > "$1/$2"; }
# set_exec <repo> <path> <+x|-x>: a tracked file's executable bit, where git keeps it — the
# filesystem's, and the index's, which is the only one on Windows: there chmod changes
# nothing (measured in the CI). Both, so the fixture means the same on every platform.
set_exec() { chmod "$3" "$1/$2" && g -C "$1" update-index --chmod="$3" -- "$2"; }

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
set_exec "${FWD}" scripts/reset-task.sh +x
put "${FWD}" .claude/docs/00-overview.md '# 00\nThe method, revised.\n'
put "${FWD}" .claude/memory/sessions/README.md 'sessions, second version\nThe plan block of the framework repo.\n'
put "${FWD}" .claude/memory/STATE.md '# STATE\n\n## Progress\n- template\n\n## Active branches\n- template\n'
put "${FWD}" .claude/memory/LEARNINGS.md "# Learnings\nHeader, second version.\n\n## OPEN proposals (awaiting the user's decision)\n\n<!-- Format of a proposal:\n### IMP-001 — <title>\n- Date: YYYY-MM-DD | Origin: <session>\n- Observed problem: <...>\n-->\n\n## Applied\n\n## Deferred (not rejected — resumed at the right time)\n\n## Rejected (with the reason — so they are not re-proposed)\n"
# The framework's own entries make its LEARNINGS.md large (over 128 KB at v1.3.4): a
# reader that stops early, a grep -q under pipefail, fails only past the pipe's buffer.
awk 'BEGIN { for (i = 1; i <= 3000; i++) printf "- the framework entry line %04d, long enough to fill a pipe buffer quickly.\n", i }' >> "${FWD}/.claude/memory/LEARNINGS.md"
[ "$(wc -c < "${FWD}/.claude/memory/LEARNINGS.md")" -gt 131072 ] || fail "fixture: v1.1.0's LEARNINGS.md is not larger than 128 KB"
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
FW="${FWD}" T=relative-T run 2 "${PRJ}" preflight v1.0.0 v1.1.0
has "must be an absolute path"
mkdir -p "${PRJ}/scratch-T"
FW="${FWD}" T="${PRJ}/scratch-T" run 2 "${PRJ}" preflight v1.0.0 v1.1.0
has "is inside a repository"
rmdir "${PRJ}/scratch-T"
set +e
( cd "${PRJ}" && FW="${FWD}" T="${T_DIR}" bash "${FWD}/tools/upgrade-check.sh" preflight v1.0.0 v1.1.0 ) >"${out}" 2>&1
rc=$?
set -e
[ "${rc}" -eq 1 ] || fail "preflight run from the framework's working tree: exit ${rc}, expected 1"
has "FAIL   this copy runs from the framework's working tree"
echo "PASS (upgrade-check preflight): a sound pin passes; a malformed or foreign one fails with its correction; a tag is suggested, never applied."

# --- Case 3: inventory ----------------------------------------------------------------
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" inventory v1.0.0 v1.1.0
has "HYBRID    M  diverged  CLAUDE.md — 3-way: 1 conflict(s)"
has "edge case 6: CLAUDE.md changed in v1.0.1 v1.1.0"
has "edge case 7: .claude/docs/00-overview.md is METHOD but customised"
has "edge case 7: scripts/reset-task.sh is METHOD but customised"
has "scripts/reset-task.sh: v1.1.0's mode is 100755"
has "edge case 1: scripts/test-repo-snapshot.sh is deleted in v1.1.0"
has "markers removed in scripts/reset-task.sh(-1) and added in Makefile(+1): a slot may have MOVED"
has "§2, new or re-worded: Makefile: PROTECTED_BRANCHES"
has "LEARNINGS M  =vX       .claude/memory/LEARNINGS.md (header)"
has "TEMPLATE  =  diverged  .claude/memory/decisions/README.md"
has ".claude/memory/STATE.md lacks v1.1.0's title '## Progress'"
has ".claude/memory/LEARNINGS.md lacks v1.1.0's title '## Deferred (not rejected — resumed at the right time)'"
has "3 line(s) of LEARNINGS.md carry an old-form field label"
grep -n 'INFO   v1.0.1:' "${out}" | cut -d: -f1 > "${workdir}/order"
grep -n 'INFO   v1.1.0:' "${out}" | cut -d: -f1 >> "${workdir}/order"
[ "$(sort -n "${workdir}/order" | tr '\n' ' ')" = "$(tr '\n' ' ' < "${workdir}/order")" ] && [ "$(wc -l < "${workdir}/order")" -eq 2 ] \
  || fail "inventory: the Upgrading notes are not listed oldest first"
has "| **Upgrading from 1.0.1**: move your protected branches to the Makefile first."
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" inventory v1.0.0 v1.0.1
has "v1.0.1's field labels are still the old form: none to rename"
hasnt "old-form field label"
# docs/04 answered inline, on an upgrade that crosses no release moving its slot: METHOD
# from v4.0.0, so a customised METHOD file (edge case 7); Case 12 crosses the move.
put "${PRJ}" .claude/docs/04-git-workflow.md '# 04\nMerge form: the integrate block\n'
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" inventory v1.0.0 v1.1.0
has "METHOD    =  diverged  .claude/docs/04-git-workflow.md"
has "edge case 7: .claude/docs/04-git-workflow.md is METHOD but customised"
hasnt "edge case 8: .claude/docs/04-git-workflow.md"
g -C "${PRJ}" checkout -q -- .claude/docs/04-git-workflow.md
echo "PASS (upgrade-check inventory): the 3-way measured, the edge cases flagged, the moved slot, §2, titles and labels, the notes in order."

# --- Case 4: invariant ----------------------------------------------------------------
RESTORE="$(g -C "${PRJ}" rev-parse HEAD)"
upgraded_state() {
  g -C "${FWD}" show v1.1.0:.claude/memory/sessions/README.md > "${PRJ}/.claude/memory/sessions/README.md"
  put "${PRJ}" .claude/memory/decisions/README.md 'decisions\nADR home: docs/adr\nend\n'
  put "${PRJ}" .claude/memory/LEARNINGS.md "# Learnings\nHeader, second version.\n\n## OPEN proposals (awaiting the user's decision)\n\n### IMP-001 — A lesson of the project\n- Date: 2026-01-02 | Origin: a session\n- Observed problem: something recurs\n- Proposal: do it once\n\n<!-- Format of a proposal:\n### IMP-001 — <title>\n- Date: YYYY-MM-DD | Origin: <session>\n- Observed problem: <...>\n-->\n\n## Applied\n\n## Deferred (not rejected — resumed at the right time)\n\n## Rejected (with the reason — so they are not re-proposed)\n"
  put "${PRJ}" .claude/memory/STATE.md '# STATE\n\n## Progress\n- the project is under way\n\n## Active branches\n- main\n'
  put "${PRJ}" .claude/memory/sessions/2026-01-02-start.md '# The first session\nSee [[STATE]] and docs/04-git-workflow.md#merge.\nA fact of the project.\n'
  put "${PRJ}" .claude/memory/sessions/2026-01-10-framework-upgrade.md '# The upgrade to v1.1.0\n'
  put "${PRJ}" .claude/memory/plans/framework-upgrade-v1.0.0-to-v1.1.0.md '# Plan\n'
  rm -f "${PRJ}/.claude/memory/components/extra.md"
}
# violate <description> <expected line> <command...>: from the sound state, one violation.
violate() {
  local what="$1" expected="$2"
  shift 2
  upgraded_state
  "$@"
  FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" invariant v1.0.0 v1.1.0 "${RESTORE}"
  grep -qF -- "${expected}" "${out}" || fail "invariant, ${what}: expected a line with: ${expected}"
  # Exactly one FAIL: the violation is caught for its own reason, not for a side effect.
  grep -q ": 1 FAIL, " "${out}" || fail "invariant, ${what}: not exactly one FAIL"
}
upgraded_state
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" invariant v1.0.0 v1.1.0 "${RESTORE}"
has "OK     .claude/memory/sessions/README.md: the memory template at v1.1.0"
has "OK     .claude/memory/sessions/2026-01-02-start.md: unchanged but for pointer repairs"
has "OK     .claude/memory/STATE.md: unchanged but for pointer repairs (edge case 3 (a)) and renamed titles or labels"
has "OK     .claude/memory/sessions/2026-01-10-framework-upgrade.md: added"
has "OK     the IMP entries are unchanged"
has "OK     titles and field labels in v1.1.0's form"
lrn="${PRJ}/.claude/memory/LEARNINGS.md"
note="${PRJ}/.claude/memory/sessions/2026-01-02-start.md"
# move_entry_to_applied: the project's entry IMP-001, moved from the OPEN section to Applied.
move_entry_to_applied() {
  awk '/^### IMP-001/ { m = 1 } m && /^$/ { m = 0 } m { e = e $0 "\n"; next } { print } /^## Applied$/ { printf "\n%s", e }' "${lrn}" > "${lrn}.tmp" && mv "${lrn}.tmp" "${lrn}"
}
# subst <file> <from> <to>: replace a literal text, in place, with no backup file left.
subst() {
  F="$2" R="$3" awk '{ p = index($0, ENVIRON["F"]); if (p) $0 = substr($0, 1, p - 1) ENVIRON["R"] substr($0, p + length(ENVIRON["F"])); print }' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}
# insert_before <file> <line> <text...>: insert lines before the first exact match.
insert_before() {
  local f="$1" at="$2"
  shift 2
  printf '%s\n' "$@" > "${workdir}/insert"
  AT="${at}" awk -v ins="${workdir}/insert" '!done && $0 == ENVIRON["AT"] { while ((getline l < ins) > 0) print l; done = 1 } { print }' "${f}" > "${f}.tmp" && mv "${f}.tmp" "${f}"
}
violate "an edited entry" "FAIL   the IMP entries changed" \
  subst "${lrn}" "do it once" "do it twice"
violate "a hidden entry" "comment block(s)" \
  insert_before "${lrn}" "## Applied" "<!-- a note" "### IMP-002 — an entry hidden in a comment" "- Proposal: never seen" "-->" ""
violate "a note's fact" "changed beyond pointer repairs" \
  subst "${note}" "A fact of the project." "Another fact."
violate "a deleted note" "is deleted: an upgrade removes nothing" rm "${note}"
violate "a title left" "still lacks v1.1.0's title '## Progress'" \
  subst "${PRJ}/.claude/memory/STATE.md" "## Progress" "## Stato avanzamento"
violate "a label left" "still carry an old-form field label" \
  subst "${lrn}" "- Proposal: do it once" "- Proposta: do it once"
violate "a slot re-opened" "a slot the project had answered is open again" \
  cp "${FWD}/.claude/memory/decisions/README.md" "${PRJ}/.claude/memory/decisions/README.md"
violate "a component added" "added outside the upgrade's own note, plan and decision records" \
  put "${PRJ}" .claude/memory/components/another.md 'x\n'
rm -f "${PRJ}/.claude/memory/components/another.md"
# The upgrade's own decision record is allowed; a format comment fewer than vY's is shown.
upgraded_state
put "${PRJ}" .claude/memory/decisions/2026-01-10-upgrade-choice.md '# A structural choice of the upgrade\n'
awk '/<!--/{c=1} !c{print} /-->/{c=0}' "${lrn}" > "${lrn}.tmp" && mv "${lrn}.tmp" "${lrn}"
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" invariant v1.0.0 v1.1.0 "${RESTORE}"
has "OK     .claude/memory/decisions/2026-01-10-upgrade-choice.md: added — the upgrade's own decision record"
has "CHECK  the body has 0 comment block(s), v1.1.0's format has 1"
rm -f "${PRJ}/.claude/memory/decisions/2026-01-10-upgrade-choice.md"
violate "STATE overwritten by vY's template" ".claude/memory/STATE.md: changed beyond pointer repairs" \
  cp "${FWD}/.claude/memory/STATE.md" "${PRJ}/.claude/memory/STATE.md"
violate "a fact changed on a pointer line" "changed beyond pointer repairs" \
  subst "${note}" "docs/04-git-workflow.md#merge." "docs/04-git-workflow.md#merge, never again."
violate "a pointer line deleted" "changed beyond pointer repairs" \
  subst "${note}" "See [[STATE]] and docs/04-git-workflow.md#merge." ""
violate "an entry deleted" "FAIL   the IMP entries changed" \
  subst "${lrn}" "- Proposal: do it once" ""
violate "an entry added at Step 5" "FAIL   the IMP entries changed" \
  insert_before "${lrn}" "## Applied" "### IMP-002 — added during the upgrade" "- Proposal: belongs to the retro, after Step 5" ""
violate "an entry moved to Applied" "FAIL   the IMP entries changed" \
  move_entry_to_applied
# A hostile git configuration (colour forced, an external diff) changes nothing.
printf '[color]\n\tui = always\n[diff]\n\texternal = /usr/bin/true\n' > "${workdir}/hostile.gitconfig"
upgraded_state
subst "${note}" "A fact of the project." "Another fact."
GIT_CONFIG_GLOBAL="${workdir}/hostile.gitconfig" FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" invariant v1.0.0 v1.1.0 "${RESTORE}"
has "2026-01-02-start.md: changed beyond pointer repairs"
# A restore point after which nothing changed passes on nothing: it fails.
upgraded_state
g -C "${PRJ}" stash push -q -u
FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" invariant v1.0.0 v1.1.0 "${RESTORE}"
has "nothing in the payload changed since"
g -C "${PRJ}" stash pop -q
# An entry written INSIDE the format comment keeps the count: a human must see it.
upgraded_state
subst "${lrn}" "- Observed problem: <...>" "- Observed problem: an entry hidden in the format comment"
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" invariant v1.0.0 v1.1.0 "${RESTORE}"
has "CHECK  the format comment differs from v1.1.0's"
has "an entry hidden in the format comment"
upgraded_state
[ -z "$(find "${PRJ}/.claude/memory" -name '*.tmp' -o -name '*.bak')" ] || fail "the test left backup files in the memory"
echo "PASS (upgrade-check invariant): the allowed touches pass; every violation of the closed list fails, under any git configuration."

# --- Case 5: post ---------------------------------------------------------------------
reconciled_state() {
  upgraded_state
  for f in .claude/commands/sos.md .claude/docs/04-git-workflow.md .claude/commands/checkpoint.md \
           .claude/settings.json .gitignore commitlint.config.cjs scripts/hooks-install.sh; do
    g -C "${FWD}" show "v1.1.0:${f}" > "${PRJ}/${f}"
  done
  g -C "${FWD}" show v1.1.0:scripts/reset-task.sh > "${PRJ}/scripts/reset-task.sh"
  set_exec "${PRJ}" scripts/reset-task.sh +x
  put "${PRJ}" .claude/docs/00-overview.md '# 00\nThe method, revised, our way.\n'
  put "${PRJ}" Makefile '# [TO BE DEFINED AT SETUP] the branches reset-task must never touch\nPROTECTED_BRANCHES = main dev\nreset-task:\n\tPROTECTED_BRANCHES="$(PROTECTED_BRANCHES)" bash scripts/reset-task.sh\n'
  put "${PRJ}" CLAUDE.md '# Index\nStack: bash\nRule A: the project own wording, kept.\nRule B: fixed in 1.0.1.\n'
  rm -f "${PRJ}/scripts/test-repo-snapshot.sh"
  hooks_dir="$(g -C "${PRJ}" rev-parse --path-format=absolute --git-common-dir)/hooks"
  mkdir -p "${hooks_dir}"
  for h in pre-commit commit-msg pre-push; do
    printf '#!/bin/sh\n# Hook generated by scripts/hooks-install.sh — a stand-in.\n' > "${hooks_dir}/${h}"
    chmod +x "${hooks_dir}/${h}"
  done
}
# break_post <description> <expected line> <command...>
break_post() {
  local what="$1" expected="$2"
  shift 2
  reconciled_state
  "$@"
  FW="${FWD}" T="${T_DIR}" run 1 "${PRJ}" post v1.0.0 v1.1.0
  grep -qF -- "${expected}" "${out}" || fail "post, ${what}: expected a line with: ${expected}"
  grep -q ": 1 FAIL, " "${out}" || fail "post, ${what}: not exactly one FAIL"
}
reconciled_state
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" post v1.0.0 v1.1.0
has "CHECK  .claude/docs/00-overview.md (METHOD) differs from v1.1.0's"
has "CHECK  v1.1.0 added 1 slot(s) to Makefile"
has "PROTECTED_BRANCHES = main dev"
has "OK     pre-push installed, with the generator's marker"
has "OK     no orphan of a file v1.1.0 removed"
has "CHECK  the pin reads 'v1.0.0': Step 6 writes 'version: v1.1.0'"
# docs/04 answered inline, no move crossed: a METHOD file that differs, shown to a human.
reconciled_state
put "${PRJ}" .claude/docs/04-git-workflow.md '# 04\nMerge form: the integrate block\n'
FW="${FWD}" T="${T_DIR}" run 0 "${PRJ}" post v1.0.0 v1.1.0
has "CHECK  .claude/docs/04-git-workflow.md (METHOD) differs from v1.1.0's: fine only if it was reconciled as a hybrid (edge case 7)"
break_post "an orphan" "scripts/test-repo-snapshot.sh is an orphan" \
  put "${PRJ}" scripts/test-repo-snapshot.sh 'echo removed in 1.1.0\n'
break_post "a mode" "scripts/reset-task.sh: mode 100644, v1.1.0's is 100755" \
  set_exec "${PRJ}" scripts/reset-task.sh -x
break_post "a missing hook" "pre-push missing or foreign" \
  rm "${hooks_dir}/pre-push"
break_post "a missing METHOD file" ".claude/commands/sos.md (METHOD) is missing" \
  rm "${PRJ}/.claude/commands/sos.md"
break_post "a METHOD file left at vX" "scripts/reset-task.sh (METHOD) is still v1.0.0's" \
  eval 'g -C "${FWD}" show v1.0.0:scripts/reset-task.sh > "${PRJ}/scripts/reset-task.sh"'
break_post "conflict markers left" "CLAUDE.md: conflict markers left by a merge" \
  put "${PRJ}" CLAUDE.md '# Index\nStack: bash\n<<<<<<< CLAUDE.md\nRule A: the project own wording.\n=======\nRule A: the framework second wording.\n>>>>>>> theirs\nRule B: fixed in 1.0.1.\n'
break_post "a broken marker" "a marker broken by a line wrap" \
  put "${PRJ}" CLAUDE.md '# Index\nStack: bash\nNew slot: [TO BE DEFINED AT\nRule B: fixed in 1.0.1.\n'
reconciled_state
echo "PASS (upgrade-check post): a reconciled project passes; an orphan, a mode, a hook, a missing file and a broken marker fail."

# --- Case 6: line ends ----------------------------------------------------------------
# Git for Windows checks text out with CRLF by default (core.autocrlf=true): a project
# grafted there has every file of the framework with CRLF line ends, and the verdicts must
# not depend on it.
# crlf <dir>: every file of a working tree with CRLF line ends, as such a checkout writes
# them; written in place, so each file keeps its mode.
crlf() {
  find "$1" -path "$1/.git" -prune -o -type f -print | while IFS= read -r f; do
    awk '{ sub(/\r$/, ""); printf "%s\r\n", $0 }' "${f}" > "${workdir}/crlf.tmp"
    cat "${workdir}/crlf.tmp" > "${f}"
  done
}
# The three states, each from the graft as committed.
graft_state() { g -C "${PRJ}" checkout -q -- . && g -C "${PRJ}" clean -q -f -d; }
# The upgraded memory with a guide README of its own, so a template's diff is printed too.
upgraded_from_graft() {
  graft_state && upgraded_state \
    && put "${PRJ}" .claude/memory/sessions/README.md 'sessions, second version, kept our way\nThe plan block of the framework repo.\n'
}
reconciled_from_graft() { graft_state && reconciled_state; }
# eol_count <dir> <eol>: how many of the framework's files have <eol> line ends (lf, crlf)
# in the working tree, as git reads them (ls-files --eol: w/<eol>). On Windows a grep for
# $'\r$' counted none in a clone made with core.autocrlf=true (measured in the CI); git
# reads the bytes themselves.
eol_count() {
  ( cd "$1" && g ls-files --eol -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore scripts ) \
    | awk -v w="w/$2" '$2 == w { n++ } END { print n + 0 }'
}
# same_lines <state> <expected rc> <subcommand...>: the state built in a copy of the project
# with LF line ends and in one with CRLF; the two runs must print the same lines.
same_lines() {
  local state="$1" want="$2" lf_project="${PRJ}" v other
  shift 2
  for v in lf crlf; do
    rm -rf "${workdir}/project-${v}"
    cp -R "${lf_project}" "${workdir}/project-${v}"
    PRJ="${workdir}/project-${v}"
    "${state}"
    if [ "${v}" = crlf ]; then g -C "${PRJ}" config core.autocrlf true && crlf "${PRJ}"; fi
    # Not vacuous: each copy has the line ends it is named after, and only those.
    other=crlf; [ "${v}" = lf ] || other=lf
    [ "$(eol_count "${PRJ}" "${v}")" -gt 0 ] && [ "$(eol_count "${PRJ}" "${other}")" -eq 0 ] \
      || fail "$1: the ${v} copy does not have ${v} line ends only, as git reads them"
    FW="${FWD}" T="${T_DIR}" run "${want}" "${PRJ}" "$@"
    sed "s#${PRJ}#<project>#g" "${out}" > "${workdir}/out.${v}"
  done
  PRJ="${lf_project}"
  diff "${workdir}/out.lf" "${workdir}/out.crlf" > "${workdir}/out.diff" || {
    cat "${workdir}/out.diff" >&2
    fail "$1: with CRLF line ends the verdict differs from the one with LF (the diff above)"
  }
}
same_lines graft_state 0 inventory v1.0.0 v1.1.0
grep -q "3-way: 1 conflict(s)" "${workdir}/out.crlf" || fail "line ends: the inventory measured no 3-way"
same_lines upgraded_from_graft 0 invariant v1.0.0 v1.1.0 "${RESTORE}"
grep -q "a memory template that differs from v1.1.0's" "${workdir}/out.crlf" || fail "line ends: invariant printed no template's diff"
same_lines reconciled_from_graft 0 post v1.0.0 v1.1.0
grep -q "OK     pre-push installed" "${workdir}/out.crlf" || fail "line ends: post read no hook list"
grep -q "the pin reads 'v1.0.0'" "${workdir}/out.crlf" || fail "line ends: post read no pin"
echo "PASS (upgrade-check line ends): with CRLF line ends the graft, the upgraded memory and the reconciled project get the verdicts they get with LF."

# --- Case 7: the line-end step of Step 3 ------------------------------------------------
# SETUP.md, Step 3, "Line ends, first": on a working tree with CRLF line ends, it rewrites
# the framework's paths with LF from the last commit — so it must refuse, rewriting
# nothing, when those paths carry a change not yet committed, and when no .gitattributes
# holds them to LF yet. The block is READ from SETUP.md, never retyped here.
step="${workdir}/line-end-step.sh"
awk '/\*\*Line ends, first/ { f = 1 } f && /^  ```bash$/ { b = 1; next } b && /^  ```$/ { exit } b { sub(/^  /, ""); print }' \
  "${REPO_ROOT}/SETUP.md" > "${step}"
[ -s "${step}" ] || fail "line-end step: no bash block under \"Line ends, first\" in SETUP.md"
# windows_project <name> [without-attributes]: the project as Git for Windows checks it out
# (a clone with core.autocrlf=true), a file of its own outside the framework's paths, and —
# unless told otherwise — the framework's .gitattributes brought in, as the step's sentence
# says.
windows_project() {
  g clone -q -c core.autocrlf=true "${PRJ}" "${workdir}/$1"
  printf 'notes of the project\r\n' > "${workdir}/$1/notes.txt"
  g -C "${workdir}/$1" add notes.txt && g -C "${workdir}/$1" commit -q -m "docs: the project's own notes"
  [ "${2:-}" = without-attributes ] || cp "${REPO_ROOT}/.gitattributes" "${workdir}/$1/.gitattributes"
}
# run_step <dir>: the step, from the project's root; its exit code in ${rc}.
run_step() { set +e; ( cd "$1" && bash "${step}" ) > "${out}" 2>&1; rc=$?; set -e; }
windows_project win-clean
[ "$(eol_count "${workdir}/win-clean" crlf)" -gt 0 ] || fail "line-end step: the clone has no CRLF framework file to rewrite"
cksum "${workdir}/win-clean/notes.txt" > "${workdir}/notes.before"
run_step "${workdir}/win-clean"
[ "${rc}" -eq 0 ] || fail "line-end step on a clean tree: exit ${rc}"
[ "$(eol_count "${workdir}/win-clean" crlf)" -eq 0 ] || fail "line-end step: framework files left with CRLF"
cksum "${workdir}/win-clean/notes.txt" | diff "${workdir}/notes.before" - >/dev/null || fail "line-end step: the project's own file changed"
# A change not yet committed on a framework file — unstaged; staged; staged only, the
# working file back to the commit's text; under an assume-unchanged or a skip-worktree mark,
# where git diff sees nothing: refused every time, the change and the index kept.
for kind in unstaged staged staged-only assume-unchanged skip-worktree; do
  windows_project "win-${kind}"
  w="${workdir}/win-${kind}"
  case "${kind}" in assume-unchanged | skip-worktree) g -C "${w}" update-index --"${kind}" CLAUDE.md ;; esac
  printf 'An answer of the project, not yet committed.\r\n' >> "${w}/CLAUDE.md"
  case "${kind}" in staged*) g -C "${w}" add CLAUDE.md ;; esac
  [ "${kind}" = staged-only ] && g -C "${w}" show HEAD:CLAUDE.md > "${w}/CLAUDE.md"
  cksum "${w}/CLAUDE.md" > "${workdir}/claude.before"
  g -C "${w}" ls-files -s -v > "${workdir}/index.before"
  before="$(eol_count "${w}" crlf)"
  run_step "${w}"
  [ "${rc}" -ne 0 ] || fail "line-end step, a change (${kind}): it ran instead of refusing"
  cksum "${w}/CLAUDE.md" | diff "${workdir}/claude.before" - >/dev/null || fail "line-end step, a change (${kind}): the change was overwritten"
  g -C "${w}" ls-files -s -v | diff "${workdir}/index.before" - >/dev/null || fail "line-end step, a change (${kind}): the index changed before the refusal"
  [ "$(eol_count "${w}" crlf)" -eq "${before}" ] || fail "line-end step, a change (${kind}): files were rewritten before the refusal"
  case "${kind}" in
    staged*) g -C "${w}" diff --cached --quiet -- CLAUDE.md && fail "line-end step, a change (${kind}): the staged change was dropped" ;;
  esac
done
# Before .gitattributes is brought over, the step would write CRLF again and look done.
windows_project win-no-attributes without-attributes
w="${workdir}/win-no-attributes"
g -C "${w}" ls-files -s -v > "${workdir}/index.before"
run_step "${w}"
[ "${rc}" -ne 0 ] || fail "line-end step without .gitattributes: it ran instead of refusing"
g -C "${w}" ls-files -s -v | diff "${workdir}/index.before" - >/dev/null || fail "line-end step without .gitattributes: the index changed before the refusal"
echo "PASS (upgrade-check line-end step): SETUP.md's step leaves no framework file with CRLF and the project's own files untouched; with a change not yet committed — staged or not, or hidden by an assume-unchanged or skip-worktree mark — it refuses and keeps it and the index; before .gitattributes holds the files to LF, it refuses."

# --- Case 8: read-only ----------------------------------------------------------------
snapshot() {
  bash "${REPO_ROOT}/scripts/repo-snapshot.sh" "$1"
  g -C "$1" --no-optional-locks diff HEAD
  g -C "$1" --no-optional-locks status --porcelain
  # What the snapshot does not see: an index refresh, a config write, the hooks.
  cksum "$1/.git/index" "$1/.git/config" 2>/dev/null
  ls -la "$1/.git/hooks"
}
snapshot "${PRJ}" > "${workdir}/prj.before"
snapshot "${FWD}" > "${workdir}/fw.before"
for sub in "preflight v1.0.0 v1.1.0" "inventory v1.0.0 v1.1.0" "invariant v1.0.0 v1.1.0 ${RESTORE}" "post v1.0.0 v1.1.0"; do
  ( cd "${PRJ}" && FW="${FWD}" T="${T_DIR}" bash "${CHECK}" ${sub} ) >"${out}" 2>&1 || true
  # Each subcommand ran to its end: a run that died early would prove nothing.
  grep -q "^${sub%% *} v1.0.0 -> v1.1.0.*: [0-9]* FAIL, [0-9]* CHECK$" "${out}" || fail "read-only: ${sub%% *} did not run to its end"
done
snapshot "${PRJ}" | diff "${workdir}/prj.before" - >/dev/null || fail "read-only: the project changed"
snapshot "${FWD}" | diff "${workdir}/fw.before" - >/dev/null || fail "read-only: the framework changed"
[ "$(find "${T_DIR}" -mindepth 1 -maxdepth 1)" = "${T_DIR}/upgrade-check" ] || fail "read-only: something was written in T outside T/upgrade-check"
echo "PASS (upgrade-check read-only): the project and the framework unchanged; writes only under T/upgrade-check."

# --- Case 9: renames ------------------------------------------------------------------
# A framework of its own: v2.0.0 moves both commands under .claude/commands/fw/ and edits
# one of them; the project, grafted at v1.0.0, answered that one's placeholder. One unchanged
# line separates the two edits, so the merge is clean (the distance rule of CONTRIBUTING.md).
# Its T is the one the first fixture used: tags of the same names in another FW, which
# listings cached by name across runs would confuse.
FW9="${workdir}/fw9"
P9="${workdir}/project9"
g init -q -b main "${FW9}"
put "${FW9}" CLAUDE.md '# Index\nThe slots are marked [TO BE DEFINED AT SETUP].\n'
put "${FW9}" .claude/commands/checkpoint.md 'checkpoint\nIntegration branch: <integration>\nAn unchanged line.\nStep two.\n'
put "${FW9}" .claude/commands/sos.md 'sos\n'
put "${FW9}" .claude/commands/integrate.md 'integrate\nBlock one: <integration>\nBlock two: <stable>\nThe end.\n'
put "${FW9}" .claude/commands/retro.md 'retro\nReflect on the deliverable.\n'
put "${FW9}" .claude/memory/STATE.md '# STATE\n'
g -C "${FW9}" add -A && g -C "${FW9}" commit -q -m "feat: 1.0.0" && g -C "${FW9}" tag -a v1.0.0 -m v1.0.0
# A release in between rewrites integrate.md: from v1.0.0 to v2.0.0 git pairs nothing, while
# each release's own diff does — a jump of several releases, as from v1.2.0 to v3.0.0. It
# also moves retro.md once, before v2.0.0 moves it again: two renames, composed.
put "${FW9}" .claude/commands/integrate.md 'integrate, rewritten\nStep one: the names of the branches.\nStep two: the merge block.\nStep three: the push block.\nStep four: the checks.\n'
g -C "${FW9}" mv .claude/commands/retro.md .claude/commands/retrospective.md
g -C "${FW9}" commit -q -am "feat: 1.5.0" && g -C "${FW9}" tag -a v1.5.0 -m v1.5.0
mkdir -p "${FW9}/.claude/commands/fw"
g -C "${FW9}" mv .claude/commands/checkpoint.md .claude/commands/fw/checkpoint.md
g -C "${FW9}" mv .claude/commands/sos.md .claude/commands/fw/sos.md
g -C "${FW9}" mv .claude/commands/integrate.md .claude/commands/fw/integrate.md
g -C "${FW9}" mv .claude/commands/retrospective.md .claude/commands/fw/retro.md
put "${FW9}" .claude/commands/fw/checkpoint.md 'checkpoint\nIntegration branch: <integration>\nAn unchanged line.\nStep two, with the file tools.\n'
put "${FW9}" .claude/commands/fw/integrate.md 'integrate, rewritten\nStep one: the names of the branches.\nStep two: the merge block.\nStep three: the push block.\nStep four: the checks, each printing a line.\n'
# The mention goes, a slot comes: one marker line before and after, a count would see nothing.
put "${FW9}" CLAUDE.md '# Index\nThe slots carry the setup marker.\nStack: [TO BE DEFINED AT SETUP]\n'
g -C "${FW9}" add -A && g -C "${FW9}" commit -q -m "feat!: 2.0.0" && g -C "${FW9}" tag -a v2.0.0 -m v2.0.0
mkdir -p "${P9}"
g -C "${FW9}" archive v1.0.0 -- .claude CLAUDE.md | tar -x -C "${P9}"
put "${P9}" .claude/commands/checkpoint.md 'checkpoint\nIntegration branch: main\nAn unchanged line.\nStep two.\n'
g init -q -b main "${P9}" && g -C "${P9}" add -A && g -C "${P9}" commit -q -m "chore: graft the framework v1.0.0"
FW="${FW9}" T="${T_DIR}" run 0 "${P9}" inventory v1.0.0 v2.0.0
has "edge case 2: renamed between v1.0.0 and v2.0.0: .claude/commands/checkpoint.md -> .claude/commands/fw/checkpoint.md — customised in the project: merge it into .claude/commands/fw/checkpoint.md"
has "3-way: 0 conflict(s), 0 of 4 lines in conflict"
has "edge case 2: renamed between v1.0.0 and v2.0.0: .claude/commands/sos.md -> .claude/commands/fw/sos.md — the project's copy is v1.0.0's"
has "edge case 2: renamed between v1.0.0 and v2.0.0: .claude/commands/integrate.md -> .claude/commands/fw/integrate.md — the project's copy is v1.0.0's"
has "edge case 2: renamed between v1.0.0 and v2.0.0: .claude/commands/retro.md -> .claude/commands/fw/retro.md — the project's copy is v1.0.0's"
hasnt "edge case 1:"
has "added in CLAUDE.md(+1)"
hasnt "fw/checkpoint.md(+"
# The same inventory with a T whose path holds a backslash, as Windows writes one (C:\…):
# awk reads a -v value's escapes, so a path passed that way would stop matching its own
# file, and the two renames of retro.md would not compose.
T9B="${workdir}/T\\b9"
mkdir -p "${T9B}"
FW="${FW9}" T="${T9B}" run 0 "${P9}" inventory v1.0.0 v2.0.0
has "edge case 2: renamed between v1.0.0 and v2.0.0: .claude/commands/retro.md -> .claude/commands/fw/retro.md — the project's copy is v1.0.0's"
hasnt "edge case 1:"
# The migration half done: the merged command in its new place, retro.md moved, the old
# sos.md and integrate.md still there.
g -C "${FW9}" show v2.0.0:CLAUDE.md > "${P9}/CLAUDE.md"
put "${P9}" .claude/commands/fw/checkpoint.md 'checkpoint\nIntegration branch: main\nAn unchanged line.\nStep two, with the file tools.\n'
g -C "${FW9}" show v2.0.0:.claude/commands/fw/sos.md > "${P9}/.claude/commands/fw/sos.md"
g -C "${FW9}" show v2.0.0:.claude/commands/fw/integrate.md > "${P9}/.claude/commands/fw/integrate.md"
g -C "${FW9}" show v2.0.0:.claude/commands/fw/retro.md > "${P9}/.claude/commands/fw/retro.md"
rm "${P9}/.claude/commands/checkpoint.md" "${P9}/.claude/commands/retro.md"
FW="${FW9}" T="${T_DIR}" run 1 "${P9}" post v1.0.0 v2.0.0
has "FAIL   .claude/commands/sos.md is the old place of .claude/commands/fw/sos.md (edge case 2): remove it once merged — until then Claude Code runs it under its bare name"
has "FAIL   .claude/commands/integrate.md is the old place of .claude/commands/fw/integrate.md (edge case 2)"
hasnt ".claude/commands/checkpoint.md is the old place"
has "CHECK  v2.0.0 added 1 slot(s) to CLAUDE.md"
rm "${P9}/.claude/commands/sos.md" "${P9}/.claude/commands/integrate.md"
FW="${FW9}" T="${T_DIR}" run 1 "${P9}" post v1.0.0 v2.0.0
has "OK     no orphan of a file v2.0.0 removed or renamed"
hasnt "is the old place of"
echo "PASS (upgrade-check renames and marker lines): inventory names each rename by what the project holds, with the merge's measure, never as a deletion, and a slot a mention's removal would hide in the count; post asks for it, and fails while an old command file remains."

# --- Case 10: the marker grep -----------------------------------------------------------
# The grep of SETUP.md's step 2, read from the guide as a project reads it, run with the
# platform's own grep on a project that holds slots and the records the grep leaves out.
grep_line="$(awk '/^## 2\./{f=1} /^## 3\./{f=0} f && /^grep -rnE /{print; exit}' "${REPO_ROOT}/SETUP.md")"
[ -n "${grep_line}" ] || fail "marker grep: no grep line in SETUP.md's step 2"
G="${workdir}/grep-project"
put "${G}" CLAUDE.md 'Stack: [TO BE DEFINED AT SETUP]\n'
put "${G}" docs/legacy.md 'Old: [DA DEFINIRE AL SETUP]\n'
put "${G}" .claude/memory/decisions/README.md 'ADR home: [TO BE DEFINED AT SETUP]\n'
put "${G}" SETUP.md 'prose that names the [TO BE DEFINED AT SETUP] marker\n'
put "${G}" .claude/memory/LEARNINGS.md 'an entry that names the [TO BE DEFINED AT SETUP] marker\n'
put "${G}" .claude/memory/sessions/2026-01-02-start.md 'a note that names the [TO BE DEFINED AT SETUP] marker\n'
# The hooks the install generates carry the formatting slot while it is open, and an earlier
# release's hook its .bak: generated files, never slots to fill by hand.
put "${G}" .git/hooks/pre-commit '# 2. AUTOMATIC FORMATTING — [TO BE DEFINED AT SETUP].\n'
put "${G}" .git/hooks/pre-commit.bak '# 2. AUTOMATIC FORMATTING — [TO BE DEFINED AT SETUP].\n'
( cd "${G}" && eval "${grep_line}" ) | sed 's#^\./##' | LC_ALL=C sort > "${out}" || true
printf '%s\n' '.claude/memory/decisions/README.md:1:ADR home: [TO BE DEFINED AT SETUP]' \
  'CLAUDE.md:1:Stack: [TO BE DEFINED AT SETUP]' 'docs/legacy.md:1:Old: [DA DEFINIRE AL SETUP]' \
  | LC_ALL=C sort > "${workdir}/grep.expected"
diff "${workdir}/grep.expected" "${out}" >/dev/null || fail "marker grep: it printed other lines than the three slots"
echo "PASS (upgrade-check marker grep): SETUP.md's grep prints the slots, the legacy one included, and none of the records it leaves out nor the generated hooks."

# --- Case 11: step 1 of a greenfield graft ------------------------------------------------
# The two blocks a new project runs before its setup, read from the guide: the start of the
# repository, and the copy by tag. The framework holds a commit after its tag and a file it
# does not track — both must stay behind —, and its own memory: a dated note and IMP entries.
FW11="${workdir}/fw11"
g init -q -b main "${FW11}"
put "${FW11}" CLAUDE.md '# Index\n'
put "${FW11}" Makefile 'help:\n\t@echo help\n'
put "${FW11}" commitlint.config.cjs 'module.exports = {};\n'
put "${FW11}" .gitignore '.env\n'
put "${FW11}" .gitattributes '* text=auto\n'
put "${FW11}" .claude/settings.json '{}\n'
put "${FW11}" scripts/hooks-install.sh '#!/usr/bin/env bash\necho hooks\n'
put "${FW11}" .claude/memory/sessions/README.md 'the sessions guide\n'
put "${FW11}" .claude/memory/sessions/2026-01-02-work.md 'a note of the framework\n'
put "${FW11}" .claude/memory/LEARNINGS.md "---\nupdated: 2026-01-02\n---\n# Learnings\nThe header.\n\n## OPEN proposals (awaiting the user's decision)\n\n### IMP-007 — An entry of the framework\n- Observed problem: something\n\n<!-- Format of a proposal:\n### IMP-001 — <short title>\n-->\n\n## Applied\n\n### IMP-003 — An applied entry\n\n## Deferred (not rejected — resumed at the right time)\n\n## Rejected (with the reason — so they are not re-proposed)\n"
g -C "${FW11}" add -A && set_exec "${FW11}" scripts/hooks-install.sh +x
g -C "${FW11}" commit -q -m "feat: 1.0.0" && g -C "${FW11}" tag -a v1.0.0 -m v1.0.0
put "${FW11}" CLAUDE.md '# Index\nA line committed after the tag.\n'
g -C "${FW11}" commit -q -am "feat: after the tag"
put "${FW11}" .claude/settings.local.json '{"permissions": {"allow": ["Bash(make:*)"]}}\n'
step1="$(awk '/^## 1\./{f=1} /^## 2\./{f=0} f' "${REPO_ROOT}/SETUP.md")"
start_block="$(printf '%s\n' "${step1}" | awk '/^git init -b <integration>/{f=1} f{print} f && /echo "root: OK"/{exit}' \
  | sed -e 's/<integration>/develop/g' -e 's/<stable>/main/g' -e "s#<the remote's URL>#file:///nonexistent#g")"
copy_block="$(printf '%s\n' "${step1}" | awk '/^: "\$\{FW:\?\}" && test/{f=1} f{print} f && /echo "payload: OK"/{exit}' \
  | sed 's/vX\.Y\.Z/v1.0.0/g')"
[ -n "${start_block}" ] && [ -n "${copy_block}" ] || fail "step 1: a block of SETUP.md not found"
P11="${workdir}/project11"
mkdir -p "${P11}"
# Each block runs in a shell of its own, as a user's: without this test's errexit and
# pipefail, a pipe returns its last command's status.
( cd "${P11}" \
    && export GIT_AUTHOR_NAME=self-test GIT_AUTHOR_EMAIL=self-test@example.invalid \
       GIT_COMMITTER_NAME=self-test GIT_COMMITTER_EMAIL=self-test@example.invalid \
    && bash -c "${start_block}" && git switch -q -c chore/graft-framework \
    && FW="${FW11}" bash -c "${copy_block}" ) > "${out}" 2>&1 \
  || fail "step 1's blocks did not run to their end"
has "root: OK"
has "payload: OK"
[ "$(g -C "${P11}" rev-list --count develop)" = 1 ] && [ "$(g -C "${P11}" rev-list --count main)" = 1 ] \
  || fail "step 1: the start is not one empty commit on both branches"
[ -x "${P11}/scripts/hooks-install.sh" ] || fail "step 1: the copy lost a script's executable mode"
grep -qx '# Index' "${P11}/CLAUDE.md" && ! grep -q 'after the tag' "${P11}/CLAUDE.md" \
  || fail "step 1: the copy is not the tag's"
[ ! -e "${P11}/.claude/settings.local.json" ] || fail "step 1: the copy took a file the framework does not track"
[ ! -e "${P11}/.claude/memory/sessions/2026-01-02-work.md" ] || fail "step 1: the copy took a session note of the framework"
[ -f "${P11}/.claude/memory/sessions/README.md" ] || fail "step 1: the copy lost the sessions guide"
[ "$(grep -c '^### IMP-' "${P11}/.claude/memory/LEARNINGS.md")" = 1 ] || fail "step 1: LEARNINGS.md kept an entry of the framework"
[ "$(grep -c '^## ' "${P11}/.claude/memory/LEARNINGS.md")" = 4 ] || fail "step 1: LEARNINGS.md lost one of its four titles"
# The copy run again over the first, its tag mistyped: bsdtar takes an empty archive for a
# good one, so the chain must stop before it writes, and the line that proves the copy stay
# silent over the files the first run left.
cp "${P11}/.claude/memory/LEARNINGS.md" "${workdir}/learnings11.before"
retag_block="$(printf '%s\n' "${copy_block}" | sed 's/v1\.0\.0/v1.0.9/g')"
if ( cd "${P11}" && FW="${FW11}" bash -c "${retag_block}" ) > "${out}" 2>&1; then
  fail "step 1: the copy ran to its end with a tag that does not exist"
fi
hasnt "payload: OK"
cmp -s "${workdir}/learnings11.before" "${P11}/.claude/memory/LEARNINGS.md" \
  || fail "step 1: a run with a mistyped tag rewrote LEARNINGS.md"
echo "PASS (upgrade-check step 1): the repository starts with its empty commit; the copy is the tag's, its script executable, nothing untracked, no memory of the framework but LEARNINGS.md's template; run again with a mistyped tag, it stops and writes nothing."

# --- Case 12: the answers v4.0.0 moved ---------------------------------------------------------
# The slot lines of v3.0.0 are the real ones, byte for byte: the entries of moved_slots match
# them whole. The marker is built here, so this file never carries it as a slot would.
M="[TO BE DEFINED A""T SETUP]"
MI="[DA DEFINIRE A""L SETUP]"
FW12="${workdir}/fw12"
P12="${workdir}/project12"
T12="${workdir}/T12"
mkdir -p "${T12}"
g init -q -b main "${FW12}"
# v2.9.0 writes its slots in another form, as the releases before v1.1.0 did in Italian.
put "${FW12}" CLAUDE.md "# Index\nStack: ${MI}\n5. Documentation updated (it lives: ${MI}).\n"
put "${FW12}" .claude/docs/02-code-quality.md "# 02\n- Every public unit: a documentation comment (the tool: ${MI}).\n"
put "${FW12}" .claude/docs/04-git-workflow.md "# 04\n- The merge: ${MI}.\n"
put "${FW12}" .claude/memory/STATE.md '# STATE\n'
g -C "${FW12}" add -A && g -C "${FW12}" commit -q -m "feat: 2.9.0" && g -C "${FW12}" tag -a v2.9.0 -m v2.9.0
put "${FW12}" CLAUDE.md "# Index\nStack: ${M}\n5. Documentation updated:\n   aligned (where the project documentation lives: ${M}). Same\n   logic as the memory.\n"
put "${FW12}" .claude/docs/02-code-quality.md "# 02\n- Every public unit: a documentation comment. *(The tool is\n  ${M}.)*\n- Errors: expose a structured format to\n  the client *(which one — ${M})*, never stacktraces/queries/\n  internal paths.\n7. Project documentation updated *(where it lives —\n   ${M})*; if the project documentation does not exist yet, the\n   debt is recorded.\n"
put "${FW12}" .claude/docs/04-git-workflow.md "# 04\n- The merge, in one of two forms — which one the project adopts is\n  ${M}:\n  - via Pull Request;\n"
put "${FW12}" .claude/memory/STATE.md '# STATE\n'
g -C "${FW12}" add -A && g -C "${FW12}" commit -q -m "feat: 3.0.0" && g -C "${FW12}" tag -a v3.0.0 -m v3.0.0
put "${FW12}" CLAUDE.md "# Index\nStack: ${M}\n5. Documentation updated:\n   aligned (where the project documentation lives: the answer **Documentation**, below). Same\n   logic as the memory.\n\n## The answers the method reads\n- **Documentation** — where it lives: ${M}\n- **Merge** — the form: ${M}\n- **Doc comments** — the tool: ${M}\n- **Error format** — the format: ${M}\n"
put "${FW12}" .claude/docs/02-code-quality.md "# 02\n- Every public unit: a documentation comment. *(The tool is the answer **Doc comments**.)*\n- Errors: expose a structured format to\n  the client *(the answer **Error format**)*, never stacktraces/queries/\n  internal paths.\n7. Project documentation updated *(where it lives — the answer\n   **Documentation**)*; if the project documentation does not exist yet, the\n   debt is recorded.\n"
put "${FW12}" .claude/docs/04-git-workflow.md "# 04\n- The merge, in one of two forms — which one the project adopts is its answer **Merge**:\n  - via Pull Request;\n"
g -C "${FW12}" add -A && g -C "${FW12}" commit -q -m "refactor!: 4.0.0" && g -C "${FW12}" tag -a v4.0.0 -m v4.0.0
# The project, grafted at v3.0.0: rule 5, the doc comments and the merge answered, the error
# format left open; the documentation answered twice, in rule 5 and in the DoD's point 7 —
# two answers one label receives.
mkdir -p "${P12}"
g -C "${FW12}" archive v3.0.0 -- .claude CLAUDE.md | tar -x -C "${P12}"
put "${P12}" CLAUDE.md "# Index\nStack: bash\n5. Documentation updated:\n   aligned (where the project documentation lives: the docs/ folder). Same\n   logic as the memory.\n"
put "${P12}" .claude/docs/02-code-quality.md "# 02\n- Every public unit: a documentation comment. *(The tool is\n  shdoc.)*\n- Errors: expose a structured format to\n  the client *(which one — ${M})*, never stacktraces/queries/\n  internal paths.\n7. Project documentation updated *(where it lives —\n   the wiki)*; if the project documentation does not exist yet, the\n   debt is recorded.\n"
put "${P12}" .claude/docs/04-git-workflow.md "# 04\n- The merge, in one of two forms — which one the project adopts is\n  the /fw:integrate block:\n  - via Pull Request;\n"
g init -q -b main "${P12}" && g -C "${P12}" add -A && g -C "${P12}" commit -q -m "chore: graft the framework v3.0.0"
RESTORE12="$(g -C "${P12}" rev-parse HEAD)"
FW="${FW12}" T="${T12}" run 0 "${P12}" inventory v3.0.0 v4.0.0
has "edge case 8: .claude/docs/02-code-quality.md: the slot of '${M}.)*' is answered in the project ('shdoc') — v4.0.0 moved it: carry the answer to CLAUDE.md, the line **Doc comments**"
has "edge case 8: .claude/docs/04-git-workflow.md: the slot of '${M}:' is answered in the project ('the /fw:integrate block') — v4.0.0 moved it: carry the answer to CLAUDE.md, the line **Merge**"
has "edge case 8: CLAUDE.md: the slot of 'aligned (where the project documentation lives: ${M}). Same' is answered in the project ('the docs/ folder') — v4.0.0 moved it: carry the answer to CLAUDE.md, the line **Documentation**"
has "edge case 8: .claude/docs/02-code-quality.md: the slot of '${M})*; if the project documentation does not exist yet, the' is answered in the project ('the wiki') — v4.0.0 moved it: carry the answer to CLAUDE.md, the line **Documentation**"
has "INFO   .claude/docs/02-code-quality.md: 'the client *(which one — ${M})*, never stacktraces/queries/' is open in the project: nothing to carry"
has "edge case 8: .claude/docs/02-code-quality.md is METHOD in v4.0.0 and the project answered slots of it a release moved (below)"
hasnt "edge case 7:"
# Half carried: the docs brought over, CLAUDE.md at v4.0.0 with two answers carried, the
# documentation's left open.
for f in .claude/docs/02-code-quality.md .claude/docs/04-git-workflow.md; do g -C "${FW12}" show "v4.0.0:${f}" > "${P12}/${f}"; done
put "${P12}" CLAUDE.md "# Index\nStack: bash\n5. Documentation updated:\n   aligned (where the project documentation lives: the answer **Documentation**, below). Same\n   logic as the memory.\n\n## The answers the method reads\n- **Documentation** — where it lives: ${M}\n- **Merge** — the form: the /fw:integrate block\n- **Doc comments** — the tool: shdoc\n- **Error format** — the format: ${M}\n"
FW="${FW12}" T="${T12}" run 1 "${P12}" invariant v3.0.0 v4.0.0 "${RESTORE12}"
has "FAIL   CLAUDE.md: 'aligned (where the project documentation lives: ${M}). Same' was answered at the restore point, and its new line in CLAUDE.md, **Documentation**, is still open"
has "FAIL   .claude/docs/02-code-quality.md: '${M})*; if the project documentation does not exist yet, the' was answered at the restore point, and its new line in CLAUDE.md, **Documentation**, is still open"
has "OK     .claude/docs/02-code-quality.md: its answer ('shdoc') is on CLAUDE.md's line **Doc comments**"
has "OK     .claude/docs/04-git-workflow.md: its answer ('the /fw:integrate block') is on CLAUDE.md's line **Merge**"
has "OK     .claude/docs/02-code-quality.md: 'the client *(which one — ${M})*, never stacktraces/queries/' was open at the restore point, nothing to carry"
grep -q ": 2 FAIL, " "${out}" || fail "invariant, the answers of one label left behind: not exactly two FAILs"
# One of the label's two answers carried: the line is no longer open, and the other answer is
# still not on it — a CHECK that quotes it, never an OK.
put "${P12}" CLAUDE.md "# Index\nStack: bash\n5. Documentation updated:\n   aligned (where the project documentation lives: the answer **Documentation**, below). Same\n   logic as the memory.\n\n## The answers the method reads\n- **Documentation** — where it lives: the docs/ folder\n- **Merge** — the form: the /fw:integrate block\n- **Doc comments** — the tool: shdoc\n- **Error format** — the format: ${M}\n"
FW="${FW12}" T="${T12}" run 0 "${P12}" invariant v3.0.0 v4.0.0 "${RESTORE12}"
has "OK     CLAUDE.md: its answer ('the docs/ folder') is on CLAUDE.md's line **Documentation**"
has "CHECK  .claude/docs/02-code-quality.md: '${M})*; if the project documentation does not exist yet, the' was answered at the restore point with 'the wiki', which CLAUDE.md's line **Documentation** does not hold word for word"
hasnt "its answer ('the wiki')"
# Both carried, the second on the line the first runs on to.
put "${P12}" CLAUDE.md "# Index\nStack: bash\n5. Documentation updated:\n   aligned (where the project documentation lives: the answer **Documentation**, below). Same\n   logic as the memory.\n\n## The answers the method reads\n- **Documentation** — where it lives: the docs/ folder, and\n  the wiki for the guides\n- **Merge** — the form: the /fw:integrate block\n- **Doc comments** — the tool: shdoc\n- **Error format** — the format: ${M}\n"
FW="${FW12}" T="${T12}" run 0 "${P12}" invariant v3.0.0 v4.0.0 "${RESTORE12}"
has "OK     CLAUDE.md: its answer ('the docs/ folder') is on CLAUDE.md's line **Documentation**"
has "OK     .claude/docs/02-code-quality.md: its answer ('the wiki') is on CLAUDE.md's line **Documentation**"
# The line itself gone from the new home: a FAIL too.
put "${P12}" CLAUDE.md "# Index\nStack: bash\n\n## The answers the method reads\n- **Merge** — the form: the /fw:integrate block\n- **Doc comments** — the tool: shdoc\n- **Error format** — the format: ${M}\n"
FW="${FW12}" T="${T12}" run 1 "${P12}" invariant v3.0.0 v4.0.0 "${RESTORE12}"
has "FAIL   CLAUDE.md has no line **Documentation**"
# A doc left as the project had it: post names edge case 8.
g -C "${P12}" show "${RESTORE12}:.claude/docs/02-code-quality.md" > "${P12}/.claude/docs/02-code-quality.md"
FW="${FW12}" T="${T12}" run 1 "${P12}" post v3.0.0 v4.0.0
has "CHECK  .claude/docs/02-code-quality.md (METHOD) differs from v4.0.0's: its answers moved to another file (edge case 8)"
# A project whose moved slots are all open, in the forms an editor leaves — a trailing blank,
# a line re-flowed —, and whose docs/04 holds a convention of its own: nothing to carry, and
# the customised docs are edge case 7's.
P12C="${workdir}/project12c"
mkdir -p "${P12C}"
g -C "${FW12}" archive v3.0.0 -- .claude CLAUDE.md | tar -x -C "${P12C}"
put "${P12C}" .claude/docs/02-code-quality.md "# 02\n- Every public unit: a documentation comment. *(The tool is\n  ${M}.)*\n- Errors: expose a structured format to\n  the client *(which one — ${M})*, never stacktraces/queries/ \n  internal paths.\n7. Project documentation updated *(where it lives —\n   ${M}\n   )*; if the project documentation does not exist yet, the\n   debt is recorded.\n"
put "${P12C}" .claude/docs/04-git-workflow.md "# 04\n- The merge, in one of two forms — which one the project adopts is\n  ${M}:\n  - via Pull Request;\n- Our own convention: a squash before the review.\n"
g init -q -b main "${P12C}" && g -C "${P12C}" add -A && g -C "${P12C}" commit -q -m "chore: graft the framework v3.0.0"
FW="${FW12}" T="${T12}" run 0 "${P12C}" inventory v3.0.0 v4.0.0
has "INFO   .claude/docs/02-code-quality.md: 'the client *(which one — ${M})*, never stacktraces/queries/' is open in the project: nothing to carry"
has "INFO   .claude/docs/02-code-quality.md: '${M})*; if the project documentation does not exist yet, the' is open in the project, re-flowed: nothing to carry"
has "edge case 7: .claude/docs/02-code-quality.md is METHOD but customised"
has "edge case 7: .claude/docs/04-git-workflow.md is METHOD but customised"
hasnt "is answered in the project"
hasnt "the project answered slots of it"
# A project on a release whose slot lines the table does not know: never "nothing moved".
P12D="${workdir}/project12d"
mkdir -p "${P12D}"
g -C "${FW12}" archive v2.9.0 -- .claude CLAUDE.md | tar -x -C "${P12D}"
put "${P12D}" .claude/docs/02-code-quality.md "# 02\n- Every public unit: a documentation comment (the tool: shdoc).\n"
g init -q -b main "${P12D}" && g -C "${P12D}" add -A && g -C "${P12D}" commit -q -m "chore: graft the framework v2.9.0"
FW="${FW12}" T="${T12}" run 0 "${P12D}" inventory v2.9.0 v4.0.0
has "CHECK  edge case 8: .claude/docs/02-code-quality.md: v4.0.0 moved its slots, and v2.9.0's copy holds them in no form this check knows"
has "edge case 8: .claude/docs/02-code-quality.md is METHOD in v4.0.0, and a release in between moved its slots in a form this check does not know"
hasnt "no release between v2.9.0 and v4.0.0 moved a slot"
echo "PASS (upgrade-check moved answers): inventory names each answered slot v4.0.0 moved, with its answer and its new line, edge case 7 only for a doc whose moved slots are all open — a trailing blank or a re-flow still open —, and a release whose slot lines it does not know; invariant fails while an answer the restore point held has no home or an open one, asks while the line does not hold it word for word — two answers on one label —, and passes once each is carried; post names edge case 8 for a doc left behind."
