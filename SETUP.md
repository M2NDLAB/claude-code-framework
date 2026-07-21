# SETUP — starting a new project from this template

This guide takes you from "empty template" to "project ready to work with Claude
Code". Estimated time: 15-30 minutes, most of it spent filling in the technical rules.

## 0. Prerequisites

- **git** (the framework is git-centric: branches, per-task commits, hooks).
- **gitleaks** — secret scanning in the hooks. macOS: `brew install gitleaks`.
- **Node.js / npx** — used by commitlint (Conventional Commits).
- *(optional)* **tree** — to regenerate `TREE.md`. Fallback: `git ls-files`.
- *(optional)* **Obsidian** — the `.claude/` directory opens as a vault; the `[[...]]`
  wikilinks become a navigable graph. It is not required: the links work as pointers
  in any editor.

## 1. Copy the template into the new project

> **An EXISTING project?** Read the *Grafting onto an EXISTING project (brownfield)*
> section at the end of this guide first: the copy list below assumes the files are
> absent, and there you will find the reconciliation rules for the ones already
> present (plus the criterion for a pre-existing `.claude/`).

Copy into the root of the new repo: the `.claude/` directory, `CLAUDE.md`, `Makefile`,
`commitlint.config.cjs`, `.gitignore`, `scripts/`. (README.md and this SETUP.md you
may leave out of the final project, or keep them for reference.)

> **`LICENSE`, `CONTRIBUTING.md` and `CHANGELOG.md` are NOT copied.** They are files of
> the framework repo (its licence, its contribution flow, its history): the licence of
> YOUR project is your own choice ([TO BE DEFINED AT SETUP], Root checklist below).
> `SECURITY.md`, on the other hand, is a reusable scaffold: you can copy it and fill in
> its `[TO BE DEFINED AT SETUP]` slots.

Then **write the provenance pin**: create `.claude/framework-version` (it does NOT
exist in the framework repo and must not be looked for there — it is CREATED at every
graft) with the version you are copying. It is the certain base of the 3-way merge of a
future upgrade (see *Upgrading the framework*, Step 0):

```
version: vX.Y.Z     # the framework tag you are copying
commit: <sha>       # git rev-parse <tag>^{commit}, run in the framework repo
grafted: YYYY-MM-DD # today: the date of the graft (it will never change)
```

Flat `key: value` lines, no parser: it is read with `cat`/`grep`. If the framework
reached you as an export without git history, `commit: n/a` — `version` is the field
that matters. The file is committed (it is not a local artifact).

Then: `git init` (if it is not a repo already) and create the integration branch
(`develop`).

## 2. Fill in the `[TO BE DEFINED AT SETUP]` slots

Look for the markers in the template:
`grep -rnE "TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP" .`

> **Convention (grep visibility).** A `[TO BE DEFINED AT SETUP]` *slot* to be filled
> in ALWAYS sits on **a single physical line**: if word wrap breaks it at the end of a
> line it escapes the grep above — and the one in Step 4 of the upgrade — and silently
> stays unfilled. This holds for slots, not for prose that merely names the marker.
> `/lint-memory` has a sentinel that flags broken slots (check 10). The grep also
> accepts the legacy Italian marker, so a project grafted before the English marker
> was introduced is still covered.

Two equivalent modes — pick the one you prefer:
- **by hand**, ticking the checklist below;
- **in dialogue with Claude Code**: ask it to interview you about the
  `[TO BE DEFINED AT SETUP]` slots (guided by this checklist) and to write your
  answers into the right files. It invents nothing: whatever you do not answer stays
  `[TO BE DEFINED AT SETUP]`, and you complete it whenever you like. (See also the
  variant of the first command, step 4.)

Here is the complete list, grouped by file:

### `CLAUDE.md` (the most important one)
- [ ] Header: **project name**, **stack**, **repo**.
- [ ] Rule 5: **where the project documentation lives**.
- [ ] Rule 8: **which components are "sensitive"** (subject to the security gate).
- [ ] Final section **"Project-specific technical rules"**: stack, build/test/lint/run
      commands, standard structure of a component, code conventions, API design,
      datastores, tests/coverage, deployment. This is where the framework becomes
      *your* project.
- [ ] **Interaction language** (in the technical rules): which language the agent
      speaks with you in session. The language of the ARTIFACTS is not configurable —
      it is always English (rule 9); only this axis is yours.

### `.claude/docs/`
- [ ] `02-code-quality.md`: doc-comment tool, error format exposed to clients,
      formatter/linter, where the documentation lives, production artifact format.
      (It is often enough to define them in CLAUDE.md and leave a pointer here.)
- [ ] `03-security-gate.md`: explicit list of the sensitive components (aligned with
      CLAUDE.md rule 8).
- [ ] `04-git-workflow.md`: branching model, **if** different from main/develop/feat.

### `.claude/commands/`
- [ ] `checkpoint.md`: patterns to ignore for `tree`, name of the integration branch.
- [ ] `integrate.md`: real names of the integration and stable branches (the ROLES of
      `docs/04`) used in the integration block.
- [ ] `new-component.md`: standard structure of a component in this project (until
      CLAUDE.md and this file are filled in, `/new-component` is inert).

### `.claude/memory/`
- [ ] `TREE.md`: the `-I '...'` pattern for `tree` suited to your stack.
- [ ] **EMPTY OUT the framework's LIVE memory**: `LEARNINGS.md` arrives with the IMPs
      of the framework itself (hybrid regime, see its `CONTRIBUTING.md`) — bring the
      sections back to empty: the IMPs of YOUR project restart from 001. Delete the
      notes in `sessions/` (keep the README).
- [ ] (The `STATE.md` and `INDEX.md` templates are populated by the first command —
      see point 4; for now leave the instruction blocks in place.)

### `.claude/settings.json`
- [ ] Add to `allow` ONLY the **read-only** commands of your tools (build tool,
      package manager, container CLI) to reduce prompts — e.g. the build/test command.
      The baseline is already set (`allow`: git inspection + safe `add`/`commit`;
      `deny`: push, `reset --hard`, destructive deletions, reading secrets) — the
      principles are in `04-git-workflow.md` ("Permission configuration").
- [ ] Leave `settings.local.json` out of version control (it is already in
      `.gitignore`) and start empty: personal permissions are NOT committed, no vague
      grants of the "stop asking for similar commands" kind.

### Root
- [ ] `scripts/hooks-install.sh`: enable and adapt the **formatting** block for your
      language (see the commented examples in the pre-commit hook).
- [ ] `Makefile`: add the project's `build` / `test` / `run` targets.
- [ ] `.gitignore`: uncomment/add the build artifacts of your stack.
- [ ] **Project licence**: choose the licence of YOUR project and create its `LICENSE`
      (your holder and year). The framework's is not inherited; record the choice in
      `CLAUDE.md` too (technical rules).

## 3. Install the git hooks

```bash
make hooks-install
```

Check: a commit with a non-conventional message must be rejected; a file with a fake
secret must be blocked by gitleaks.

> **Does the repo already have a history?** (a graft onto an existing project) The hook
> only protects commits from now on: complete the baseline with a one-off scan of the
> ENTIRE history, `gitleaks detect` (from the repo root). Assess every finding BEFORE
> going on: a secret in pushed history stays exposed even if you remove it from the
> current files — rotate/revoke it immediately; rewriting the history is a separate
> operation, to be decided with judgement (`docs/03`, baseline).

## 4. First command to Claude Code

Open Claude Code in the project root and give it a command like this one:

> Read `CLAUDE.md` and all the docs in `.claude/docs/`: I want you to internalise the
> way of working (memory, task planning, escalation, security gate, git workflow,
> self-improvement). Then **initialise the memory**: fill `STATE.md` with the real
> initial state of the project (removing the templates' instruction blocks), generate
> `TREE.md` from the current structure, and populate `INDEX.md`. Finally, give me a
> summary of the method as you understood it and flag any `[TO BE DEFINED]` still open.
> Do not write application code in this pass.

*(If at step 2 you chose the dialogue mode)* append to the command:

> Then interview me about the `[TO BE DEFINED AT SETUP]` slots still open, following
> the checklist of step 2 of `SETUP.md`, and write my answers into the right files;
> whatever I cannot answer yet stays `[TO BE DEFINED AT SETUP]`.

From here on the cycle is the one in `.claude/docs/00-overview.md` (see "The
end-of-deliverable cycle"). For every heavy prompt Claude Code will produce a plan in
`.claude/memory/plans/`; at the end of a deliverable it will follow the sequence [if
sensitive] `/security-review` → `/retro` → `/checkpoint` → `/integrate`; when it gets
stuck, `/sos`. The periodic review of the IMP backlog stays `/retro` over the whole
`LEARNINGS.md`.

## 5. Evolving the framework

The process lessons that emerge while working end up in `LEARNINGS.md` as IMP
proposals. The ones that turn out to be useful to *any* project are candidates to go
back into the framework template, for the next project. It is the loop described in
the README's *Philosophy*.

In practice: mark those IMPs with the line `- Destination: framework` (IMP format in
the header of `LEARNINGS.md`), then run `/harvest-framework` — it collects the marked
entries and prints a copyable block for them, ready to be anonymised and re-proposed
as an IMP in the framework repo (`CONTRIBUTING.md`). The command only reads and
prints: the transfer stays your explicit gesture. Details in
`.claude/docs/06-self-improvement.md`, *"The bridge to the framework"*.

---

## Grafting onto an EXISTING project (brownfield)

Steps 1-5 hold for an already-started project too (code, git history, its own docs),
with the differences in this section. Guiding principle: **the host project takes
precedence** — the template INTEGRATES, it does not impose itself; every collision is
reported to the user instead of being resolved silently.

### Before copying: does `.claude/` already exist?

The existence of the directory alone is NOT enough to decide: look at what it contains.

- **CASE A — a previous graft of the framework** (there is a `CLAUDE.md` at the project
  root and `.claude/` contains the framework's `docs/` and `memory/`): do NOT copy the
  template over it — that is the project's memory. Resume from `STATE.md`; if you want
  to update the framework to a more recent version, **follow the dedicated procedure
  *«Upgrading the framework on an already-grafted project»*** at the end of this guide
  — file-by-file reconciliation by class (method / project memory / hybrids), with the
  differences declared to the user. (If the provenance pin
  `.claude/framework-version` is missing, do not create it by hand here: it arrives
  from the retrofit at the close of the upgrade, Step 6.)
- **CASE B — only local harness artifacts** (typically `settings.local.json` created by
  permission approvals; no framework docs or memory): go ahead and copy the template,
  and PRESERVE those local files (they are not versioned and must not be overwritten).

### Reconciling colliding files

The copy list of step 1 assumes the files are absent. If the host project already has
them:

| File | Rule |
|---|---|
| The host's `README.md` | It is PRESERVED: it is the project's public documentation (the framework's README is not copied anyway, step 1). |
| `.gitignore` | It is INTEGRATED: add the template's entries (secrets, `settings.local.json`, etc.) to the host's file, do not overwrite it. |
| `Makefile` | It is INTEGRATED: add the process targets (`hooks-install`, `reset-task`) to the host's one. |
| `SECURITY.md` | If the host already has one, it is preserved/integrated; the template's scaffold is only needed if it is missing. |
| `LICENSE` | The host's stays (the framework's LICENSE is never copied, step 1). |
| Existing git hooks | See step 3: `hooks-install.sh` stops by itself in front of hooks that are not its own or an active `core.hooksPath`, and tells you how to proceed. |

General rule for every other collision: **preserve the host's file, integrate only
what is needed from the template, report the collision to the user**.

### Inherited git hygiene

On a pre-existing git history, before adopting the flow of `docs/04`:

- [ ] **History scanned**: a one-off `gitleaks detect` over the whole history (see the
      box in step 3) — the hook only protects future commits.
- [ ] **Audit of inherited tags**: `git cat-file -t <tag>` on each one (`tag` =
      annotated, `commit` = lightweight). The regime of `docs/04` (*Versioning*)
      creates annotated SemVer tags: work out which SemVer base the versioning
      restarts from (the `/integrate` guard stops on a non-SemVer base); any
      normalisation of the inherited tags is the user's decision — pushed tags are
      shared history.
- [ ] **Version constants in the host's scripts/config**: if a version is hard-coded,
      align it with the tags (or derive it from `git describe`) and record the choice —
      drift between a constant and a tag is a latent bug.
- [ ] **Branch topology**: faced with a dormant remote integration branch (e.g. an old
      `dev`), DECIDE and DECLARE the choice: trunk-based (the two roles coincide — a
      case `docs/04` provides for) or restoring the branch as the integration one.
      Record the choice in the `[TO BE DEFINED AT SETUP]` slots of `docs/04` and in the
      commands' parameters (`checkpoint.md`, `integrate.md` — step 2 of this guide).

### The first command becomes an ASSESSMENT that populates the memory

On an existing project the memory does not start empty: it starts from a snapshot of
what is there. Instead of the command of step 4, use:

> Read `CLAUDE.md` and all the docs in `.claude/docs/`: internalise the method. Then
> make a **READ-ONLY assessment** of the existing project: structure, components, real
> maturity (tests? docs? build?), evident defects, architectural choices visible in the
> code. With that, **initialise the memory**: fill `STATE.md` with the REAL state
> (including the defects and debts you observed), create a note in
> `.claude/memory/components/` for every significant component that already exists,
> record in `.claude/memory/decisions/` the inherited architectural choices you can
> reconstruct (retroactive decisions, marked as such), generate `TREE.md` and populate
> `INDEX.md`. Do NOT fix the divergences between the host's documentation and the
> reality of the code: record them in `STATE.md`, section "Documentation debt".
> Finally, summarise the method back to me and flag the `[TO BE DEFINED]` slots still
> open. Do not write application code in this pass.

It is the assessment → proposal → decision pattern of `00-overview.md` and
`01-task-planning.md`, promoted to a setup step: the assessment TAKES A SNAPSHOT, the
decisions about what to fix stay with the user.

### The host's docs-versus-reality divergences

A README documenting features that do not exist (or the like) is NOT fixed during the
graft: scope hygiene prevails (`00-overview.md`, one change at a time). It is recorded
in `STATE.md` → "Documentation debt" and fixed only as a task decided by the user.
LEVEL 1 of `06-self-improvement.md` (immediate factual corrections) concerns the
documentation of the METHOD and of the managed project, NOT the host's pre-existing
documentation during the graft — see the scope note there. Once the graft is complete,
the host's documentation is to all effects documentation of the managed project:
divergences discovered AFTERWARDS follow the normal rules of `docs/06`; the debts
recorded during the graft are worked off as tasks decided by the user.

### Language of the host project

Rule 9 of `CLAUDE.md` — artifacts always English — applies to the artifacts of the
METHOD and to the NEW artifacts the project produces from the graft onwards. It is
**not** a mandate to bulk-translate what is already there: the host's pre-existing
documentation, written in another language, is left as it is, exactly like past
commits. Translating it is a task like any other, decided by the user, and it follows
scope hygiene (`00-overview.md`, one change at a time) — never something the graft
does on its own initiative.

What you do declare at graft time is the **interaction language** (technical rules of
`CLAUDE.md`, checklist of step 2): decided once, not note by note.

---

## Upgrading the framework on an already-grafted project (`vX` → `vY`)

The **third case**, alongside greenfield (steps 0-5) and brownfield (grafting onto a
project WITHOUT the framework). Here the project ALREADY has a version of the framework
grafted — `CLAUDE.md` at the root, `.claude/docs/` and `.claude/memory/` populated: it
is exactly the condition of **CASE A** above — and it must be brought to a more recent
version **while preserving the accumulated project memory** (STATE, sessions,
decisions, components, the IMP backlog).

It is the DESCENDING direction of the bridge described in `docs/06* (*"The bridge to
the framework"*): while `/harvest-framework` sends lessons UP from the project to the
framework, the upgrade sends a new version of the framework DOWN into the project. It
is also the vehicle by which the framework's fixes (e.g. to `hooks-install.sh`) and a
version's new `[TO BE DEFINED AT SETUP]` slots reach already-started projects.

> **No automation, for now — a choice, not an omission.** With few real upgrades behind
> us this is a guided MANUAL procedure that orchestrates primitives that already exist
> (throwaway branch, `reset-task.sh`, `/checkpoint`, `/integrate`,
> `make hooks-install`, `/lint-memory`). A command/script automating it stays deferred
> until more real upgrades justify it: the same anti-hype filter with which the
> framework defers the automated graft. Document first, try it in the field, automate
> afterwards. (The *provenance pin* `.claude/framework-version`, itself born deferred,
> was promoted after the first real upgrade: the baseline established by hand proved
> to be the most fragile point of the procedure.)

### The mental model: three classes of file, plus the graft state

An upgrade touches ONLY the PROCESS layer, NEVER the project memory. Every file falls
into one of three classes:

- **METHOD** (pure framework, brought to `vY`): `.claude/docs/00-06`, the
  non-customised commands in `.claude/commands/`, the guide READMEs inside
  `.claude/memory/*/`, `scripts/reset-task.sh`, `scripts/README.md`,
  `commitlint.config.cjs`.
- **PROJECT-MEMORY** (stays UNTOUCHED): `.claude/memory/STATE.md`, `TREE.md`,
  `INDEX.md`, `sessions/`, `components/`, `decisions/`, `plans/`. **Verification
  invariant: after the upgrade the `git diff` on `.claude/memory/` must be EMPTY** (the
  only exception: pointers broken by a doc rename — see *Edge cases*).
- **HYBRID** (a framework part that evolves + a project part to preserve, reconciled):
  `CLAUDE.md`, `.claude/settings.json`, `scripts/hooks-install.sh`, `.gitignore`,
  `Makefile`, `LEARNINGS.md`, and the commands customised at setup (`checkpoint.md`,
  `integrate.md`, `new-component.md`).

> **Why hybrids cannot be split "by section".** Filling in the
> `[TO BE DEFINED AT SETUP]` slots is DESTRUCTIVE: when the project fills a marker, the
> string disappears and is replaced by the answer. Once setup is done the file is a
> blend of framework prose + project answers with no greppable boundary left. The only
> robust mechanism for reconciling them is the **3-way merge** with the template at the
> STARTING version (`vX`) as the common base.

Apart from these stands the **provenance pin** `.claude/framework-version` — the FOURTH
species, the **graft state**, which falls into none of the three classes: it is not
METHOD (it does not exist in the framework repo: it is created at every graft, step 1),
it is not PROJECT-MEMORY (the procedure writes it, not the project), and it is not
reconciled 3-way — it is REWRITTEN. Setup creates it, Step 0 reads it as the baseline,
the close of the upgrade updates it (Step 6). It lives outside `.claude/memory/` on
purpose: that way the "empty diff on `memory/`" invariant stays intact even when the
upgrade touches it.

### Precondition: get hold of the framework at `vX` and `vY`

The project COPIED the framework's files, not its git history: the version tags live
only in the framework repo. "What changed" is therefore derived THERE, not in the
project (adding the framework as a *remote* of the project is discouraged: it pollutes
the graph and mixes two version lines). Before starting, get two checkouts (or exports)
of the framework repo: one at the GRAFTED version (`vX`) and one at the TARGET version
(`vY`). They are the *base* and the *theirs* of the 3-way merge.

### Step 0 — Determine the `vX` baseline

Determine `vX` like this, in order of preference:

0. **Read the provenance pin** `.claude/framework-version` (it is in every project
   grafted — or already upgraded once — since the pin exists): the `version` field IS
   the baseline, end of step. The fallbacks below are for pre-pin grafts, and they are
   needed ONCE only: Step 6 writes the pin at the close (retrofit).
1. **Ask** whoever did the graft (they often remember it or wrote it down).
2. **Estimate it** from the content: pick the framework tag whose copy of the
   METHOD-class files matches the project's current ones best — a comparison on the
   real content beats the "tag closest to the graft date" heuristic.
3. **Degrade** honestly: if `vX` stays uncertain, do NOT fake a clean 3-way. Fall back
   to file-by-file reconciliation guided by the CHANGELOG as an index (which is what
   CASE A already prescribes), inspecting every doubtful file.

### Step 1 — Restore point and throwaway branch

From the integration branch with a clean working tree:
`git checkout -b chore/framework-upgrade-vX-to-vY`. The pre-upgrade HEAD is the restore
point: **the memory lives in git, so the safety commit IS already the backup**
(selective restore with `git checkout <pre-upgrade-sha> -- .claude/memory/`). The whole
upgrade is a throwaway unit — if it goes wrong, the branch is deleted (see *Rollback*
in `docs/04`). No extra copy of the memory outside the tree is needed.

### Step 2 — Derive "what changed" (framework side)

In the framework repo, combine two complementary sources:

- **The CHANGELOG as an INDEX** ("which files and why"): the sections between `vX` and
  `vY` — every entry cites the IMP and names the file touched. It is the map of the
  change. (The CHANGELOG is not copied into the project: it is read in the framework
  repo.)
- **`git diff` as the EXACT TEXT**, scoped to the METHOD paths only and EXCLUDING the
  framework's memory:

  ```bash
  git diff vX vY -- .claude/docs .claude/commands .claude/settings.json \
    CLAUDE.md scripts Makefile commitlint.config.cjs .gitignore
  ```

  Excluding `.claude/memory/` is deliberate: the framework's memory is ITS own, it must
  NEVER overwrite the project's.

### Step 3 — Reconcile by class

- **METHOD** → bring the `vY` version over.
- **PROJECT-MEMORY** → do not touch; the `diff` on `.claude/memory/` stays empty.
- **HYBRIDS** → 3-way merge with `base = template@vX`, `theirs = template@vY`,
  `mine = the project's file` (`git merge-file`/`diff3`). The 3-way must achieve this: a
  marker ADDED by `vY` **re-materialises** in the file (a new `[TO BE DEFINED]` to fill
  in); one that was REMOVED **disappears**; one that was MOVED or co-edited surfaces as
  a **conflict** to resolve by hand. Always re-apply the project's
  `[TO BE DEFINED AT SETUP]` answers (branch names, `tree` patterns, formatter, the
  stack's allow-list, the whole "Technical rules" section of `CLAUDE.md`). Trivial
  hybrids (`.gitignore`, `Makefile`) are INTEGRATED (additive union: make sure the lines
  of the `vY` base are present without removing the project's); on `LEARNINGS.md` at
  most the header/format is updated, NEVER the project's IMP entries.

> **Execution boundary (`docs/04`, section of the same name).** The agent PREPARES and
> commits LOCALLY on the upgrade branch; it does NOT merge, does NOT push, does NOT tag.
> Where `vY` changes a RULE (rather than being a factual correction), Level 2 of
> `docs/06` kicks in: it is PROPOSED, not applied silently — *"Never rewrite your own
> rules on your own initiative"* (`CLAUDE.md`, rule 6).

### Step 4 — Re-sync the hooks and audit the markers

`make hooks-install` (idempotent; it saves a `.bak` of the project's formatting block).
Real verification: a fake secret blocked by gitleaks, a non-conventional message
rejected by commitlint. Then
`grep -rnE "TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP" .` to catch the NEW markers
introduced by `vY`, to be filled in with the project's answers (reuse the dialogue of
step 2 of this guide). The dual-form grep matters here: a project grafted before the
English marker existed still carries the Italian one.

### Step 5 — Verify before finalising

- `git diff --stat` and a per-file diff; **confirm the EMPTY `diff` on
  `.claude/memory/`** (a strong invariant: a non-empty diff = a bug in the upgrade,
  stop and investigate).
- The project's `[TO BE DEFINED]` customisations survived in the reconciled files.
- `/lint-memory` on the preserved memory against the new docs (pointers to
  renamed/moved docs, STATE vs git, `LEARNINGS`↔`STATE` coherence, orphan pages).
- The project's build/tests green (even if the upgrade is process-only, confirm the
  project still builds and commits).

### Step 6 — Closing and hand-off

**Update the provenance pin**: rewrite in `.claude/framework-version` the `version` and
`commit` fields with the `vY` you have just brought over; `grafted` is not touched (it
is the date of the original graft). If the project does NOT have the pin (a pre-pin
graft), CREATE it now — that is the retrofit: from this upgrade on the baseline is
certain; unknown `grafted` → `n/a (retrofit YYYY-MM-DD)`. The pin lives outside
`.claude/memory/`, so the invariant of Step 5 stays intact.

`/checkpoint` (the upgrade's session note — `vX→vY`, what was reconciled, what the user
decided; `STATE.md` with the updated framework version; `TREE.md` if the structure
changed). Then `/integrate`: a process-only upgrade of the project does NOT bring
product features/fixes → bump **"no tag"** (`chore`, internal work, not a release):
declare it and omit the tag. The merge of the upgrade branch and the push are HUMAN
actions. If something does not add up at review time, the branch is thrown away: the
memory is safe in the pre-upgrade commit.

### Edge cases (to be handled explicitly)

The "bring the `vY` version over" reconciliation of Step 3 is an OVERWRITE, not a
`sync`, and the 3-way covers co-edits but not everything. These seven cases must be
handled on purpose, or the upgrade leaves the project in an incoherent state:

1. **A file DELETED in `vY` (orphan).** If `vY` removes a METHOD file (a merged doc, a
   deprecated command), overwriting does not delete it: it stays orphaned. The
   `git diff vX vY` shows removals as delete hunks — **apply those too** (`git rm`), and
   close with an anti-orphan check: the set of the project's METHOD files must match
   `vY`'s.

2. **A file RENAMED/RENUMBERED in `vY` (duplicate).** If `vY` renames or renumbers a
   doc/command (e.g. a renumbering of `docs/`), the overwrite creates the new name and
   **leaves the old one** → two files and an ambiguous `CLAUDE.md`/`TREE.md` index. Use
   `git diff -M` as an index of the renames to apply the move (remove the old one, bring
   the new one), not a blind add+delete.

3. **Memory pointers towards renamed docs — the only exception to the invariant.** If
   `vY` renames/renumbers a doc, the `[[wikilink]]`s and the pointers (`docs/04:142`, …)
   in `STATE.md` and in the sessions **dangle**, and `/lint-memory` will flag them as
   broken. Here the "empty diff on `memory/`" invariant and the repair conflict: the way
   out is to treat the repair of the pointers as an **EXPLICIT and DECLARED exception**,
   in a **separate commit** (`docs(memory): update the pointers to the docs renamed by
   vY`), distinct from the upgrade's commits. That way the invariant stays useful (it
   catches ACCIDENTAL edits to the memory) and the necessary repair does not slip
   through unnoticed. It is the only legitimate touch to the memory during an upgrade,
   and only if a rename forces it.

4. **Installed hooks (`.git/hooks/*`) live outside the git graph.** The
   `make hooks-install` of Step 4 materialises the hooks in `.git/hooks/`, which is
   neither tracked nor on the branch. Two consequences: (a) if you forget the re-run,
   the installed hooks stay old while `hooks-install.sh` is updated — a silent
   incoherence; (b) **throwing away the branch does NOT uninstall** the new hooks
   already materialised, and the safety commit never captured them. Therefore: the
   re-run is MANDATORY, not optional; and if you abort the upgrade after Step 4, re-run
   `make hooks-install` from version `vX` to bring the hooks back in line with the
   restored code.

5. **Crossing `1.0.0` (`0.x → 1.0`) changes LIVE rules.** Updating `docs/04` across the
   first stable release is not just text: it changes the versioning regime (in `0.x` the
   tags live on the development branch, from `1.0.0` on the stable one) underneath a
   project that is already operating with the old rule. If the project is in the middle
   of a release cycle of its own, **stop and tell the user**: updating a PROCESS doc can
   change LIVE semantics, not just prose.

6. **A multi-version jump (`v0.1 → v0.4`): the order of the migrations.** A `git diff`
   between the ENDPOINTS collapses the intermediate steps: fine for additions/removals
   that cancel out, but it **loses the order of non-commutative migrations** (e.g. a file
   renamed in `vX+1` and then restructured in `vX+2`) and merges multiple fixes to the
   same file into a single hunk. For a jump of several versions, use the **per-version**
   CHANGELOG as an index of the order and, on the most intricate files (typically
   `hooks-install.sh`), reconcile **one version at a time** instead of in one go.

7. **Pre-flight: has the "pure METHOD" file been customised inline?** The METHOD class
   assumes that `docs/02/03/04` stay templates (their `[TO BE DEFINED]` slots are
   resolved by convention in `CLAUDE.md` with a pointer). But if the project filled them
   in **inline** — or freely edited an otherwise pure file (`commitlint.config.cjs`, a
   doc) — that file is in fact a HYBRID, and the overwrite destroys its customisation
   silently. Before overwriting a METHOD-class file, **inspect** that it really is
   untouched with respect to `vX`; if it diverges, treat it as a hybrid (3-way).

> **Outside the upgrade payload.** `LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md` are
> files of the FRAMEWORK REPO (not copied into the project, step 1): do not push them
> into the project and do not read them from the project. `SECURITY.md`, `README.md` and
> this `SETUP.md` inside the project are optional/for reference — and be careful **not
> to overwrite the project's `README.md`** with the framework's. `settings.local.json`
> (unversioned) stays intact by construction.
