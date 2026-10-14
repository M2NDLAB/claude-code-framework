---
date: 2026-10-13
task: v2.2.0 — the retro over the backlog, decided and applied — the recovery block given only after a failed check, a LOW finding declared as a limit, a backlog small enough to grow only from the projects' real use
branch: feat/backlog-retro-2.2.0
status: completed
model: 'claude-opus-5-5'
turns: 5
tags: [session, retro, imp, plan, security-gate]
---
# Session 2026-10-13 — v2.2.0: the retro over the backlog

> A dedicated branch from `main` at `00f8349` (v2.1.0, its tag signed). Probes only in the
> session's scratchpad. Hybrid regime: no `plans/`, this note is the plan-pointer. The retro's
> phase 1, read-only on `main`, the same day; then the user's decisions.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 5` — the user's report of v2.1.0's integration, with the brief of the retro; the
  user's decisions on the retro; the user's decisions of 2026-10-14, after the first push;
  the user's check of the citation, with the CI step approved; the decision on H1's
  compensation, with IMP-104.

## The brief — persisted so a /clear does not lose it
- v2.1.0 integrated and published by the user (`00f8349`, the tag v2.1.0 signed, the branch
  deleted locally and on GitHub); this repository's hooks regenerated with
  `make hooks-install`.
- An incident at that integration, for the first commit of the next release: the recovery
  block (`git tag -d v2.1.0`, "only if …") was printed with blocks 1 and 2, and the user ran it
  after an integration that had succeeded. The local tag was deleted and recovered with
  `git fetch` — no damage, a ruleset protects the remote tag. A condition written above a
  copyable block does not work as a condition. Checked here: `/integrate` printed that block
  only "if (and ONLY if)" the tag existed and its check had failed; the tag was free when the
  blocks were printed, so the agent printed it against the command's text, following its own
  v2.0.0 precedent — IMP-102.
- Phase 7 of the cycle, the retro over the backlog — phase 1, analysis only, no write in the
  repository, no branch, the aim to DECIDE: every OPEN or deferred IMP of `LEARNINGS.md`,
  the oldest included, with its number, title, priority, date and trigger; for each, one of
  four outcomes with a one-line reason — APPLY (an observed defect, a proportionate cost),
  REJECT (overtaken, covered by something else, or costing more than it gives), DEFER (on a
  VERIFIABLE trigger, an observable event), MERGE (a duplicate or the same family).
- The context of the evaluations: at the end of the cycle the repository becomes private and
  for personal use (IMP-086); after this cycle the framework develops only from the lessons
  the projects' real use brings, through `/harvest-framework`, so the backlog that remains is
  small and motivated; v2.1.0's two lenses — *Claims*, 14 findings nearly all LOW; *The real
  path*, 9, the only HIGH among them.
- Deliver the table, the totals by outcome, the minimum number of releases for the APPLY set
  with the EXPECTED bump, and apart the entries that touch the two projects using the
  framework and are worth having before their upgrades (phases 9 and 10); then STOP.

## The retro — phase 1 (read-only, on `main` at `00f8349`)
- The inventory: 38 OPEN entries (IMP-048 to IMP-101), 6 deferred, no open part left inside
  the Applied ones (searched), and the new IMP-102: 45.
- APPLY (19): IMP-051, 052, 053, 057, 060, 061, 074, 075, 078, 082, 083, 085, 086, 088, 091,
  092, 094, 099, 102. MERGE (9): IMP-063 into 060, 064 into 067, 065 into 075, 079 into 083,
  093 into 092, and 096, 097, 098, 101 into 095, the hooks' group. DEFER (10): IMP-026,
  037 (option a), 045, 062, 067, 077, 089, 090, 095, 100. REJECT (7): IMP-023, 027, 042, 048,
  072, 080, 081. Each outcome, with its reason and trigger, is in `LEARNINGS.md`.
- One release, v2.2.0, a MINOR expected: new rules enter the payload; the generated hooks do
  not change, so a project's upgrade regenerates them once; two HYBRID files change,
  `integrate.md` and `checkpoint.md`. IMP-086 is not a release: it is applied at the switch.
- The lenses' data, used: *The real path* gave the only HIGH (H1, IMP-090) and two of the
  four MEDIUMs (M2, IMP-092; M3, IMP-093) — there the decisions are the most careful: IMP-090
  deferred on a trigger the user verified, IMP-092 and IMP-093 declared, no new mechanism.
  *Claims* gave the other two MEDIUMs (M1, IMP-091; M4, IMP-094), both applied, and 12 LOW.
  Of the 11 IMPs v2.1.0's review opened, 6 came from LOW findings — the datum behind IMP-103.

## The decisions (the user's, 2026-10-13)
- The retro approved, the outcomes as proposed: 19 APPLY, 9 MERGE, 10 DEFER, 7 REJECT.
- No cut: IMP-083, IMP-082 and IMP-088 stay in v2.2.0.
- IMP-099 does not wait for the decision on the CI's matrix: the check declares as verified
  the platforms the CI's workflow LISTS, read from there — one place — instead of written by
  hand, so it stays true whatever IMP-086 decides.
- The proposal on LOW findings adopted now, in `docs/03`: a LOW finding that a line of text
  does not close becomes a limit declared where its claim lives, not an IMP — IMP-103, on the
  datum above.
- IMP-102's fix is STRUCTURAL, not only textual: in its normal sequence `/integrate` does not
  print the recovery block; it produces it only when the user reports a failed check.
  `docs/04`'s rule 3 of the blocks is aligned.
- What the user verified on the two projects using the framework (it updates triggers only):
  git-lfs absent from both; Claude Code run non-interactively in neither; one has no deploy,
  the other builds its services' container images with the repository's root as the build
  context, copying specific paths — IMP-085's check at its upgrade; an IDE's integrated
  terminal to be confirmed, the user pushes from macOS's Terminal.
- v2.2.0, the bump EXPECTED a MINOR, computed again on the content at `/integrate`. The first
  commit records IMP-102 and the retro's outcomes in `LEARNINGS.md` — the rejected and the
  merged closed with their reason, the deferred with a verifiable trigger — and what the user
  verified. Then the usual flow: a dedicated branch; block 0, the CI green on the three
  systems on every pushed state; the upgrade of the HYBRID files rehearsed with LF and CRLF;
  ONE reviewer with the two lenses; `/checkpoint`; blocks 1 and 2 WITHOUT a recovery block in
  advance.

## The decisions (the user's, 2026-10-14, after the first push)
- IMP-099, the first design: the workflow does not reach the projects, so the user's earlier
  instruction — read the platforms from the workflow — could not hold there; the check
  carries the CI's list in one line, and the documentation check fails when that line
  differs from the workflow's matrix. On Windows the check names the CI's image without
  declaring a match.
- The guard's comments now, with task 8: the user approves an edit to
  `scripts/agent-git-guard.mjs` only if its diff touches comments alone; a change of code is
  asked first.
- The statement written in task 6, "outside managed settings, a mod can approve what a deny
  rule refuses", reported precisely — the mechanism and its exact name, the page of Claude
  Code's documentation that says it, the exact text written and where —: a security
  statement, held to the *Claims* lens.
- Then the usual flow: block 0, ONE reviewer, the upgrade rehearsed, `/checkpoint`,
  `/integrate`.

## Plan (one commit per IMP applied)
- [x] 1. The retro's registrations — the 45 outcomes in `LEARNINGS.md`, IMP-102 and IMP-103, what the user verified on the two projects — and this note with its plan — commit: 5ddaa56
- [x] 2. `/integrate` and the cycle's close: apply IMP-102 (the recovery block produced only after a failed check is reported; `docs/04`'s rule 3), IMP-074 (the bump computed on the content), IMP-051 (the reconciliation after a merge is the next deliverable's first step) — commit: 2d82446, a25e17e, 8c58dc0
- [x] 3. Resumption: apply IMP-094 (`reset-task.sh`: the fix, a self-test red first, `docs/01`'s manual form) and IMP-052 (verify before continuing) — commit: 2cb04dd, 14d09fc
- [x] 4. Process: apply IMP-053 (the gate's verdict always written), IMP-057 (an invariant over a known debt), IMP-060 with IMP-063 (delegation), IMP-078 (a body line read as the footer), IMP-103 (a LOW finding declared as a limit) — commit: 8cf45b1, 3bfc446, 85c7fbe, c62e58d, 29cccab
- [x] 5. Harvest: apply IMP-061 (the source note's date in the block; each lesson counted once at recording) — commit: 4fe4e26
- [x] 6. The boundary's claims: apply IMP-092 with IMP-093 and IMP-097's IDE terminal, IMP-083 with IMP-079, IMP-075 with IMP-065 — commit: b408a71, d49e54e, 4c03a05; the guard's own comments, 9d75a78; the declarations re-read against the documentation, 0c0d7c2
- [x] 7. `SETUP.md`: apply IMP-091 (the scan's known limits, IMP-095's and IMP-096's with them) and IMP-085 (the framework's files out of deploy artifacts) — commit: 3db3233, 249e7af
- [x] 8. The platform: apply IMP-099 (the platforms the CI's workflow lists, one place) — commit: 07b8abd
- [x] 9. The framework's own workflow: apply IMP-082 and IMP-088 (`CONTRIBUTING.md`) — commit: 0cf77df, 7b0c4fc
- [x] 10. The CI's rounds (block 0, the user's pushes): green on the three systems on every pushed state — commit: none to fix — rounds 1 to 3 green on `a31cd57`, `493a4e1` and `850ef45`; the final round with task 13
- [x] 11. ONE reviewer, read-only on git, the snapshot before and after, the two lenses on the payload and on the sets its claims name: HIGH fixed here; MEDIUM resolved or accepted with its reason; LOW per IMP-103 — commit: 559541c, 850ef45 (its record); H1's compensation, the user's decision, 39ade72
- [x] 12. `/retro` and `/checkpoint`: the upgrade 2.1.0 → 2.2.0 rehearsed on the final payload, the HYBRID files with LF and with CRLF — commit: the checkpoint (its own sha cannot be written in it)
- [x] 13. `/integrate`: the CHANGELOG 2.2.0 entry, claiming only what was measured; the bump computed on the content against the expected MINOR and declared before the tag; the final block 0; blocks 1 and 2, without a recovery block in advance — commit: 3e6b6ca (the entry), c46bbcc (the rehearsal with it); the final block 0 green on the three on `c46bbcc` (run 38567505709); blocks 0, 1 and 2, the user's — the merge 9bc0ef7 on `main`, tagged v2.2.0, signed, both published

Each applying commit carries its IMP's part of the text and moves the entry to Applied, its
heading dated; the shas go into the headings with a later commit, as in v2.1.0. Task 10 may
take several commits, one per round of the CI; each round needs the user's push.

## The mapping, before task 2
- Four read-only agents, one per theme, mapped each IMP's sites, the references that cite
  the same rule or title, the tests and documentation checks it touches, the HYBRID slots
  nearby, and their open questions; their brief quoted the user's decisions verbatim and each
  returned its coverage gaps. The snapshot was unchanged after them, the tree clean. Their
  maps are in the session's scratchpad; what they found beside the approved scope is below.

## The applying commits (tasks 2 to 9)
- One commit per IMP, each gated on `make test-scripts` and the upgrade check's self-test in
  the same command, each moving its entry to Applied.
- Measured before IMP-088 was written, with `git merge-file` on git 2.54.0: a change on the
  line next to an answered slot conflicts; one unchanged line in between merges cleanly.
  Then found on `integrate.md` (IMP-102): its new section, inserted after a blank line,
  conflicted against a copy with the branch placeholders answered — the diff aligned the
  blank line on the other side of the insertion, next to the answered line. Set right under
  the paragraph above, with no blank line inside, it merges cleanly, LF and CRLF.
- Every HYBRID file the release changes was merged three ways against a copy with its setup
  answers in place, LF and CRLF, all clean: `integrate.md` and `checkpoint.md` (their
  placeholders answered, `checkpoint.md`'s setup paragraph deleted), the `Makefile`
  (`PROTECTED_BRANCHES` and its project section answered), `CLAUDE.md` (title, stack, repo,
  rules 5 and 8, technical rules); and `docs/00` and `docs/04`, METHOD files a project may
  answer inline. Task 12 rehearses the whole upgrade.
- IMP-094, red first: the new self-test against the script as committed — case 1 left
  ` M both.txt` and ` M staged.txt`; alone, case 2 (the index's lock held) and case 3
  (outside a repository, where bash 3.2's `cd ""` let the script go on) each exited 0 saying
  "Half-done task discarded" —; green after the fix, case 4 under `core.autocrlf` true too.
- Read before writing task 6's claims, on 2026-10-14: Claude Code's *Configure
  permissions* (*Extend permissions with hooks*), *Hooks reference*, *Mods overview*, the
  environment-variable reference, the tools reference, *Run parallel sessions with
  worktrees* and *Configure auto mode*.
- The check on commit messages — no body line opening with a single word and a colon —
  stopped four messages before their commit (IMP-074's, IMP-052's, IMP-057's, IMP-082's),
  each rewritten while uncommitted: the rule IMP-078 wrote down, at work.
- IMP-099, red first: with only the `CI_IMAGES` line added, the committed check failed the
  new case, and on stubbed platforms it called macOS 27 and 15, Debian 12, Ubuntu 16.04 and
  a Windows 11 build (22631) "a platform the framework's CI verifies"; green after the fix
  (macOS, bash 3.2). The committed documentation check let a planted `macos-15` through
  (0 FAIL); the new one fails it, both ways. The CI step's assertion, simulated on six
  platform lines, passed the three right ones and failed the three wrong ones. What the
  images report, from the CI's own log of round 1: macOS 26.6.2 on `macos-26-arm64`, Ubuntu
  24.04.5, Windows Server 2025 build 10.0.26100 on `windows-2025-vs2026`. This Mac, macOS
  27.0.1, now reads "not verified".
- The guard's comments: the forms its scope now names, run through it — git in an unquoted
  heredoc's `$(…)` or backticks, `function f { … }`, a `coproc`, `$cmd`, `sh -c`, `sudo` —
  each go through; `exec`, `nice`, `nohup` and `xargs -n1` before a git write are blocked,
  and only `env`, `timeout` and a bare `xargs` among the wrappers are cases of its self-test.
  The diff changed no line of code: with the comment lines removed, the file equals HEAD's.
- The task-6 declarations re-read on 2026-10-14, at the user's request, from the pages'
  Markdown fetched that morning — *Configure permissions*, *Mods overview*, *Settings
  reference*, *CLI reference*, *Hooks reference*: the deny passage unchanged since the night's
  reading; four statements narrowed and `--safe-mode` declared (IMP-092's entry).

## The CI's rounds (task 10)
- Round 1, the branch's first push, on `a31cd57` (run 38534670202): green on the three
  images; 31 PASS lines on Ubuntu and on macOS, 30 and the one SKIP on Windows, no FAIL; the
  documentation check 0 FAIL, 0 CHECK on each.
- Round 2, on `493a4e1` (run 38544391152): green, the same counts. The new step of the
  prerequisite check named each job's image — "Linux, ubuntu 24.04 (x86_64), verified by the
  framework's CI on ubuntu-24.04", "macOS 26.6.2 (arm64), verified … on macos-26", and on
  Windows `windows-2025` with no verdict —, its assertion passing on the three.
- Round 3, on `850ef45`, the review's fixes (run 38552013931): green, the same counts, the
  documentation check 0 FAIL, 0 CHECK, the platform step's assertion passing on the three.

## The review (task 11)
- ONE reviewer, a general-purpose agent, read-only: the range `00f8349..493a4e1`, the two
  lenses, Claude Code's documentation fetched as Markdown, anything run only in a clone the
  main session made at the tip; its brief quoted the user's decisions verbatim, the two
  projects' names replaced. About 27 minutes. The snapshot after it differed in one line,
  `refs/remotes/origin/feat/backlog-retro-2.2.0` moved to `493a4e1`: the user's push of
  round 2, at 11:43:01 by the reflog ("update by push"), three minutes after the snapshot
  before; the working tree clean, the clone at the tip.
- Its findings: 1 HIGH, 1 MEDIUM, 6 LOW, 6 INFO. Each checked by the main session at its
  source before acting — the documentation pages fetched again, the texts read.
  - H1, the session's working directory: Claude Code reads `.claude/settings.json` from the
    session's primary working directory with no parent-directory fallback (*Settings*,
    *Configure permissions*), so a session started in a subdirectory, or moved with `/cd`,
    runs with no guard, no `deny` or `ask` rule, no session marker and no SessionStart hook,
    while `CLAUDE.md` loads — read, not measured. Declared in `docs/04` (a bullet, the rows,
    the `ask` bullet), `SETUP.md`'s *Hardening*, the README, `scripts/README.md` and the
    guard's comment; the `pre-push` still refuses on `CLAUDECODE`.
  - M1, `SETUP.md`'s abort block claimed `docs/04`'s form while printed under its condition:
    now run or given only once the user has decided to abort.
  - L1 to L6, each closed with a line: `/integrate`'s recovery block alone (the changed line
    kept one unchanged line away from the answered one); ExitWorktree; its "no tag" bullet
    yields to the content; `reset-task`'s limits declared; rule 7 of `CLAUDE.md` for a
    session that "dies mid-task"; the base check on `origin/<integration branch>`.
  - I2, I4, I5, I6 closed with a line (dontAsk; IMP-078's count, now four; the manual
    discard is the user's form; the worktree's fallback and the branch measured for the
    Agent tool only). I1, the self-test does not reach `reset-task`'s check that the tree
    reads clean: declared in IMP-094's entry. I3, two pushed commit messages narrower than
    the text they introduced (`b408a71`, `4c03a05`): history, not rewritten.
- The documentation check reported `/cd` as a command missing from `.claude/commands/`:
  declared in its allow-list beside `/clear`, both commands of Claude Code itself.
- Its coverage gaps, closed here: the HYBRID merges (the guard blocks `git merge-file` for a
  delegated agent) — rehearsed by the main session; round 2 of the CI — read above. Left
  open: the `reset-task` mutant of I1, not run; gitleaks' source behind `SETUP.md`'s known
  limits, held to the records only.
- Beside the approved scope, answered: a background session that changed code in a worktree
  commits and pushes before finishing, unless the task, `CLAUDE.md` or memory says the user
  handles git — rule 3 does —, and the `pre-push` refuses that push (*agent-view*,
  read, not measured); `worktree-agent-<id>` was measured for the Agent tool on 2026-09-27,
  not for the Workflow tool, and `docs/04` now says so.

## The decisions (the user's, 2026-10-14, after the review)
- The user checked the citation of the deny statement on *Configure permissions* on their own
  and found it exact; `0c0d7c2`'s corrections stand; the CI step that asserts the platform
  line names its own image, approved.
- H1's compensation, option A, in this release: a line in `CLAUDE.md`'s *Persistent memory*
  — if `STATE.md` was not injected at the start, the project's settings did not load: say so
  to the user before anything else, and advise restarting Claude Code from the repository's
  root —, minimal and away from the slots — `39ade72`.
- IMP-104 recorded OPEN at a LOW priority, the user's: a SessionStart hook in the USER's
  settings, which load from any folder, warning when a session sits in a framework
  repository but not at its root — the machine's configuration, optional hardening for
  `SETUP.md`, not the payload's; its trigger the first session started from a subfolder that
  the instruction does not catch.

## Task 12 — the upgrade rehearsed, the retro, the checkpoint
**The upgrade 2.1.0 → 2.2.0, rehearsed on the final payload** (`39ade72`, tagged v2.2.0 in a
clone only, the scratchpad's `rh6-*.sh`; a project grafted at v2.1.0 with every setup answer
in place — `CLAUDE.md`'s title, stack, repo, rules 5 and 8 and technical rules, the two
commands' branch placeholders with `checkpoint.md`'s setup paragraph deleted, the
`Makefile`'s protected branches and targets, the formatting slot, `.gitignore` and the
`allow` list —, and `docs/00`'s and `docs/04`'s slots answered inline), with LF and with
CRLF line ends, the same results on both:
- the prerequisite check from `T` 0 FAIL, 0 WARN; `preflight` 0/0; `inventory` 0 FAIL and
  the two CHECKs of edge case 7, `docs/00` and `docs/04` customised inline; every 3-way at
  0 conflicts — `CLAUDE.md` 0 of 105 lines, `integrate.md` 0 of 189, `checkpoint.md` 0 of 51,
  the `Makefile` 0 of 39, `docs/00` 0 of 159, `docs/04` 0 of 448;
- Step 3: twelve METHOD files with the tag's modes, `scripts/test-reset-task.sh` new at
  100755; the answers kept, the new texts present — the recovery section, rule 3, the line
  on `STATE.md`, rule 7's "dies mid-task", the H1 bullet —; `sessions/README.md` equal to
  2.2.0's;
- Step 4: `make hooks-install` exit 0, the three hooks unchanged, no `.bak`; refused, a fake
  secret and a message without a type; the project's `make test-scripts` 12 PASS, the
  `reset-task` self-test among them; `make reset-task` on a half-done task left the tree
  clean;
- Step 5: `invariant` 0/0; `post` 0 FAIL once the pin reads v2.2.0, and the two CHECKs of
  the files customised inline.
A first run, on `493a4e1` before the review's fixes, had given the same results.

**The retro.** IMP-104 recorded at the user's decision. Two more, open: IMP-105 — the real
path starts where the tool reads its configuration: two releases in a row the only HIGH was
a configuration silently not in effect, and four statements of task 6 came from WebFetch's
answers about the pages, not their text —; IMP-106 — the snapshot's difference when the
user pushes during a delegated run. IMP-078's count, four.

**The checkpoint.** The 19 Applied entries carry their commits. `STATE.md`, `TREE.md` and
`INDEX.md` stay clean templates here (`CONTRIBUTING.md`, *This repo's memory*); the README's
tree already lists the new self-test, which the documentation check holds to the files.

## Task 13 — /integrate
**The bump, computed on the content against the expected MINOR.** By the types alone the
range gives a PATCH: two `fix(scripts)` commits (IMP-094, IMP-099) among `chore` and `docs`.
By the content a MINOR: new rules and checks in the files the framework ships — `docs/04`'s
*The type suggests; the content decides*, *Destructive commands never in advance* and the
session that loads no settings, `docs/03`'s point 4, `docs/02`'s allow-list, `docs/01`'s
verification before continuing, `docs/00`'s delegation, `CLAUDE.md`'s line on `STATE.md`,
`/integrate`'s failure path, the session note's security-gate line, the prerequisite
check's images, `reset-task`'s self-test. No breaking change: no command removed or
renamed, no slot added or removed (`inventory`), the session-note format gains a line older
notes need not carry, and the upgrade from 2.1.0 merges cleanly. A MINOR, the bump the
request expected: v2.2.0 from v2.1.0, the merge typed `feat`.

**The CHANGELOG's 2.2.0 entry** written from the draft, claiming what was measured — the
rehearsal's clean merges, the hooks unchanged, the self-test red first, the CI's assertion on
the images — and naming as read, not measured, what rests on Claude Code's documentation —
`3e6b6ca`. Its message's first draft held a body line that began "expected:", stopped by the
grep before the commit.

**The upgrade rehearsed again, on `3e6b6ca`** with the entry, tagged v2.2.0 in a clone only,
the same project and answers, LF and CRLF: `inventory` printed the entry's *Upgrading from
2.1.0* paragraph whole, 0 FAIL and the two CHECKs of edge case 7; every 3-way at 0 conflicts;
the answers kept and the new texts present; the hooks unchanged, no `.bak`; a fake secret
and a message without a type refused; the project's `make test-scripts` green; `make
reset-task` left the tree clean; `invariant` 0/0, `post` 0 FAIL once the pin read v2.2.0.

## Security gate
- Under the gate: the release asserts security properties — the boundary's declarations in
  `docs/04`, the pre-commit's known limits, `reset-task`'s "discarded", the prerequisite
  check's "verified". The two lenses applied by ONE reviewer (task 11): the HIGH declared
  where its claims live and compensated in `CLAUDE.md`, the MEDIUM resolved, the six LOW and
  six INFO closed with a line or declared — IMP-103.

## Problems encountered → cause → solution
1. Four statements of task 6 said more or other than Claude Code's documentation → written
   from WebFetch's answers about the pages — a model's reading, of the first part only of a
   long page — and compressed in the writing; the *Settings reference* not read → re-read
   from the pages' Markdown at the user's request, narrowed in `0c0d7c2`; IMP-105.
2. The snapshot after the review differed → the user's push of round 2 moved the
   remote-tracking ref → the reflog showed it; the main session went on with the fixes before
   reporting it, against the rule's letter; IMP-106.
3. The documentation check reported `/cd` as a missing command → its rule takes every
   backticked `/word` for a command of the method → declared beside `/clear`.
4. A probe command in the scratchpad began with `rm -rf` → the `deny` rule refused it →
   rerun in a fresh directory, nothing removed.

## Proposals
- IMP-104, IMP-105 and IMP-106, open in `LEARNINGS.md`, for the next retro.

## Beside the approved scope — for the review (task 11)
- Done in 9d75a78, with the user present: the guard's own comments claimed more than its
  cases — Bash, PowerShell and Monitor "the tools that run git", heredoc bodies "data", the
  wrappers "mirrored" from Claude Code's.
- From the mapping's readings, not measured: Claude Code's background sessions that changed
  code in a worktree commit and push before finishing, and the `pre-push` refuses that push
  where it is installed; `docs/04` names an isolated agent's branch `worktree-agent-<id>`,
  which the worktrees page does not confirm (it names `worktree-<name>` for `--worktree`).
  Both answered by the review (*The review*, above).

## Resumption notes
- The payload names no IMP number: the documentation check's `imp-number` refuses one; the
  why goes in prose.
- Delegated agents read only: the snapshot before and after each delegation.
- Closed on 2026-10-14 on `chore/memory-test-harvest`, the next deliverable's branch: the
  final block 0 green on the three on `c46bbcc` — 31 PASS on Ubuntu and macOS, 30 and the
  known SKIP on Windows, the documentation check's one CHECK the release being prepared —,
  then blocks 1 and 2, run by the user, without a recovery block: the merge `9bc0ef7` on
  `main`, its tree the tested one, 31 commits, and v2.2.0 signed on it, both published, the
  feature branch deleted.
