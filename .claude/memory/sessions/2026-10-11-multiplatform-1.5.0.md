---
date: 2026-10-11
task: v1.5.0 — macOS, Linux and Windows (IMP-070, points 1-6) — a CI on the three platforms outside the payload; line ends (`.gitattributes`, the upgrade check's CRLF tolerance); the PowerShell tool (option C); the prerequisites by tool name; the platform matrix; seven IMPs recorded
branch: feat/multiplatform-1.5.0
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, platforms, ci, tools, imp, plan]
---
# Session 2026-10-11 — v1.5.0: macOS, Linux and Windows

> A dedicated branch from `main` at `db87686` (v1.4.1, its tag signed). Probes only under
> `/tmp`. Hybrid regime: no `plans/`, this note is the plan-pointer. Phase 1 was a
> read-only analysis — no write in the repository, its snapshot identical before and
> after —, presented to the user and decided the same day; phase 2 starts here.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 2` — the user's brief for phase 1, with v1.4.1 integrated and pushed (`db87686`,
  tag v1.4.1 signed; the bump stays a PATCH: the tag is published), and the user's
  decisions on phase 1, which open phase 2.

## The brief — persisted so a /clear does not lose it

### Phase 1 (2026-10-11)
v1.5.0, multi-platform support (IMP-070). Phase 1: analysis only — no write in the
repository, no branch. For each point (1)-(8) of IMP-070: the current state, a
measurement, the options, a recommendation. Plus:
- a complete inventory of the real prerequisites: what uses what, the minimum version,
  the platforms;
- an inventory of the non-portable constructs in the bash scripts, `upgrade-check.sh`
  first (`sed -i`, `grep -P`, `stat`, `date`, `readlink -f`, `mktemp`, paths, CRLF line
  ends), with the number of occurrences;
- `docs-check.mjs` is Node: check that it does not depend on the platform (paths,
  separators, line ends);
- for the CI: the workflow's minimal permissions, third-party actions pinned by full SHA
  and not by tag, the cache, the estimated duration per platform — a minimal CI, nothing
  beyond what `make test-scripts` and the self-tests of `tools/` need;
- the PowerShell tool: check on Claude Code's CURRENT documentation whether PreToolUse
  hooks intercept it, and with which matcher; cite the page.
What cannot be measured on macOS is declared as expected and to be verified in CI, never
as a fact. The delivery: per point, the state, the options and a recommendation; then a
split into releases with the EXPECTED bump of each; then stop.

Registrations, in the first commit of the next branch: the three candidate lessons of the
v1.4.1 note's Retro, as OPEN IMPs; an OPEN IMP (MEDIUM, the process block), "the bump is
fixed by the brief before the content"; an OPEN IMP (MEDIUM), "auto mode and the
framework's boundaries" — weigh whether it belongs to IMP-067. And a principle for
`tools/`, in this note and in `tools/README.md` (below).

### The decisions on phase 1 (2026-10-11), which open phase 2
1. Split: v1.5.0 (points 1-6, and the upgrade check's tolerance of CRLF line ends) and
   v1.6.0 (point 7). The `Makefile` stays.
2. PowerShell: option C.
3. make: a declared prerequisite; in CI, `choco install make` at a fixed version.
4. `.gitattributes` in the payload, class HYBRID, limited to the framework's paths. The
   Upgrading note includes the renormalisation step for working trees already in CRLF —
   MEASURED in the simulated CRLF rehearsal — and never touches the project's files
   outside the framework's paths.
5. The branch is pushed for the CI before `/integrate`: yes, only in `CONTRIBUTING.md`, as
   a "block 0" the user runs (push the branch, wait for green). After the merge, block 2
   deletes the remote branch too. No required checks in `main`'s ruleset: `/integrate`'s
   merge commit is new and would have no CI result, so its push would be refused — written
   in `CONTRIBUTING.md` as a motivated choice.
6. The plan B threshold (below), recorded here and in IMP-070.
7. Node.js: 22.12 is the declared minimum (commitlint imposes it); the CI verifies majors
   22 and 24. No `setup-node`.
8. `sha_pinning_required`: the user enables it in the repository's settings.
Two more OPEN IMPs, placed in v1.6.0 (prerequisites and versions): commitlint is not
pinned; `gitleaks protect` is deprecated — its replacement verified on gitleaks' current
documentation before it is proposed.

Phase 2: a dedicated branch from `main`, probes only under `/tmp`, ONE reviewer. At the
end `/checkpoint` and the `/integrate` blocks — for this release with a block 0 (push the
branch, wait for the CI), since the CI is born here. Merge, tag and push are the user's.

## The principle for `tools/` (the user's, 2026-10-11)
`tools/` holds more than 3000 lines (`upgrade-check.sh` 894, `docs-check.mjs` 1155, their
self-tests 407 and 575): from here on, a new rule in `upgrade-check.sh` or `docs-check.mjs`
answers an OBSERVED defect, never a hypothetical one. `tools/README.md` says so too. In
this release the upgrade check's tolerance of CRLF line ends answers a defect measured in
phase 1's simulated CRLF checkout (below); no new rule is added on prediction alone.

## Plan B threshold (the user's decision, 2026-10-11)
IMP-070 keeps a rewrite of the scripts in Node.js as a plan B, if the tests on Windows
cost too much. The threshold, decided before the first run so the call is mechanical:
the Windows job runs over 30 minutes, or over 5 times the Linux job, steadily for 3
consecutive runs.

## Plan (one commit per task)
- [x] 1. This note and its plan, phase 1's analysis and the decisions; the registrations — IMP-071 to IMP-077, IMP-070 annotated with the decisions and the plan B threshold — and the principle for `tools/` — commit: a787c9a
- [x] 2. The CI: `.github/workflows/test.yml` on ubuntu-24.04, macos-26 and windows-2025 — read-only token, checkout pinned by full SHA, GNU make on Windows at a fixed version; the documents that list what setup does not copy; `CONTRIBUTING.md`: block 0, the remote branch deleted in block 2, no required checks on `main` — commit: f1147f5
- [x] 3. `.gitattributes` in the payload (HYBRID, the framework's paths only) and `tools/.gitattributes`; the upgrade check's payload and classes; `SETUP.md` (the copy list, the classes, Step 2) — commit: 40d6075
- [x] 4. `upgrade-check.sh` reads the project's files whatever their line ends: the CRLF case first, failing (RED), then the fix (GREEN) — commit: cc16df0
- [x] 5. PowerShell, option C: the tool off in `settings.json`, the guard reading `PowerShell` too (`git.exe`, case, backtick continuations), its self-test, `docs/04`, `SETUP.md` *Hardening* — commit: db1fc77
- [x] 6. The prerequisites by tool name (`SETUP.md` §0, `hooks-install.sh`'s message, the READMEs): git, bash and a POSIX userland (Git for Windows), GNU make, gitleaks, Node.js 22.12 — commit: ecd2b8d
- [x] 7. The upgrade 1.4.1 → 1.5.0 rehearsed, LF and CRLF, the renormalisation step measured; the Upgrading note drafted — commit: c22c9b3
- [ ] 8. The line-end step of Step 3 in `SETUP.md`, refusing a change not yet committed on the framework's paths (the user's request after task 7): the case first (RED), then the guard (GREEN) — commit: —
- [ ] 9. The CI's runs (block 0, the user's pushes): what fails, fixed, until green on the three platforms — commit: —
- [ ] 10. The platform matrix (`README.md`, `SETUP.md`): only what the CI verified — commit: —
- [ ] 11. ONE reviewer + fixes — commit: —
- [ ] 12. `/checkpoint` (the rehearsal re-run on the final payload) — commit: —
- [ ] 13. `/integrate`: the CHANGELOG 1.5.0 entry; blocks 0, 1 and 2 — commit: —

The plan was amended after task 7, by the user's request of 2026-10-11: task 8 is new,
the tasks after it move by one, and the commits from task 8 on count 13 (those before,
12). Task 9 may take several commits, one per CI round: each round needs the user's push.

## Phase 1 — the read-only analysis (2026-10-11)
Measured on macOS 27.0.1 (Apple M4 Pro): `/bin/bash` 3.2.57, the BSD userland (grep
2.6.0-FreeBSD, BSD sed and find, Apple diff, bsdtar 3.5.3, awk 20200816), git 2.54.0,
Node.js 26.11.1, GNU Make 3.81, gitleaks 8.30.1. Measured by simulation on macOS: a CRLF
checkout (`core.autocrlf=true`) of the v1.4.1 rehearsal's project. Everything Linux- or
Windows-specific: EXPECTED, from the documentation and the code, to verify in CI.

**Line ends — the finding that shaped the plan.**
- The runner image installs Git for Windows without a `CRLFOption` (`Install-Git.ps1`), so
  the installer's default applies — CRLF checkouts, `core.autocrlf=true`: EXPECTED, the
  CI prints it.
- bash 3.2 on a CRLF script stops at its line 22, `set: pipefail: invalid option name`;
  GNU make 3.81 reads a CRLF `Makefile` (both MEASURED).
- `upgrade-check.sh` on a CRLF checkout of the same, correct upgrade (MEASURED):

  | Subcommand | LF checkout | CRLF checkout |
  | --- | --- | --- |
  | `inventory` | 0 conflicts in every 3-way; the `LEARNINGS.md` header `=vX` | every 3-way at 100% of its lines (`docs/01`: 326 of 326); the header "diverged"; 10 false title CHECKs |
  | `invariant` | 0 FAIL, 0 CHECK | 11 FAIL, 2 CHECK: "the IMP entries changed", 10 titles "still lacking" |
  | `post` | 3 FAIL (the hooks, not installed in a rehearsal) | 11 FAIL: "no hook list found", 10 titles |

  The cause: raw reads of the project's files — the `cmp` of the `LEARNINGS.md` regions,
  `normalise_format` against the restore point's blob, `git merge-file`, and regexes
  anchored at a line's end that meets a `\r`. The classification itself holds:
  `git hash-object -- <path>` applies the line-end conversion. The self-tests run with
  `GIT_CONFIG_NOSYSTEM=1`, so the runner's `core.autocrlf` never reaches their fixtures:
  the CI alone would not see this — a CRLF case is needed.
- `docs-check.mjs` already reads CRLF alike (`text()` and `blob()` normalise; its
  self-test's CRLF case passes).

**The PowerShell tool — Claude Code's documentation, read on 2026-10-11 (local 2.1.296).**
- https://code.claude.com/docs/en/hooks, PreToolUse input, *PowerShell*: the same fields
  as Bash (`command`, `description`, `timeout`, `run_in_background`); "Match
  `Bash|PowerShell` in hooks that inspect shell commands"; on Windows without Git Bash,
  Claude Code does not register the Bash tool at all.
- The same page, *Exec form and shell form*: a command hook runs with `sh -c` on macOS and
  Linux, Git Bash on Windows, PowerShell when Git Bash is not installed.
- https://code.claude.com/docs/en/tools-reference, *PowerShell tool*: on automatically on
  Windows without Git Bash; on by default with Git Bash for claude.ai and Console
  accounts; opt-in on Linux, macOS and WSL. *Bash deny rules also turn off the PowerShell
  tool*: on Windows with Git Bash, any Bash deny rule — a scoped one like
  `Bash(git push *)` included — turns the PowerShell tool off for the session, silently,
  unless `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` or a scoped PowerShell rule is set. The
  Monitor tool on Windows: only with Git Bash.
- So in a framework project on Windows with Git Bash the PowerShell tool is already off —
  by a side effect of the deny rules. The guard's matcher is `Bash|Monitor`; it compares
  `basename(word)` with `git`, missing `git.exe` and `Git`, which run on Windows (and
  `Git` on a case-insensitive APFS too). The Windows runner's shells include
  `C:\Windows\System32\bash.exe`, WSL's: from PowerShell, `bash` can be WSL.

**The constructs of the bash scripts** — code lines, full-line comments skipped, the nine
bash files and the `Makefile`:
- zero: `sed -i`, `grep -P`, `stat`, `readlink` (`-f` or not), `realpath`, `mktemp -t`,
  `find -printf`/`-perm`/`-E`, `sort -V`, `head -n -N`, `tail -r`, `tac`, bash 4+
  features, `echo -e`/`-n`, `LC_ALL`, `/proc`, `timeout`, `perl`, `python`, `jq`,
  `uname`;
- portable as used: `mktemp -d` 5, `date +%Y-%m-%d` 1, `sed` (BRE) 8, `grep` 45 (`-o` 5),
  `awk` 27 (21 in `upgrade-check.sh`, no gawk-only function), `find` 5
  (`-mindepth`/`-maxdepth`/`-prune`), `xargs -0` 4, `sort` 6, `wc` 11 (always through
  `tr -d ' '`), `cp -R`/`-L` 2, `tar` 2 (`--null -T -` 1), `diff`/`cmp` 25;
- different on Windows: `[ -x ]` for a file's mode 2 (`upgrade-check.sh` 486, 814),
  `chmod -x` expected by a self-test 1 (`test-upgrade-check.sh` 374), `ln -s` 3 (a
  dangling link in `test-hooks-install.sh` 58; PATH fixtures in `test-agent-git-guard.sh`
  203-204), `env -i` 2 (`test-agent-git-guard.sh` 75: no `SystemRoot` for `node.exe`).
- Executables: 11, all with a shebang; no symlink; no `.gitattributes`.

**The prerequisites, as used.** git 2.31 (`rev-parse --path-format`); bash 3.2 (all the
scripts, the generated hooks); a POSIX userland (the commands above); Node.js — the guard
14.13.1, `docs-check.mjs` 18, commitlint 21.2.3 `>=22.12.0` (npm registry), so 22.12 in
effect; npx (the first commit downloads commitlint, unpinned); gitleaks 8 (`protect
--staged`, hidden from `--help` in 8.30.1, the latest release); GNU make (`$(if)`); tree,
optional; on Windows, Git for Windows (bash, the userland, the hooks' shell) and a GNU
make of its own. `SETUP.md` §0 named git, gitleaks ("macOS: `brew install gitleaks`"),
Node.js with npx, tree and Obsidian — not bash, make, the userland, nor Windows.

**`docs-check.mjs`** does not depend on the platform: repository paths only through
`posix.*`, the filesystem only through `join(ROOT, p)` with `ROOT` from git, line ends
normalised, no `shell`, `/dev/null`, `os.EOL` or `localeCompare`; on Windows it needs
`git.exe` on the PATH, which Git for Windows provides.

**The `Makefile`** (point 8): four targets — `help`, and short names for three scripts
(`hooks-install`, `reset-task`, `test-scripts`) —, the `PROTECTED_BRANCHES` setup slot and
the project's own targets; `make <target>` in 42 lines of 15 present documents; without
make, `reset-task.sh` falls back to the example defaults, and refuses `--yes`.

**The CI's facts.** The repository is public (free standard runners); Actions enabled, no
workflow, the token's default permission read, `sha_pinning_required` false. The images
(actions/runner-images, October 2026): `ubuntu-latest` = 24.04 (bash 5.2.21, git 2.55.0,
Node.js 22.23.3, make 4.3, dash as `/bin/sh`); `macos-latest` = `macos-26` arm64 (bash
3.2.57 only, git 2.55.0, Node.js 24.20.0, make from Xcode's tools: expected);
`windows-latest` = `windows-2025` (Git 2.55.0.windows.5, Git Bash 5.3.15, Node.js 22.23.3,
NO make, Chocolatey 2.7.4). Pins: `actions/checkout` v7.0.1 =
`3d3c42e5aac5ba805825da76410c181273ba90b1` (a lightweight tag: a commit SHA); Chocolatey's
`make` 4.4.1 (a community package, approved 2023-05-24). Local durations:
`test-hooks-install` 3 s, `test-agent-git-guard` 24 s, `test-repo-snapshot` 2 s,
`test-docs-check` 93 s, `test-upgrade-check` 34 s, `docs-check` 1 s — about 157 s;
expected on the runners: Linux 4-6 min, macOS 5-8 min, Windows 15-30 min. No cache: there
is nothing to install (gitleaks and npx are stubs in the self-tests); the checkout needs
the full history and the tags.

## Line ends in the upgrade check (task 4) — RED, then GREEN
- The case first: `tools/test-upgrade-check.sh`, case 6, rebuilds the graft, the upgraded
  memory (with a guide README of its own, so a template's diff is printed) and the
  reconciled project in two copies — one with LF, one with every file in CRLF and
  `core.autocrlf=true` — and demands the very same output. Against the unchanged check it
  failed at once: every 3-way of `inventory` at 100% of its lines, the `LEARNINGS.md`
  header "diverged" instead of `=vX` (RED).
- The fix: one function, `lf`, reads the project's text without `\r`, at the nine places
  where a `\r` changed a verdict or a printed line — the titles, the `LEARNINGS.md`
  regions, the 3-way's own side, a note normalised, a template's diff, the markers shown,
  the hook list. git's own reads (`hash-object`, `diff`) already convert line ends and
  stay as they are. All seven cases pass (GREEN).
- Each of the nine sites, put back to its raw read in turn, fails the self-test (9 of 9;
  the control passes). The first campaign found the template's diff unexercised — no
  template differed from `vY`'s in the case's state —, hence the guide README of its own.
- `old_labels`, the marker counts and the conflict and broken-marker greps were left as
  they are: anchored at a line's start or counting inside a line, a `\r` does not reach
  them.

## PowerShell, option C (task 5)
- Built and tested in a copy under the scratchpad first, so the two files of the boundary
  were written once each through the file tools — one `ask` approval each — and compared
  byte for byte with the tested copy.
- `settings.json`: `CLAUDE_CODE_USE_POWERSHELL_TOOL=0` in `env`, the matcher
  `Bash|PowerShell|Monitor`. The guard: the tool list, PowerShell's escape (the backtick,
  a backslash ordinary), `commandName` (the last path component after `/` or `\`, lower
  case, without `.exe`), CRLF read as LF. Its self-test: 10 writes and 7 reads through
  PowerShell, three spellings of git through Bash, the main session free through
  PowerShell, the matcher and the `env` key checked.
- Each piece undone in turn fails the self-test: the tool list, the PowerShell mode,
  the case, `.exe`, the `\` separator, the CRLF normalisation, the matcher, the `env` key
  (8 of 8; the control passes). The CRLF case first survived: its `\r` stuck to an
  argument (`-1`), which decides nothing; it now sticks to the subcommand (`git log` at a
  line's end), which a raw read would take for a write.
- Documented, not measured: that Claude Code honours the `env` key and calls the hook
  with `tool_name: "PowerShell"` — the CI does not run Claude Code; the guard's reading of
  PowerShell's text is measured, on every platform.

## The upgrade 1.4.1 → 1.5.0 rehearsed, LF and CRLF (task 7)
A clone of this branch's tip, tagged v1.5.0 in the clone only (a draft CHANGELOG entry
inserted); a project grafted at v1.4.1 — its memory emptied, `checkpoint.md` answered, a
pin, files of its own outside the framework's paths (a `.bat` kept CRLF by its own
attribute, notes) —, cloned as it is (LF) and with `core.autocrlf=true` (a Windows
checkout: every text file CRLF), with and without a `.gitattributes` of its own.
- **The renormalisation step, measured** on fresh CRLF clones: after `vY`'s
  `.gitattributes` is brought in, `git rm --cached -r -q -- <the framework's paths>` then
  `git checkout HEAD -- <the same paths>` leaves 0 of 37 framework files with CRLF, the
  project's own files byte for byte as they were, `.gitattributes` untracked or staged
  alike. A plain `git checkout -- <paths>` rewrites NOTHING (37 of 37 still CRLF, staged or
  committed attributes alike): git takes the files for up to date. Touching them first does
  not help either. A first measure had shown the plain checkout working — an artefact: the
  copy made with `cp -R` had stat data unknown to the index, so git rewrote every file;
  only fresh clones measure what a project meets.
- **The whole upgrade**, both projects: `preflight` 0/0; `inventory` 0 FAIL — with a
  `.gitattributes` of its own, 1 CHECK, "new in v1.5.0, but the project already has a file
  there"; the line-end step (CRLF only); METHOD files copied; the 3-way of `settings.json`
  and `hooks-install.sh` with 0 conflicts; a commit; `invariant` 0/0; `post` the 3 hooks a
  rehearsal does not install and the pin. The four checks' outputs are the same, line for
  line, on the LF and the CRLF project — `inventory` run there BEFORE the renormalisation,
  on CRLF files.
- The Upgrading note is drafted on these measures (the scratchpad's draft, inserted at
  `/integrate`).

## The line-end step guarded (task 8)
The user's request after task 7: `git checkout HEAD -- <the framework's paths>` overwrites
what those paths hold, so the procedure must refuse a change not yet committed there,
with a case in a self-test.
- The step moved into `SETUP.md`, as the first point of Step 3 (*Line ends, first*): the
  Upgrading note now points there, and a self-test can read the block where the
  procedure keeps it — `tools/test-upgrade-check.sh`, case 7, never retypes it.
- RED first: the step as task 7 measured it ran on a tree with an uncommitted edit of
  `CLAUDE.md`; run by hand on a CRLF clone, it erased the edit — 1 line before, 0 after —,
  and `git status` showed nothing left to see: a silent loss.
- GREEN: the block refuses, rewriting nothing, while `git diff --quiet HEAD` finds the
  framework's files different from the last commit. The case: on a CRLF clone, a clean
  tree — 0 framework files left with CRLF, the project's own file untouched —; an edit
  unstaged, staged, staged only (the file back to the commit's text) — refused each time,
  the edit and the staged entry kept, nothing rewritten.
- The guard had a second half, `git diff --cached --quiet`, for a change only staged.
  Mutated, it changed nothing: `git rm --cached` itself refuses an index entry that
  differs from both the commit and the file. It was removed; the staged-only case stays,
  measuring git's own refusal. Without the first half, the self-test fails (the unstaged
  edit).

## The CI's runs (task 9)
**Round 1** — run 38154275640, on task 7's commit `c22c9b3`, pushed by the user:

| Image | Result | Time | Measured versions |
| --- | --- | --- | --- |
| ubuntu-24.04 | green: `make test-scripts`, the upgrade check's self-test | 68 s | bash 5.2.21, git 2.55.0, Node.js 22.23.3, GNU make 4.3, GNU awk 5.2.1 |
| macos-26 | green, the same two | 128 s | bash 3.2.57, git 2.55.0, Node.js 24.20.0, GNU make 3.81, BWK awk 20200816 |
| windows-2025 | red at once: `test-hooks-install.sh`, case 1 — `ln: failed to create symbolic link '…/.git/hooks/pre-commit': No such file or directory` | 23 s | Git Bash 5.3.15, git 2.55.0.windows.5, Node.js 22.23.3, GNU make 4.4.1 (Chocolatey), GNU awk 5.4.1 |

- Measured now, expected in phase 1: on the Windows runner `core.autocrlf` is `true`, from
  `C:/Program Files/Git/etc/gitconfig`; and the scripts ran — no `\r` error —: task 3's
  `.gitattributes` holds.
- Not mawk: Ubuntu's runner resolves `awk` to GNU awk, so the BWK/mawk worry of phase 1 is
  moot there.
- Fixed: the case plants a dangling link with `ln -s`, which Git Bash cannot do. It is now
  skipped there, said aloud (`SKIP (dangling symlink): …`), and the install still runs for
  the cases after it; checked on macOS with an `ln` failing as Git Bash's does.
- `make` stops at the first failing self-test: the rest of Windows stayed unseen. The
  workflow now runs each self-test on its own after a failure (skipped when all pass), and
  the upgrade check's self-test even after one — a single run shows every failure.

**Round 2** — run 38155280825, on `5d50879`: ubuntu-24.04 green (64 s), macos-26 green
(148 s), windows-2025 red (61 s) — four failures, all shown in one run by the new step:
1. `test-hooks-install.sh`: past the SKIP, `hooks-install.sh` itself refused the
   repository ("… is not inside a git repository, or git is older than 2.31"). git prints
   its paths as `C:/…`, Git Bash names the same directory `/c/…`: the script took git's
   answer for a relative path and compared the top level as a string. A product defect —
   `make hooks-install` failed in every project on Windows. Fixed: both forms of an
   absolute path accepted, the top level compared by identity (`-ef`).
2. `test-agent-git-guard.sh`: `/usr/bin/git rebase main` went unblocked. Not the guard:
   the self-test passed the command to `node.exe` as an argument, and Git Bash rewrites an
   argument that looks like a POSIX path (`C:/Program Files/Git/usr/bin/git …`, which the
   guard reads as the command `C:/Program`); Claude Code hands the hook its input on
   stdin. Fixed in the self-test: the command travels on stdin.
3. `test-docs-check.sh`, its CRLF case: on Windows the files outside `.gitattributes`
   are already CRLF, and the case added a second `\r`. Fixed: an idempotent conversion.
   The check itself, run on the Windows checkout by the new step: 0 FAIL, 0 CHECK.
4. `test-upgrade-check.sh`: "run it from the project's root (C:/Users/…), not from
   /c/Users/…" — the same two forms, a product defect of the check taken at the tag. Fixed:
   wherever a directory git names meets one the shell names — the project's root, the
   framework's clone against the project, T outside both, the running copy outside the
   framework's working tree — by identity, walking up for containment; the git-version
   test of the same function accepts `C:/…`, its next failure otherwise.
- Passed on Windows: `test-repo-snapshot.sh`, the upgrade self-test's classes case.
- Checked on macOS before the push: `within` and `-ef` across `/var/…` and `/private/var/…`,
  two names of one directory, positive and negative; the whole suite green.
- macOS ends about two minutes after the other two in both rounds: a run is concluded
  when its last job is.
- One commit of this round opened its body with "was:" — commitlint read it as the footer
  (IMP-078). It was still local: the two commits were written again from `29899f4`, the
  tree identical (`71c9b62` and `5ca1325` replaced by `4aa5bd2` and `7d51bde`).

**Round 3** — run 38156691732, on `ded0fbb`, awaited and read with `gh` until all three
jobs had concluded (the user's instruction from this round on): ubuntu-24.04 green (52 s),
macos-26 green (155 s), windows-2025 red (194 s).
- Confirmed on Windows: the fix of `hooks-install.sh` (its self-test passes past the SKIP —
  the push boundary, the hooks' directory); the upgrade check's identity comparisons (its
  `classes` and `preflight` cases pass); the guard classes every write and read of its
  self-test right, through Bash and PowerShell, with `node.exe` started under `env -i`,
  no `SystemRoot` — phase 1's worry, measured groundless; the documentation check on the
  checkout, 0 FAIL.
- Failed, and fixed:
  1. The guard's self-test, "node missing": its PATH held a `cat` made with `ln -s`, which
     Git Bash copies away from the DLL it loads ("error while loading shared
     libraries"). Now a two-line wrapper that runs the real `cat`.
  2. The documentation check's self-test, its CHANGELOG case: the edit pattern
     `^## \[Unreleased\]\n\n` met a CHANGELOG with CRLF line ends. Its edits now read the
     files as LF.
  3. The upgrade check's self-test, `inventory`: the CHECK on `reset-task.sh`'s mode never
     came. NTFS keeps no executable bit — `chmod` changes nothing, Git Bash takes any
     script with a shebang for executable, git commits the index's mode (`core.fileMode`
     false) —, and both sides were wrong: the fixture's v1.1.0 recorded 100644, the check
     read every script as 100755. The check now reads the index where git does not trust
     the filesystem (`mode_of`, probed on macOS on both branches), the fixture sets the bit
     in the filesystem and in the index (`set_exec`), and `SETUP.md`, Step 3, gives the
     Windows form, `git update-index --chmod=+x`.
- The local suite green on macOS before the push.

**Round 4** — run 38157635041, on `39a142e`: ubuntu-24.04 green (69 s), macos-26 green
(229 s), windows-2025 red (290 s).
- On Windows `make test-scripts` passes for the first time: the three script self-tests
  (the dangling-symlink case skipped), the documentation check's self-test and the check.
  Six of the upgrade check's eight cases pass there: classes, preflight, inventory,
  invariant, post, line ends.
- The seventh, the line-end step, stopped at its own precondition: "the clone has no CRLF
  framework file to rewrite". It counted with `grep $'\r$'`, which on Windows read none in
  a clone made with `core.autocrlf=true`. Whether that clone had no CRLF, or grep did not
  see them, that run does not settle. The count now asks git — `git ls-files --eol`,
  `w/crlf`, read from the bytes; on macOS 37 of 37 in such a clone —, and the next round
  settles it.
- Plan B's threshold: Windows took 290 s, 4.2 times Linux's 69 s — below 5 times and far
  below 30 minutes.

## Resumption notes
- The CI runs only on what the user pushes: the first push of this branch came after
  task 7 (round 1, below). The branch is public from then on: no commit is rewritten,
  every fix is a new commit.

## Received for later blocks
- **v1.6.0** (prerequisites and versions): point 7 of IMP-070, the prerequisite check;
  IMP-076, commitlint pinned or not; IMP-077, `gitleaks git` in place of `protect`.
