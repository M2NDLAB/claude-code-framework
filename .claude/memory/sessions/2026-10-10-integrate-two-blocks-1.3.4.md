---
date: 2026-10-10
task: v1.3.4 — the /integrate block in two parts, the push after the checks (IMP-069), and the tag's signature verified when tags are signed (IMP-066); the reconciliation after v1.3.3 and the cycle's plan
branch: fix/integrate-two-blocks-1.3.4
status: in-progress
model: 'claude-opus-5-5'
turns: 1
tags: [session, integrate, git, imp, plan]
---
# Session 2026-10-10 — v1.3.4: /integrate in two blocks

> A small deliverable before v1.4.0, on this branch from `main` at `4fbd063` (v1.3.3).
> Probes only under `/tmp`. Hybrid regime: no `plans/`, this note is the plan-pointer —
> and, below, the reconciliation the user asked for "in STATE" (see the first section).

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 1` — the user's message with v1.3.3's integration, the decisions on its open
  points and the v1.3.4 go-ahead.

## Reconciliation after v1.3.3 (the first commit, as the user asked)
- **Where it lives.** The user asked to realign "STATE and the branches in the memory" in
  the first commit, without a `/checkpoint` on `main` (no direct commits there). In this
  repository `STATE.md`, `TREE.md` and `INDEX.md` stay CLEAN TEMPLATES — the hybrid regime
  of `CONTRIBUTING.md`: they are copied into every project, so the framework's own state
  would ship with them. The state lives here, in the session note, as in every earlier
  post-integration reconciliation; the templates are not touched. If the user wants the
  regime changed, that is a Level 2 proposal of its own.
- **Integration.** The user merged `fix/upgrade-safety-1.3.3` into `main` (`4fbd063`),
  tagged **v1.3.3** (annotated and signed: `git tag -v` gives a good signature) and pushed
  both; the feature branch is deleted. `git describe`: `v1.3.3-0-g4fbd063`.
- **Branches.** `main` = integration and stable (trunk-based). `fix/integrate-two-blocks-1.3.4`
  = this deliverable. `feat/english-translation` is a leftover LOCAL branch, merged into
  `main` since v1.1.0 (`git branch --merged main`): deleting it (`git branch -d`) is the
  user's call.
- **Tag signing on the user's machine.** `tag.gpgSign` and `commit.gpgSign` are true in
  the global config (OpenPGP): v1.3.4's block will carry `git tag -v`.

## The user's decisions on v1.3.3's open points (2026-10-10)
- **IMP-047 — the interpretation is confirmed.** The criterion: "a release is what
  reaches the consumers" — the payload AND the files read at the tag during graft and
  upgrade (`SETUP.md`, the CHANGELOG, the verification script). The paragraph of
  `CONTRIBUTING.md` stays as it is.
- **v1.3.3's bump stays a PATCH** (fixes to a defective procedure); the tag is published.
- **The IMP field labels ("Origin", "Observed problem", …) are FORMAT, like the titles.**
  They are renamed at the upgrade with the same table. Constraint: the verification
  script's "LEARNINGS body unchanged" check compares the body AFTER normalising the labels
  by the table, or the mandatory rename makes it fail. To measure on the client project
  (read-only, `git -C`): how many label lines are involved. In v1.4.0.

## The cycle (the user's plan, 2026-10-10)
v1.3.4 (`/integrate` in two blocks + the signature) → v1.4.0 (the upgrade, structural) →
v1.4.1 (payload purity and the mechanical checks) → v1.5.0 (multi-platform) → the block
on the security gate's lenses → the process block → the mechanical verification of the
documentation → the client project's upgrade, as the acceptance test → the next project
(named by the user; external names stay out of the repository).

## Received for later blocks — persisted so a /clear does not lose them
- **v1.4.0 (MINOR)**, per the decisions of [[2026-10-10-upgrade-safety-1.3.3]]: IMP-046
  with the closed list of allowed touches; the verification script outside the payload;
  the per-file strategy driven by measurement; the marker comparison; IMP-037 re-scoped;
  the "No automation" box updated; the *Upgrading* notes collected ("same topic: the most
  recent wins; different topics: they add up"); the mandatory rename of titles AND field
  labels, with the content/format line of rule 9; no "Slots changed" field; STATE, TREE
  and INDEX out of the 3-way; an explicit error on the pin; the "reaches the consumers"
  criterion. Its FIRST commit records as OPEN the multi-platform IMP below. A dedicated
  branch from `main`; probes only in `/tmp`; the client project only read, with `git -C`.
  The script is born with its self-tests, including the one that fails when a payload file
  has no class; it is tried, read-only, on the real history of the client project's three
  upgrades. ONE reviewer; `/checkpoint` and the printed `/integrate` block; merge, tag and
  push are the user's.
- **The multi-platform IMP, to record in v1.4.0's first commit** — "Multi-platform
  support: macOS, Linux, Windows", priority HIGH, a dedicated MINOR release v1.5.0 after
  v1.4.1. Origin: the user's requirement of 2026-10-10; today the framework is tested on
  macOS only, and the prerequisites prescribe `brew install gitleaks` (an agnosticism
  leak). From Claude Code's documentation: on native Windows, with Git for Windows the
  Bash tool uses Git Bash; without it, commands go through the PowerShell tool, which the
  delegated-agent guard does not intercept — the read-only boundary falls (the `pre-push`
  holds: it is a git hook). Direction decided: (a) a POSIX environment on Windows too,
  through Git for Windows (needed for git anyway); NO twin bash/PowerShell scripts; a
  rewrite in Node only as plan B, if the tests on Windows show excessive costs. To do:
  (1) GitHub Actions CI on macOS, Ubuntu and Windows running `make test-scripts`, in the
  framework repository and OUTSIDE the payload, with minimal permissions; (2) fix what
  fails; (3) `make` on Windows — a declared prerequisite, or targets runnable as scripts;
  (4) the PowerShell tool — check the current documentation for whether a PreToolUse hook
  can intercept it; if yes, extend the guard; if not, the framework requires the Bash
  tool and says so in *Hardening*; (5) a platform matrix in the README and `SETUP.md`,
  only with what the CI verifies; (6) the prerequisites name the tools, not the package
  managers; (7) a prerequisite check — a script runnable WITHOUT make (`bash scripts/…`)
  that checks git, bash, Node (minimum version), gitleaks, make and whatever else is
  needed; when something is missing it prints the install command for the detected
  platform and exits with an error; it installs NOTHING (installing system software stays
  a human action); called from `SETUP.md` (graft and upgrade) and from `hooks-install`;
  (8) measure what the Makefile is for today: if it only gives short names to scripts,
  weigh dropping make from the prerequisites. v1.5.0 starts with a read-only phase 1, like
  the other blocks.

## Plan (one commit per task)
- [x] 1. The reconciliation after v1.3.3, the user's decisions, the cycle's plan, this plan — commit: c0b131a
- [x] 2. Record IMP-069 (approved, applied in this release): the `/integrate` block is copied whole, so the pause before the push does not happen — commit: a4ca575
- [x] 3. `/integrate` prints two blocks — local work ending with the checks, then the publication — with `git tag -v` only when tags are signed (IMP-066); `docs/04` and `docs/00` aligned — commit: ca47c4d
- [x] 4. ONE reviewer + fixes — commit: (this one)
- [ ] 5. `/checkpoint` — commit: —
- [ ] 6. `/integrate`: the CHANGELOG 1.3.4 entry; the block printed in the new format — commit: —

## Rehearsals (task 3) — throwaway repositories under `/tmp`, no push
- Block 1 as printed, on a bare `file://` remote seeded by a bare clone (no push at all):
  `N` = the branch's commits + 1 matched the count after the merge (4 for 3 commits).
- `git config --type=bool --get tag.gpgSign` prints `true` for `yes`, nothing when unset.
- Signatures, with a throwaway SSH key only (never the user's): a good signature exits 0;
  an unsigned annotated tag gives `error: no signature found`, exit 1; an SSH signature
  without `gpg.ssh.allowedSignersFile` exits 1. On the user's machine gpg answers in
  Italian ("Firma valida"): hence a marker echoed on the exit code, not a text to read.
- A first rehearsal command was refused by the session's permissions: it seeded the
  remote with a `git push` to the local bare repository. Redone without any push.

## Review (task 4) — one reviewer, dispositions
One independent reviewer over `4fbd063..ca47c4d` and the CHANGELOG draft, about eleven
minutes; both repositories identical before and after. Verdict: not ready — one HIGH,
two MEDIUM, in step 4 of `/integrate`. Its scratch directory under `/tmp` could not be
removed by it (its `rm` was refused); it is left for the user.

| Finding | Severity | Disposition |
| --- | --- | --- |
| F1 — block 1 pasted whole runs `git tag -a` after a failed rebase, checkout or merge: the tag lands on the wrong commit, and a later re-paste passes every check named while block 2 publishes the stale tag | HIGH | REPRODUCED in `/tmp` (after a rebase conflict the loose lines tagged the upstream commit; the chain created no tag). FIXED: the constructive lines are one `&&` chain ending with a marker; the tag check is the tag ON the integration tip; the recovery block covers a tag left by a failed paste; `/integrate` checks the tag is free and recognises its own tag from an earlier paste |
| F2 — block 2 not gated: a refused branch push still pushed the tag | MEDIUM | FIXED: `git push --atomic origin <integration> <tag> && git branch -d <feature>` (from git's documentation; not rehearsed: no push in this session) |
| F3 — a `#` in zsh with default options is not a comment: a trailing `# expected: N` broke the count | MEDIUM | CONFIRMED, and wider: the user's own zsh has `interactivecomments` off, so every comment line of the earlier blocks printed `command not found: #`. FIXED: no comment line inside the blocks, explanations around them; each check prints a fixed line; rehearsed in `zsh -f -i` |
| F4 — IMP-066 and IMP-069 still OPEN; IMP-066's slot-or-config choice unrecorded | LOW | In the checkpoint (task 5), as planned |
| F5, F6, F7 — the header's "only steps 1-2"; `N` from `HEAD`, no fallback without a remote; the release variant undefined (its block 2 would delete the integration branch) | LOW | FIXED |
| F8 — "the block" where it became wrong (`integrate.md` step 2, `docs/04` on `git describe`) | LOW | FIXED; the mentions that name the mechanism stay |
| F9 — a legitimate count mismatch had no next step | LOW | FIXED: the line says to repair and run `/integrate` again |
| F10 — "the tag is TYPED by hand" against a block pasted whole | LOW | FIXED in `docs/04`: pure ASCII, printed so by the agent |
| F11 — `git log` may open a pager mid-paste | INFO | FIXED: `git --no-pager log` |
| F12, F13, F14 — the CHANGELOG draft (the signature under Fixed, the upgrade note, the preamble); the note's sha and rehearsals; the checklist's wording | INFO | FIXED |

