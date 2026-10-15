---
date: 2026-10-15
task: v3.0.0 — the retro of a test project's harvest (IMP-107..121) decided and applied, the framework's commands moved under the fw namespace, the claims of the allow list and of selective loading made true
branch: feat/harvest-retro-3.0.0
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, retro, imp, plan, security-gate]
---
# Session 2026-10-15 — v3.0.0: the test project's harvest, and the fw namespace

> A dedicated branch from `main` at `a45fab2` (v2.2.0 and the harvest's recording). Hybrid
> regime: no `plans/`, this note is the plan-pointer. Phase 9 of the cycle; the retro's
> phase 1, read-only on `main`, the same day; then the user's decisions.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session; the retro's phase 1 was delegated to nine
  read-only agents on the same model.
- `turns: 2` — the retro's brief; the user's decisions.

## The brief — persisted so a /clear does not lose it
- Phase 9: a release of the framework with the entries a test project harvested, IMP-107 to
  IMP-121 ([[2026-10-14-test-project-harvest]]). Phase 1 read-only, no file changed: check
  that `main` is at `a45fab2`, aligned with `origin/main`, the tree clean; a retro of the
  fifteen entries — for each, apply it in this release, defer it on a precise trigger, or
  reject it, always with the reason. Priority: the next phase is the upgrade of an existing
  project to the new version, so the entries that touch the upgrade path (the classes of
  file, the slots, the markers, `upgrade-check.sh`) come first, then the greenfield graft's.
  IMP-117 repeats the violation of a rule already applied (IMP-075): say also why that rule
  was not enough. IMP-111: no definitive rule yet — it must first be measured in manual
  mode and narrowed for the P1 note. The bump, MINOR or PATCH, by the rule on the content
  (IMP-074). A table — entry, proposal, reason, files touched —, then stop.

## The retro — phase 1 (read-only, on `main` at `a45fab2`)
- The state: `main` = `origin/main` = the live remote (`git ls-remote`, no fetch) =
  `a45fab2`, 0 ahead and 0 behind, the tree clean.
- One workflow of nine read-only agents: four themed analysts — A, classes and markers
  (IMP-115, 118, 114); B, framework reads (108, 111, 112); C, setup writes, commands and the
  cycle (117, 116, 121, 119, 120); D, the greenfield graft (107, 113, 109, 110) —, each
  followed by an adversarial verifier, then a synthesis of couplings, order and bump. Their
  brief quoted the user's request verbatim; the snapshot before and after was identical, the
  tree clean; 9 of 9 agents done in about an hour.
- Their full structured output — every claim with its evidence, the verifiers' corrections,
  the synthesis — is kept verbatim beside this note, in
  `2026-10-15-harvest-retro-3.0.0-agents.txt`: a copy of the whole file (`cp`, checked with
  `cmp`), not an edit.
- The outcome proposed: 13 to apply, IMP-111 and IMP-112 deferred, none rejected — with the
  forms of IMP-110, 113 and 118 different from the entries'. The bump proposed: a MINOR by
  the content (now a MAJOR: the decisions below).
- Checked by the main session at the source, after the agents:
  - ten memory-only commits went straight onto `main` — `c97118b`, `63a306b`, `bf83956`,
    `1c39166`, `9d41511`, `86ca886` and the four post-integration checkpoints of July,
    `95e43bd`, `d8d4036`, `b576f37`, `21ab017` —, two records through a branch, `ec59010`
    and `a45fab2`: the agents had found six;
  - `integrate.md` holds 40 branch placeholders on 28 lines and no word of trunk-based;
  - the marker counts by tag: the `Makefile` holds 2 up to v1.3.1 and 3 from v1.3.2, when
    the protected branches' slot moved in from `reset-task.sh` (1, then 0); a mention removed
    at the `Makefile`'s line 4 would bring it back to 2, so inventory's net count would hide
    that slot from a `vX` before v1.3.2;
  - the only `- Destination: framework` line of `LEARNINGS.md` is the format comment's, which
    `/harvest-framework` excludes;
  - the shipped allow list (`git diff:*`, `git log:*`, `tree:*`), and `CLAUDE.md`'s
    `@`-imports of the seven docs and `STATE.md`;
  - the documentation check: 0 FAIL, 0 CHECK, 40 markers in the full form.
- Beside the brief, found by the agents: the shipped allow list admits writes
  (`git diff --output`, `git log --output`, `tree -o`) and a read past the `Read` deny
  (`git diff --no-index`), against `docs/04`'s "only read-only commands"; `docs/00`'s
  *Selective loading* says what the `@`-imports do not do; the guard lets
  `git grep -O<cmd>` through and refuses `git --man-path 2>/dev/null`.
- Coverage gaps, declared: nothing that writes was run — no `git merge-file`, no suite, no
  documentation check on an edited text —, so every conflict predicted is line arithmetic on
  IMP-088's measured rule; the test project's own records and the project upgraded next were
  not available to the agents; Claude Code's pages were not re-read (IMP-105's caution);
  git was read in its 2.54.0 man pages only; the archive was measured list-only, on macOS;
  IMP-086, 104, 105 and 106 were outside the brief.

## The decisions (the user's, 2026-10-15)
1. Scope: all 13 entries to apply, in this release.
2. IMP-118: variant Y — `docs/04`'s two slot-shaped lines (the branching-model pointer and
   the stack's commands for `allow`) stay slots; inventory's *Markers* section compares the
   marker lines, not the net counts per file.
3. IMP-117: a rule 10 in `CLAUDE.md`, short, pointing to `docs/04`'s *Operating rules for
   Claude Code*. Not in *Persistent memory*: it concerns every file setup copies, not the
   memory alone.
4. IMP-110: form A, the empty initial commit BEFORE §1. Cover also a remote that already holds
   an initial commit made by the forge's web interface (a README or a licence): start from
   that commit.
5. IMP-119 and IMP-120: a branch whose diff touches only `.claude/memory/**` is exempt from
   the gate and from `/retro`, and is integrated with the no-tag block and the CI green; the
   criterion is mechanical, on the diff. With any other file, the full cycle.
   `CONTRIBUTING.md` adopts the same rule.
6. IMP-111 and IMP-112: measured after the tag, in a dedicated session; candidates A and B
   first, C only if they fail S2. The next upgrade runs with the confirmations.
7. The project upgraded next (phase 10) is read read-only to derive its branching model and
   how it answered the lines the retro cites; nothing is written there. Its pin reads `1.2.0`,
   without the `v`. The rehearsal's fixture is synthetic: the form of its case, no name and no
   content of the project.
8. A new entry, recorded as an IMP and applied in this release — command name collisions
   (IMP-122):
   - Facts, the user's reading of Claude Code's documentation on 2026-10-15 (the skills page,
     *Resolve skills that share a name*; the commands page): a project command with a
     built-in command's name replaces it; for aliases, the documentation says the built-in
     stays reachable through the alias. `/security-review` is built in, and Claude can invoke
     it through the Skill tool; `/checkpoint` is a built-in alias of `/rewind`.
   - Measured by the user, in a throwaway folder, Claude Code v2.1.299: `/checkpoint` runs the
     framework's command, which hides the `/rewind` alias — a behaviour the documentation
     does not state, which may change —; `/security-review` runs the framework's command,
     which hides the built-in one. The framework hides two of Anthropic's commands in every
     project that uses it, and the user does not notice.
   - Decision: every framework command moves into the `fw` namespace,
     `.claude/commands/fw/<name>.md` → `/fw:<name>`, so a collision is impossible by
     construction, both ways; check that `fw` collides with nothing. Names and references
     change, not the commands' logic: `CLAUDE.md`, `.claude/docs/*`, `README.md`,
     `SETUP.md`, `CONTRIBUTING.md`, the tests, the scripts, `upgrade-check.sh`, the
     documentation check. The session notes already written stay as they are: history.
   - `CONTRIBUTING.md`: a new framework command goes under `fw/` only, with a link to
     Claude Code's page of built-in commands (code.claude.com/docs/en/commands).
   - The upgrade: `SETUP.md` describes the migration for the projects — the old command
     files to remove, the references to update; while the old files remain they keep hiding
     the built-in commands —; `upgrade-check.sh` flags the old command files left; the
     CHANGELOG declares an incompatible change for the projects, with the migration step,
     naming no project.
   - The bump: with the rename the release is a MAJOR, v3.0.0 — recomputed under IMP-074 and
     confirmed, below.
9. Beside the scope:
   - the allow list: a new IMP, the P1 lens (IMP-123); in this release `docs/04`'s claim "only
     read-only commands" is corrected and the limit declared; the mechanical restriction stays
     in the IMP, with a trigger;
   - selective loading: a new IMP (IMP-124); in this release its Level 1 — `docs/00`
     describes what really happens —; Level 2 stays open;
   - the guard (`-O`, `--man-path`): evidence on IMP-083, no proposal.
10. The minor choices follow the agents' advice; each is named in its task below.
11. First the agents' output saved in the repository with this note — the session's
    scratchpad is not durable —, then the phases listed, then the work; stop before
    `/integrate`'s blocks.

## Why IMP-075's rule was not enough (IMP-117)
The causes the retro found, the user's question, each with its evidence in the agents'
output:
1. Off the point of use: the rule is the tail of `docs/04`'s `ask` bullet, in a section about
   the settings; `SETUP.md`'s §2, §4, Step 3 and Step 4 say what to write, never how.
2. Its reason reaches two files: "skips the checkpoint" holds for `settings.json` and the
   guard only; the harm it should prevent — a stale line number writes the wrong line, with no
   error — is named nowhere.
3. Its list is short: `.claude/`, `CLAUDE.md`, `scripts/` — not the `Makefile`, which was
   written with `sed`.
4. Its exception is open: "a procedure that writes them by design" — setup is a procedure of
   `SETUP.md` too.
5. A standing instruction of the runtime says the opposite: auto mode's text invites `sed` and
   heredocs, all session long (the retro's own context carried it); its own carve-out for exact
   replacements was not heeded either.
6. The procedure hands out coordinates: §2's and Step 4's `grep -rn` print file and line, the
   input of `sed -i '<N>s…'` (inferred).
7. Nothing checks it: no step reads the diff of the answers — the user's review found the
   damage.
8. Salience, not loading: after the graft `docs/04` loads in every session through
   `CLAUDE.md`'s imports, about 1,450 lines with the rule one clause among them; the crossing
   from the project's code to the memory, the checkpoint's step 3, has no reminder.
9. Never exercised: its verification read text and merges, not behaviour.
The remedy, one layer per cause: text at every point of use, a check of the answers' diff, the
reason, the scope and a closed exception in `docs/04`'s *Operating rules*, a short rule 10 in
`CLAUDE.md`, the checkpoint's step 3. Not adopted: a hook that parses shell text (beyond the
threat model), a path-scoped rule, an `ask` rule on `sed -i`. If it happens again, the next
step is a mechanism, not more text.

## Pre-flight readings (task 2)
- **Claude Code's pages**, fetched as Markdown on 2026-10-15 (`skills.md`, `commands.md`,
  `plugins.md`, `plugins-reference.md` under code.claude.com/docs/en/), read, not measured:
  - the skills page, *How a skill gets its command name*: "File in a subdirectory of
    `.claude/commands/` | Subdirectory path relative to `commands/` with each `/` replaced by
    `:`, then the file name without extension | `.claude/commands/frontend/component.md` →
    `/frontend:component`" — the decision's premise holds;
  - the same page, *Resolve skills that share a name*: "In a local terminal session, your skill
    replaces the built-in command, but not its aliases" — the user's measurement found the
    alias `/checkpoint` taken all the same: page and behaviour disagree, and the namespace makes
    the question moot;
  - the commands page: "`/rewind` | … Aliases: `/checkpoint`, `/undo`"; `/security-review` is a
    built-in row;
  - plugins: "plugin skills are namespaced as `/plugin-name:skill-name`"; the reserved names are
    `anthropic-skills` (synced skills) and, for plugins, names that pass as Anthropic's own.
- **`fw` against everything else**: no built-in command or bundled skill named `fw` or starting
  so, among the 119 commands of the commands page's table; the word appears in none of the four pages; no
  plugin named `fw` installed here, none among the 6,708 plugin names of the local marketplace
  cache. Residuals, declared in IMP-122: a plugin named `fw`; a nested `.claude/skills/` under a
  project directory named `fw`.
- **The project upgraded next**, read read-only with `git -C` and file reads, nothing written
  there; its form only:
  - the pin: `version` without the `v` — `preflight`'s error, with its suggestion —, `commit`
    v1.2.0's own;
  - trunk-based on its main branch, the two roles coinciding, a dormant historical remote branch
    protected too;
  - the eight command files at the top of `.claude/commands/`, tracked: three as v1.2.0's
    (`integrate.md` among them, its branch placeholders and its slot left as they are — the
    run-time reading, de facto), five customised (`checkpoint.md`'s two placeholders answered
    inline; `harvest-framework.md`, `lint-memory.md`, `new-component.md`,
    `security-review.md` edited);
  - `docs/00`'s slot-shaped line and its mention both rewritten inline; `docs/02`'s five slots
    and `docs/03`'s answered inline; `docs/04`, four of five answered inline — its reading
    convention answered for trunk-based —, the branching-model pointer left open;
  - `CLAUDE.md`: four slots answered, the two mentions of rule 9 left as they are;
  - the `Makefile`: the mention at its line 4 rewritten, the project's section answered; the
    protected branches answered in `reset-task.sh`, before v1.3.2 moved them to the `Makefile`;
  - the formatting slot answered; no `.gitattributes` (a graft before v1.5.0), LF line ends; no
    `.claude/skills/`.
- **What follows for this release**: inventory by lines is needed by this very upgrade — from
  v1.2.0, the `Makefile`'s net marker count would hide the protected branches' slot —; IMP-118's
  pointer and prose in `docs/00` meet two declared conflicts there; the namespace's migration is
  a rename with a 3-way for a customised command (base the old path at `vX`, theirs the `fw/`
  path at `vY`, mine the project's old file), the old file removed after; the fixture of the
  rehearsal reproduces this form, with none of the project's names or contents.

## The bump — recomputed under IMP-074
- The rename moves every command to a new name: "removing or renaming a command" is the first
  item of the framework's breaking criterion (`CONTRIBUTING.md`), and every project must
  adapt — remove the old files, update its references — to adopt the release. A MAJOR by the
  content, whatever the commits' types: v3.0.0 from v2.2.0. Without the rename the release
  was a MINOR (the retro's computation: new rules in IMP-117, 119, 120, 121, 107 and 110).
  Confirmed again at `/integrate`, on the final content.

## Plan (one commit per IMP applied)
- [x] 1. This note — the brief, the retro's outcome and gaps, the user's decisions, the bump, the plan — and the agents' output beside it — commit: 08a492a
- [x] 2. The registrations in `LEARNINGS.md` — IMP-107..121's outcomes (13 approved with their forms; IMP-111 and IMP-112 deferred with their trigger and the P1 verification), IMP-122, IMP-123 and IMP-124 recorded, the evidence on IMP-083 —; the pre-flight readings in this note: Claude Code's pages on command names, `fw` against the built-in commands and the plugins, the project upgraded next (its form only) — commit: 731216a
- [ ] 3. IMP-122, the `fw` namespace: the eight commands under `.claude/commands/fw/`, every reference, the classes (the old paths kept for the inventory), the old files flagged by `upgrade-check.sh`, the migration in `SETUP.md`, the documentation check and the self-tests, `CONTRIBUTING.md`'s rule — commit: —
- [ ] 4. Classes and markers: IMP-115 (`docs/02`-`04` HYBRID), IMP-118 (variant Y; the mentions; the greps; lint check 10; inventory by lines) — commit: —
- [ ] 5. Writing and open threads: IMP-117 (rule 10, `docs/04`'s *Operating rules*, `SETUP.md`'s points of use, `/fw:checkpoint`'s step 3), IMP-121 (an open thread reaches `STATE.md`) — commit: —
- [ ] 6. Commands and hooks: IMP-116 (the run-time reading, trunk-based), IMP-114 (the formatting reminder) — commit: —
- [ ] 7. The cycle: IMP-120 (a deliverable is what goes to integration), IMP-119 (records between deliverables; a memory-only branch exempt by its diff), `CONTRIBUTING.md` — commit: —
- [ ] 8. The greenfield graft, `SETUP.md` §0-§4: IMP-109, IMP-110 (form A; a remote the forge initialised), IMP-107, IMP-113, IMP-108 — commit: —
- [ ] 9. The claims beside the scope: IMP-123's part (`docs/04`'s allow list), IMP-124's Level 1 (`docs/00`'s selective loading) — commit: —
- [ ] 10. The rehearsal: the upgrade 2.2.0 → 3.0.0, and 1.2.0 → 3.0.0 in the form of the project upgraded next, LF and CRLF, the fixture synthetic; the self-tests' new fixtures synthetic too — commit: —
- [ ] 11. The security gate: ONE reviewer, read-only, the two lenses, the snapshot before and after; HIGH fixed, MEDIUM resolved or accepted with its reason, LOW per IMP-103 — commit: —
- [ ] 12. `/fw:retro`, `/fw:checkpoint`, the CHANGELOG's 3.0.0 entry and the bump stated — then stop before `/integrate`'s blocks: block 0, the user's push and the CI on the three systems, comes first — commit: —

Each applying commit carries its IMP's part of the text and moves the entry to Applied; the
shas go into the headings with a later commit, as in v2.2.0.

## Task 3 — the `fw` namespace (IMP-122)
- The eight commands moved with `git mv`, their content untouched but for the names they cite;
  every reference outside history follows. The old paths stay in `classify()`: an upgrade from
  an earlier release reads them at `vX`, and the documentation check holds the class table to
  every tag's payload.
- Observed in this session, once the files moved: the runtime listed the commands as
  `fw:checkpoint`, `fw:integrate` and the rest, and Claude Code's own `security-review`
  reappeared among its commands — the namespace at work, and the hiding gone.
- Red first: the new case of `tools/test-upgrade-check.sh`, run against the upgrade check of
  `731216a`, failed (its `classify()` knew no `fw/` path); green with the change. The
  documentation check, before its tripwire learned renames, reported "0 → 4 slot markers since
  v2.2.0" on the moved `lint-memory.md`; nothing after.
- Found on the way: `tools/test-docs-check.sh` built its base from HEAD and took out only the
  unstaged deletions, so a `git mv`'s old path stayed in the base and the new one stayed
  untracked there. It now takes the staged deletions out too and stages the base, as the next
  commit takes it; the tripwire reads the rename between the tag and the index, which writes
  nothing — a diff against the working tree refreshed the index, and the read-only case caught
  it.
- A conflict this task brings to every project's upgrade, to be measured at the rehearsal:
  rule 8's line of `CLAUDE.md` holds its slot and the command's name.
- Writing: the method's files edited with the file tools; the renames with `git mv`.

## Resumption notes
- The payload names no IMP number (the documentation check's `imp-number`).
- The method's files are edited with the file tools (IMP-075); the copy of the agents' output
  beside this note is a whole-file copy, checked byte for byte, not an edit.
- Delegated agents read only: the snapshot before and after each delegation.
- The project upgraded next is read read-only; its name, its path and its contents are never
  written in this repository.

## Security gate
- Under the gate: the release asserts security properties — the boundary's claims in
  `docs/04`, the graft that reads the framework by tag and copies no personal permissions, the
  namespace that hides no built-in command. The verdict is written at the deliverable's close.

[[LEARNINGS]] · [[2026-10-14-test-project-harvest]] · [[2026-10-13-backlog-retro-2.2.0]]
