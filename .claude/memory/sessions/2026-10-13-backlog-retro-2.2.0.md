---
date: 2026-10-13
task: v2.2.0 — the retro over the backlog, decided and applied — the recovery block given only after a failed check, a LOW finding declared as a limit, a backlog small enough to grow only from the projects' real use
branch: feat/backlog-retro-2.2.0
status: in-progress
model: 'claude-opus-5-5'
turns: 3
tags: [session, retro, imp, plan, security-gate]
---
# Session 2026-10-13 — v2.2.0: the retro over the backlog

> A dedicated branch from `main` at `00f8349` (v2.1.0, its tag signed). Probes only in the
> session's scratchpad. Hybrid regime: no `plans/`, this note is the plan-pointer. The retro's
> phase 1, read-only on `main`, the same day; then the user's decisions.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 3` — the user's report of v2.1.0's integration, with the brief of the retro; the
  user's decisions on the retro; the user's decisions of 2026-10-14, after the first push.

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
- [ ] 10. The CI's rounds (block 0, the user's pushes): green on the three systems on every pushed state — commit: —
- [ ] 11. ONE reviewer, read-only on git, the snapshot before and after, the two lenses on the payload and on the sets its claims name: HIGH fixed here; MEDIUM resolved or accepted with its reason; LOW per IMP-103 — commit: —
- [ ] 12. `/retro` and `/checkpoint`: the upgrade 2.1.0 → 2.2.0 rehearsed on the final payload, the HYBRID files with LF and with CRLF — commit: —
- [ ] 13. `/integrate`: the CHANGELOG 2.2.0 entry, claiming only what was measured; the bump computed on the content against the expected MINOR and declared before the tag; the final block 0; blocks 1 and 2, without a recovery block in advance — commit: —

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

## Beside the approved scope — for the review (task 11)
- Done in 9d75a78, with the user present: the guard's own comments claimed more than its
  cases — Bash, PowerShell and Monitor "the tools that run git", heredoc bodies "data", the
  wrappers "mirrored" from Claude Code's.
- From the mapping's readings, not measured: Claude Code's background sessions that changed
  code in a worktree commit and push before finishing, and the `pre-push` refuses that push
  where it is installed; `docs/04` names an isolated agent's branch `worktree-agent-<id>`,
  which the worktrees page does not confirm (it names `worktree-<name>` for `--worktree`).

## Resumption notes
- The payload names no IMP number: the documentation check's `imp-number` refuses one; the
  why goes in prose.
- Delegated agents read only: the snapshot before and after each delegation.
- Next: block 0, round 2 (the commits after `a31cd57`); task 11, ONE reviewer, the two
  lenses, read-only, its brief quoting the user's decisions verbatim; then task 12.
