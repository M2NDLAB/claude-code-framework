---
date: 2026-10-07
task: v1.3.1 — a broken agent-git guard blocks delegated agents only, never the main session (the review's A5 variant); the IMP-054/055 retro lessons and tag signing recorded as IMP-063..066
branch: fix/guard-agent-only-fail-closed
status: completed
model: 'claude-opus-5-5'
turns: 1
tags: [session, imp, security, verification]
---
# Session 2026-10-07 — v1.3.1: the guard fails closed for delegated agents only

> A small deliverable after v1.3.0 ([[2026-09-27-imp-054-055-agent-git-boundary]]), from
> `main` at `ec0b118`. No plan block: five commits. Probes only in throwaway repositories
> under `/tmp`, remotes via `file://`; nothing towards GitHub.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session. Delegated: one reviewer
  (`general-purpose`, the main model); three nested probe sessions (`claude-haiku-4-5`,
  scripted executor).
- `turns: 1` — the v1.3.1 prompt. Not counted: background notifications, the reviewer's
  hand-back.

## The user's decisions (2026-10-07)
1. **The review's A5 variant — yes.** In its reduced form the guard has no job in the main
   session (the push boundary is the `pre-push`), so blocking the main session when the
   guard breaks was pure cost: no Bash tool with a missing file or `node`, and a grafted
   project upgraded in the wrong order locked its own session. The wiring: if the script
   fails AND the input carries `agent_id` → exit 2; otherwise → exit 0. Delegated agents
   stay fail-closed. A hermetic test covering both branches; `SETUP.md` and `docs/04`
   simplify where they describe the recovery and the upgrade order — declared.
2. The three retro lessons of [[2026-09-27-imp-054-055-agent-git-boundary]] recorded as
   OPEN IMPs, for the retro.
3. An OPEN IMP, low priority: `/integrate` step 4 verifies the tag's signature with
   `git tag -v` ONLY when signing is configured at setup; signing stays optional. Origin:
   the framework's tags are annotated but not signed, and GitHub shows them as Unverified.
- PATCH v1.3.1; a dedicated branch from `main`; `/checkpoint` and the printed `/integrate`
  block at the end — merge, tag and push are the user's.

## Done
- `ab2cd0c` — IMP-063 (a fan-out's stall cost), IMP-064 (permission probes in an
  untrusted workspace), IMP-065 (edit the method's files with the file tools), IMP-066
  (tag signature in `/integrate`, low priority): all OPEN.
- `fc174d3` — the two self-tests that run git ignore the user's global and system git
  config. Found on the way, not asked: the user's global config now has `tag.gpgsign` and
  `commit.gpgsign` set, and `make test-scripts` failed on the snapshot test (a plain
  `git tag` became a signed tag asking for a message) — a hermeticity defect shipped in
  v1.3.0.
- `c65b22a` — the A5 wiring; the guard's comments; `test-agent-git-guard.sh` section 4
  rewritten for both branches; `docs/04` (the table row, the fail-closed bullet, the
  "guard cannot run" bullet), `SETUP.md` (Step 3: no order to respect between the guard
  and `settings.json`, from v1.3.1), `scripts/README.md`.
- `b8997aa` — the review applied (below).
- This checkpoint; the CHANGELOG 1.3.1 entry at `/integrate`.

## The wiring, final
```
input=$(cat) || exit 2; printf '%s' "$input" | node "$CLAUDE_PROJECT_DIR/scripts/agent-git-guard.mjs"; rc=$?; case $rc in 0|2) exit $rc;; esac; case "$input" in *'"agent_id"'*) exit 2;; esac
```
The guard's verdict (0 pass, 2 block) always stands; a failure (exit 3 on unreadable
input, a crash, a missing file or `node`) blocks when the raw input carries the
`agent_id` key and passes otherwise; an input the wiring cannot even read blocks.

## Verification — RED → GREEN
| Check | Previous version | This branch |
| --- | --- | --- |
| Self-test, `node` missing, main session | v1.3.0's `\|\| exit 2`: FAIL ("expected exit 0, got 2") | PASS |
| Self-test, no `cat`, agent input | `c65b22a`'s wiring: FAIL ("expected exit 2, got 0") | PASS |
| Self-test, a healthy block with the key JSON-escaped | `c65b22a`'s wiring: FAIL ("expected exit 2, got 0") | PASS |
| Snapshot test under `GIT_INDEX_FILE=<outside>` | `c65b22a`: rc 1, an index written outside its temp dir | rc 0, nothing outside |
| Snapshot test with the user's signing config | `ec0b118`: FAIL ("no tag message?") | PASS |
| Nested sessions, the guard file removed | v1.3.0: the MAIN session's Bash blocked, the subagent blocked | the main session's Bash works, the subagent blocked (re-run on the final wiring) |
| `make test-scripts` | — | 4 of 4 PASS |
The reviewer also ran the self-test against six wirings on a scratch copy: only the
current one passes (the old `|| exit 2`, `|| true`, a fail-open that keeps exit 2, a bare
`node …`, a loose `*agent_id*` pattern all fail), and checked the wiring under bash-as-sh,
dash, ksh and zsh, with trailing newlines, CRLF, NUL bytes, invalid UTF-8, empty and 8 MB
inputs.

## Review (one reviewer, the security gate) — dispositions
| Finding | Severity | Disposition |
| --- | --- | --- |
| F1 — if `$(cat)` cannot run, an agent's input reads empty and passes | LOW | FIXED: `input=$(cat) \|\| exit 2` — an unread input cannot be classified, so it blocks (the main session too: only when `cat` itself cannot run); tested |
| F2 — the wiring overrode a HEALTHY guard's verdict by a text match (a JSON-escaped key) | LOW | FIXED: verdicts 0/2 stand; the guard reports unreadable input as exit 3, a failure; tested |
| F3 — while the guard is broken, a main-session value ENDING in `"agent_id` matches; `"agent_id":null` | INFO | Kept the loose pattern (a false positive blocks: fails safe; a tighter `"agent_id":` would fail OPEN if the JSON ever had a space before the colon); the test comment corrected; a main session with `agent_type` only now tested |
| F4 — the main session gets no signal that the guard is broken (exit 0 hides its stderr) | INFO | NOT CHANGED: an exit 1 would contradict the user's verbatim "altrimenti → exit 0" — the user's call |
| F5 — the tests still leaked the caller's git ENVIRONMENT (`GIT_DIR`, `GIT_INDEX_FILE`, `GIT_CONFIG_PARAMETERS`, …): from a git hook they wrote into a repo outside their temp dir | LOW | FIXED: `unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR`; RED → GREEN shown |
| F6 — docs accurate; `SETUP.md` says "from v1.3.1" before `/integrate` computes the version; a wikilink to this note before it existed; an overlong README line | INFO | v1.3.1 is the user's decision (PATCH); this note now exists; the line reflowed |
Not checked by the reviewer: Windows/Git Bash, other Claude Code versions, how a hook's
stderr reaches the user on exit 0 vs 1, workflow agents' hook input (verified live in
phase 1 of the earlier block), Linux dash beyond macOS's.

**Gate verdict**: no HIGH, CRITICAL or MEDIUM; LOW F1, F2, F5 resolved; INFO recorded,
F4 left to the user.

## Problems encountered → cause → solution
1. `make test-scripts` failed on a test that passed in v1.3.0 → the user had since set
   `tag.gpgsign`/`commit.gpgsign` globally, and the tests read the global config → tests
   made hermetic (config, then — after the review — environment).
2. The first run of the new section 4 failed for the agent branch with `node` missing →
   the test's `PATH=/nonexistent` also removed `cat`, which the wiring needs → a `PATH`
   holding `cat` only; the missing-`cat` case became its own test after F1.
3. A probe loop failed with "bad substitution" → zsh reads `$ref:s…` as a modifier →
   `${ref}`.

## Retro
One candidate lesson, offered and not recorded (the user listed this block's IMPs): a
self-test is hermetic only if it pins the git CONFIGURATION and the git ENVIRONMENT it
runs in — the user's signing setup broke it the day after release. The fix is in the
code; whether it deserves a line in `docs/02` (*Tests that demonstrate*) is the retro's.

## Follow-up
- `/integrate`: v1.3.1 (PATCH); merge, tag and push are the user's. The user's machine now
  signs tags (`tag.gpgsign`): the release tag will be signed — IMP-066 is about the
  method's check, not this machine's setup.
- F4 (a signal to the main session when the guard is broken) — the user's call.
