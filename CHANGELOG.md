# Changelog

The relevant changes to this repo, in the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format; versions follow the
SemVer on annotated tags defined in `.claude/docs/04-git-workflow.md`
(*Versioning*). It is updated inside `/integrate`, before the merge+tag block.

## [Unreleased]

## [1.1.0] — 2026-07-21

### Added
- **Language rule with two axes** (IMP-040), as rule 9 of `CLAUDE.md`. ARTIFACTS —
  everything that lands in the repo, including future commit messages, IMP entries and
  session notes — are **always English**: a deliberate, declared opinionated choice
  rather than an implicit leftover, because English artifacts are the universal
  practice of open source and keep a project portable. INTERACTION — the language the
  agent speaks with you in session — stays configurable and is the only configurable
  axis. It REPLACES the IMP-029 model (now marked superseded) instead of coexisting
  with it: the "Lingua/e del progetto" slot becomes "Interaction language" in the
  technical rules, in the `SETUP.md` step-2 checklist and in the brownfield section.

### Changed
- **The whole framework is translated to English** (IMP-041): `CLAUDE.md`, the seven
  process docs, the eight slash commands, the memory templates and their READMEs, the
  live memory (`LEARNINGS.md` and the ten historical session notes), `README.md`,
  `SETUP.md`, `CONTRIBUTING.md`, `SECURITY.md`, this CHANGELOG, and the comments and
  user-facing messages of the scripts and config. Not translated, by design: past
  commits (immutable history), file names, wikilink targets and session slugs,
  identifiers in scripts, and conventional-commit types.
- **Behavior-bearing strings switched WITH backward compatibility, so this is not a
  breaking change.** `[DA DEFINIRE AL SETUP]` → `[TO BE DEFINED AT SETUP]`,
  `Destinazione: framework` → `Destination: framework`, the `hooks-install.sh` marker,
  the `PRONTO PER INTEGRAZIONE` / `RACCOLTA PER IL FRAMEWORK` blocks and the escalation
  delimiters. Every READER accepts the legacy Italian form as well — the `/lint-memory`
  sentinel and setup grep, the `/harvest-framework` grep, and `hooks-install.sh` via a
  `LEGACY_MARKER` — so a project grafted or upgraded with an earlier release keeps
  working untouched. Upgrading is optional and needs no migration.

## [1.0.0] — 2026-07-19

First **stable** release. From this version on the framework promises stability of
its own method contract: a breaking change costs a MAJOR. What a breaking change is
for a method framework — removing or renaming a command, an incompatible memory or
marker format, a structure that breaks existing grafts or upgrades — is defined in
`.claude/docs/04-git-workflow.md` (*Versioning*) and in `CONTRIBUTING.md`. The
definition is itself part of the promise.

The `0.1 → 1.0` path consolidated the capabilities the framework now guarantees:

- **Persistent memory** — STATE/TREE/INDEX, sessions, decisions, plans, IMP backlog,
  with a consistency health-check (`/lint-memory`, 11 checks, including grep-visible
  markers and inventories-vs-reality).
- **Resilient task planning** — heavy prompts turned into atomic tasks, one commit per
  task, surgical resumption after an interruption without redoing committed work.
- **Security gate** — mandatory review on sensitive components, adversarial by
  propagation radius; gitleaks baseline (pre-commit hook + one-off scan of the history).
- **Git workflow with versioning** — Conventional Commits, SemVer on annotated tags, two
  pre/post-1.0 regimes, local/shared execution boundary, `/integrate` block.
- **End-of-deliverable cycle** — [if sensitive] `/security-review` → `/retro` →
  `/checkpoint` → `/integrate`, with controlled self-improvement: rules are
  PROPOSED (IMP), the human disposes.
- **Greenfield and brownfield grafting** — start from scratch or graft onto an existing
  project, reconciling colliding files and the inherited git history hygiene.
- **Upgrade-in-place** — updates the grafted framework (`vX → vY`) preserving the
  memory, with the provenance pin `.claude/framework-version` as a certain baseline.
- **Project → framework bridge** — method lessons rise back to the template under
  human curation (`/harvest-framework`).

### Added
- `.claude/docs/04-git-workflow.md`: agnostic definition of **“breaking change”** as the
  MAJOR criterion (the project's public contract; examples for code projects and for
  method/tooling projects) and the post-1.0 regime as the current, fully specified
  regime (IMP-039).

### Changed
- `CONTRIBUTING.md`: the repo's git model moves to the **post-1.0 regime** — tags stay
  on `main` (trunk-based), with the stability promise and the definition of breaking
  change for the framework (IMP-039).

## [0.6.2] — 2026-07-19

### Fixed
- The "partial inventory list" drift class (two recurrences: the TREE legend
  fixed by IMP-018, the D1/D2/D5 lists of v0.6.1) now catches itself:
  check 11 **"Inventories vs reality"** in `/lint-memory` — a two-way set
  comparison between the ENUMERATED lists (`CLAUDE.md` "Quick commands"; the
  `commands/`/Makefile lines of the README's "Structure", where present; the
  table in `scripts/README.md`) and the filesystem, never the prose mentions.
  Makefile process targets recognised by STRUCTURAL anchoring (a recipe that
  invokes `scripts/`; `help` excluded), so project targets added at setup do
  not produce false positives in client projects; CHANGELOG and IMP records
  excluded by declaration, since they record past states (IMP-038).

## [0.6.1] — 2026-07-18

### Fixed
- Inventory lists stuck at pre-v0.5.1: `CLAUDE.md` ("Quick commands") without
  `make test-scripts`, the README ("Structure") without `scripts/test-hooks-install.sh`
  and with the Makefile line listing two targets, the table in `scripts/README.md`
  without the test script. Second recurrence of the "partial list" class (cf. the
  TREE legend of IMP-018): improvement proposal IMP-038 registered — an
  inventories-vs-reality check in `/lint-memory`.
- `SECURITY.md`: the "Prevention already active" entry completed the baseline with the
  pre-commit hook alone; added the one-off `gitleaks detect` scan of the
  pre-existing history (IMP-028b, in force since v0.3.0).

### Added
- README: **MIT licence** badge (static, linked to `LICENSE`) and **version** badge
  (dynamic from the GitHub tags, `sort=semver`). Only the two real ones: no
  build/CI/size badges — they would reflect facts that do not exist.

### Changed
- README aligned with the v0.6.0 state: **"Grafting and upgrading"** entry in "What it
  includes" (greenfield, brownfield, upgrade in place with the provenance pin as a
  certain baseline), project→framework bridge in the Self-improvement entry
  (`/harvest-framework`), pin creation mentioned in step 1 of "How to use it".
- `CONTRIBUTING.md`: cross-link to the hybrid regime's plan block — the plan of a
  heavy deliverable lives in the session note, not in `plans/` (debt declared in
  IMP-034, settled here).

## [0.6.0] — 2026-07-18

### Added
- `SETUP.md`: **provenance pin `.claude/framework-version`** — `key: value` lines
  (`version`/`commit`/`grafted`), no parser. Created at step 1 of every graft,
  declared as the FOURTH class **"graft state"** in the taxonomy of the upgrade
  procedure (it lives outside `.claude/memory/`: the empty-diff invariant stays intact),
  read as preference 0 of Step 0 (the certain baseline of the 3-way; ask/estimate/degrade
  remain as pre-pin fallbacks) and rewritten at the close (Step 6) with a **retrofit**
  for pre-pin grafts (IMP-036, approved after the first real upgrade).

### Changed
- The *"No automation, for now"* box of the upgrade procedure: only the
  `/upgrade-framework` command remains deferred (IMP-037, real-upgrade counter 1 of 2-3);
  the pin is promoted — the manually ascertained baseline proved to be the most fragile
  point of the procedure in the field.

## [0.5.1] — 2026-07-17

### Fixed
- `SETUP.md` + `/lint-memory`: a `[TO BE DEFINED AT SETUP]` *slot* broken by word-wrap
  escaped the single-line `grep` of setup and of Step 4 of the upgrade, silently staying
  unfilled. Convention "one slot stays on one physical line" + a sentinel (check 10 of
  `/lint-memory`) that declares the false positives in prose (IMP-031).
- `hooks-install.sh`: in the `FORCE_OVERWRITE=1` branch a hook that is a *dangling*
  symlink made `cp -L` fail under `set -euo pipefail` — the script aborted before the
  backup and the removal, against its header comment. `[[ -e ]]` guard, `rm` shared by
  the two branches; RED→GREEN test `scripts/test-hooks-install.sh` + `make test-scripts`
  target (IMP-032).

### Changed
- docs/01 + `sessions/README.md`: ratified that in the framework repo (hybrid regime) a
  heavy deliverable does NOT use `plans/`/`decisions/` — the plan lives as an IMP entry +
  a session note (standardised **plan block**) + `[task N/T]` commits; patch to the
  RESUMPTION step that only looked at `plans/` (IMP-034 A+C).
- `LEARNINGS.md`: terminological note next to IMP-026 to disambiguate
  "command"/"skill"/the harness's `Skill` tool (IMP-035).

## [0.5.0] — 2026-07-17

### Added
- `SETUP.md`: **"Upgrading the framework on an already-grafted project
  (`vX` → `vY`)"** section — the third case alongside greenfield and brownfield.
  Three-class model (method / project-memory / hybrids), empty-`diff`-on-`memory/`
  invariant, 3-way merge `base=vX` for the hybrids (filling the `[TO BE DEFINED]` slots
  is destructive), what-changed derived framework-side (CHANGELOG as index + scoped
  `git diff`), **7 edge cases** (orphans, renames, broken memory pointers, hooks outside
  the git graph, `0.x→1.0` regime, multi-version jump, pure/hybrid pre-flight), execution
  boundary (the agent prepares, the human integrates, "no tag" bump). Pointer stub from
  brownfield CASE A; cross-link from the README.
- Upgrade automation **deferred** as open proposals with the trigger "after the first
  real upgrade": `provenance-pin` at graft time (IMP-036) and the read-and-print
  `/upgrade-framework` command, the inverse twin of `/harvest-framework` (IMP-037) —
  anti-hype filter, same criterion as `graft.sh`.

## [0.4.0] — 2026-07-17

The `/harvest-framework` command and the project→framework bridge: the lessons that
concern the method, emerged while working on a client project, are now marked and rise
back to the template through a repeatable procedure under human control (IMP-033).

### Added
- **`/harvest-framework`** (`.claude/commands/`): rakes up from the backlog the IMPs
  marked `Destination: framework` and prints a copyable, anonymised block, ready to be
  re-proposed as an IMP in the framework repo. It only reads and prints — no
  clone/copy/push/cross-repo (the IMP-009 boundary, agnosticity); anti-vacuity on the
  empty case; defaults to the whole backlog, narrowable with `$ARGUMENTS` (IMP-033).
- **`Destination: framework`** attribute in the IMP format of `LEARNINGS.md` (single
  physical line, greppable): it marks, in a client project, the lessons to be raised
  back to the framework; it is a destination attribute, not a level (IMP-033).
- docs/06: **"The bridge to the framework"** section — how a framework-bound lesson
  is marked, how it rises back (human curation, with anonymisation) and why the boundary
  is read-and-print only; cross-links from the README (*Philosophy*), `SETUP.md` §5 and
  `CONTRIBUTING.md` (IMP-033).

### Changed
- `CLAUDE.md` ("Quick commands") and `README.md` ("Structure"): `/harvest-framework`
  added to the command lists (IMP-033).

## [0.3.0] — 2026-07-17

Lessons from the first graft onto an existing project, verified against the files and
applied as IMP-027..030 (the `graft.sh` option is deferred with a trigger).

### Added
- `SETUP.md`: **"Grafting onto an EXISTING project (brownfield)"** section —
  CASE A/B criterion for a pre-existing `.claude/`, reconciliation of the colliding
  files (the host takes precedence), first command as a read-only assessment
  that populates the memory from what exists, doc-vs-reality divergences
  recorded as debt, *Inherited git hygiene* checklist (tag audit, hard-coded
  version constants, branch topology decided-and-declared)
  (IMP-027, IMP-028a/c).
- docs/03 + `SETUP.md` step 3: on a repo with pre-existing history the gitleaks
  baseline is completed with a one-off scan of the whole history,
  `gitleaks detect` (IMP-028b).
- `/integrate`: guard on the versioning base — `git describe --tags`
  also accepts lightweight tags and non-SemVer names; on a base that is not `vX.Y.Z`
  it stops (IMP-028a).
- "Project language(s)" entry in the technical rules of `CLAUDE.md` and in the
  setup checklist (IMP-029); filling the `[TO BE DEFINED AT SETUP]` slots also
  **in dialogue with Claude Code**, declared an equivalent mode (IMP-030).
- docs/06: perimeter of LEVEL 1 — during the graft the host's documentation is not
  corrected as a matter of course (debt in `STATE.md`); once the graft is complete it
  falls back under LEVEL 1 (IMP-027).

### Fixed
- `hooks-install.sh` no longer overwrites blindly: it stops in front of hooks of
  another origin (hook managers' symlinks included) and of an active `core.hooksPath`
  (hooks installed-but-inert); `FORCE_OVERWRITE=1` makes a `.bak` backup without
  writing through the symlinks; customisations of one's own hooks are saved
  to `.bak` on re-run instead of being destroyed (IMP-028d + adversarial review).
- docs/04 *Versioning*: the rationale for annotated tags corrected into descriptive form
  (`git describe` without `--tags` uses annotated tags only; `/integrate` uses `--tags`
  and for that reason verifies the base); the `[TO BE DEFINED AT SETUP]` markers of
  `integrate.md` and of docs/04 re-compacted onto one line — they were invisible to the
  grep declared by the setup.

### Changed
- `STATE.md` template: "Documentation debt" widened to cover existing-but-wrong
  documentation (IMP-027).

## [0.2.0] — 2026-07-11

Consolidation: missing process conventions, remediation of the drifts, the repo's
project files (IMP-009..025; IMP-023 and IMP-026 deferred with a trigger).

### Added
- The framework's MIT `LICENSE`; the client project's licence explicitly
  `[TO BE DEFINED AT SETUP]` (IMP-021).
- `SECURITY.md` (real channel: GitHub Security Advisories + reusable scaffold),
  `CONTRIBUTING.md` (the repo's real workflow), `CHANGELOG.md` with its update
  wired into `/integrate` (IMP-022).
- docs/04: *Execution boundary and blocks for the user* section (IMP-009);
  tag hygiene and pre-push checks, also in the `/integrate` block (IMP-010);
  the "shared history = forever" rule (no specific project names)
  (IMP-025).
- docs/00: the phases upstream of a structural deliverable (IMP-011), scope and
  session hygiene (IMP-012), the memory-on-disk principle (IMP-013), effort
  proportional to the consequences (IMP-017), `/lint-memory` triggers (IMP-018).
- docs/02: verification against real artefacts and *Tests that demonstrate* (IMP-015);
  docs/03: adversarial review by propagation radius and completeness of the
  findings (IMP-016).
- Debts with an explicit trigger in the `STATE.md` template, survival check
  in `/checkpoint`, LEARNINGS↔STATE consistency check in `/lint-memory` (IMP-014).

### Changed
- Parametric merge in docs/04: always a human action, via PR (team) or via the
  `/integrate` block (single developer) — the internal contradiction resolved (IMP-019).
- The repo's memory regime declared "hybrid": only `LEARNINGS.md` and
  `sessions/` are live; emptying on copy instructed in `SETUP.md` (IMP-024); the
  trunk-based model on `main` declared in `CONTRIBUTING.md` (IMP-025).

### Removed
- The gitleaks PreToolUse hook from `settings.json`: it could never block (false
  security demonstrated); the real defence remains the pre-commit hook (IMP-020).

## [0.1.0] — 2026-06-16

First tagged version of the methodological template, extracted from a real project.

### Added
- Persistent memory system: `STATE`, `TREE`, `INDEX`, `sessions/`,
  `components/`, `decisions/`, `plans/`, improvement backlog (`LEARNINGS`).
- Process documentation `00`–`06`: the method and the end-of-deliverable cycle
  (IMP-006/007), resilient task planning with a cross-module refactor protocol
  (IMP-003), code quality, security gate, git workflow with SemVer versioning
  (IMP-001) and a parametric integration branch (IMP-008), escalation,
  self-improvement.
- Slash commands: `/checkpoint`, `/integrate` (IMP-002), `/sos`, `/retro`,
  `/security-review`, `/new-component`, `/lint-memory` (IMP-005).
- Git hooks (`make hooks-install`): gitleaks (pre-commit) + commitlint
  (commit-msg); permission baseline in `.claude/settings.json` (IMP-004).
- Process scripts: `hooks-install.sh`, `reset-task.sh`.
