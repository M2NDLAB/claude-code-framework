#!/usr/bin/env bash
# Self-test of scripts/agent-git-guard.mjs AND of its wiring in .claude/settings.json
# (docs/04, "Delegated agents and the shared working tree").
#
# Contract under test: a delegated agent (hook input carrying agent_id) is read-only on
# git; the main session is never restricted. When the guard itself FAILS — a crash, a
# missing guard file, a missing `node` — the wiring blocks a delegated agent (exit 2,
# fail-closed) and, in the main session, exits 1: a non-blocking error that Claude Code
# shows in the transcript with the FIRST line of stderr, which the wiring makes its own
# clear message. The guard has no job in the main session (its push boundary is the
# pre-push). Claude Code treats a PreToolUse hook's non-zero exit other than 2 as
# "proceed" (measured on 2.1.283: exit 1, exit 127, a timeout), so the wiring, not the
# guard, decides the failure case.
#
# It FAILS if the guard stops blocking a write or starts blocking a read or the main
# session — through Bash, PowerShell or Monitor —, if the wiring disappears from
# settings.json or the PowerShell tool is no longer off there, if a broken guard lets an
# agent through, blocks the main session or stays silent there, or if the first line of a
# failure is not the wiring's own message.
#
# HERMETIC: the wired command is READ from .claude/settings.json (never retyped here) and
# run by /bin/sh in a clean environment against JSON inputs. No git repository is touched:
# the guard reads command text only.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

fail() {
  echo "FAIL (agent git guard): $*" >&2
  exit 1
}

NODE="$(command -v node || true)"
[[ -n "${NODE}" ]] || fail "node not found: the guard needs Node.js (a framework prerequisite); without it delegated agents are blocked"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

# --- The wiring, as settings.json declares it ------------------------------------------------
wired="$("${NODE}" -e '
const settings = require(process.argv[1]);
const tools = (group) => (group.matcher ?? "").split("|");
const hook = (settings.hooks?.PreToolUse ?? [])
  .filter((group) => ["Bash", "PowerShell", "Monitor"].every((t) => tools(group).includes(t)))
  .flatMap((group) => group.hooks ?? [])
  .find((h) => /scripts\/agent-git-guard\.mjs/.test(h.command ?? ""));
if (!hook) process.exit(3);
process.stdout.write(hook.command);
' "${REPO_ROOT}/.claude/settings.json")" \
  || fail "no PreToolUse hook on Bash, PowerShell and Monitor runs scripts/agent-git-guard.mjs in .claude/settings.json"
# The PowerShell tool off: on Windows the framework's shell is Git Bash's.
"${NODE}" -e '
if (require(process.argv[1]).env?.CLAUDE_CODE_USE_POWERSHELL_TOOL !== "0") process.exit(3);
' "${REPO_ROOT}/.claude/settings.json" || fail "settings.json does not keep the PowerShell tool off (env CLAUDE_CODE_USE_POWERSHELL_TOOL=0)"
# The checkpoint on the boundary's own files (an accidental edit would change it at once).
"${NODE}" -e '
const ask = require(process.argv[1]).permissions?.ask ?? [];
const missing = ["Edit(/.claude/settings.json)", "Edit(/scripts/agent-git-guard.mjs)"].filter((r) => !ask.includes(r));
if (missing.length) { console.error(missing.join(", ")); process.exit(3); }
' "${REPO_ROOT}/.claude/settings.json" || fail "settings.json lacks the ask rule(s) above on the boundary's own files"

# The hook input for a command; "agent" as the second argument adds agent_id/agent_type;
# the third names the tool (default Bash).
# The command travels on stdin, as Claude Code hands the hook its input: on Windows, Git
# Bash rewrites an ARGUMENT that looks like a POSIX path (/usr/bin/git becomes
# C:/Program Files/Git/usr/bin/git) before node.exe sees it — measured in the CI.
hook_input() {
  printf '%s' "$1" | "${NODE}" -e '
const command = require("fs").readFileSync(0, "utf8");
const [who, tool] = process.argv.slice(1);
const input = { session_id: "self-test", hook_event_name: "PreToolUse", tool_name: tool || "Bash",
  tool_input: { command }, cwd: process.cwd() };
if (who === "agent") Object.assign(input, { agent_id: "a-self-test", agent_type: "general-purpose" });
process.stdout.write(JSON.stringify(input));
' "${2:-}" "${3:-}"
}

# Runs the wired command as Claude Code would (sh -c, CLAUDE_PROJECT_DIR set) and prints
# its exit code. Arguments: project dir, hook input, PATH (default: node's dir + system).
run_wired() {
  local rc
  set +e
  printf '%s' "$2" | env -i HOME="${HOME}" PATH="${3:-$(dirname "${NODE}"):/usr/bin:/bin}" \
    CLAUDE_PROJECT_DIR="$1" /bin/sh -c "${wired}" >/dev/null 2>"${workdir}/stderr"
  rc=$?
  set -e
  echo "${rc}"
}

expect() { # expect <code> <label> <project dir> <hook input> [PATH]
  local rc
  rc="$(run_wired "$3" "$4" "${5:-}")"
  [[ "${rc}" == "$1" ]] || fail "$2 — expected exit $1, got ${rc}: $(head -c 300 "${workdir}/stderr")"
}
first_line() { # first_line <prefix> <label>: the transcript shows only stderr's first line
  [[ "$(head -n 1 "${workdir}/stderr")" == "$1"* ]] \
    || fail "$2 — stderr's first line is not '$1…': $(head -n 1 "${workdir}/stderr")"
}

# --- 1. Delegated agent: every write is refused (exit 2) -------------------------------------
AGENT_WRITES=(
  'git switch -c sub-x'
  'git checkout main'
  'git -C . checkout p01'
  'git -c core.pager=cat --git-dir=.git --work-tree=. switch main'
  'cd /tmp && git restore .'
  'git reset --hard HEAD~1'
  'git commit -m "wip"'
  'git branch new-branch'
  'git branch -D old-branch'
  'git branch -f other HEAD~1'
  'git tag v9.9.9'
  'git stash'
  'git stash push -m wip'
  'git worktree add ../wt HEAD'
  'git config user.email someone@example.invalid'
  'git archive -o out.tar HEAD'
  'git diff HEAD~1 --output=d.txt'
  'git status'
  'git status --short'
  'git push origin main'
  'git -C "$PWD" push origin main'
  "git 'switch' main"
  'GIT_TRACE=1 git checkout main'
  'env GIT_TRACE=1 git checkout main'
  'timeout 30 git checkout main'
  'echo main | xargs git checkout'
  'v=$(git switch main)'
  'git log -1 && git merge feature'
  '/usr/bin/git rebase main'
  'git -c alias.co=checkout co main'
  'git fetch origin'
  'git pull'
  'git gc --prune=now'
  'git remote add other file:///tmp/other'
  # the review's forms (2026-10-07): line continuations, substitutions inside double
  # quotes, flags that do not mean "list", stuck options, redirections, shell keywords
  $'cd /tmp && \\\n  git checkout main'
  $'git log -1 && \\\ngit reset --hard HEAD~1'
  $'GIT_TRACE=1 \\\n  git switch main'
  'echo "$(git switch main)"'
  'out="$(git checkout main 2>&1)"; echo "$out"'
  'echo "`git stash`"'
  'git branch -v newbranch'
  'git branch --sort=refname newbranch'
  'git tag --sort=refname newtag'
  'git archive -oout.tar HEAD'
  'git remote -v add other file:///tmp/other'
  '2>/dev/null git branch other'
  'if true; then git switch main; fi'
  'git symbolic-ref HEAD refs/heads/other'
)
for c in "${AGENT_WRITES[@]}"; do
  expect 2 "agent write not blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}" agent)"
done

# --- 2. Delegated agent: reads go through (exit 0) — a guard that blocks reads gets disabled --
AGENT_READS=(
  'git --no-optional-locks status'
  'GIT_OPTIONAL_LOCKS=0 git status --short'
  'git log --oneline -5'
  'git -C . diff HEAD~1..HEAD'
  'git show HEAD:CLAUDE.md'
  'git branch'
  "git branch --list 'feat/*'"
  'git branch --show-current'
  'git tag -l'
  'git tag --contains HEAD'
  'git stash list'
  'git worktree list'
  'git config --get user.name'
  'git config user.name'
  'git remote -v'
  'git rev-parse --abbrev-ref HEAD'
  'git archive HEAD | tar -t'
  'git ls-files | wc -l'
  'git blame -L 1,5 CLAUDE.md'
  'git --version'
  'ls -la && cat CLAUDE.md'
  'grep -rn "git checkout" .'
  'echo "git switch main"'
  "cat <<'EOF'
git switch main
EOF"
  $'git --no-pager \\\n  log -1'
  'git -c core.pager=cat log -1'
  "git tag -n5 'v*'"
  'git branch -a --contains HEAD'
  'git branch -v'
  'git symbolic-ref --short HEAD'
  'echo "branch: $(git rev-parse --abbrev-ref HEAD)"'
  'echo "$((1 + 2))"'
  '2>/dev/null git log -1'
)
for c in "${AGENT_READS[@]}"; do
  expect 0 "agent read blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}" agent)"
done

# --- 2b. The Monitor tool runs shell commands too: same rule --------------------------------
expect 2 "agent Monitor write not blocked" "${REPO_ROOT}" "$(hook_input 'while true; do git pull; sleep 30; done' agent Monitor)"
expect 0 "agent Monitor read blocked" "${REPO_ROOT}" "$(hook_input 'tail -f app.log | grep --line-buffered ERROR' agent Monitor)"

# --- 2c. The PowerShell tool, if a developer turns it on: same rule, PowerShell's syntax ----
PS_WRITES=(
  'git checkout main'
  '& git commit -m "x"'
  'git.exe switch main'
  'Git checkout main'
  "& 'C:\\Program Files\\Git\\cmd\\git.exe' commit -m x"
  'cd C:\repo; git stash'
  $'git `\n  checkout main'
  $'git log -1\r\ngit merge feature'
  'if ($ready) { git reset --hard HEAD~1 }'
  '$out = $(git switch main)'
)
for c in "${PS_WRITES[@]}"; do
  expect 2 "agent PowerShell write not blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}" agent PowerShell)"
done
PS_READS=(
  'git log -1'
  'git --no-optional-locks status'
  'git.exe diff HEAD~1'
  $'git log `\n  -1'
  $'git log\r\ngit --no-optional-locks status\r\n'
  'Get-ChildItem -Recurse | Select-String "git checkout"'
  "Write-Output 'git switch main'"
)
for c in "${PS_READS[@]}"; do
  expect 0 "agent PowerShell read blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}" agent PowerShell)"
done
# Not vacuous: the CRLF read above reaches the guard with its \r (JSON writes it as \r).
[[ "$(hook_input $'git log\r\ngit --no-optional-locks status\r\n' agent PowerShell)" == *'status\r\n'* ]] \
  || fail "a CRLF command reached the guard without its \\r: the CRLF cases prove nothing"
# Through Bash too (Git Bash on Windows), git may be spelled git.exe, Git or a Windows path.
for c in 'git.exe checkout main' 'GIT checkout main' '/c/Program\ Files/Git/cmd/git.exe switch main'; do
  expect 2 "agent write not blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}" agent)"
done

# --- 3. Main session: never restricted (pushes are the pre-push hook's job, not this one) --
for c in 'git switch -c feat/x' 'git commit -m "x"' 'git push origin main'; do
  expect 0 "main session blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}")"
  expect 0 "main session blocked (PowerShell): ${c}" "${REPO_ROOT}" "$(hook_input "${c}" '' PowerShell)"
done

# --- 4. A broken guard: fail-CLOSED for a delegated agent, open for the main session ------
mkdir -p "${workdir}/empty" "${workdir}/broken/scripts" "${workdir}/no-node" "${workdir}/no-cat"
echo 'throw new Error("simulated crash");' > "${workdir}/broken/scripts/agent-git-guard.mjs"
# A PATH with the wiring's `cat` and no `node`: `cat` is a wrapper, not a link — Git Bash's
# `ln -s` copies the binary away from the DLL it loads (measured in the CI on Windows).
printf '#!/bin/sh\nexec "%s" "$@"\n' "$(command -v cat)" > "${workdir}/no-node/cat"
chmod +x "${workdir}/no-node/cat"
ln -s "${NODE}" "${workdir}/no-cat/node"           # a PATH with `node` and no `cat`
for who in agent main; do
  if [[ "${who}" == agent ]]; then want=2; mark=agent; else want=1; mark=""; fi
  expect "${want}" "node missing (${who})"       "${REPO_ROOT}"      "$(hook_input 'git log -1' "${mark}")" "${workdir}/no-node"
  first_line "agent-git-guard: cannot run" "node missing (${who})"
  expect "${want}" "guard file missing (${who})" "${workdir}/empty"  "$(hook_input 'git log -1' "${mark}")"
  first_line "agent-git-guard: cannot run" "guard file missing (${who})"
  expect "${want}" "guard crash (${who})"        "${workdir}/broken" "$(hook_input 'git log -1' "${mark}")"
  first_line "agent-git-guard: cannot run" "guard crash (${who})"
done
# A healthy block keeps the guard's own message first.
expect 2 "agent write, healthy guard" "${REPO_ROOT}" "$(hook_input 'git switch main' agent)"
first_line "agent-git-guard: BLOCKED" "agent write, healthy guard"
# When the guard fails, the wiring classifies the call by the text `"agent_id"` in the raw
# input. A quote INSIDE a value arrives JSON-escaped, so a main-session command quoting the
# key stays the main session's. (A value that ENDS in `"agent_id` would still match while
# the guard is broken: a false positive that blocks, i.e. fails safe — accepted.)
expect 1 "a main-session command quoting \"agent_id\" (broken guard)" "${workdir}/empty" \
  "$(hook_input 'echo "\"agent_id\": x"')"
expect 2 "unreadable input carrying agent_id must block" "${REPO_ROOT}" '{"agent_id":"a-self-test","tool_name":"Bash", truncated'
expect 1 "unreadable input without agent_id: not blocked, but shown (it cannot be told from the main session)" "${REPO_ROOT}" 'not json'
# The wiring cannot even read its input (no `cat`): it cannot classify the call, so it blocks.
expect 2 "an unreadable stdin blocks (agent)" "${REPO_ROOT}" "$(hook_input 'git log -1' agent)" "${workdir}/no-cat"
expect 2 "an unreadable stdin blocks (main)"  "${REPO_ROOT}" "$(hook_input 'git log -1')"       "${workdir}/no-cat"
# A HEALTHY guard's verdict stands whatever the spelling of the key: here agent_id is written
# with a JSON escape, so the raw-text test would miss it — the guard's exit 2 must survive.
expect 2 "a healthy guard's block stands (escaped agent_id key)" "${REPO_ROOT}" \
  '{"tool_name":"Bash","tool_input":{"command":"git commit -m x"},"cwd":"/tmp","agent\u005fid":"a1","agent_type":"general-purpose"}'
# A main session started with --agent carries agent_type but no agent_id: the main session.
expect 1 "a main session with agent_type only (broken guard)" "${workdir}/empty" \
  '{"tool_name":"Bash","tool_input":{"command":"git log -1"},"cwd":"/tmp","agent_type":"reviewer"}'

echo "PASS (agent git guard): ${#AGENT_WRITES[@]} agent writes blocked, ${#AGENT_READS[@]} reads allowed, through PowerShell ${#PS_WRITES[@]} and ${#PS_READS[@]}, main session free; a broken guard (node missing / file missing / crash / bad input) blocks agents and shows a non-blocking error to the main session."
