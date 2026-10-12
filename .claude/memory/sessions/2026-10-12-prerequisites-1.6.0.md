---
date: 2026-10-12
task: v1.6.0 — prerequisites and versions (IMP-070 point 7, IMP-076, IMP-077) — a prerequisite check runnable without make; commitlint pinned in one place; gitleaks' minimum declared, its hook kept; the generated hooks run with the real tools in the CI
branch: feat/prerequisites-1.6.0
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, prerequisites, ci, tools, imp, plan]
---
# Session 2026-10-12 — v1.6.0: prerequisites and versions

> A dedicated branch from `main` at `e281e10` (v1.5.0, its tag signed). Probes only in the
> session's scratchpad. Hybrid regime: no `plans/`, this note is the plan-pointer. No phase
> 1: the analysis is v1.5.0's ([[2026-10-11-multiplatform-1.5.0]]; IMP-070, IMP-076,
> IMP-077). A draft plan, checked by two read-only agents — the repository's snapshot
> identical before and after —, was decided by the user the same day.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 2` — the user's brief for v1.6.0, with v1.5.0 integrated and published; the
  user's decisions on the plan.

## The brief — persisted so a /clear does not lose it
v1.6.0, the EXPECTED bump a MINOR: `/integrate` computes it again from the commits and, if
the two diverge, says so before the tag (IMP-074).

The FIRST commit holds the registrations the agent kept in its persistent memory while
v1.5.0's branch was frozen; then that memory is emptied — the repository is the source.

The content, from the decisions of v1.5.0's phase 1:
1. `scripts/check-prerequisites.sh`, runnable without make, with a self-test built on
   stubs in `PATH`: it runs each tool, compares the minimums, recognises the platform (Git
   Bash included), and warns when `core.autocrlf=true` and `.gitattributes` is missing. It
   FAILS only for a tool missing or one that does not start; below a verified minimum it
   only WARNS. It installs nothing. `hooks-install.sh` and `SETUP.md` call it.
2. commitlint pinned to an explicit version, defined in ONE place; the declared Node.js
   minimum derives from that version — what it requires, verified on the npm registry.
3. `gitleaks protect`: the form that replaces it in the pre-commit, and the release since
   which it exists, verified on gitleaks' official documentation. It is replaced ONLY if
   the replacement exists in the minimum version we declare; otherwise it stays, and an
   IMP records the deadline.
4. The new self-tests enter the CI of the three systems.

The flow: a dedicated branch; a block 0 with the CI green on the three systems on every
pushed state; ONE reviewer; `/checkpoint`; blocks 1 and 2 with the check of the tested
tip.

## The decisions on the plan (the user's, 2026-10-12)
- **D1 → B.** `protect` stays; gitleaks' declared minimum is 8.0.0. An OPEN IMP records the
  deadline: move to `gitleaks git`, with 8.20.0 as the minimum (8.19.x's `--staged`
  defect), when gitleaks announces the removal of `protect`. The bump stays a MINOR.
- **D2 → yes.** For a tool missing or below its minimum: the tool's name, its minimum and
  its official installation page — no package manager, as IMP-070's point 6 has it (its
  point 7 had asked for the platform's install command).
- **D3 → yes, minimal.** Four cases with the real tools, no more without an observed
  defect (the principle of `tools/`): the generated pre-commit refuses a secret built at
  run time and accepts a clean commit; the commit-msg hook, at the pin, accepts a
  conforming message and refuses a wrong one. gitleaks in the CI: its version AND its
  checksum fixed in the workflow, the checksum verified before the binary runs, the CI
  failing on a mismatch — a link of the supply chain, treated like the action pinned by
  SHA.
- The plan approved as it stands, 11 tasks. The reviewer carries the security mandate on
  the hooks, and the security gate's verdict is written.

## The facts at the source (read on 2026-10-12)
- **commitlint** (npm registry, `npm view`; cross-checked on registry.npmjs.org):
  `@commitlint/cli` and `@commitlint/config-conventional` are at 21.2.3, published
  2026-09-19; every 21.x of both declares `engines.node` `>=22.12.0` — raised in 21.0.0
  ("chore!: minimum node version v22", #4679); no 22.x, no pre-release. The two come from
  one monorepo in lerna's fixed mode, but a package unchanged in a release is not
  republished, so not every number exists for both. `@commitlint/cli` 21.2.3 reaches its
  siblings and its other dependencies through caret ranges (`yargs ^18.0.0`,
  `tinyexec ^1.0.0`, …), which npx resolves at install time: a pin fixes the two packages,
  not their tree. The tree resolved today: no `engines.node` above `>=22.12.0`. So the pin
  is 21.2.3, and Node.js 22.12 stays the minimum.
- **gitleaks** (github.com/gitleaks/gitleaks — the README, `.pre-commit-hooks.yaml`, the
  releases, the source at each tag):
  - the latest release is v8.30.1 (2026-03-21); `protect` and `detect` are still
    registered there and on master, hidden from `--help`; no removal announced (the
    README, the release notes, the issues searched). gitleaks' own `scripts/pre-commit.py`
    at v8.30.1 still runs `gitleaks protect -v --staged`;
  - the replacement is `gitleaks git --pre-commit --redact --staged --verbose` (the
    `.pre-commit-hooks.yaml` entry since #1627, first released in v8.21.3);
  - `gitleaks git` came in v8.19.0 (2024-09-14, "Deprecate `detect` and `protect`. Add
    `git`, `dir`, `stdin`", #1504), but from v8.19.0 to v8.19.3 it ignores `--pre-commit`
    and `--staged` and scans the history — issue #1522, fixed by #1533 in v8.20.0
    (2024-10-03). IMP-077 had recorded 8.19.0: corrected in this note's first commit;
  - `protect --staged` reads the staged diff through its own code
    (`sources.NewGitDiffCmd(source, staged)` in `cmd/protect.go`) at v8.18.4, v8.19.0,
    v8.19.3 and v8.20.0; `protect` with `--staged`, and the root flags `--redact` and
    `--verbose`, exist from v8.0.0 (2021-11-22).
- **The CI's images** (actions/runner-images, the software lists at `2c421200c9e6`): no
  gitleaks on `ubuntu-24.04`, `macos-26` (arm64) or `windows-2025`; their Node.js is
  22.23.3, 24.20.0 and 22.23.3.

## What the plan's review changed
Two read-only agents checked the draft (the repository's snapshot identical before and
after). Kept from their findings:
- every task updates, in its own commit, the lists and documents that name what it adds —
  the class table, the `Makefile` recipe, `scripts/README.md`, the README's tree, the
  fixtures of `tools/test-docs-check.sh` —, or the documentation check and the upgrade
  check's self-test fail at each commit in between;
- IMP-071 to IMP-075 were already in the backlog (`a787c9a`): not repeated;
- session notes are append-only (`sessions/README.md`): rounds 6 to 8 go in a section at
  the end of v1.5.0's note;
- the upgrade runs the release's scripts from `T`: a 1.5.0 project has no check of its
  own, so the check runs from `T`, on the project, before Step 4; and v1.5.0's Upgrading
  note said the hooks did not change — v1.6.0's must say `make hooks-install` is needed;
- `hooks-install.sh` calls the check after its own repository checks, for what the hooks
  need: `bash scripts/hooks-install.sh` runs without make;
- the pin is narrowed to what it fixes (the two packages, not their tree — IMP-071);
- a documentation-check rule on the written minimums answers an observed defect: v1.3.3's
  M3, a Node.js minimum written and already false ([[2026-10-10-upgrade-safety-1.3.3]]);
- the line-end warning tests what the line-end step tests (`git check-attr eol`), not the
  bare presence of `.gitattributes`; WSL and Cygwin named, as not verified;
- a literal secret in a committed test would trip this repository's own pre-commit: the
  real-hook case builds it at run time.

## Plan (one commit per task)
- [x] 1. The registrations — IMP-079 to IMP-084, IMP-073's occurrence (`7d2052b`), IMP-077 corrected (8.20.0) —, the CI's rounds 6 to 8 at the end of v1.5.0's note, and this note with its plan; then the agent's persistent memory emptied — commit: 598cab8
- [x] 2. `scripts/check-prerequisites.sh` and its stub-based self-test, with the lists and documents that name them: the minimums and commitlint's pin at its head, the one place; each tool run (the POSIX userland too), a tool found that does not start fails, below a minimum a warning (a version comparison bash 3.2 runs, no `sort -V`); the platform named; the line-end warning by `git check-attr eol`; D2's hints. Each case red first, a mutant for each detection branch (IMP-072) — commit: da54b98 (the pin moved to task 3, see below)
- [x] 3. commitlint at the pin, read from the one place by `hooks-install.sh`; `SETUP.md` §0 no longer says "latest"; a documentation-check rule holds every written minimum and the pin against the one place — commit: 1e1129f
- [x] 4. `hooks-install.sh` runs the check, after its own repository checks and for what the hooks need; its self-test copies the check into its throwaway places, its stubs answer a version — commit: 77525a0
- [x] 5. gitleaks per D1 (B): `protect` stays, 8.0.0 declared; IMP-077 decided, OPEN on its trigger — commit: efd4ca4
- [x] 6. The CI per D3: gitleaks at a fixed version and checksum, verified before it runs; the four real-hook cases in `tools/`; the *Versions* step names gitleaks and npx; the real check on each runner; the prose on what the CI installs and runs — commit: 6212081
- [x] 7. The upgrade 1.5.0 → 1.6.0 rehearsed in throwaway clones, LF and CRLF: the check from `T` before Step 4, the hooks regenerated; the Upgrading note drafted — commit: 3b0edca
- [x] 8. The CI's rounds (block 0, the user's pushes): what fails, fixed with new commits, until green on the three — commit: the record of round 1 — green on `3b0edca` (run 38299497518), nothing to fix (its own sha cannot be written in it)
- [ ] 9. ONE reviewer, read-only on git, snapshot before and after, with the security mandate on the hooks; the gate's verdict written; fixes — commit: —
- [ ] 10. `/retro` and `/checkpoint`: the upgrade rehearsed again on the final payload; IMP-070 and IMP-076 applied, each in its `chore(claude): apply IMP-nnn` commit (`docs/06`); IMP-077 stays OPEN on its trigger (D1) — commit: —
- [ ] 11. `/integrate`: the CHANGELOG 1.6.0 entry, claiming only what was measured (IMP-073); the bump computed again against the expected MINOR; the final block 0 green on the three, then blocks 1 and 2 — commit: the CHANGELOG commit (its own sha cannot be written in it)

Task 8 may take several commits, one per round of the CI: each round needs the user's
push. Task 10's applied entries follow `docs/06`'s dedicated commits, so it takes several
too.

## The prerequisite check (task 2) — RED, then GREEN, then the mutants
- `scripts/check-prerequisites.sh` runs each tool's version command — `gitleaks version`,
  the subcommand 8.0.0 already has (its root `--version` came later, both read from the
  source) —, compares the version number by number in awk (no `sort -V`), and probes the
  userland on nothing, the same way on GNU and BSD. Run on this Mac, under the system's
  bash 3.2 too: every tool OK; outside a repository the line ends are SKIP.
- Two moves from the plan's wording, so that no commit claims what is not yet true
  (IMP-073): commitlint's pin enters with task 3, where `hooks-install.sh` starts reading
  it; gitleaks' minimum with task 5, which declares it. Until then the table says Node.js
  22.12 comes from commitlint's 21.x line, the one npx fetches.
- The self-test's five cases ran RED against an empty check (its first assertion), GREEN
  against the real one (11 s here). Then one mutant per detection branch, 24, each
  changing the script and each killed by the assertion of its own branch: a tool missing,
  not starting, unreadable or below its minimum turned OK; the comparison made one of
  strings; the no-minimum branch skipped; the userland's FAIL turned OK, or `cmp` dropped
  from it; each platform arm and each architecture test; the line ends' SKIP, autocrlf
  test, check-attr test and warning; the exit status, either way; the version cut to its
  first number; `gitleaks --version` in place of the subcommand; a stop at the first
  failure. Two first drafts of the architecture mutants broke the script's syntax — a
  `.*?fi` that stopped inside "verified" — and were rebuilt before they counted.
- Not exercised: the carriage return `first_line` strips, should a Windows program end its
  line with one — no case feeds one; task 6 runs the check on the Windows runner.

## commitlint at the pin (task 3)
- `COMMITLINT=21.2.3` joins the table of `check-prerequisites.sh`, which prints it alone
  when asked (`--commitlint-version`); `hooks-install.sh` reads it there and writes it into
  the commit-msg hook for both packages — a pin it cannot read stops the install. Every
  throwaway place of `test-hooks-install.sh` gets the check next to the installer, as
  every copy of `scripts/` has it.
- The documentation check holds every "<tool> <version> or later" of the present documents
  — 14 today: `SETUP.md`, the READMEs of `scripts/` and `tools/`, the scripts' messages,
  `docs-check.mjs`'s own header, reworded into that form — and any "commitlint X.Y.Z"
  against the table; an IMP entry's body is history and is skipped, and so is the check's
  own self-test, whose planted defects are data. The answer to an observed defect: v1.3.3's
  M3.
- Measured: the generated commit-msg hook run for real, with npx fetching 21.2.3 — a
  message without a type refused. A conforming one was refused too, by commitlint finding
  no configuration in that throwaway repository: task 6's real case needs
  `commitlint.config.cjs` there.
- Mutants, each run once: the hook written without the pin; the check printing `latest`
  (`hooks-install.sh` refuses it, the check's self-test sees it); the version comparison
  always equal; the pin comparison removed; the history mask removed (a planted
  "Node.js 14.13 or later" in an IMP entry then fails). All five killed; one first draft
  of the last mutated three lines — the mask idiom is the other rules' too — and was
  rebuilt on the rule's own line before it counted.

## hooks-install runs the check (task 4)
- `hooks-install.sh` runs `check-prerequisites.sh --hooks` from the repository's top level,
  after its own repository checks, in place of its `command -v gitleaks` and `npx`: a tool
  missing or not starting stops it before any hook is written; `--hooks` leaves out make,
  which the hooks never run, so `bash scripts/hooks-install.sh` still needs none. A missing
  check file is said as such.
- Found while wiring it, and measured: from a subdirectory,
  `git check-attr eol -- CLAUDE.md` answers "unspecified" — the framework's attributes are
  anchored at the top level — so the line-end warning would fire wrongly there. The check
  now reads the attributes from the top level (`git -C <top>`).
- RED first, against the code before the change: the subdirectory case fails on the check
  without the top-level read; `test-hooks-install.sh`'s new case 4 fails on HEAD's
  installer, which installs the hooks with a gitleaks that does not start. Then green; and
  the mutant that drops the `--hooks` scope is killed by both self-tests.
- `test-hooks-install.sh` counts four cases now, so `tools/test-docs-check.sh`'s fixtures
  that plant a wrong count move with it ("Four cases:" to "Five cases:"; "the header lists
  4 cases, the file marks 3"). Its stubs answer their version command.

## gitleaks per D1, B (task 5)
- The table declares gitleaks 8.0.0, and `SETUP.md` §0 writes it, held against the table by
  the documentation check. The generated pre-commit hook is unchanged — `protect --staged`
  — so a project's pre-commit is not rewritten by this release; the reason lives in a
  comment of `hooks-install.sh`, outside the hook.
- IMP-077 decided and kept OPEN on its deadline: gitleaks' announcement that `protect` goes.
  Its risk line was wrong for the switch it describes — the check only warns below a
  minimum, and 8.19.x would scan the history in silence —, so it now says the switched hook
  must refuse a gitleaks below 8.20.0 by itself.
- The check's self-test: gitleaks exactly at 8.0.0 is OK, 7.6.1 is a warning.

## The CI per D3 (task 6)
- gitleaks 8.30.1 on the three images: 8.0.0, the declared minimum, ships no darwin_arm64
  archive (its release assets, read with `gh`), so one version for all three — the latest,
  the one whose `protect` is hidden; the minimum stays read from the source, as the check
  says. The three archives were downloaded and hashed here: each SHA-256 equals the one in
  the release's `gitleaks_8.30.1_checksums.txt`, and those three values are fixed in the
  workflow, which hashes the archive before extracting it. The step, run here as the macOS
  runner would: the right hash extracts the binary and adds it to the PATH; a wrong one
  fails with the two hashes, nothing extracted. The Windows branch (7-Zip, `cygpath`) waits
  for the CI.
- `tools/test-real-hooks.sh`, the four cases of D3, each hook run as git runs it; the
  secret is an AWS access key ID put together at run time (gitleaks 8.30.1's
  `aws-access-token` rule, probed first). Green here in 3 s; a mutant per case — the scan's
  failure ignored, every change refused, a pin that does not exist, commitlint's failure
  ignored — each killed by its own case.
- The workflow also runs the shipped `check-prerequisites.sh` against each runner's real
  tools, and its *Versions* step names gitleaks and npx. `SETUP.md` §0, `CONTRIBUTING.md`,
  `tools/README.md`, the README's tree and the workflow's header say what the CI now runs
  and installs.

## The upgrade 1.5.0 → 1.6.0 rehearsed, LF and CRLF (task 7)
A clone of this branch at `6212081`, the draft CHANGELOG entry committed and tagged v1.6.0
there only; a project grafted at v1.5.0 from that tag's payload — the live memory emptied
as setup's step 2 says, `checkpoint.md`'s paragraph answered, `CLAUDE.md`'s stack and the
formatting slot of `hooks-install.sh` answered, a pin, a file of its own, v1.5.0's hooks
installed —, as it is (LF) and cloned with `core.autocrlf=true`. The upgrade as `SETUP.md`
says it, with the new *Precondition* paragraph:
- the prerequisite check, `vY`'s copy run from `T`: 0 FAIL, 0 WARN on both — on the CRLF
  project, "core.autocrlf is true, and .gitattributes holds the framework's files to LF";
  `preflight` 0/0;
- `inventory` 0 FAIL, 0 CHECK, the same line for line on both: `CLAUDE.md` and
  `hooks-install.sh` diverged with 0 conflicts, `Makefile`, `scripts/README.md` and
  `test-hooks-install.sh` at `vX` in the project, the two new files absent; no slot moved;
- Step 3: the METHOD files with the tag's modes (100755 for the scripts), the three 3-way
  merges clean, the project's answers kept;
- Step 4: `make hooks-install` exit 0 — "commit-msg contained local changes", its `.bak`
  identical to v1.5.0's hook; pre-commit and pre-push unchanged; the three hooks carry the
  marker; the new commit-msg names 21.2.3; a fake secret refused (one finding), a message
  without a type refused (`type-empty`); the project's `make test-scripts` green (7 PASS);
- Step 5: `invariant` 0/0; `post` 0 FAIL and one CHECK, the pin still at v1.5.0 — 0/0 after
  Step 6 rewrote it.

The Upgrading note, drafted on these measures (the scratchpad holds the whole entry, for
`/integrate`):

```markdown
**Upgrading from 1.5.0** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- **The prerequisites, first.** Before Step 1, run `vY`'s prerequisite check from `T`, as
  the *Precondition* says. A FAIL is a tool to install or repair before Step 4, whose
  `make hooks-install` now runs the same check and stops on it.
- METHOD files — bring them over from the tag: `scripts/README.md`,
  `scripts/test-hooks-install.sh`; and two new ones, executable: `scripts/check-prerequisites.sh`,
  `scripts/test-check-prerequisites.sh`.
- HYBRID files (3-way): `scripts/hooks-install.sh` (the check first, commitlint's pin),
  `Makefile` (the new self-test in `test-scripts`), `CLAUDE.md` (the `test-scripts` line of
  *Quick commands*).
- **`make hooks-install` is needed this time** — 1.5.0's note said the hooks did not
  change: the commit-msg hook now names commitlint's pin. The re-run says the old hook
  "contained local changes" and saves it as `commit-msg.bak`: unless the project edited
  that hook, it is 1.5.0's own, byte for byte (the rehearsal compared them) — compare, then
  remove the `.bak`. The pre-commit and pre-push hooks do not change.
- The memory templates and the `LEARNINGS.md` header do not change; nothing migrates.
```

## The CI's rounds (task 8)
Round 1, the branch's first push: `3b0edca`, run 38299497518, green on the three jobs —
Ubuntu in 88 s, macOS in 194 s, Windows in 574 s. Nothing to fix. Read in the log, not
taken from the green (IMP-084):
- the gitleaks step prints nothing when the hash matches; it passes only when the hash it
  computes equals the fixed one, both non-empty. The next step's `gitleaks version` printed
  8.30.1 on the three — Windows' branch, 7-Zip and `cygpath`, included;
- the prerequisite check against each runner's real tools: 0 FAIL, 0 WARN on the three.
  macOS ran it with bash 3.2.57, the declared minimum, and make 3.81. Windows took the
  line "core.autocrlf is true, and .gitattributes holds the framework's files to LF": the
  image sets `core.autocrlf` in `C:/Program Files/Git/etc/gitconfig`;
- the real hooks: the PASS line, printed only after the four cases, on the three — with
  gitleaks 8.30.1 and commitlint 21.2.3;
- `make test-scripts`: 17 PASS on Ubuntu and macOS; on Windows 16 PASS and the
  dangling-symlink SKIP, as in v1.5.0. docs-check 0 FAIL, 0 CHECK; the upgrade check's
  self-test 8 PASS; the guard's "3 CRLF cases whose CR node received" — on the three;
- Node.js 22.23.3 on Ubuntu and Windows, 24.20.0 on macOS; npx 10.9.9 and 11.19.0.

## The review (task 9) — one reviewer, read-only on git
One delegated agent with the security mandate on the hooks, over `e281e10..4b3abb9`. Its
sandbox was made by the main session: a clone at `4b3abb9`, no remote, and a throwaway
project with the three generated hooks. The repository's snapshot, its tracked files, its
three hooks and its `.git/config` were identical before and after. The harness refused the
agent's report file; its findings, 1 HIGH, 2 MEDIUM, 2 LOW, 7 INFO:
- **HIGH H1, older than this range — a forced colour lets the pre-commit pass a secret.**
  gitleaks runs `git diff -U0 --no-ext-diff --staged .` without `--no-color`, in every
  release up to 8.30.1. With `color.ui=always` or `color.diff=always` in the user's config
  the patch comes coloured, gitleaks parses no file out of it, prints "no leaks found" and
  exits 0. The one-off `gitleaks detect` of `SETUP.md` scans 0 commits the same way.
  `tools/test-real-hooks.sh` sets `GIT_CONFIG_GLOBAL=/dev/null`, so the CI cannot see it.
  Upstream: gitleaks#2281, open, filed against `gitleaks git --pre-commit --staged` too, so
  IMP-077's switch would not cure it; PR #2284, open. The agent's fix: run gitleaks under
  `GIT_CONFIG_PARAMETERS="${GIT_CONFIG_PARAMETERS:+${GIT_CONFIG_PARAMETERS} }'color.diff'='never'"`
  — the last value wins, a `git -c` included, which `GIT_CONFIG_COUNT` would not beat —;
  the same prefix wherever the method says to run `gitleaks detect`; a fifth real-hook case
  with `color.ui=always`.
- **MEDIUM M1 — the declared minimum, 8.0.0, admits releases whose hook is unsafe.** Read
  at the source over the 107 v8 tags: (a) before 8.18.2 the staged diff has no
  `--no-ext-diff`, so a `diff.external` (difftastic's documented setup) or a
  `GIT_EXTERNAL_DIFF` replaces the patch — "no leaks found", exit 0 (gitleaks#1206, open
  since 2023); Ubuntu 24.04 and Debian 13 ship 8.16.0; (b) 8.0.0 to 8.1.3 write their
  default config to `<source>/.gitleaks.toml` when none exists, and every later gitleaks
  then loads it instead of its built-in rules (measured with 8.30.1: a key found without
  the file, missed with 8.1.3's default there); (c) 8.4.0 to 8.18.1 log a scan error and
  exit 0 (reasoned). Its fix: the floor 8.18.2, enforced, by the check or the hook. It
  revisits D1's number, not its choice to keep `protect`.
- **MEDIUM M2 — the check reads a gitleaks 7.x as `OK gitleaks 2026`.** No 6.x or 7.x
  has a `version` subcommand: their CLI ignores the word and scans the working directory,
  the first line a log line with a timestamp, and `version_number` takes the year. With a
  leak in the working tree it exits 1, and the check says the tool does not start. The
  self-test's 7.6.1 stub answers `version`, a CLI that never existed: the case passes for
  the wrong reason. The hook itself fails closed with 7.x (`unknown flag 'staged'`).
- **LOW L1** — `hooks-install.sh`'s comment says a commitlint release reaches a project
  only through a framework release; the two packages' own dependencies follow `^21.2.3`.
- **LOW L2** — the workflow's header and `SETUP.md` §0 say the CI installs only make and
  gitleaks; `tools/test-real-hooks.sh` makes npx fetch commitlint's tree, unhashed.
- **INFO** — I1: the pin guard and the documentation check accept `21`, `.` or `1..2`.
  I2: `core.autocrlf` is read as text, so a bare key or `2`, true for git, reads as not
  true. I3: a FAIL for any hook tool now leaves a fresh project without the pre-push too —
  loudly; an upgrade keeps the old hooks. I4: the `USERLAND` comment is wider than its
  list. I5: the real-hook PASS line names the pin; nothing asserts the version that ran
  (21.2.3, measured). I6: this repository's own commit-msg hook is still v1.5.0's. I7:
  gitleaks' releases are unsigned, so the SHA-256 pin is trust on first use.
- Found sound, by the agent's runs or reading: the pre-commit and pre-push hooks the two
  installers generate, byte-identical; the commit-msg text, where only the pin expands; the
  commit-msg failing closed (registry unreachable, offline, npx absent, a pin that does not
  exist); the pre-commit failing closed (gitleaks absent 127, SIGSEGV 139, a panic 2); the
  installer's order, nothing written before the check; the check writing nothing and
  exiting 1 exactly on a FAIL, its comparison right on the edge cases under bash 3.2; the
  three SHA-256 values equal to the release's checksums file and verified before
  extraction, only the binary extracted; the test key never whole in a tree, a commit or
  the CI log; 16 written minimums, 0 FAIL.

**The main session's own checks**, in throwaway repositories under the scratchpad:
- H1 through a real `git commit`, the hook `4b3abb9` generates, a staged AWS key built at
  run time: a plain config refuses it ("leaks found: 1"); with `color.ui=always`, with
  `color.diff=always`, and with `git -c color.ui=always commit` the commit IS created —
  "scanned ~0 bytes", "no leaks found", exit 0. The same hook with the prefix refuses all
  three, and `-c color.diff=always` on top of `color.ui=always`; a clean change still
  passes under `color.ui=always`.
- M1 at the source, four tags read: v8.0.0's `git/git.go` and v8.18.1's
  `detect/git/git.go` run `diff -U0 --staged .`; `--no-ext-diff` first in v8.18.2
  (`sources/git.go`); v8.30.1 still without `--no-color`. v8.0.0's `initConfig`, the one
  that writes `.gitleaks.toml`, runs from `protect` and `detect` only: the check's
  `gitleaks version` writes nothing, the hook's `protect` does.
- gitleaks' root `--version`: from v8.19.0 (the agent's table over the 107 tags);
  `gitleaks --version` here prints "gitleaks version 8.30.1".

**Pending: the user's decisions** on H1 (its fix in this release) and on M1 (the floor and
how it is enforced), asked on 2026-10-12 with the gate's verdict to follow.

## Resumption notes
- The branch is public since round 1 (`3b0edca`): no commit is rewritten, every fix is a
  new commit. Every commit after `3b0edca` reaches the CI through the next block 0; block 1
  waits for the final run's green on the three jobs.
- Next: the user's decisions on H1 and M1; then the review's fixes, each red first, one
  commit per area; then block 0 for the new state.
