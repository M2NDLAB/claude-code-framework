---
type: learnings
updated: 2026-07-21
tags: [improvement]
---
# Learnings & improvement proposals

> **What this file is.** The backlog of process self-improvement (see
> `.claude/docs/06-self-improvement.md`). Here Claude Code records the proposed
> changes to rules, docs, commands and configuration (IMP-nnn) — but it does NOT
> apply them on its own: it applies them only after the user approves. Purely
> FACTUAL corrections to the docs (Level 1) do not go through here, they are
> applied immediately.
>
> IMP numbering starts at **001**. This file is born EMPTY in a new project. IN THE
> FRAMEWORK REPO, by contrast, it is LIVE (declared hybrid regime — see
> `CONTRIBUTING.md`): whoever copies the template EMPTIES it at setup (`SETUP.md`).
>
> **The `Destination: framework` attribute.** In a CLIENT project an IMP may concern
> the FRAMEWORK rather than this project: it is marked with the line
> `- Destination: framework` (a single physical line, so `/harvest-framework` picks
> it up via grep). Omitted = a lesson about this project, which stays in the client.
> It is a DESTINATION attribute, not a level: the lesson stays a Level 2 one — see
> `docs/06-self-improvement.md`, *"The bridge to the framework"*. IN THE FRAMEWORK
> REPO the attribute is moot (every IMP is already about the framework) and is not
> used on the entries.

## OPEN proposals (awaiting the user's decision)

_(none at the moment)_

<!-- Format of a proposal:
### IMP-001 — <short title>
- Date: YYYY-MM-DD | Origin: <session/problem that produced it>
- Observed problem: <recurring friction, repeated error, gap, ambiguous rule>
- Proposal: <what to change and where: CLAUDE.md / docs/NN / command / hook / process>
- Expected benefit / risk:
- Resumption trigger: <if it is not applicable now: which event brings it back into play>
- Destination: framework   (OPTIONAL — only in a client project and only if the lesson
                            must be sent upstream to the framework; a single physical
                            line, for the grep)
-->

## Applied

### IMP-001 — SemVer versioning strategy on annotated tags → applied on 2026-06-16, commit 5ad74cb
- Added to `04-git-workflow.md` the "Versioning" section that REPLACES the rule "tag
  only after the merge onto `main`": two regimes (pre-1.0 you tag on `develop`, from
  `1.0.0` on `main`), commit-type→bump mapping, annotated tags, hotfix as a PATCH.

### IMP-002 — "READY FOR INTEGRATION" block at the end of a deliverable → applied on 2026-06-16, commit 803e409
- New slash command `/integrate`: it gathers the state read-only and emits the
  merge+tag sequence ready to paste (bump, next version from `git describe`,
  verification and anti-error notes) without running push/merge. Called from
  `/checkpoint` and from docs/04.

### IMP-003 — Protocol for a safe cross-module refactor → applied on 2026-06-16, commit 00bed56
- Section in `01-task-planning.md`: dedicated branch, atomic tasks per consumer,
  tests of ALL touched modules green at EVERY step, coherence review before the merge.

### IMP-004 — Clean permission configuration → applied on 2026-06-16, commit 11c4c98
- `settings.json`: added `git add`/`git commit` to `allow` and `git clean`/`branch -D`/
  `rm -rf` to `deny`; four principles documented in docs/04 ("Permission
  configuration") and the checklist updated in `SETUP.md`.

### IMP-005 — Memory/wiki lint (health-check) → applied on 2026-06-16, commit c08631f
- New slash command `/lint-memory` (consistency: state-vs-reality, contradictions,
  orphans, broken links, stale claims) with the criterion "a contradiction is a bug to
  be fixed"; a note on the lint≠retro boundary added in docs/06.

### IMP-006 — A single end-of-deliverable cycle → applied on 2026-06-16, commit 0a399f1
- Section "The end-of-deliverable cycle" in `00-overview.md` with an ordered sequence
  (construction → [if sensitive] `/security-review` → `/retro` → `/checkpoint` →
  `/integrate`); cycle diagram updated; aligned mentions in `README.md` and `SETUP.md`.
  `/security-review` is conditional (only if sensitive), the others are fixed.

### IMP-007 — Wire /retro into the flow and resolve the reflection inconsistency → applied on 2026-06-16, commit e016ad4
- `/retro` is now the reflection step of the cycle (BEFORE `/checkpoint`). Corrected in
  `06-self-improvement.md` the two occurrences of "reflection at the checkpoint";
  clarified in `retro.md` the two intensities (lightweight per-deliverable recording vs
  periodic review of the backlog with decisions).

### IMP-008 — Parametric integration branch → applied on 2026-06-16, commit 86c7362
- In `04-git-workflow.md` "integration branch"/"stable branch" are ROLES
  (`develop`/`main` only example defaults, [TO BE DEFINED AT SETUP]); the `/integrate`
  block parametrised (`<integration>`/`<stable>`); the `reset-task.sh` guard
  configurable via `PROTECTED_BRANCHES`.

### IMP-009 — Git execution boundary and blocks for the user → applied on 2026-07-11, commit 6019fc6
- New section in `04-git-workflow.md`: LOCAL history = Claude Code, SHARED history =
  the user; user blocks with REAL values (never bare placeholders); the executor's
  placeholders never passed to the user; destructive commands only in a separate block
  with the exact condition.

### IMP-010 — Tag hygiene and pre-push checks → applied on 2026-07-11, commit 83a6642
- docs/04 *Versioning*: the tag typed by hand with an ASCII `-m`, `git rev-parse <tag>`
  before the push, `tag -d` ONLY if the verification fails, `git log
  origin/<branch>..<branch>` before every push. The `/integrate` block updated with the
  two checks and the separate recovery block.

### IMP-011 — Phases upstream of a structural deliverable → applied on 2026-07-11, commit fdfdb29
- `00-overview.md` + `01-task-planning.md`: for deliverables with structural choices,
  BEFORE the plan: read-only assessment → proposal with alternatives → user decision →
  recording in `decisions/` (or an ADR) → a plan that POINTS at the decision.

### IMP-012 — Scope and session hygiene → applied on 2026-07-11, commit 27fa2d2
- `00-overview.md`: one change at a time (no "while we're at it"), `/clear` between
  unrelated deliverables, unrelated work on a separate branch/worktree.

### IMP-013 — Memory on disk as a contract → applied on 2026-07-11, commit bd2b034
- `00-overview.md` (pillar 1), `01` (RESUMPTION), `sessions/README.md`: decisions on
  disk SHORTEN the prompts (the prompt points at them); expensive work is persisted
  BEFORE a `/clear`/model switch; the resumption prompt gives the task without empty
  turns.

### IMP-014 — Debts with a trigger, surviving the rewrites of STATE → applied on 2026-07-11, commit a9a3966
- `STATE.md` template (a debt entry with its trigger), `/checkpoint` (a survival check
  of the entries after the rewrite), `/lint-memory` (check 9: `LEARNINGS` ↔ `STATE`
  consistency).

### IMP-015 — Verification against real artifacts; tests that demonstrate → applied on 2026-07-11, commit 1843352
- docs/02: the cause is verified against the REAL artifacts before acting (a debt may
  have been recorded with the wrong cause); section "Tests that demonstrate":
  RED→GREEN isolating the variable, invariants by construction with an anti-vacuity
  check.

### IMP-016 — Adversarial review by blast radius → applied on 2026-07-11, commit a20a932
- docs/03: adversarial (author ≠ judge) for security code in SHARED modules;
  author-verifies for reconnaissance and local fixes; completeness of the findings
  taken from the SYNTHESIS (not from the journal, which retries can inflate) before
  acting.

### IMP-017 — Effort proportional to the consequences of being wrong → applied on 2026-07-11, commit 2e01896
- `00-overview.md`: a tool-agnostic principle — expensive reasoning where correctness
  has consequences, standard for reading/decisions already taken/chores.

### IMP-018 — /lint-memory trigger + minor factual fixes → applied on 2026-07-11, commit f910cfd
- Declared trigger (periodic + events touching many notes) in `00-overview.md` and
  `lint-memory.md`; the legend of `TREE.md` now points at the authoritative list in
  `CLAUDE.md`; `SETUP.md` warns that `/new-component` is inert until it is filled in.

### IMP-019 — Parametric merge: PR or the /integrate block → applied on 2026-07-11, commit 152f6f5
- docs/04 *Merge*: resolved the contradiction "ALWAYS via PR" vs the local `/integrate`
  block — the merge is ALWAYS a human action, in two forms [TO BE DEFINED AT SETUP]:
  via PR (team review flow) or via the `/integrate` block (single developer). Release
  and the 1.0.0 promotion aligned.

### IMP-020 — Removed the decorative PreToolUse gitleaks hook → applied on 2026-07-11, commit 6a55922
- Demonstrated on the real chain: exit always 0 (the `||` swallowed the leak it found,
  with a misleading message), the `--staged` target wrong at Write/Edit time; the
  pre-commit of `hooks-install.sh`, by contrast, really does block (a commit with a
  secret is rejected). `settings.json` cleaned up: no false sense of security.

### IMP-021 — MIT licence at two levels → applied on 2026-07-11, commit a9b7dee
- A real MIT `LICENSE` (Copyright (c) 2026 M2NDLAB) covering the framework ONLY; the
  licence of the client project stays its own choice [TO BE DEFINED AT SETUP]
  (`CLAUDE.md` technical rules + `SETUP.md`: LICENSE is not copied).

### IMP-022 — SECURITY, CONTRIBUTING, CHANGELOG for the repo → applied on 2026-07-11, commit 63312bf
- `SECURITY.md` (a real channel: GitHub Security Advisories, no email; client-side
  parts [TO BE DEFINED AT SETUP]); `CONTRIBUTING.md` (the repo's real workflow);
  `CHANGELOG.md` in Keep a Changelog form with a retroactive `v0.1.0` entry +
  `Unreleased`; updating the CHANGELOG wired in as step 3 of `/integrate`.

### IMP-024 — "Declared hybrid" memory regime → applied on 2026-07-11, commit 16cfe1e
- Live in the framework repo are ONLY `LEARNINGS.md` and `sessions/`;
  `STATE`/`TREE`/`INDEX` stay templates. Declared in `CONTRIBUTING.md` and in this
  file's header; `SETUP.md` instructs emptying them on copy (the client's IMPs restart
  from 001).

### IMP-025 — Declared trunk-based + agnostic shared history → applied on 2026-07-11, commit da164c8
- `CONTRIBUTING.md` declares the DELIBERATE exception: trunk-based on `main`
  (integration and stable coincide, a case docs/04 provides for), pre-1.0 tags on
  `main`; docs/04 *Commit format*: no project/client names in the shared history.

### IMP-027 — Brownfield setup path → applied on 2026-07-14, commit ff3c2bc (+7fc8b8e)
- Section "Grafting onto an EXISTING project (brownfield)" in `SETUP.md`: the CASE A/B
  criterion for a pre-existing `.claude/` (the existence of the directory alone is not
  enough), reconciliation of colliding files (the host takes precedence; every
  collision is reported), the first command as a read-only assessment that POPULATES
  the memory from what exists (a real STATE, retroactive `components/`, inherited
  decisions), docs-vs-reality divergences recorded as debt and never fixed as a matter
  of course. The scope of LEVEL 1 clarified in docs/06 (with the end-of-graft
  boundary, 7fc8b8e), "Documentation debt" widened in the `STATE.md` template to cover
  existing-but-wrong documentation, a pointer from the README and a forward pointer to
  step 1. The `graft.sh` script option is NOT included: deferred (see Deferred).

### IMP-028 — Inherited git hygiene at graft time → applied on 2026-07-14, commits 051d02c, 1103ffb, 4cd4363, c623b82
- (b) 051d02c: a one-off `gitleaks detect` over the whole history declared as the
  completion of the baseline (docs/03 + the box in SETUP step 3).
  (d) 1103ffb + review c623b82: `hooks-install.sh` stops on hooks of another origin
  (symlinks included) and on `core.hooksPath` with a correctly scoped remedy;
  `FORCE_OVERWRITE=1` makes a `.bak` backup and never writes through symlinks;
  customisations of its OWN hooks are saved to `.bak` on re-run; the header comment
  aligned with the real behaviour. Six scenarios demonstrated on throwaway repos.
  (a+c) 4cd4363: a guard on the SemVer base in step 1 of `/integrate` + the docs/04
  rationale corrected into descriptive form (`git describe --tags` also accepts
  lightweight tags; no new obligation) + the "Inherited git hygiene" checklist in the
  brownfield section (tag audit, hard-coded version constants, branch topology
  decided-and-declared).

### IMP-029 — Declared language coexistence → applied on 2026-07-14, commit acdefcb → **SUPERSEDED by IMP-040 on 2026-07-21**
- What it did at the time: a "Lingua/e del progetto" entry in the examples of the
  technical rules of `CLAUDE.md`, a checkbox in the step-2 checklist of `SETUP.md`, a
  pointer in the brownfield section: the language of memory/process vs the public
  documentation was decided once, not note by note. It held in greenfield too.
- **Why it no longer holds**: it made the ARTIFACT language a per-project choice, which
  produced an Italian-language template and mixed-language artifacts across projects.
  IMP-040 REPLACES this model with the two-axis rule (artifacts always English,
  interaction configurable). This entry is kept as a record — do not re-apply it.

### IMP-030 — Filling in the [TO BE DEFINED AT SETUP] slots assisted by Claude Code → applied on 2026-07-14, commit 42bc00a
- SETUP step 2 declares the two equivalent modes (by hand with the checklist / in
  dialogue with Claude Code, which interviews you and writes the answers), a variant of
  the first command at step 4, an aligned line in the README. Documentation of existing
  behaviour only: markers without an answer stay `[TO BE DEFINED AT SETUP]`, nothing is
  invented.

### IMP-031 — Grep-visible `[TO BE DEFINED AT SETUP]` markers (never broken by wrap) → applied on 2026-07-17, commit f02e6bb
- Convention in `SETUP.md` §2 (a slot to be filled in sits on ONE single physical line,
  or it escapes the `grep -rn "DA DEFINIRE AL SETUP" .` of the setup and of Step 4 of
  the upgrade); the sentinel `grep -rn "DA DEFINIRE AL$" .` as check 10 of
  `/lint-memory`, with the KNOWN false positives declared (the guidance prose of
  `SETUP.md`, the IMP records of `LEARNINGS.md`), so that it excludes prose without
  suppressing a broken slot elsewhere. It closes with PREVENTION the class of which the
  fixes 7fc8b8e/740b575 had only cured the instances. *(The two greps quoted above are
  the ones as they stood at the time; both are dual-form since IMP-041.)*

### IMP-032 — `hooks-install.sh`: FORCE_OVERWRITE robust on a dangling symlink → applied on 2026-07-17, commit d061f6c
- In the `FORCE_OVERWRITE=1` branch, a `[[ -e "${target}" ]]` guard (it follows the
  link → FALSE only on a dangling one): the `.bak` backup is made where it makes sense,
  the `rm -f` is common to both branches, the header comments are aligned (backup
  "skipped if dangling"). A hermetic RED→GREEN test `scripts/test-hooks-install.sh`
  (gitleaks/npx stubs + a throwaway repo) and the `make test-scripts` target; RED = the
  `cp -L` abort, GREEN = exit 0 + link removed + hook installed + no vacuous `.bak`.

### IMP-033 — The `/harvest-framework` command + the project→framework bridge → applied on 2026-07-17, commits d2856be, c0df16c, f50816f, 534b41d
- MARKING: the `Destination: framework` attribute in the IMP format of `LEARNINGS.md`
  (a single greppable physical line; absent = a project lesson; moot in the framework
  repo). COMMAND: `.claude/commands/harvest-framework.md` collects the marked IMPs
  (default the whole backlog + `$ARGUMENTS`) and prints an ANONYMISED copyable block for
  human curation — read-and-print only: no clone/copy/push/cross-repo (the IMP-009
  boundary, agnosticism); an anti-vacuity check on the empty case; demonstrated on a
  fixture. BRIDGE: the "The bridge to the framework" subsection in docs/06; registration
  in CLAUDE.md + README (Structure), cross-links in README Philosophy / SETUP §5 /
  CONTRIBUTING. A preliminary read-only assessment (multi-agent workflow) → the user's
  decision on the 4 structural points. CHANGELOG `[Unreleased]` at release time via
  `/integrate`.

### IMP-034 — The heavy plan in the framework repo lives in the session note, not in plans/ → applied on 2026-07-17, commit da0e158 (A+C)
- User decision: **A+C** (not B, not D). A (`docs/01`): the "Hybrid regime of the
  framework repo" box in PHASE 2 — a heavy deliverable does NOT create a file in
  `plans/` nor record in `decisions/`; the plan lives as an IMP entry + a session note +
  `[task N/T]` commits (the same checkpoints), the SPECIFIC rule (IMP-024) over the
  general one within its declared scope only; plus a patch to step 1 of RESUMPTION (it
  looked only at `plans/` → a false negative in the hybrid regime). C
  (`sessions/README.md`): the standardised **plan block** sub-format
  (`## Plan (one commit per task)`), which resolves the prose-vs-checklist divergence of
  the two interim applications. Discarded: D (lex specialis = premature abstraction from
  n=1, a drift vector) and B (an ephemeral `plans/`, with a forgettable `git rm`). The
  `CONTRIBUTING.md` cross-link deferred to the README/CONTRIBUTING deliverable (out of
  scope). Dogfooding: this deliverable applied the same interim (3rd occurrence).

### IMP-035 — Disambiguating "skill"/"command"/the `Skill` tool alongside IMP-026 → applied on 2026-07-17, commit ee5b0f8
- Resolved with ONE line of terminological note next to IMP-026 (where the confusion
  arises): "command" = a file in `.claude/commands/` (what the repo uses); the
  `.claude/skills/` FEATURE (IMP-026) is not adopted; the harness calls commands
  "skills" too (platform naming). No glossary (the overload occurred once); the
  distinction is already load-bearing (IMP-037 cites it).

### IMP-036 — Provenance pin: record the framework's `vX` at graft time → applied on 2026-07-18, commit 6de868f
- Approved in the targeted retro after the first real upgrade (brew v0.2.0→v0.5.1,
  2026-07-17): the baseline had been established BY HAND from the content, and the
  3-way of `hooks-install.sh` required the per-version base — with the wrong `vX` the
  merge comes out corrupted SILENTLY. Design D1-D6 approved as a block:
  [[2026-07-18-retro-mirata-imp-036-037]].
- Applied in `SETUP.md`: the pin `.claude/framework-version` (`key: value` lines —
  `version`/`commit`/`grafted`, no parser) created at step 1 of every graft; the FOURTH
  class **"graft state"** declared explicitly in the upgrade taxonomy (outside
  `memory/`: the empty-diff invariant stays intact); preference 0 of Step 0
  (ask/estimate/degrade remain as pre-pin fallbacks); rewriting + RETROFIT at the close
  (Step 6) — which dissolves the non-retroactivity; the "No automation" box updated
  (only `/upgrade-framework` stays deferred, IMP-037); a clause in CASE A (a missing pin
  arrives from the retrofit, it is not created by hand). Zero new tools/permissions;
  agnostic content.

### IMP-038 — Completeness check of the inventory lists in /lint-memory → applied on 2026-07-19, commit 2f69413
- Approved in a dedicated targeted retro (a precondition of the v1.0 assessment), with
  the design verified during application. Check 11 "Inventories vs reality" in
  `lint-memory.md`: a set comparison in BOTH directions
  (exists-but-not-listed / listed-but-non-existent) between the ENUMERATED lists — the
  "Quick commands" of CLAUDE.md; the `commands/`/Makefile lines of the README's
  "Structure", where present; the table of `scripts/README.md` — and the filesystem;
  never the mentions in prose (the enumeration avoids list-vs-prose false positives).
  The Makefile's process targets by STRUCTURAL anchoring (a recipe that invokes
  `scripts/`; `help` excluded): it replaces the positional criterion "above the
  [TO BE DEFINED] banner" of the initial design — fragile because the setup fills in or
  removes the banner — and keeps the client's project targets out of scope. Equivalent
  forms admitted (`make reset-task` ≡ `./scripts/reset-task.sh`); excluded by
  declaration are the CHANGELOG and the IMP records (past states, not current
  inventories).

### IMP-039 — Post-1.0 regime and the definition of «breaking change» for the framework → applied on 2026-07-19, commit 4604da4
- Origin: the deliverable promoting to v1.0.0. The post-1.0 regime existed in `docs/04`
  as a bump table only; what was missing was (a) the DEFINITION of the MAJOR criterion —
  what a breaking change is for a METHOD project, not a code one — and (b) a framing of
  1.0 as no longer a future event. Applied (user-directed within the deliverable, hence
  straight into Applied): `docs/04` (the template, agnostic) defines breaking change on
  the *public contract* with examples for code projects and for method/tooling projects,
  and presents the regimes as a permanent method; `CONTRIBUTING.md` (a NON-template doc
  of the repo) brings the git model to post-1.0 and states the concrete breaking-change
  promise for the framework (a command removed/renamed, an incompatible memory/marker
  format, a structure that breaks grafts/upgrades). A NON-obvious design choice: the
  status «we are at 1.0» lives only in the NON-template docs
  (`CONTRIBUTING`/`CHANGELOG`), never in the `docs/04` template, so as not to break
  agnosticism. Doc commit `4604da4`, CHANGELOG `e8b7ad3`.

### IMP-040 — Two-axis language rule: interaction configurable, artifacts always English → applied on 2026-07-21, commit 0d725df
- Date: 2026-07-20 | Origin: user decision, language deliverable phase 1 (session
  [[2026-07-20-language-rule-phase1]])
- Observed problem: the IMP-029 model ("memory/process language vs public-doc language,
  default = the framework's language") made the ARTIFACT language a per-project choice.
  The result: an Italian-language template, mixed-language artifacts across projects,
  and reduced adoptability — against open-source practice, where repo artifacts are
  conventionally English.
- Applied: it REPLACES the IMP-029 model (rather than accumulating two conflicting
  models) with two axes. (1) **INTERACTION** — the language the agent uses with the user
  in session — CONFIGURABLE, a `[TO BE DEFINED AT SETUP]` slot in CLAUDE.md's technical
  rules; the ONLY configurable axis. (2) **ARTIFACTS** — everything that lands in the
  repo: code, comments, files, README, documentation, memory, FUTURE commits, IMP
  entries, notes — ALWAYS English. Landed as rule 9 of `CLAUDE.md`, appended rather than
  inserted because rules 1/5/6/7/8 are referenced by number from eight other files. Past
  git history is immutable and is never translated. Also rewritten: the technical-rules
  slot (now "Interaction language"), the step-2 checklist of `SETUP.md` and the
  brownfield "Language of the host project" paragraph.
- **The stance is DECLARED, not implicit.** The rule removes pure agnosticism on the
  language axis, and it says so in the rule itself: the framework takes a position here
  on purpose, because English artifacts are the universal practice of open source and
  they keep a project readable, greppable and portable beyond the people who started it.
  The user resolved the tension explicitly as a deliberate opinionated choice rather
  than a default that could be overridden — the alternative considered and discarded was
  a `[TO BE DEFINED AT SETUP]` slot defaulting to English.
- Boundary the rule does NOT cross: it applies to the METHOD's artifacts and to the NEW
  artifacts a project produces. It is not a mandate to bulk-translate a host project's
  pre-existing documentation at graft time — that stays a task the user decides, under
  scope hygiene, exactly like past commits.

### IMP-041 — Translate the entire framework to English → applied on 2026-07-21, branch `feat/english-translation` (commit series `[task N/13]`)
- Date: 2026-07-20 | Origin: user decision, language deliverable phase 1 (session
  [[2026-07-20-language-rule-phase1]])
- Recorded decision (structural; hybrid regime — recorded here instead of in
  `decisions/`): translate ALL framework content from Italian to English — docs/,
  commands/, memory templates and live memory (LEARNINGS, sessions),
  README/SETUP/CONTRIBUTING/SECURITY/CHANGELOG, CLAUDE.md, script comments and
  user-facing messages. NOT translated: past commits (immutable history), file NAMES
  (renames would break references and history), identifiers in scripts,
  conventional-commit types (already English), wikilink targets and session slugs.
- Execution: phase 1 = assessment, rule text, translation inventory, glossary, risk
  analysis — then a STOP for the user's approval of the glossary. Phase 2 = the
  translation itself, one commit per coherent group of files, with the glossary applied
  as law across every file.
- **Behavior-bearing strings, switched WITH backward compatibility.** The
  grep-coupled tokens (`[TO BE DEFINED AT SETUP]`, `Destination: framework`, the
  `hooks-install.sh` marker) moved to English, but every READER accepts the legacy
  Italian form as well. Two consequences: no project grafted with an earlier release
  breaks, and the atomicity requirement of the phase-1 plan became unnecessary — what
  had to come first was only making the readers dual-form (task 2 of the series).
- **Bump: MINOR, not the MAJOR proposed in phase 1.** The phase-1 argument for MAJOR
  rested on the marker switch breaking greps in existing grafts; backward-compatible
  readers remove that premise, so the public contract of the method is not broken. What
  remains is a large content change that adds no capability — by itself not even a
  release — plus one genuinely new rule (IMP-040) and one configuration slot renamed. A
  backward-compatible addition of a rule is the MINOR case of `docs/04`.

## Deferred (not rejected — resumed at the right time)

### IMP-023 — CODE_OF_CONDUCT.md and .github/ templates → deferred on 2026-07-11
- User decision: DEFER. Without a real flow of external contributions they are
  ceremony (the anti-hype filter); they are created on the spot when needed (low cost).
  On resumption: CODE_OF_CONDUCT = Contributor Covenant v2.1 with a placeholder
  contact; `.github/` with minimal issue/PR templates aligned with Conventional Commits
  and the end-of-deliverable cycle.
- Resumption trigger: the first issue/PR from a real external contributor, or the
  user's decision to publicise the repo.

### IMP-026 — Claude Code skills as a managed artifact → deferred on 2026-07-11
- Terminological note (IMP-035): "skill" is overloaded — "command" = a file in `.claude/commands/` (what the repo uses); this IMP concerns the `.claude/skills/` FEATURE (not adopted); the harness calls commands "skills" too (platform naming). Do not conflate them.
- User decision: DEFER (interpretation confirmed: a convention for managing Skills as a
  first-class artifact, NOT a library of concrete skills). No friction observed today
  that would justify them: the commands and the selective loading of docs/memory serve
  the same function (on-demand context).
- Resumption trigger: ≥2 recurring operational procedures in a client project with no
  natural home (neither the technical rules of CLAUDE.md nor a command), or Skills
  becoming the primary vehicle for project procedures in Claude Code. On resumption: a
  minimal agnostic convention (`.claude/skills/README.md` + hooks into `/checkpoint` and
  `/lint-memory`), NEVER a library of concrete skills.

### IMP-027 (the `graft.sh` option) — automated graft script → deferred on 2026-07-14
- User decision: the rest of IMP-027 is APPLIED (see Applied); the script that automates
  the graft (copying the right subset, zeroing LEARNINGS/sessions, the one-off
  `gitleaks detect`, hook handling) is NOT done now — the anti-hype filter: collisions
  are human decisions (the script can only detect them) and the brownfield section of
  `SETUP.md` must be tried in the field first.
- Resumption trigger: after 2-3 real brownfield grafts, when the common pattern is
  distillable from the tested text.

### IMP-037 — The `/upgrade-framework` read-and-print command (the inverse twin of `/harvest-framework`) → deferred on 2026-07-17
- User decision (periodic retro): DEFER (confirmed). A command that ONLY READS AND PRINTS
  (the boundary of `/harvest-framework`/IMP-009) the `vX→vY` upgrade plan — the delta
  from the CHANGELOG, the taxonomy by class, the block of reconciliations — with no
  writes/merges/pushes and no cross-repo git. It abstracts the manual procedure of
  `SETUP.md`, but with 0 real upgrades the common pattern is not distillable: premature
  automation (the anti-hype filter, as with IMP-027 `graft.sh`).
- Resumption trigger: after 2-3 real upgrades, when the common pattern is distillable
  from the tested text (D3 is case #1 of the 2-3 needed; on its own it does NOT fire the
  trigger).
- **Case #1 happened** (targeted-retro annotation 2026-07-18): the first real upgrade was
  performed on 2026-07-17 (brew, v0.2.0→v0.5.1) — see
  [[2026-07-18-retro-mirata-imp-036-037]]. Friction observed: the cost was in the
  file-by-file JUDGEMENT (decisions R1/R3/R4/R5 + the per-version 3-way of
  `hooks-install.sh`), which a read-and-print command does not remove; the manual
  procedure of `SETUP.md` held up (the memory invariant respected, the functional
  verification of the hooks demonstrated). Counter: **1 of 2-3**, trigger NOT fired.
  User decision: deferral CONFIRMED.

### IMP-042 — `/change-language` (an automated translation command) → deferred on 2026-07-20
- User decision (language deliverable, phase 1): DEFER — the same anti-hype filter as
  IMP-027 (`graft.sh`) and IMP-037 (`/upgrade-framework`). A command that automates
  switching a project's artifact language (or grafting the framework into a
  non-English context) is premature with a single manual translation behind us: the
  common pattern is not yet distillable.
- Resumption trigger: after 2-3 real manual uses (full translations or language switches
  performed by hand), when the repeatable steps are distillable from practice. The
  framework's own translation (IMP-041) is case #1, now completed.

## Rejected (with the reason — so they are not re-proposed)
_(none yet)_
