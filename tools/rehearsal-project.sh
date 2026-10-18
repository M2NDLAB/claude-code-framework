#!/usr/bin/env bash
# rehearsal-project.sh — a synthetic project grafted at a revision of the framework, every setup
# slot answered and its memory populated: the fixture of a release's upgrade rehearsal, and of
# the CI's run of the shipped self-tests inside a project (tools/test-rehearsal-project.sh).
#
# WHY. The shipped self-tests passed in this repository and failed in the projects three times
# in two releases — the formatting slot answered, a memory over its budget, a user's shell —,
# because here every slot is open and the memory is this repository's own. The rehearsal that
# found them was written anew at every release, in a scratchpad, and a release rehearsed on
# one commit shipped a later one. This builds the same projects from the repository, on any
# commit.
#
# Usage, from anywhere:
#   FW=<the framework's clone> bash tools/rehearsal-project.sh <rev> <new dir> [answered|legacy] [crlf]
#
# <rev> is a tag for a rehearsal, HEAD for the CI: the copy is SETUP.md's step 1 at <rev>, read
# by revision, never from FW's working tree. <new dir> must not exist, its parent must, and it
# lies outside FW, checked before anything is written; it is all the script writes, with <new
# dir>.crlf under `crlf`. The shapes:
#   answered  every slot marker replaced by an answer of its own; the protected branches
#             `main dev`; a rule of the project's own at the end of the allow list, a target of
#             its own in the Makefile, three technical rules in CLAUDE.md; the pin as step 1
#             writes it; the memory populated in the titles of <rev>'s templates — STATE.md
#             past the 8,000 characters the SessionStart hook shows, its open issues alone
#             about 10,000, two IMP entries of the project's, two dated notes, a component
#             note, a decision record.
#   legacy    the same, with the marks of a project grafted early and never upgraded since: the
#             pin's version without its v and no graft date; open issues of about 52,000
#             characters, never condensed; the memory's titles and field
#             labels in their form before v1.1.0 (upgrade-check.sh's TITLE_TABLE and
#             LABEL_TABLE, read the other way); no .gitattributes; the integrate command's
#             branch placeholders replaced, as setup asked before v3.0.0; a dormant protected
#             branch, `dev`.
# Every bracketed marker is answered, the ones older releases named in prose included: the
# project of a user who answered all it was pointed at, which also customises the METHOD files
# such a mention sits in (edge case 7). And the checkpoint command's two placeholders, which are
# no markers, its paragraph that marks them deleted, as setup asks. `crlf` adds a clone of the project with
# core.autocrlf=true, as a Windows checkout writes it: CRLF wherever .gitattributes does not
# hold a file to LF — every file of a legacy project, none of a project at v1.5.0 or later,
# whose .gitattributes holds every path this script writes —, the files counted in the line
# it prints.
# Prints what it built; exit 1 on any failure, and then nothing of it is left.
# Prerequisites: git 2.31 or later, bash 3.2 or later, tar, awk, Node.js (JSON and counts).
set -euo pipefail

die() { printf 'rehearsal-project: %s\n' "$*" >&2; exit 1; }

[ $# -ge 2 ] && [ $# -le 4 ] || die "usage: FW=<framework clone> bash tools/rehearsal-project.sh <rev> <new dir> [answered|legacy] [crlf]"
REV="$1"
OUT="$2"
SHAPE="${3:-answered}"
CRLF="${4:-}"
case "${SHAPE}" in answered | legacy) ;; *) die "unknown shape '${SHAPE}': answered or legacy" ;; esac
case "${CRLF}" in '' | crlf) ;; *) die "unknown option '${CRLF}': crlf, or nothing" ;; esac
[ -n "${FW:-}" ] || die "FW is not set: the absolute path of the framework's clone"
TOOLS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v node >/dev/null || die "node not found: a prerequisite of the framework"

# A git with a fixed identity, no signing and no line-end conversion: the same fixture on every
# machine, whatever the user's configuration.
g() { git -c user.name=rehearsal -c user.email=rehearsal@example.invalid -c commit.gpgSign=false \
  -c tag.gpgSign=false -c core.autocrlf=false "$@"; }

fw_top="$(git -C "${FW}" rev-parse --show-toplevel 2>/dev/null)" || die "FW=${FW} is not a git repository"
commit="$(git -C "${FW}" rev-parse -q --verify "${REV}^{commit}")" || die "${REV} is not a revision of FW=${FW}"
[ ! -e "${OUT}" ] || die "${OUT} exists: the project is built in a new directory"
[ -z "${CRLF}" ] || [ ! -e "${OUT}.crlf" ] || die "${OUT}.crlf exists: the CRLF clone is built in a new directory"
# Where it would land is checked before anything is written: the parent, which must exist,
# resolved and held against FW; then the one directory, created alone.
parent="$(dirname "${OUT}")"
[ -d "${parent}" ] || die "${parent} does not exist: the new directory's parent must"
parent="$(cd "${parent}" && pwd -P)"
case "${parent}/" in
  "$(cd "${fw_top}" && pwd -P)/"*) die "${OUT} is inside FW: build the project outside it" ;;
esac
OUT="${parent}/$(basename "${OUT}")"
mkdir "${OUT}"
# From here a failure removes what was built: nothing half-built is left to be taken for a
# fixture. Both directories are this run's own, created above or below.
built_crlf=""
trap 'rc=$?; if [ "${rc}" -ne 0 ]; then rm -rf "${OUT}"; [ -z "${built_crlf}" ] || rm -rf "${built_crlf}"; fi; exit "${rc}"' EXIT
cd "${OUT}"

# The marker in both forms — a release before v1.1.0 wrote it in Italian —, built here so this
# file never carries it as a slot would.
M1="[TO BE DEFINED A""T SETUP]"
M2="[DA DEFINIRE A""L SETUP]"

# --- The graft: step 1 of SETUP.md, at <rev> ---------------------------------------------------
g init -q -b main .
g commit -q --allow-empty -m "chore: start the repository"
paths=()
for p in .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore .gitattributes scripts; do
  git -C "${FW}" cat-file -e "${commit}:${p}" 2>/dev/null && paths+=("${p}")
done
git -C "${FW}" archive "${commit}" -- "${paths[@]}" \
  ':(exclude).claude/memory/LEARNINGS.md' ':(exclude,glob).claude/memory/sessions/[0-9]*' | tar -x
[ -x scripts/hooks-install.sh ] && [ -f .claude/settings.json ] && [ -f .claude/memory/STATE.md ] \
  || die "the copy of ${REV} lacks its scripts, its settings or its memory"
git -C "${FW}" show "${commit}:.claude/memory/LEARNINGS.md" > "${OUT}/.learn.src" 2>/dev/null \
  || die "${REV} has no .claude/memory/LEARNINGS.md"
awk '/^## /{h=1; print; print ""; next} /^<!--/{c=1} !h || c {print} /-->[[:space:]]*$/{if (h && c) print ""; c=0}' \
  "${OUT}/.learn.src" > .claude/memory/LEARNINGS.md
rm -f "${OUT}/.learn.src"
version="$(git -C "${FW}" describe --tags --exact-match "${commit}" 2>/dev/null || git -C "${FW}" describe --tags --always "${commit}")"

# --- The answers ----------------------------------------------------------------------------------
# The checkpoint command's two placeholders, which are no markers, answered as SETUP.md's step 2
# asks — the integration branch and tree's ignore pattern —, and the paragraph that marks them,
# where the release has one (from v1.4.1), deleted with its marker: as a project set up holds
# the file, so a release that changes their lines conflicts here as it does there.
for f in .claude/commands/fw/checkpoint.md .claude/commands/checkpoint.md; do
  [ -f "${f}" ] || continue
  awk '/^Setup replaces the placeholders below/ { skip = 1 }
    skip { if (/then deletes this paragraph:/) skip = 0; next }
    { gsub(/<integration>/, "main"); gsub(/<pattern-to-ignore-for-the-stack>/, "node_modules|dist"); print }' \
    "${f}" > "${OUT}/.checkpoint.tmp"
  cat "${OUT}/.checkpoint.tmp" > "${f}"
  rm -f "${OUT}/.checkpoint.tmp"
  ! grep -qE '<integration>|<pattern-to-ignore-for-the-stack>|^Setup replaces the placeholders below' "${f}" \
    || die "${f} at ${REV}: a placeholder or its paragraph left"
done
# Every marker outside the memory this script writes becomes "rehearsal answer <n>", numbered
# across the project. A file is rewritten through `cat >`, which keeps its mode: a script stays
# executable.
n_answers=0
while IFS= read -r f; do
  case "${f}" in
    ./.claude/memory/LEARNINGS.md | ./.claude/memory/STATE.md | ./.claude/memory/TREE.md | ./.claude/memory/INDEX.md) continue ;;
  esac
  M1="${M1}" M2="${M2}" N="${n_answers}" awk '
    BEGIN { m[1] = ENVIRON["M1"]; m[2] = ENVIRON["M2"]; n = ENVIRON["N"] + 0 }
    {
      line = $0; out = ""
      for (;;) {
        best = 0
        for (k = 1; k <= 2; k++) { i = index(line, m[k]); if (i && (!best || i < best)) { best = i; w = k } }
        if (!best) break
        n++
        out = out substr(line, 1, best - 1) "rehearsal answer " n
        line = substr(line, best + length(m[w]))
      }
      print out line
    }
    END { print n > "/dev/stderr" }' "${f}" > "${OUT}/.answer.tmp" 2> "${OUT}/.answer.n"
  cat "${OUT}/.answer.tmp" > "${f}"
  n_answers="$(cat "${OUT}/.answer.n")"
done < <(grep -rlF -e "${M1}" -e "${M2}" --exclude-dir=.git . | LC_ALL=C sort)
rm -f "${OUT}/.answer.tmp" "${OUT}/.answer.n"

# replace_line <file> <old> <new>: the file's whole line <old> becomes <new>; a failure when the
# file holds no such line, so a release that rewrote it is never answered on nothing.
replace_line() {
  O="$2" NEW="$3" awk '$0 == ENVIRON["O"] { print ENVIRON["NEW"]; f = 1; next } { print } END { exit !f }' "$1" > "${OUT}/.line.tmp" \
    || die "$1 holds no line '$2' at ${REV}"
  cat "${OUT}/.line.tmp" > "$1"
  rm -f "${OUT}/.line.tmp"
}
# The protected branches: a value, not a marked line — the Makefile's variable from v1.3.2 on,
# reset-task.sh's default before it.
if grep -qxF 'PROTECTED_BRANCHES = main develop' Makefile; then
  replace_line Makefile 'PROTECTED_BRANCHES = main develop' 'PROTECTED_BRANCHES = main dev'
else
  replace_line scripts/reset-task.sh 'PROTECTED_BRANCHES="${PROTECTED_BRANCHES:-main develop}"' 'PROTECTED_BRANCHES="${PROTECTED_BRANCHES:-main dev}"'
fi
# A rule of the project's own, at the end of the allow list, where a user adds one; the file
# stays JSON.
node -e '
const fs = require("fs"); const p = process.argv[1];
const text = fs.readFileSync(p, "utf8");
const next = text.replace(/("allow": \[[^\]]*?)(\n(\s*)\])/, (m, body, close, ind) => `${body},\n${ind}  "Bash(make test)"${close}`);
if (next === text) { console.error("no allow list in " + p); process.exit(1); }
JSON.parse(next);
fs.writeFileSync(p, next);
' .claude/settings.json || die "settings.json at ${REV}: no allow list to add to"
printf '\n# The project'"'"'s own targets.\ntest: ## Run the project'"'"'s tests\n\t@echo "the project'"'"'s tests"\n' >> Makefile
# Three technical rules of the project's own, under the heading setup answers.
awk '{ print } /^## Project-specific technical rules/ && !f { f = 1
  print ""
  print "- **Stack**: a rehearsal stack — `make test` runs its tests."
  print "- **Interaction language**: English."
  print "- **Project licence**: none, a fixture of the framework'"'"'s rehearsal." }
  END { exit !f }' CLAUDE.md > "${OUT}/.claude.tmp" || die "CLAUDE.md at ${REV} has no technical rules heading"
cat "${OUT}/.claude.tmp" > CLAUDE.md
rm -f "${OUT}/.claude.tmp"

# --- legacy's marks -------------------------------------------------------------------------------
if [ "${SHAPE}" = legacy ]; then
  rm -f .gitattributes
  if [ -f .claude/commands/integrate.md ]; then
    sed -e 's/<integration>/main/g' -e 's/<stable>/main/g' .claude/commands/integrate.md > "${OUT}/.int.tmp"
    cat "${OUT}/.int.tmp" > .claude/commands/integrate.md
    rm -f "${OUT}/.int.tmp"
  fi
fi

# --- The memory -----------------------------------------------------------------------------------
# The titles of <rev>'s templates; legacy writes them, and the entries' field labels, in their
# form before v1.1.0, upgrade-check.sh's tables read from new to old (the first old form of each).
eval "$(sed -n "/^TITLE_TABLE='/,/'\$/p; /^LABEL_TABLE='/,/'\$/p" "${TOOLS}/upgrade-check.sh")"
[ -n "${TITLE_TABLE:-}" ] && [ -n "${LABEL_TABLE:-}" ] || die "upgrade-check.sh's tables of the old titles and labels not found"
old_form() { # old_form <titles|labels> <new form>: the old form, or the new one where there is none
  if [ "${SHAPE}" != legacy ]; then printf '%s\n' "$2"; return; fi
  if [ "$1" = titles ]; then t="${TITLE_TABLE}"; else t="${LABEL_TABLE}"; fi
  T="${t}" X="$2" awk 'BEGIN { n = split(ENVIRON["T"], l, "\n"); for (i = 1; i <= n; i++) { split(l[i], kv, "\t"); if (kv[2] == ENVIRON["X"] && r == "") r = kv[1] } print (r == "" ? ENVIRON["X"] : r) }'
}
grep '^## ' .claude/memory/STATE.md > "${OUT}/.titles"
{
  printf -- '---\ntype: state\nupdated: 2026-01-15\nbranch: main\ntags: [state]\n---\n'
  printf '# STATE — Rehearsal project\n\n'
  printf '> Updated: 2026-01-15 | Last: **the first task after the graft** | Index: [[INDEX]]\n'
  while IFS= read -r title; do
    printf '\n%s\n' "$(old_form titles "${title}")"
    case "${title}" in
      *Caution*)
        # Past the hook's budget on its own, entries of about 650 characters: 16 of them, and
        # 80 for legacy — a memory never condensed, at the scale a project grafted early holds.
        i=1
        if [ "${SHAPE}" = legacy ]; then last=80; else last=16; fi
        while [ "${i}" -le "${last}" ]; do
          printf -- '- Rehearsal issue %s — an open issue of the rehearsal project, long enough that the budget of the SessionStart hook is crossed: it names a component, the reason it stays open and the trigger that brings it back; the reason here is a dependency not yet released, the component the one the decision record names, and the trigger the release of that dependency, or a deliverable that needs the component before it, whichever comes first; until then the debt is accepted, in writing, here → trigger: the dependency released.\n' "${i}"
          i=$((i + 1))
        done ;;
      *)
        printf -- '- The rehearsal project'"'"'s %s, as a checkpoint writes it.\n' "${title#\#\# }"
        printf -- '- A second line, so the section is not a single one: [[2026-01-12-rehearsal-first-task]].\n' ;;
    esac
  done < "${OUT}/.titles"
} > .claude/memory/STATE.md
rm -f "${OUT}/.titles"
printf '# INDEX — Rehearsal project\n\n- [[STATE]] · [[TREE]] · [[LEARNINGS]]\n- Components: [[rehearsal-api]]\n- Decisions: [[2026-01-11-rehearsal-choice]]\n- Sessions: [[2026-01-10-rehearsal-graft]] · [[2026-01-12-rehearsal-first-task]]\n' > .claude/memory/INDEX.md
printf '# TREE — Rehearsal project\n\n```\n.\n├── CLAUDE.md\n├── Makefile\n└── scripts/\n```\n' > .claude/memory/TREE.md
mkdir -p .claude/memory/sessions .claude/memory/components .claude/memory/decisions
for note in 2026-01-10-rehearsal-graft 2026-01-12-rehearsal-first-task; do
  printf -- '---\ndate: %s\ntask: %s\nbranch: main\nstatus: completed\ntags: [session]\n---\n# Session %s\n\n- The framework at %s, its answers in place: [[STATE]].\n- A pointer an upgrade may leave dangling: `docs/04:142`.\n' \
    "${note:0:10}" "${note:11}" "${note:0:10}" "${version}" > ".claude/memory/sessions/${note}.md"
done
printf '# rehearsal-api\n\n- The component the open issues name; its decision: [[2026-01-11-rehearsal-choice]].\n' > .claude/memory/components/rehearsal-api.md
printf '# 2026-01-11 — the rehearsal'"'"'s choice\n\n- Decided: one component, kept small. Alternative discarded: two.\n' > .claude/memory/decisions/2026-01-11-rehearsal-choice.md
# Two IMP entries of the project's: the first in the first section (the open proposals), the
# second in the second (the applied ones), each right after its title and blank line.
l_date="$(old_form labels '- Date:')"; l_orig="$(old_form labels '| Origin:')"
l_prob="$(old_form labels '- Observed problem:')"; l_prop="$(old_form labels '- Proposal:')"
l_ben="$(old_form labels '- Expected benefit / risk:')"
L1="### IMP-001 — A rehearsal friction" L2="${l_date} 2026-01-12 ${l_orig} [[2026-01-12-rehearsal-first-task]] — a check that passed on silence" \
L3="${l_prob} the project's check printed nothing when it could not read its input." L4="${l_prop} print a line on the datum it read." L5="${l_ben} a silent pass made visible; none." \
A1="### IMP-002 — A rehearsal rule → applied on 2026-01-12, commit 0000000" A2="${l_date} 2026-01-11 ${l_orig} [[2026-01-10-rehearsal-graft]] — the graft's first friction" \
awk '/^## / { s++ } { print } s == 1 && /^## / { p = 1; next } s == 2 && /^## / { q = 1; next }
  p && /^$/ { printf "%s\n%s\n%s\n%s\n%s\n\n", ENVIRON["L1"], ENVIRON["L2"], ENVIRON["L3"], ENVIRON["L4"], ENVIRON["L5"]; p = 0 }
  q && /^$/ { printf "%s\n%s\n\n", ENVIRON["A1"], ENVIRON["A2"]; q = 0 }' .claude/memory/LEARNINGS.md > "${OUT}/.learn.tmp"
cat "${OUT}/.learn.tmp" > .claude/memory/LEARNINGS.md
rm -f "${OUT}/.learn.tmp"
if [ "${SHAPE}" = legacy ]; then
  # The four section titles too, in their old form — listed first: each replacement rewrites
  # the file the list is read from.
  grep '^## ' .claude/memory/LEARNINGS.md > "${OUT}/.ltitles"
  while IFS= read -r title; do
    replace_line .claude/memory/LEARNINGS.md "${title}" "$(old_form titles "${title}")"
  done < "${OUT}/.ltitles"
  rm -f "${OUT}/.ltitles"
fi

# --- The pin and the commit ------------------------------------------------------------------------
if [ "${SHAPE}" = legacy ]; then
  printf 'version: %s\ncommit: %s\ngrafted: n/d (a retrofit, its date not recorded)\n' "${version#v}" "${commit}" > .claude/framework-version
else
  printf 'version: %s\ncommit: %s\ngrafted: 2026-01-10\n' "${version}" "${commit}" > .claude/framework-version
fi
g add -A
# Windows records no executable bit: the scripts get the one they have at <rev>.
git -C "${FW}" ls-tree -r "${commit}" -- scripts | awk '$1 == "100755" { print $4 }' | while IFS= read -r f; do
  [ -f "${f}" ] && g update-index --chmod=+x -- "${f}"
done
g commit -q -m "chore: graft the framework ${version}"
[ "${SHAPE}" != legacy ] || g branch dev
[ -z "$(g status --porcelain)" ] || die "the project's tree is not clean after its commit"

state_chars="$(node -e 'process.stdout.write(String(require("fs").readFileSync(process.argv[1], "utf8").length))' .claude/memory/STATE.md)"
crlf_line=""
if [ -n "${CRLF}" ]; then
  built_crlf="${OUT}.crlf"
  # Not through g: its core.autocrlf=false on the command line would rule the checkout.
  git clone -q -c core.autocrlf=true "${OUT}" "${built_crlf}"
  [ "${SHAPE}" != legacy ] || git -C "${built_crlf}" branch -q dev origin/dev
  git -C "${built_crlf}" remote remove origin
  # The line says what the checkout wrote, counted, never what the option asked for.
  crlf_files="$(git -C "${built_crlf}" ls-files --eol | awk '$2 == "w/crlf"' | wc -l | tr -d ' ')"
  if [ "${crlf_files}" -gt 0 ]; then
    crlf_line="; with core.autocrlf=true, ${crlf_files} files with CRLF line ends: ${built_crlf}"
  else
    crlf_line="; with core.autocrlf=true, no file with CRLF line ends — ${REV}'s .gitattributes holds them all to LF: ${built_crlf}"
  fi
fi
printf 'rehearsal-project: %s — %s at %s (%s): %s slots answered, STATE.md %s characters%s\n' \
  "${OUT}" "${SHAPE}" "${version}" "${commit:0:7}" "${n_answers}" "${state_chars}" "${crlf_line}"
