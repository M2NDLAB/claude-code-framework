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
- [ ] 1. This note — the user's brief and this plan — commit: —
- [ ] 2. Main's red CI, diagnosed from its log: the test, its cause and the evidence, the class; the fix's direction, for a `fix/` branch of its own — commit: —
- [ ] 3. The IMP on the run block 2 starts on `main`, which no step of the method reads, and where its check goes — commit: —
- [ ] 4. The course's candidates (a) to (e), PROPOSED, each with its source and its verification date — commit: —
- [ ] 5. The course's candidates (f) to (j), PROPOSED — (i) at LOW priority, (j) deferred — commit: —
- [ ] 6. The first derived project's harvest: its new entries, from the first free number — commit: —
- [ ] 7. The harvest's entries that repeat or extend an existing one, as evidence on it; the lesson decided at an agreed point and never recorded; the user's two additions — U6's linter, the attribution with its settings keys verified — commit: —
- [ ] 8. The agnosticism of what the harvest brings, and the deduplication table for the project — commit: —
- [ ] 9. The checkpoint: the IMPs' state, the gate's line, the follow-up, `status: completed` — commit: —

## Problems encountered → cause → solution
- The brief's item 2 announces an attached block and a section to paste: the message held
  neither — its placeholder for the section was left as it was written → nothing to record
  from them yet → the user asked for both; tasks 6 to 8 wait for them, and no entry is
  reconstructed from elsewhere.

[[LEARNINGS]] · [[2026-10-19-4.1.0-record]]
