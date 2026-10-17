---
date: 2026-10-16
task: v4.0.0 — the method's docs leave CLAUDE.md's imports and load when needed; the token-cost assessment, the user's decisions D1-D8, the plan, then the measurements of task 2
branch: feat/on-demand-docs
status: completed
model: 'claude-opus-5-5'
turns: 3
tags: [session, plan, context, imp, gate]
---
# Session 2026-10-16 — v4.0.0: the process docs load when they are needed

> The user's brief, translated from Italian: a new phase after v3.0.0 — measure the
> framework's token cost and plan loading the process documentation only when it is needed;
> measurements and proposals only, nothing modified until the plan is approved. The third
> turn approved this note (step 0 of the plan as presented in the chat — task 1 below): record
> the assessment, the scorecard's baselines, the user's data and decisions, because the session
> scratchpad is not durable; close the comparison with the data; update the plan; run the
> measurements (task 2); stop before the tasks that change the method. This repository keeps a
> heavy deliverable's plan in its session note (`CONTRIBUTING.md`, *A heavy deliverable here*).

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session. Delegated work: two read-only workflows on the
  same model — the research (three agents on Claude Code's documentation, four on the eight
  commands, one dependency scan of the repository, a completeness critic) and an adversarial
  review of the first proposal (six lenses: rule preservation twice, security, derived
  projects, numbers, behaviour). The findings used below were checked at their source where a
  file or a page is cited. `scripts/repo-snapshot.sh` before and after both runs: no
  difference, and no tracked edit.
- `turns: 3` — the brief; the turn with the user's `/context`, `/context all`, `/skill-doctor`
  and `/doctor` (run read-only, nothing applied, as the user had said); the data and decisions.

## Counting method
- No token-counting API: no API key in the environment, and the subscription's credential is
  not read. Characters are counted on the text as Claude Code injected it, rebuilt from this
  session's first API request (the transcript's `api-request-shape` and `api-request-blob`
  entries); tokens are estimated at 2.6-2.9 characters per token, the band the transcripts'
  `usage` fields give on pairs of requests. The user's `/context` (Memory files 33.7k for
  94,027-95,440 characters) puts the ratio at about 2.8; `/context` itself calls its figures
  estimates, and the API's `usage` (61,459 tokens written to the cache by the first request)
  agrees with it within 3%.

## Measured — before
| What loads at every session start | Characters | Tokens (÷2.8) |
|---|---:|---:|
| `CLAUDE.md` | 8,716 | 3.1k |
| `docs/00` | 11,827 | 4.2k |
| `docs/01` | 10,100 | 3.6k |
| `docs/02` | 8,712 | 3.1k |
| `docs/03` | 7,204 | 2.6k |
| `docs/04` (476 lines) | 34,741 | 12.4k |
| `docs/05` | 4,314 | 1.5k |
| `docs/06` | 7,711 | 2.8k |
| `STATE.md` through the `@`-import (no frontmatter, no comments) | 1,564 | 0.6k |
| `STATE.md` again, raw, through the SessionStart hook (run by hand) | 3,266 | 1.2k |
| the eight `fw:` lines of the skill listing | 850 | 0.3k |
| **The framework at every session start** | **≈99,200** | **≈35.0k** |

- Every subagent and workflow agent (Explore and Plan aside, `sub-agents.md:1076`): the same
  95,652-character block opened the first request of each of the eight research agents — about
  33.7k tokens before the brief, written to the cache per agent (no sharing between siblings:
  each wrote 50-71k), at a five-minute TTL. The SessionStart output never reaches them.
- No framework hook adds text at every turn: the guard exits 0 with no output.
- Duplicates. `STATE.md` loads twice. A command's `@` re-attaches its doc: an agent invoked
  `/fw:harvest-framework IMP-999` (read-only) and its transcript holds a `file` attachment of
  `docs/06`, 128 lines, in a context that already held it. The lifetime counters of
  `~/.claude.json` show the commands invoked under their pre-3.0.0 names — `checkpoint` 32,
  `integrate` 25, `security-review` 17, `retro` 16 —, so the duplicate is paid in the projects'
  sessions; this repository's integrations read `integrate.md` instead of invoking it.
- This session (the user's `/usage`, session view): $87.27 at list price — not billing on a
  subscription —; Opus 1.5M output, 178.0M cache read, 4.1M cache write; the main prompt cache
  at 98 requests, 98% from the cache, no miss, a one-hour TTL; the session limit at 77%, the
  week at 12%. From the transcripts, deduplicated by request: 951 requests, 843 of them
  subagents' (89%); at 33.7k each the docs are about 32M of 184M cache reads (17%). The
  transcripts' output counts are partial for subagents: `/usage`'s 1.5M is the figure.
- The session of 2026-10-15 (`f298051e`), deduplicated: 124 main and 398 subagent requests; the
  docs about 16.6-18.4M of 84.1M cache reads (20-22%).
- The cache's lifetime, verified, not assumed: `prompt-caching.md:270-277` — on a subscription
  within its included usage the main conversation gets one hour, subagents, workflows and
  compaction five minutes; over the limit the main conversation drops to five minutes. Measured
  the same: `ephemeral_1h` for the main session, `ephemeral_5m` only for the agents. How cached
  tokens weigh on the Pro/Max limits is not stated.
- The two derived projects' `STATE.md` (project A, the one upgraded next, and project B; read
  read-only, titles and sizes only): 72,257 and 96,500 bytes. Project A: *Caution* 36,836
  characters in two top-level entries, *Progress* 15,606. Project B: no *Caution & open issues*
  title — its open issues sit in a section of its own, 31,534 characters, besides a 7,052-
  character preamble. Both still carry the pre-English titles. The hook's output is capped at
  10,000 characters, past which Claude gets a path and a 2,000-character preview
  (`hooks.md:1017-1020`).
- `/doctor`: no file over the large-file threshold (the larger of 40,000 characters and 5% of
  the window, per `/doctor`'s own text), no size warning for `docs/04` (the user checked).
  `/skill-doctor`: 13 claude.ai-synced and 5 plugin skills never invoked; `fw:harvest-framework`
  once today (the probe above).

The commands, per invocation (tokens ÷2.8; the `@` column is what is attached today on the
invoke path, measured for `harvest-framework` only):

| Command | Body | Attached by `@` | Main reads | Subagents |
|---|---:|---|---|---|
| `checkpoint` | 1.4k | `docs/04` whole, ≈13k | `sessions/README.md`, `STATE.md`, today's note | 0 |
| `integrate` | 4.4k | `docs/04` whole | the CHANGELOG's head, the opening note | 0 in the text; 5 verifiers at 3.0.0 |
| `retro` | 0.5k | `docs/06` + `docs/00` | `LEARNINGS.md` — 74-82k whole; one Read stops at 25k (`tools-reference.md:516`) short of *Deferred* | 0 in the text; 9-11 at a periodic retro |
| `lint-memory` | 2.1k | `docs/06` + `docs/00` | the whole memory, up to ≈300k | 0-4 |
| `security-review` | 0.6k | `docs/03` | the branch's diff | 0-1, up to 8 |
| `sos` | 0.3k | `docs/05` | the note, excerpts | 0 |
| `harvest-framework` | 1.7k | `docs/06` (measured) | a grep, the marked entries | 0 |
| `new-component` | 0.6k | — | the technical rules, a similar component | 0-1 |

## Verified on Claude Code's documentation (raw pages, quoted by page and line)
Imports load at launch (`memory.md:102`) and do not lower the cost (`memory.md:88`); a path in
backticks is never imported (`memory.md:112`); a file named in words arrives "only if
[Claude] decides to open the file" (`memory.md:435`); a rule without `paths` loads at launch
(`memory.md:188`), a path-scoped one on Read, Write, Edit or a one-file view (`memory.md:209`),
`paths` the only field read (`memory.md:241`); after a compaction the root `CLAUDE.md` and
unscoped rules come back from disk, path-scoped rules reload on demand, read files return only
up to five and as a path over 5,000 tokens, skill bodies up to 5,000 tokens each and 25,000 in
all (`context-window.md:1599-1615`); a skill's body stays for the session (`skills.md:610`); a
command file takes every field but `name` and `paths` (`skills.md:173`); a `model` in a
command's frontmatter is a model switch, the whole history read with no cache hit
(`prompt-caching.md:93`); an effort change keeps the cache only on Opus 5.5, Sonnet 5.5, Haiku
5.5 and Fable 5.1 with a key or a subscription (`prompt-caching.md:38`, `:99`); the listing's
budget is 1% of the window (`skills.md:1217`): 6.7k of 10k here.

## The user's decisions, 2026-10-16 (translated from Italian)
- **D1** — "the core in `.claude/rules/fw-core.md` without `paths`, so `CLAUDE.md` stays
  entirely the project's. A condition, to measure at step 1: a rule without `paths` (a) is
  present after a `/compact` and (b) is in the first request of a general-purpose subagent. If
  either is missing, the core goes in `CLAUDE.md`. The documentation guarantees survival of the
  compaction only for the root's `CLAUDE.md`."
- **D2** — "procedures as commands in `fw/`."
- **D3** — "04 whole, read by sections, with the pointers' check in docs-check."
- **D4** — "02 stays where it is, with a rule that loads it."
- **D5** — "STATE with a budget, with the *Caution & open issues* printed first. But the two
  real STATEs exceed by 7-10 times the limit past which a hook's output is truncated: the budget
  alone is not enough. Add (a) in `/fw:checkpoint` the rule that STATE stays under the budget
  and the history moves to the session notes; (b) in `/fw:lint-memory` a check on `STATE.md`'s
  size. The reduction of the two projects' STATEs is NOT done by the upgrade: their first
  `/fw:checkpoint` after the upgrade will do it."
- **D6** — "IMP-126 enters v4.0.0 with commits of its own, including the check of the CI
  inside block 1's chain (promote the 2026-10-16 evidence to a decision: it is my position).
  The next project waits for v4.0.0 and reaches it in a single jump."
- **D7** — the transcripts' retention raised to 90 days by the user; transcripts are not copied
  into the repository.
- **D8** — "yes, at most 5 runs of `claude -p`; report what they consumed."
- IMP-124's Level 2 is decided by this plan: the docs leave the imports.

## The design the plan applies
- **Always** — the core: the rules that hold in every turn, the Definition of Done,
  resumption, a table of the moments at which each doc is read, the boundary, delegation,
  the gate's trigger with its five categories. Where it lives is D1's measurement.
- **By context** — `.claude/rules/fw-code-quality.md` (METHOD, fixed broad globs) tells Claude
  to Read `docs/02` in place (D4). Not an `@`-import: task 2 measured an `@` inside a
  path-scoped rule loaded at every launch, before the rule. `.claude/rules/fw-boundary.md`
  (paths on the boundary's files) points at `docs/04`'s *Enforcement…* and *Permission
  configuration*.
- **Procedures** — commands in `.claude/commands/fw/` (`skills.md:16`: commands are skills);
  each reads its doc at step 1, by section, and again after a compaction; a new `/fw:plan`
  reads `docs/01`. No `@` in a command's body; no `model`, `effort`, `allowed-tools` or `hooks`
  in their frontmatter.
- **The gate** — never by path: always on in the core (the five categories, "in doubt, under
  the gate"), and checked by `/fw:integrate` before its blocks on the session note's gate line
  (the command used and the reviewed tip) — a check the agent applies, declared as such;
  merges outside it are a known limit, written in `docs/03`.
- **`STATE.md`** — no import; `scripts/state-inject.sh` prints the banner, *Caution & open
  issues* first, then the status line, *Active branches*, *Progress* and the rest within a
  budget of 8,000 characters (so the whole output stays under the hook's 10,000), past it a
  notice to Read the full file before anything else; never fails the session (exit 0, the whole
  file on any error). D5's two rules keep the file under budget from the first checkpoint after
  the upgrade on.
- **Expected** (÷2.8): the framework at every session start ≈35.0k → ≈6.4k (the draft core,
  14,758 characters in 172 lines, measured); every subagent ≈33.7k → ≈6k. In the two derived
  projects, where `STATE.md` (71,600 and 95,360 characters) is imported whole as well — if their
  `CLAUDE.md` imports it as 3.0.0's does, which was not read —, about 61-69k → about 9k.

## Scorecard baselines (the first ten sessions after v4.0.0; one miss opens an IMP)
- S1, a gate line in the note closing each merge — 4/4 since `8cf45b1` (recomputed with git).
- S2, a session note in each merge's diff — 27/28 merges, every merge since the first one
  (recomputed).
- S3, `[task N/T]` commits — 201/212 non-merge commits since 2026-10-01 (recomputed); heavy
  branches opened by `[task 1/N]` — 11/11, as the review agent counted it (not recomputed).
- S4, conventional subjects — 338/338 non-merge commits (recomputed).
- S5, a snapshot before and after each delegation — 2/2 in `f298051e`, as the review agent
  counted it.
- S6, the procedure read before a block that moves shared history — 3/3, same source.
- S7, the procedure re-read after a compaction — 1/1, same source.
- S8, `git status` and `git diff` before each commit, no `git add -A` — 1/1, same source.
- S9, rule 10's forbidden forms on the method's files — 0, same source.
- S10, path-rule loads against the files edited — no baseline: an `InstructionsLoaded` hook in
  `settings.local.json` for the trial, logging outside the repository.
- S11, delegated agents reporting a missing `STATE.md` — 0. S13, the built-in
  `/security-review` picked in a gated deliverable — 0. S12, briefs naming the docs an agent
  must Read — a diagnostic. S14, the docs read per session — the cut costs more when the median
  passes 30k tokens.

## Plan (one commit per task)
- [x] 1. The assessment, the user's data and decisions, the scorecard's baselines and this plan; IMP-124's decision, IMP-126's 2026-10-16 evidence and the user's decision, in `LEARNINGS.md`; the merge `0c71b6f` reconciled — commit: 95f9216
- [x] 2. The measurements, in a scratch project outside the repository, at most five `claude -p` runs: an unconditional rule after a `/compact` and in a general-purpose subagent's first request (D1), and in a session started in a subdirectory; an `@`-import inside a path-scoped rule, at launch or with the rule (D4); a path rule at each matching read and around a Write; the SessionStart hook on `compact`; recorded here with their cost (*Task 2 — the measurements*) — commit: 64ec691
- [x] 3. IMP-126: `CONTRIBUTING.md` gives block 0 its written form — commit: 245fcae
- [x] 4. IMP-126: block 1 checks the CI of the tip inside its chain (D6); IMP-126 moved to Applied, its heading taking this task's sha with the next commit — commit: 45ef9e9
- [x] 5. `/fw:plan`, reading `docs/01`; its class, the inventories, the tests — commit: cd358ac
- [x] 6. `scripts/state-inject.sh`, a hermetic self-test (the template, legacy titles, no titles, over the budget, CRLF, a missing file), its class and inventories; the SessionStart wiring in `settings.json` and an `ask` rule on the script, both through the user's approval — commit: 389271a
- [x] 7. The setup answers of `docs/02`-`04` move to `CLAUDE.md`'s technical rules, one marked line each; the slots become pointers and the three docs METHOD; `SETUP.md` §2, the classes, edge cases 7 and 8; `upgrade-check` checks that an answer at `vX` has its new home at `vY` — `refactor!` with a BREAKING CHANGE footer — commit: 8a9a1c1
- [x] 8. `.claude/rules/fw-code-quality.md` (a Read of `docs/02` at its moment, no `@`: task 2) and `.claude/rules/fw-boundary.md`; classes, README's tree, TREE's legend, step 2's pathspec, a coverage check of the globs; docs-check fails an `@` in a method rule — commit: 634d10d
- [x] 9. The commands: step-1 Reads by section, the compaction line, descriptions with triggers, the frontmatter policy, `LEARNINGS.md` read by section, `/fw:sos` on an ARCHITECT RESPONSE, `/fw:security-review` named against the built-in, `/fw:checkpoint`'s STATE budget (D5a), `/fw:lint-memory`'s STATE size check (D5b), its glob and import checks — commit: 40e15a5
- [x] 10. The gate's check in `/fw:integrate`, the PR form included; the limits declared in `docs/03` — commit: d5a33c2
- [x] 11. The core in `.claude/rules/fw-core.md` — D1's two conditions held at task 2 —; `CLAUDE.md` the project's own and its class; `docs/00` *Selective loading*; every `@` of the method's files removed, `STATE.md`'s included; the rules' citations re-pointed; docs-check strict, with the pointers resolved to headings — commit: 9b9175f; the measurements of the fifth turn recorded after it
- [x] 12. `SETUP.md` (the migration from 3.x, the single jump from 1.2.0, `STATE.md` reduced by the first checkpoint after the upgrade, step 4, the brownfield rows), `README.md`, `CONTRIBUTING.md`, `SECURITY.md` — commit: af2a2ad
- [x] 13. The rehearsal on a clone tagged v4.0.0 — from 3.0.0 with every answer in place, and from 1.2.0 in the synthetic form of the project upgraded next, LF and CRLF — moved here from task 14, so that the gate reviews the tip that ships; then `/fw:security-review`, adversarial, its reviewer not the author, its perimeter named: the claims about what loads, the gate's check, `state-inject.sh` and its wiring, the migration of the answers — commit: 0afcb5b, b48e2a9 (the rehearsal's fixes); ed22e6b, 5845b88, ff5985a, c0eb73f (the first round's fixes); this note's gate section
- [x] 14. The CHANGELOG's 4.0.0 entry with IMP-127's erratum and the measured first request; the rehearsal again on the CHANGELOG's commit; the gate's second round on the fixes and the entry; the retro; the checkpoint; then `/fw:integrate` up to block 0, no further (the fifth turn) — commit: 9a92d94, 88e2757 (the entry); 9615698, 0470ebd, d26e549 (the second round); 5c6f07b (the third); e82d7c2 (the retro), ba09bd7 (the checkpoint); 83b422c, 278b9bf (the CI's Windows run, the fifth round); this note's gate line

## Resumption notes
- The chat's "step 0" and "step 1" are tasks 1 and 2 here. The user's instruction: stop after
  task 2, before any task that changes the method.
- Task 2 settled task 11's file (`.claude/rules/fw-core.md`) and task 8's mechanism (a Read
  instruction, no `@`); the user confirms the latter before task 3. A measurement that cannot be
  taken is reported as such, never inferred.
- Fourteen tasks, at the edge of the healthy range: the cycle's steps are tasks 13 and 14, as
  in 3.0.0.
- The draft core and the research results live in the session's scratchpad, not durable: the
  decisions and numbers they hold are in this note.
- The fourth turn's instruction: go from task 3 on, and stop after task 11 — the core and the
  new `CLAUDE.md` — with the core's full text, its characters and tokens, and what left the
  launch context; stop earlier at a step that prepares block 0. None did: no push before task
  11, the CI's line of task 4 measured on runs already on GitHub.
- For task 14's *Upgrading* note: `fw/checkpoint.md`'s step 1 changed one blank line away
  from the paragraph setup deletes — a weak separator, a likely conflict in a project's 3-way;
  `CLAUDE.md`'s method part (rules, imports, quick commands) left in one hunk that holds rules
  5 and 8, which projects answered — a conflict by construction, resolved by edge case 8.
- IMP-124 moves to Applied at the checkpoint (task 14), with the release's commits.
- Not run here: gawk and mawk on `state-inject.sh`, the wiring's Windows path — block 0's CI
  is their first run.

## The previous merge, reconciled
- 2026-10-16: `chore/memory-3.0.0-record` integrated. Block 0 pushed `5e43676` (CI run
  38918692260); block 1 merged 31 seconds later, before the CI had a result — its wait was
  written in prose only; block 2 published `main` at `0c71b6f` (CI run 38918804679). Both runs
  green on the three platforms — 34, 34 and 33 PASS with Windows' known SKIP and NOTE; the
  documentation check 0 FAIL, 0 CHECK; the prerequisite check 0 FAIL, 0 WARN; the real hooks
  PASS. The merge's tree equals `5e43676`'s. `2026-10-15-3.0.0-record.md`'s follow-up on that
  branch's blocks is done. The timing is IMP-126's evidence (`LEARNINGS.md`).

## Security gate
- `/fw:security-review` at `278b9bf` — `0c71b6f..278b9bf` reviewed in five rounds
  (`..b48e2a9`, `..88e2757`, `..d26e549`, `..5c6f07b`, and `ba09bd7..278b9bf` on the fix of
  the CI's first Windows run), its reviewers never the author: no HIGH or CRITICAL; 3 MEDIUM
  and 29 LOW resolved, every INFO closed, declared where its claim lives, or carried to the
  retro (IMP-128 to IMP-134); the last round's one LOW closed and checked by its reviewer.
  Under the gate because the deliverable changes the method's boundary — the SessionStart
  wiring of `settings.json`, `scripts/state-inject.sh` —, the gate's own check, and the
  product's claims about what is in context. After `278b9bf` only this note changes.

### First round — `/fw:security-review`, reviewed `0c71b6f..b48e2a9`
- How: a workflow (run `wf_3f4a0f11-bd4`, 8 agents, 1,559,293 tokens, 320 tool calls, a duration
  of 35,502,785 ms as the workflow reported it), four read-only reviewers by perimeter — `state-inject.sh` and its
  wiring, the claims about what loads, the gate's check in `/fw:integrate`, the migration of
  the answers — each followed by a verifier briefed to REFUTE; none of them the author. Each
  read `docs/03` and the user's decisions in this note by path. The snapshot before and after
  was identical, `git diff` empty, HEAD `b48e2a9`.
- Result: 40 findings; the verifiers confirmed 38 and refuted 2 (claims F7: a Read past
  25,000 tokens pages with an explicit notice, measured; migration F7: the `>/dev/null` grep
  drains its input, BSD grep measured and GNU grep by the CI of `0c71b6f`). After the
  verifiers' grading: no HIGH or CRITICAL, 3 MEDIUM, 17 LOW, 18 INFO. Each confirmed one
  checked by hand against the file before its fix; the fixes shown RED on `b48e2a9`.
- MEDIUM, all resolved: gate-check M1 — a "not applicable" passed on a change to the method's
  boundary when the project's answer listed only its modules (`c0eb73f`); gate-check M2 — after
  the reviewed tip the check exempted shipped memory files and any changelog text
  (`c0eb73f`); migration F1 — `invariant` said "its answer reached" from the marker's absence,
  so of two answers on one label the second was lost under an OK (`5845b88`, RED: two OKs,
  0 FAIL, 0 CHECK).
- LOW, all resolved: state-inject SI-1 (the fallbacks unbounded), SI-2 (bytes that are not
  UTF-8 counted as 0), SI-3 (no banner on a missing file) — `ed22e6b`; claims F1 (the human's
  say on what cannot be undone, always loaded at v3.0.0, absent from the core), F2 (`docs/02`'s
  ban on details shown to the client), F4 and gate-check I3 (the core "in every delegated
  agent"), F6 (the section recipe cut at a fenced heading) — `ff5985a`; claims F8 = gate-check
  M1; gate-check M3 (the reviewed tip's source), L1 (the note's selection), L3 (an accepted
  MEDIUM where `STATE.md` is a template), L4 (free text in double quotes), L5 (`push.followTags`)
  — `c0eb73f`, L4's rule in the core `ff5985a`; migration F2 (a trailing blank read as an
  answer), F3 (a release before v1.1.0 read as nothing moved), F4 (edge case 8 decided by the
  framework's file) — `5845b88`.
- INFO: closed — state-inject SI-4 (the budget check made positive), SI-6 (docs/04: the script
  is no protected path; the rules' leading slash read in Claude Code's permissions page on
  2026-10-17, not measured), SI-7 (the cut line's numbers) — `ed22e6b`; claims F3 (granting a
  permission is a moment of the boundary's row), F5 (the command's file read again after a
  compaction), F10 (what README's numbers measured), F11 (the open slot's comment), F12 (the
  documentation check is the framework's), migration F5 (the core's end-of-task rule and the
  upgrade's checkpoint) — `ff5985a`; gate-check L2 (block 1 opens on the checked sha), I1
  (`gh -R`), I2 (block 1's local branch, "every job"), I4 (the PR form's claim) — `c0eb73f`;
  migration F6 in part (each label held to a line of HEAD's `CLAUDE.md`, `5845b88`).
  Declared — SI-5 (a NUL byte, BSD awk) in the script's header, `ed22e6b`; migration F6's
  other half: the slot lines are read at tags, which do not move, and the reviewer's probe
  found 13 of 14 at each of v1.1.0-v3.0.0. Carried over, not introduced here, to the retro as
  proposals: claims F9 (`make reset-task` at a new session's start whatever the uncommitted
  work), F13 (the core describes `-n` but forbids it nowhere), migration F8 (a slot a conflict
  resolution re-opens in a HYBRID file gets no FAIL).
- Seen by two reviewers in their own context: a workflow agent received the instructions the
  main session loaded at its launch — the old `CLAUDE.md` with its imports, no core —, not the
  files on disk. The reviews read every file they judged from disk, by path; the core and
  `SETUP.md` now say it (`ff5985a`).
- Not covered by the round, by the reviewers' own lists: Windows and Git Bash (the CI is
  their first run), gawk and busybox on the self-test, Claude Code's behaviour beyond its
  pages (the hook's cap and preview, an interactive session), the real end-to-end upgrade
  (the main session's rehearsal), and the CHANGELOG entry, not yet written.
- Second round: the fixes `b48e2a9..` and the CHANGELOG entry, once written, by a reviewer
  who is not the author — task 14, before the retro.

### Second round — `/fw:security-review`, reviewed `b48e2a9..88e2757`
- How: two independent reviewers by the Agent tool, none of them the author, each briefed with
  the user's decisions verbatim and told to read `docs/03`, the review's command and this
  note from disk — their startup context held an older core, as the first round saw —; each
  verified its own findings before reporting. Code and boundary: 240,402 tokens, 60 tool
  calls, 1,071,498 ms. Claims and the CHANGELOG entry: 274,440 tokens, 97 tool calls,
  1,358,276 ms. Snapshot before and after identical, `git diff` empty, HEAD `88e2757`.
- Result: no HIGH, CRITICAL or MEDIUM; 9 LOW, 12 INFO, each checked by hand against the file.
  Of the first round's findings the code reviewer judged SI-4, F1 and F6 partly closed (R2-2,
  code R2-1, F6's declared half) and the rest closed; the claims reviewer F2 and migration F5
  partly (claims R2-2, R2-4).
- Resolved — code: R2-1 (`invariant` found an answer in the line's own description, so
  "via Pull Request" passed with nothing carried; RED on `88e2757`, `9615698`), R2-2 (the
  positive budget check passed on the fallbacks, the banner opening every path; `0470ebd`),
  R2-4 (busybox `diff` prints no normal format: `answer_at` reads `-U0`; `9615698`), R2-5
  (block 1's rebase after the tip pin: `<base>` pinned after the fetch; `0470ebd`), R2-3 and
  R2-6 (the longest output's figure; the greenfield push and quotes; `d26e549`, `0470ebd`).
  Claims: R2-1 (the subagent's derived share at 2.85, its own runs' ratio; `d26e549`), R2-2
  (the core keeps rule 2's prohibitions, the CHANGELOG and `fw-code-quality.md` say so;
  `0470ebd`, `d26e549` — whether `docs/02`'s other "never"s join rule 2 is the user's,
  IMP-132), R2-3 (Step 6 commits the reconciliation and the pin before the review;
  `0470ebd`), R2-4 (the core in the user's terms, lint-memory proposes no reduction on an
  upgrade's branch; `0470ebd`), R2-5 (the rehearsal rerun on the tip that ships, below), R2-6
  (the boundary as the core names it), R2-7 (`LEARNINGS.md` by its diff); INFO R2-8 (an import
  measured at one invocation), R2-9, R2-10 (an agent keeps what the session last loaded, at
  launch or at a compaction), R2-11 (the erratum names the header's date), R2-12 (docs 00-04
  and 06; the Makefile's recipe), R2-13, R2-14 — `0470ebd`, `d26e549`.
- Declared: `88e2757`'s message says the Upgrading steps follow "the order the user asked
  for"; the entry puts the answers first, the order edge case 8 needs, where the user's list
  put rules 1-10 first. A local commit's message, left as it is. R2-15: the core changed after
  the user's approval — the list, each change with its finding, goes to the user with block 0.
- Not covered by the round, by the reviewers' own lists: gawk and Git Bash (the CI), the unit
  of the hook's 10,000 cap (Claude Code's page says characters; the outputs reach 8,386
  UTF-16 units, up to 14,211 bytes for astral text), `git push --no-follow-tags` with an
  explicit tag and `gh -R` against `GH_REPO` (read, not run), an interactive session.

### The rehearsal again, on `d26e549` (task 14)
- A from 3.0.0 and B from 1.2.0 rebuilt from scratch by the task 13 builder, Step 3 driven by
  the inventory; the files Step 3 leaves to a human taken from the first rehearsal where `vY`
  did not change them since (`CLAUDE.md`, `STATE.md`, B's `Makefile`, `reset-task.sh`,
  `LEARNINGS.md`), reconciled again where it did.
- A: preflight 0 FAIL; every hybrid 3-way clean — `fw/checkpoint.md`, `fw/integrate.md` with
  its placeholders, `settings.json`, `Makefile`, `hooks-install.sh`; `inventory` quotes 13
  answers, the 4.0.0 Upgrading note printed; `invariant` 0 FAIL, 1 CHECK (the stack's read-only
  commands, which belong in `settings.json`), every other answer found word for word; `post`
  0 FAIL, 3 CHECK; `make test-scripts` 13 PASS; `CLAUDE.md`'s 3-way 150 of 159 lines.
- B: the pin without its `v` fails preflight, corrected by a commit, then 0 FAIL; renames 0
  conflicts but two co-edits at a command's end, both sides kept; docs/00 2 conflicts, edge
  case 7, resolved as in task 13 (vY's, its answer in **Sensitive components**); `invariant`
  0 FAIL, 2 CHECK — **Branches** holds "main only, trunk-based" for "main, trunk-based", and
  **Merge** "the /fw:integrate block" for "the /integrate block": confirmed by hand, the
  re-phrasing of the carrying —; `post` 0 FAIL, 9 CHECK; 13 PASS; the hook prints 8,211
  characters, the open issues first; `CLAUDE.md`'s 3-way 168 of 177.
- CRLF: copies of both, every text file with CRLF — the same verdicts as LF in `inventory`,
  `invariant` and `post`.
- Not rehearsed: a project that replaced `fw/integrate.md`'s placeholders throughout (the
  Upgrading note says what to expect), Windows.

### Third round — `/fw:security-review`, reviewed `88e2757..d26e549`
- One independent reviewer, not the author, briefed as the second round's (220,265 tokens, 69
  tool calls, 1,010,931 ms); snapshot identical, `git diff` empty, HEAD `d26e549`.
- Result: no HIGH, CRITICAL or MEDIUM; 1 LOW, 1 LOW/INFO, 5 INFO, checked by hand. Of the
  second round's findings it judged code R2-5 and claims R2-5, R2-7 partly closed, the rest
  closed; it recomputed every figure of the entry (1,029 = 16,330 − 15,301; 35,400, 7,800,
  33,600, 6,500, 370) and found them exact, the longest hook output 8,354 + 2 × the digits of
  the cut line's numbers.
- Resolved in `5c6f07b`: F1 (LOW: block 1's base pin blind to a base already stale when
  `/fw:integrate` runs — under the gate the computation requires the base to be an ancestor of
  the reviewed tip, or stops for a rebase and a new review); F3 (`LEARNINGS.md`'s `updated:`
  date no shipped change); F5 (where the boundary is named); F6 (a command's import measured at
  one invocation, in `lint-memory` and the docs check); F7 (an Explore or a Plan agent skips
  the rules with no `paths`). Declared: F4, a description the project re-worded is searched
  whole by `invariant`, in the code and in `SETUP.md`. F2 (LOW/INFO: the rehearsal on the tip
  that ships recorded nowhere) — the rehearsal sections here.

### The rehearsal on `5c6f07b`
- The same as on `d26e549`, rebuilt from scratch: A preflight 0 FAIL, every hybrid clean,
  `invariant` 0 FAIL / 1 CHECK, `post` 0 FAIL / 3 CHECK, 13 PASS, 13 answers quoted; B
  preflight 0 FAIL / 1 CHECK (`grafted: n/d`), `invariant` 0 FAIL / 2 CHECK — the two
  re-phrased answers above —, `post` 0 FAIL / 9 CHECK, 13 PASS, 12 answers; `CLAUDE.md`'s 3-way
  150 of 159 and 168 of 177; with CRLF, the same verdicts in `inventory`, `invariant` and
  `post` for both.

### Fourth round — `/fw:security-review`, reviewed `d26e549..5c6f07b`
- One reviewer, not the author (140,371 tokens, 38 tool calls, 781,002 ms); snapshot
  identical, `git diff` empty, HEAD `5c6f07b`.
- Result: no HIGH, CRITICAL, MEDIUM or LOW; the third round's F1 and F3-F7 closed; 4 INFO,
  checked by hand. I1 — the stale-base stop is written in step 4's computation only, not in
  step 5's list, `docs/03`'s list or the CHANGELOG: an under-claim, the check doing more than
  the texts say, left as it is. I2 — that stop fires after step 3 has committed the
  changelog's move: it fails loudly, the new review reading the entry; IMP-133. I3 —
  `CONTRIBUTING.md`'s memory-only rule counts `LEARNINGS.md`'s `updated:` date as payload,
  which `integrate.md` now sets aside; `CONTRIBUTING.md` ships to no project, but the check's
  letter counts every path outside `.claude/memory/`, so it changes on a later branch;
  IMP-134. I4 — here a rebased feature branch has no push path after block 0 (carried over):
  the user's decision, IMP-134.
- The reviewed tip was `5c6f07b`, block 0 pushed `ba09bd7` (2026-10-17, the user's terminal).

### The CI's first run, and the fifth round — `ba09bd7..278b9bf`
- CI run 39035256707 on `ba09bd7`: `ubuntu-24.04` and `macos-26` green, `windows-2025` red at
  `make test-scripts` — the one-by-one step: `scripts/test-state-inject.sh` alone,
  `FAIL (state inject): CRLF: the test's file has no CR (the case would prove nothing)`; the
  other six self-tests, the upgrade check's self-test, the prerequisite check and the real
  hooks green there; the documentation check 0 FAIL, 1 CHECK (4.0.0 untagged). The cause: the
  check used `grep $'\r$'`, which Git Bash's grep does not see — v1.5.0's lesson, recorded in
  its note and `tools/test-upgrade-check.sh`, not applied to a test written since. Cases 5-9
  had never run on Windows.
- The user's decision (translated): the CR counted by Node; cases 5-9 read again for Git
  Bash's known traps and fixed in the same commit; every `grep $'\r'` of the repository's
  code reported before a fix. The grep found one, the test's own — none in shipped code.
- `83b422c`: the CR counted by Node, with a control; the unreadable case's skip a declared
  SKIP (chmod takes no read permission away there); case 7's PATH of `ln -s` links — which on
  Git Bash copy a binary away from its DLLs (`scripts/test-agent-git-guard.sh`) — replaced by
  an awk stub that exits 127, first on the PATH. Case 8's `cygpath -w` form, the wiring's
  `head -c` and case 9 hold no such trap, by reading. GREEN here on BSD awk, mawk and as root.
- The round: one independent reviewer, not the author (146,163 tokens, 40 tool calls,
  584,631 ms; then 6 calls, 62,764 ms for the fix), no confirmation asked: 1 LOW — the PASS
  line named the unreadable case where it was skipped — and 2 INFO — a comment saying the
  opposite, case 7 holding less than before. `278b9bf`: the PASS line says what ran, the
  README where the case is skipped, the comment reworded; case 7's narrower hold declared in
  the header. The reviewer checked the fix: closed, closed, declared, no new defect. Snapshot
  identical, `git diff` empty, both times.
- Not covered: nothing ran on Git Bash here — the CI on the next push is the first run of
  cases 5-9 on Windows.

## Problems encountered → cause → solution
1. The first draft of the core dropped rules — the definition of a sensitive component, the
   resumption protocol, the Definition of Done for tasks with no code — and its "STATE.md not
   injected" row would have fired in every delegated agent → it compressed the docs instead of
   listing their norms → two reviewers mapped every normative statement to its new home
   (126 rules); the draft was rewritten from the map.
2. The first cumulative numbers counted transcript entries → an assistant entry per content
   block, each repeating its request's usage → deduplication by request.
3. "A Read stops at 2,000 lines" → wrong for this version → `tools-reference.md:516`: 25,000
   tokens per call, a partial view past it.
4. A `cd` into a subdirectory in a Bash call moved the session's primary working directory
   (the runtime's environment update said so) → a shell `cd` moves it → back at the root in the
   next call; whether the project's settings reload on such a move is not stated. Evidence for
   IMP-104.
5. Task 12's first commit went in with the suite red: the chain ran `make test-scripts` and
   the commit with `;` between them, so the commit did not depend on the suite → a case of
   the docs check's own self-test edited a line task 12 had reworded → the case fixed, the
   suite green, the commit amended before anything left the machine (`af2a2ad`); every later
   commit chained with `&&`.
6. The rehearsal's first fake secret passed the pre-commit → it was AWS's documented example
   key, which gitleaks leaves alone on purpose → a token generated at run time, refused; the
   throwaway commit undone in the scratch project.
7. A commit body's wrapped line opened with `root:` → commitlint read a footer there and
   only warned, the core's commit rule broken → the message rewrapped and amended before
   anything left the machine (`ed22e6b`), the suite run again in the same chain.
8. The Edit tool turned the `\u00XX` escapes of a test's JavaScript into the characters
   themselves, a C1 control among them → the documentation check failed on the guillemets →
   the bytes written as numbers, every edited file checked for control characters.

## Factual doc corrections (Level 1, docs/06)
- None applied. Suspected at task 1, from the review's reasoning: the signal "a session that
  opens without `STATE.md` injected did not load the settings" (`CLAUDE.md`, `docs/04`,
  `SETUP.md`) could not fire, an ancestor `CLAUDE.md` bringing the import into a subdirectory
  session. Task 2's measurement does not confirm it: there the ancestor's import of a file
  outside the subdirectory is external and was not loaded (`claude -p`; `memory.md:133`); an
  interactive session's approval of external imports was not measured. No correction is due.
- IMP-124 counts "1,347 lines" of docs; the seven files hold 1,313 at `0c71b6f`.
- Task 6's "the longest output its rules allow, 8,289 characters" (*Measured along the
  tasks*) measured a cut from `## Progress`; a cut from a section titled past 80 characters
  gave 8,361 with that script and 8,380 with the gate's fixes (2026-10-17) — the figure the
  CHANGELOG states. Still under the self-test's 9,000. The second round measured 8,382 on the
  self-test's own case and 8,386 on a 3 MB file — the cut line's numbers gain digits —: the
  CHANGELOG says under 8,400, 8,386 the largest measured.
- *Measured before task 12*: "≈6.6k in a subagent" applies 2.8 to the subagent's 18,661
  characters (6,665); the subagent's own runs imply 2.85, which gives about 6,500 — and
  33,600 before, 35,400 and 7,800 in the main session at its 2.80. The CHANGELOG states each
  at its own ratio (the gate's second round, R2-1 of the claims).

## Task 2 — the measurements
A scratch project outside the repository (a git repository with a `CLAUDE.md` importing a
file, a rule without `paths`, a rule scoped to `src/**/*.py` that `@`-imports a file, a rule
scoped to `gen/**`, a SessionStart hook printing its source), each file carrying a unique
marker. Five `claude -p` runs on Haiku 5.5 (the context's composition does not depend on the
model), read back from their transcripts' request records — what each API request carried,
not what the model said.

| Question | Result |
|---|---|
| D1 (b): a rule without `paths` in a general-purpose subagent's first request | **present**, with `CLAUDE.md` and its import; no SessionStart output there |
| D1 (a): the same rule after a compaction | **present** — after a manual `/compact` and a resume (runs 2-3), and after an automatic compaction inside one process (run 5: `CLAUDE_CODE_AUTO_COMPACT_WINDOW=100000`, `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50`; 51,067 tokens compacted to 5,042), re-injected with `CLAUDE.md`. The page says so too: "Project-root CLAUDE.md and unscoped rules — Re-injected from disk" (`context-window.md:1599`) |
| A session started in a subdirectory of the repository | the root's rule without `paths` **present**, the ancestor `CLAUDE.md` present, its `@`-import of a file outside the subdirectory **absent** (an external import, not approved in `-p`), the project's SessionStart hook **not run** |
| D4: an `@`-import inside a path-scoped rule | **loaded at launch**, in the main session and in the subagent, before the rule itself, and again after each compaction: such an import costs what a `CLAUDE.md` import costs |
| A path-scoped rule | loaded with the first matching Read, once for two Reads in the same turn (a later, separate Read was not measured); after a Write of a new file it arrives in the next request, so the first write goes without it; after a compaction it reloads on demand, or comes back with the files re-read |
| The SessionStart hook | run at `startup`, `resume` and `compact` (manual and automatic); after a resume followed by a compaction both outputs sat in the rebuilt context |

What follows for the plan: D1's conditions hold, the core goes to `.claude/rules/fw-core.md`,
and it reaches a subdirectory session too, where its missing-banner check is the one that
fires. D4's rule cannot `@`-import `docs/02`: it tells Claude to Read it, and the core's table
keeps the moment for the first write. Not measured, outside the five runs or no longer needed:
an `@` attachment repeated by a second invocation, a backticked `@` in a command's body (the
plan removes `@` from the bodies), a colon in a skill's `name` (D2 keeps commands), a separate
second Read of a matching file, an interactive session's approval of external imports.

Cost of the five runs, at list price: $0.0493 — input 33,624, output 11,480, cache read 482,972,
cache write 198,631 tokens, all Haiku 5.5. The transcripts stay where Claude Code keeps them.

## The fourth turn — the user's answers (translated from Italian)
- D4's mechanism confirmed — a rule that has `docs/02` Read, no `@` — with two conditions:
  "(1) 02's prohibitions (exceptions never swallowed, validation at the edge, the why in the
  comments, the Definition of Done) stand in the core, not only in 02: a prohibition does not
  move to an on-demand load. (2) If the rule uses `paths:`, the globs of the code files depend
  on the stack: either they are a [TO BE DEFINED AT SETUP] slot, or the rule stays without
  `paths`. No concrete globs in the framework." The docs-check ban on `@` in a method rule:
  approved.
- D5(b) extended: `/fw:lint-memory` also flags a `STATE.md` without *Caution & open issues*.
  "(1) The hook must not truncate in silence: if the section is missing, it says so in one
  line; if STATE exceeds the budget, it prints the Caution first, then a line with how many
  characters it cut and the instruction to read the file. (2) A test checks that the hook's
  whole output, budget plus headers, stays under 10,000 characters with a margin. If 8,000
  leaves no margin, lower it and tell me."
- "Go for task 3 and the following ones. Stop after the task that writes the core
  (`fw-core.md` and the new `CLAUDE.md`)" — with the core's full text, its characters and
  tokens, and what left the launch context and where it is now. "If you reach the step that
  prepares block 0 before that point, stop there."

## Measured along the tasks
- Task 4: the CI's line of block 1, read-only, in bash and zsh — `completed/success` on
  `feff389`; `completed/failure` on `7d2052b` refused; a commit never pushed gives `/`, refused;
  an unknown workflow an HTTP 404, refused. A run in progress not measured.
- Task 6: `state-inject.sh` on the template prints 1,580 characters (the raw file, comments
  included, 3,266). The longest output its rules allow — no *Caution* section and a cut, both
  notices — measured at 8,289 characters: 1,711 under the hook's cap, so the budget stays at
  8,000. On a 81,440-character file of accented and astral text it printed 6,927 — the cut is
  taken in bytes, so multibyte text shows less than the budget, never more. Two mutants of the
  script killed by its self-test: the budget raised to 9,500 (9,679 printed, over the test's
  9,000) and the open issues no longer first. macOS's `iconv` rejected a valid output (Python
  and Node.js decode it): the test decodes with Node.js's strict decoder, with a control.
  gawk and mawk, the CI's awks on Linux and Windows, not run here: block 0's CI is their first
  run, the Windows form of the project's path in the wiring's case included.
- Task 7: the eleven slots of `docs/02`-`04` and the two of `CLAUDE.md`'s rules 5 and 8 hold
  the same line, byte for byte, at v1.2.0, v2.0.0 and v3.0.0 — rule 8's aside, which named
  `/security-review` before v3.0.0: `upgrade-check`'s table carries both forms. They became
  nine lines of `CLAUDE.md`, *The answers the method reads* (the two branch slots one line,
  the two documentation slots one line, the two sensitive-components slots one line); the
  read-only commands of the stack belong in `settings.json`'s `allow`, so that slot left the
  doc with no marked line. The self-test's new case 12, red with the table emptied (its first
  `edge case 8` line missing), green with it.
- Task 8: D4's condition (2) — no concrete glob of code files in the framework — taken as a
  slot: `fw-code-quality.md`'s `paths` holds the setup marker, quoted, until a project answers
  it. Claude Code reads a `[` as the start of a bracket expression (`memory.md`), so the open
  slot matches only a one-letter file at the root: the rule does not load, and the core's
  table sends Claude to `docs/02` alone. The rule is HYBRID; `fw-boundary.md`, on four of the
  framework's own files, METHOD. The docs check's new family: no `@`-import in a method rule
  outside code spans, each concrete glob matching a tracked file — its self-test's case 11
  plants both defects.
- Task 9: no command carries an `@` any more; each reads its doc at its first step — by
  section for `docs/04`, `docs/00` and `docs/06`'s bridge, whole for `docs/03`, `05` and
  `06` at a retro — and again after a compaction. The `fw:` lines of the skill listing went
  from 850 characters to 1,591 (≈0.3k → ≈0.6k tokens, in every session): nine commands, each
  description with its trigger; `/fw:new-component` left the listing
  (`disable-model-invocation`, "Description not in context", `skills.md:590`). The docs
  check's family widened to the commands: no `@` in a method command, and a frontmatter of
  `description`, `argument-hint` and — on `/fw:new-component` only —
  `disable-model-invocation`. Its own floor of `@`-imports fell from 15 to the 8 `CLAUDE.md`
  still holds; task 11 removes those. `/fw:lint-memory` gained checks 12 (STATE's budget and
  its *Caution* title) and 13 (the rules' globs, the imports and their cost).
- Task 11: the core, `.claude/rules/fw-core.md`, 15,301 characters in 168 lines — the draft v3
  of task 1 (rebuilt from the reviewers' map of 126 rules) without its technical rules, plus
  `docs/02`'s prohibitions spelled out (D4's condition 1), the banner's 8,000 characters and
  its cut line, the boundary's and the rollback's rows, `docs/03` and `docs/05` reachable from
  the table; a sentence-level diff against the draft found one qualifier dropped (a review
  through `git diff`), restored. `CLAUDE.md`, the project's: 3,360 characters (its title and
  stack lines unchanged, projects answered them). The payload holds 0 `@`-imports. The docs
  check reads the slash commands, the `make` targets and the docs' index from the core, and
  in the core and the rules every pointer to `docs/04` must name a section the doc has.
- The framework at every session start, estimated (÷2.8, band 2.6-2.9), not measured with
  `/context`: core 15,301 + `CLAUDE.md` 3,360 + the template's `STATE.md` through the hook
  1,660 + the `fw:` lines of the skill listing 1,591 = 21,912 characters ≈ 7.8k tokens,
  against ≈99,200 ≈ 35.0k before (−78%). Every delegated agent: core + `CLAUDE.md`, 18,661
  ≈ 6.7k, against 33.7k (−80%). The draft's 6.4k grew with the answers' nine lines, the
  `CLAUDE.md` template's examples and the core's additions above.

## The fifth turn — the user's answers (translated from Italian)
- "Review of the core: approved." Approved too: the two guards and the tree's check in block 1,
  the triggers in the descriptions (+265 tokens, `/fw:new-component` out of the listing),
  `CLAUDE.md` HYBRID with its title and stack lines unchanged.
- Two measurements before task 12, at most three `claude -p` runs, their cost reported: (1)
  "the slot in fw-code-quality.md's paths does not load because of a side effect of the glob,
  and that is inferred, not measured" — with the marker open the rule must not load when Claude
  reads a code file and the frontmatter must give no warning, with a compiled glob it must
  load; a warning or another behaviour, and a form that depends on nothing undocumented is
  chosen; (2) "the −78% is a ÷2.8 estimate and will end up in the CHANGELOG: for the DoD (point
  10) it needs the measurement" — the tokens written to the cache at the first request, as the
  61,459 of the day before, for the main session and for a general-purpose subagent; "the
  CHANGELOG carries the measured numbers".
- Then tasks 12-14 and the cycle. "The gate applies: the deliverable touches the boundary
  (guard, hook, settings, state-inject.sh), with a reviewer other than the author." The
  *Upgrading* note gives the projects the concrete steps of the expected conflict on
  `CLAUDE.md`: rules 1-10 leave because they are in the core, the answers go to *The answers
  the method reads*, `STATE.md`'s titles take the method's form, a `STATE.md` over the budget is
  condensed by the first `/fw:checkpoint` after the upgrade, never by the upgrade itself. "Stop
  when /fw:integrate has printed block 0: not further."

## Measured before task 12 — three `claude -p` runs
Three scratch clones of this repository, each run read back from its transcript's request
records and usage (deduplicated by request): A, this branch at `9b9175f`, the slot open; B,
`main` at `0c71b6f` (v3.0.0 and its record); C, this branch with `fw-code-quality.md`'s
`paths` compiled to `scripts/**/*.sh`. A and B on Opus 5.5 — the main session's model —, the
same prompt: Read `scripts/repo-snapshot.sh`, then one general-purpose subagent replying with
one word.

| First request | v3.0.0 (B) | This branch (A) | Difference |
|---|---:|---:|---:|
| Main session: input tokens in all (cache write + cache read + uncached) | 57,932 (47,211 + 10,719 + 2) | 30,373 (19,652 + 10,719 + 2) | −27,559 (−48%) |
| General-purpose subagent, idem | 54,264 (46,726 + 7,536 + 2) | 27,256 (27,254 + 0 + 2) | −27,008 (−50%) |

- The 10,719 tokens both main sessions read from the cache are the common prefix — the
  system prompt and the tools, identical in A and B —; the rest differs only by the
  framework's files, so the differences are the framework's alone. The subagent's 7,536 read in
  B and 0 in A are a cache effect (B's subagent found part of its prefix written by A's), not
  content: the totals are the comparable figures.
- The ratio this measurement gives: about 77,300 fewer characters at launch (≈99,200 →
  21,912) for 27,559 fewer tokens — 2.80 characters per token in the main session; 76,991
  characters (95,652 → 18,661) for 27,008 tokens in the subagent, 2.85. The ÷2.8 of the
  estimates holds; the framework's own part at launch, derived with it, is ≈7.8k tokens in the
  main session and ≈6.6k in a subagent, against ≈35k and ≈33.6k. Derived, not measured: no
  run without the framework.
- The 61,459 of 2026-10-16 (this session's first request, 61,459 written + 26,826 read) also
  held the user's long first message: not comparable with A and B.
- The slot: in A, after the Read of a code file, no request carried `fw-code-quality.md`; in
  C, the request after the same Read carried it, as a `nested_memory` attachment. Neither
  debug log (`--debug-file`, 359 lines in A) nor stderr held a warning on a rule, a glob or a
  frontmatter — stderr held only the untrusted workspace's notice that the `allow` rules were
  ignored. The open slot's non-match rests on the bracket expression Claude Code's memory page
  documents ("Glob syntax treats `[` as the start of a bracket expression"): the form stays. A
  one-letter file at the root would match it; not measured.
- Also seen in A and C: the new SessionStart wiring ran under Claude Code itself
  (`hook_success`, the banner, *Caution & open issues* first), and the core was in the main
  session's and the subagent's first request.
- Cost, at list price: $1.0786 — A $0.3787 and B $0.6938 on Opus 5.5, C $0.0061 on Haiku 5.5;
  input 18, output 1,326, cache read 202,333, cache write 182,775 tokens.

## Task 13 — the rehearsal (3.0.0 → 4.0.0, and 1.2.0 → 4.0.0)
- The fixture, synthetic, in the session's scratchpad (`rh4.*`): the framework cloned at the
  branch's tip and tagged v4.0.0 in the clone only — moved once, onto `0afcb5b`, after the
  first fix. Project A: a graft at v3.0.0 with every answer — `CLAUDE.md`'s title, stack,
  rules 5 and 8 and its technical rules; `docs/02`'s five slots, `docs/03`'s, `docs/04`'s five;
  the three setup commands; the `Makefile`; the formatting slot; `.gitignore`;
  `decisions/README.md`; the allow list —, a `STATE.md` of 10,506 characters with the method's
  titles, its hooks at v3.0.0; LF, and cloned again with `core.autocrlf` true. Project B: a
  graft at v1.2.0 in the form of the project upgraded next, none of its names or contents —
  the pin `version: 1.2.0` without its v, `grafted: n/d (retrofit …)`; trunk-based on `main`
  with a dormant `dev` protected in `reset-task.sh`; `CLAUDE.md` with forty technical rules;
  `docs/00` answered inline and its closing mention rewritten; `docs/02` and `03` inline,
  `docs/04` four slots of five; four commands customised, three as shipped; formatting
  "none"; no `.gitattributes`; a `STATE.md` of 56,928 bytes with the pre-English titles and a
  *Caution* of two entries of about 17,500 characters each; LF, and cloned again with
  `core.autocrlf` true.
- The procedure as `SETUP.md` writes it, with the tag's `upgrade-check.sh`; the mechanical part
  of Step 3 (METHOD and TEMPLATE files brought from the tag, HYBRID ones merged 3-way) by a
  scratch script that follows the inventory's table; every answer, conflict and title by hand,
  with the file tools.
- A: preflight 0 FAIL. The inventory named the thirteen answers v4.0.0 moved, each with its
  new line, and no edge case 7. `CLAUDE.md`'s 3-way: 2 conflicts, 150 of 159 lines — rebuilt
  from v4.0.0 and the project's text re-applied, as Step 3 says of a file mostly in conflict.
  Every other hybrid merged clean, `fw/checkpoint.md` included (its step 1 one blank line from
  the setup paragraph the project had deleted: no conflict). The answer of `docs/04`'s last
  slot went to `settings.json`'s `allow`. `invariant` 0 FAIL — the thirteen answers in their
  lines, one CHECK for the `allow` answer —, `post` 0 FAIL. `STATE.md` untouched; its hook
  printed *Caution* first and the cut line (2,300 of 10,298 characters not shown).
- B: preflight's FAIL on the pin, the correction as the branch's first commit, then 0 FAIL.
  The inventory named the eight renames — five customised, merged into `fw/`, two of them with
  one conflict each where the project's last line met the release's last change, both kept —,
  edge case 7 on `docs/00` (`vY`'s taken) and on `reset-task.sh`, whose protected branches
  went to the `Makefile` first (`make -n reset-task YES=1` prints `main dev`), and twelve moved
  answers. `CLAUDE.md`: 2 conflicts, 168 of 177 lines — rebuilt, its forty rules kept byte for
  byte, its `/integrate` answer written as `/fw:integrate`. `LEARNINGS.md`'s header and format
  comment merged by `SETUP.md`'s blocks, 0 conflicts. `STATE.md`'s six titles renamed,
  nothing else: `invariant` says so; the hook printed 8,192 characters, *Caution* first, the
  cut line naming 48,434 characters not shown. Step 4's grep found five slots — the
  `Makefile`'s comment, the new globs, a `new-component` slot and `integrate`'s step 1 line
  added after v1.2.0, `checkpoint`'s setup paragraph of v3.0.0 — answered. `invariant` 0
  FAIL (one CHECK, the restore point's pin in its old form), `post` 0 FAIL.
- Both: `make test-scripts` 13 PASS, a generated token refused by the pre-commit, a message
  without a type refused; in B the old hooks kept as `.bak`.
- CRLF: A's `.gitattributes` (v3.0.0) holds the framework's files to LF, so its Windows
  checkout reads LF and its inventory is A's own. B's checkout carried CRLF: Step 3's
  line-end step refused before `.gitattributes`, then took the framework's paths to LF and
  left the project's own file CRLF; the inventory equal to LF's but for `.gitattributes`
  itself, `invariant` and `post` equal, 13 PASS.
- Two defects, each fixed: `test-state-inject.sh`'s first case read the project's own
  `STATE.md` as the template and failed in A — IMP-125's class —, red with the shipped test,
  green with one that builds its template (`0afcb5b`); the inventory said "renamed in v4.0.0"
  of the commands v3.0.0 renamed — now "renamed between vX and vY".

## Proposals
- At task 1: none new — IMP-124's Level 2 decided, IMP-126 widened by the user's decision.
- The retro (task 14), in `LEARNINGS.md`: IMP-128 (a new session discards only the plan's
  half-task), IMP-129 (the core forbids `-n`), IMP-130 (a slot re-opened in a HYBRID file
  fails `invariant`), IMP-131 (a check passes on a datum, never on a missing alarm), IMP-132
  (`docs/02`'s other prohibitions: the user decides whether they join rule 2), IMP-133 (the
  stale-base stop before step 3's changelog commit), IMP-134 (this repository's
  `CONTRIBUTING.md`: the `updated:` date, and a rebased branch after block 0); new evidence on
  IMP-125 and IMP-105. IMP-124 and IMP-127 applied.

## Follow-up
- Stop after task 2 (the user's instruction): the user confirms D4's mechanism — a Read
  instruction in the rule, since an `@` there loads at every launch — before task 3. Done:
  confirmed in the fourth turn.
- For the user with block 0, before it runs: the core changed after the user's approval of
  its text ("Revisione del nucleo: approvato") — `git diff 9b9175f..5c6f07b --
  .claude/rules/fw-core.md`, each change tied to a finding in *Security gate*; the decisions
  of IMP-132 and IMP-134 (I4); the open IMPs of the retro.
- Block 0 was printed and run by the user (`ba09bd7`); the CI's first Windows run failed in
  the STATE injection's self-test, fixed in `83b422c` and `278b9bf`, reviewed. The user
  approved the core's changes after its approval, and deferred IMP-132 and IMP-134 to a
  cleanup deliverable. Block 0's second round pushes this note's commit; then the CI, and,
  green on the three systems, blocks 1 and 2.
- After the integration (the user's instruction, translated): the v4.0.0 record on its own
  memory-only branch, as for 3.0.0, with the Architect's comment on IMP-132 and the next
  deliverable — a cleanup: every open IMP and every finding of v4.0.0's gate decided before
  the upgrade of the first derived project — in the record's note and in `LEARNINGS.md`, not in
  `STATE.md`, a clean template here.
