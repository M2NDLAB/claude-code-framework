#!/usr/bin/env bash
# Self-test of scripts/agent-git-guard.mjs AND of its wiring in .claude/settings.json
# (IMP-055; docs/04, "Delegated agents and the shared working tree").
#
# Contract under test: a delegated agent (hook input carrying agent_id) is read-only on
# git; the main session is never restricted; the wiring is FAIL-CLOSED — a crash of the
# guard, a missing guard file, a missing `node` or unreadable input all exit 2 (blocked).
# Claude Code treats any other non-zero exit of a PreToolUse hook as "proceed": measured
# on 2.1.283, an exit 1, an exit 127 and a timeout all let the tool call run.
#
# It FAILS if the guard stops blocking a write, starts blocking a read or the main
# session, if the wiring disappears from settings.json, or if `|| exit 2` is dropped (the
# crash case would then exit 1).
#
# HERMETIC: the wired command is READ from .claude/settings.json (never retyped here) and
# run by /bin/sh in a clean environment against JSON inputs. No git repository is touched:
# the guard reads command text only.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

fail() {
  echo "FAIL (IMP-055 guard): $*" >&2
  exit 1
}

NODE="$(command -v node || true)"
[[ -n "${NODE}" ]] || fail "node not found: the guard needs Node.js (a framework prerequisite); without it every Bash call is blocked"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

# --- The wiring, as settings.json declares it ------------------------------------------------
wired="$("${NODE}" -e '
const settings = require(process.argv[1]);
const tools = (group) => (group.matcher ?? "").split("|");
const hook = (settings.hooks?.PreToolUse ?? [])
  .filter((group) => tools(group).includes("Bash") && tools(group).includes("Monitor"))
  .flatMap((group) => group.hooks ?? [])
  .find((h) => /scripts\/agent-git-guard\.mjs/.test(h.command ?? ""));
if (!hook) process.exit(3);
process.stdout.write(hook.command);
' "${REPO_ROOT}/.claude/settings.json")" \
  || fail "no PreToolUse hook on Bash and Monitor runs scripts/agent-git-guard.mjs in .claude/settings.json"
[[ "${wired}" == *"|| exit 2"* ]] || fail "the wiring is not fail-closed (no '|| exit 2'): ${wired}"
# The checkpoint on the boundary's own files (an accidental edit would change it at once).
"${NODE}" -e '
const ask = require(process.argv[1]).permissions?.ask ?? [];
const missing = ["Edit(/.claude/settings.json)", "Edit(/scripts/agent-git-guard.mjs)"].filter((r) => !ask.includes(r));
if (missing.length) { console.error(missing.join(", ")); process.exit(3); }
' "${REPO_ROOT}/.claude/settings.json" || fail "settings.json lacks the ask rule(s) above on the boundary's own files"

# The hook input for a command; "agent" as the second argument adds agent_id/agent_type;
# the third names the tool (default Bash).
hook_input() {
  "${NODE}" -e '
const [command, who, tool] = process.argv.slice(1);
const input = { session_id: "self-test", hook_event_name: "PreToolUse", tool_name: tool || "Bash",
  tool_input: { command }, cwd: process.cwd() };
if (who === "agent") Object.assign(input, { agent_id: "a-self-test", agent_type: "general-purpose" });
process.stdout.write(JSON.stringify(input));
' "$1" "${2:-}" "${3:-}"
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
  'git show HEAD:README.md'
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
  'git blame -L 1,5 README.md'
  'git --version'
  'ls -la && cat README.md'
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

# --- 3. Main session: never restricted (pushes are the pre-push hook's job, not this one) --
for c in 'git switch -c feat/x' 'git commit -m "x"' 'git push origin main'; do
  expect 0 "main session blocked: ${c}" "${REPO_ROOT}" "$(hook_input "${c}")"
done

# --- 4. Fail-closed wiring -------------------------------------------------------------------
expect 2 "node missing must block" "${REPO_ROOT}" "$(hook_input 'git log -1' agent)" /nonexistent
mkdir -p "${workdir}/empty"
expect 2 "guard file missing must block" "${workdir}/empty" "$(hook_input 'git log -1')"
mkdir -p "${workdir}/broken/scripts"
echo 'throw new Error("simulated crash");' > "${workdir}/broken/scripts/agent-git-guard.mjs"
expect 2 "guard crash must block" "${workdir}/broken" "$(hook_input 'git log -1')"
expect 2 "unreadable input must block" "${REPO_ROOT}" 'not json'

echo "PASS (IMP-055 guard): ${#AGENT_WRITES[@]} agent writes blocked, ${#AGENT_READS[@]} reads allowed, main session free, fail-closed on node missing / file missing / crash / bad input."
