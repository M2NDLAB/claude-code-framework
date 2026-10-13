# Changelog

The relevant changes to this repo, in the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format; versions follow the
SemVer on annotated tags defined in `.claude/docs/04-git-workflow.md`
(*Versioning*). It is updated inside `/integrate`, before the merge+tag blocks.

## [Unreleased]

## [2.1.0] — 2026-10-13

### Added
- **The gate's lenses** (IMP-056, IMP-058, IMP-059): `docs/03` gets *The lenses of the gate*,
  which every review of the gate applies. *Claims, not only actions* — an assertion the
  product makes about a security property, a status, a summary, an "OK", "nothing changed",
  "no leaks found", is checked against what the code really does, and an assertion that
  something did not happen needs a datum that shows it; when a change widens a claim, the
  review covers the set the claim names, beyond the diff. *The real path* — a gate on an
  external tool covers what the tool does by itself on the way to its effect, what its
  configuration, the user's included, makes it do and what it updates, writes or fetches
  unasked; each such path is closed by the tool's off-switch, compensated, or declared as a
  known limit. A deliverable whose product asserts a security property is under the gate for
  that alone: `docs/00`'s cycle follows that trigger, and `/security-review` recalls the
  lenses in its check 11, their text living in `docs/03` only.
- **Two lines in `docs/02`** (IMP-073, IMP-071, IMP-087, IMP-084). The Definition of Done's
  point 10: a commit message, a changelog entry, the Verified part of an applied IMP is
  written after the last measurement it cites, and no wider than it. And in *Tests that
  demonstrate*: a test of what drives an external tool adds cases under the configurations
  the users have, each checking that its datum reaches the program under test before it
  counts.

### Fixed
- **`hooks-install.sh` claimed local changes it never measured.** Run again over a hook that
  differs from the one it generates — another release's, untouched, as well as a customised
  one —, it said the hook "contained local changes". It now says the hook differs from the
  one this version generates, and saves it as `.bak` as before. The user met it regenerating
  this repository's hooks after 2.0.0's integration.
- **The hooks' coverage was claimed wider than it is** — the HIGH of this release's review. A
  hook manager sets `core.hooksPath` again at its next run — husky does, from the `prepare`
  script its setup writes, at every `npm install`, unless `HUSKY=0` —, and from then on the
  pre-commit's scan and the push boundary do not run, without a word: with `core.hooksPath`
  set after the install, a commit holding a key goes through (measured). `docs/04`, `docs/03`
  and `scripts/README.md` now say so, `README.md` no longer says the pre-push leaves every
  push to the human, and the installer's refusal when `core.hooksPath` is set says that a hook
  manager sets it again, integrating the framework's commands into it being the durable
  choice.
- **The baseline claimed every commit.** `docs/03` and `CLAUDE.md`'s rule 1 now say what the
  pre-commit does — it refuses a `git commit` when gitleaks finds a secret in the staged
  changes —, and `docs/03` declares its limits, among them the commits git creates itself: a
  rebase's `--continue`, `git am`, a cherry-pick or a revert that applies cleanly do not run
  it (measured on git 2.54).
- `docs/04` and the generated pre-push's comment no longer call `CLAUDECODE` undocumented:
  Claude Code's environment-variable reference documents it.

**Upgrading from 2.0.0** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- METHOD files — bring them over from the tag: `.claude/docs/00-overview.md`,
  `.claude/docs/02-code-quality.md`, `.claude/docs/03-security-gate.md`,
  `.claude/docs/04-git-workflow.md`, `.claude/commands/security-review.md`,
  `scripts/README.md`, `scripts/test-hooks-install.sh`.
- HYBRID files (3-way): `scripts/hooks-install.sh` (the re-run's message, the refusal when
  `core.hooksPath` is set, the pre-push's comment) and `CLAUDE.md` (rule 1's sentence on the
  hook, three lines). `scripts/hooks-install.sh` rehearsed on a project with every setup
  answer in place, the pre-commit's formatting slot among them: the merge clean, with LF and
  with CRLF line ends.
- **`make hooks-install`**: the generated pre-push's comment changes, so the re-run saves the
  old hook as `pre-push.bak`, saying it differs from the hook this version generates: unless
  the project edited it, it is 2.0.0's own, byte for byte (the rehearsal compared them) —
  compare, then remove the `.bak`. The pre-commit and the commit-msg hooks do not change.
- The memory templates and the `LEARNINGS.md` header do not change; nothing migrates.

## [2.0.0] — 2026-10-13

**Breaking: gitleaks 8.18.2 or later.** `make hooks-install`, through the prerequisite check
it now runs first, refuses a gitleaks below 8.18.2, or one whose version it cannot read —
which 1.5.0 accepted. Below 8.18.2 the pre-commit's scan can let a secret through in silence
(*Changed*, below). Debian 13's and Ubuntu 24.04's packages are 8.16.0: install a release
(https://github.com/gitleaks/gitleaks#installing) before upgrading.

### Added
- **A prerequisite check, `scripts/check-prerequisites.sh`** (METHOD, IMP-070 point 7),
  runnable without make. It RUNS each tool — git, bash and the POSIX userland, GNU make,
  gitleaks, Node.js and npx — rather than finding it, compares its version with the
  minimum, names the platform and whether the framework's CI verifies it, and warns when
  `core.autocrlf` is true and nothing holds the framework's files to LF. A tool missing or
  not starting fails it, with the tool's installation page, and so does gitleaks below its
  security minimum or with a version the check cannot read; any other version below its
  minimum, or unread, is a warning. It installs nothing. Its self-test,
  `scripts/test-check-prerequisites.sh` (METHOD), runs it against stub tools, gitleaks'
  three command lines among them, in `make test-scripts`.
- **The generated hooks run with the real tools in the CI** — the framework repository's
  own `tools/test-real-hooks.sh`: the pre-commit hook refuses a staged secret, also with a
  colour the user's git configuration forces, behind a textconv that masks it, and in a key
  file marked binary, and lets a clean change through; the commit-msg hook accepts a
  conforming message and refuses one without a type. The CI installs gitleaks 8.30.1, its
  archive checked against a SHA-256
  fixed in the workflow before it runs, and runs the prerequisite check against each
  image's real tools. npx fetches commitlint from the npm registry there as in a project,
  unhashed.

### Changed
- **gitleaks' minimum is 8.18.2, a security minimum** (IMP-077) — the breaking change
  above. Read at gitleaks' source: before 8.18.2 the staged diff runs without
  `--no-ext-diff`, so a configured external diff replaces what gitleaks reads; from 8.4.0
  to 8.18.1 a scan error also ends in "no leaks found" and exit 0; 8.0.0 to 8.1.3 write a
  `.gitleaks.toml` into the project, which later releases load instead of their own rules.
  The hook keeps `gitleaks protect --staged`, hidden from `--help` since 8.19.0; its
  replacement, `gitleaks git --pre-commit --staged`, scans the staged changes only from
  8.20.0, and the switch waits for gitleaks to announce the removal of `protect`.
- **commitlint is pinned** (IMP-076): 21.2.3 for both its packages, an exact version defined
  in one place — the head of `check-prerequisites.sh` —, which `hooks-install.sh` writes
  into the commit-msg hook and refuses unless it is x.y.z. The hook ran npx's latest, so a
  new major could raise the Node.js minimum, or change behaviour, under every project at
  once. The two packages' own dependencies still follow the ranges they declare. Node.js
  22.12 stays the minimum: the `engines` of 21.2.3.
- **`hooks-install.sh` runs the prerequisite check first**, for what the hooks need — no
  make: a tool missing or not starting, or a gitleaks below its security minimum, stops it
  before any hook is written. It looked only for gitleaks and npx on the PATH.

### Fixed
- **The pre-commit hook let a staged secret through when the user's git configuration
  forced a colour** — `color.ui` or `color.diff` set to "always" — **or a textconv driver
  converted the staged text**: gitleaks scans what its own `git diff` prints, found
  nothing to read, or read the conversion, and printed "no leaks found". In every earlier
  release; measured through real commits. The hook now runs gitleaks with git's documented
  environment configuration, after the caller's own: the colour off, each configured
  textconv read as `cat`. Only an explicit `git -c` naming one of these settings still
  wins. The one-off history scan of `SETUP.md`'s step 3, which scanned 0 commits under a
  forced colour, gives the same prefix, and the pairs for a textconv.
- **The pre-commit hook let a secret through in a file git shows as binary although it
  holds text** — the attribute `binary` or `-diff`, a diff driver's `binary = true`: with
  `*.key binary` in `.gitattributes`, a guard against line-end conversion, a staged private
  key was committed with "no leaks found". In every earlier release; measured. The hook now
  copies each such file from the index into a directory under `TMPDIR` that only the user
  can read, scans it with `gitleaks detect --no-git` — the project's `.gitleaks.toml` and
  `.gitleaksignore` passed on —, and removes it however the hook ends, Ctrl-C included. A
  file binary by its content stays unscanned, as gitleaks reads text. Measured on an arm64
  Mac: 50 MB of such text adds about 12 s, a tenth of the scan of the same text staged
  plain. `SETUP.md` §3 says what the scan reads and its known limits.

**Upgrading from 1.5.0** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- **gitleaks 8.18.2 or later, first — the breaking change.** Before Step 1, run `vY`'s
  prerequisite check from `T`, as the *Precondition* says. A FAIL — gitleaks below 8.18.2,
  or one whose version cannot be read, among them — is a tool to install or repair before
  Step 4, whose `make hooks-install` runs the same check and stops on it.
- **If your git configuration forced a colour** (`color.ui` or `color.diff` "always", at
  any level), every earlier pre-commit scanned nothing, and so did a history scan: scan the
  history with the command of `SETUP.md`'s step 3. **If the project marks text files
  binary** (`binary`, `-diff`), the earlier pre-commit never read them, nor does the history
  scan: scan their current content as files, as step 3 says.
- METHOD files — bring them over from the tag: `scripts/README.md`,
  `scripts/test-hooks-install.sh`; and two new ones, executable:
  `scripts/check-prerequisites.sh`, `scripts/test-check-prerequisites.sh`.
- HYBRID files (3-way): `scripts/hooks-install.sh` (the check first, commitlint's pin, the
  git configuration the pre-commit gives gitleaks, the scan apart of the text git shows as
  binary), `Makefile` (the new self-test in `test-scripts`), `CLAUDE.md` (the
  `test-scripts` line of *Quick commands*). Rehearsed on a project with every setup answer
  in place, the pre-commit's formatting slot among them: the three merges clean, with LF
  and with CRLF line ends.
- **`make hooks-install` is needed** — 1.5.0's note said the hooks did not change: the
  pre-commit and the commit-msg hooks change. The re-run says each "contained local
  changes" and saves it as `.bak`: unless the project edited them, they are 1.5.0's own,
  byte for byte (the rehearsal compared them) — compare, then remove the `.bak` files. The
  pre-push hook does not change.
- The memory templates and the `LEARNINGS.md` header do not change; nothing migrates.

## [1.5.0] — 2026-10-11

### Added
- **macOS, Linux and Windows, verified by a CI** (IMP-070, points 1-6). The framework
  repository's own workflow, `.github/workflows/test.yml`, runs `make test-scripts` and
  the upgrade check's self-test on ubuntu-24.04, macos-26 and windows-2025 at every push:
  a read-only token, `actions/checkout` pinned by its full commit SHA, named images, GNU
  make on Windows at a fixed version. It stays in this repository: setup never copies
  `.github/`. `SETUP.md` §0 gains the matrix of what it verifies — macOS on arm64, Linux
  and Windows on x64 — and names what it does not.
- **`.gitattributes` in the payload** (HYBRID): LF line ends for the framework's own paths
  on every platform, whatever `core.autocrlf` says — bash cannot run a script with CRLF
  line ends, and Git for Windows checks text out with CRLF by default. The project's other
  files keep the project's own rules.
- **The agent git guard reads the PowerShell tool too**, and the tool is kept off.
  Claude Code's documentation says a PreToolUse hook can match it, and that on Windows
  with Git Bash a Bash deny rule turns it off silently: `.claude/settings.json` now turns
  it off on purpose (`CLAUDE_CODE_USE_POWERSHELL_TOOL=0`), since the framework's scripts
  and hooks are bash; the guard's matcher becomes `Bash|PowerShell|Monitor`, and the guard
  reads PowerShell's ordinary forms — the backtick escape, script blocks, assignments,
  here-strings, block comments — and every spelling of git (`git.exe`, `Git`, a Windows
  path, quoted or not), through Bash too.

### Fixed
- **`make hooks-install` on Windows.** `hooks-install.sh` refused every repository there:
  git prints its paths as `C:/…`, Git Bash names the same directory `/c/…`, and the script
  compared them as strings. It accepts both forms now and compares by identity.
- **The upgrade check on Windows.** For the same reason it refused to run from the
  project's root; it now compares the project, the framework's clone and `T` by identity.
  It reads a file's mode from the index where git does not trust the filesystem
  (`core.fileMode` false), and its walk up a path ends on a network path too.
- **The upgrade check on a CRLF checkout.** It read the project's files raw: on a Windows
  checkout every 3-way of `inventory` measured 100% of its lines in conflict, and
  `invariant` and `post` reported eleven false FAILs each. It now reads the project's text
  with its line ends converted, at the nine places where a `\r` changed a verdict or a
  printed line; a case of its self-test demands the same output from an LF and a CRLF
  copy of a project.
- **The upgrade's precondition on Windows** (`SETUP.md`): it compared the same two forms
  of the project's root as strings and printed STOP every time; it compares them by
  identity now.

### Changed
- **The prerequisites name the tools, not a package manager** (`SETUP.md` §0): git 2.31,
  bash 3.2 with a POSIX userland (on Windows, Git for Windows), GNU make (on Windows,
  installed apart), gitleaks, Node.js 22.12 — the minimum commitlint's current release
  imposes, for npx and the guard alike. `hooks-install.sh` points to gitleaks' own
  installation page. On Windows, step 1 adds the scripts with their executable mode.

**Upgrading from 1.4.1** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- **Line ends, first — a Windows checkout.** If `git ls-files --eol -- CLAUDE.md` reads
  the file as w/crlf, the framework's files are CRLF in the working tree: run the first
  point of Step 3, *Line ends, first* — bring `.gitattributes` over, then the step rewrites
  the framework's paths, and only them, with LF from the last commit. It refuses,
  rewriting nothing, while those files differ from that commit, while one carries an
  `assume-unchanged` or `skip-worktree` mark, and before `.gitattributes` holds them to LF.
  Measured on a simulated Windows checkout (a clone with `core.autocrlf=true`): 37 of 37
  framework files with LF afterwards, the project's own files byte for byte as they were,
  the 3-way merges then clean; each refusal keeps the change and the index.
- METHOD files — bring them over from the tag: `.claude/docs/04-git-workflow.md`,
  `scripts/README.md`, `scripts/agent-git-guard.mjs`, `scripts/test-agent-git-guard.sh`,
  `scripts/test-hooks-install.sh`.
- HYBRID files (3-way): `.claude/settings.json` (the `env` key
  `CLAUDE_CODE_USE_POWERSHELL_TOOL` and the matcher), `scripts/hooks-install.sh` (Windows
  paths; the gitleaks message). `.gitattributes` is new: copy it, or — where the project
  has one, which `inventory` flags — add `vY`'s lines after the project's own: for the same
  path, a later line wins.
- The memory templates and the `LEARNINGS.md` header do not change; nothing migrates.
- The generated hooks do not change: on macOS and Linux `make hooks-install` is not
  needed from 1.4.1. On Windows it is — 1.4.1's `hooks-install.sh` refused every
  repository there, so the hooks were never installed.
- On Windows, a project grafted there recorded the seven scripts as `100644`: the check
  now reads the index, and `post` reports each mode. Record them with
  `git update-index --chmod=+x -- scripts/*.sh scripts/*.mjs`, and commit.
- Check the machine against `SETUP.md` §0: bash with its userland, GNU make, Node.js 22.12.

## [1.4.1] — 2026-10-11

### Fixed
- **The payload carries nothing that only holds in the framework's repository**
  (IMP-049). A project received text it could not use and pruned it by hand at every
  upgrade:
  - the blocks that hold only here — the hybrid-regime box of `docs/01` and its
    resumption patch, the plan block of `sessions/README.md`, the closing box of
    `docs/06`, the moot clause of `/harvest-framework`, two sentences of the
    `LEARNINGS.md` header — moved to `CONTRIBUTING.md`; `docs/01` keeps one conditional
    line at its top, so an agent in the framework's repository still plans, records its
    decisions and resumes from the session note;
  - the numbers of the framework's IMP backlog — 23 at v1.4.0, in the docs, a command, a
    guide README and the scripts' headers and self-test labels: orphans in a project, or
    collisions with its own numbering — are gone; the why stays in prose, and the
    self-tests print descriptive labels;
  - of the 14 pointers to files a project does not have, 2 left with the moved blocks and
    12 are rephrased, or labelled as the framework's (`SETUP.md`, `CONTRIBUTING.md`, the
    README's *Philosophy*, `LICENSE`) — the SessionStart message of `settings.json` among
    them;
  - `docs/04`'s criterion for a method/tooling project no longer reads as the framework's
    own ("as this framework is"); that one stays in `CONTRIBUTING.md`.
- **Lists that claimed completeness and were not complete** (IMP-068):
  - the production-artefact slot of `/new-component` was written `[TO BE DEFINED]`,
    invisible to the setup's and the upgrade's greps since v0.1.0;
  - `checkpoint.md`'s two placeholders, in §2 of `SETUP.md` with no marker, now carry
    one, in a paragraph setup deletes once they are replaced;
  - the brownfield `Makefile` row of `SETUP.md` names `test-scripts`; step 1 names
    `tools/` among what is not copied; "Its subcommands:" names `classes`;
  - the backlog's sections include Rejected (`/harvest-framework`, the `INDEX.md` and
    `STATE.md` templates);
  - the hooks self-test reads the generator's hook loop instead of a copy of it; the
    snapshot self-test counts the traces it checks;
  - two counts that no program can keep true stop counting: the provenance pin is no
    longer "the FOURTH species", nor the upgrades "three".
- **Italian residue** in the payload: the example names of the `plans/` and `sessions/`
  guides, the hooks self-test's fixture path, the calque `<id-prompt>` (`<prompt-id>`
  now, as `docs/01` has it), guillemets as quotation marks in `docs/04` and `SETUP.md`.
- `/harvest-framework` counts only the marker lines: its grep is anchored at the start of
  the line, and a hit counts only inside an entry — the format comment of `LEARNINGS.md`
  shows the marker without being one.
- `docs/06` and `SETUP.md` (§5) placed the IMP format "in the header" of `LEARNINGS.md`:
  it is its format comment, in the body.

### Added
- **`tools/docs-check.mjs`, the framework repository's mechanical documentation check**,
  and its self-test `tools/test-docs-check.sh`. `make test-scripts` runs both, behind a
  presence guard: in a project, where `tools/` is never copied, the line does nothing. It
  reads the working tree, the tags and the commits, writes nothing, and fails on:
  - the payload's purity — a framework IMP number; a pointer to a file a project does not
    have, by name or section, link, cited path, `@`-import or wikilink, each mention on
    its own, neither labelled as the framework's nor conditional; a slot in a short form
    or broken by a wrap;
  - the inventories — commands, process targets, self-tests, the script and tool tables,
    the docs index, the README tree — against the files;
  - tags against the CHANGELOG, both ways, but the one release being prepared; the
    entries' form, order and dates, and the chain of their *Upgrading* notes;
  - an old version presented as the current one — next to a currency word or after a
    marker, in a heading, a `version:` line, a checkout or a static badge;
  - internal links — Markdown links and anchors, wikilinks, `@`-imports, cited paths, and
    section titles cited with their file (a phrase in quotes right after a file name is
    read as one), in the docs and in the scripts' comments and messages;
  - the lists that declare themselves complete — §2 against the payload's markers, with a
    tripwire on a slot added since the latest tag; the class table against every tag, and
    the classes of `SETUP.md`; the copy lists and what is not copied, the counts in prose,
    the subcommands, the commit types, the memory's titles and labels;
  - Italian residue in the artifacts, the file names and the commits since v1.1.0.
  What its rules cannot tell apart is declared in an allow-list, each entry with its
  reason; an entry that matches nothing fails, and none hides another finding of its
  line. Node.js, not bash: no GNU/BSD difference, CRLF line ends read alike; an error of
  the check itself exits 2, never a verdict. Mutation-tested: each place where the check
  reports, and each form of a pointer, a version, a section title or an Italian word it
  names, disabled in turn, makes the self-test fail.
- IMP-049 and IMP-068 applied.

### Changed
- The format comment of `LEARNINGS.md`, and step 2 of `docs/06` (*Applying approved
  proposals*), say what becomes of an applied entry: moved under Applied, rewritten in
  its final form, citing the session note of its evidence — what the framework's own
  applied entries did, made explicit. Older entries are not backfilled.

**Upgrading from 1.4.0** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- METHOD files — bring them over from the tag, after the pre-flight of edge case 7:
  `.claude/docs/01-task-planning.md`, `.claude/docs/03-security-gate.md`,
  `.claude/docs/04-git-workflow.md`, `.claude/docs/06-self-improvement.md`,
  `.claude/commands/harvest-framework.md`, `.claude/commands/lint-memory.md`,
  `scripts/repo-snapshot.sh` and the three `scripts/test-*.sh`. Where edge case 7 flags
  one as customised because the project pruned the framework-only text or the IMP
  numbers by hand, and its diff against `vX` shows only that pruning, take `vY`'s copy;
  any other customisation makes it a hybrid (3-way).
- HYBRID files (3-way): `.claude/settings.json` (the SessionStart message), `Makefile` (one
  guarded line in `test-scripts`), `scripts/hooks-install.sh` (a comment),
  `.claude/commands/integrate.md` (a sentence of its header). `CLAUDE.md` changes only
  the licence example of the technical rules, which every project replaced at setup:
  keep the project's section. `.claude/commands/checkpoint.md` gains a paragraph whose
  marker names its two placeholders: where the project already replaced them, delete the
  paragraph — its answers stand. `.claude/commands/new-component.md`: the
  production-artefact slot now carries the full marker; where the project answered it,
  keep the answer.
- MEMORY TEMPLATES (3-way): `sessions/README.md` loses its plan block and the IMP number,
  and its example names change; `plans/README.md` changes its example name and
  `<id-prompt>` to `<prompt-id>`; the header of `LEARNINGS.md` loses two sentences, its
  format comment gains the lines on applied entries. A project that pruned the same text
  merges clean; one that customised a moved block meets a conflict there — the text it
  kept holds only in the framework's repository.
- `STATE.md`, `TREE.md` and `INDEX.md` changed in the framework's templates only (wording,
  the Rejected section, `<prompt-id>`): the project's own files are not reconciled, and
  nothing migrates.
- No hook changes (`hooks-install.sh` changed a comment): `make hooks-install` is not
  needed from 1.4.0; `make test-scripts` as usual.

## [1.4.0] — 2026-10-10

### Added
- **`tools/upgrade-check.sh`, the read-only checks of an upgrade** (IMP-037, option (b)).
  It lives in the framework repository, outside the payload, and an upgrade runs it at
  the tag it upgrades to, from the project's root (`SETUP.md`, *Precondition*):
  - `preflight` — the Precondition and the provenance pin;
  - `inventory` — every payload file's class, what the framework did between the tags,
    where the project stands and the measured conflicts of its 3-way; the edge-case
    flags; the slots added, removed or moved; the §2 checklist's changes; the titles and
    field labels to rename; the *Upgrading* notes in release order;
  - `invariant` — the closed list of touches on `.claude/memory/`, by content;
  - `post` — the reconciled project against `vY`: METHOD files and modes, orphans,
    markers, hooks, titles and labels.
  `classes <tag>` prints the class table, the authority file by file. The script decides
  nothing and writes nothing in either repository — only under an absolute `T` outside
  both — and it runs only as `vY`'s copy: a copy from the framework's working tree is a
  `FAIL`. Each finding is `OK`, `FAIL` or `CHECK`, under any git configuration of the
  user's. Its self-test, `bash tools/test-upgrade-check.sh`, fails when a payload file has
  no class. Tried read-only on a client project's three real upgrades,
  it reproduced what had been measured by hand — 161 of 197 lines in conflict in
  `CLAUDE.md` on the translation release, the two per-version bases of
  `hooks-install.sh` on the first upgrade.
- **A class of memory templates** (IMP-046): the four guide READMEs and the header of
  `LEARNINGS.md`, reconciled 3-way like the hybrids, so a project's customisation (an
  answered ADR slot, a pruned block, a header paragraph of its own, a reworded format
  comment) survives an upgrade; `SETUP.md` gives the recipes for the header and the
  format comment.
- IMP-070 (open, high): multi-platform support — macOS, Linux, Windows — for v1.5.0.

### Changed
- **The upgrade's memory invariant is a closed list, checked by content** (IMP-046),
  instead of an empty diff that the procedure's own classes contradicted: the memory
  templates, the format lines of edge case 3, the upgrade's own note, plan and decision
  records, and `STATE.md`, `TREE.md`, `INDEX.md` at the checkpoint. It runs at Step 5,
  before the checkpoint.
- **Step 3 picks its strategy per file from the measure** (IMP-050, point 3): a surgical
  3-way where the conflicts are few, a rebuild from `vY` with the project's
  customisations re-applied where most of the file conflicts. **The slots that changed or
  moved are derived from the tags** (IMP-050, point 4): the markers and the §2 checklist
  compared between `vX` and `vY`, no hand-written list.
- **The provenance pin is checked**: `version: vX.Y.Z` with its `v`, `commit` the tag's
  commit. A malformed pin is an error that names its correction, never normalised; a tag
  on the pinned commit is only suggested.
- **The IMP field labels are format, like the section titles** (`CLAUDE.md`, rule 9;
  `SETUP.md`, edge case 3 (b), with their table): renamed at every upgrade whose `vY` has
  the new ones.
- **`STATE.md`, `TREE.md` and `INDEX.md` are compiled memory** in a project: never
  reconciled 3-way; a change to their format arrives only as a declared migration.
- The *"No automation, for now"* box becomes *"Mechanical checks, not an orchestrating
  command"*: only a command that would orchestrate the steps stays deferred, until the
  first upgrade of a second project.

**Upgrading from 1.3.4** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- This upgrade is the first to run with the script: follow `SETUP.md` and run
  `tools/upgrade-check.sh` as they stand at v1.4.0.
- `CLAUDE.md` (HYBRID): in rule 9, the four lines from the one that begins "protects the
  memory's CONTENT" to "which every command would have to consult." become exactly:

  ```
     protects the memory's CONTENT. Its FORMAT is method: the section titles and the
     field labels the commands look up by name take the method's form, and every upgrade
     brings the project's to it, leaving the content under them as it is — never a map
     from old to new, which every command would have to consult.
  ```

- **The field labels of `LEARNINGS.md`**: a project whose entries still carry the labels
  of 1.0.0 or earlier renames them now, with the table of edge case 3 (b), in the same
  declared commit as the titles. This applies whether or not the project followed the
  title rename of 1.3.2.
- **The pin**: a `version:` without its `v` is corrected by hand before the upgrade;
  `preflight` names the line.
- No script of the payload, hook or settings change: `make hooks-install` is not needed
  from 1.3.4; `make test-scripts` as usual.

## [1.3.4] — 2026-10-10

### Fixed
- **`/integrate` prints two blocks, and the push comes after the checks** (IMP-069). The
  single block asked to verify "BEFORE the push" in a comment; pasted whole — as happened
  at 1.3.2 and 1.3.3 — it pushed before anyone had read the checks. Block 1 is local only
  and ends with the checks; one line outside the blocks names what they must have
  printed; block 2 holds only the publication. Because blocks are pasted whole:
  - block 1's constructive lines (rebase, merge, tag) are ONE `&&` chain, so after a
    failure nothing else runs — the old block tagged the wrong commit after a rebase
    conflict (reproduced), and a later paste could publish that tag;
  - the checks print fixed lines — `tag on <integration>: OK` (the tag on the commit just
    merged), `count: OK (N)` (the commits about to be published), `signature: OK` —
    whatever language git or gpg answer in;
  - no comment line inside the blocks: in zsh with its default options a `#` at the
    prompt is a command (`command not found: #`), and in a chain it breaks the chain;
  - block 2 pushes the branch and the tag in one atomic push, then deletes the merged
    feature branch: a refused branch push no longer lets the tag go public.
  The release variant is spelled out, and never deletes the integration branch.
  `docs/04` (*Execution boundary and blocks for the user*, rule 4) states the rule for
  every block that ends by publishing; `docs/00` describes the step accordingly.
- **The tag's signature is verified where tags are signed** (IMP-066). When `tag.gpgSign`
  is true in the repository's or the global config, block 1 runs `git tag -v`. Signing
  stays optional: a project that does not sign sees no check. `docs/04` (*Tag and push
  hygiene*) adds it, checks the tag against the merged tip rather than its mere
  existence, and asks for a pure-ASCII `-m` printed so by the agent instead of a tag
  "typed by hand".

### Added
- IMP-069, recorded and applied in this release; IMP-066 applied.

**Upgrading from 1.3.3** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade says how they combine):
- METHOD files — bring them over from the tag, after the pre-flight of edge case 7 (both
  carry setup slots): `.claude/docs/00-overview.md`, `.claude/docs/04-git-workflow.md`.
- `.claude/commands/integrate.md` (HYBRID, customised at setup, 3-way): the header and
  step 2 speak of "blocks"; steps 4 and 5 and the release variant are rewritten. Keep
  your integration and stable branch names in the merged text.
- No script, hook or settings change: no `make hooks-install` is needed from 1.3.3;
  `make test-scripts` as usual.

## [1.3.3] — 2026-10-10

### Fixed
- **`make hooks-install` from a linked worktree.** `scripts/hooks-install.sh` wrote to
  `<repository>/.git/hooks`, but in a linked worktree `.git` is a file: the script aborted
  with `mkdir: … Not a directory` — an upgrade run on its own worktree hit it at Step 4.
  It now resolves the repository's common git directory, shared by all worktrees
  (`git rev-parse --path-format=absolute --git-common-dir`). It stops with a clear message
  outside a repository — where it printed OK and created a stray `.git` — and when its
  copy is not at the top level of the repository it sits in, where it would have
  installed the hooks into the enclosing repository. Its messages name the hooks
  directory. The self-test gains a third case: a linked worktree, a subdirectory, outside
  a repository, below the top level.
- **The upgrade's Step 4 could pass with the push boundary missing.** Its proofs exercise
  behaviour, not version: they pass with older hooks installed, and none reaches the
  `pre-push` 1.3.0 added. Step 4 now checks that every hook the script generates is
  installed and carries the generator's marker — the list read from the script's own
  loop. It catches a missing or foreign hook; the re-run is what makes them current.
- **The upgrade's rollback of the hooks did not work.** Edge case 4 said to re-run
  `vX`'s `make hooks-install`: that leaves the `pre-push` a `vX` before 1.3.0 never had, a
  `vX` from 0.3.0 to 1.0.0 refuses the English marker, and `FORCE_OVERWRITE=1` overwrites
  the pre-upgrade `.bak`. Step 1 now photographs the hooks directory into the scratch
  directory (never over an existing photograph), and edge case 4 moves the installed
  hooks aside and restores the photograph byte for byte.
- **The `Makefile` is no longer an "additive union" in the upgrade.** Step 3 still said
  so, against the 1.3.2 notes: a union keeps two `reset-task` recipes, and `make` runs
  both, or warns and runs only the last. The `Makefile` goes through the 3-way like every
  hybrid; only `.gitignore` stays additive.
- **A slot that moves to another file** (the upgrade's new edge case 8). A clean 3-way of
  its new home lands the framework's default while the project's answer stays in the old
  file: move the answer first, then bring the old file over, then check every way of
  reaching it.
- **The *Upgrading* notes are part of the procedure** (Step 2): collected from every entry
  between `vX` and `vY`, oldest first. Notes on different topics add up; notes on the
  same topic supersede each other, the latest winning.
- **The memory's section titles are compared at every upgrade** (edge case 3 (b)), not
  only when `vY` renames them: a project that kept the titles of an earlier release was
  never caught. The rename is mandatory, and the project's own code and tests that cite
  the old titles change in the same commit as the rename. The title table is now also in
  `SETUP.md`, with the shortened forms seen in projects (`## Rimandate`, `## Rifiutate`).
- `SETUP.md`: the prerequisites name git 2.31, and Node.js for two users with different
  floors — the guard needs 14.13.1, while commitlint, run through npx at its latest
  release, declares its own (22.12 for the 21.x line); the upgrade's execution boundary
  says that delegated agents only read; Step 4 explains why `make test-scripts` checks
  `settings.json`.

### Changed
- **Rule 9 separates the memory's content from its format** (`CLAUDE.md`). What the memory
  holds is never bulk-translated; the section titles the commands look up by name are
  format, and format is method, so the upgrade renames them in the project — never
  through a map from old titles to new.
- **When the documentation is the product, a release is what reaches the consumers**
  (IMP-047). `docs/04` (*Versioning*) and `/integrate` no longer send every doc-only
  change to "no tag" in such a project: a change to the files it ships is a release, at
  least a PATCH. `CONTRIBUTING.md` names what this framework ships — the payload, plus
  what an upgrade reads at the tag (`SETUP.md`, the upgrade's tooling).

### Added
- IMP-068 (open): a list that declares itself complete deserves a mechanical check.
- The upgrade block's decisions: IMP-037 option (b), a read-only upgrade verification
  script, approved for 1.4.0, option (a) deferred under a new trigger; directions and
  target releases for IMP-046, IMP-049 and IMP-050.

**Upgrading from 1.3.2** (from an earlier release, also follow the entries in between —
Step 2 of the upgrade now says how they combine):
- METHOD files — bring them over from the tag, after the pre-flight of edge case 7
  (`docs/04` carries setup slots): `.claude/docs/04-git-workflow.md`,
  `scripts/test-hooks-install.sh`, `scripts/README.md`.
- `scripts/hooks-install.sh` (HYBRID, 3-way): the `HOOKS_DIR=` line becomes the block
  that resolves the common git directory (`REPO_ROOT` is unchanged: the block reads it);
  the pre-push refusal and the final OK line name the hooks directory.
- `.claude/commands/integrate.md` (HYBRID, customised at setup, 3-way): step 2's no-tag
  bullet gains the exception for a project whose documentation is the product.
- `CLAUDE.md` (HYBRID): in rule 9, the lines that begin "The rule applies from the graft"
  and end before "Past git history is never translated" become exactly (from a release
  before 1.3.2, which has no such lines, add them right before "Past git history is
  never translated"):

  ```
     The rule applies from the graft, or from the upgrade that brought it, onwards: to
     the method's artifacts and to the new ones the project produces; what already
     exists is never bulk-translated (translating it is a task the user decides). That
     protects the memory's CONTENT. Its FORMAT is method: the section titles the
     commands look up by name take the method's form, and every upgrade brings the
     project's titles to it, leaving the content under them as it is — never a map
     from old titles to new, which every command would have to consult.
  ```

- Before Step 4, photograph the hooks (Step 1 of the upgrade). Then `make hooks-install`
  (the script changed; from a linked worktree too) and the Step 4 checks,
  `make test-scripts` included (git 2.31 or later).
- The memory's section titles: run the comparison of edge case 3 (b). It applies to every
  project still carrying titles from before 1.1.0, whether or not it followed the 1.3.2
  note.

## [1.3.2] — 2026-10-10

### Fixed
- **A broken guard is no longer silent in the main session.** When
  `scripts/agent-git-guard.mjs` cannot run, the wiring in `.claude/settings.json` still
  blocks delegated agents and, in the main session, now exits 1 — a non-blocking error
  that the transcript shows with the wiring's own first line:
  `agent-git-guard: cannot run (exit N): delegated agents are blocked until it is
  repaired; this session is not`. In 1.3.1 the main session's calls passed silently, and
  nobody learned that delegated agents had lost their Bash tool.
- **`wip` commits** (C13): `docs/04` and `/checkpoint` prescribed a `wip:` prefix that the
  commit-msg hook rejects — `wip` is not in commitlint's `type-enum`. They now prescribe
  `chore: wip …`; commitlint is unchanged.
- **`scripts/reset-task.sh` carried a setup slot while filed METHOD**, so an upgrade
  overwrote a project's list of protected branches. The list now lives in the `Makefile`
  (`PROTECTED_BRANCHES`, a `[TO BE DEFINED AT SETUP]` slot of the `reset-task` target);
  `make reset-task` is the entry point and `make reset-task YES=1` the unattended one (an
  agent has no terminal to answer the prompt). Run directly without the list, the script
  falls back to `main develop` with a warning, and refuses `--yes`.
- **The upgrade had no declared way to rename the memory's section titles** (C12, see the
  Errata). `SETUP.md`, edge case 3, now names two declared exceptions to the empty-diff
  invariant on `.claude/memory/`: the pointers to renamed docs, and the section titles the
  method looks up by name — renamed to `vY`'s form in a separate commit, their content
  never touched.
- `SETUP.md`: the §2 checklist, which calls itself the complete list, now names the setup
  slots it missed — where formal ADRs live; the merge form and the public contract of
  `docs/04`; `PROTECTED_BRANCHES`; `SECURITY.md`'s; the sensitive list `docs/00` points
  to — and an unclosed backtick around `docs/06` is closed.

### Changed
- **Rule 9 states its own scope** (B8): in `CLAUDE.md` it applies from the graft, or from
  the upgrade that brought it, onwards, and what already exists is never bulk-translated.
  Until now this lived only in `SETUP.md`, which never reaches a grafted project.
- Rule 7 and `docs/01` point to `make reset-task`.
- The live memory no longer names a client project (two IMP entries, five session notes).
  The release tags already published keep the earlier text.

### Added
- IMP-067 (open, medium): the framework in headless mode and via the Claude Agent SDK.

### Errata — corrections to entries already published
- **[1.1.0], the escalation delimiters** (C11). That entry says that "every READER
  accepts the legacy Italian form", the escalation delimiters included. The legacy forms
  ARE accepted by the setup grep and the `/lint-memory` sentinel (the marker), by
  `/harvest-framework` (`Destinazione: framework`) and by `hooks-install.sh` (the hook
  marker). Of the two delimiters 1.1.0 renamed — the closers `FINE REPORT` and
  `FINE RESPONSE` — the method reads only one: the closer of the Architect's answer,
  checked by `docs/05` (*HOW to handle the answer*, rule 1) in its English form,
  `===== END OF RESPONSE =====`; an answer closed by 1.0.0's `===== FINE RESPONSE =====`
  can get a request to paste it again. The report's closer is read by the Architect, not
  by the method, and the printed `PRONTO PER INTEGRAZIONE` / `RACCOLTA PER IL FRAMEWORK`
  blocks have no reader at all.
- **[1.1.0], "Upgrading is optional and needs no migration" was wrong** (C12). 1.1.0
  declared that the memory templates were translated, not what that broke: the format
  comment of the Applied section of `LEARNINGS.md` was dropped; the `/checkpoint`
  placeholder `<branch-integrazione>` became `<integration>`; and the section titles of
  `STATE.md` and `LEARNINGS.md` were translated, while `/checkpoint`, `/lint-memory`,
  `/retro`, `docs/03` and `docs/06` look them up BY NAME — so a project that crossed 1.1.0
  with Italian titles is not read correctly. The migration step is in *Upgrading* below;
  no command reads the old titles (no legacy reader, as for C11).

**Upgrading from 1.3.1** (from an earlier release, also follow the entries in between):
- METHOD files — bring them over from the tag, after the pre-flight of edge case 7
  (`docs/04` carries setup slots): `.claude/docs/01-task-planning.md`,
  `.claude/docs/04-git-workflow.md`, `scripts/reset-task.sh`, `scripts/agent-git-guard.mjs`,
  `scripts/test-agent-git-guard.sh`, `scripts/README.md`. The guard's self-test must come
  together with `settings.json`: each checks the other's version.
- `.claude/settings.json` (HYBRID, 3-way): the guard's `command` changes.
- `.claude/commands/checkpoint.md` (HYBRID, customised at setup, 3-way): the `wip` line
  becomes `chore: wip …`.
- `Makefile` (HYBRID) — not additive this time: add the variable with your integration and
  stable branches, `PROTECTED_BRANCHES = main develop`, and REPLACE the `reset-task`
  recipe line with
  `PROTECTED_BRANCHES="$(PROTECTED_BRANCHES)" bash scripts/reset-task.sh $(if $(YES),--yes)`
  (an additive union would keep both lines and run the script twice). If you had edited
  the list inside `scripts/reset-task.sh`, move it to `PROTECTED_BRANCHES` BEFORE taking
  1.3.2's script, which is METHOD and comes over as is.
- `CLAUDE.md` (HYBRID): in rule 7, `(scripts/reset-task.sh)` becomes `` (`make reset-task`) ``;
  in rule 9, right before "Past git history is never translated", add exactly:

  ```
     The rule applies from the graft, or from the upgrade that brought it, onwards: to
     the method's artifacts and to the new ones the project produces; what already
     exists is never bulk-translated (translating it is a task the user decides).
  ```

  and in *Quick commands* the `./scripts/reset-task.sh` line becomes:

  ```
  - `make reset-task` — discard the interrupted half-done task (keeps commits; the
    protected branches are the Makefile's `PROTECTED_BRANCHES`; `YES=1` without asking)
  ```
- **The memory's section titles — for a project that crossed 1.1.0 with Italian titles.**
  In a separate commit (`docs(memory): rename the memory's section titles to vY's form`,
  edge case 3 (b) of the upgrade), rename ONLY the title lines; the content of the
  sections stays as it is, in its language (rule 9 is prospective):

  | File | Title until 1.0.0 | Title since 1.1.0 |
  | --- | --- | --- |
  | `STATE.md` | `## Stato avanzamento` | `## Progress` |
  | `STATE.md` | `## Cosa esiste adesso` | `## What exists now` |
  | `STATE.md` | `## Decisioni prese (non ovvie dal codice)` | `## Decisions made (not obvious from the code)` |
  | `STATE.md` | `## Debito documentazione` | `## Documentation debt` |
  | `STATE.md` | `## Attenzione / problemi aperti` | `## Caution & open issues` |
  | `STATE.md` | `## Branch attivi` | `## Active branches` |
  | `LEARNINGS.md` | `## Proposte APERTE (in attesa di decisione utente)` | `## OPEN proposals (awaiting the user's decision)` |
  | `LEARNINGS.md` | `## Applicate` | `## Applied` |
  | `LEARNINGS.md` | `## Rimandate (non respinte — si riprendono al momento giusto)` | `## Deferred (not rejected — resumed at the right time)` |
  | `LEARNINGS.md` | `## Rifiutate (con motivo — per non riproporle)` | `## Rejected (with the reason — so they are not re-proposed)` |
- No hook changed since 1.3.1, so `make hooks-install` is not needed from there; run
  `make test-scripts`.

## [1.3.1] — 2026-10-07

### Added
- IMP-063..066 (open): a fan-out's stall cost; permission probes in an untrusted
  workspace; editing the method's own files with the file tools; verifying the tag's
  signature in `/integrate` when signing is configured (low priority).

### Changed
- `docs/04` (*Enforcement of the execution boundary*), `SETUP.md` (upgrade Step 3) and
  `scripts/README.md`: the recovery and the upgrade order simplify — there is no longer
  an order to respect between the guard and `.claude/settings.json`.

### Fixed
- **A broken agent-git guard no longer blocks the main session** (IMP-055, the code
  review's A5 variant). In 1.3.0 any failure of `scripts/agent-git-guard.mjs` — a missing
  file or `node`, a crash — blocked every Bash call, the main session's included, although
  the guard has no job there (the push boundary is the `pre-push`); a grafted project
  upgraded with `settings.json` before the guard locked its own session. The wiring in
  `.claude/settings.json` now lets the guard's verdict stand and turns a failure into a
  block only when the hook input carries `agent_id`: delegated agents stay fail-closed.
  An input the wiring cannot read blocks every call; the guard reports an unparseable
  input as a failure (exit 3).
- **The self-tests are hermetic against the user's git setup.** With a global
  `tag.gpgSign`, the snapshot test failed (a plain `git tag` became a signed tag asking
  for a message); run from a git hook, `GIT_DIR`/`GIT_INDEX_FILE` pointed the throwaway
  commands at the real repository. The tests that run git now ignore the global and
  system config and the caller's git environment.

**Upgrading from 1.3.0:** reconcile `.claude/settings.json` (the PreToolUse hook's
`command`, 3-way) and bring `scripts/agent-git-guard.mjs` and the three
`scripts/test-*.sh` over, in any order; then `make test-scripts`. Nothing changes for
delegated agents; the main session no longer loses its Bash tool when the guard cannot
run.

## [1.3.0] — 2026-10-07

### Added
- **The push boundary: a `pre-push` hook** (IMP-054). `scripts/hooks-install.sh` now also
  installs a `pre-push` that refuses a push launched from a Claude Code session. It reads
  the session markers that every process the agent starts inherits: `AGENT_GIT_BOUNDARY`,
  set by the new `env` key of `.claude/settings.json`, and `CLAUDECODE` as the fallback.
  The `Bash(git push:*)` deny matches command text only: probed on Claude Code's real
  matcher, 20 of 30 push forms (`git -C <dir> push`, `git 'push'`, an alias, `sh -c`, a
  script, `make`, …) reached a local test remote past it; with the `pre-push`, only two
  forms of deliberate evasion did (`git send-pack`, `--no-verify` with hooks disabled). A
  project's own pre-push (git-lfs's, for one) goes in `.git/hooks/pre-push.local`, which
  the generated hook runs after the check.
- **Delegated agents are read-only on git** (IMP-055). A PreToolUse hook on the Bash and
  Monitor tools, `scripts/agent-git-guard.mjs`, refuses every git write by a subagent or a
  workflow agent (the hook input carries `agent_id`), recognising the subcommand after
  git's global options; the main session is never restricted. It is wired
  `node … || exit 2`, because Claude Code lets a hook that exits 1, misses its binary or
  times out proceed: a crash or a missing `node` blocks. A linked worktree is no exception
  — it shares refs, config and stash with the repository.
- `scripts/repo-snapshot.sh`: a read-only fingerprint (HEAD, branch, refs, stash,
  worktrees, untracked files) that the main session diffs before and after delegating
  work; any difference means stop and report.
- `ask` rules on edits to `.claude/settings.json` and to the guard: settings reload while
  Claude Code runs, so an accidental edit would change the boundary at once.
- Self-tests in `make test-scripts` that fail when the `pre-push` or the guard stop
  blocking, the crash and missing-binary cases included: `test-agent-git-guard.sh`,
  `test-repo-snapshot.sh`, and a second case in `test-hooks-install.sh`.
- `SETUP.md`, *Hardening*: the threat model, the forge's rules as the server-side layer
  (the framework repo's own rulesets as the example) and the Claude Code sandbox as a
  documented option with its cost.
- IMP-062 (open): covering remote writes through `gh`.

### Changed
- `docs/04`: new sections *Enforcement of the execution boundary* — the threat model is an
  agent's ACCIDENTAL errors with ordinary commands; deliberate evasion is for the
  operating system or the forge — and *Delegated agents and the shared working tree*.
  Claude Code never pushes; the deny list is a convenience, no longer presented as the
  boundary. `docs/03` points review agents to the delegated-agent rules.
- `SETUP.md`: the guard, the snapshot and the self-tests are filed as METHOD
  (`test-hooks-install.sh` was in no class); setup step 3 and upgrade Steps 3-4 name the
  `pre-push`, the guard and their order. `.gitignore` excludes `.claude/worktrees/`.

**Upgrading from 1.2.x — a declared change of behaviour for agents:**
- delegated agents (subagents, workflow agents) can no longer write git state —
  commits, branches, checkouts, stashes, tags — anywhere, their own worktree included: a
  project whose delegated agents write git must move those writes to the main session;
- no push from inside a Claude Code session: the human pushes from their own terminal;
- bring `scripts/agent-git-guard.mjs` and the other new scripts over BEFORE merging
  `.claude/settings.json`: the merged settings wire the guard at once, and a missing guard
  file blocks every Bash call (the file tools still work to repair it). Then
  `make hooks-install` — a project with its own `pre-push` renames it to
  `.git/hooks/pre-push.local` first — and `make test-scripts`. The guard needs Node.js
  14.13 or later.

## [1.2.1] — 2026-09-25

### Fixed
- **The upgrade procedure could read the wrong version of the framework, with no
  error** (IMP-050, points 1-2). In `SETUP.md`, *Upgrading the framework*, the
  Precondition asked for "two checkouts (or exports)" and Step 2 read the CHANGELOG
  with no ref, so the procedure read whatever the framework's SHARED clone had checked
  out — during a real upgrade, another session switched that clone to `main` while the
  upgrade was reading it. And no command named the repo: a project that versions itself
  with `vX.Y.Z` answers a bare `git show vY:<path>` with its OWN file, exit 0 — a
  silently corrupted 3-way, IMP-036's class. Now the framework is read only as
  immutable objects, by tag, from the project root: every framework-side command
  carries `git -C "${FW:?}"` (an unset `FW` would turn `git -C ""` back into the
  project), the project-side commands stay bare, and a read-only check stops on a wrong
  working directory, on `FW` pointing at the project (any of its worktrees), a
  subdirectory or a non-repo, and on a missing `vY`. The 3-way reads its base and theirs
  by tag into a scratch directory outside both repos — never through `<( … )`, which
  `git merge-file` can read empty or truncated. Graft step 1 resolves the pin's
  `commit` the same way. A bare clone is mentioned as an option; `--mirror` is not.
  **Upgrading:** nothing to migrate in a project. The upgrade now needs a git clone of
  the framework with its tags: an export (the old "or exports") has no tags to read by.

## [1.2.0] — 2026-09-23

### Added
- **`model` and `turns` in the session-note frontmatter** (IMP-044): two OPTIONAL
  fields — which model produced the note (its id as the runtime exposes it, verbatim,
  always single-quoted) and how many user messages the recorded work took (a bare
  integer, per note: an approximate proxy of friction, a lower bound after a compaction
  or a resumption). Defined in `.claude/memory/sessions/README.md`; `/checkpoint`
  (step 3) carries the minimal format inline, since it is the command that writes the
  notes. Additive and backward compatible: older notes stay valid and are never
  backfilled. Deliberately NOT recorded: tokens, duration, files touched, difficulty
  (reasons in IMP-044). No command consumes the fields yet: a threshold rule on `turns`
  is deferred until a real distribution exists (IMP-045).
  **Upgrading from an earlier release:** bring `.claude/memory/sessions/README.md` and
  the IMP-format comment at the top of `.claude/memory/LEARNINGS.md` over by hand —
  they are method templates, but the upgrade procedure's Step 2 diff excludes
  `.claude/memory/` (a known contradiction, IMP-046, open).

### Changed
- The Origin line of the IMP format points at the session note that produced the
  proposal: `Origin: [[<session note>]] — <problem>` (IMP-044) — the provenance of an IMP
  was traceable for only 2 of 43 entries. `/harvest-framework` keeps local session-note
  wikilinks out of the harvested block.
- `docs/01-task-planning.md`, the coherence review of a cross-module refactor: section
  titles cited by name from other files are a shared contract too — when the work
  renames them, grep the old and the new wording before the merge (IMP-043).

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

*Corrected in 1.3.2, Errata.*

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
