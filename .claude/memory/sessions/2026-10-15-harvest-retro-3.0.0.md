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
- [x] 3. IMP-122, the `fw` namespace: the eight commands under `.claude/commands/fw/`, every reference, the classes (the old paths kept for the inventory), the old files flagged by `upgrade-check.sh`, the migration in `SETUP.md`, the documentation check and the self-tests, `CONTRIBUTING.md`'s rule — commit: ee4ce1f
- [x] 4. Classes and markers: IMP-115 (`docs/02`-`04` HYBRID), IMP-118 (variant Y; the mentions; the greps; lint check 10; inventory by lines) — commit: 080cf44, 1634337
- [x] 5. Writing and open threads: IMP-117 (rule 10, `docs/04`'s *Operating rules*, `SETUP.md`'s points of use, `/fw:checkpoint`'s step 3), IMP-121 (an open thread reaches `STATE.md`) — commit: d7ea3e3, 5bdad7a
- [x] 6. Commands and hooks: IMP-116 (the run-time reading, trunk-based), IMP-114 (the formatting reminder) — commit: 292f860, 7c49e79
- [x] 7. The cycle: IMP-120 (a deliverable is what goes to integration), IMP-119 (records between deliverables; a memory-only branch exempt by its diff), `CONTRIBUTING.md` — commit: 6ab65a0, c8e3221
- [x] 8. The greenfield graft, `SETUP.md` §0-§4: IMP-109, IMP-110 (form A; a remote the forge initialised), IMP-107, IMP-113, IMP-108 — commit: d29449f, b2b7458, a0531ef, b11d1db
- [x] 9. The claims beside the scope: IMP-123's part (`docs/04`'s allow list), IMP-124's Level 1 (`docs/00`'s selective loading) — commit: 24010c2, 6259b15
- [x] 10. The rehearsal: the upgrade 2.2.0 → 3.0.0, and 1.2.0 → 3.0.0 in the form of the project upgraded next, LF and CRLF, the fixture synthetic; the self-tests' new fixtures synthetic too — commit: 3feb827, 1ae21c5, ce0516e
- [x] 11. The security gate: ONE reviewer, read-only, the two lenses, the snapshot before and after; HIGH fixed, MEDIUM resolved or accepted with its reason, LOW per IMP-103 — commit: 2ed33a9, 07e2e19, 7c81d6c, f0c90e3, 8efe25e, 420448f, 2f17499
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

## Task 4 — classes and markers (IMP-115, IMP-118)
- IMP-115, red first: with a project's `docs/04` answered inline, the upgrade check of
  `ee4ce1f` printed "edge case 7: .claude/docs/04-git-workflow.md is METHOD but customised";
  with the three docs HYBRID, `inventory` shows a hybrid and `post` holds it to no `vY` text.
- IMP-118: the payload's markers went from 40 to 30, every one a slot §2 lists; no METHOD file
  holds one, which the documentation check now fails. The greps' exclusions measured here on
  macOS with the system's BSD grep and with ugrep (the shell's `grep` on this machine); the
  new case 10 runs §2's grep, read from `SETUP.md`, with each CI image's own grep.
- The inventory by lines, red first: on a throwaway release that drops a mention and adds a
  slot in the same file, the counting check showed nothing in `inventory` and in `post`; the
  line check shows the slot. From v1.2.0 — the project upgraded next — the `Makefile`'s
  protected-branches slot, which a count masked, now shows.
- A planted case of the documentation check's self-test anchored on the HYBRID bullet's run of
  three files: a `CLAUDE.md` named again in the new parenthesis hid the planted removal; the
  parenthesis says "the technical rules" instead.

## Task 5 — writing with the file tools, open threads (IMP-117, IMP-121)
- IMP-117 in the user's form: rule 10 in `CLAUDE.md`, the rule's home in `docs/04`'s
  *Operating rules for Claude Code*, the points of use in `SETUP.md`, the checkpoint's step 3.
  `checkpoint.md` carried both entries' hunks: IMP-117's was staged alone with
  `git apply --cached` on its own hunk, so each entry has its commit.
- IMP-121 on the side that writes STATE; its `CONTRIBUTING.md` counterpart says where an open
  thread lives here. This note's own open threads, the framework's way: the follow-up below,
  and the deferred entries of `LEARNINGS.md`.

## Task 6 — commands and hooks (IMP-116, IMP-114)
- IMP-116: `integrate.md`'s introduction says the agent substitutes the branch names in what it
  prints and setup answers step 1's line only; with one branch, the tag goes on it in both
  regimes. No answered line is touched, so no project migrates.
- IMP-114: the reminder only while the generated pre-commit carries the slot's marker, red first
  against the installer as committed. Its self-test's open-slot half took the project's own
  copy for an open one: the rehearsal (task 10) found it failing in every project that answered
  the slot.

## Task 7 — the cycle (IMP-120, IMP-119)
- A deliverable is what goes to integration, whatever its size: heaviness decides the plan,
  never the cycle. A record made while no deliverable is open gets a branch of its own; a
  branch whose diff touches only `.claude/memory/` is exempt from the gate and the retro, by the
  diff, and goes in with the no-tag blocks, the CI green. `CONTRIBUTING.md` adopts the rule.

## Task 8 — the greenfield graft (IMP-109, IMP-110, IMP-107, IMP-113, IMP-108)
- Step 1 starts the repository with an empty commit on the integration branch (the roles of
  `docs/04`), in two blocks for the user, or from the commit a forge made; the graft goes on a
  branch of its own. The copy is read by tag, as one chain ending in a line that proves it,
  leaves the framework's own memory out and derives `LEARNINGS.md` from the tag's file; the
  prerequisite check runs from the project once the copy is in. Case 11 of the upgrade check's
  self-test runs step 1's blocks, read from `SETUP.md`; measured here too, macOS, git 2.54.0,
  bsdtar.

## Task 9 — the claims beside the scope (IMP-123, IMP-124)
- `docs/04` no longer calls the shipped allow list read-only: its rules match the command's
  text, and an allowed `git diff` can write with `--output`; the claim narrowed, the limit
  declared, the mechanical restriction deferred with its trigger. `docs/00` says what Claude
  Code does: the seven docs are imported and loaded at every launch, selective loading applies
  to the rest; whether to stop importing them stays IMP-124, open.

## Task 10 — the rehearsal (2.2.0 → 3.0.0, and 1.2.0 → 3.0.0)
- The fixture, synthetic, in the session's scratchpad (`rh7-*`): the framework cloned at the
  branch's tip and tagged v3.0.0 in the clone only. Scenario A: a graft at v2.2.0 with every
  answer — `CLAUDE.md`, `docs/00` answered inline, `docs/02`-`04` inline, the three commands set
  up, the `Makefile`, the formatting slot, `decisions/README.md`, `.gitignore`, the allow list —,
  LF, and the same cloned with `core.autocrlf` true. Scenario B: a graft at v1.2.0 in the form
  of the project upgraded next, none of its names or contents — the pin `version: 1.2.0`
  without its v, a short commit, `grafted: n/d (retrofit …)`; trunk-based on `main`, a dormant
  branch protected in `reset-task.sh`; `CLAUDE.md` answered, forty technical rules of its own;
  `docs/00` answered inline and its closing mention rewritten; `docs/02` and `03` inline,
  `docs/04` four slots of five; the `Makefile`'s mention rewritten and its section answered;
  formatting "none"; `checkpoint.md`'s placeholders answered; `lint-memory`,
  `harvest-framework`, `new-component` and `security-review` customised; `integrate`, `retro`
  and `sos` as shipped; no `.gitattributes`; LF.
- The procedure as `SETUP.md` writes it, with the tag's `upgrade-check.sh`: Precondition,
  prerequisites, preflight, Step 1 and the hooks' photograph, the inventory, Step 3 by class,
  the declared conflicts resolved by hand, the templates committed apart, Step 4 (the hooks, a
  fake secret, a message without a type, `make test-scripts`, `reset-task`), Step 5, Step 6.
- Four defects found, each fixed red first: `make test-scripts` failed in all three projects
  at the hooks' Case 7, which took the project's answered copy for an open one (3feb827); from
  v1.2.0, `integrate.md`'s move read as a deletion — git pairs nothing across the jump —, so a
  customised copy would have been removed instead of merged, and the listings by tag were
  cached across runs by name (1ae21c5); Step 0's correction of a malformed pin contradicted
  Step 1's clean start (ce0516e).
- The last run, on ce0516e: preflight 0 FAIL in A; in B the pin's FAIL, v1.2.0 suggested, and
  the `n/d` CHECK — the pin corrected as the branch's first commit, preflight then 0 FAIL. The
  inventory names the eight renames in both. The 3-way's conflicts, each declared or expected:
  `CLAUDE.md` 2 in both (rule 8's line, its slot and the command's name: the project's answer
  kept with `/fw:security-review`; the technical rules' guidance against the project's own
  section: the project's kept); `docs/00` 1 in A and 2 in B (step 2's list answered inline
  against the pointer to `docs/03`, which holds the list: vY's taken; in B the closing mention
  rewritten: vY's taken); the `Makefile` 1 in B (its rewritten mention: vY's taken);
  `fw/harvest-framework.md` 1 in B (the project's line beside vY's change in §5: both kept).
  `docs/02`-`04`, the three setup commands, `settings.json` and `hooks-install.sh` merged clean.
- `integrate.md` in its two forms: answered throughout (A), merged clean with every answer kept,
  step 1's slot line left to answer; as shipped (B), brought over, its slot line the same.
- Edge case 8 in B: `main dev` carried to the `Makefile` first, `reset-task.sh` then brought
  from the tag; on each protected branch, in a clone of the upgrade branch, `make reset-task`
  refuses with and without `YES=1`; the script run directly refuses `--yes` and, asked, warns of
  its defaults and asks.
- Step 4: in A the hooks unchanged, no `.bak`; in B two `.bak` and a new `pre-push`. A fake
  secret and a message without a type refused; `make test-scripts` green in all three. Step 5:
  `invariant` 0 FAIL — in B one CHECK, the restore point's pin in its old form —; `post` 0
  FAIL, its CHECKs the customised files and the slot lines, `CLAUDE.md`'s rule 8 among them.
  Step 6: the pin at v3.0.0, B's `n/d` written `n/a`.
- Greenfield step 1, block 1 only — the publication is the user's: two branches and
  trunk-based, `root: OK`, the copy `payload: OK`, `sessions/` its README only, the
  prerequisites 0 FAIL; a remote the forge started with a README, a licence and a `.gitignore`:
  the integration branch from its commit, and the copy as written overwrites the forge's
  `.gitignore` — git shows it modified and restores it —, the case §1 sends to the brownfield
  reconciliation.
- For the CHANGELOG: a project's `STATE.md` and `TREE.md` name the old commands; the upgrade
  leaves them, its checkpoint rewrites `STATE.md` and regenerates `TREE.md` — the structure
  changed —, and the session notes stay history.

## Task 11 — the security gate
- ONE reviewer, a workflow agent on the session's model, read-only, its brief pointing at this
  note's decisions; the two lenses of `docs/03`; the range `a45fab2..6a6badd`; a stall budget
  of 60 minutes, used 35. The snapshot before and after identical, the tree clean. Its full
  structured output stays in the session's scratchpad, which is not durable, and is not
  copied here — it holds a path of this machine —: this section is the record.
- No CRITICAL or HIGH. One MEDIUM, six LOW, five INFO, each fixed or closed by its text:
  - SG-01 MEDIUM — here the memory-only exemption also covered the memory files the framework
    ships (the guide READMEs, the templates, `LEARNINGS.md`'s header), against
    `CONTRIBUTING.md`'s own release test: narrowed to the framework's records; `docs/00` says a
    shipped memory file is product in a project whose documentation is its product (2ed33a9).
    The user's decision 5 kept its intent: records between deliverables close lighter.
  - SG-02 LOW — `git diff --name-only` hides a rename's old path: `--no-renames` (2ed33a9).
  - SG-03 LOW, SG-04 LOW, SG-09 INFO — the allow list's forms (`tree --fromfile`, measured,
    `tree -R`, the default external diff, `--output` onto the boundary's files,
    `git branch --delete --force`, `git commit -n`), `docs/03`'s limit for `--no-verify`, the
    ask bullet's shell sentence; the ask rule in `bypassPermissions` sourced from the
    permission-modes page, fetched on 2026-10-15 (07e2e19); IMP-123's deferred restriction
    gets the forms.
  - SG-05 LOW, SG-11 INFO — the copy's chain checks its tag first, red first: Case 11 ran the
    blocks under the test's own pipefail, which hid the defect, and now runs each in a shell
    of its own; the `export-ignore` limit declared; step 1 says the user runs its blocks, that
    a hook from the user's git configuration may run, and how to copy beside a forge's
    `.gitignore` (8efe25e).
  - SG-06 LOW — step 2's grep read `.git/` and listed the generated pre-commit as a slot:
    `--exclude-dir=.git`, red first in Case 10 (7c81d6c).
  - SG-07 LOW, SG-08 INFO — what the bare names run once the old commands are gone, and the two
    collisions the namespace leaves open (420448f).
  - SG-10 INFO — an import loads without its frontmatter and block comments; the TREE.md
    template's legend (2f17499).
  - SG-12 INFO — `awk -v` read a backslash in T's path, so a double rename did not compose:
    the path travels in the environment, red first with a backslash T and a double rename;
    SETUP.md's splice of `LEARNINGS.md`'s format comment, the same defect, dropped the comment
    with no error, measured (f0c90e3).
- From the rehearsal, beside the review: edge case 8's third step would have run
  `YES=1 make reset-task` on the upgrade branch; it checks with `make -n` now (420448f).
- Not measured, declared: whether Claude Code's rules stop `tree --fromfile .env`; `tree -R`'s
  writes; an `export-ignore` in the clone's or the user's attributes; a hook from
  `init.templateDir` on the empty commit; which shell writes prompt in each mode. The Claude
  Code ones join IMP-111's measurement session (IMP-123's trigger).
- The reviewer's gaps, declared: nothing that writes was run; GNU tar, Git Bash and git 2.31
  not measured; `tools/docs-check.mjs` read through its diff only; the files unchanged in the
  range not reviewed again.

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
