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
- [ ] 3. commitlint at the pin, read from the one place by `hooks-install.sh`; `SETUP.md` §0 no longer says "latest"; a documentation-check rule holds every written minimum and the pin against the one place — commit: —
- [ ] 4. `hooks-install.sh` runs the check, after its own repository checks and for what the hooks need; its self-test copies the check into its throwaway places, its stubs answer a version — commit: —
- [ ] 5. gitleaks per D1 (B): `protect` stays, 8.0.0 declared; IMP-077 decided, OPEN on its trigger — commit: —
- [ ] 6. The CI per D3: gitleaks at a fixed version and checksum, verified before it runs; the four real-hook cases in `tools/`; the *Versions* step names gitleaks and npx; the real check on each runner; the prose on what the CI installs and runs — commit: —
- [ ] 7. The upgrade 1.5.0 → 1.6.0 rehearsed in throwaway clones, LF and CRLF: the check from `T` before Step 4, the hooks regenerated; the Upgrading note drafted — commit: —
- [ ] 8. The CI's rounds (block 0, the user's pushes): what fails, fixed with new commits, until green on the three — commit: —
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

## Resumption notes
- The branch is local until task 8's first block 0; from then on it is public, and no
  commit is rewritten.
