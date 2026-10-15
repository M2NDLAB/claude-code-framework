# SETUP — starting a new project from this template

This guide takes you from "empty template" to "project ready to work with Claude
Code". Estimated time: 15-30 minutes, most of it spent filling in the technical rules.

## 0. Prerequisites

The tools, by name; how to install each one depends on your platform.

- **git 2.31 or later** (the framework is git-centric: branches, per-task commits,
  hooks; `make hooks-install` and the upgrade's checks use `rev-parse --path-format`).
- **bash 3.2 or later, with a POSIX userland** (`awk`, `sed`, `grep`, `find`, `xargs`,
  `sort`, `diff`, …): the framework's scripts and hooks are bash. macOS and Linux have
  them; on Windows, Git for Windows brings both with Git Bash, which Claude Code needs too,
  for its Bash tool and its hooks (*Hardening*, below).
- **GNU make** — the process targets (`make hooks-install`, `make test-scripts`,
  `make reset-task`). macOS has it with Xcode's command-line tools, Linux distributions
  with their build tools; on Windows install it apart: Git for Windows ships none.
- **gitleaks 8.18.2 or later** (https://github.com/gitleaks/gitleaks) — secret scanning in
  the pre-commit hook, `gitleaks protect --staged` (hidden from `--help` since 8.19.0, for
  `gitleaks git`; it still runs). A security minimum, read at gitleaks' source: below it the
  scan can let a secret through in silence — a configured external diff replaces what it
  reads (8.18.2 brings `--no-ext-diff`), from 8.4.0 a scan error ends in "no leaks found"
  and exit 0, and 8.0.0 to 8.1.3 write into the project a `.gitleaks.toml` that later
  releases then load instead of their own rules. So the prerequisite check FAILS below it,
  or when it cannot read gitleaks' version, and `make hooks-install` stops. Debian 13's and
  Ubuntu 24.04's packages are 8.16.0: install a release instead.
- **Node.js 22.12 or later, with npx.** commitlint (Conventional Commits) runs through npx
  at the version `scripts/check-prerequisites.sh` pins — its two packages; their own
  dependencies follow the ranges they declare —, and that version's `engines` set the
  minimum. The agent git guard, `scripts/agent-git-guard.mjs`, runs on Node.js too: without
  a working `node`, delegated agents lose their shell tools (fail-closed, `docs/04`) and the
  main session sees a notice on every call.
- *(optional)* **tree** — to regenerate `TREE.md`. Fallback: `git ls-files`.
- *(optional)* **Obsidian** — the `.claude/` directory opens as a vault; the `[[...]]`
  wikilinks become a navigable graph. It is not required: the links work as pointers
  in any editor.

**Check them** with `bash scripts/check-prerequisites.sh` — without make, from the
framework's clone or from the project once step 1 has copied `scripts/`. It runs each tool
above and compares its version with the minimum, names the platform and whether the CI
below verifies it — the release and the architecture of one of its images; on Windows it
names the image and says no more, Git Bash's `uname` giving a build, not an edition —, and
warns when `core.autocrlf` is true and nothing holds the framework's files to LF (run from
the project's root, it reads the project's). It fails
for a tool missing or one that does not start, and for gitleaks below its security minimum
or with a version it cannot read; any other version below its minimum is a warning. It
installs nothing.

**The platforms verified.** The framework's repository runs `make test-scripts`, the
upgrade check's self-test, the prerequisite check and the generated hooks with the real
gitleaks and commitlint at every push, on three GitHub-hosted images — its own
`.github/workflows/test.yml`, which setup does not copy; the prerequisite check carries the
same list of images, which the framework's documentation check holds to the workflow's:

| Platform | Image | bash | Node.js |
| --- | --- | --- | --- |
| macOS 26, arm64 | `macos-26` | 3.2, the system's `/bin/bash` | 24 |
| Ubuntu 24.04, x64 | `ubuntu-24.04` | 5.2 | 22 |
| Windows Server 2025, x64 | `windows-2025` | 5.3, Git Bash | 22 |

- The images bring their own tools; the CI installs GNU make on Windows and gitleaks on
  the three, each at a fixed version — gitleaks' archive checked against a fixed SHA-256
  before it runs. The real hooks' commit-msg makes npx fetch commitlint from the npm
  registry, as it does in a project: its two packages at their pin, their dependencies by
  the ranges they declare, no hash checked. The Node.js column is what the images carried when v1.5.0 was released;
  each run's log names every version (its *Versions* step). The minimums in the list above
  are the tools' own requirements, not runs.
- On Windows, `core.autocrlf` is `true`, as Git for Windows sets it, and `.gitattributes`
  keeps the framework's files LF; the hooks' self-test skips its dangling-symlink case,
  which Git Bash cannot plant.
- Not verified: another release of macOS or Ubuntu than the images', other Linux
  distributions, WSL, Linux or Windows on arm64, macOS on Intel; nor another Windows
  release, which the prerequisite check cannot tell from the image's.

## 1. Copy the template into the new project

> **An EXISTING project?** Read the *Grafting onto an EXISTING project (brownfield)*
> section at the end of this guide first: the copy list below assumes the files are
> absent, and there you will find the reconciliation rules for the ones already
> present (plus the criterion for a pre-existing `.claude/`).

**Start the repository first.** The graft goes on a branch of its own and reaches the
integration branch like any deliverable, so that branch must exist on the remote before it.
Create the remote empty — no README, no licence — and run two blocks from the new project's
directory: the first local, the second the publication. The branch names are the ROLES of
`docs/04` (*Branching model*): `develop` and `main` by default; in a trunk-based project the
two are one branch, so drop `<stable>` from both blocks. No hook exists yet: the commit's
message is given ready, in the Conventional Commits form.

```bash
git init -b <integration> \
  && git commit --allow-empty -m "chore: start the repository" \
  && git branch <stable> \
  && git remote add origin <the remote's URL> \
  && test "$(git rev-list --count <integration>)" = 1 && echo "root: OK"
```

Once the first block has printed `root: OK`, publish:

```bash
git push --atomic -u origin <integration> <stable>
```

If the forge created the remote with a first commit — a README or a licence made from its
web interface —, start from that commit instead: clone the remote, and in a two-branch
model create the integration branch from it (`git switch -c <integration>`) and publish it
(`git push -u origin <integration>`); in a trunk-based one the clone's branch already is
the integration branch. The forge's files are the project's own: where the copy below
collides with one of them — a `.gitignore` the forge wrote —, reconcile it as the brownfield
section says, never overwrite it.

Then open the graft's branch, `git switch -c chore/graft-framework`: everything that follows
is committed there, and integrated at step 4.

Copy into the root of the new repo: the `.claude/` directory, `CLAUDE.md`, `Makefile`,
`commitlint.config.cjs`, `.gitignore`, `.gitattributes`, `scripts/`. (README.md and this
SETUP.md you may leave out of the final project, or keep them for reference.)

> **`LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md`, `tools/` and `.github/` are NOT copied.**
> They are files of the framework repo (its licence, its contribution flow, its history,
> its own checks, its CI): the licence of YOUR project is your own choice
> ([TO BE DEFINED AT SETUP], Root checklist below).
> `SECURITY.md`, on the other hand, is a reusable scaffold: you can copy it and fill in
> its `[TO BE DEFINED AT SETUP]` slots.

Then **write the provenance pin**: create `.claude/framework-version` (it does NOT
exist in the framework repo and must not be looked for there — it is CREATED at every
graft) with the version you are copying. It is the certain base of the 3-way merge of a
future upgrade (see *Upgrading the framework*, Step 0):

```
version: vX.Y.Z     # the framework tag you are copying
commit: <sha>       # that tag's commit, resolved IN the framework repo (see below)
grafted: YYYY-MM-DD # today: the date of the graft (it will never change)
```

Flat `key: value` lines, no parser: it is read with `cat`/`grep`. If the framework
reached you as an export without git history, `commit: n/a` — `version` is the field
that matters. The file is committed (it is not a local artifact).

Resolve `commit` with `git -C "${FW:?}" rev-parse "vX.Y.Z^{commit}"`, where `FW` is the
absolute path of the framework clone — never from the project's directory: an existing
project may carry a tag with the same name, and a bare `git rev-parse` there returns
the PROJECT's commit, silently, into the base of the next upgrade. The `^{commit}`
matters too: on an annotated tag the bare form returns the tag object's id. (Why
`${FW:?}` and not `$FW`: see the *Precondition* of *Upgrading the framework*.)

On Windows git records no executable bit (`core.fileMode` is false there):
give the scripts theirs as you add them,
`git add --chmod=+x -- scripts/*.sh scripts/*.mjs`, or they enter the history as `100644` —
not executable in a teammate's checkout on macOS or Linux, and a mode failure in every
check of a future upgrade.

## 2. Fill in the `[TO BE DEFINED AT SETUP]` slots

Look for the markers in the template:

```bash
grep -rnE "TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP" --exclude=SETUP.md --exclude=LEARNINGS.md --exclude='[0-9][0-9][0-9][0-9]-*' .
```

> **Convention (grep visibility).** A `[TO BE DEFINED AT SETUP]` *slot* to be filled
> in ALWAYS sits on **a single physical line**: if word wrap breaks it at the end of a
> line it escapes the grep above — and the one in Step 4 of the upgrade — and silently
> stays unfilled. This holds for slots, not for prose that merely names the marker. In
> the framework's own files the literal marker appears in slots only — prose calls it the
> setup marker —, so every line the grep prints from them is a slot to fill; its
> exclusions leave out what records the marker rather than marks a slot: a copy of this
> guide kept in the project, the backlog of `LEARNINGS.md`, the dated session notes.
> `/fw:lint-memory` has a sentinel that flags broken slots (check 10). The grep also
> accepts the legacy Italian marker, so a project grafted before the English marker
> was introduced is still covered.

Two equivalent modes — pick the one you prefer:
- **by hand**, ticking the checklist below;
- **in dialogue with Claude Code**: ask it to interview you about the
  `[TO BE DEFINED AT SETUP]` slots (guided by this checklist) and to write your
  answers into the right files. It invents nothing: whatever you do not answer stays
  `[TO BE DEFINED AT SETUP]`, and you complete it whenever you like. (See also the
  variant of the first command, step 4.) It writes each answer with its file tools, an
  edit of the slot's own text — never `sed -i`, a line number or a script: the grep's
  output is the list of what to fill, not a set of coordinates (`CLAUDE.md`, rule 10).
  Stage what step 1 copied before the interview; after it, `git diff` shows what the
  interview wrote, the memory's initialisation beside the answers — read it before
  staging it.

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
      CLAUDE.md rule 8) — the list step 2 of the end-of-deliverable cycle points to.
- [ ] `04-git-workflow.md`: branching model, **if** different from main/develop/feat;
      the merge form the project adopts — Pull Request or the `/fw:integrate` block
      (*Merge*); what the project's public contract is, the criterion of a MAJOR
      (*Versioning*).

These three docs are HYBRID: an answer written inline, or a pointer to `CLAUDE.md` in place
of the slot, survives every upgrade, which merges them three ways.

### `.claude/commands/fw/`
- [ ] `fw/checkpoint.md`: patterns to ignore for `tree`, name of the integration branch — its
      placeholders `<pattern-to-ignore-for-the-stack>` and `<integration>`, then the
      paragraph at its top that marks them.
- [ ] `fw/integrate.md`: the names of the integration and stable branches (the ROLES of
      `docs/04`), on step 1's line only — the agent substitutes them in the blocks it
      prints; in a trunk-based project the two are one branch.
- [ ] `fw/new-component.md`: standard structure of a component in this project, and its
      production artefact (until CLAUDE.md and this file are filled in,
      `/fw:new-component` is inert).

### `.claude/memory/`
- [ ] `TREE.md`: the `-I '...'` pattern for `tree` suited to your stack.
- [ ] `decisions/README.md`: where formal ADRs live, if the project keeps any (an
      `adr/` folder, a wiki, a docs site).
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
      principles are in `04-git-workflow.md` ("Permission configuration"). The `env`
      marker `AGENT_GIT_BOUNDARY` and the PreToolUse hook that runs
      `scripts/agent-git-guard.mjs` are the method's boundary wiring, and the `ask`
      rules on edits to these two files are its checkpoint: leave them in
      (`04-git-workflow.md`, "Enforcement of the execution boundary").
- [ ] Leave `settings.local.json` out of version control (it is already in
      `.gitignore`) and start empty: personal permissions are NOT committed, no vague
      grants of the "stop asking for similar commands" kind.

### Root
- [ ] `scripts/hooks-install.sh`: enable and adapt the **formatting** block for your
      language (see the commented examples in the pre-commit hook).
- [ ] `Makefile`: add the project's `build` / `test` / `run` targets, and set
      `PROTECTED_BRANCHES` — the branches `make reset-task` must never touch (your
      integration and stable branches).
- [ ] `.gitignore`: uncomment/add the build artifacts of your stack.
- [ ] **Project licence**: choose the licence of YOUR project and create its `LICENSE`
      (your holder and year). The framework's is not inherited; record the choice in
      `CLAUDE.md` too (technical rules).
- [ ] `SECURITY.md`, if you copied the scaffold (step 1): its slots — how to report a
      vulnerability, response times, supported versions.

## 3. Install the git hooks

```bash
make hooks-install
```

First it runs the prerequisite check for what the hooks need
(`check-prerequisites.sh --hooks`, §0): a tool missing or not starting stops it before any
hook is written. It installs three hooks: gitleaks (pre-commit), commitlint (commit-msg) and the push
boundary (pre-push: a push launched from a Claude Code session is refused — the human
pushes from their own terminal). Check: a commit with a non-conventional message must be
rejected; a file with a fake secret must be blocked by gitleaks; `make test-scripts` must
pass — it proves the pre-push on a throwaway repository and the delegated agents' guard on
the command forms its cases list. A pre-push of your own (git-lfs's, for one): see Step 4 of the upgrade.

**The graft's first commit comes now**, on its branch, so the hooks just checked see it:
name its paths — what step 1 copied, the pin, the answers of step 2 —, never `git add .`.

**What the pre-commit's scan reads.** gitleaks scans the staged changes as `git diff` shows
them. The hook turns git's colour off and reads each textconv driver as `cat` for it, so a
configuration that would empty or convert that output hides no secret. A file git shows as
binary although it holds text — the attribute `binary` or `-diff`, a diff driver's
`binary = true` — is copied from the index into a directory only the user can read, under
`TMPDIR`, and scanned apart; the hook removes the directory when it ends, on an error or a
Ctrl-C too. Measured on an arm64 Mac: 50 MB of such text adds about 12 s, a tenth of what
the scan takes on the same text staged plain, and a file binary by its content costs its
first 8000 bytes — so no size limit. Known limits: a file binary by its content (a NUL in
its first 8000 bytes) is not scanned, as gitleaks reads text; a `git -c` naming the colour
or a textconv on a commit's command line wins over the hook's settings — a deliberate
choice, outside the threat model (`docs/04`, *Enforcement of the execution boundary*); a
SIGKILL during the scan, which no process can catch, leaves its directory behind, in the
user's own temporary directory; the commits git creates itself — a rebase's `--continue`,
`git am`, a cherry-pick or a revert that applies cleanly — run no pre-commit at all, while a
cherry-pick's `--continue` after a conflict and a merge concluded by `git commit` do
(measured on git 2.54.0); the scan apart passes over a file whose first bytes are an
application's signature (`MZ`, `%PDF`, …) and over a type change — a symlink turned into a
key file marked binary goes through (measured) —, and with `GITLEAKS_CONFIG_TOML` set it
still reads the project's `.gitleaks.toml`, which `gitleaks protect` reads only after that
variable (read at gitleaks' source); a clean filter rewrites what is staged before the scan
sees it — under git-lfs a pointer, the content reaching the LFS store unscanned (measured
with a filter like git-lfs's).

> **Does the repo already have a history?** (a graft onto an existing project) The hook
> only protects commits from now on: complete the baseline with a one-off scan of the
> ENTIRE history, from the repo root:
>
> ```bash
> GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=color.diff GIT_CONFIG_VALUE_0=never gitleaks detect
> ```
>
> The three variables, git's documented environment configuration, turn its colour off for
> the scan: a colour your git configuration forces to "always" leaves gitleaks nothing to
> read, and it reports a clean history. If `git config --get-regexp '^diff\..*\.textconv$'`
> lists a textconv driver, gitleaks reads that driver's conversion instead of what was
> committed: add one pair per driver, `GIT_CONFIG_COUNT=2` with
> `GIT_CONFIG_KEY_1=diff.<driver>.textconv GIT_CONFIG_VALUE_1=cat`. The scan does not read
> what the history shows as binary (measured: a key committed in a `*.key binary` is not
> found): if the project marks text files `binary` or `-diff`, scan their current content as
> files too, `gitleaks detect --no-git --source <path>`. Nor does it read what a merge's own
> resolution introduced, or a type change (read at gitleaks' source). Assess every finding BEFORE going
> on: a secret in pushed history stays exposed even if you remove it from the
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
> the checklist of step 2 of `SETUP.md`, and write my answers into the right files, each
> an edit of the slot's own text with your file tools; whatever I cannot answer yet stays
> `[TO BE DEFINED AT SETUP]`.

From here on the cycle is the one in `.claude/docs/00-overview.md` (see "The
end-of-deliverable cycle"). For every heavy prompt Claude Code will produce a plan in
`.claude/memory/plans/`; at the end of a deliverable it will follow the sequence [if
under the gate] `/fw:security-review` → `/fw:retro` → `/fw:checkpoint` → `/fw:integrate`;
when it gets stuck, `/fw:sos`. The periodic review of the IMP backlog stays `/fw:retro` over the whole
`LEARNINGS.md`.

The graft itself is the project's first deliverable: closed with that cycle — its session
note's security-gate line says whether it is under the gate, since it installs the security
baseline (the hooks, the permissions) — and integrated with `/fw:integrate`'s no-tag blocks
onto the branch the first block of step 1 started.

## 5. Evolving the framework

The process lessons that emerge while working end up in `LEARNINGS.md` as IMP
proposals. The ones that turn out to be useful to *any* project are candidates to go
back into the framework template, for the next project. It is the loop described in
the README's *Philosophy*.

In practice: mark those IMPs with the line `- Destination: framework` (IMP format in
the format comment of `LEARNINGS.md`), then run `/fw:harvest-framework` — it collects the
marked entries and prints a copyable block for them, ready to be anonymised and
re-proposed in the framework repo (`CONTRIBUTING.md`), where a lesson already received
counts once. The command only reads and
prints: the transfer stays your explicit gesture. Details in
`.claude/docs/06-self-improvement.md`, *"The bridge to the framework"*.

## Hardening

The method's own layer (`.claude/docs/04-git-workflow.md`, *Enforcement of the execution
boundary*) has a declared threat model: an agent's ACCIDENTAL errors with ordinary
commands — the kind every real incident was. Deliberate evasion (disabling a hook,
unsetting the session marker, writing to the forge with the owner's credential) is
outside it: only the forge's rules or the operating system stop it.

**Start Claude Code at the repository's root.** Claude Code reads `.claude/settings.json`
from the session's working directory only, with no fallback to the directories above: a
session started in a subdirectory, or moved there with `/cd`, runs without the guard, the
`deny` and `ask` rules, the session marker and the SessionStart hook, and nothing says so —
only the `pre-push` still refuses its push (`docs/04`, *Enforcement of the execution
boundary*). A session that opens without `STATE.md` injected loaded no settings, or runs
no hook.

**On Windows, Git Bash.** The method's layer is wired for the Bash tool, which on Windows
runs in Git Bash (Git for Windows, a prerequisite); Claude Code runs the hooks there too.
Its PowerShell tool is kept off by `CLAUDE_CODE_USE_POWERSHELL_TOOL=0` in
`.claude/settings.json`: with the tool on, Claude takes PowerShell as its primary shell, and
a `bash` called from PowerShell can be WSL's. A developer who turns it on keeps the guard —
it reads PowerShell's commands too, in the forms its self-test lists — and the `pre-push`; the
`deny` rules, Bash rules, do not reach it.

**In auto mode.** The method's layer holds there too: auto mode allows pushes to any branch
of the working repository, the default branch included, and the `pre-push` is what stops a
push from the session, however it is spelled (`docs/04`, *Enforcement of the execution
boundary*). As a net for the usual spelling in the repositories without the framework, the
`ask` rules Claude Code's documentation suggests — `Bash(git push *)` and
`Bash(gh pr create *)`, in your own `~/.claude/settings.json` — prompt even in auto mode, for
commands that begin that way only; in a framework project the `deny` on `Bash(git push:*)`
answers first. And auto mode's own settings are read only from `~/.claude/settings.json`,
managed settings and `--settings`: what its setup command drafts from one repository — a
trusted repository, a visibility — holds for every project, so write it in a form true for
all of them.

Two layers beyond the method, neither switched on by the template:

- **Server-side layer — the forge's rules.** They hold for every client and every route
  (git, the forge's CLI, its API), the owner included when no bypass is granted. The
  framework's own repository runs two GitHub rulesets with NO bypass actor: on the
  default branch, *Block force pushes* and *Restrict deletions*; on `refs/tags/v*`,
  *Restrict updates* and *Restrict deletions* (force pushes blocked too). They stop the
  IRREVERSIBLE operations — rewriting or deleting the main line, moving or deleting a
  release tag — for the human and the agent alike, and leave the `/fw:integrate` flow alone:
  a normal push and a NEW tag go through. They are not the push boundary (the `pre-push`
  is). Do not add *Require a pull request* to a single-developer `/fw:integrate` flow: it
  rejects the direct push of the local `--no-ff` merge, and an owner's bypass is also the
  bypass of an agent holding the owner's credential. Residual, outside the threat model:
  removing the ruleset, or writing to the remote with an owner credential (`gh`, `curl`).
  On GitHub, rulesets are free on public repositories only; GitLab and Bitbucket have
  protected branches.
- **OS layer — the Claude Code sandbox** (`sandbox.enabled` in `.claude/settings.json`):
  an OPTION, not a recommendation. It enforces network and filesystem limits through the
  operating system, whatever the command's spelling. Its cost: the network allowlist is
  per DOMAIN, so allowing the forge for fetch allows push too; each project curates its
  own allowlists (registries, the forge) or fetch and installs fail; only Bash is
  sandboxed, not the file tools or MCP servers; Linux and WSL2 need bubblewrap and socat,
  native Windows is unsupported; and the unsandboxed retry must be switched off
  (`allowUnsandboxedCommands: false`), or a failing command can be retried outside it.

**Keep the framework out of what you deploy.** The framework serves development only, but its
files sit in the repository: a build that copies the whole repository — a container image
built with `COPY . .` from the root, for one — carries them into production, the project's
memory included, and from a working tree also what git ignores there, such as
`settings.local.json` and the agents' worktrees. Keep them out with your stack's own
mechanism — the build context's ignore file, or an explicit list of what is copied: the
`.claude/` directory whole, `CLAUDE.md`, the framework's scripts, `commitlint.config.cjs`;
the files the project also owns — the `Makefile`, `.gitignore`, `.gitattributes` — stay its
own call. The class table names every framework file (`tools/upgrade-check.sh classes <tag>`,
*The mental model: the classes of file, and the graft state*). The framework ships no ignore
file for this: such files depend on the stack.

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
  *"Upgrading the framework on an already-grafted project"*** at the end of this guide
  — file-by-file reconciliation by class (method, hybrids, memory templates, project
  memory), with the
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
| `.gitattributes` | It is INTEGRATED: add the template's lines (LF line ends for the framework's paths) AFTER the host's — for the same path a later line wins —, do not overwrite it. |
| `Makefile` | It is INTEGRATED: add the process targets (`hooks-install`, `reset-task` with its `PROTECTED_BRANCHES` variable, `test-scripts`) to the host's one. |
| `SECURITY.md` | If the host already has one, it is preserved/integrated; the template's scaffold is only needed if it is missing. |
| `LICENSE` | The host's stays (the framework's LICENSE is never copied, step 1). |
| Existing git hooks | See step 3: `hooks-install.sh` stops by itself in front of hooks that are not its own or an active `core.hooksPath`, and tells you how to proceed. |

General rule for every other collision: **preserve the host's file, integrate only
what is needed from the template, report the collision to the user**.

### Inherited git hygiene

On a pre-existing git history, before adopting the flow of `docs/04`:

- [ ] **History scanned**: a one-off `gitleaks detect` over the whole history (see the
      box in step 3) — the hook only protects future commits.
- [ ] **Hook managers**: a hook manager — husky, lefthook, simple-git-hooks — sets up its
      own hooks when it runs: husky sets `core.hooksPath` at every `npm install`, unless
      `HUSKY=0`, and from then on git reads none of the hooks of step 3, without a word
      (`docs/04`, *Enforcement of the execution boundary*). If the host has one, at the
      root or in a subdirectory, integrate the hooks' commands into it — the durable
      choice. The three commands print nothing when there is none:

  ```bash
  git config --show-origin --get core.hooksPath
  git ls-files | grep -E '(^|/)(\.husky/|\.?lefthook\.|\.?simple-git-hooks\.)'
  git grep -l -E '"(husky|lefthook|simple-git-hooks)"' -- '*package.json'
  ```
- [ ] **Audit of inherited tags**: `git cat-file -t <tag>` on each one (`tag` =
      annotated, `commit` = lightweight). The regime of `docs/04` (*Versioning*)
      creates annotated SemVer tags: work out which SemVer base the versioning
      restarts from (the `/fw:integrate` guard stops on a non-SemVer base); any
      normalisation of the inherited tags is the user's decision — pushed tags are
      shared history.
- [ ] **Version constants in the host's scripts/config**: if a version is hard-coded,
      align it with the tags (or derive it from `git describe`) and record the choice —
      drift between a constant and a tag is a latent bug.
- [ ] **Branch topology**: faced with a dormant remote integration branch (e.g. an old
      `dev`), DECIDE and DECLARE the choice: trunk-based (the two roles coincide — a
      case `docs/04` provides for) or restoring the branch as the integration one.
      Record the choice in the `[TO BE DEFINED AT SETUP]` slots of `docs/04` and in the
      commands' parameters (`fw/checkpoint.md`, `fw/integrate.md` — step 2 of this guide).

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
METHOD and to the NEW artifacts the project produces from the graft onwards (for a
project grafted earlier: from the upgrade that crossed v1.1.0, which brought the rule). It is
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

It is the DESCENDING direction of the bridge described in `docs/06` (*"The bridge to
the framework"*): while `/fw:harvest-framework` sends lessons UP from the project to the
framework, the upgrade sends a new version of the framework DOWN into the project. It
is also the vehicle by which the framework's fixes (e.g. to `hooks-install.sh`) and a
version's new `[TO BE DEFINED AT SETUP]` slots reach already-started projects.

> **Mechanical checks, not an orchestrating command — a choice, not an omission.** The
> procedure stays a guided MANUAL one, built on primitives that already exist (throwaway
> branch, `make reset-task`, `/fw:checkpoint`, `/fw:integrate`, `make hooks-install`,
> `/fw:lint-memory`): what it asks of a human — how to resolve a conflict, which
> customisation to keep, how to answer a slot — differed at every real upgrade. Its
> MECHANICS did not: which files changed and how much they collide with the project's,
> which slots moved, whether the memory was touched only where allowed. They live in a
> read-only script, `tools/upgrade-check.sh`, which this procedure calls at fixed points
> (*Precondition*); it decides nothing and writes nothing in either repository. A command
> that would orchestrate the steps stays deferred until the first upgrade of a SECOND
> project: the real upgrades behind this procedure were all one project's — the
> same anti-hype filter with which the framework defers the automated graft. (The
> *provenance pin* `.claude/framework-version`, born deferred too, was promoted after the
> first real upgrade: the baseline established by hand proved to be the most fragile
> point of the procedure.)

### The mental model: the classes of file, and the graft state

An upgrade touches ONLY the PROCESS layer, NEVER the project memory. Every file falls
into one of these classes — file by file, the authority is the class table of
`tools/upgrade-check.sh` (`classes <tag>` prints it), and a payload file without a class
makes the framework's own self-test fail:

- **METHOD** (pure framework, brought to `vY`): `.claude/docs/00-01` and
  `.claude/docs/05-06`, the non-customised commands in `.claude/commands/fw/`, `scripts/reset-task.sh`,
  `scripts/agent-git-guard.mjs`, `scripts/repo-snapshot.sh`,
  `scripts/check-prerequisites.sh`, the self-tests `scripts/test-*.sh`,
  `scripts/README.md`, `commitlint.config.cjs`.
- **HYBRID** (a framework part that evolves + a project part to preserve, reconciled):
  `CLAUDE.md`, `.claude/settings.json`, `scripts/hooks-install.sh`, `.gitignore`,
  `.gitattributes`, `Makefile`, the docs a project answers at setup (`.claude/docs/02-04`,
  inline or with a pointer to the technical rules), and the commands customised at setup
  (`fw/checkpoint.md`, `fw/integrate.md`, `fw/new-component.md`).
- **MEMORY TEMPLATES** (the method's own files inside `.claude/memory/`, reconciled 3-way
  like the hybrids): the four guide READMEs — the `README.md` of `components/`,
  `decisions/`, `plans/` and `sessions/` — and, of `LEARNINGS.md`, its HEADER (the lines
  before the first `## `) and its format comment, which sits further down, in the body.
  A project may have customised them
  (the slot of `decisions/README.md` answered, a block pruned, a paragraph of its own in
  the header): the 3-way keeps that, an overwrite would not.
- **PROJECT-MEMORY** (stays UNTOUCHED): `.claude/memory/STATE.md`, `TREE.md`,
  `INDEX.md`, the notes of `sessions/`, `components/`, `decisions/` and `plans/` (their
  READMEs aside), and the IMP entries of `LEARNINGS.md`. Never reconciled 3-way —
  `STATE.md`, `TREE.md` and `INDEX.md` included: in a project they are compiled memory,
  not templates, and a change to their format reaches a project only as a declared
  migration (the titles of edge case 3 (b)). **Verification invariant: during the
  upgrade, `.claude/memory/` is touched only by a CLOSED list** — the memory templates;
  the format lines of edge case 3 (pointers, titles, field labels); the upgrade's own
  session note, plan and decision records; `STATE.md`, `TREE.md` and `INDEX.md` at the
  checkpoint. `upgrade-check.sh invariant` checks it by content (Step 5).

> **Why hybrids cannot be split "by section".** Filling in the
> `[TO BE DEFINED AT SETUP]` slots is DESTRUCTIVE: when the project fills a marker, the
> string disappears and is replaced by the answer. Once setup is done the file is a
> blend of framework prose + project answers with no greppable boundary left. The only
> robust mechanism for reconciling them is the **3-way merge** with the template at the
> STARTING version — read at the tag `vX` (see the *Precondition*) — as the common base.

Apart from these stands the **provenance pin** `.claude/framework-version` — a species of
its own, the **graft state**, which falls into none of these classes: it is not
METHOD (it does not exist in the framework repo: it is created at every graft, step 1),
it is not PROJECT-MEMORY (the procedure writes it, not the project), and it is not
reconciled 3-way — it is REWRITTEN. Setup creates it, Step 0 reads it as the baseline,
the close of the upgrade updates it (Step 6). It lives outside `.claude/memory/` on
purpose: the closed list of Step 5 needs no entry for it.

### Precondition: get hold of the framework at `vX` and `vY`

The project COPIED the framework's files, not its git history: "what changed" is
derived from the framework repo, not from the project (adding the framework as a
*remote* of the project is discouraged: it pollutes the graph and mixes two version
lines). But the tag NAMES are not the framework's alone: the project versions itself
with `vX.Y.Z` too (`docs/04`, *Versioning*), so it may carry tags with the same names.
Resolved from the project's directory, `vY` is the PROJECT's tag: a bare
`git show vY:<path>` exits 0 with the project's file, and a bare `git diff vX vY`
diffs the project's history. The upgrade runs from the PROJECT root, under two rules
that hold for every step below:

1. **The framework is read ONLY as immutable objects, by tag** — `git show <tag>:<path>`,
   `git diff <tagX> <tagY> -- <paths>` (always TWO tags: with one, git compares against
   the working tree), `git ls-tree <tag>`, `git rev-parse "<tag>^{commit}"`. Never its
   working tree, never whatever happens to be checked out: the framework's clone may be
   in use by other sessions — during a real upgrade, a session working on the framework
   ran `git switch main` on the very clone the upgrade was reading. The upgrade itself
   performs no checkout, switch, stash, `worktree add` or commit in the framework repo.
   What it extracts goes, by shell redirection, into a scratch directory `T` outside
   BOTH repos — never through git's own `-o`/`--output`: under `-C`, a relative path
   there resolves inside the framework.
2. **Every FRAMEWORK-side command carries `-C "${FW:?}"` — and only those.** The
   project-side commands stay bare: the upgrade branch, the restore, `git merge-file`,
   `make hooks-install`, the marker grep, `git diff --stat`, `git rm`, writing the pin.
   With `-C` they would act on the framework (`make -C "${FW:?}" hooks-install` installs
   the hooks into the FRAMEWORK's `.git`).

`FW` must be a git clone with its tags — an export has no tags to read by. Set the two
paths once, absolute, and check them (read-only, from the project root):

```bash
FW=/absolute/path/to/the/framework/clone
T=/absolute/path/to/a/scratch/dir
mkdir -p "${T:?}"
: "${FW:?}" && test "$(git rev-parse --show-toplevel)" -ef "$(pwd -P)" \
  && test -z "$(git -C "${FW:?}" rev-parse --show-prefix)" \
  && test "$(git -C "${FW:?}" rev-parse --path-format=absolute --git-common-dir)" \
       != "$(git rev-parse --path-format=absolute --git-common-dir)" \
  && git -C "${FW:?}" rev-parse -q --verify "refs/tags/vY^{commit}" >/dev/null \
  && echo "FW OK" \
  || { echo "STOP: check the cwd (the project root), FW and vY" >&2; false; }
```

The check stops when the current directory is not a repository root, when `FW` is not
a repository root, when `FW` is the project itself (any of its worktrees), and when `vY`
is missing in `FW` — the root compared by identity (`-ef`): on Windows git prints `C:/…`
where Git Bash names the same directory `/c/…`; `--path-format` needs git 2.31 or later.
Why `${FW:?}` and never `$FW`: `git -C ""` runs in the CURRENT directory — the project —
so an unset `FW` silently brings the collision back. A shell that does not keep state
between commands (an agent's tool calls) restates `FW=`, `T=` and the `cd` to the
project root in every command: `${FW:?}` turns a forgotten restatement into a loud
failure, while a bare project-side command run from the wrong directory acts on that
directory's repository.
Inside `$( … )`, `<( … )` or a pipe, a failed `${FW:?}` does not stop the outer
command: start such a line with `: "${FW:?}" &&`. `vX`/`vY` stay placeholders to
substitute, as everywhere in this guide: a forgotten one fails loudly
(`invalid object name`), while an empty variable would turn `vY:<path>` into `:<path>` —
the framework's index.

If the check stops because `vY` is missing, updating the framework clone
(`git -C "${FW:?}" fetch --tags`) is a preparatory step for the human, outside the
procedure: the procedure itself never writes there. The tag `vX` is the *base* and
`vY` the *theirs* of the 3-way merge.

> **Optional: a *bare* clone as `FW`** (`git clone --bare`) — with no working tree, a
> checkout or a working-tree read fails loudly there. It replaces neither the reads by
> tag nor `-C "${FW:?}"`; avoid `--mirror`, whose fetch silently follows a re-created tag.

**The verification script.** From `vY` = v1.4.0 on, the framework carries
`tools/upgrade-check.sh`, the read-only checks of this procedure. Extract `vY`'s copy into
`T` once, and run it from the project root at the points the steps name:

```bash
git -C "${FW:?}" show vY:tools/upgrade-check.sh > "${T:?}/upgrade-check.sh" \
  && FW="$FW" T="$T" bash "${T:?}/upgrade-check.sh" preflight vX vY
```

Always `vY`'s copy — never one kept from an earlier upgrade, never the framework's
working tree: the checks belong to the release you upgrade to, and `preflight` says so
when they do not. It reads the framework only by tag and the project read-only, and
writes only under `"$T/upgrade-check/"`. Each of its lines reads `OK`, `FAIL` (a rule of
this procedure is broken; the exit code is then 1) or `CHECK` (a human looks); it decides
nothing. Its subcommands: `classes` (the class table, file by file), `preflight` (this
Precondition and the pin of Step 0), `inventory` (Step 2), `invariant` and `post`
(Step 5). `tools/` is not copied into the project (step 1). For a `vY` before v1.4.0
there is no script: the steps are done by hand.

**The prerequisites.** From `vY` = v2.0.0 on, run `vY`'s prerequisite check too, before
Step 1: extracted into `T` the same way, run from the project root, whose line ends it
reads.

```bash
git -C "${FW:?}" show vY:scripts/check-prerequisites.sh > "${T:?}/check-prerequisites.sh" \
  && bash "${T:?}/check-prerequisites.sh"
```

A FAIL is a tool to install or repair before Step 4, whose `make hooks-install` runs the
same check — the project's copy, brought over in Step 3 — and stops on it; a WARN, a
version below its minimum, stops nothing.

### Step 0 — Determine the `vX` baseline

Determine `vX` like this, in order of preference:

0. **Read the provenance pin** `.claude/framework-version` (it is in every project
   grafted — or already upgraded once — since the pin exists): the `version` field IS
   the baseline, end of step. `preflight` checks the pin: `version: vX.Y.Z` with its
   `v`, and a `commit` that is that tag's commit, never the tag object. A malformed pin
   is an ERROR that names its correction, never normalised: correct the line by hand
   before going on; when a tag sits on the pinned commit, the script SUGGESTS it and
   applies nothing. The fallbacks below are for pre-pin grafts, and they are needed ONCE
   only: Step 6 writes the pin at the close (retrofit).
1. **Ask** whoever did the graft (they often remember it or wrote it down).
2. **Estimate it** from the content: pick the framework tag whose copy of the
   METHOD-class files matches the project's current ones best — a comparison on the
   real content beats the "tag closest to the graft date" heuristic. Each tag's copy is
   read with `git -C "${FW:?}" show <tag>:<path>`, never by checking the tags out.
3. **Degrade** honestly: if `vX` stays uncertain, do NOT fake a clean 3-way. Fall back
   to file-by-file reconciliation (which is what CASE A already prescribes) guided by
   the CHANGELOG as an index — read at the tag `vY`, as in Step 2 — inspecting every
   doubtful file.

### Step 1 — Restore point and throwaway branch

From the integration branch with a clean working tree:
`git checkout -b chore/framework-upgrade-vX-to-vY`. The pre-upgrade HEAD is the restore
point — write its sha (`git rev-parse HEAD`, before the branch's first commit) in the
upgrade's session note: Step 5's `invariant` checks the memory against it. **The memory
lives in git, so the safety commit IS already the backup**
(selective restore with `git checkout <pre-upgrade-sha> -- .claude/memory/`). The whole
upgrade is a throwaway unit — if it goes wrong, the branch is deleted (see *Rollback*
in `docs/04`). No extra copy of the memory outside the tree is needed.

One thing the restore point does not hold: the installed hooks, which live outside git
(edge case 4). Photograph them into `T` before anything else, from the project root:

```bash
H="$(git rev-parse --path-format=absolute --git-common-dir)/hooks"
test -d "$H" && test ! -e "${T:?}/hooks-before" \
  && mkdir "${T:?}/hooks-before.partial" \
  && cp -pPR "$H/." "${T:?}/hooks-before.partial/" \
  && mv "${T:?}/hooks-before.partial" "${T:?}/hooks-before" \
  && echo "hooks photographed"
```

No "hooks photographed" line = no photograph: find out why before going on. The chain
refuses to overwrite an existing photograph — taken again after Step 4 it would hold
`vY`'s hooks — and a copy that fails halfway never takes the photograph's name (a
leftover `hooks-before.partial` is a failed attempt: look at it, remove it, retry). A
repository with no hooks directory has nothing to photograph: say so in the session note;
the rollback then removes what Step 4 created. The photograph is the only way back for
the hooks: keep `T` until the upgrade branch is merged or thrown away — outside `/tmp`,
which the system may clean — and write its path in the upgrade's session note: an upgrade
resumed or abandoned in a later session needs it.

### Step 2 — Derive "what changed" (framework side)

From the project root, reading the framework only by tag (*Precondition*), combine two
complementary sources:

- **The CHANGELOG as an INDEX** ("which files and why"): the sections between `vX` and
  `vY` — every entry cites the IMP and names the file touched. It is the map of the
  change. Read it at the tag — `git -C "${FW:?}" show vY:CHANGELOG.md`, the sections
  above `vX`'s own. (The CHANGELOG is not copied into the project: it is read from the
  framework repo, never from its working tree.)
- **`git diff` as the EXACT TEXT**, scoped to the METHOD paths only and EXCLUDING the
  framework's memory:

  ```bash
  git -C "${FW:?}" diff vX vY -- .claude/docs .claude/commands .claude/settings.json \
    CLAUDE.md scripts Makefile commitlint.config.cjs .gitignore .gitattributes \
    .claude/memory/components/README.md .claude/memory/decisions/README.md \
    .claude/memory/plans/README.md .claude/memory/sessions/README.md
  ```

  The rest of `.claude/memory/` stays out on purpose: the framework's memory is ITS own,
  it must NEVER overwrite the project's. Only the memory templates are named — and the
  header of `LEARNINGS.md`, which this diff cannot isolate: `inventory` compares it.

**The *Upgrading* notes are a CHECKLIST, not an index.** From the same CHANGELOG, collect
the *Upgrading* note of EVERY entry between `vX` (excluded) and `vY`, oldest first, and
work through them in Steps 3-5: they carry the migrations the diff cannot show — an answer
that moves to another file, a title to rename, a recipe to replace rather than merge.
Notes on DIFFERENT topics ADD UP: each migration applies even when no later note mentions
it again (1.3.2's rename of the memory's section titles applies to an upgrade to any later
version). Only notes on the SAME topic supersede each other, and then the most recent one
wins: 1.3.0 wanted the guard in place before `settings.json`, 1.3.1 allows any order —
1.3.1 holds. A note scoped to its own starting point does not override an earlier one for
a jump that starts before it: 1.3.2's "no `make hooks-install` needed from 1.3.1" says
nothing to an upgrade from 1.2.0, whose hooks did change in 1.3.0.

**The inventory.** `FW="$FW" T="$T" bash "${T:?}/upgrade-check.sh" inventory vX vY`
prints, in one pass, what the two sources above leave to assemble by hand: every payload
file with its class, what the framework did between the tags (`=`, `M`, `A`, `D`), where
the project stands against them (`=vX`, `=vY`, `diverged`, `absent`) and, for a file
both sides changed, the measure of its 3-way (conflicts, and lines in conflict out of
the total); the flags of the edge cases (a customised METHOD file, a file deleted or
renamed, one changed in several releases, a mode); the slots added, removed or moved
between the tags — compared line by line, so a mention of the marker that a release drops
hides no slot it adds —, and the changes of the §2 checklist — derived from the tags, never
from a hand-written list; the memory's titles and field labels to rename; and the
*Upgrading* notes of the releases in between, oldest first. It is the input of Step 3.

### Step 3 — Reconcile by class

- **Line ends, first — a working tree with CRLF.** Where the framework's files carry CRLF
  in the working tree — `git ls-files --eol -- CLAUDE.md` reads them as w/crlf, as Git
  for Windows writes them by default (`core.autocrlf` `true`) — every 3-way below would
  conflict on every line. Before any other change of this step, bring `.gitattributes`
  over (copied, or integrated after the project's own lines, below), then rewrite the
  framework's paths, and only them, from the last commit:

  ```bash
  if [ "$(git check-attr eol -- CLAUDE.md)" != "CLAUDE.md: eol: lf" ]; then
    echo "refused: no .gitattributes holds the framework's files to LF yet; bring it over first" >&2
    false
  elif git ls-files -v -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore scripts | grep -q '^[[:lower:]S] '; then
    echo "refused: a framework file is marked assume-unchanged or skip-worktree; clear the mark first" >&2
    false
  elif ! git diff --quiet HEAD -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore scripts; then
    echo "refused: the framework's paths carry changes not yet committed; commit them first" >&2
    false
  else
    git rm --cached -r -q -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore scripts \
      && git checkout HEAD -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore scripts
  fi
  ```

  `git checkout HEAD` overwrites what those paths hold, so the step first refuses —
  rewriting nothing — when their files differ from the last commit, a change staged or
  not, and when a file carries a mark that hides its changes from `git diff`: with
  `assume-unchanged` the step erased an edit, with `skip-worktree` `git rm --cached` stopped
  halfway and left the rest of the framework staged as deleted (both measured). A change
  only staged, its file back to the commit's text, makes `git rm --cached` refuse by
  itself. Commit the change, or clear the mark (`git update-index --no-assume-unchanged`,
  `--no-skip-worktree`), and run the step again. Before `.gitattributes` is in place the
  step would write CRLF again and look done: it refuses. A plain `git checkout -- <paths>`
  is not enough: git takes the files for up to date and rewrites nothing.
- **The strategy, file by file, from the measure** (`inventory`, Step 2). Where a file's
  3-way leaves few lines in conflict, it stays surgical: take it. Where most of a file is
  in conflict — a translation release, a wide rewrite — rebuild it from `vY` and
  re-apply the project's customisations, listed from the diff against `vX`'s copy and
  sorted by what they are: prose is rewritten freely, VALUES (slot answers, names,
  identifiers) stay identical, strings a program reads stay byte for byte — each one an
  edit with the file tools on its own text (`CLAUDE.md`, rule 10). Where the line
  falls is a human call, informed by the table: the measure, not the file's name,
  decides.
- **METHOD** → after the pre-flight of edge case 7 — and edge case 8, if `vY` moved a
  slot out of the file — bring the `vY` version over, read from the tag, never from the
  framework's working tree:

  ```bash
  git -C "${FW:?}" show vY:<path> > "${T:?}/theirs" && cp "${T:?}/theirs" <path>
  ```

  `show` does not carry the file's mode: take it from
  `git -C "${FW:?}" ls-tree vY -- <path>` (`100755` = executable) and `chmod` a new
  file, or one whose mode `vY` changed, accordingly. On Windows, where the filesystem
  keeps no executable bit and `chmod` changes nothing, the mode lives in the index:
  `git add --chmod=+x -- <path>` stages the file with it (`git update-index --chmod=+x`
  for a file already staged).
- **PROJECT-MEMORY** → do not touch: only the declared commits of edge case 3 enter the
  closed list of Step 5, and `STATE.md`, `TREE.md` and `INDEX.md` never go through a
  3-way.
- **HYBRIDS** → 3-way merge with `base` = the template at the tag `vX`, `theirs` = the
  template at the tag `vY`, `mine` = the project's file (`git merge-file`/`diff3`).
  Extract base and theirs by tag into `T`, chained, so that a failed read stops the
  merge instead of feeding it an empty file:

  ```bash
  git -C "${FW:?}" show vX:<path> > "${T:?}/base" \
    && git -C "${FW:?}" show vY:<path> > "${T:?}/theirs" \
    && git merge-file <path> "${T:?}/base" "${T:?}/theirs"
  ```

  The last command is project-side: `git merge-file` rewrites `<path>` and exits with
  the number of conflicts. Never hand it a `<( … )`: it sizes its inputs with `stat`,
  which a pipe does not answer reliably — the input is read EMPTY or TRUNCATED, and the
  merge comes out wrong with no error of its own. The 3-way must achieve this: a marker
  ADDED by `vY` **re-materialises** in the file (a new `[TO BE DEFINED]` to fill in);
  one that was REMOVED **disappears**; one that was MOVED or co-edited surfaces as a
  **conflict** to resolve by hand, with the file tools. Always re-apply the project's
  `[TO BE DEFINED AT SETUP]` answers (branch names, `tree` patterns, formatter, the
  stack's allow-list, the answers in `docs/02`-`04`, the whole "Technical rules" section of
  `CLAUDE.md`) — and if `vY`
  MOVED a slot to another file, see edge case 8 before merging either file. `.gitignore`
  is INTEGRATED (additive union: make sure the lines of the `vY` base —
  `git -C "${FW:?}" show vY:<path>` — are present without removing the project's), and
  so is `.gitattributes`, with `vY`'s lines after the project's: for the same path, a
  later line wins. The
  `Makefile` is NOT: it goes through the 3-way like the other hybrids. A union keeps the
  old and the new recipe of the same target, and `make` then runs both, or warns
  "overriding commands" and runs only the last — measured on v1.3.2's `reset-task`.
  `LEARNINGS.md` is not a hybrid: its header is a memory template (below), its IMP
  entries are the project's memory, and its `## ` titles and field labels go through
  edge case 3 (b), with `STATE.md`'s titles.
- **MEMORY TEMPLATES** → the 3-way of the hybrids, with base `vX`: an uncustomised README
  comes out as `vY`'s, a customised one keeps the project's text and surfaces only the
  hunk that conflicts. For `LEARNINGS.md`, its HEADER only — never a whole-file merge: the
  framework's file is live, and its own entries would come in. Merge the region before
  the first `## `:

  ```bash
  git -C "${FW:?}" show vX:.claude/memory/LEARNINGS.md > "${T:?}/lrn.vx" \
    && git -C "${FW:?}" show vY:.claude/memory/LEARNINGS.md > "${T:?}/lrn.vy" \
    && awk '/^## /{exit} {print}' "${T:?}/lrn.vx" > "${T:?}/lrn.base" \
    && awk '/^## /{exit} {print}' "${T:?}/lrn.vy" > "${T:?}/lrn.theirs" \
    && awk '/^## /{exit} {print}' .claude/memory/LEARNINGS.md > "${T:?}/lrn.mine" \
    && git merge-file "${T:?}/lrn.mine" "${T:?}/lrn.base" "${T:?}/lrn.theirs"
  ```

  Resolve its conflicts in `"$T/lrn.mine"` — the frontmatter's `updated:` stays the
  project's own date — then put it back in front of the project's entries:

  ```bash
  cat "${T:?}/lrn.mine" > "${T:?}/lrn.new" \
    && awk '/^## /{b=1} b' .claude/memory/LEARNINGS.md >> "${T:?}/lrn.new" \
    && cp "${T:?}/lrn.new" .claude/memory/LEARNINGS.md
  ```

  Its format comment, further down in the body, is reconciled the same way, so a
  project's own rewording survives; a project grafted before v1.1.0 loses its second,
  obsolete comment block (the format of the Applied entries), which `vY` no longer has:

  ```bash
  lrn_comments() { awk '/^<!--/{c=1} c{print} /-->[[:space:]]*$/{c=0}' "$1"; }
  lrn_comments "${T:?}/lrn.vx" > "${T:?}/fmt.base" \
    && lrn_comments "${T:?}/lrn.vy" > "${T:?}/fmt.theirs" \
    && lrn_comments .claude/memory/LEARNINGS.md > "${T:?}/fmt.mine" \
    && git merge-file "${T:?}/fmt.mine" "${T:?}/fmt.base" "${T:?}/fmt.theirs"
  ```

  Resolve its conflicts in `"$T/fmt.mine"`, then put it in place of the file's comment
  blocks:

  ```bash
  awk -v merged="${T:?}/fmt.mine" '
    /^<!--/ { c = 1; if (!done) { while ((getline l < merged) > 0) print l; done = 1 } }
    !c { print }
    /-->[[:space:]]*$/ { c = 0 }' .claude/memory/LEARNINGS.md > "${T:?}/lrn.fmt" \
    && cp "${T:?}/lrn.fmt" .claude/memory/LEARNINGS.md
  ```

  `invariant` compares the result with `vY`'s format and shows a difference for a human.
  Commit the templates apart, declared: `docs(memory): bring the memory templates to vY`.
- **The guard and `settings.json`: no order to respect** (from v1.3.1; v1.3.0 required
  the guard first). The merged settings wire the guard and Claude Code reloads them at
  once; until `scripts/agent-git-guard.mjs` is in place, only DELEGATED agents are blocked
  (fail-closed) — the session running the upgrade keeps its Bash tool, and every call of
  its own shows an `agent-git-guard: cannot run` notice meanwhile: expected, it stops
  once the guard is in place.

> **Execution boundary (`docs/04`, section of the same name).** The agent PREPARES and
> commits LOCALLY on the upgrade branch; it does NOT merge, does NOT push, does NOT tag.
> Nor does it WRITE in the framework repo: no checkout, switch, stash, `worktree add` or
> commit there — it only reads it by tag (*Precondition*). Only the MAIN session
> writes: delegated agents — subagents, workflow agents — are read-only on git, which the
> guard enforces on the shell tools from v1.3.0 (`docs/04`, *Delegated agents and the
> shared working tree*). The READING can be spread across them (inventories, diffs by tag, a review);
> the branch, `git merge-file`, the commits and any throwaway clone for a dry run stay
> with the main session. Its edits — an answer, a value re-applied, a conflict's
> resolution, a renamed title — are made with the file tools (`CLAUDE.md`, rule 10); the
> copies from the tag, `git merge-file`, the line-end rewrite and the header's splice are
> the procedure's whole-file writes. An edit to `.claude/settings.json` or
> `scripts/agent-git-guard.mjs` through the file tools asks the human (the `ask` rules),
> auto mode included, unless a mod or a PermissionRequest hook answers in the user's place,
> in a session started at the project's root (`docs/04`); the shell commands of Step 3 do
> not. Where `vY` changes a
> RULE (rather than being a factual correction), Level 2 of `docs/06` kicks in: it is
> PROPOSED, not applied silently — *"Never rewrite your own rules on your own
> initiative"* (`CLAUDE.md`, rule 6).

### Step 4 — Re-sync the hooks and audit the markers

`make hooks-install` (idempotent; a hook that differs from the one it generates — another
release's, or one with the project's formatting block — is saved as a `.bak` first, over the
`.bak` an earlier run left: compare each `.bak`, then remove it, before the next upgrade).
It installs into the repository's COMMON git directory, which all its worktrees share:
run from the upgrade's own worktree, `vY`'s hooks reach the main worktree too, still on
`vX` until the merge — expected. (Until v1.3.2 the script aborted from a linked worktree
with `mkdir: … Not a directory`.) From v1.3.0 it also installs the `pre-push` push
boundary: if the project already has a `pre-push` of its own (git-lfs's, for one), the
script stops — rename it to `pre-push.local` in the same hooks directory (the path the
script prints; `$H` below) and re-run: the generated pre-push runs it after the boundary
check, if it is executable — one that is not is skipped without a word —, and a re-run
leaves it alone. Real verification:

- **Every hook the script generates is installed and carries the generator's marker.**
  The list is read from the script's own loop, so a hook added to it is checked too:

  ```bash
  H="$(git rev-parse --path-format=absolute --git-common-dir)/hooks"
  n=0; for h in $(sed -n 's/^for hook in \(.*\); do$/\1/p' scripts/hooks-install.sh); do
    n=$((n + 1))
    grep -qF 'Hook generated by scripts/hooks-install.sh' "$H/$h" 2>/dev/null \
      || echo "MISSING or foreign: $h"
  done; test "$n" -gt 0 || echo "STOP: no hook list found in scripts/hooks-install.sh"
  ```

  Nothing printed = all in place. It catches a hook that is MISSING or FOREIGN — the
  `pre-push` a `vX` before 1.3.0 never had, a hook still carrying the Italian marker of a
  `vX` before 1.1.0 — not one left over from an earlier run with the same marker: the
  re-run is what makes the hooks current. The proofs below exercise behaviour, not
  version: they pass with an older `pre-commit` and `commit-msg` still installed, and
  none of them reaches the `pre-push` — whose behaviour `make test-scripts` proves in a
  throwaway repository (a push from the session is refused by design: never attempt one).
- **No hook manager in the way**: the three commands of the graft's check (*Inherited git
  hygiene*, *Hook managers*) print nothing. `make hooks-install` stops in front of a manager
  that has run — `core.hooksPath` set, or a pre-commit, commit-msg or pre-push without the
  generator's marker —, not in front of one configured since the graft and not yet run.
- A fake secret blocked by gitleaks, a non-conventional message rejected by commitlint.
- `make test-scripts` green. It also checks `.claude/settings.json` against the guard:
  the wiring of `scripts/agent-git-guard.mjs` on Bash, PowerShell and Monitor, the
  PowerShell tool kept off (`CLAUDE_CODE_USE_POWERSHELL_TOOL=0`) and the two `ask` rules on
  the boundary's own files. A failure there means the merged settings lost them — repair
  the settings, never the test: the self-test (METHOD) and `settings.json` (HYBRID) arrive
  in the same upgrade and check each other.

The slots `vY` added, removed or MOVED are in `inventory`'s *Markers* section, and a new
or re-worded item of the §2 checklist in the next one: both derived from the tags. Then
step 2's grep, run from the project root, lists every marker still in the project, to be
filled in with the project's answers, each an edit with the file tools (reuse the dialogue
of step 2 of this guide); a
slot that moved to another file is edge case 8. The dual-form grep
matters here: a project grafted before the English marker existed still carries the
Italian one.

### Step 5 — Verify before finalising

- **The memory's closed list — here, before the checkpoint.**
  `FW="$FW" T="$T" bash "${T:?}/upgrade-check.sh" invariant vX vY <restore point>` (the
  pre-upgrade commit of Step 1). Run it before Step 6: the checkpoint's retro may add IMP
  entries. It fails on any touch outside the list — an edited or hidden IMP entry, a note
  changed beyond its pointers, a file added outside the upgrade's own note, plan and
  decision records, a slot the project had answered opened again, a title or label left
  in the old form — and shows for a human a template that differs from `vY`'s. A FAIL is
  a bug in the upgrade: stop and investigate.
- `FW="$FW" T="$T" bash "${T:?}/upgrade-check.sh" post vX vY`: the METHOD files and their
  modes at `vY`, every file present, no orphan, no marker broken by a wrap, each slot
  `vY` added shown with the value under it, every hook installed, titles and labels in
  `vY`'s form.
- `git diff --stat` and a per-file diff.
- The project's `[TO BE DEFINED]` customisations survived in the reconciled files.
- `/fw:lint-memory` on the preserved memory against the new docs (pointers to
  renamed/moved docs, STATE vs git, `LEARNINGS`↔`STATE` coherence, orphan pages).
- The project's build/tests green (even if the upgrade is process-only, confirm the
  project still builds and commits).
- **No framework file in a deploy artifact.** If the project builds one from the repository —
  a container image from its root, for one —, check that no framework path reaches it, the
  paths `vY` adds above all (the files `inventory` marks `A`): an explicit exclusion list does
  not know them yet (*Hardening*, *Keep the framework out of what you deploy*).

### Step 6 — Closing and hand-off

**Update the provenance pin**: rewrite in `.claude/framework-version` the `version` and
`commit` fields with the `vY` you have just brought over — `version: vY` with its `v`,
`commit` resolved on the
framework side, `git -C "${FW:?}" rev-parse "vY^{commit}"` (a bare `rev-parse` in the
project returns the project's own `vY`, if it has one; on an annotated tag, without
`^{commit}` it returns the tag object's id); `grafted` is not touched (it is the date
of the original graft). If the project does NOT have the pin (a pre-pin
graft), CREATE it now — that is the retrofit: from this upgrade on the baseline is
certain; unknown `grafted` → `n/a (retrofit YYYY-MM-DD)`. The pin lives outside
`.claude/memory/`: the closed list of Step 5 needs no entry for it.

`/fw:checkpoint` (the upgrade's session note — `vX→vY`, what was reconciled, what the user
decided, and its security-gate line with the reason, since an upgrade rewrites the security
baseline: the hooks, the permissions, a destructive guard; `STATE.md` with the updated
framework version; `TREE.md` if the structure changed). Then `/fw:integrate`: a process-only upgrade of the project does NOT bring
product features/fixes → bump **"no tag"** (`chore`, internal work, not a release):
declare it and omit the tag. The merge of the upgrade branch and the push are HUMAN
actions. If something does not add up at review time, the branch is thrown away: the
memory is safe in the pre-upgrade commit.

### Edge cases (to be handled explicitly)

The "bring the `vY` version over" reconciliation of Step 3 is an OVERWRITE, not a
`sync`, and the 3-way covers co-edits but not everything. These eight cases must be
handled on purpose, or the upgrade leaves the project in an incoherent state:

1. **A file DELETED in `vY` (orphan).** If `vY` removes a METHOD file (a merged doc, a
   deprecated command), overwriting does not delete it: it stays orphaned. The
   `git -C "${FW:?}" diff vX vY` shows removals as delete hunks — **apply those too**
   (`git rm`, project side), and close with an anti-orphan check: the set of the
   project's METHOD files must match `vY`'s — read at the tag, never from the
   framework's working tree.

2. **A file RENAMED/RENUMBERED in `vY` (duplicate).** If `vY` renames or renumbers a
   doc/command (e.g. a renumbering of `docs/`), the overwrite creates the new name and
   **leaves the old one** → two files and an ambiguous `CLAUDE.md`/`TREE.md` index. Use
   `git -C "${FW:?}" diff -M vX vY` as an index of the renames to apply the move
   (remove the old one, bring the new one), not a blind add+delete. A file the project
   customised — a HYBRID, or a METHOD file edited inline (edge case 7) — is not brought
   over under its new name: it is MERGED into it, `base` the old path at `vX`, `theirs`
   the new path at `vY`, `mine` the project's old file, from the project root:

   ```bash
   git -C "${FW:?}" show vX:<old path> > "${T:?}/base" \
     && git -C "${FW:?}" show vY:<new path> > "${T:?}/theirs" \
     && cp <old path> "${T:?}/mine" \
     && git merge-file "${T:?}/mine" "${T:?}/base" "${T:?}/theirs"
   ```

   Resolve its conflicts in `"$T/mine"`, then put it at the new path and remove the old
   one, in the same commit:

   ```bash
   mkdir -p "$(dirname <new path>)" && cp "${T:?}/mine" <new path> && git rm -q <old path>
   ```

   **The commands' namespace, from v3.0.0.** Every command of the method moved from
   `.claude/commands/` to `.claude/commands/fw/`, and runs as `/fw:<name>`. The eight files
   are renames: the three customised at setup (`fw/checkpoint.md`, `fw/integrate.md`,
   `fw/new-component.md`) and any other the project edited are merged as above, the rest
   brought over from the tag; then the project's own references to the old names are
   updated — its answers in `CLAUDE.md`, its own docs and commands —, while its session
   notes are history and stay as they are. Until an old file is removed, Claude Code keeps
   running it under its bare name, and two of them hide Claude Code's own commands of the
   same name: its security review, and the checkpoint alias of its rewind. `inventory`
   names each rename with the measure of its merge, and `post` fails while an old file
   remains.

3. **Memory lines the method reads by name — the declared touches of the closed list.**
   Two kinds of line in the project's memory are read by the method itself, and a `vY`
   that changes them leaves them stale:
   - **(a) Pointers towards renamed docs.** If `vY` renames/renumbers a doc, the
     `[[wikilink]]`s and the pointers (`docs/04:142`, …) in `STATE.md` and in the
     sessions **dangle**, and `/fw:lint-memory` will flag them as broken.
   - **(b) Section titles and field labels looked up by name.** The `## ` titles of
     `STATE.md` and `LEARNINGS.md`, and the field labels of the IMP entries
     (`- Origin:`, `- Observed problem:`, …), are FORMAT lines that the method reads by
     name (`/fw:checkpoint`, `/fw:lint-memory`, `/fw:retro`, `/fw:harvest-framework`, `docs/03`,
     `docs/06`). Format is method (`CLAUDE.md`, rule 9): the project's titles and labels
     take `vY`'s form — the rename is mandatory, and a map from old to new is not an
     alternative. Do not wait for a `vY` that renames them: COMPARE at every upgrade,
     since a project can carry the format of any earlier release (v1.1.0 translated it,
     and a project that kept the old one has been read wrongly since). `inventory` does
     it; by hand, from the project root:

     ```bash
     : "${FW:?}" && for f in STATE LEARNINGS; do
       git -C "${FW:?}" show "vY:.claude/memory/$f.md" | grep '^## ' \
         | grep -vxF -f <(grep '^## ' ".claude/memory/$f.md") \
         | sed "s|^|$f.md lacks: |"
     done
     ```

     Each printed line is a `vY` title the project lacks: find its old form — the table
     below, or a project's own shortened form — and rename that line. Nothing printed =
     nothing to rename. For the labels, when `vY`'s format comment uses the new ones,
     this lists the lines still in the old form (ignore the ones inside the format
     comment, which Step 3 reconciles):

     ```bash
     grep -nE '^- (Data|Origine|Problema osservato|Proposta|Beneficio atteso / rischio|Trigger di ripresa|Destinazione):|\| Origine:' .claude/memory/LEARNINGS.md
     ```

     Rename the label, never the text after it: one edit per line, anchored at its start,
     with the file tools — a pattern replaced across the file would rewrite an entry's text
     too, which `invariant` fails. ONLY the title and label lines: the content is never
     touched and keeps its language. If the project's own code or tests cite the old
     titles (grep for them), update them in the same commit as the rename — the declared
     `docs(memory)` commit below — so that no commit leaves the project's tests red: that
     side of the migration is the project's.

     | File | Title until 1.0.0 (and short forms seen) | Title since 1.1.0 |
     | --- | --- | --- |
     | `STATE.md` | `## Stato avanzamento` | `## Progress` |
     | `STATE.md` | `## Cosa esiste adesso` | `## What exists now` |
     | `STATE.md` | `## Decisioni prese (non ovvie dal codice)` | `## Decisions made (not obvious from the code)` |
     | `STATE.md` | `## Debito documentazione` | `## Documentation debt` |
     | `STATE.md` | `## Attenzione / problemi aperti` | `## Caution & open issues` |
     | `STATE.md` | `## Branch attivi` | `## Active branches` |
     | `LEARNINGS.md` | `## Proposte APERTE (in attesa di decisione utente)` | `## OPEN proposals (awaiting the user's decision)` |
     | `LEARNINGS.md` | `## Applicate` | `## Applied` |
     | `LEARNINGS.md` | `## Rimandate (non respinte — si riprendono al momento giusto)`, or `## Rimandate` | `## Deferred (not rejected — resumed at the right time)` |
     | `LEARNINGS.md` | `## Rifiutate (con motivo — per non riproporle)`, or `## Rifiutate` | `## Rejected (with the reason — so they are not re-proposed)` |

     | Field label until 1.0.0 | Since 1.1.0 |
     | --- | --- |
     | `- Data: … \| Origine: …` | `- Date: … \| Origin: …` |
     | `- Origine:` (alone) | `- Origin:` |
     | `- Problema osservato:` | `- Observed problem:` |
     | `- Proposta:` | `- Proposal:` |
     | `- Beneficio atteso / rischio:` | `- Expected benefit / risk:` |
     | `- Trigger di ripresa:` | `- Resumption trigger:` |
     | `- Destinazione:` | `- Destination:` |

   These repairs are EXPLICIT and DECLARED touches of the closed list, in a **separate
   commit** per kind (`docs(memory): update the pointers to the docs renamed by vY`;
   `docs(memory): rename the memory's titles and field labels to vY's form`), distinct
   from the upgrade's other commits. That way the invariant stays useful — it catches
   ACCIDENTAL edits to the memory — and the necessary repair does not slip through
   unnoticed. For the project's own memory they are the only touches during an upgrade,
   and only where they are needed: a doc `vY` renamed, a title or a label the comparison
   of (b) finds. (The method's own files under `memory/` — the guide READMEs, the header
   of `LEARNINGS.md` — are the memory templates of Step 3.) (Kind (b) was added in
   v1.3.2, for the titles alone; from v1.3.3 it starts from the comparison of the two
   sets, not from a rename in `vY`; from v1.4.0 it covers the field labels too.)

4. **Installed hooks (`.git/hooks/*`) live outside the git graph.** The
   `make hooks-install` of Step 4 materialises the hooks in the repository's common git
   directory — `.git/hooks/`, shared by every worktree — which is neither tracked nor on
   the branch. Two consequences: (a) if you forget the re-run, the installed hooks stay
   old while `hooks-install.sh` is updated — a silent incoherence: the re-run is
   MANDATORY (Step 4's check catches a hook that is missing or foreign, not a stale one);
   (b) **throwing away the branch does
   NOT uninstall** the hooks already materialised, and the safety commit never captured
   them. Re-running `vX`'s script does not bring them back either: it leaves in place a
   `pre-push` that a `vX` before v1.3.0 never had; a `vX` from v0.3.0 to v1.0.0 refuses
   the hooks that carry the English marker; `FORCE_OVERWRITE=1` replaces the pre-upgrade
   `.bak` with the new hook; and a `pre-push` renamed to `pre-push.local` at Step 4 stays
   renamed. The way back is Step 1's photograph. Once the user has decided to abort the
   upgrade after Step 4 — never before, and never printed with another block —, the session
   runs or gives this alone: it puts back the hooks photographed at Step 1.

   ```bash
   H="$(git rev-parse --path-format=absolute --git-common-dir)/hooks"
   test -d "${T:?}/hooks-before" && test ! -e "${T:?}/hooks-aborted" \
     && mv "$H" "${T:?}/hooks-aborted" \
     && cp -pPR "${T:?}/hooks-before" "$H" \
     && diff -r --no-dereference "${T:?}/hooks-before" "$H" && echo "hooks restored"
   ```

   It moves the installed hooks aside into `T` (`hooks-aborted`, kept for inspection) and
   copies the photograph back byte for byte — subdirectories, symlinks and a renamed
   `pre-push` included: `diff` prints nothing and the last line says "hooks restored".
   Without a photograph, work hook by hook: where Step 4 printed a WARNING for a hook,
   move that hook's `.bak` back over it; a hook that did not exist before Step 4 — the
   `pre-push` of a `vX` before 1.3.0 — is removed, and a `pre-push.local` renamed at
   Step 4 goes back to `pre-push`; every other hook stays, since Step 4 rewrote it with
   identical content. Never a `.bak` that THIS Step 4 did not announce: an older one
   would install hooks older than `vX`.

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
   CHANGELOG (read at the tag `vY`) as an index of the order and, on the most intricate
   files (typically `hooks-install.sh`), reconcile **one version at a time** instead of
   in one go — each intermediate step read by its tags
   (`git -C "${FW:?}" show <tag>:<path>` for its base and its theirs), never a checkout
   per version.

7. **Pre-flight: has the "pure METHOD" file been customised inline?** The METHOD class
   assumes a file stays as the framework wrote it. (The docs a project answers at setup,
   `docs/02`, `03` and `04`, are HYBRID from v3.0.0: their answers are merged, never
   overwritten.) But if the project freely edited an otherwise pure file
   (`commitlint.config.cjs`, a doc, a command) that file is in fact a HYBRID, and the
   overwrite destroys its customisation silently. Before overwriting a METHOD-class file, **inspect** that it really is
   untouched with respect to `vX` — `vX`'s copy read by tag, then compared:
   `git -C "${FW:?}" show vX:<path> > "${T:?}/base" && diff "${T:?}/base" <path>`. A
   bare `git diff vX -- <path>` in the project compares against the PROJECT's `vX`, the
   collision of the *Precondition*. If it diverges, treat it as a hybrid (3-way).

8. **A slot that MOVES to another file.** A `vY` can move a `[TO BE DEFINED AT SETUP]`
   slot from one file to another — v1.3.2 moved `reset-task.sh`'s protected branches
   into the `Makefile`. The 3-way cannot follow it: the new home merges CLEANLY with the
   framework's DEFAULT in the slot — Step 4's marker grep shows the marker, next to a
   value that looks answered — while the project's answer stays behind in the old file,
   as a conflict there, or lost if that file comes over as METHOD. Edge case 7 would
   keep the answer where it was: the opposite of the migration. So: (1) carry the
   project's answer to its new home FIRST, by hand, with the file tools; (2) only then bring the old file over
   as its class says; (3) check EVERY way of reaching the answer — the `make` target, its
   unattended form (`YES=1`), the script run directly, the docs that name the command —
   not only the one you edited. The *Upgrading* note of the release that moved the slot
   names both places (Step 2).

> **Outside the upgrade payload.** `LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md` are
> files of the FRAMEWORK REPO (not copied into the project, step 1): do not push them
> into the project and do not read them from the project — the CHANGELOG is read from
> the framework, by tag (Step 2). So are `tools/` — the upgrade runs its script from the
> framework, at `vY` (*Precondition*) — and `.github/`, the framework's own CI.
> `SECURITY.md`, `README.md` and this `SETUP.md` inside
> the project are optional/for reference — and be careful **not to overwrite the
> project's `README.md`** with the framework's. `settings.local.json`
> (unversioned) stays intact by construction.
