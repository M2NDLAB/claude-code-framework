---
date: 2026-09-27
task: retro block — IMP-054 + IMP-055, what really enforces a boundary on an agent; phase 1 (verified inventory + proposal, 2026-09-27) and phase 2 (the user's decisions applied, from 2026-10-07); IMP-061 recorded
branch: feat/agent-git-boundary
status: in-progress
model: 'claude-opus-5-5'
turns: 4
tags: [session, imp, retro, security, verification]
---
# Session 2026-09-27 — IMP-054 + IMP-055: real boundaries for an agent

> A retro block in two phases. Phase 1 (2026-09-27): a read-only assessment and a
> proposal, then STOP. Phase 2 (from 2026-10-07, after the user's decisions): applied on
> this branch, one commit per task. Hybrid regime: no `plans/`; this note is the
> plan-pointer. Every push probe runs in a throwaway repository outside the framework,
> with a `file://` bare remote; each lab repository carries `protocol.allow=never` and
> `protocol.file.allow=always`. Nothing targets GitHub: the only contact is read-only GETs
> of the repository's visibility, protection and rulesets.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session throughout. Delegated in phase 1: one
  documentation workflow (4 researchers + 4 adversarial verifiers) and one review workflow
  that stalled (see *Phase-1 review status*), all on the main model. The 39 nested probe
  sessions ran `claude-haiku-4-5` as a SCRIPTED EXECUTOR only: no verdict relies on its
  reasoning — each comes from the lab remote's refs and from the tool results Claude Code
  returned.
- `turns: 4` — the phase-1 prompt; the resumption after the machine slept (present the
  proposal as it stands); the GitHub ruleset to cite; the decisions with the phase-2
  go-ahead. Not counted: `/model`, `/effort`, background notifications.

## Plan (one commit per task)
- [x] 1. This note: phase-1 evidence, the user's decisions, the plan block — commit: d64a9e1
- [x] 2. Record IMP-062 (OPEN): cover remote writes through `gh` — commit: a66eda3
- [ ] 3. `scripts/agent-git-guard.mjs` (delegated agents read-only on git) + its wiring in `settings.json` (PreToolUse, fail-closed; the `AGENT_GIT_BOUNDARY` marker) + `scripts/test-agent-git-guard.sh` + `Makefile` — commit: —
- [ ] 4. `hooks-install.sh` generates the `pre-push` (the push boundary) + `test-hooks-install.sh` extended — commit: —
- [ ] 5. `scripts/repo-snapshot.sh` + `scripts/test-repo-snapshot.sh` + `Makefile` — commit: —
- [ ] 6. `docs/04` (threat model, enforcement, delegated agents), a pointer in `docs/03`, `scripts/README.md`, `CLAUDE.md`'s quick-command line — commit: —
- [ ] 7. `SETUP.md` (classes, *Hardening*, hooks step, upgrade Step 4), `.gitignore`, `README.md` — commit: —
- [ ] 8. Code review of the hook and the `pre-push` by ONE reviewer (security-gate lens) + fixes — commit: —
- [ ] 9. `ask` rules on edits to `settings.json` and to the hook file (D6) — commit: —
- [ ] 10. End-to-end verification on the REAL files in a throwaway lab (v1.2.1 RED, the branch GREEN) — commit: —
- [ ] 11. `/retro` + `/checkpoint` (IMP-054/055 → Applied) — commit: —
- [ ] 12. `/integrate`: the CHANGELOG 1.3.0 entry; the merge+tag block printed for the user — commit: —

## Phase 1 — evidence (2026-09-27)

### How it was measured
- A lab = a bare `remote.git` + a clone `proj` with 40 local branches `p01..p40` that the
  remote lacks. Each probe form pushes its OWN branch, so the remote's refs say which forms
  landed, whatever the executor reported.
- A nested `claude -p` session (Claude Code 2.1.283) per configuration, told to run each
  form verbatim, one Bash call per form; `--output-format stream-json` gives the exact
  command sent and Claude Code's own answer. The message tells the layer: "Permission to use
  Bash with command … has been denied" = a deny rule matched; "…running in don't ask mode" =
  no rule matched and nothing allowed it; "PreToolUse:Bash hook error" = the hook blocked.
- Trap met and handled: in a workspace never trusted interactively, Claude Code IGNORES the
  project's `permissions.allow` (stderr: "Ignoring N permissions.allow entries from
  .claude/settings.json: this workspace has not been trusted"), while project deny rules and
  hooks stay active. The first matrix therefore ran with no effective allow; it was re-run
  with the allow in `settings.local.json`, which is honoured.
- Model deviations: in three runs the executor re-escaped two forms (`g\it`, `git p"u"sh`);
  those cells are excluded, and both forms were checked verbatim in another run.

### E1 — 30 push forms against five configurations (the remote's refs are the ground truth)
Configurations: **as-is** = the framework's `deny: Bash(git push:*)` + an effective broad
allow; **real** = this repo's own `settings.json` + its personal, untracked
`settings.local.json`, whose `Bash(git *)` allow is honoured; **wild** = as-is + deny
`Bash(git * push *)`, `Bash(git * push)`, `Bash(* git push *)`; **guard** = as-is + a
PreToolUse guard PROTOTYPE that also parsed `sh -c`, `eval` and scripts (not what phase 2
builds); **guard + pre-push** = guard + a `pre-push` git hook that refuses when the process
runs inside a Claude Code session.

| Configuration | Pushes that reached the remote | Blocked by the layer under test |
| --- | --- | --- |
| as-is | 20 of 30 | deny rule: 10 |
| real (this repo) | 9 of 30 | deny rule: 10; 10 more fell to "not allowed" — a prompt in default mode, the classifier in auto mode |
| wild | 12 of 30 | deny rules: 18 |
| guard | 1 of 30 (`make -f push27.mk`) | hook: all 29 others |
| guard + pre-push | 0 of 30 | hook 29, pre-push 1 (`make`) |
| pre-push only (+ as-is deny) | 2 of 30 (`git send-pack`, `-c core.hooksPath=/dev/null … --no-verify`) | deny 10, pre-push 18 |

- The deny rule matches the literal form and what Claude Code strips before matching
  (`cd . &&`, `env`, `nice`, `command`, bare `xargs`, a subshell, `VAR=` assignments, a
  backslash inside the name). It misses every global option before the subcommand (`-C`,
  `-c`, `--git-dir`, `--no-pager`), a quoted subcommand (`git 'push'`, `git p"u"sh`), an
  absolute path, `sh -c`/`bash -c`/`eval`, `$(which git)`, `xcrun`, an ad-hoc alias,
  `git send-pack`, and every indirect route (a script, `make`, `python3 -c`).
- In this repo's REAL configuration 9 forms pushed, among them `git -C . push` (the idiom
  v1.2.1 normalised), `git --no-pager push` and `git send-pack`.
- The wildcard denies close the global-option forms but still let 12 through, and they
  DENY legitimate work: `git stash push -m …` and `echo "never git push here"` (2 of 9
  benign commands). The prototype guard denied none of the 9.

### E2 — Failure modes, modes, subagents, worktrees, sandbox (nested sessions)
| Probe | Result |
| --- | --- |
| Hook exits 1 | fail-OPEN: the push landed |
| Hook binary missing (exit 127) | fail-OPEN: landed |
| Same, wired as `… \|\| exit 2` | blocked ("PreToolUse:Bash hook error … command not found") |
| Hook exceeds its `timeout` (2 s) | fail-OPEN: landed |
| Hook prints `permissionDecision: "deny"` | blocked |
| `--dangerously-skip-permissions` + deny `git push:*` | literal `git push` denied; `git -C . push` LANDED |
| Same + the guard | blocked |
| Subagent (Agent tool), no guard | it ran `git switch -c sub-x` in the SHARED tree — the main session then found itself on `sub-x` — and `git -C . push` landed: IMP-055's incident, reproduced |
| Subagent, with the guard | `switch`, both pushes and a plain `git status` blocked; `git --no-optional-locks status` and `git log` ran; the MAIN session's own `git switch -c main-x` ran |
| Hook input | `agent_id` + `agent_type` present for Agent-tool subagents (`general-purpose`) and for Workflow agents (`workflow-subagent`); absent in the main session. A worktree-isolated agent's `cwd` is its worktree |
| Agent with `isolation: "worktree"` | worktree at `.claude/worktrees/agent-<id>` on a new branch `worktree-agent-<id>`, based on `origin/main` (the lab's seed commit), NOT on the local HEAD; Claude Code's built-in isolation refused `-C`, `--git-dir`, `cd <main> &&` and `sh -c "cd <main>; git …"` towards the main checkout; afterwards the worktree and its branch were gone, an empty `.claude/worktrees/` remained |
| Sandbox (`sandbox.enabled`) | a push to a `file://` remote outside the cwd failed ("unable to create temporary object directory"); `https://example.com` denied by the proxy; a write outside the cwd denied. Default config: the executor's unsandboxed retries went to the permission flow (denied in dontAsk). With `allowUnsandboxedCommands: false` the retries stayed sandboxed |
| `env` key of `settings.json` | the variable reaches the Bash tool and its child processes; so does `CLAUDECODE=1` |
| A linked worktree's own git (plain git) | from the agent's worktree, `git branch -f p06 HEAD~1` moved another branch, `git config user.email …` changed the SHARED config, `git stash push` landed in the SHARED stash; only a branch checked out in another worktree is refused (`branch -D` not tried: this session's own deny matched and was respected) |

### E3 — Plain-shell probe of the `pre-push` layer (this session's shell, `CLAUDECODE=1`)
Blocked: direct push, `git -C . push`, a script file, `python3` subprocess, `make`, an
ad-hoc alias. Landed: `git send-pack` (plumbing: no pre-push), `--no-verify`,
`-c core.hooksPath=/dev/null`, `env -u CLAUDECODE`, `CLAUDECODE=` — and, as intended, a
push from a shell without the marker (the human's terminal).

### E4 — Documentation (code.claude.com, docs.github.com, git-scm.com; verified adversarially, 0 coverage gaps)
- Bash rules: "It doesn't match the same program invoked in a different form, so a deny or
  ask rule covers the invocation Claude usually produces and isn't a security boundary
  around the program." Named examples: `git -C . push origin main`,
  `git -c push.default=current push origin main`, `git 'push' origin main`
  (permissions, *What a Bash rule doesn't match*). Wrappers stripped: `timeout`, `time`,
  `nice`, `nohup`, `stdbuf`, `command`, `builtin`, `noglob`, bare `xargs`.
- For enforcement the same page points to the sandbox ("doesn't depend on the command
  text") or a PreToolUse hook ("to inspect the full command text with your own logic").
- Auto mode: "Auto mode allows pushes to any branch of the repository you're working in,
  including the default branch"; an `ask` rule is evaluated before the classifier, but "a
  push Claude writes another way, such as `git -C <dir> push` … doesn't match the rule, so
  it isn't checkpointed" (auto-mode-config, *Common boundaries*).
- Deny rules "block in every mode, including `bypassPermissions`" — matches E2.
- Hooks: exit 2 blocks "before permission rules are evaluated" and "even a JSON
  `permissionDecision` of `"allow"` can't override it"; exit 1 is a "non-blocking error
  (action proceeds)". Settings-file hooks "also run before every tool a subagent uses",
  with `agent_id`/`agent_type`. The docs CONTRADICT themselves on a PreToolUse timeout —
  E2 measured fail-open for a command hook. `--bare` and `--safe-mode` load no hooks;
  `disableAllHooks` disables them. Settings files are watched and reloaded mid-session,
  hooks included.
- Subagents: `disallowedTools: Bash(git push *)` "still removes the whole tool from the
  subagent, not only the matching commands" — there is no per-agent Bash rule; the hook's
  `agent_id` is the only per-agent, per-command mechanism.
- Worktrees: subagent worktrees "branch from your repository's default branch unless
  `worktree.baseRef` is set to `"head"`"; Claude Code "blocks a Bash or Monitor command that
  redirects git into the main checkout" — matches E2.
- Path rules (checked 2026-10-07): "`Edit` rules apply to all built-in tools that edit
  files"; a `Write(path)` rule "is never consulted"; `/path` is relative to the settings
  source. `.claude/` is a protected path: its writes are never auto-approved (prompted in
  default mode, routed to the classifier in auto mode); `scripts/` is not.
- Sandbox: Seatbelt (macOS), bubblewrap + socat (Linux, WSL2), no native Windows; network
  allowlist by DOMAIN only (fetch and push to the same host are indistinguishable); domain
  fronting can reach unlisted hosts; only Bash is sandboxed.
- `CLAUDECODE` is NOT documented (env-vars reference); the `env` key of `settings.json` is.
- GitHub: rulesets and branch protection are free for PUBLIC repos only; a token "has the
  same capabilities … that the owner of the token has", so the server cannot tell the agent
  from the human on the same credential; GitHub.com has no custom pre-receive hooks. Remote
  writes without `git push` exist: `gh api` (POST/PUT/PATCH), `gh pr merge`,
  `gh release create` (creates the tag).
- git: `--no-verify` "bypasses the pre-push hook completely"; `-c core.hooksPath=/dev/null`
  disables all hooks; `git send-pack` does not run `pre-push`.
- This repository (GETs): on 2026-09-27 public, personal account, `main` not protected, no
  rulesets, `gh` logged in with `repo` scope, SSH remote. On 2026-10-07 two rulesets set by
  the user: `protect-main` (default branch: `deletion`, `non_fast_forward`) and
  `protect-release-tags` (`refs/tags/v*`: `update`, `deletion`, `non_fast_forward`), both
  active, no bypass actor, `current_user_can_bypass: never`.

## Phase-1 review status — a declared coverage gap
- VERIFIED adversarially: the documentation facts (E4) — 4 researchers + 4 skeptics, all
  completed, corrections integrated.
- MEASURED, NOT reviewed: E1-E3 (ground truth = the lab remote's refs; neither the harness
  nor its reading was reviewed by a second party).
- NOT VERIFIED by anyone: the synthesis of the proposal (inventory judgements, the
  combination, the IMP-055 design, the class table, the bump), the prototype's code, the
  counts. The pre-note review workflow (red team, framework contract, fact-check, then
  skeptics) stalled: its agents were interrupted and restarted repeatedly; after about an
  hour 0 of 3 reviewers had returned, 0 skeptics had run, and it was stopped. The user
  takes the unverified parts to the Architect; phase 2 has ONE code reviewer (task 8).

## The user's decisions (2026-10-07)
- **Threat model** (to be written in `docs/04` and in the *Hardening* section): the method
  defends against an agent's ACCIDENTAL errors made with ordinary commands. The three real
  incidents were all of this kind; no agent ever pushed or bypassed a control on purpose.
  Deliberate evasion is outside this layer: only the operating system or the forge's rules
  stop it.
- **D1 — yes, with a REDUCED hook.** The `pre-push` with the marker covers EVERY push born
  from the agent's process, in any form (`-C`, a script, `make`, `sh -c`): it IS the push
  boundary. The PreToolUse hook does ONE thing: git read-only for delegated agents
  (`agent_id`), recognising the subcommand after the global options (`-C`, `-c`,
  `--git-dir`, …), fail-closed through `|| exit 2`. NO analysis of `sh -c`, `eval`, shell
  scripts or interpreter code: pushes there are the `pre-push`'s, the rest is deliberate
  evasion. The hook stays small and readable.
- **D2 — yes**: the deny list unchanged, no wildcards; `docs/04` stops presenting it as the
  boundary.
- **D3 — no, for now**: the hook does NOT cover `gh`. Recorded as an OPEN proposal (IMP-062),
  trigger: the first use of `gh` in the framework's flows, or the first incident.
- **D4 — yes**: delegated agents are read-only on git (everywhere — E2's worktree row).
- **D5 — yes**: an essential `repo-snapshot.sh` — HEAD, branch, refs, stash, worktrees,
  untracked files.
- **D6 — yes**: `ask` rules on edits to `settings.json` and to the hook file.
- **D7 — done by the user** (the rulesets above). A short *Hardening* section in `SETUP.md`:
  the ruleset as the server-side layer; the sandbox ONLY as a documented option with its
  cost, not as a recommendation.
- **D8 — yes**: MINOR v1.3.0, with an *Upgrading* note declaring the behaviour change for
  projects whose delegated agents write git.
- **D9 — yes**: the marker is `AGENT_GIT_BOUNDARY=1`.
- Corrections to the proposal: the hook does not cover `gh api`; the ruleset's residual is
  its removal, or remote writes with an owner credential (`gh`, `curl`), outside the threat
  model. The push boundary is the `pre-push`; the hook is the boundary of the delegated
  agents' read-only git.
- Phase 2: a dedicated branch from `main` (aligned with `origin` at `86ca886`); probes only
  in throwaway repositories with a local bare remote via `file://`, never a push towards
  GitHub — the prohibition quoted verbatim in every subagent's brief; a hermetic test in
  `make test-scripts` that fails if the `pre-push` or the hook stop blocking, the
  crash/missing-binary case included; ONE reviewer for the hook and `pre-push` code; no
  write in the framework repo outside the working branch; at the end `/checkpoint` and the
  printed `/integrate` block — merge, tag and push are the user's.

## Done
- `86ca886` (phase 1, on `main`, a separate commit as asked) — IMP-061 recorded (OPEN):
  `/harvest-framework` re-prints entries already carried upstream.

## Side findings (not in this block's scope)
- `scripts/test-hooks-install.sh` belonged to no class in `SETUP.md` (classified by this
  block).
- Step 2's pathspec lists directories, so a NEW payload directory (`.claude/hooks/`,
  `.claude/agents/`) would never reach an upgrade — kin of IMP-046 and IMP-050 point 3;
  this block avoids it by placing the hook under `scripts/`.
- The Claude Code docs contradict themselves on a PreToolUse timeout; measured fail-open.
- In an untrusted workspace, project `allow` rules are ignored while deny rules and hooks
  apply — a trap for any probe run with `claude -p`.
- This repo's personal `settings.local.json` allows `Bash(git *)`, and these sessions run
  in auto mode, whose classifier allows pushes by default: before this block a
  `git -C … push` would have run unprompted here. The file is the user's own; the
  `pre-push` covers it once installed.
