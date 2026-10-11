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
- [ ] 6. The prerequisites by tool name (`SETUP.md` §0, `hooks-install.sh`'s message, the READMEs): git, bash and a POSIX userland (Git for Windows), GNU make, gitleaks, Node.js 22.12 — commit: —
- [ ] 7. The upgrade 1.4.1 → 1.5.0 rehearsed, LF and CRLF, the renormalisation step measured; the Upgrading note drafted — commit: —
- [ ] 8. The CI's first runs (block 0, the user's pushes): what fails, fixed, until green on the three platforms — commit: —
- [ ] 9. The platform matrix (`README.md`, `SETUP.md`): only what the CI verified — commit: —
- [ ] 10. ONE reviewer + fixes — commit: —
- [ ] 11. `/checkpoint` (the rehearsal re-run on the final payload) — commit: —
- [ ] 12. `/integrate`: the CHANGELOG 1.5.0 entry; blocks 0, 1 and 2 — commit: —

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

## Resumption notes
- The CI runs only on what the user pushes: the first push of this branch comes after
  task 7, so the CI's rounds (task 8) start there. Once pushed, the branch's commits are
  shared history: none is rewritten after it.

## Received for later blocks
- **v1.6.0** (prerequisites and versions): point 7 of IMP-070, the prerequisite check;
  IMP-076, commitlint pinned or not; IMP-077, `gitleaks git` in place of `protect`.
