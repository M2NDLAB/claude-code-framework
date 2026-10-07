# scripts/ — process scripts

Only **working-method** scripts, stack-agnostic. The project's build/run scripts
(compilation, tests, startup) do NOT live here: each project adds its own.

| Script | What it does |
|---|---|
| `hooks-install.sh` | Installs the local git hooks: secret scanning (gitleaks, pre-commit), Conventional Commits (commitlint, commit-msg) and the push boundary (pre-push: it refuses a push launched from a Claude Code session, `docs/04`), always active. Automatic code formatting is included as a **commented-out example** to adapt to the project's language. Idempotent on its own hooks (if you have customised them, a re-run saves a `.bak` first); faced with pre-existing hooks of ANOTHER origin — including the symlinks of hook managers — it stops (override: `FORCE_OVERWRITE=1`, with a `.bak` backup), and it also stops if `core.hooksPath` is active (e.g. husky: `.git/hooks` would be ignored and the hooks would be inert). |
| `reset-task.sh` | SURGICAL cleanup of an interrupted task: it discards ONLY the uncommitted work and preserves the branch and the previous commits. It is the cleanup of the task planning protocol (`.claude/docs/01-task-planning.md`). It refuses to operate on shared branches. |
| `test-hooks-install.sh` | Hermetic self-test of `hooks-install.sh` (stubs for `gitleaks`/`npx` + a throwaway git repo): it runs the REAL script end-to-end and demonstrates the contract of the `FORCE_OVERWRITE=1` branch on the dangling-symlink case, then that the generated pre-push refuses agent-session pushes in every form and lets the human's through (a local `file://` bare remote), without touching the real repo. Launch it with `make test-scripts`. |
| `agent-git-guard.mjs` | The PreToolUse hook (wired in `.claude/settings.json`) that keeps DELEGATED agents read-only on git: a subagent's or workflow agent's git write is refused, whatever global options precede the subcommand; the main session is never restricted. Fail-closed: wired `node … \|\| exit 2`. See `.claude/docs/04-git-workflow.md`, *Enforcement of the execution boundary*. |
| `test-agent-git-guard.sh` | Hermetic self-test of the guard AND of its wiring, read from `settings.json`: writes blocked, reads allowed, main session free, and blocked on a crash, a missing guard file, a missing `node` or unreadable input. |
| `repo-snapshot.sh` | Read-only fingerprint of a repository (HEAD, branch, refs, stash, worktrees, untracked files) that the main session diffs before and after delegating work to agents: any difference means stop and report. |
| `test-repo-snapshot.sh` | Hermetic self-test of `repo-snapshot.sh`: read-only (a plain `git status` as the control), every kind of trace detected and restored. |

## Typical use

```bash
make hooks-install      # or: bash scripts/hooks-install.sh
make test-scripts       # self-test of the scripts (hermetic: does not touch the real repo)
before="$(mktemp)"; scripts/repo-snapshot.sh > "$before"   # before delegating to agents
scripts/repo-snapshot.sh | diff "$before" -              # after: any output = stop
./scripts/reset-task.sh # after an interruption, before resuming a plan
```

Prerequisites: `gitleaks` and `npx` (Node.js) for `hooks-install.sh`; `node` for the
guard, which blocks every Bash call of the session if `node` is missing (fail-closed).
