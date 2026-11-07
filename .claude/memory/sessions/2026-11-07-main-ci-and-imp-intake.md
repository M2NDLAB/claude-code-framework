---
date: 2026-11-07
task: main's red CI diagnosed, and the IMP on the run no step reads; the course's method candidates and the first derived project's harvest recorded and deduplicated — nothing applied, no triage
branch: chore/memory-main-ci-and-imp-intake
status: in-progress
model: 'claude-opus-5-5'
turns: 1
tags: [session, imp, harvest, ci]
---
# Session 2026-11-07 — Main's red CI, and the intake of new IMPs

> Recording only: a branch of its own from `main` at `20a5287`, its diff confined to the
> framework's records — this note and entries of [[LEARNINGS]] —, so no gate, no retro and no
> tag (`CONTRIBUTING.md`, *This repo's workflow*). The fix the diagnosis calls for goes on a
> `fix/` branch of its own, never on this one (the user's word, below).

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 1` — the brief.
- Ultracode was on for the session, by the user's `/effort` at its start, whose output read
  "Set effort level to max (this session only) … · Ultracode on": the user's explicit
  decision, the case candidate (c) asks a note to record. The delegation kept the core's
  terms. One read-only workflow (run `wf_ea6a6a7d-553`), 9 agents: 6 reading Claude Code's
  documentation live — five `web-fetch` agents on one page each, one `claude-code-guide`
  held to the docs site —, 3 sweeping `LEARNINGS.md` by thirds for the kin of the eleven
  candidates; each brief quoted the user's words verbatim. The stall budget, set at the
  launch: 25 minutes. It took 11 (658,260 ms), 750,350 tokens and 80 tool calls; no agent
  stalled or was skipped; the agents ran on the models their types define, not read here.
  `scripts/repo-snapshot.sh` and `git diff` before and after: identical. What it did not
  cover: past each page's first 40,000 characters or so the fetch tool returned a model's
  summary, not the text — an answer that rests on one is marked so where an entry cites it,
  and no proposal rests on one —; and each kinship the sweep called "extends" was read again
  here, by hand, before it reached an entry.

## The user's brief, 2026-11-07 (translated from Italian)
Project names replaced by their neutral labels, as everywhere in this repository.

"Session on the framework, phase 9 part 1: the CI's diagnosis and the harvest from the first
derived project. Do NOT apply IMPs and do NOT triage: only diagnosis, recording and
deduplication. Work on a dedicated chore/ branch (a descriptive name), small commits, the
memory updated, /fw:checkpoint at the end. No push, merge or tag: prepare the blocks for me
according to Boundary. The method's files changed only with the file tools. Artifacts in
English.

1. Red CI on main. Fact: run 39250087583 (commit 20a5287, main) fails on windows-2025 at the
step "make test-scripts" with exit 2. The run of ed9b97c (branch chore/memory-4.1.0-record)
passes, and `git diff ed9b97c 20a5287` is empty: the same files. Read the log with `gh run
view 39250087583 --log-failed`, read-only. If gh is not there or not logged in, STOP and ask
me for the log. I will tell you the outcome of the re-run, which I launch myself. Classify it:
a non-deterministic test, a change of the runner, or something else. Name the test and the
cause, with the evidence. The fix, if one is needed, goes on a separate fix/ branch, with the
CI on the 3 systems before integrating. Do not mix it with the recording. Record an IMP: main
stayed red for 19 days without any step of the method seeing it (block 1 checks the branch's
CI, none the one started after block 2). Propose where the check goes.

2. The harvest from the first derived project (the attached block, already anonymised).
Record every IMP of the block in LEARNINGS, plus the lesson below, decided at an agreed point
and never recorded: [the section "Sensitive components named by code path..." of the
project's report]. Verify the agnosticism: no project name, local path or secret.
Deduplicate against the whole of LEARNINGS. For each entry: new / duplicate of IMP-xxx /
extends IMP-xxx. Produce the table to send back to the project. Add to the one on U6 (zsh)
this proposal: the linter is an answer of the project; where no linter exists for a dialect
of the shell, the minimum is the syntax check, declared as such. Add to the one on the
attribution trailer this proposal: the attribution is an answer of the project, set with the
`attribution` key (commit, pr, sessionUrl) of the settings. Verify the keys on
https://code.claude.com/docs/en/settings-reference before writing them.

3. Method candidates from the course, to record as PROPOSED (not approved), each with its
source and its verification date (2026-10-31):
a. Session suggestions: one fixed line, "▶ For you: <command> — <why>". /clear at the end of
/fw:integrate and at the end of /fw:checkpoint with a closed deliverable; the effort suggested
in /fw:plan by the cost of the error (low, medium, high, xhigh, max; ultrathink for a single
turn); /compact with a focus in long tasks; a change of model only at /clear (each model has
its own cache). The table goes in a doc loaded on demand, dated; in fw-core a single line.
b. Models named only by family (haiku, sonnet, opus), as an answer given at setup; the
opusplan option.
c. Ultracode off by default (it orchestrates multi-agent workflows and contradicts the
controlled delegation of fw-core); on only by an explicit decision of the user, recorded in
the session note.
d. CLI and MCP: git and everything that touches the boundary only from the CLI (the guard and
the pre-push do not see an MCP server for git); for the rest the CLI where there is one, MCP
where it gives something more; the servers not in use are disabled.
e. ARCHITECTURE.md at the root, not copied into the projects: the layers, a deliverable's
cycle and the inventory of sub-agents, hooks, permissions, commands and automations, in
Mermaid. docs-check compares the inventory with settings.json, commands/fw/, hooks-install.sh
and the CI's matrix.
f. Automatic memory: the levers autoMemoryEnabled and autoMemoryDirectory, and the automatic
memory declared not authoritative.
g. The automatic proof uses the InstructionsLoaded hook to verify what loads, after a
compaction and in sub-agents too.
h. The parts of fw-core tied to specific files become rules with `paths:`, to go below 187
lines.
i. A SubagentStart hook with a short note of method for the Explore and Plan agents, which do
not load fw-core. Low priority.
j. model and effort for the reviewer sub-agents, as an answer given at setup. Deferred.

4. End of session. Report to me: the CI's diagnosis; the deduplication table for the project;
the new IMPs with their id; the state of LEARNINGS (total, applied, rejected, deferred,
waiting); the integration blocks to run. The triage starts when the harvest of another
project arrives (at the end of its C1)."

The brief's item 2 named an attached block and a section to paste, and neither was in the
message: *Problems*, below.

## Plan (one commit per task)
- [x] 1. This note — the user's brief and this plan — commit: 69d24f4
- [x] 2. Main's red CI, diagnosed from its log: the test, its cause and the evidence, the class; the fix's direction, for a `fix/` branch of its own — commit: 9897afd
- [x] 3. The IMP on the run block 2 starts on `main`, which no step of the method reads, and where its check goes — commit: f94c008
- [x] 4. The course's candidates (a) to (e), PROPOSED, each with its source and its verification date — commit: 48b944c
- [ ] 5. The course's candidates (f) to (j), PROPOSED — (i) at LOW priority, (j) deferred — commit: —
- [ ] 6. The first derived project's harvest: its new entries, from the first free number — commit: —
- [ ] 7. The harvest's entries that repeat or extend an existing one, as evidence on it; the lesson decided at an agreed point and never recorded; the user's two additions — U6's linter, the attribution with its settings keys verified — commit: —
- [ ] 8. The agnosticism of what the harvest brings, and the deduplication table for the project — commit: —
- [ ] 9. The checkpoint: the IMPs' state, the gate's line, the follow-up, `status: completed` — commit: —

## Main's red CI — the diagnosis
Read with `gh`, read-only: `gh run view 39250087583 --log-failed`, the run's and its jobs'
JSON, the job log of the green run 39240838225, and the list of the runs since 2026-10-13.

- **The run.** 39250087583, the push of `main` at `20a5287` — the `--no-ff` merge of
  `chore/memory-4.1.0-record` —, 2026-10-19 12:11 UTC: ubuntu-24.04 and macos-26 green;
  windows-2025 red at `make test-scripts`, exit 2 — make's own status when a recipe fails —,
  and every later step of the job green.
- **The test.** `scripts/test-hooks-install.sh`, case 6 (*binary files*), its sub-check
  "stopped by Ctrl-C": `FAIL (binary files): stopped by Ctrl-C: expected exit 130, got 0`.
  The case runs the generated pre-commit in the background under job control, a stub
  gitleaks first on `PATH` in its `hang` mode — the stub writes its pids, then `exec sleep
  30` —, sends INT to the hook's process group as soon as the pids file has content, and
  expects the hook to die of it (130) with the scan's directory gone. The `out6.log` it
  printed holds only git's `unable to stream … to stdout`, the closed pipe the case's
  comment expects.
- **The class: a non-deterministic test** — neither the runner nor the files:
  1. the same tree passed on the same image: the run on `ed9b97c` (39240838225, 10:54 UTC
     the same day) and this one both ran the image `windows-2025-vs2026` 20261007.264.1,
     runner 2.337.0, provisioner 20261002.596; `git diff ed9b97c 20a5287` is empty (the
     user's fact), and the case builds its own repositories in a temporary directory, so the
     branch, the merge commit and the refs never reach it;
  2. the same job ran the same test twice more, both green: the step "Each self-test on its
     own (after a failure)" at 12:15 — `PASS (binary files)` —, and the shipped self-tests
     inside a grafted project at 12:27;
  3. 28 runs since `bfd6c90` (2026-10-13), which brought the sub-check, tested a tip that
     holds it, each Windows job running it two or three times: this is its only failure. The
     period's two other red runs were real defects, fixed since — 39035256707, a CR test
     (`83b422c`), and 39170600064, two fixture checks (`f011b8e`, `ffcb0d4`).
- **What failed, from the timing.** The remainder of case 6 after its `NOTE` line — the
  sub-check included — took 33.25 s in the red execution (12:11:49.09 → 12:12:22.34), 1.86 s
  in the same job's green one (12:15:10.37 → 12:15:12.23) and 2.75 s in the green run on
  `ed9b97c` (10:55:33.84 → 10:55:36.59). The 30 s more are the stub's `sleep 30` run to its
  end: the scan never died of the INT. The hook then exits 0 by bash's rule for a SIGINT
  that arrives while it waits for a foreground command which does not die of it — bash
  takes it as handled and goes on —: the scan returns 0, the stub's `protect` returns 0, the
  hook ends green. Reproduced here on the case reduced to its shape — an EXIT trap and no INT
  trap, the scan a subshell that execs the stub, `set -e` — with macOS's bash 3.2.57: the INT
  delivered, exit 130 at once; the INT lost by the scan (its sleep ignoring INT), exit 0
  after the whole sleep, the hook going on past the scan. Windows' bash 5.3.15 not measured;
  the rule is the bash manual's (*Signals*).
- **Why the INT did not take — likely, not proven.** The stub announces itself (its pids
  file) before its last `exec sleep 30`, and the test signals as soon as the file has
  content. Under Git Bash's MSYS2 runtime an exec starts a new Windows process, and a signal
  that lands while the stub hands over to sleep can be lost. A `kill` to the group that
  failed would leave the same trace — the scan running out its sleep, the hook at 0 —; only
  `jobs6.log`, where the case sends the subshell's stderr, would tell the two apart, and
  `fail6` does not print it.
- **The fix's direction**, for a `fix/` branch of its own, the CI on the three systems
  before integrating (the user's word) — not applied here:
  (a) diagnostics: `fail6` prints `jobs6.log` too, and the sub-check its duration; a `kill`
  that fails becomes a failure with its own message;
  (b) the race removed: the stub announces itself only once nothing in it execs again — it
  traps INT to die of it (`trap 'trap - INT; kill -INT $$' INT`), leaves the scan's
  directory (`cd /`; Windows refuses to remove a process's working directory), writes its
  pids, then waits in its own bash (`while :; do sleep 1; done`): an INT then reaches a bash
  that is not exec'ing, and its trap runs even where its current sleep misses the signal;
  (c) RED first — a stub that loses the INT fails the sub-check with the new message —, then
  GREEN, here and on the three systems.
  `scripts/` ships, so the fix is a release, a PATCH at least, and the test backs a claim of
  the pre-commit's, so in doubt under the gate; or it joins the next corrective release —
  the user's call.
- **The re-run** of 39250087583: the user's, its outcome awaited (*Follow-up*).

## Problems encountered → cause → solution
- The local reproduction's first form was refused by the project's `deny` rule
  `Bash(rm -rf:*)`: the command cleaned its scratch directory first → the rule matches the
  literal form, whatever the path → the scripts written with the file tools into a new
  scratch directory, nothing to remove; nothing had run.
- The brief's item 2 announces an attached block and a section to paste: the message held
  neither — its placeholder for the section was left as it was written → nothing to record
  from them yet → the user asked for both; tasks 6 to 8 wait for them, and no entry is
  reconstructed from elsewhere.

## Proposals
All in [[LEARNINGS]], recorded as proposed, none decided — the triage starts with the next
harvest (the user's word).
- IMP-142 — the run block 2 starts on `main` is read by no step; the check goes into block 0a,
  the session that prints block 2 reading the merge's run besides.
- The course's candidates, each with its source, the user's verification of 2026-10-31 and the
  docs re-read on 2026-11-07 (quoted where an entry rests on them; what came through the fetch
  tool's summary is marked so). Where the docs differ from the candidate, the entry says so.
  - IMP-143 (a) — session suggestions, one fixed line; extends IMP-012 and IMP-017.
  - IMP-144 (b) — models by family, an answer given at setup; `opusplan`. The docs list a
    fourth family, `fable`, and `opusplan` switches at Claude Code's plan mode, not at
    `/fw:plan`.
  - IMP-145 (c) — Ultracode off by default; extends IMP-060. Claude Code's own default is
    already off; this session is the first case its rule would record.
  - IMP-146 (d) — git and the boundary from the CLI only; extends IMP-092, IMP-054 and
    IMP-055. The candidate's "the pre-push does not see it" holds for a server that runs no
    git binary or runs remotely; for a local one that runs git, to be measured.
  - IMP-147 (e) — `ARCHITECTURE.md` at the root, its inventory checked.
  - IMP-148 (f) — the auto memory's two levers, and declared not authoritative. Setting them is
    the user's, not the payload's: a directory the project's own settings set may be refused
    (reported by the reading, not quoted).
  - IMP-149 (g) — an automatic proof of what loads, by `InstructionsLoaded`. The page says
    nothing of subagents: that half is measured first.
  - IMP-150 (h) — the core's file-bound parts into path-scoped rules; extends IMP-124. IMP-117
    kept rule 10 in the core and turned down a path rule for it.
  - IMP-151 (i), LOW — a `SubagentStart` note for Explore and Plan. Whether those two also skip
    the rules with no `paths`, as `docs/00` says, is not in the text read: to be read or
    measured.
  - IMP-152 (j) — the reviewers' model and effort at setup, deferred by the user's word; its
    trigger proposed here, none having been given.

## Follow-up
- The re-run of 39250087583, launched by the user: its outcome, reported by the user, goes
  into the diagnosis — green on the same commit confirms the class; red again, on a newer
  image, reopens it.
- The harvest's block and the section of the project's report: the user's, asked for on
  2026-11-07; tasks 6 to 8 wait for them.
- The fix of the self-test: a `fix/` branch of its own, after this one is integrated — the
  user decides whether it ships alone or with the next corrective release.

[[LEARNINGS]] · [[2026-10-19-4.1.0-record]]
