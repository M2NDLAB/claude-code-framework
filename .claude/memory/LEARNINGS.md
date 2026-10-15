---
type: learnings
updated: 2026-10-15
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
> IMP numbering starts at **001**. This file is born EMPTY in a new project.
>
> **The `Destination: framework` attribute.** In a CLIENT project an IMP may concern
> the FRAMEWORK rather than this project: it is marked with the line
> `- Destination: framework` (a single physical line, so `/fw:harvest-framework` picks
> it up via grep). Omitted = a lesson about this project, which stays in the client.
> It is a DESTINATION attribute, not a level: the lesson stays a Level 2 one — see
> `docs/06-self-improvement.md`, *"The bridge to the framework"*.

## OPEN proposals (awaiting the user's decision)

### IMP-086 — The framework repository's visibility, and what its memory holds
- Date: 2026-10-13 | Origin: the user's decision, 2026-10-13 — at the end of the cycle the
  framework's repository becomes PRIVATE, for personal use; recorded in
  [[2026-10-12-prerequisites-1.6.0]]
- Priority: LOW (user decision, 2026-10-13).
- Observed problem: the switch changes conditions the repository relies on today, to be
  handled at that moment:
  - rulesets on GitHub's Free plan apply to public repositories only: Pro, or a
    protection that is local only;
  - the CI has 2,000 minutes a month, Windows counted twice and macOS ten times — the
    user's proposal: drop macOS from the CI, already covered locally;
  - the "Repository visibility" line of auto mode, in the user's `~/.claude/settings.json`,
    to update;
  - `README.md` and `CONTRIBUTING.md` must not present the repository as public.
- The memory's hygiene, valid while private too: no names or details of the projects that
  use the framework, no personal data, references in a neutral form — the practice since
  v1.3.2. What has been public stays public: no rewriting of history.
- Proposal: NOT decided — the list above, applied when the repository turns private.
- Expected benefit / risk: the switch costs no protection and no CI coverage unknowingly.
  Risk: without macOS in the CI, bash 3.2 and the BSD userland are verified only locally.
- Resumption trigger: the switch of the repository to private, at the end of the cycle.
- Status: APPROVED on 2026-10-13 (the retro over the backlog) — applied at its trigger, the
  switch, not in v2.2.0. Two decisions are the user's then: GitHub Pro or a protection that
  is local only — the ruleset that protects the remote tags is one of those that stop
  applying on the Free plan —, and macOS out of the CI. IMP-099's platform claim no longer
  depends on the second (see there).

### IMP-104 — Mechanical detection of a session started outside the repository's root
- Date: 2026-10-14 | Origin: v2.2.0's review, H1 — [[2026-10-13-backlog-retro-2.2.0]]
- Priority: LOW (user decision, 2026-10-14).
- Observed problem: Claude Code reads the project's settings from the session's primary
  working directory only, with no parent-directory fallback: a session started in a
  subdirectory, or moved there with `/cd`, runs without the guard, the `deny` and `ask`
  rules, the session marker and the SessionStart hook, and nothing says so. v2.2.0 declares
  it in `docs/04` and `SETUP.md`, and `CLAUDE.md` — which loads from the directories above —
  tells the agent to say so when `STATE.md` was not injected: an instruction, read by the
  agent, not a mechanism.
- Proposal: a SessionStart hook in the USER's settings (`~/.claude/settings.json`), which
  load from any folder: it checks whether the session is inside a repository that carries
  the framework but not at its root, and warns. It is the machine's configuration, not the
  payload's: `SETUP.md` would document it as optional hardening.
- Expected benefit / risk: the slip caught by the machine rather than by the agent's
  reading of an instruction. Risk: a hook in the user's settings runs in every project and
  every folder; it must stay cheap, and silent where it has nothing to say.
- Resumption trigger: the first time a session starts from a subfolder without
  `CLAUDE.md`'s instruction catching it.

### IMP-105 — The real path starts where the tool reads its configuration
- Date: 2026-10-14 | Origin: v2.2.0's retro — its review's H1 and the re-reading of task 6
  — [[2026-10-13-backlog-retro-2.2.0]]
- Observed problem: two releases in a row, the review's only HIGH was a configuration the
  boundary relies on, silently not in effect — in v2.1.0 a hook manager that sets
  `core.hooksPath` after the install (IMP-090), in v2.2.0 a session that did not load the
  project's settings. `docs/03`'s *The real path* asks what a tool's configuration makes it
  do, not where and when the tool reads it. In the same release four statements about
  Claude Code, written from WebFetch's answers about its pages — a model's reading, of the
  first part only of a long page — and compressed in the writing, said more or other than
  the pages' own text: the re-reading from the pages' Markdown, at the user's request, found
  them.
- Proposal: *The real path* gains (a) where and when the tool reads the configuration the
  gate relies on — the files, the directory it starts from, the flags and settings that
  skip them —, and (b) a statement about an external tool rests on the source's own text,
  its passage quoted in the record, never on a summary of it.
- Expected benefit / risk: the family of the last two HIGHs looked for by name, and a claim
  checked against a quote rather than a paraphrase. Risk: a longer lens, and readings that
  cost more.

### IMP-106 — The snapshot's difference when the user pushes during a delegated run
- Date: 2026-10-14 | Origin: v2.2.0's retro — [[2026-10-13-backlog-retro-2.2.0]]
- Observed problem: in this repository block 0 runs while a reviewer works, and the user's
  push moves `refs/remotes/origin/<branch>`, which the snapshot records: the comparison after
  the review showed a difference no agent made. `docs/04` says any difference stops the
  session, to be reported; the main session read the ref's reflog — "update by push", at the
  time of the user's push — and went on with the review's fixes before reporting it, which
  the rule's letter does not allow.
- Proposal: `docs/04`'s *Snapshot before, check after* names the case — a remote-tracking
  ref whose reflog says "update by push" at the user's push is the user's, reported with the
  result rather than stopped for —, or the snapshot before is taken after the user's push.
- Expected benefit / risk: the rule stays strict where an agent could have moved shared
  state, and the expected case no longer invites a deviation. Risk: none known — an agent's
  push is refused by the `pre-push` before any ref moves.

### IMP-107 — The greenfield copy has no read-by-tag recipe
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 001, 2026-10-14): a greenfield graft of v2.2.0 copied the
  framework with no prescribed way to read it by tag
- Observed problem: `SETUP.md` §1 says only "Copy into the root of the new repo: the
  `.claude/` directory, …" — implicitly from the clone's working tree. The upgrade's
  Precondition rule 1 (the framework read ONLY as immutable objects, by tag) has no
  greenfield counterpart, and `git show <tag>:<path>` does not carry file modes (scripts
  lose their executable bit). The agent improvised
  `git -C "${FW:?}" archive <tag> -- <paths> | tar -x`.
- Proposal: §1 gives the copy by tag as a block —
  `git -C "${FW:?}" archive vX.Y.Z -- .claude CLAUDE.md Makefile commitlint.config.cjs .gitignore .gitattributes scripts | tar -x`
  from the project root — and states the upgrade's rule: never the working tree.
- Expected benefit / risk: the graft copies exactly the pinned version, modes included;
  the pin's commit is true by construction. Risk: none known.
- Kin: IMP-050 (points 1-2), the same rule for the upgrade.
- Status: APPROVED on 2026-10-15 (the retro, [[2026-10-15-harvest-retro-3.0.0]]) — with
  IMP-113, one block of §1: the copy by tag (`git archive`, the live memory excluded), a guard
  on the directory, the pin from the same literal tag, a check line, since the pipe returns
  tar's status; brownfield extracts into `T`; the plain `tar -x` the CI already runs, one form
  for the method.

### IMP-108 — The prerequisite check is run "from the framework's clone"
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 002, 2026-10-14): step 0 of a greenfield graft
- Observed problem: `SETUP.md` §0 runs `bash scripts/check-prerequisites.sh` "from the
  framework's clone or from the project once step 1 has copied `scripts/`". From the
  clone it is the working tree's script — what the upgrade forbids. The extract-to-scratch
  recipe exists only in the upgrade's Precondition.
- Proposal: §0 shows the same extraction as the upgrade —
  `git -C "${FW:?}" show vX.Y.Z:scripts/check-prerequisites.sh > "${T:?}/check-prerequisites.sh" && bash "${T:?}/check-prerequisites.sh"`
  — or says to run it after step 1's copy.
- Expected benefit / risk: one rule for reading the framework in every path of `SETUP.md`.
  Risk: none.
- Kin: IMP-050 (points 1-2), IMP-107.
- Status: APPROVED on 2026-10-15 — option (b): the check runs from the project's root at the
  end of step 1, after the copy; not an extraction at §0, which would need `FW` and `T` before
  the guide defines them and fails for an export.

### IMP-109 — `SETUP.md` §1 names `develop` as if it were mandatory
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 003, 2026-10-14): a graft onto a trunk-based project
- Observed problem: `SETUP.md` §1: "`git init` … and create the integration branch
  (`develop`)". `docs/04`'s *Branching model* says the names are ROLES and trunk-based is
  allowed; §1 reads as if `develop` were required, before §2 asks for the names.
- Proposal: §1 says "create the integration branch (its name is chosen at §2: `develop` by
  default, or `main` alone for trunk-based — `docs/04`)".
- Expected benefit / risk: no contradiction for a trunk-based project. Risk: none.
- Kin: IMP-008 (the branches as roles), which §1 predates in this sentence.
- Status: APPROVED on 2026-10-15 — in the same edit as IMP-110: the integration branch named
  when it is created, after `docs/04`'s *Branching model*, and recorded at §2.

### IMP-110 — Where the graft commit of a NEW project goes
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 004, 2026-10-14): a graft onto an empty repository
- Observed problem: `SETUP.md` never says where the graft is committed. In an empty
  repository the first commit creates the integration branch, so there is no base to
  branch from; yet `docs/04` says "never work directly on the integration branch", and
  `/integrate` assumes `origin/<integration>` exists. The user had to decide an exception
  (the graft committed on the integration branch, the first push as a plain block); the
  agent then extended the exception on its own to a second direct commit before the first
  push (the record of the push-boundary test).
- Proposal: `SETUP.md` §1 (or a new §3b) states the greenfield bootstrap: the graft is the
  root commit on the integration branch — the one declared exception to `docs/04` —,
  followed by a first push block the user runs (`git push -u origin <integration>`);
  `/integrate` starts from the second deliverable. `docs/04` names the exception and its
  PERIMETER: the root commit only, or everything before the first push (e.g. the boundary
  test's record, which can only be written after the graft commit).
- Expected benefit / risk: the first commit and the first push are prescribed, not
  improvised. Risk: none known.
- Status: APPROVED on 2026-10-15 — form A, the user's, not the entry's exception: the user's
  empty initial commit, before §1, and the first push, in two blocks; a remote the forge
  initialised with a README or a licence is the starting point instead; then the graft on a
  branch of its own, the project's first deliverable. `docs/04` unchanged.

### IMP-113 — The graft copies the framework's LIVE memory, then asks to empty it by hand
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 007, 2026-10-14): a greenfield graft received 27 of the
  framework's session notes and its whole IMP backlog
- Observed problem: `SETUP.md` §1 copies `.claude/` whole; §2 then asks to "EMPTY OUT the
  framework's LIVE memory" by hand (the sections of `LEARNINGS.md` back to empty, the notes
  of `sessions/` deleted). If skipped, the project starts with the framework's memory, and
  a `/harvest-framework` would send the framework's own IMPs back upstream as duplicates.
  The agent rebuilt `LEARNINGS.md` by hand.
- Proposal: the graft does not copy the live memory: `LEARNINGS.md` and `sessions/` come
  from empty templates (the header, the format comment, the four `## ` titles;
  `sessions/README.md` only) — e.g. §1's copy excludes `.claude/memory/sessions/*` but the
  README, and `SETUP.md` gives the empty `LEARNINGS.md` as the memory template
  `upgrade-check.sh` already classes it as.
- Expected benefit / risk: no forgettable manual step; no framework IMP can leak into a
  project's harvest. Risk: none known.
- Kin: IMP-024 (the declared hybrid regime), IMP-049 (payload purity).
- Status: APPROVED on 2026-10-15 — option (a), inside IMP-107's block: the archive leaves out
  `LEARNINGS.md` and the dated notes, `LEARNINGS.md` is derived from the tag's own file
  (header, the four titles, the format comment); §2's EMPTY OUT becomes a check, which also
  covers an export. The harvest risk the entry names does not hold: no framework entry carries
  the marker, and `/harvest-framework` excludes the format comment's line. The harms that do:
  the numbering, `/retro` and `/lint-memory` over the framework's entries and notes.

### IMP-114 — `hooks-install` says "enable formatting" to a project that chose none
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 008, 2026-10-14): a greenfield graft where formatting was
  decided "none"
- Observed problem: with the formatting slot of `scripts/hooks-install.sh` answered
  "none", `make hooks-install` still prints "Remember to enable automatic formatting in the
  pre-commit hook", and the `Makefile`'s help still says "formatting to be enabled". "None"
  is a legitimate answer the tooling does not recognise.
- Proposal: print the reminder only while the slot still carries its setup marker; the
  `Makefile`'s help says "formatting: see the pre-commit hook".
- Expected benefit / risk: no false reminder at every hooks run. Risk: none — the change
  sits near a slot, so IMP-088's distance rule applies.
- Status: APPROVED on 2026-10-15 — the reminder printed only while the generated pre-commit
  carries the formatting slot's marker, matched without writing it; the generated hooks
  unchanged; the `Makefile`'s help takes `CLAUDE.md`'s wording; the test inside the hooks'
  Case 7.

### IMP-115 — `SETUP.md` asks to fill the slots of `docs/02`-`04`, the upgrade classes them METHOD
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 009, 2026-10-14): filling the docs' slots in a greenfield
  graft
- Observed problem: `SETUP.md` §2 asks to fill slots in `02-code-quality.md`,
  `03-security-gate.md` and `04-git-workflow.md`. The upgrade's class table puts
  `.claude/docs/00-06` in METHOD (overwritten), and edge case 7 then has to detect them as
  hybrids "customised inline". Following §2 literally makes the next upgrade harder.
- Proposal: one rule: either the docs' slots are answered ONLY in `CLAUDE.md` (no slot left
  in METHOD files, the markers rephrased as pointers), or `docs/02`-`04` are classed HYBRID;
  §2 and the class table say the same thing.
- Expected benefit / risk: a greenfield project's first upgrade has no edge case 7 by
  construction. Risk: moving the slots is a migration (edge case 8) for existing projects.
- Kin: IMP-050 (points 3-4), IMP-088.
- Status: APPROVED on 2026-10-15 — option (b): `docs/02`, `03` and `04` classed HYBRID,
  nothing to migrate; option (a) would move their slots into `CLAUDE.md`, a migration close
  to the breaking criterion.

### IMP-116 — `integrate.md`: "replace the placeholders" is ambiguous, and trunk-based is not covered
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 010, 2026-10-14): filling `.claude/commands/integrate.md` in
  a graft onto a trunk-based project
- Observed problem: §1, "Replace the placeholders with the project's real names" — unclear
  whether setup rewrites the ~30 `<integration>`/`<stable>` occurrences (as `checkpoint.md`
  asks for its own) or the agent substitutes them at run time. With trunk-based
  (`<integration>` = `<stable>`) the promotion section and the pre/post-1.0 split of the
  tag's branch do not apply, and the command does not say so.
- Proposal: "the agent substitutes the names at run time; setup answers only this line",
  plus "trunk-based: the promotion section does not apply; the tag goes on the single
  branch".
- Expected benefit / risk: one reading of the command. Risk: none.
- Kin: IMP-008, IMP-019.
- Status: APPROVED on 2026-10-15 — the run-time reading, in a paragraph of the command's
  introduction that touches no answered line; trunk-based: the tag on the single branch, no
  promotion; `CONTRIBUTING.md` keeps the placeholder lines answered for the earlier grafts.

### IMP-117 — The slots of the method's files filled with `sed -i`, not with the file tools
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 011, 2026-10-14): the user's review of a greenfield graft;
  seen again in a later deliverable
- Observed problem: `docs/04`'s *Permission configuration* (the `ask` bullet, from
  IMP-075) says the method's files are edited with the file tools, auto mode included. The
  agent filled the slots of `CLAUDE.md`, `docs/02`-`04`, commands, `decisions/README.md`,
  `hooks-install.sh` and the `Makefile` with `sed -i` by LINE NUMBER. Cost: four later
  repairs (a duplicated half-line, a lost backtick, a garbled sentence, two comment lines
  deleted with a slot). `SETUP.md` §2 does not say how the agent writes the answers; the
  runtime's auto-mode instructions explicitly invite edits through sed. Later, outside
  setup: after editing project files through a Python heredoc, the agent edited a memory
  component note the same way, by momentum — the habit is per session, not per file.
- Proposal: `SETUP.md` §2, "in dialogue with Claude Code", adds: the agent writes the
  answers with the file tools (Edit/Write), slot by slot on the slot's text, never `sed -i`
  nor a substitution by line number — pointing at `docs/04`'s rule. The reminder is
  repeated where the memory is edited most: `/checkpoint`'s step 3 ("with the file
  tools").
- Expected benefit / risk: no collateral damage, and the `ask` checkpoint on the
  boundary's files is not bypassed by a bulk shell edit. Risk: more tool calls at setup.
- Kin: IMP-075 — its rule held in the text and was not followed at the point of use.
- Status: APPROVED on 2026-10-15 — the user's form: a short rule 10 in `CLAUDE.md`, pointing
  to `docs/04`'s *Operating rules for Claude Code*, not in *Persistent memory*: it concerns
  every file setup copies, not the memory alone. There, the reason (precision), the scope (the
  files setup copies) and a closed exception (a whole-file write a procedure prints, never an
  answer); the `ask` bullet keeps its two files and a pointer; the points of use in `SETUP.md`
  and the checkpoint's step 3. Why IMP-075's rule was not enough: the retro's note.

### IMP-118 — The setup marker does not tell a slot from a mention
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 012, 2026-10-14): the user's review of a greenfield graft,
  and again at the first deliverable's retro
- Observed problem: `SETUP.md` §2's grep for the setup marker returns the slots AND the
  prose that mentions the marker (the `Makefile`'s line 4, `CLAUDE.md`'s rule 9, …). The
  agent rewrote the `Makefile`'s line 4, which was not a slot — in a HYBRID file one more
  line to reconcile at the next upgrade. §2's *Convention* says it "holds for slots, not
  for prose that merely names the marker" but gives no mechanical way to tell them apart.
  Also: `docs/00`'s end-of-deliverable cycle, step 2, "(the concrete list is
  `[TO BE DEFINED AT SETUP]`)", is a mention, so the graft left it, yet it reads as an
  OPEN slot after `docs/03` answered it.
- Proposal: a distinct form for mentions (e.g. `«TO BE DEFINED AT SETUP»` or "the setup
  marker") so the grep returns slots only; `/lint-memory`'s check 10 and `upgrade-check.sh`
  adopt the same distinction.
- Expected benefit / risk: the grep becomes a to-do list; no method line rewritten by
  mistake. Risk: a migration of the prose in the framework's own files.
- Kin: IMP-031 (markers on one physical line, the known false positives declared).
- Status: APPROVED on 2026-10-15 — the literal marker only in a slot §2 lists: the mentions
  rephrased, `docs/00`'s slot-shaped line a pointer to `docs/03`, the code matching a split
  form. The user's choices: variant Y, `docs/04`'s two slot-shaped lines stay slots; and
  inventory's *Markers* section compares the marker lines, not the net counts per file, so a
  mention removed cannot hide a slot the same file gained. Not the guillemets: the greps and
  `MARKER_RE` match the bare words, brackets or not.

### IMP-119 — Trunk-based: no home for memory-only commits between deliverables
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 013, 2026-10-14): the first deliverable's retro of a
  trunk-based project
- Observed problem: after the graft was pushed, IMP updates about it had to be committed
  somewhere. `docs/00`'s "Unrelated work = unrelated branch" wants a separate branch;
  `docs/04` forbids direct commits on the integration branch, which in trunk-based is the
  only one. The agent put them as the first commit of the next feature branch — cheapest,
  but against the letter of `docs/00`; a separate chore branch costs a second `/integrate`
  cycle for a memory-only change.
- Proposal: `docs/00` (or `docs/04`) says where memory-only or process-only records go when
  no deliverable is open: e.g. "they ride on the next feature branch as its first, separate
  `docs(memory)` commit, named as such in the `/integrate` summary", or "a `chore/memory-*`
  branch integrated with the no-tag block". One rule for both branching models.
- Expected benefit / risk: no improvised exception at every between-deliverables note.
  Risk: none known.
- Status: APPROVED on 2026-10-15 — the user's form: a record made while no deliverable is open
  goes on a branch of its own, never onto the integration branch; a branch whose diff touches
  only `.claude/memory/**` is exempt from the gate and from `/retro`, and is integrated with the
  no-tag block and the CI green — the criterion is mechanical, on the diff —; with any other
  file, the full cycle. `CONTRIBUTING.md` adopts the same rule: ten memory-only commits went
  straight onto this repository's `main`.

### IMP-120 — Is a deliverable that is not "heavy" closed with the full cycle?
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 014, 2026-10-14): the first deliverable's retro; seen again
  at the second
- Observed problem: `docs/00` ties "deliverable" to "a complete heavy unit" and says small
  tasks do not need the full ritual; `docs/01`'s PHASE 1 measures heaviness (~8-10 files,
  ~400 lines). Two complete user-facing features (6 files / ~350 lines, then 3 files / ~125
  lines) were NOT heavy by `docs/01`, yet the user called them deliverables and wanted them
  integrated; the agent ran the full cycle because `/integrate` was asked. The docs leave
  the light-but-complete case undecided.
- Proposal: decouple the axes in `docs/00`: heaviness decides the PLAN (`docs/01`); the
  end-of-deliverable cycle is triggered by "a unit that will be integrated" (a branch going
  to `/integrate`), whatever its size; "small, isolated tasks" are those committed without
  their own integration.
- Expected benefit / risk: no doubt on when `/retro` and `/checkpoint` are due. Risk:
  slightly more ritual for small integrated fixes (`/retro` is a no-op without friction).
- Kin: IMP-006 (the single end-of-deliverable cycle).
- Status: APPROVED on 2026-10-15 — a deliverable is a unit of work that goes to integration,
  whatever its size; heaviness decides the plan only; the exemption of a memory-only branch is
  IMP-119's.

### IMP-121 — A question left for the user in a session note does not reach STATE, so resumption misses it
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 015, 2026-10-14): the resumption of a deliverable in a new
  session
- Observed problem: a session note ended a measurement with "to be added from the user's
  observation" — an open question for the USER. `/checkpoint` checks that the existing
  entries of *Caution & open issues* survive a rewrite of STATE, but nothing carries a NEW
  open thread of a note into STATE; the note template puts such threads under *Follow-up*,
  which nobody reads at resumption. The resumption summary, built from the injected STATE,
  did not mention it; the user remembered it on their own, and their handoff came back with
  the slot still unfilled.
- Proposal: `/checkpoint` (and `sessions/README.md`, *Follow-up*) says that every open
  thread awaiting the user or a later session — a question, a measurement — becomes an
  entry of STATE's *Caution & open issues* with its trigger (e.g. "→ Trigger: ask the user
  at the next session's start"); the note keeps the detail, STATE the pointer.
- Expected benefit / risk: a resumption from STATE alone surfaces every pending question.
  Risk: a longer *Caution* section — each entry is closed when answered.
- Kin: IMP-014 (debts with a trigger, surviving the rewrites of STATE).
- Status: APPROVED on 2026-10-15 — on the side that writes `STATE.md`: the checkpoint's step 3
  checks that every open thread of the notes it writes has an entry in *Caution & open issues*
  with its trigger, and the session-note format says the same; cited by *Format*, never by
  *Follow-up*, which sits inside the fenced template.

### IMP-123 — The shipped allow list admits more than reading
- Date: 2026-10-15 | Origin: the retro's agents, the P1 lens on the shipped `settings.json` —
  [[2026-10-15-harvest-retro-3.0.0]]
- Observed problem: `docs/04`'s *Permission configuration* says `allow` holds "only
  read-only commands", and the shipped list holds `Bash(git diff:*)`, `Bash(git log:*)` and
  `Bash(tree:*)`. In git's and tree's man pages — read, not measured —: `git diff` and
  `git log` take `--output=<file>`, which writes a file, and `--ext-diff`, which runs a
  configured program; `git diff --no-index` — explicit, or implied when a path lies outside
  the working tree — reads any file, `.env` included, while the `Read(.env)` deny binds the
  Read tool only; `tree -o <file>` writes a file. A rule matches the command's text, so each of
  these forms runs with no prompt.
- Proposal: (a) in v3.0.0, `docs/04`'s claim narrowed and the limit declared where the claim
  lives (the user's decision); (b) the mechanical restriction — narrower rules, deny pairs,
  fewer entries — measured before it is chosen.
- Expected benefit / risk: the allow list says what it grants; later, it grants reading only.
  Risk: a narrower list asks more often.
- Resumption trigger, for (b): IMP-111's measurement session, which runs these forms as control
  cases; or an agent seen running one of them at work, whichever comes first.
- Kin: IMP-111 (the same lens on the framework's reads), IMP-054 (a rule matches the text, not
  the program).

### IMP-124 — The docs' selective loading against `CLAUDE.md`'s imports
- Date: 2026-10-15 | Origin: the retro's agents (theme C) — [[2026-10-15-harvest-retro-3.0.0]]
- Observed problem: `docs/00`'s *Selective loading* says to load only the files the task
  needs, `CLAUDE.md` being the index. `CLAUDE.md` writes the seven docs and `STATE.md` as
  `@`-imports, which Claude Code expands and loads into the context at launch (its memory
  page, read in a saved copy, not measured): every session starts with all of them, about
  1,450 lines — the retro's own sessions carried all seven docs. The selective part holds for
  the memory's notes, not for the docs.
- Proposal: Level 1, in v3.0.0 (the user's decision) — `docs/00` describes what happens: the
  docs load at every launch through `CLAUDE.md`'s imports; selective loading applies to the
  memory's notes and to what the task reads besides. Level 2, OPEN: whether to stop importing
  the docs — pointers without `@`, read on demand —, weighing salience (IMP-117: a rule loaded
  and still missed) against the context every session pays.
- Expected benefit / risk: a doc that tells the truth about its own cost. Level 2's risk:
  rules read less often.
- Kin: IMP-117 (salience, not loading).

<!-- Format of a proposal:
### IMP-001 — <short title>
- Date: YYYY-MM-DD | Origin: [[<session note>]] — <problem>
- Observed problem: <recurring friction, repeated error, gap, ambiguous rule>
- Proposal: <what to change and where: CLAUDE.md / docs/NN / command / hook / process>
- Expected benefit / risk:
- Resumption trigger: <if it is not applicable now: which event brings it back into play>
- Destination: framework   (OPTIONAL — only in a client project and only if the lesson
                            must be sent upstream to the framework; a single physical
                            line, for the grep)
Once applied, the entry moves under "Applied" and is rewritten in its final form — what
was verified, the decisions, what stays uncovered —, its evidence condensed; the detail
stays in the session notes and the git history. Every applied entry cites the session
note its evidence comes from: [[<session note>]] — from the release that brought this
line on; older entries are not backfilled.
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
- Approved in the targeted retro after the first real upgrade (the client project, v0.2.0→v0.5.1,
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

### IMP-043 — Cross-file section titles in the coherence review → applied on 2026-07-21, commit ff7fbb6
- Date: 2026-07-21 | Origin: framework translation to English, v1.1.0 (IMP-041 series)
- Observed problem: in multi-file work the GLOSSARY covers terms but NOT the section
  titles that other files cite by name. A title renamed in file A while file B still
  points at the old wording produces a broken cross-reference that no term-level check
  catches — the single broken pointer of that deliverable (README → *"Evolving the
  framework"*, fixed in `e00efad`).
- **Applied in REDUCED form; the version first proposed was discarded.** The original
  proposal (fix the cited titles in a canonical MAP, as an artifact preceding the tasks
  in PHASE 2) was rejected on the facts: the map is a `grep` away — maintaining a file to
  replay a query is ceremony — and no new planning step was warranted. What went in is
  ~5 lines extending the coherence review that ALREADY existed in `01-task-planning.md`
  (*"Special case — cross-module refactor"*): section titles cited by name from other
  files are a shared contract exactly like a shared API, so if the work renames them you
  grep the old and the new wording before the merge.
- Why a check and not a warning: phase 1 had ALREADY flagged this exact risk and the
  defect passed anyway. The gap was never awareness — it was the absence of a mechanical
  verification. That is the sentence the doc now carries.
- Frequency and the anti-hype filter: ONE occurrence in 122 commits (the 2026-07-18
  public-doc alignment, the closest candidate, renamed no titles). Hence the deliberately
  CONDITIONAL placement — it fires only on work that renames cross-file titles, never as
  a step of every deliverable.

### IMP-044 — `model` and `turns` in the session-note frontmatter → applied on 2026-09-23, commit 184529e (+cdf862f)
- Date: 2026-09-22 | Origin: [[2026-09-23-memory-model-turns]] — no record of which
  model produced a note, and no objective proxy of the friction a task cost
- Observed problem: a memory note does not say which model produced it, so its
  reliability cannot be weighed after the fact; and the friction of the recorded work —
  the raw material of IMPs — is noticed only if someone happens to remember it.
- Proposal (assessment of 2026-09-22, adversarially verified; user decisions D1-D5 of
  2026-09-23): two OPTIONAL frontmatter fields, additive and backward compatible.
  - **Scope: `sessions/` notes only.** STATE/TREE/INDEX and `components/` are rewritten
    over time (the value would record the last editor and go stale); `decisions/`
    carry a human decision; `plans/` span many sessions; IMP entries are edited by
    later sessions, and `turns` means nothing for them.
  - **`model`**: a free value, never an enum (model names change); the id as the
    runtime exposes it to the agent, verbatim, ALWAYS single-quoted (verified with a
    real YAML parser: an unquoted id breaks a flow list or is coerced into a
    number/date/boolean; double quotes turn `\` into an escape). Several models on one
    note → one string, distinct ids in order of first use, `, `-separated (Obsidian
    types a property by name across the vault, so one shape only). Main session only;
    delegated work is mentioned in the body. Not exposed → omitted, never guessed.
  - **`turns` per NOTE, not per task (D1)**: the user's messages whose work THIS note
    records. A note is not a task (one note per session or day in client projects; a
    resumed deliverable got a new note even here), and a cumulative count across notes
    risks double counting: the value of a unit of work — a deliverable, grouped by
    `branch`; not a `docs/01` plan task — is the SUM of its notes, computed at analysis
    time, never recorded. A bare integer ≥ 1, counted by the agent from its own
    conversation — NOT from the runtime transcript, whose internal format makes the
    obvious heuristic wrong (tool results are `type:"user"` entries: dozens of them
    against a single real prompt in the assessment session). An approximate PROXY,
    declared in the format and not in the value: a lower bound after a compaction or a
    resumption, and still written. Rewrites within one session never recount a message
    (the value before the session's first write + the session's messages); a delegated
    writer records the main session's values, never its own.
  - **IMP format (D2)**: the Origin line becomes `Origin: [[<session note>]] — <problem>`
    — today only 2 of 43 entries cite the note that produced them, so the provenance of
    an IMP is NOT traceable. One line, real value from now on.
  - **`/checkpoint` carries the minimal format inline (D3)**: it is the command that
    WRITES the notes — updating only the template would be a dead improvement — and the
    only channel through which the two fields reach already-upgraded projects (see
    IMP-046; the D2 Origin line has no such channel).
  - **Deliberately NOT recorded** (user decision — so they are not re-proposed):
    `tokens` — it lives in the runtime's usage report, duplicating it is redundancy;
    `duration`/wall-clock — infrastructure time, not effort, an illusion of
    measurement; `files_touched` — git already knows it; `difficulty`/`complexity` —
    `turns` is already the objective proxy, a subjective field would be the invented
    version of the same datum.
- Expected benefit / risk: after-the-fact reliability of the notes, and the data the
  deferred threshold rule (IMP-045) needs before it can exist. Risk: a proxy read as a
  measure — declared in the format; no command consumes the fields yet.
- Versioning (D5): **MINOR → v1.2.0** via `feat(memory)`, on the contract criterion —
  `docs/04` lists "an optional field" as MINOR, `CONTRIBUTING.md` calls breaking only an
  INCOMPATIBLE memory format. A DECLARED deviation from two rules read literally:
  `integrate.md` step 2 (memory/doc-only commits → no tag) and the
  `chore(claude): apply IMP-nnn` type of `docs/06`. Precedents: v1.1.0 (a process-rule
  addition, IMP-040, typed `feat(process)` → MINOR) and `feat(memory)` in v0.4.0 (the
  destination attribute of the IMP format).

### IMP-047 — `/integrate`'s "doc-only → no tag" ignores the method-project contract → applied on 2026-10-10, commits cd6e820, 2c6700e
- Date: 2026-09-23 | Origin: [[2026-09-23-memory-model-turns]] — for a method framework
  the `.md` files ARE the product, yet `/integrate` maps "memory/doc-only commits" to
  "no tag"
- Observed problem: `integrate.md` step 2 lists "memory/doc-only commits" next to the
  no-tag types, while `docs/04` (*Versioning*) defines the contract of a method/tooling
  project as the method itself and lists "an optional field" as MINOR. For such a project
  a doc-only change CAN be a contract change, and the two rules then disagree. Recurring:
  v0.4.0 (all ten changed files `.md`, `feat` commits, released MINOR) and v1.2.0
  (IMP-044, where the deviation had to be DECLARED as such — D5).
- Proposal: NOT decided here (end-of-deliverable retro: recorded only). Direction to
  evaluate: qualify the clause of `integrate.md` — "doc-only" means documentation ABOUT
  the product, not a change to the product's contract when the product is a method (a
  pointer to `docs/04`) — so that the type of the commit, not its file extension, drives
  the bump.
- Expected benefit / risk: the next contract change of a method project is computed
  right by `/integrate` instead of relying on a declared deviation. Risk: a `feat` used
  loosely on real doc-only work would then cut a release — the type discipline of
  `docs/04` already guards it.
- **Decision 2026-10-10** ([[2026-10-10-upgrade-safety-1.3.3]], user decision 7): the criterion is
  "does it change the payload?". Yes: a release with a tag — in a method framework the
  documentation is the product. Only the framework's memory, or files outside the
  payload: no tag. So v1.4.1, the payload pruning, is a PATCH. Applied in v1.3.3 (task 9),
  which closes the contradiction between `integrate.md` and `docs/04`.
- Applied in v1.3.3 ([[2026-10-10-upgrade-safety-1.3.3]], task 9): `docs/04` (*Versioning*) adds
  "When the documentation IS the product" — a change to the shipped files is a release,
  at least a PATCH; a change confined to the project's own memory or to unshipped files is
  no tag; `integrate.md` step 2 points to it; `CONTRIBUTING.md` names what this framework
  ships. The shipped set includes `SETUP.md`'s procedures and v1.4.0's verification
  script, which setup does not copy — read literally, "files outside the payload: no tag"
  would leave them untagged, while an upgrade targets a tag and v1.4.0 was decided as a
  MINOR. **Confirmed by the user on 2026-10-10** ([[2026-10-10-integrate-two-blocks-1.3.4]]): "a release is
  what reaches the consumers" — the payload AND the files read at the tag during graft
  and upgrade (`SETUP.md`, the CHANGELOG, the verification script); the paragraph of
  `CONTRIBUTING.md` stays.

### IMP-050 (points 1-2) — The framework is read only by tag, via `git -C "${FW:?}"` → applied on 2026-09-25, commit 190404a
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — the upgrade read the
  framework from its shared working tree and, by bare tag names, from the project's own
  tags (points 1-2 of IMP-050; points 3-4 stay OPEN, see IMP-050 (points 3-4); point 5 is applied, see IMP-050 (point 5))
- Observed problem: (1) the Precondition asked for "two checkouts (or exports)" and the
  CHANGELOG read named no ref, so the upgrade read whatever the SHARED framework clone
  had checked out — during a real upgrade, a session working on the framework ran
  `git switch main` on that clone while the upgrade was reading it; (2) no command named
  the repo: a project with its own same-named tags answers a bare `git show vX:<path>` or
  `vY:<path>` with ITS file, exit 0 — a silently corrupted 3-way (base or theirs),
  IMP-036's class.
- Further evidence for (1), 2026-09-24: a subagent of the assessment of these very points
  detached the framework repo at `v1.2.0` and left an archive in its root, despite a
  written read-only constraint; while detached, the working tree lacked IMP-048..053
  ([[2026-09-25-imp-050-read-by-tag]]). A second live case of a process moving the HEAD
  of a shared clone — and a lesson of its own: a prompt constraint is not a boundary, a
  permission is (IMP-054).
- User decision (retro block 1, 2026-09-25, [[2026-09-25-imp-050-read-by-tag]]): the core
  only (D1 — the mechanised extensions go to the point-3 block); D2, the graft-time pin
  comment too; D3, a one-line optional bare-clone aside, `--mirror` excluded; PATCH
  v1.2.1 typed `fix(setup)`, the deviation declared in the commit body — from
  `docs/06`'s `chore(claude)` type and from `integrate.md`'s "doc-only → no tag" (the
  latter conflict is IMP-047, open).
- Applied in `SETUP.md`, *Upgrading the framework* (headings and step numbers
  unchanged): the Precondition rewritten in place — the false premise "the version tags
  live only in the framework repo" corrected; rule 1, the framework is read ONLY as
  immutable objects by tag (two refs per diff, no write in the framework, extraction by
  shell redirection into a scratch directory `T` outside both repos); rule 2,
  `-C "${FW:?}"` on every framework-side command and only there; `FW`/`T` set once per
  shell (an agent restates them and the `cd`), `${FW:?}` and `: "${FW:?}" &&` explained;
  a read-only check that exits 1 on a wrong cwd, on `FW` = the project (any worktree), a
  subdir or a non-repo, and on a missing `vY`; `fetch --tags` left to the human; the
  bare-clone aside; the mental model's box on hybrids (the 3-way base read at the tag
  `vX`). By-tag reads with `-C` in Step 0 (fallbacks 2-3), Step 2, Step 3
  (METHOD after the edge-7 pre-flight; the chained 3-way, never `<( … )`; the trivial
  hybrids; the LEARNINGS header), the Execution boundary box, Step 6 (the pin's `commit`
  with `^{commit}`), edge cases 1, 2, 6, 7 and the Outside-the-payload box. Graft step 1:
  the pin's `commit` resolved the same way (D2). Untouched on purpose: the Step 2
  pathspec (IMP-046), Step 4 (point 4), edge case 4 and the hooks (point 5).
- Verification: RED→GREEN in throwaway clones only — a hostile `FW` (detached at v0.1.0,
  dirty, a change staged) and a fixture project with its own annotated v1.0.0/v1.2.0;
  every framework-side command of the new text but the human's `fetch --tags` executed
  as written, in bash and zsh. Details in the session note.
- Expected benefit / risk: closes a silent wrong-version read that becomes CERTAIN as
  soon as a client's own tags overlap the framework's — the upgraded client's already do
  ([[2026-09-24-third-upgrade-lessons]], B4-B5; the original evidence of points 1-2:
  `git show 1c39166:.claude/memory/LEARNINGS.md`). Risk: a longer Precondition, and
  every framework-side read now uses `git -C`, the form IMP-054 is about.
- **The same two traps, re-harvested by the client** (annotation 2026-09-26,
  [[2026-09-26-client-harvest-registration]]) — NOT an independent confirmation: the
  client's lesson comes from the same third upgrade as B4 and B5, this entry's original
  evidence; count it once. The client, reading the framework only through v1.2.0,
  proposed exactly these two points: point 1, the framework's HEAD moved during the
  assessment (= B4, the same incident); point 2, its own same-named tag answers a bare
  `git show vY:<path>` with ITS file, exit 0 (= B5). Both are covered by v1.2.1
  (`SETUP.md`, Precondition, rules 1 and 2). Correction to its account of point 1: the
  switch did not change the checked-out commit (`main` was at `v1.2.0`'s commit then),
  HEAD moved with the next commit, and the working tree had already diverged through
  uncommitted edits — the damage in that instance was nil (only `LEARNINGS.md`
  differed, whose entries an upgrade never carries). Its extra sanity check (a blob
  compared with `rev-parse`) is not covered: input for IMP-050 (points 3-4). Kin:
  IMP-055 (delegated agents in a shared working tree).

### IMP-050 (point 5) — The hooks step from a linked worktree, and the rollback; with the v1.3.x migrations bound into the procedure → applied on 2026-10-10, commits 9cf7cb3, 331f390, a3a9836, 3ef8915, 2c6dd7f, 77dc84e, b511da2, 2c6700e
- Origin: IMP-050 (points 3-4), point 5; the phase-1 analysis of [[2026-10-10-upgrade-safety-1.3.3]] (the
  v1.3.x migrations lived in the CHANGELOG, not in the procedure). User decisions of
  2026-10-10.
- Applied (v1.3.3): `scripts/hooks-install.sh` resolves the hooks directory with
  `git rev-parse --path-format=absolute --git-common-dir` and stops outside a repository,
  below its top level, or without git — self-test case 3, RED then GREEN. Upgrade Step 4
  checks that every hook of the script's loop is installed with the generator's marker;
  Step 1 photographs the hooks and edge case 4 restores the photograph (the re-run of
  `vX`'s script, measured, does not). Beyond point 5, the migrations: Step 2 works
  through the *Upgrading* notes as a checklist (different topics add up, on the same
  topic the latest wins); the `Makefile` goes through the 3-way (the name-based half of
  point 3); edge case 8, a slot that moves to another file (point 4's new variant, by hand
  until v1.4.0's script detects it); edge case 3 (b) compares the title sets at every
  upgrade, the rename mandatory, and rule 9 separates the memory's content from its
  format (IMP-048's decision); the prerequisites (git 2.31; Node.js, two floors), the
  upgrade's write boundary, the coupling of `settings.json` and the guard's self-test.
- Verified: `make test-scripts` green after every task; each `SETUP.md` snippet extracted
  and run as written in throwaway repositories under `/tmp`; ONE reviewer, six MEDIUM
  fixed (task 10).

### IMP-054 — The `git push` deny does not catch `git -C <dir> push`: a decorative boundary → applied on 2026-10-07, commits 3ec5dc5, 70e8598, adea3fd, 256a7ba, e692d36
- Date: 2026-09-25 | Origin: [[2026-09-25-imp-050-read-by-tag]] — the deny list matched
  only the literal `git push …`, while v1.2.1 normalised `git -C "${FW:?}"`
- Verified ([[2026-09-27-imp-054-055-agent-git-boundary]], phase 1): on the real matcher
  (Claude Code 2.1.283, nested sessions, a local `file://` remote) `Bash(git push:*)`
  let 20 of 30 push forms through under a broad allow, 9 in this repo's own configuration
  (its personal `settings.local.json` allows `Bash(git *)`; auto mode allows pushes by
  default); wildcard denies still leaked 12 and denied `git stash push`. Claude Code's
  docs: a Bash rule "isn't a security boundary around the program".
- User decisions (2026-10-07): the THREAT MODEL — an agent's accidental errors with
  ordinary commands; deliberate evasion is for the OS or the forge's rules — written in
  `docs/04` and `SETUP.md`; D1 the `pre-push` IS the push boundary (the PreToolUse hook is
  reduced to IMP-055's job); D2 the deny unchanged, no wildcards, no longer presented as
  the boundary; D3 `gh` not covered (IMP-062, open); D6 `ask` on edits to the boundary's
  files; D7 the forge's rulesets (set by the user on 2026-10-07) as the server-side layer,
  the sandbox only as a documented option; D8 MINOR v1.3.0; D9 `AGENT_GIT_BOUNDARY=1`.
- Applied: `hooks-install.sh` generates a `pre-push` that refuses when `AGENT_GIT_BOUNDARY`
  (the new `env` key of `settings.json`) or `CLAUDECODE` is set, and runs a project's own
  `pre-push.local` after the check; `docs/04`, *Enforcement of the execution boundary*;
  `SETUP.md`, *Hardening*, setup step 3 and upgrade Steps 3-4; the `ask` rules;
  `test-hooks-install.sh` case 2.
- Verification: the self-tests fail on each of three `pre-push` regressions; end to end on
  the real payload, 30 push forms: v1.2.1 20 landed, this release 2 (`git send-pack`,
  `--no-verify` with hooks disabled — deliberate evasion, declared).
- Residual (declared in `docs/04`): deliberate evasion; a repository where
  `make hooks-install` never ran; remote writes without git (IMP-062).

### IMP-055 — Delegated agents that run git in a shared working tree: isolate them, snapshot before and after → applied on 2026-10-07, commits 6a3c691, b08a128, 70e8598, 256a7ba
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — a multi-agent
  security gate over a commit range left the repository on another branch
- Verified ([[2026-09-27-imp-054-055-agent-git-boundary]], phase 1): a subagent without a
  guard switched the shared tree's branch and pushed with `-C` (reproduced); the hook
  input carries `agent_id`/`agent_type` for subagents and workflow agents, not for the
  main session; a linked worktree shares refs, config and stash (from inside one an agent
  moved another branch, rewrote the shared config, stashed); the harness's isolated
  worktrees start from `origin/<default>`.
- User decisions (2026-10-07): D4 delegated agents read-only on git EVERYWHERE, their own
  worktree included; D1 the hook does that one job, recognising the subcommand after
  git's global options, fail-closed through `|| exit 2`, with NO analysis of `sh -c`,
  `eval`, scripts or interpreter code; D5 an essential snapshot (HEAD, branch, refs,
  stash, worktrees, untracked files). Deviation from the relayed proposal, as decided: no
  project-wide deny on checkout/switch/restore/archive (it would block the main session,
  and Claude Code has no per-agent Bash rule) — the per-agent hook instead.
- Applied: `scripts/agent-git-guard.mjs` (PreToolUse on Bash and Monitor),
  `scripts/repo-snapshot.sh`, `docs/04`, *Delegated agents and the shared working tree*,
  a pointer in `docs/03`, `.claude/worktrees/` in `.gitignore`; self-tests
  `test-agent-git-guard.sh` and `test-repo-snapshot.sh`.
- Code review (one reviewer, the security gate): 1 HIGH and 4 MEDIUM fixed; 1 MEDIUM
  accepted as designed — a missing guard file blocks the main session too (the decided
  fail-closed wiring), recovery and upgrade order documented, the agent-only variant left
  to the user. End to end: every delegated-agent write refused through Bash and Monitor,
  the main session free.
- **Refined in v1.3.1** (2026-10-07, [[2026-10-07-guard-agent-only-fail-closed]]): the user
  adopted the review's agent-only variant — a broken guard (crash, missing file or
  `node`, unparseable input) now blocks delegated agents only, never the main session;
  the guard's own verdict always stands. The upgrade order between the guard and
  `settings.json` no longer matters. Commits c65b22a, b8997aa.

### IMP-066 — `/integrate` verifies the tag's signature only when signing is configured → applied on 2026-10-10, commits ca47c4d, 8adb1a9
- Date: 2026-10-07 | Origin: [[2026-10-07-guard-agent-only-fail-closed]] — the framework's
  release tags are annotated but not signed, and GitHub shows them as Unverified (user
  observation)
- Priority: LOW (user decision, 2026-10-07).
- Observed problem: step 4 of `/integrate` checks that the tag exists and is sound
  (`git rev-parse`), never its signature; `docs/04` requires annotated tags and says
  nothing about signing, so a project that signs its releases gets no check, and one that
  does not cannot tell "unsigned" from "badly signed".
- Proposal: NOT decided here (retro). Direction: in `/integrate`, step 3 creates the tag
  with `-s` and step 4 adds `git tag -v <tag>` ONLY when the setup configured signing;
  signing stays optional (agnosticism). How the setup declares it — a
  `[TO BE DEFINED AT SETUP]` slot, or git's own `tag.gpgSign` — is part of the decision
  (a new slot carries IMP-050 point 4's upgrade cost).
- Expected benefit / risk: verifiable releases where a project wants them. Risk: a check
  that fails on machines without the signing key — it must run on the releasing machine.
- Applied in v1.3.4 ([[2026-10-10-integrate-two-blocks-1.3.4]]), covered by IMP-069's two blocks, as the user
  decided. The choice the entry left open: git's own `tag.gpgSign` (the repository's
  config or the global one, read with `git config --type=bool --get`), NO new setup
  slot. `git tag -a` stays as it is — with `tag.gpgSign` true it signs by itself — and
  block 1 adds `git tag -v <tag> && echo "signature: OK"`: the marker rests on the exit
  code, whatever language gpg answers in. Signing stays optional: a project that does
  not sign sees no check. `docs/04` (*Tag and push hygiene*) carries the rule.

### IMP-069 — The `/integrate` block is copied whole: the pause before the push does not happen → applied on 2026-10-10, commits ca47c4d, 8adb1a9
- Date: 2026-10-10 | Origin: [[2026-10-10-integrate-two-blocks-1.3.4]] — the user's report on the integration
  of v1.3.2 and v1.3.3
- Status: APPROVED on 2026-10-10 (the user's proposal, below) and applied in v1.3.4,
  together with IMP-066.
- Observed problem: in v1.3.2 and in v1.3.3 the user pasted steps 1-5 of the block in one
  go: the checks of step 4 were printed AFTER the push had already started, and
  `git tag -v` was not run at all. The block asked to "verify BEFORE the push" in a
  comment. A pause written as a comment inside a copyable block is not a pause.
- Proposal: `/integrate` prints TWO separate blocks. Block 1: rebase, merge, tag, and the
  checks — `git rev-parse` of the tag, `git log origin/<integration>..<integration>` with
  the expected number of lines and, ONLY when tag signing is configured in the repository
  or in the global config (`git config --get tag.gpgSign`), `git tag -v <tag>`. Block 2:
  the push and the branch deletion, preceded by one line OUTSIDE the blocks — "copy only
  after checking block 1's output: N lines expected, a valid signature". The procedure of
  `docs/04` is aligned.
- Expected benefit / risk: nothing is published before its checks have been read; a
  signed tag is verified where tags are signed, and a project that does not sign sees no
  check. Risk: one paste more.
- Applied (v1.3.4): `/integrate` prints block 1 (local: rebase, merge, tag, then the
  checks) and block 2 (the publication), with one line between them naming what block 1
  must have printed; `docs/04` rule 4 of *Execution boundary and blocks for the user*.
  The review (one reviewer) added what pasting whole requires: block 1's constructive
  lines are one `&&` chain (the loose lines tagged the wrong commit after a rebase
  conflict — reproduced); each check prints a fixed line (`tag on <integration>: OK`,
  `count: OK (N)`, `signature: OK`); no comment line inside a block (a `#` at a zsh
  prompt with default options is a command — the user's own zsh has
  `interactivecomments` off); block 2 is one `git push --atomic` of the branch and the
  tag, then `git branch -d`.

### IMP-037 (option b) — A read-only upgrade verification script → applied on 2026-10-10, commits b40b76a, 11381b5, 75e7fb4, d32ef1a, b057262, 37fbc22, 5648df0, 4e5e50c
- Date: 2026-10-10 | Origin: [[2026-10-10-upgrade-safety-1.3.3]] — the decision on IMP-037 after its
  count trigger fired (three real upgrades); the history is under *Deferred*, IMP-037
  (option a)
- Status: **APPROVED on 2026-10-10**, applied in v1.4.0: a READ-ONLY upgrade verification
  script; `SETUP.md` stays the procedure and calls it. It reads the framework by tag with
  `git -C "${FW:?}"` — the "no cross-repo git" boundary of option (a) was about writes and
  `FW`'s working tree, not about reads by tag (the v1.2.1 rule, IMP-050 points 1-2). It
  lives OUTSIDE the payload, is never copied into a project, and runs in its version AT
  the tag `vY`, never from the framework's working tree. The "No automation, for now" box
  of `SETUP.md` is updated with it (Level 2, approved).
- Why (b) and not (a): across the three upgrades the judgement differed every time and
  the mechanics did not; a command would shadow a procedure that changed in 7 of 11
  releases, and could not be tested. The script holds the mechanics: preflight (the pin —
  an explicit error, never a silent normalisation, IMP-050), the per-file inventory and
  measurement, the marker and §2-checklist delta between the tags, the memory invariant
  (IMP-046), the post-checks.
- Applied in v1.4.0 ([[2026-10-10-upgrade-verification-1.4.0]]): `tools/upgrade-check.sh` with `classes`,
  `preflight`, `inventory`, `invariant`, `post`, outside the payload, run at the tag
  `vY`; its self-test (`bash tools/test-upgrade-check.sh`) fails when a payload file has
  no class; tried read-only on the client project's three real upgrades, where it
  reproduced the hand measurements and raised false alarms that were fixed; the
  "No automation" box of `SETUP.md` rewritten. Option (a) stays under *Deferred*.

### IMP-046 — The upgrade procedure contradicts itself on `.claude/memory/` → applied on 2026-10-10, commits d32ef1a, 37fbc22, 5648df0, 4e5e50c
- Date: 2026-09-22 | Origin: [[2026-09-23-memory-model-turns]] — the upgrade demands an
  empty diff on `.claude/memory/` yet classifies its guide READMEs as METHOD (a side
  finding of the IMP-044 assessment)
- Observed problem: `SETUP.md` (*Upgrading the framework*) classifies "the guide READMEs
  inside `.claude/memory/*/`" as METHOD (brought to `vY`) and `LEARNINGS.md` as HYBRID
  ("at most the header/format is updated"), while Steps 3 and 5 demand an EMPTY
  `git diff` on `.claude/memory/` ("a non-empty diff = a bug in the upgrade") and edge
  case 3 calls the pointer repair "the only exception". Step 2's diff also excludes
  `.claude/memory` on purpose, so a change to a guide README never shows up in the
  exact-text source of the upgrade. Two rules of the same procedure cannot both hold.
- Evidence — the two real upgrades of the same client project (2026-07-17,
  v0.2.0→v0.5.1; 2026-07-19, v0.5.1→v1.0.0): both treated the whole of `.claude/memory/`
  as project memory — the first with an ad-hoc second exception (the LEARNINGS header),
  the second with an empty diff. That project's `sessions/README.md` is still
  byte-identical to v0.2.0 while its provenance pin says 1.0.0: the README changes of
  v0.5.1 (IMP-034, `da0e158`) never arrived. The contradiction is live since v0.5.0,
  the release that introduced the procedure and its invariant (`8eb3107`); the first
  template change it strands is older — the LEARNINGS format of v0.4.0 (`d2856be`). It
  is not an effect of IMP-044.
- Why it matters now: IMP-044 changes two templates under `.claude/memory/`, and an
  upgraded project will receive neither: `sessions/README.md` (the `/checkpoint` clause
  of IMP-044 carries the minimal format of the two fields for this very reason — a
  MITIGATION, not the fix) and the Origin line of the LEARNINGS format comment (D2),
  which has NO mitigation: `/retro` does not carry the IMP format.
- Proposal: NOT decided here — a contradiction in the method is a BUG, to be resolved at
  a dedicated retro (user decision 2026-09-23). Direction to evaluate: scope the
  invariant to the PROJECT-MEMORY files (notes, STATE/TREE/INDEX, the IMP entries),
  NAMING the guide READMEs and the LEARNINGS header and format comment as declared,
  expected hunks — and bring them into Step 2's diff.
- Expected benefit / risk: the method's own changes to the memory templates reach
  upgraded projects, while the invariant keeps catching accidental edits to the real
  memory. Risk: a looser invariant that lets an accidental edit through — the fix must
  name the allowed files, never relax to "some diff is fine".
- **Evidence from the third upgrade** (annotation 2026-09-24,
  [[2026-09-24-third-upgrade-lessons]]): the format guides live under `memory/` but are
  not memory. The client's `sessions/README.md` is the template blob of v0.2.0-v0.5.0
  (after v0.2.0 the file first changed at v0.5.1), so the relayed "stayed at v0.5.0
  across two upgrades" and "byte-identical to v0.2.0" above are the same fact; no commit
  on the client's main has touched a guide README since the graft. NEW:
  `decisions/README.md` carries a setup slot (where
  formal ADRs live), which the client answered — so that README is a HYBRID, while
  `SETUP.md` files it at once as METHOD ("the guide READMEs", brought to `vY`) and,
  through `decisions/`, as PROJECT-MEMORY (untouched). A plain overwrite re-opens the
  answered slot; the 3-way surfaces exactly that hunk. Consequence for the direction
  above: the guide READMEs are not ONE class — a "format guides" class overwritten
  wholesale, or guides moved out of `memory/` (the two options raised), must still
  3-way `decisions/README.md`. The third upgrade's branch (not yet merged) brings all
  four guides to v1.2.0 as a declared exception citing this IMP — `sessions/README.md`
  minus the framework-repo Plan block and IMP number, the ADR answer kept: the third
  time the contradiction had to be worked around.
- **Annotation 2026-10-10** ([[2026-10-09-quick-fixes-1.3.2]]): edge case 3 of `SETUP.md`
  is no longer "the only exception" but two DECLARED exceptions for the project's memory
  lines — (a) the pointers to renamed docs, (b) the `## ` section titles of `STATE.md`
  and `LEARNINGS.md` that the method reads by name (v1.3.2, for the titles v1.1.0
  translated) — and it now points here for the method's own files under `memory/`. The
  contradiction this entry records is unchanged; (b) follows its direction of named,
  declared exceptions.
- **Evidence from a client harvest — the verification half** (annotation 2026-09-26,
  [[2026-09-26-client-harvest-registration]]): once the invariant allows named files
  and parts (the third upgrade's declared exception), a plain `git diff` cannot prove
  it — a legitimate format update and an edited IMP entry touch the same file list; the
  invariant has to be CONTENT-based. And content, not the "declared, expected hunks" of
  the direction above: the framework's `LEARNINGS.md` is live, so its tag diff is
  mostly its own entries (v1.1.0→v1.2.0: 5 hunks, +169/−4, the format change one of
  them), and the format comment's position depends on each project's body — the hunks
  cannot be derived from the framework. The client built the checks as a script:
  (1) an allowed-path diff; (2) a `LEARNINGS.md` body normaliser (from the first `## `
  to the end, minus the format comment) — generically it must strip exactly `vX`'s
  format comment(s), read by tag (two at v1.0.0, one from v1.1.0), and compare the
  header and format with `vY`'s by content, or an edit inside the format comment
  passes; (3) the guide READMEs compared with their expected content, not by hunk
  headers — this overlaps the blob-id check recorded as input of IMP-050 (points 3-4),
  `decisions/README.md` being the hybrid exception (the third upgrade's annotation above —
  B7 of [[2026-09-24-third-upgrade-lessons]]); (4) no backfill of the
  IMP-044 fields (`sessions/README.md`, *Absent = not recorded*); (5) the scope of the
  checkpoint commits. Run on a clone, one positive and eight negative branches: all
  caught (client-side, relayed). Relayed proposal: ship them as
  `scripts/verify-memory-invariant.sh` or a Step 5 recipe, template paths only — to be
  weighed against `SETUP.md`'s "No automation, for now", IMP-037 (trigger fired on the
  count) and IMP-049 (d) (a check hosted in the payload ships to clients).
- **Decision 2026-10-10** ([[2026-10-10-upgrade-safety-1.3.3]]): in v1.4.0, the direction proposed in
  phase 1, accepted with the release split. A named set of MEMORY TEMPLATES — the guide
  READMEs of `components/`, `plans/`, `sessions/` and `decisions/`, the `LEARNINGS.md`
  lines before the first `## ` and its format comment — reconciled 3-way with base `vX`;
  PROJECT-MEMORY becomes `decisions/*.md` except the README; the invariant becomes a
  CLOSED list of allowed touches (the templates, edge case 3's lines, the upgrade's own
  plan file; the session note, `STATE.md` and `TREE.md` only in the checkpoint commit),
  checked by content. `STATE.md`, `TREE.md` and `INDEX.md` are NOT memory templates (user
  decision 4): in a project they are compiled memory, never reconciled 3-way, and a change
  to their format arrives only as a declared migration. Measured in phase 1 with a real
  `git merge-file`: the client's `decisions/README.md` gives 1 conflict when `vY` edits
  the slot line and none for an edit elsewhere; `sessions/README.md` pruned by `vY` as the
  client pruned it merges clean. The client's invariant script was never committed: the
  checks are rebuilt from their description, with the number of format comments read from
  `vY` (an entry hidden inside an injected format comment passes otherwise).
- Applied in v1.4.0 ([[2026-10-10-upgrade-verification-1.4.0]]): the MEMORY TEMPLATES class (the four guide
  READMEs, the header and the format comment of `LEARNINGS.md`), reconciled 3-way with
  recipes for the header and the comment; `STATE.md`, `TREE.md` and `INDEX.md` compiled
  memory, never 3-way (user decision 4); the invariant a closed list checked by content
  by `upgrade-check.sh invariant`, at Step 5, before the checkpoint — the templates, the
  pointer repairs and the renamed titles and labels, the upgrade's own note, plan and
  decision records; the LEARNINGS entries compared with titles and labels normalised and
  the format comments counted against `vY`'s. The client's lost V1-V7 script is rebuilt
  on generic rules, with its negative branches in the self-test.

### IMP-050 (points 3-4) — Upgrade procedure hardening: a strategy per file from measurement, the slots that change → applied on 2026-10-10, commits 75e7fb4, 5648df0, 4e5e50c
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — the read-only
  assessment of the third real upgrade (v1.0.0 → v1.2.0, across the full translation of
  v1.1.0) found five traps that *Upgrading the framework* does not guard against
  (points 4-5 were then avoided rather than hit)
- Status: points 1-2 APPLIED on 2026-09-25, commit 190404a — see *Applied*, IMP-050
  (points 1-2). Point 5 APPLIED on 2026-10-10 in v1.3.3 — see *Applied*, IMP-050
  (point 5). Points 3-4 below stay OPEN, for v1.4.0, numbered as before (IMP-037's
  case-#3 annotation cites them by number); the heading said "points 3-5" until then.
- Observed problem (each verified on the source):
  1. → APPLIED (see *Applied*, IMP-050 (points 1-2)).
  2. → APPLIED (same entry).
  3. A STRATEGY PER FILE, DRIVEN BY MEASUREMENT. Step 3 picks the strategy by class,
     plus a fixed split by file name (additive union for `.gitignore`/`Makefile`,
     header/format only for `LEARNINGS.md`); every other hybrid goes through the 3-way
     with base = `vX`, and nothing measures churn. v1.0.0 → v1.2.0 changes 31 payload
     files (+1801/−1701; 24 of them in Step 2's scope): on the translated hybrids the
     3-way degenerates into near-whole-file conflicts (`CLAUDE.md`: 161 of 197 output
     lines inside conflict markers), while where the framework change does not overlap
     the project's edits it stays surgical (`settings.json`, `reset-task.sh`,
     `hooks-install.sh` — the last two with 40-50% framework churn too). Churn alone
     does not predict the conflict mass; its overlap with the project's divergence
     does — so both are measured. The upgrade worked around it with a per-file churn
     table, a per-file strategy (3-way vs rebuild from `vY` + re-applied inventory) and
     an inventory of the project's customisations built by diff against the baseline.
     What `SETUP.md` has is a proto-inventory by category (the answers to re-apply in
     Step 3, checked in Step 5): not mechanical, and blind to free-form edits. Not
     "drop the 3-way": keep it where it stays surgical.
  4. A CHANGED SLOT WITHOUT ITS OWN MARKER NEVER RE-MATERIALISES. Step 3 promises that a
     marker added by `vY` re-materialises, and Step 4 greps for it. But the bullets of
     the example list in `CLAUDE.md`'s technical rules carry no marker — only the section
     heading does — and Step 3 re-applies the project's whole section. So the one slot
     that changed between v1.0.0 and v1.2.0 ("Lingua/e del progetto" → "Interaction
     language", v1.1.0) cannot come back, and in `CLAUDE.md` the grep returns only the
     two rule-9 prose lines that name the marker — one of which points at the slot, but
     only as prose. The CHANGELOG names the change (1.1.0) and Step 2 already reads the
     CHANGELOG as its index: the missing link is from that index (or from the diff of
     the `SETUP.md` §2 checklist) to Step 4's audit. One instance so far (a re-scoped
     slot, not a new marker) — the defect is structural.
  5. THE HOOKS STEP FROM A LINKED WORKTREE, AND THE ROLLBACK. `hooks-install.sh`
     hard-codes `HOOKS_DIR="${REPO_ROOT}/.git/hooks"`; in a linked worktree `.git` is a
     file and `make hooks-install` aborts with a raw `mkdir: … Not a directory`. The
     natural workarounds give a FALSE GREEN: the main worktree's script prints OK but
     installs the version checked out THERE (the old one), and Step 4's functional proof
     passes anyway — the executable lines of the generated hooks are identical from
     v1.0.0 to v1.2.0, so the proof cannot tell old hooks from new. `SETUP.md` never
     mentions worktrees, while `docs/00` recommends "a separate branch (or worktree)".
     Rollback: a pre-v1.1.0 script knows only the Italian marker and refuses a hook that
     carries the English one (the IMP-041 compatibility is one-way); edge case 4 says
     "re-run `make hooks-install` from `vX`" without saying it fails. Ways out: remove
     the two hooks by hand (keeps the pre-upgrade `.bak`), or `FORCE_OVERWRITE=1` —
     which overwrites that `.bak` with the new hook, losing the pre-upgrade backup.
     Reproduced in a throwaway repo with the real scripts.
- Proposal: NOT decided here (retro). Directions to evaluate: (1)+(2) applied; (3) Step
  3 opens with a per-file churn measurement (framework side and project side) and picks
  the strategy per file, the mechanical inventory being the input of a rebuild — its
  items carry IMP-048's three levels, which the upgrade used as-is; (4) a slot
  checklist derived from the CHANGELOG / the §2 checklist diff and linked into Step 4,
  or a marker on each bullet of the technical-rules list; (5) resolve the hooks
  directory with `git rev-parse --git-path hooks`, state the main-worktree constraint in
  Steps 1/4, and in edge case 4 the rollback caveat (manual removal preferred to
  `FORCE_OVERWRITE=1`).
- Input for this block from the application of points 1-2
  ([[2026-09-25-imp-050-read-by-tag]]). Moved here by the user (D1): a mechanised `vX`
  estimate in Step 0 (blob ids read by tag), a blob-id check in Step 5 that the METHOD
  files are `vY`'s, an anti-orphan command in edge case 1. Found by the pre-commit
  review, outside the 1-2 perimeter: graft step 1 still copies the payload from whatever
  the framework clone has checked out while the pin records a tag — point 1's trap at
  graft time (`ff7fbb6` put METHOD changes on `main` between v1.1.0 and v1.2.0); a
  pin-identity check (`FW`'s `vX^{commit}` = the pin's `commit`, which would also catch
  a moved tag — pins rewritten at Step 6 before v1.2.1, which named no command, may
  hold the tag object's id); and which copy
  of `SETUP.md` governs an upgrade (a project's reference copy is `vX`'s, without the
  newer rules).
- Expected benefit / risk: the next upgrade does not rediscover these traps by trial.
  Risk: a longer procedure; the mechanical part is what IMP-037's command would absorb
  (see its case-#3 annotation).
- **Evidence from a client harvest** (annotation 2026-09-26,
  [[2026-09-26-client-harvest-registration]]) — four of its lessons land here, verified
  on v1.2.1 and by experiment in throwaway repositories. They come from the same third
  upgrade as B9 and B10 of [[2026-09-24-third-upgrade-lessons]]: re-harvested, not new
  occurrences — what follows is what they ADD.
  - **Point 4 — the producer side, and the sentinel.** The slot is confirmed (re-scoped
    at v1.1.0, not added; its marker is lost when Step 3 re-applies the project's whole
    section). New: every release that adds or changes a slot lists it under a fixed
    field of its CHANGELOG entry ("New slots to fill on upgrade"), which Step 4 reads
    for the entries between `vX` and `vY` — the direction above has only the consumer
    side; releases already cut are not covered. And the check-10 sentinel of
    `/lint-memory` (`TO BE DEFINED AT$|DA DEFINIRE AL$`, `lint-memory.md`:47, Applied
    IMP-031) catches only a break right before `SETUP`: against every wrap position it
    misses the inner breaks (`DEFINED⏎AT`, `BE⏎DEFINED`, `TO⏎BE`, `DEFINIRE⏎AL`,
    `DA⏎DEFINIRE`) and any break after a trailing blank — 3 of 16 variants caught, 4
    where the grep matches before a CR. A tested widening (16/16 broken caught, 0/2
    intact, no hit on the v1.2.1 tree):
    `\[(TO|TO BE|TO BE DEFINED|TO BE DEFINED AT)[[:space:]]*$|\[(DA|DA DEFINIRE|DA DEFINIRE AL)[[:space:]]*$`
    — dual form kept (IMP-048, level 3), the false-positive declaration kept (its
    category, prose that discusses the marker, recurs). Its fix sites lie outside the
    upgrade: `lint-memory.md` and the §2 Convention box of `SETUP.md`, which promises
    a sentinel that "flags broken slots".
  - **Point 5 — the hooks directory: both one-liners are wrong as written.** The
    direction above (`git rev-parse --git-path hooks`) has no anchor: it resolves the
    repository of the CALLER's cwd, so `make test-scripts` installs into the calling
    repository and fails. The client's anchored `git -C "$REPO_ROOT" rev-parse
    --git-path hooks` returns a RELATIVE `.git/hooks` in a main worktree, and the script
    never `cd`s: run from a subdirectory, it prints OK and writes a stray
    `<cwd>/.git/hooks`. What passes the self-test, a linked worktree and a
    subdirectory:
    `HOOKS_DIR="$(git -C "${REPO_ROOT}" rev-parse --path-format=absolute --git-common-dir)/hooks"`
    — `--git-common-dir` rather than `--git-path hooks`, which follows `core.hooksPath`
    (safe today only because the script's guard runs first); the idiom of `SETUP.md`'s
    own check; git 2.31 or later. The self-test needs a case run from a cwd other than
    the repository root. Bonus: outside a repository
    the v1.2.1 script prints OK and creates a stray `<dir>/.git/hooks` (it never checks
    it is in one); the `rev-parse` line aborts instead. Span: hard-coded in every tag
    from v0.1.0 to v1.2.1. Stale since v1.2.1: "`SETUP.md` never mentions worktrees"
    (three mentions now, all framework-side) — and its Precondition check PASSES from a
    linked worktree of the project, whose Step 4 then aborts. A git property for edge
    case 4 (b): the hooks directory is shared by all worktrees, so `vY`'s hooks reach
    every worktree whichever one runs Step 4.
  - **Point 5 — the rollback.** A third way out: move the two `.bak` back over the
    hooks — the pre-upgrade hooks come back byte for byte, with no script run — but
    ONLY if THIS Step 4 printed the WARNING pair: a `.bak` left by an earlier upgrade
    survives an upgrade that does not change the hooks, and a blind restore installs
    hooks older than `vX` (reproduced); the manual removal above is immune. Across the
    marker switch the `vY` run warns for BOTH hooks even when the project changed
    nothing, while Step 4 mentions only "a `.bak` of the project's formatting block"
    (`commit-msg` has none). `FORCE_OVERWRITE=1` is lossless when the customisation
    lives in the SCRIPT and loses it when it lives in the HOOK, a place the framework
    also sanctions — so the client's "harmless: the originals are regenerable" holds
    only for the former. Scope correction to "a pre-v1.1.0 script … refuses": only a
    `vX` from v0.3.0 to v1.0.0 refuses (rc 1, at the first hook); v0.1.0 and v0.2.0
    have no guard and overwrite without a `.bak`. Client-side, relayed: its notes of
    two earlier upgrades prescribe the failing rollback command.
  - **Input for point 3 — the harvested "read by tag" lesson's sanity check** (the rest
    of that lesson is covered, see *Applied*, IMP-050 (points 1-2)): `git -C
    <framework> rev-parse vY:<file>` against a known blob is NOT in v1.2.1. The
    Precondition check prints "FW OK" for a separate clone of the project or for an
    unrelated repository with a same-named `vY` (reproduced), and `SETUP.md` does not
    state that limit — only [[2026-09-25-imp-050-read-by-tag]] does. For the
    pin-identity input above: one file's blob is a weak key (`CLAUDE.md` has the same
    blob at v1.2.0 and v1.2.1) — compare a commit or tree id; the method holds no
    trusted `vY` commit (the pin records `vX`, the tags are unsigned), but the first
    released heading of `vY:CHANGELOG.md`, which Step 2 already reads, is a free
    self-consistency anchor — of four checks measured, the only one that catches a `vY`
    re-created on an earlier commit (it misses a tag moved later and a crafted
    repository); and pin-identity closes the declared limit only when the pin records
    the framework's real `vX` commit — never for `commit: n/a` pins or pre-pin grafts.
- **Decision 2026-10-10** ([[2026-10-10-upgrade-safety-1.3.3]]): point 5 in v1.3.3 —
  `--path-format=absolute --git-common-dir`, with a self-test from a linked worktree, a
  subdirectory and outside a repository; Step 4 checks that every generated hook is
  installed; Step 1 photographs the hooks and edge case 4 restores the photograph. Points
  3-4 in v1.4.0, through IMP-037's script: the per-file triage and measurement, the marker
  delta and the §2 checklist diff between the tags. NO hand-written "Slots changed" field
  in the CHANGELOG (user decision 3): it can diverge from the text, the class of C11/C12;
  the script flags a slot that changes file, and moving its answer is a migration for the
  *Upgrading* note. Also in v1.3.3, because a project's next hop would hit it: the
  `Makefile` goes through the 3-way (an additive union runs `reset-task` twice), and a new
  edge case covers a slot that moves. The pin (input above): an explicit error with the
  correcting instruction, no silent normalisation; a tag on the pinned commit may be
  SUGGESTED, never applied (user decision 6).
- Applied in v1.4.0 ([[2026-10-10-upgrade-verification-1.4.0]]): point 3 — Step 3 picks the strategy per file from
  `inventory`'s measure (the 3-way's conflicts, git merge-file -p), a rebuild from `vY`
  where most of a file conflicts; point 4 — the slots added, removed or moved and the §2
  checklist's changes derived from the tags, with no hand-written field (user decision 3).
  The pin's format checked, an explicit error, a tag only suggested (decision 6).

### IMP-049 — Payload purity: method files that only make sense in the framework repo → applied on 2026-10-11, commits b2248cf, a1779d5, 33f7263, 18873cf, 1c6093d, 603fa6b, 38daa59
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — the third real upgrade
  of a client project pruned by hand, once more, text that points at the framework repo
- Observed problem (condensed): the files a project receives carried three couplings to
  the framework repository — pointers to files a project does not have, numbers of the
  framework's IMP backlog (orphans there, or collisions with the project's own numbers),
  and blocks that hold only in the framework repository — and every upgrade brought them
  back where the project had pruned them; nothing caught a new one when it was written.
  Measured at v1.4.0: 23 IMP numbers on 22 lines in 9 files, 14 pointer lines in 9 files,
  6 framework-only blocks ([[2026-10-11-payload-purity-1.4.1]], assessment).
- Decisions ([[2026-10-10-upgrade-safety-1.3.3]], user decision 5; the v1.4.1 brief of
  2026-10-11): (a) no framework IMP number in the payload's text, the scripts' headers
  included — the why in prose; (b) the pointers rewritten — a local assumption rephrased,
  a cross-repo pointer labelled "the framework's"; (c) the framework-only blocks moved to
  `CONTRIBUTING.md`, one conditional line left in `docs/01`; (d) a mechanical check
  outside the payload, with a bidirectional allow-list, that checks the documentation too
  and hosts IMP-068 — run by `make test-scripts`.
- Applied in v1.4.1 ([[2026-10-11-payload-purity-1.4.1]]): the hybrid-regime box and the
  resumption patch of `docs/01`, the plan block of `sessions/README.md`, the closing box
  of `docs/06`, the moot clause of `/harvest-framework` and two sentences of this header
  live in `CONTRIBUTING.md`; `docs/01` keeps one conditional line at its top; the
  method/tooling bullet of `docs/04` is agnostic. The 19 numbers left after the move are
  gone, the self-tests printing descriptive labels; of the 14 pointers, 2 left with the
  moved blocks and 12 are rephrased or labelled, the SessionStart message included.
  `tools/docs-check.mjs` (Node.js) and its self-test run in `make test-scripts` behind a
  presence guard, a no-op in a project; it fails an IMP number in the payload — the
  format example `IMP-001` its one declared exception — and a pointer out of it, whether a
  name, a link, a cited path, an @-import or a wikilink, unless labelled or conditional
  (the links and paths after the single reviewer's HIGH).
- Verified ([[2026-10-11-payload-purity-1.4.1]]): the self-test plants each defect on a
  throwaway clone of the repository and sees it fail with its own line; the repository
  passes, above a floor per family, under a hostile git configuration and with CRLF line
  ends. By mutation, each disabled in turn, the 75 places where the check reports and 29
  detection and exemption paths that share one — a pointer's forms, a version's, a
  title's, an accent, a trailer, a pending entry's date — each make the self-test fail.
  One reviewer, two passes: the second found eight of those paths unplanted and two
  regressions of the first fixes, all planted since. An upgrade from 1.4.0 rehearsed in a
  throwaway clone: every 3-way clean, `invariant` 0 FAIL. The guarded line of the
  `Makefile` exits 0 where `tools/` is absent.
- Uncovered: a pointer phrased without a file name or a section the rules know ("the
  setup guide") passes; a label is accepted within its sentence, never checked for
  meaning; a project that customised a moved block, rather than pruning it, meets a 3-way
  conflict at its upgrade (the *Upgrading* note of 1.4.1 says so).

### IMP-068 — A list that declares itself complete deserves a mechanical check → applied on 2026-10-11, commits b2248cf, 66f3e50, 38daa59
- Date: 2026-10-10 | Origin: [[2026-10-09-quick-fixes-1.3.2]] (its retro) — recorded in
  [[2026-10-10-upgrade-safety-1.3.3]]
- Observed problem (condensed): `SETUP.md` §2, "the complete list" of the setup slots,
  missed six of them over the releases, each found by reading, never by a check; the same
  shape recurs wherever a text enumerates a set that lives elsewhere — the class lists,
  the hooks a check names, a count written in prose.
- Decision (the v1.4.1 brief of 2026-10-11): the mechanical documentation check of
  IMP-049 (d) hosts it; what it finds is fixed in the same release.
- Applied in v1.4.1 ([[2026-10-11-payload-purity-1.4.1]]): 41 lists measured, 8 out of
  step. The check holds each one against its source, both ways: §2 against the payload's
  markers, with a tripwire on a slot added since the latest tag while its §2 item stayed
  unchanged (replayed on the tags, the two together catch all six historical gaps); the
  class table against the payload of every tag, and the class bullets of `SETUP.md`
  against it; the copy lists of the payload; the inventories (commands, process targets,
  self-tests, the script and tool tables, the README tree); the counts in prose; the
  upgrade check's subcommands; the sections of the backlog; the commit types; the tables
  of titles and labels. A slot in a short form, or wrapped inside its brackets, fails
  too. Fixed: the slot of `new-component.md` invisible since v0.1.0, the unmarked
  placeholders of `checkpoint.md`, step 1 silent on `tools/`, "Its subcommands:" without
  `classes`, the brownfield row without `test-scripts`, the backlog's sections without
  Rejected, the hooks self-test's hard-coded loop.
- Verified ([[2026-10-11-payload-purity-1.4.1]]): each list comparison of the check,
  disabled in turn, fails the self-test, the guards that fail when an extraction finds
  nothing included; replayed on the tags, §2's comparison and its tripwire together catch
  the six historical gaps; the upgrade from 1.4.0, rehearsed in a throwaway clone, flags
  the two new slots, of `checkpoint.md` and `new-component.md`, which §2 names.
- Uncovered: a list with no structure a program can extract is out of reach — such a
  list stops claiming completeness ("the FOURTH species" and "three real upgrades" were
  reworded); the tripwire sees how many markers a file has, not which slot is new.

### IMP-070 — Multi-platform support: macOS, Linux, Windows → applied on 2026-10-13, commits da54b98, 77525a0, 6212081, 3b0edca, c3190c2, 5f05004, c99525a (point 7; points 1 to 6 in v1.5.0)
- Date: 2026-10-10 | Origin: the user's requirement of 2026-10-10, recorded in
  [[2026-10-10-integrate-two-blocks-1.3.4]] and [[2026-10-10-upgrade-verification-1.4.0]]
  — the framework was tested on macOS only
- Observed problem (condensed): every script and self-test had run on macOS only, the
  prerequisites named one platform's package manager, and on Windows the PowerShell tool
  escaped the delegated agents' guard.
- Decision (the user, 2026-10-10 and 2026-10-11 — [[2026-10-11-multiplatform-1.5.0]]): a
  POSIX environment on Windows too, through Git for Windows, no twin scripts; a rewrite in
  Node.js weighed only past the plan B threshold — the Windows job over 30 minutes, steadily,
  for 3 consecutive runs; the `Makefile` stays (point 8); the PowerShell tool off, and read
  by the guard (point 4).
- Applied in v1.5.0 ([[2026-10-11-multiplatform-1.5.0]]): points 1 to 6 — the CI on macOS,
  Ubuntu and Windows; `.gitattributes` in the payload; the upgrade check's CRLF tolerance
  and its Windows forms; the prerequisites by tool name; the platform matrix.
- Applied in v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]): point 7 —
  `scripts/check-prerequisites.sh`, runnable without make. It runs each tool, compares its
  version with a minimum read from the tool's own source, names the platform and whether the
  CI verifies it, and warns when git would write the framework's files with CRLF; it fails
  for a tool missing or not starting, and for gitleaks below its security minimum or unread
  (the user's D5); it installs nothing. `hooks-install.sh` runs it first; `SETUP.md` §0 and
  the upgrade's *Precondition* call it.
- Verified ([[2026-10-12-prerequisites-1.6.0]]): its self-test, against stubs of each tool,
  gitleaks' three command lines among them, a mutant per detection branch caught; in the CI,
  against each image's real tools, 0 FAIL and 0 WARN on the three, Windows taking the branch
  where `core.autocrlf` is true and `.gitattributes` holds LF; the upgrade from 1.5.0,
  rehearsed on the final payload with LF and with CRLF line ends, the check run from `T`
  before Step 1.
- Uncovered: point 7 asked for the install command of the detected platform; the check
  names the tool's official page instead (the user's D2) — a package manager's command per
  platform would bring back the leak point 6 removed. Not verified: WSL, Cygwin, Linux and
  Windows on arm64, macOS on Intel — the check names them as such.

### IMP-076 — commitlint is not pinned → applied on 2026-10-13, commits 1e1129f, f430e1f
- Date: 2026-10-11 | Origin: [[2026-10-11-multiplatform-1.5.0]] — phase 1's inventory of
  the prerequisites
- Observed problem (condensed): the commit-msg hook ran npx's latest commitlint, whose
  21.x `engines` had raised the Node.js minimum to 22.12 with no decision of ours; a later
  major could raise it again, or change behaviour, under every project at once.
- Decision (the user's brief for v1.6.0, 2026-10-12 — [[2026-10-12-prerequisites-1.6.0]]):
  commitlint pinned to an explicit version defined in ONE place, the Node.js minimum
  derived from it, checked on npm.
- Applied in v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]): 21.2.3 for both packages,
  `COMMITLINT=` at the head of `scripts/check-prerequisites.sh`; `hooks-install.sh` reads
  it through `--commitlint-version`, refuses anything but an exact x.y.z, and writes it
  into the commit-msg hook; Node.js 22.12, the minimum, is 21.2.3's `engines` (the npm
  registry). A rule of the documentation check holds every minimum the documents write, and
  the pin, against that one place.
- Verified ([[2026-10-12-prerequisites-1.6.0]]): the shipped self-test finds the pin in the
  generated hook, and a pin of 21 refused, red first; in the CI, the real commit-msg at the
  pin accepts a conforming message and refuses one without a type on the three platforms;
  npx resolved the packages at 21.2.3 (the review); the upgrade from 1.5.0, rehearsed, saved
  1.5.0's commit-msg byte for byte as its `.bak`.
- Uncovered: the pin fixes the two packages only; their dependencies follow the ranges they
  declare (`^21.2.3`, `yargs ^18.0.0`, …), fetched unhashed — `SETUP.md` §0 and the CI's
  statement say so. Raising the pin is a framework release's decision, and its cost.

### IMP-056 — The security gate checks what the code does, not what the product claims → applied on 2026-10-13, commit 4937100
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — a presentation-only
  deliverable, behaviourally clean for both lenses of its review, carried four truth defects
  in what it asserted
- Observed problem (condensed): `docs/03` named only defects of action, and
  `/security-review` had no truthfulness check: nothing covered the assertions a product
  emits. In the framework's own product, v2.0.0 met three ([[2026-10-12-prerequisites-1.6.0]]):
  the pre-commit relayed gitleaks' "no leaks found" after "scanned ~0 bytes"; the
  prerequisite check printed "OK gitleaks 2026"; `hooks-install.sh` claimed "local changes"
  from a mere difference.
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): one principle with
  IMP-058, IMP-071 and IMP-073, a claim covers exactly what a datum shows; its text in
  `docs/03` only, `/security-review` recalling it in one line.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): `docs/03`, *The lenses of the gate*,
  its first lens, *Claims, not only actions* — an assertion about a security property
  checked against the real behaviour, an assertion of absence backed by a datum kept apart
  from its classification; a deliverable whose product asserts a security property is under
  the gate for that alone, the trigger this entry left open. `/security-review`'s check 11
  recalls it.
- Verified ([[2026-10-13-gate-lenses-2.1.0]]): the lens's first use, v2.1.0's review of the whole payload,
  found the hooks' coverage claimed wider than it is — the release's HIGH, fixed in
  `b7e3f09` — and two MEDIUMs whose claims stay wider than the code, recorded as IMP-091 and
  IMP-092; the main session measured the HIGH.
- Uncovered: the lens is a discipline of reading; no mechanical check holds it.

### IMP-058 — Widening a claim beyond the diff widens the gate's perimeter → applied on 2026-10-13, commit b9b003f
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — a small fix attested
  as verified a claim over a whole registry, four entries of which were false
- Observed problem (condensed): the gate was the diff's — `docs/03` ran `/security-review`
  "on the branch diff" —, while a deliverable can widen a claim far beyond the files it
  touches. In v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]) H1 lay outside the reviewed
  range, the pre-commit's text unchanged, and was found because the user scoped the review
  to the hooks; the scan error's claim widened from what was read, 8.4.0 to 8.18.1, to
  "before 8.18.2", in five places.
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): IMP-056's lens at the
  claim's perimeter — one principle with IMP-056, IMP-071 and IMP-073.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): the claims lens of `docs/03` sets
  the perimeter at the claim, not the diff — from these N to all, a list of exceptions that
  disappears, a range of versions —; the gate's first step points at it.
- Verified ([[2026-10-13-gate-lenses-2.1.0]]): in the review's first use of the lenses, the perimeter took it
  beyond the diff — the HIGH lay in `docs/04`'s table and in the installer's install-time
  check, neither touched by the release.
- Uncovered: telling a widened claim from a narrow one stays a reading; no check finds it.

### IMP-073 — Write the record after the last measurement → applied on 2026-10-13, commit 2f13de1
- Date: 2026-10-11 | Origin: [[2026-10-11-payload-purity-1.4.1]] (its retro), recorded at the
  user's request in [[2026-10-11-multiplatform-1.5.0]]
- Observed problem (condensed): records claimed results ahead of their measurement, or
  wider than it — a commit message and IMP-049's Verified part in v1.4.1 (a replay of four
  commits, two rewrites); `7d2052b` in v1.5.0; `5f05004` and four documents in v2.0.0, the
  scan error's range widened ([[2026-10-12-prerequisites-1.6.0]]); and, in the product,
  `hooks-install.sh`'s "contained local changes", a cause claimed from a difference
  ([[2026-10-13-gate-lenses-2.1.0]]).
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): one principle with
  IMP-056, IMP-058 and IMP-071, a claim covers exactly what a datum shows; for the records,
  one line in `docs/02`'s Definition of Done.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): the Definition of Done's point 10 —
  a commit message, a changelog entry, an applied IMP's Verified part is written after the
  last measurement it cites.
- Verified ([[2026-10-13-gate-lenses-2.1.0]]): applied to this release's own commits before their push, the
  point narrowed three messages — a time ("a month before" for sixteen days), an attribution,
  a clause about work not yet done —, each amended while still local.
- Uncovered: a public commit that claims too much stays as it is; its correction is a record,
  as the occurrences were.

### IMP-071 — A claim of coverage is a list that declares itself complete → applied on 2026-10-13, commit 1278bf2
- Date: 2026-10-11 | Origin: [[2026-10-11-payload-purity-1.4.1]] (its retro), recorded at the
  user's request in [[2026-10-11-multiplatform-1.5.0]]
- Observed problem (condensed): "Every rule the check advertises has its defect here", the
  header of the documentation check's self-test, declared itself complete against the forms
  the check names, IMP-068's own shape inside the tool built to catch it — false twice,
  found both times by the reviewer.
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): in the principle of
  IMP-056, IMP-058 and IMP-073; the records' line of `docs/02` says it.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): the Definition of Done's point 10
  goes on — no wider than the measurement: a list that declares itself complete is held
  against its source, as IMP-068's check does, or narrowed to what was measured.
- Uncovered: a list no program can extract stays a reading, IMP-068's own limit.

### IMP-059 — Gating an external tool's invocation is not enough: check what the tool runs by itself → applied on 2026-10-13, commit 9575569
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — a dry-run gate that
  looked closed while the gated tool kept updating itself
- Observed problem (condensed): a gate on a tool's invocation left open what the tool does by
  itself, and nothing in `docs/02` or `docs/03` covered it. The entry's own evidence named
  git's configured textconv in 2026-09; v2.0.0 then met the class in the framework's own
  gate ([[2026-10-12-prerequisites-1.6.0]]): gitleaks reads a `git diff` that the user's
  colour, a textconv driver or an attribute empties or converts (H1, N1), that a
  `diff.external` replaces before 8.18.2; and 8.0.0 to 8.1.3 write a `.gitleaks.toml` into
  the project.
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): one principle with
  IMP-084 and IMP-087, the gate and the test look at the real path; its text in `docs/03`
  only.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): `docs/03`'s second lens, *The real
  path* — a gate on an external tool covers what the tool does by itself, what its
  configuration makes it do and what it updates, writes or fetches unasked, read at its
  source or in its documentation; each such path closed by the tool's off-switch,
  compensated, or declared as a known limit. `/security-review`'s check 11 recalls both
  lenses.
- Verified ([[2026-10-13-gate-lenses-2.1.0]]): the lens's first use found a hook manager that takes
  `core.hooksPath` back after the install — husky, at every `npm install` — and, among the
  findings recorded, Claude Code's own extension points, the tools outside the guard's
  matcher, a clean filter and gitleaks' type sniff (IMP-090, IMP-092, IMP-093, IMP-095,
  IMP-096).
- Uncovered: a behaviour neither documented nor read at the source stays unseen, and a new
  release of the tool can add one.

### IMP-087 — A hermetic test cannot see the defects the user's configuration causes → applied on 2026-10-13, commit a6f6463
- Date: 2026-10-13 | Origin: the review of v2.0.0, its HIGH H1, and the main session's
  measures of its family — [[2026-10-12-prerequisites-1.6.0]] (the retro)
- Observed problem (condensed): the real-hook test emptied the git configuration for
  hermeticity, as every self-test of the framework does, and could not see three silent
  bypasses that live in the user's configuration — a forced colour, a textconv driver, an
  attribute that marks a text file binary.
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): one principle with
  IMP-059 and IMP-084, the gate and the test look at the real path; for the tests, one line
  in `docs/02`, *Tests that demonstrate*.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): *Tests that demonstrate* gets the
  line — a test of what drives an external tool keeps its hermetic baseline and adds cases
  under the configurations the users have. The framework's own instance: the real-hook
  cases 5 to 7, from v2.0.0.
- Uncovered: the configurations users have are open-ended; the cases stay those observed,
  or read at the tool's source.

### IMP-084 — A cross-platform test can pass vacuously when its datum does not reach the program under test intact → applied on 2026-10-13, commit d35fc6c
- Date: 2026-10-12 | Origin: the CI's rounds 6 to 8 of v1.5.0, in the last section of
  [[2026-10-11-multiplatform-1.5.0]] — the lesson in the user's words; recorded in
  [[2026-10-12-prerequisites-1.6.0]]
- Observed problem (condensed): on Windows the `\r` of the guard's CRLF cases, written
  through Git Bash's `$'…'`, did not reach node; the anti-vacuity check caught it in rounds 6
  and 7. Whether rounds 3 to 5 were vacuous is not established, by the user's decision. The
  user's fix, `9fa2e9a`: the cases written as JSON escapes, the form Claude Code sends, and
  the check moved to node itself.
- Decision (the user, 2026-10-13 — [[2026-10-13-gate-lenses-2.1.0]]): one principle with
  IMP-059 and IMP-087, the gate and the test look at the real path; the tests' line of
  `docs/02` says it.
- Applied in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): *Tests that demonstrate* — each
  case under a configuration checks that its datum reaches the program under test, in the
  form the program receives it, before it counts. The framework's instances: the guard's
  CRLF cases since `9fa2e9a`, the real-hook cases 5 to 7 since v2.0.0.
- Uncovered: rounds 3 to 5 of v1.5.0 stay not established.

### IMP-102 — The recovery block printed in advance is run after a successful integration → applied on 2026-10-14, commits 2d82446, 559541c
- Origin: [[2026-10-13-backlog-retro-2.2.0]] — at v2.1.0's integration the agent printed
  `git tag -d v2.1.0` under its condition next to blocks 1 and 2, against `/integrate`'s own
  "if (and ONLY if)": the tag was free when the blocks were printed. The user ran it after an
  integration that had succeeded; the local tag was deleted and recovered with `git fetch`. A
  condition written above a copyable block is not a condition — IMP-069's lesson, which had
  covered the pause before the push only.
- Applied (the user's form, structural): `/integrate`'s normal sequence holds no destructive
  line. Its step 4 gains *When the user reports a failed check*, the one place a recovery
  block is produced — after the report, once read-only commands have shown the state, and
  only while the tag is local (`git ls-remote` prints nothing); the line between the blocks
  and step 5's checklist follow. `docs/04`'s rule 3 of the blocks for the user becomes
  *Destructive commands never in advance*: given once the condition holds, alone in its
  block; the tag hygiene and rule 4 follow. The upgrade's abort block in `SETUP.md` loses the
  comment line inside it, which rule 4 forbids, and is run or given only once the user has
  decided to abort — it had claimed docs/04's form while printed under its condition (the
  review, M1). The failure path's recovery block is printed alone, never beside blocks 1 and
  2, which come again after the repair (the review, L1: a phrase left from 2.1.0's text).
- Verified: `integrate.md` merges three ways cleanly against a copy whose branch placeholders
  are answered, with LF and with CRLF line ends (git 2.54.0, `git merge-file`). The new
  section starts right under the paragraph above it: with a blank line in between, git
  aligned the section against the answered line below it and the merge conflicted
  (measured). The behaviour itself shows at this release's own `/integrate`.

### IMP-074 — The bump is fixed by the brief before the content → applied on 2026-10-14, commits a25e17e, 559541c
- Origin: [[2026-10-11-multiplatform-1.5.0]], the user's brief; the reviewer's L1 in
  [[2026-10-10-upgrade-safety-1.3.3]] and L14 in [[2026-10-11-payload-purity-1.4.1]] — v1.3.3
  and v1.4.1 brought new rules into the payload, MINORs by `docs/04`'s criteria, and shipped
  as PATCHes, the brief having fixed the bump before the content existed. In v2.1.0
  ([[2026-10-13-gate-lenses-2.1.0]]) the applying commits, typed `chore` as `docs/06` says,
  carried new rules: by the types alone a PATCH, by the content a MINOR — the user's
  instruction was to compute it on the content and declare the reasoning before the tag.
  v2.0.0 had shown the other direction: a brief's MINOR became a MAJOR, declared and
  confirmed ([[2026-10-12-prerequisites-1.6.0]]).
- Applied (the user's proposal): `docs/04`, *Versioning*, gains *The type suggests; the
  content decides* — a `docs` or `chore` commit that brings a new rule or command into what
  the project ships is a MINOR, a `fix` that breaks the contract a MAJOR. `/integrate`'s
  step 2 weighs the content after the types, states the bump with its reasoning above the
  blocks, names the bump the request expected if it named one, and where the two differ says
  so and waits for the user's confirmation before step 3's commit; its documentation-is-the-
  product exception and step 5's checklist follow, and its "no tag" bullet yields to the
  content weighed above it (the review, L4: as first written it contradicted it).
- Verified: `integrate.md`'s 3-way merge against a copy with the branch placeholders answered
  stays clean, with LF and with CRLF line ends. The rule itself is exercised at this
  release's own `/integrate`, which expects a MINOR.

### IMP-051 — The memory lags one merge: `/checkpoint` runs before the merge → applied on 2026-10-14, commit 8c58dc0
- Origin: [[2026-09-24-third-upgrade-lessons]] — the cycle runs `/checkpoint` before
  `/integrate`, and the merge happens outside the session, so the memory records the state
  awaiting the merge, and the fix was an optional later `/checkpoint`: one more commit to
  push. Recurring: 5 reconcile commits in the client project, 6 trailing commits here since
  v0.3.0 — structural rather than a slip, though v0.3.0 had called it execution discipline.
- Applied (direction (c), the de-facto practice here): the reconciliation after a merge is
  the next deliverable's first `/checkpoint`. The memory never records a merge not yet run,
  and no commit of its own follows the merge. `/integrate`'s closing paragraph, `/checkpoint`'s
  step 7 and `docs/00`'s summary of the cycle say so; `/checkpoint`'s step 3 already holds
  the reconciliation with git.
- Verified: `integrate.md` and `checkpoint.md`, both HYBRID, merge three ways cleanly against
  copies with their placeholders answered and `checkpoint.md`'s setup paragraph deleted, with
  LF and with CRLF line ends. Read in `SETUP.md`: an upgrade's first `/checkpoint` is its
  Step 6, after Step 5's invariant on the memory, which the rule leaves as it was.

### IMP-094 — reset-task.sh leaves a staged change in the working tree, and reports success → applied on 2026-10-14, commits 2cb04dd, 559541c
- Origin: v2.1.0's review, M4 ([[2026-10-13-gate-lenses-2.1.0]]) — `git restore .` restores
  the working tree from the INDEX, and only then did `git restore --staged .` reset the
  index: a staged change survived as an unstaged one while the script reported the task
  discarded; both restores swallowed their errors, no self-test covered the script, and
  `docs/01`'s manual forms had the same defect.
- Applied: `reset-task.sh` restores the index and the working tree from HEAD in one step
  (`git restore --source=HEAD --staged --worktree -- .`), reports a step git refuses as a
  failure, and says the task is discarded only once the tree reads clean and HEAD has not
  moved. Found while mapping it ([[2026-10-13-backlog-retro-2.2.0]]): in bash 3.2 `cd ""`
  succeeds and stays put, so outside a repository the script went on and reported a discard;
  the top level is now resolved in its own step. `docs/01`'s two manual forms are corrected;
  the new self-test, `scripts/test-reset-task.sh`, is wired in the `Makefile`'s
  `test-scripts`, `CLAUDE.md`'s list, `scripts/README.md`'s table and the upgrade check's
  classes.
- Verified: the self-test, red first against the script as committed — case 1 left
  ` M both.txt` and ` M staged.txt`; alone, case 2 (the index's lock held) and case 3
  (outside a repository) each exited 0 saying "Half-done task discarded" — and green after
  the fix, case 4 under `core.autocrlf` true included (macOS, bash 3.2). The `Makefile` and
  `CLAUDE.md`, HYBRID, merge three ways cleanly against copies with their setup answers in
  place, with LF and with CRLF line ends.
- Declared where its claim lives, `docs/01` and the script's header (the review, L2; not
  measured): a merge, rebase or cherry-pick in progress, whose state survives the restore;
  a detached HEAD, where the guard on protected branches has no branch to compare. The
  self-test does not reach the check that the tree reads clean after the restore (the
  review, I1, from reading): no case makes it fail.

### IMP-052 — Resumption after an abrupt interruption: verify before continuing → applied on 2026-10-14, commits 14d09fc, 559541c
- Origin: [[2026-09-24-third-upgrade-lessons]] — `docs/01`'s RESUMPTION said WHERE to resume,
  not WHETHER the resumed state held: it confirmed the committed tasks and discarded a dirty
  tree, at the start of a session only. In the client project a deliverable without a plan
  was resumed after a usage limit from its dirty tree, and a wiring gap, all tests green,
  was found by reading the diff against the design; a branch was created from the wrong
  base after a resumption (relayed, [[2026-09-26-client-harvest-registration]]).
- Applied: RESUMPTION covers a pause inside a session too (a usage limit, a machine's
  sleep). Its new step 3 verifies before continuing, with or without a plan, scaled to what
  is not committed: always `git status`, the plan's ticks against the commits and the
  branch's base — `git log <integration branch>..HEAD` lists only the deliverable's own
  commits —; with uncommitted work, the build or syntax check, the touched area's tests and
  the diff read against the plan or the decision. Step 4 says what happens to the half-done
  work: discarded in a new session, whose context is gone; kept in the same session after a
  pause if step 3 holds; a `chore: wip` commit verified the same way and never undone
  without the user.
- Verified: the documentation check resolves the sections it cites. Rule 7 of `CLAUDE.md`
  said "if a session is interrupted … discard only the uncommitted half-done task", which a
  pause inside a session now contradicted (the review, L5): it reads "if a session dies
  mid-task", as `docs/01`'s cleanup section does, and `CLAUDE.md` merges three ways cleanly
  with it. The base check reads `origin/<integration branch>` where a remote exists (the
  review, L6), and the manual form of step 4 is the user's: the agent's `deny` rules refuse
  `git clean` in a compound command (the review, I5).

### IMP-053 — The security-gate verdict is always written, "not applicable" included → applied on 2026-10-14, commit 8cf45b1
- Origin: [[2026-09-24-third-upgrade-lessons]] — a skipped gate and a forgotten one looked
  the same in the memory: 4 of this repository's 13 notes before it recorded "not
  sensitive → skipped", 9 were silent, and in the client project a deliverable that touched
  components on its sensitive list had no gate record at all. An upgrade, which rewrites the
  security baseline, never named a verdict ([[2026-09-26-client-harvest-registration]]).
- Applied: the session-note format gains a `## Security gate` line and a section that says
  when it is written — the note that closes a deliverable, always, with its reason: the
  outcome, or "not applicable" and why, naming the trigger, a sensitive component or a
  security property the product asserts; a closing note without it is a forgotten gate, and
  older notes stay valid. `/checkpoint`'s step 3 writes it at a deliverable's last
  checkpoint, `docs/00`'s step 2 asks for it when the review is skipped, and the upgrade's
  checkpoint in `SETUP.md` carries it. The cycle's summaries in `README.md`,
  `CONTRIBUTING.md` and `SETUP.md` said "[if sensitive]", narrower than the gate since
  v2.1.0: "[if under the gate]".
- Verified: `checkpoint.md` (HYBRID) and `docs/00` with its slot answered inline merge three
  ways cleanly, with LF and with CRLF line ends; nothing that reads the memory checks the
  session-note format, so no older note fails. Not adopted from the annotation: a diff of
  the baseline's executable lines as the upgrade's reason — outside the approved form.

### IMP-057 — A test invariant over a known debt: a bidirectional allow-list, not an empty set → applied on 2026-10-14, commit 3bfc446
- Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project: once
  the last known violations of a capability registry were fixed, an invariant failed
  whenever an entry declared it did not honour the capability, so the fastest way to green
  for a new unit without it was to declare it compliant. The test pushed towards the lie
  exactly where the code needed the truth.
- Applied: `docs/02`, *Tests that demonstrate*, gains the rule — an invariant over a set
  with a known debt is a bidirectional allow-list: an unlisted member that violates the
  property fails, a listed one that no longer does fails, each entry with its reason; the
  list is reconciled with "not assertions about the state known today", since (b) breaks it
  the day that state changes, as the anti-vacuity check guards the scanned set; and a test
  that the truth breaks measures the declaration — the test is what to fix.
- Verified: the documentation check passes. Its own exceptions follow the rule since
  v1.4.1, where direction (b) caught a mutation on the unchanged repository
  ([[2026-10-11-payload-purity-1.4.1]]).

### IMP-060 — A delegation brief quotes the user's decisions verbatim; a multi-agent report declares its coverage gaps → applied on 2026-10-14, commit 85c7fbe
- Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project: a brief
  that paraphrased the user's decisions, and left one out, made several agents treat a
  decided point as "undecided, blocking"; the same run lost 2 of 27 agents to stalls, and
  declaring what they left uncovered kept the report honest. Merged in: IMP-063, from
  [[2026-09-27-imp-054-055-agent-git-boundary]] — a review workflow of 3 reviewers and 3
  skeptics stalled for an hour, while one reviewer returned in about 20 minutes with 1 HIGH
  and 5 MEDIUM, all reproduced.
- Applied: `docs/00`, *Scope and session hygiene*, gains the delegation bullet — the brief
  quotes the user's decisions and constraints verbatim, or points at the record that holds
  them; one independent agent first, a fan-out only where the consequences of being wrong
  warrant it, with a stall budget fixed before the run; a report built from several agents
  names its gaps, checked by hand or reported as not covered. `docs/03`'s section on
  adversarial reviews applies it to the reviewers. The verbatim quote is for the brief: a
  record persisted in the memory follows rule 9 and is English.
- Verified: the documentation check resolves the cited section. This release's mapping
  ([[2026-10-13-backlog-retro-2.2.0]]) followed (a) and (b) before they were written: its
  four read-only agents got the user's decisions verbatim and each returned its coverage
  gaps; the snapshot was unchanged after them.

### IMP-078 — commitlint reads a body line that starts with "word:" as the footer → applied on 2026-10-14, commit c62e58d
- Origin: [[2026-10-11-multiplatform-1.5.0]] — a body line that began with a single word and
  a colon opened the footer and cut the body there, the hook only warning "footer must have
  leading blank line": six times from v1.4.1 to v2.1.0, all in the agent's own messages, one
  left in a public commit (`e6597f1`). Read at the parser's source
  (conventional-commits-parser 7.1.3, `getFooterTokenRegex`): a line matching
  `^(?:BREAKING CHANGE|[\w-]+)(?::\s+|\s+#).+` opens the footer, a hyphenated word counting
  as one word.
- Applied (option (a)): `docs/04`, *Commit format*, says the footer follows a blank line and
  no body line, a wrapped one included, begins with a single word followed by a colon or by
  " #", and why. Its own example, whose footer followed the body with no blank line, gains
  the blank line. Option (b), the warning raised to an error, is not adopted: the hook would
  refuse messages 2.1.0 accepts — breaking, by the criterion v2.0.0 applied to gitleaks.
- Verified: the documentation check passes, its Types line untouched. In this release the
  messages were checked before each commit with a grep for such a line: it stopped four of
  them, rewrapped while still uncommitted ([[2026-10-13-backlog-retro-2.2.0]]).

### IMP-103 — A LOW finding that a line of text does not close becomes a declared limit, not an IMP → applied on 2026-10-14, commit 29cccab
- Origin: [[2026-10-13-backlog-retro-2.2.0]] — the retro over the backlog, on the data of
  v2.1.0's review ([[2026-10-13-gate-lenses-2.1.0]]): 6 of the 11 IMPs that review opened came
  from LOW findings, IMP-095 to IMP-100, while `docs/03` asked only that LOW/INFO findings
  be "at least recorded", and the framework now wants a small backlog, grown from the
  projects' real use.
- Applied (the agent's proposal at the retro, adopted by the user): `docs/03`'s point 4 of
  *How the gate works* — a LOW/INFO finding that a line of text closes, a claim narrowed to
  what the code does, is closed in the release; one it does not close becomes a known limit,
  declared where the claim it concerns lives, not a proposal in the backlog; a lesson about
  the process still becomes one. `/security-review`'s closing line follows. `CLAUDE.md`'s
  rule 8, "LOW at least recorded", stays true of a declared limit and is not touched.
- Verified: the documentation check passes.

### IMP-061 — `/harvest-framework` re-prints entries already carried upstream: double counts at recording time → applied on 2026-10-14, commit 4fe4e26
- Origin: [[2026-09-26-client-harvest-registration]] — `/harvest-framework` prints every
  marked entry, carried upstream or not, with no provenance the framework could match: in
  the recording of 2026-09-26, seven of fifteen harvested entries repeated lessons relayed
  two days before, and the draft counted three of them as independent occurrences until the
  review caught it.
- Applied (directions (b) and (c)): the command collects, beside the entry's number, the
  date of the session note its Origin cites — the date only, never the note's name, whose
  slug can name the project — and prints both in each entry's heading; its closing step
  says a lesson harvested twice is counted once by the framework, and drops the advice to
  annotate the project's entries by hand, so a project's `LEARNINGS.md` keeps its format.
  `docs/06`'s bridge and `SETUP.md`'s pointer say a repeat is evidence on the entry it
  repeats; `CONTRIBUTING.md`, *In practice, for a proposed change*, says how the framework
  counts once: the pair matched against the recordings' session notes, a neutral label for
  the project, its number written as "the project's entry 012", never as an IMP number.
- Verified: the documentation check passes; the command cannot run in this repository,
  where no entry is marked, so its first use is the next harvest from a project.

### IMP-092 — Claude Code's permission flow can replace the guard's verdict and the ask rules → applied on 2026-10-14, commits b408a71, 9d75a78, 0c0d7c2, 559541c, 39ade72
- Origin: v2.1.0's review, M2 and I1, *The real path* ([[2026-10-13-gate-lenses-2.1.0]]) —
  `docs/04` said the guard's verdict "always stands" and the boundary's files "always" ask,
  while Claude Code's own extension points can answer in their place. Merged in: IMP-093,
  M3 — tools that write git state outside the guard's matcher.
- Applied, as declarations: `docs/04` gains *What Claude Code can put above the guard and
  the rules* — a mod the user installs that handles `tool.check` can approve a call the
  guard blocked, one an `ask` rule would prompt for and one a `deny` rule refuses, except
  where managed settings or a Team or Enterprise plan hold deny rules over it, by default;
  a PermissionRequest hook can answer a prompt in the user's place; `"disableAllHooks":
  true`, the documented switch for every installed mod in every session, turns off the
  project's hooks too, and a `--safe-mode` session loads none of them, with none of the
  wiring's notices; `"onFailure": "block"` would close the fail-open in the main session
  too, so it is not set. The fail-closed bullet says the wiring never
  changes the guard's verdict; the guard's and the deny rules' rows name what is outside
  them; the read-only bullet and the ask bullet are narrowed to match. IMP-093's tools —
  EnterWorktree, which creates a worktree on a new branch with no prompt, and a git MCP
  server — are declared outside the guard. IMP-097's IDE terminal is declared in the bullet
  on where the human pushes; its code waits with IMP-095. The worktree-isolation bullet
  gains what the reading found besides: a fresh worktree fetches the default branch when
  the repository was not fetched for 24 hours, which moves a ref the snapshot sees, and
  falls back to the local HEAD without a remote. `SETUP.md`, `scripts/README.md` and the
  README follow. `"disableAllHooks": false` is not adopted: it pins a choice of the user's.
- Verified: each sentence against Claude Code's documentation as read on 2026-10-14 —
  *Configure permissions* (*Extend permissions with hooks*), *Hooks reference*, *Mods
  overview*, the environment-variable reference, the tools reference and *Run parallel
  sessions with worktrees* — read, not measured; `docs/04` with its slots answered inline
  merges three ways cleanly, with LF and with CRLF line ends. Re-read the same day at the
  user's request, against the pages' text and with the *Settings reference*
  (`disableAllHooks`) and the *CLI reference* (`--safe-mode`) besides
  ([[2026-10-13-backlog-retro-2.2.0]]): four statements narrowed — the deny rules' exception
  holds by default and the organization can change it, and the deny row had left out Team
  and Enterprise plans; `disableAllHooks` is one of the documented switches, not the only
  one; the `/hooks` menu shows a notice when hooks are off; the Desktop app's version —, and
  `--safe-mode`, which loads no hook of the project, declared with `disableAllHooks`.
- The guard's own comments follow, edited with the user present (an ask-protected file):
  Bash, PowerShell and Monitor are the shell tools its wiring matches, and EnterWorktree and
  a git MCP server write git state outside it.
- The release's review found the route all these declarations had missed, the HIGH of v2.2.0
  (H1): Claude Code reads `.claude/settings.json` from the session's primary working
  directory, with no parent-directory fallback — *Settings* and *Configure permissions*, read
  on 2026-10-14, not measured —, so a session started in a subdirectory, or moved there with
  `/cd`, has no guard, no `deny` or `ask` rule, no `AGENT_GIT_BOUNDARY` and no SessionStart
  hook, while `CLAUDE.md` still loads; `--setting-sources` without `project` and managed
  `allowManagedHooksOnly` do the same. `docs/04` gains *Only a session that loads the
  project's settings has the wiring* and its rows and `ask` bullet follow; `SETUP.md`'s
  *Hardening* gains *Start Claude Code at the repository's root*; the README,
  `scripts/README.md` and the guard's comment follow. The `pre-push` still refuses such a
  session's push, on `CLAUDECODE`. The compensation, the user's decision of 2026-10-14:
  `CLAUDE.md`, which loads from the directories above, tells the agent that a session
  whose `STATE.md` was not injected did not load the settings, to say so before anything
  else and to advise a restart from the repository's root — an instruction, not a
  mechanism, which IMP-104 proposes. With it: ExitWorktree, whose `remove` deletes a worktree
  and its branch with no permission asked (L3), joins EnterWorktree; dontAsk refuses an
  `ask` rule's call instead of asking (I2); a fresh worktree falls back to the local HEAD
  when `origin/HEAD` is neither cached nor fetchable, and the `worktree-agent-<id>` branch
  was measured for the Agent tool only (I6).

### IMP-083 — The guard grows beyond its threat model → applied on 2026-10-14, commits d49e54e, 9d75a78
- Origin: the user's request at v1.5.0's integration ([[2026-10-11-multiplatform-1.5.0]]) —
  in v1.5.0 the guard learned non-ordinary PowerShell forms for a tool the framework keeps
  off, growing from 239 to 309 lines. Merged in: IMP-079 — a parser's coverage holds for the
  forms it was held against, not for the language: v1.5.0's reviewer got 15 of 19 ordinary
  PowerShell forms through, and v2.1.0's review (L6, [[2026-10-13-gate-lenses-2.1.0]]) found
  bash forms the guard passes.
- Applied (reduced, as approved): `docs/04`'s guard row covers the forms its self-test holds
  it to, not "ordinary forms", and its *Outside this layer* names L6's forms — git in an
  unquoted heredoc's `$(…)` or backticks, a function declared with `function` and no
  parentheses, a `coproc`, a command name in a variable. *Proven, not assumed* says the
  cases are the guard's coverage and states the admission rule: a form joins them only when
  an agent was seen writing it, or it is an ordinary form of the shell's own documentation,
  never because the parser could read it. `SETUP.md` and `scripts/README.md` narrow their
  coverage claims the same way. No form is pruned: the rule stops the growth. The guard's own
  comments follow: its scope names L6's forms and calls its self-test's forms its coverage,
  no longer "deliberate evasion"; its splitter says an unquoted heredoc runs its `$(…)`; its
  wrapper list says how it differs from the wrappers Claude Code strips.
- Verified: the forms `scripts/README.md` now names — git after its global options, spelled
  `git.exe`, `Git` or a Windows path — are cases of `scripts/test-agent-git-guard.sh`
  (read); the documentation check passes. The forms the guard's scope names, run through it
  on 2026-10-14: each goes through unblocked, while `exec`, `nice`, `nohup` and `xargs -n1`
  before a git write are blocked ([[2026-10-13-backlog-retro-2.2.0]]); its comments changed,
  no line of its code.
- Evidence after application, 2026-10-15 — no proposal ([[2026-10-15-harvest-retro-3.0.0]]):
  the guard lets a delegated agent's `git grep -O<cmd>` through — `grep` is classed as a
  read, and `-O` runs a program —, a form no agent was seen writing at work; and it refused a
  retro agent's `git --man-path 2>/dev/null`, a read, taking the redirection after git's
  global options for the subcommand — a false positive, on the safe side.

### IMP-075 — Auto mode and the framework's boundaries → applied on 2026-10-14, commit 4c03a05
- Origin: [[2026-10-11-multiplatform-1.5.0]] — the user ran `/auto-mode-setup` on 2026-10-11:
  it drafted entries from this repository into `~/.claude/settings.json`, which holds for
  every project — the trusted repository, the framework's visibility, and a false
  statement about the protection of `main` —, and the user corrected the file. Merged in:
  IMP-065 ([[2026-09-27-imp-054-055-agent-git-boundary]]) — the `ask` rules on the boundary's
  files cover the file tools only, and some `.claude/` edits had gone through shell
  one-offs, auto mode's preference for the shell a contributing factor.
- Applied (the user's proposal): `docs/04` gains *In auto mode too* — auto mode allows
  pushes to any branch, the default one included, and a push written another way matches
  no rule, so the `pre-push` stays the boundary; its local-file bullet says `autoMode` is
  read only from the user's settings, the managed ones and `--settings`, so what the setup
  command drafts from one repository is written true for all of them; its `ask` bullet
  says the method's own files are edited with the file tools, a shell write to them a slip
  to report, a procedure that writes them by design excepted. `SETUP.md`'s *Hardening*
  gains *In auto mode*: the boundary, the documentation's `ask` recipe as a net for the
  usual spelling in the user's own settings — `Bash(git push *)`, `Bash(gh pr create *)`,
  commands that begin that way only, a framework project's `deny` answering first —, and
  the per-user environment.
- Verified: each sentence against Claude Code's *Configure auto mode*, read on 2026-10-14
  (*Common boundaries*, *Add a human checkpoint*, *Where the classifier reads
  configuration*, *Generate environment entries*) — read, not measured; `docs/04` merges
  three ways cleanly with its slots answered inline, with LF and with CRLF line ends.
- Kept apart from IMP-067, deferred: that one measures what loads in non-interactive modes.

### IMP-091 — The commits git creates itself skip the pre-commit → applied on 2026-10-14, commit 3db3233
- Origin: v2.1.0's review, M1, *Claims* ([[2026-10-13-gate-lenses-2.1.0]]) — git runs the
  pre-commit only from `git commit`, so a key pasted into a rebase conflict's resolution was
  committed (measured), while `docs/03`'s baseline and `CLAUDE.md`'s rule 1 claimed every
  commit. v2.1.0 narrowed those two claims (`ee883ee`), measured on git 2.54.0 which commits
  run the hook and which do not.
- Applied, the rest of the text: the known limits of `SETUP.md`'s *What the pre-commit's scan
  reads* gain the commits git creates itself, as measured, and, under IMP-103, the limits of
  the hooks' group whose code is deferred: the scan apart passes over a file that starts with
  an application's signature and over a type change, reads the project's `.gitleaks.toml`
  where `protect` would read `GITLEAKS_CONFIG_TOML` first (IMP-095), and a clean filter shows
  it git-lfs's pointer, not the content (IMP-096). The same rule puts each other limit where
  its claim lives: a `pre-push.local` that is not executable is skipped without a word
  (`docs/04`, `SETUP.md`'s Step 4, `scripts/README.md`); a re-run writes its `.bak` over the
  one an earlier run left (IMP-098, `SETUP.md`'s Step 4, `scripts/README.md`); the history
  scan reads neither a merge's own resolution nor a type change (IMP-089, `SETUP.md`'s box).
  `docs/03`'s baseline points at the list, and `scripts/README.md`'s claim on the scan apart
  names it. The compensation at publication is not adopted: a scan at every push, for a
  route that needs a secret pasted into a conflict's resolution.
- Verified: the documentation check passes; each declared limit cites its own datum —
  measured, or read at gitleaks' source — as recorded in IMP-095, IMP-096, IMP-098 and IMP-089.

### IMP-085 — The framework's files kept out of deploy artifacts → applied on 2026-10-14, commit 249e7af
- Origin: the user's question, 2026-10-13 ([[2026-10-12-prerequisites-1.6.0]]) — the framework
  serves development only, but its files, the project's memory among them, sit in the
  repository, and a deploy that copies the whole repository carries them into production;
  no page said so.
- Applied: `SETUP.md`'s *Hardening* gains *Keep the framework out of what you deploy* — keep
  the framework's files out with the stack's own mechanism, `.claude/` whole, `CLAUDE.md`, the
  framework's scripts, `commitlint.config.cjs`, the files the project also owns being its own
  call; a build from a working tree also carries what git ignores there; the class table
  names every framework file; no ignore file in the payload. The upgrade's Step 5 gains the
  check: no framework path in a deploy artifact, the paths `vY` adds above all.
- Verified: the documentation check passes. The user verified the two projects using the
  framework on 2026-10-13: one has no deploy; the other builds its services' container
  images with the repository's root as the build context, copying specific paths — the
  check runs at its upgrade.

### IMP-082 — The whole suite before each commit, the documentation check included → applied on 2026-10-14, commit 0cf77df
- Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro) — a prose edit in `SETUP.md` passed
  the self-test that reads its block and failed the documentation check, caught after the
  commit; in v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]) two commits went in after the
  documentation check alone and broke its self-test, the checkpoint's commit following
  because its command was not gated on the suite.
- Applied: `CONTRIBUTING.md`, *This repo's workflow* — every commit is gated on the suite in
  the same command, `make test-scripts && bash tools/test-upgrade-check.sh && git commit …`;
  the real-hook tests run in the CI; a `chore: wip` commit is the one exception; the suite
  reads the working tree, so a partial commit is green only if the rest is too.
- Verified: every commit of v2.2.0 so far ran in that form ([[2026-10-13-backlog-retro-2.2.0]]),
  and none went in on a red suite.

### IMP-088 — A change next to a setup slot conflicts at every project's upgrade → applied on 2026-10-14, commit 7b0c4fc
- Origin: task 10 of v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]) — a block inserted next to
  the formatting slot's line made `hooks-install.sh`'s 3-way merge conflict, 41 of 311
  lines, for every project that answered it; only the release's rehearsal found it.
- Applied (the lighter form): `CONTRIBUTING.md`, *This repo's workflow* — a change to a
  HYBRID file keeps at least one unchanged line between itself and a line a project answers
  at setup; where it must land on one, the CHANGELOG's *Upgrading* note names the conflict;
  every release that changes a HYBRID file rehearses the upgrade with every setup answer in
  place, LF and CRLF. The mechanical check is not adopted: a fixture of answered slots to
  keep.
- Verified: measured before writing it, with `git merge-file` on git 2.54.0 — a change on the
  line next to an answered one conflicts, after one unchanged line it merges cleanly
  ([[2026-10-13-backlog-retro-2.2.0]]). The same release found the blank line's weakness:
  `integrate.md`'s new section, inserted after a blank line, was aligned by the diff against
  the answered line below and conflicted until it sat right under the paragraph above.

### IMP-099 — The platform the check names as verified is wider than the CI's images → applied on 2026-10-14, commit 07b8abd
- Origin: v2.1.0's review, L13 ([[2026-10-13-gate-lenses-2.1.0]]) — `check-prerequisites.sh`
  called any macOS on arm64, any Linux but WSL on x86_64 and any Windows on x86_64 through
  Git Bash a platform the framework's CI verifies; the CI runs one release of each.
- Decided (the user, 2026-10-14, of two designs): the workflow is not in the payload and the
  check runs in the projects, so the check carries the CI's images in one line, `CI_IMAGES`,
  and the documentation check fails when that line differs from the workflow's matrix; on
  Windows the check names the image without declaring a match. Whatever IMP-086 decides on
  the matrix, the line follows it.
- Applied: the check reads macOS's release from `sw_vers` and Linux's from `/etc/os-release`
  — read as data, never sourced —, and says "verified" only for the major release of a
  `macos-` image on arm64 or the release of an `ubuntu-` image on x86_64; anything else is
  "not verified", with the images listed; on Windows through Git Bash on x86_64 it names the
  `windows-` images and says it does not tell Windows releases apart — Git Bash's `uname`
  gives a build, not an edition. `SETUP.md`'s table names each image's release, and its "Not
  verified" line the releases left out. The CI's step asserts that the check, run on each
  image, names that image — verified on Linux and macOS, named on Windows —, so its reading
  of `sw_vers` and os-release is held to the images themselves.
- Verified, red first ([[2026-10-13-backlog-retro-2.2.0]]): the committed check called macOS
  27 and 15, Debian 12, Ubuntu 16.04 and a Windows 11 build "a platform the framework's CI
  verifies", and the new self-test case failed against it, then passed (macOS, bash 3.2); the
  committed documentation check let a planted `macos-15` through, the new one fails it both
  ways; the CI step's assertion, simulated on six platform lines, passed the three right ones
  and failed the three wrong ones. On the images themselves, the CI's run on `493a4e1`: the
  check read "Linux, ubuntu 24.04 (x86_64), verified by the framework's CI on
  ubuntu-24.04", "macOS 26.6.2 (arm64), verified by the framework's CI on macos-26", and on
  Windows named `windows-2025` with no verdict; the step's assertion passed on the three.
- Uncovered: the check reads the images in the forms GitHub names them today —
  `macos-<release>`, `ubuntu-<release>`, `windows-<year>` —; an image named otherwise, with an
  `-arm` or `-intel` suffix, verifies nothing until the check learns its form.

### IMP-122 — The framework's commands hide Claude Code's built-in ones: the `fw` namespace → applied on 2026-10-15
- Origin: the user's reading and measurement, 2026-10-15 ([[2026-10-15-harvest-retro-3.0.0]])
  — `/security-review` is a built-in command, and `/checkpoint` a built-in alias of `/rewind`
  (Claude Code's commands page). The skills page, *Resolve skills that share a name*: "In a
  local terminal session, your skill replaces the built-in command, but not its aliases." The
  user measured, Claude Code v2.1.299, both framework commands hiding Anthropic's, the alias
  too, against the page's "not its aliases": every project lost two of Claude Code's commands,
  and nothing said so.
- Applied (the user's decision): the eight commands moved with `git mv` from
  `.claude/commands/` to `.claude/commands/fw/`, and run as `/fw:<name>` — the skills page,
  *How a skill gets its command name*: a file in a subdirectory of `.claude/commands/` is named
  by its path, each `/` replaced by `:`. Names and references changed, not the commands'
  logic: `CLAUDE.md`, the seven docs, the commands themselves, the memory's templates,
  `README.md`, `SETUP.md`, `SECURITY.md`, `CONTRIBUTING.md`; the session notes, the CHANGELOG
  and the IMP entries are history and keep the old names. `CONTRIBUTING.md` gains the rule — a
  new framework command goes under `fw/` only, with a link to Claude Code's commands page —,
  and the documentation check fails a command file outside `fw/` and reads a namespaced name.
  `SETUP.md`'s edge case 2 merges a renamed file the project customised into its new path —
  base the old path at `vX`, theirs the new one at `vY` — and describes the namespace's
  migration. `tools/upgrade-check.sh` classes the new paths and keeps the old ones, which an
  upgrade from an earlier release reads at `vX`; `inventory` names each rename by what the
  project holds, with its merge's measure, and no longer calls its old path a deletion; `post`
  fails while an old command file remains. The documentation check's tripwire counts a
  renamed file against its old path, read from the index.
- Verified: once the files moved, this session's runtime listed the eight commands as
  `fw:<name>`, and Claude Code's own `security-review` reappeared among its commands; the new
  case of `tools/test-upgrade-check.sh` (renames) fails against the upgrade check of the
  previous commit and passes; the tripwire, before its fix, reported "0 → 4 slot markers since
  v2.2.0" on the moved `lint-memory.md`, nothing after; `tools/test-docs-check.sh` built its
  base from HEAD and the unstaged deletions only, so a `git mv`'s old path stayed in it — it now
  takes the staged deletions out and stages its base, as a commit takes it; the suite green.
- `fw` collides with nothing Claude Code's pages name, nor with any plugin of the maintainer's
  marketplace cache (6,708 names), read on 2026-10-15. Declared residuals: a plugin named `fw`,
  whose skills would be `/fw:<name>` too; a nested `.claude/skills/` under a project directory
  named `fw`, listed as `/fw:<name>` when its names clash.
- Measured at the release's rehearsal, not here: the conflicts the rename brings to a project's
  3-way — rule 8's line of `CLAUDE.md` carries its slot and the command's name.

## Deferred (not rejected — resumed at the right time)

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
- Retro of 2026-10-13 (the user's decision): DEFER confirmed, the trigger narrowed to its
  observable clause — at least 2 recurring operational procedures in a project with no
  natural home, neither `CLAUDE.md`'s technical rules nor a command, reaching the framework
  through a harvest. The clause on Skills becoming the primary vehicle is dropped: it cannot
  be verified.

### IMP-037 (option a) — The `/upgrade-framework` read-and-print command (the inverse twin of `/harvest-framework`) → deferred on 2026-07-17, again on 2026-10-10
- **Re-deferred on 2026-10-10** ([[2026-10-10-upgrade-safety-1.3.3]]): the count trigger below fired;
  the user split the entry. Option (b), a read-only verification script, is approved —
  see IMP-037 (option b) under *Applied* (v1.4.0). This option, the full command, stays
  deferred. New resumption trigger: the first upgrade of a SECOND project (the three
  cases below are all one project's).
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
  performed on 2026-07-17 (the client project, v0.2.0→v0.5.1) — see
  [[2026-07-18-retro-mirata-imp-036-037]]. Friction observed: the cost was in the
  file-by-file JUDGEMENT (decisions R1/R3/R4/R5 + the per-version 3-way of
  `hooks-install.sh`), which a read-and-print command does not remove; the manual
  procedure of `SETUP.md` held up (the memory invariant respected, the functional
  verification of the hooks demonstrated). Counter: **1 of 2-3**, trigger NOT fired.
  User decision: deferral CONFIRMED.
- **Case #2 happened** (bookkeeping annotation 2026-09-23, found during the IMP-044
  assessment — see [[2026-09-23-memory-model-turns]]): the same client project performed
  its second real upgrade on 2026-07-19 (v0.5.1→v1.0.0, crossing the first stable
  release). Counter: **2 of 2-3** — the trigger is CLOSE, not fired. Bookkeeping only
  (user decision): the IMP is NOT reopened here; its evaluation belongs to a retro. Note
  for that retro: both upgrades hit the contradiction recorded in IMP-046.
- **Case #3 happened — TRIGGER FIRED on the count** (annotation 2026-09-24,
  [[2026-09-24-third-upgrade-lessons]]): the same client project performed its third
  real upgrade (v1.0.0→v1.2.0, across the full translation of v1.1.0). Counter: **3 of
  2-3** — the count condition is MET; the second clause ("when the common pattern is
  distillable from the tested text") is the retro's call, and the input below bears on
  it. Recording only: the IMP is NOT reopened here; whether to reopen, re-scope or
  confirm the deferral is decided at a retro. Input for that retro (IMP-050, point 3):
  the case-#1 friction was "the file-by-file JUDGEMENT, which a read-and-print command
  does not remove"; case #3 split that judgement — the per-file churn table and the
  diff-against-baseline inventory are its MECHANICAL, printable inputs (the upgrade
  produced them with ad-hoc scripts that read the framework by tag), while the per-item
  decisions stay human. Also for that retro: such a command reads the framework repo —
  by tag and with `-C` (IMP-050, points 1-2) — while the boundary above says "no
  cross-repo git" (the execution boundary and the agnosticism inherited from
  `/harvest-framework`: the project does not know where the framework repo lives).
  `git -C "$FW"` tag reads cross it: whether reads are allowed is an open question for
  that retro. All three upgrades hit IMP-046.
- Retro of 2026-10-13 (the user's decision): DEFER confirmed. The trigger — the first upgrade
  of a second project — is expected among the upgrades of the two projects using the
  framework that follow v2.2.0; the entry is decided at the retro after them, on the
  friction observed there.

### IMP-045 — A `turns` threshold as a /retro input → deferred on 2026-09-23
- Date: 2026-09-22 | Origin: [[2026-09-23-memory-model-turns]] — high-friction work is
  noticed only if someone remembers it (the companion rule of IMP-044, NOT applied)
- Proposal (NOT an active rule): when `turns` exceeds a threshold N, `/retro` examines
  the task as a candidate for a lesson (high turns = friction, and friction is the raw
  material of IMPs).
- User decision: DEFER. N is NOT determinable now: no note carries `turns` yet, so there
  is no distribution to set it on. Inventing N would produce a rule that either always
  fires (noise to be ignored) or never does (dead) — worse than no rule at all. The same
  anti-hype filter as IMP-027 (`graft.sh`), IMP-037 (`/upgrade-framework`) and IMP-042
  (`/change-language`): first the cases, then the rule that uses them. No N is chosen
  here.
- Resumption trigger: after ~20 tasks have recorded `turns`, when the real distribution
  allows N to be fixed on the data instead of guessed. A "task" here is a deliverable —
  `turns` is per NOTE (IMP-044), and one deliverable's notes share its `branch`. Helper,
  counting the distinct branches whose notes carry `turns` in this repo:
  `grep -lE '^turns: [1-9][0-9]*[[:space:]]*$' .claude/memory/sessions/20*.md | xargs grep -h '^branch:' | tr -d '\r' | sort -u | wc -l`
- On resumption: decide whether the rule looks at a single note or at the sum of the
  notes of the same deliverable; and the framework repo's own notes are process work, so
  check N against the notes of at least one client project before fixing it.
- Retro of 2026-10-13: DEFER confirmed; the helper counts 13 deliverables with `turns`, of
  the ~20 the trigger needs.

### IMP-062 — Cover remote writes through `gh` in the agent boundary → deferred on 2026-10-13
- Date: 2026-10-07 | Origin: [[2026-09-27-imp-054-055-agent-git-boundary]] — the push
  boundary of IMP-054 stops every `git push` born from the agent's process, not the remote
  writes that bypass git
- Observed problem: `gh` changes shared state without `git push`: `gh api` with a writing
  method (any `-f`/`-F` field switches it to POST; `-X PUT …/contents/<path>` creates a
  commit; `PATCH …/git/refs/<ref>` moves a ref, force included), `gh pr merge` (a merge onto
  the integration branch; `--delete-branch` also deletes the remote branch),
  `gh release create` (creates the tag when it is missing), `gh repo sync <remote>`. The
  `pre-push` never sees them — git runs it for `git push` only — and the deny list does not
  name them. Logged in with the owner's credential (`repo` scope in this repo), an agent
  using `gh` acts as the owner: the forge cannot tell them apart, and the same credential
  can remove the rulesets.
- Why not now (user decision 2026-10-07, D3): this layer's threat model is the agent's
  ACCIDENTAL errors with ordinary commands, no flow of the framework uses `gh`, and the
  hook of IMP-054/055 must stay small (delegated agents' read-only git only).
- Proposal: NOT decided. Direction: the PreToolUse hook refuses, in every session, the
  writing `gh` forms (`api` with a non-GET method or a body field, `pr merge`,
  `release create|edit|delete|upload`, `repo sync <remote>`) — sketched in the phase-1
  prototype, never tested. Alternative: a read-only token for the agent through
  `GH_TOKEN`, which narrows rather than seals (the stored credential stays reachable).
- Resumption trigger: the first use of `gh` in the framework's flows (a command, a doc
  step, an `/integrate` variant), or the first incident of an agent writing to the remote
  through `gh`.
- Expected benefit / risk: closes the non-git route to shared history for accidental use.
  Risk: a larger hook — the size the user chose to avoid now.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision): no flow of the
  framework uses `gh`, D3 still holds, and the trigger above is verifiable as it stands.

### IMP-067 — The framework in headless mode (`claude -p`, CI) and via the Claude Agent SDK → deferred on 2026-10-13
- Date: 2026-10-09 | Origin: [[2026-10-09-quick-fixes-1.3.2]] — user request; evidence
  from phase 1 of [[2026-09-27-imp-054-055-agent-git-boundary]]
- Priority: MEDIUM (user decision, 2026-10-09) — the retro's process block.
- Observed problem: the framework presupposes interactive Claude Code — `CLAUDE.md`, the
  slash commands, `.claude/settings.json` (permissions, `env`, hooks), the hook input's
  `agent_id`. Which of these load in headless mode and in the Agent SDK is not verified,
  nor which boundaries of `docs/04` fall there. What is known: with `--bare`, Claude Code
  loads no hooks (CLI help and docs, checked by the adversarial documentation pass of that
  phase — documented, NOT measured by a probe), so the delegated-agent boundary does not
  exist there; plain `claude -p` DID load the PreToolUse hook and carried `agent_id` to
  subagents and workflow agents (measured, 2.1.283); in a workspace never trusted
  interactively, `claude -p` ignored the project's `permissions.allow` while deny rules
  and hooks applied (measured — IMP-064).
- Proposal: NOT decided. First step: an investigation with real probes, as for IMP-054,
  in throwaway repositories, measuring for each mode (`claude -p`, `--bare`, `--safe-mode`,
  CI without a TTY, the Agent SDK) what loads and what does not: `CLAUDE.md`, the
  commands, settings and their `env`, the hooks (SessionStart, PreToolUse), the `pre-push`
  markers. The results go into `docs/04` and `SETUP.md` as "what holds in headless"; no new
  mechanism before the measurement.
- Out of scope: projects that USE the Messages API as a component (that is the project's
  stack; the framework stays agnostic), and harnesses other than Claude Code.
- Expected benefit / risk: the boundaries are known where they hold and where they do not.
  Risk: none for the investigation itself.
- Merged on 2026-10-13 (the retro over the backlog — how this investigation's probes are
  run): IMP-064 — Probing Claude Code's permissions in an untrusted workspace measures the
  wrong thing (2026-10-07, [[2026-09-27-imp-054-055-agent-git-boundary]]). A `claude -p`
  session started in a directory never trusted interactively ignores the project's
  `permissions.allow` while deny rules and hooks stay active: the first probe matrix showed
  every push form denied as not allowed, not by the deny rule, and only the denial messages
  and stderr told the two apart. The probes declare their trust shape — the allow in
  `settings.local.json` —, classify each denial (a rule's match, not allowed, a hook) and
  read stderr.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision): an expensive
  investigation that no project's use asks for yet, and from this cycle on the framework
  develops from real use. Its MEDIUM priority holds when the trigger comes.
- Resumption trigger: the first project that runs Claude Code non-interactively — `claude
  -p`, a CI job or the Agent SDK — on a repository with the framework. Verified by the user on
  2026-10-13: neither of the two projects using the framework does.

### IMP-077 — gitleaks `protect` is deprecated → deferred on 2026-10-13
- Date: 2026-10-11 | Origin: [[2026-10-11-multiplatform-1.5.0]] — phase 1's inventory of
  the prerequisites
- Observed problem: the pre-commit hook runs `gitleaks protect --staged --redact -v`.
  gitleaks' README: "v8.19.0 introduced a change that deprecated `detect` and `protect`.
  Those commands are still available but are hidden in the `--help` menu." 8.30.1, the
  latest release (2026-03-21), still runs it and hides it from `--help` (both measured).
  A later release may drop it, and every project's commits would stop with it.
- Proposal: NOT decided — weigh in v1.6.0 the replacement form, verified on gitleaks'
  current documentation: its own pre-commit hook definition (`.pre-commit-hooks.yaml`)
  runs `gitleaks git --pre-commit --redact --staged --verbose`, and 8.30.1's
  `gitleaks git --help` documents `--pre-commit` ("scan using git diff") and `--staged`
  ("scan staged commits (good for pre-commit)"). The switch's minimum, for the
  prerequisites to state and v1.6.0's prerequisite check to verify, is 8.20.0 (corrected
  below; first recorded as 8.19.0).
- Decided (the user, 2026-10-12, v1.6.0's D1 — [[2026-10-12-prerequisites-1.6.0]]): the
  hook keeps `protect`, and gitleaks' declared minimum is 8.0.0, where `protect --staged`,
  `--redact` and `-v` exist; `detect` stays with it. The entry stays OPEN on its trigger.
- Resumption trigger (the deadline): gitleaks announces the removal of `protect`. Then the
  hook moves to `gitleaks git --pre-commit --redact --staged --verbose`, with 8.20.0 as the
  minimum — 8.19.x's `--staged` defect —, and `detect` to `gitleaks git` wherever the
  history scan is written (`SETUP.md`'s step 3 and brownfield checklist, `docs/03`,
  `SECURITY.md`).
- Expected benefit / risk: the hook does not depend on a hidden command. Risk: an older
  gitleaks stops working with the switched hook, and 8.19.x would scan the history in
  silence, missing the staged changes. The prerequisite check fails below gitleaks'
  security minimum (D5, below) only when the hooks are installed: at the switch that
  minimum becomes 8.20.0, and the switched hook refuses a gitleaks below it by itself — the
  check at every commit, D5's option B, kept for the switch.
- Corrected on 2026-10-12 ([[2026-10-12-prerequisites-1.6.0]]), from gitleaks' source at
  each tag: `gitleaks git` exists from 8.19.0, but in 8.19.0 to 8.19.3 it ignores
  `--pre-commit` and `--staged` — it scans the history and misses the staged changes
  (issue #1522, fixed by #1533 in 8.20.0). `protect --staged` reads the staged diff
  through its own code in every release from 8.0.0 to 8.30.1, hidden from 8.19.0.
- Added on 2026-10-12 (v1.6.0's review, its HIGH — [[2026-10-12-prerequisites-1.6.0]]):
  gitleaks runs its `git diff` and `git log -p` without `--no-color` in every release up to
  8.30.1, so a colour the user's git configuration forces to "always" leaves it nothing to
  scan, and a textconv driver shows it a conversion instead of what is committed — both
  measured through real commits. Upstream: gitleaks#2281 (open, filed against
  `gitleaks git --pre-commit --staged` too) and PR #2284 (open). The switch does not cure
  it: the hook's environment block — the colour off and each textconv read as `cat`, by
  `GIT_CONFIG_COUNT` — and the prefix of `SETUP.md`'s history scan move with it, until a
  gitleaks release passes `--no-color` itself. So does the hook's scan apart of the text git
  shows as binary (D6, 2026-10-13): `gitleaks git --pre-commit` reads `git diff` too, and
  "Binary files differ" hides a key in a `*.key binary` from it as from `protect`.
- Decided again (the user, 2026-10-12, D5 on the review's MEDIUM —
  [[2026-10-12-prerequisites-1.6.0]]): the declared minimum becomes 8.18.2, a SECURITY
  minimum — the prerequisite check FAILS below it, or when it cannot read gitleaks'
  version, and the install stops. Read at gitleaks' source: before 8.18.2 the staged scan
  runs `git diff` without `--no-ext-diff`, so a configured external diff replaces what it
  reads; from 8.4.0 to 8.18.1 a scan error ends in "no leaks found" and exit 0; 8.0.0 to
  8.1.3 also write a
  `.gitleaks.toml` into the project, which later releases load instead of their own rules.
  Debian 13 and Ubuntu 24.04 package 8.16.0 (their archives, read on 2026-10-12); Debian's
  build rules set no version, so its binary names none, and the check fails it either way —
  unread, or below. `protect` stays, as D1 decided. Refusing an older gitleaks breaks the
  compatibility v1.5.0 kept: the release is v2.0.0.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision): decided already
  (D1); its trigger above is read in gitleaks' release notes.

### IMP-089 — The history scan misses a key committed in a file marked binary → deferred on 2026-10-13
- Date: 2026-10-13 | Origin: measured in [[2026-10-12-prerequisites-1.6.0]] (task 9, N1's
  family); recorded at the user's request in [[2026-10-13-gate-lenses-2.1.0]]
- Priority: LOW (user decision, 2026-10-13).
- Observed problem: `gitleaks detect`, the one-off history scan of `SETUP.md`'s step 3,
  reads `git log -p`, which shows a file marked `binary` or `-diff` as "Binary files
  differ": a key committed in a `*.key binary` is not found (measured: exit 0, "no leaks
  found"; found without the attribute). `gitleaks detect --no-git --source <path>`, which
  step 3 names, covers only the current content: a key removed since, still in the
  history, stays unseen.
- Proposal: NOT decided — when the trigger comes, scan every committed version of the files
  the project marks binary (their blobs, through `git rev-list --all -- <paths>` and
  `git cat-file`), or say in step 3 how to.
- Expected benefit / risk: a graft's baseline scan reads every committed key. Risk: a scan
  over every version of those files costs time on a long history.
- Resumption trigger: the first graft into a project whose `.gitattributes` marks key files
  as binary.
- Two more gaps of the same scan, from v2.1.0's review ([[2026-10-13-gate-lenses-2.1.0]], L5, read at
  gitleaks' source): it runs `git log -p` without a `--diff-merges` form, so what a merge's
  own resolution introduced is never read; and 8.30.1 adds `--diff-filter=tuxdb`, leaving
  out type changes.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision): the trigger is
  verifiable, and the two projects using the framework are grafted already.

### IMP-090 — The hooks go inert when a hook manager takes core.hooksPath after the install → deferred on 2026-10-13
- Date: 2026-10-13 | Origin: v2.1.0's review, its HIGH H1 — [[2026-10-13-gate-lenses-2.1.0]]
- Priority: MEDIUM (user decision, 2026-10-13).
- Observed problem: `hooks-install.sh` checks `core.hooksPath` at install time only; a hook
  manager sets it again at its next run — husky 9.1.7 at every install it runs, from the
  project's `prepare` script at each `npm install`, unless `HUSKY=0` (read at its source) —,
  and git then reads another directory: the pre-commit's scan and the push boundary stop,
  and nothing says so (measured: a commit holding a key goes through). v2.1.0 declared the
  route and made the installer's refusal say it (`b7e3f09`); the failure stays silent at use
  time. `repo-snapshot.sh`'s list of what it fingerprints reads as complete and leaves out
  the configuration, the hooks, `.git/info`, the staged state and ignored files (L17): H1's
  route leaves its fingerprint unchanged.
- Proposal: NOT decided — make the failure visible: the SessionStart hook warns when
  `core.hooksPath` is set, or when the common hooks directory's pre-push lacks the
  generator's marker; `repo-snapshot.sh` fingerprints `core.hooksPath` and the hooks'
  checksums, or declares what it leaves out.
- Expected benefit / risk: the boundary's loss shows at the next session. Risk: an edit to
  `.claude/settings.json`, a boundary file.
- Resumption trigger: the first project with a hook manager.
- Verified by the user on 2026-10-13: on the user's machines, neither of the two projects
  checked has `core.hooksPath` set or a hook manager configured — at the root or in a
  subdirectory; husky, lefthook, simple-git-hooks.
- A mitigation, the user's decision in v2.1.0, `3359003`: the graft's and the upgrade's
  checklists (`SETUP.md`, *Inherited git hygiene* and Step 4) check `core.hooksPath` and look for a hook
  manager, so the case shows at a graft or an upgrade; the detection at use time stays open.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision): neither project
  using the framework has a hook manager, and the checklists above show the case when one
  appears.

### IMP-095 — The pre-commit's scan apart has three gaps of its own → deferred on 2026-10-13
- Date: 2026-10-13 | Origin: v2.1.0's review, L2, L3 and L4 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: (1) in directory mode gitleaks skips a file whose first bytes match an
  application's signature (`MZ`, `BZh`, `{\rtf`, `%PDF`, …), logged at debug level only —
  read at its source by the reviewer; (2) gitleaks reads `GITLEAKS_CONFIG_TOML` before the
  project's `.gitleaks.toml`, while the scan apart passes `--config` unless
  `GITLEAKS_CONFIG` is set — read at its source; (3) `--diff-filter=ACM` leaves out a type
  change — measured: a symlink turned into a key file marked binary goes through.
- Proposal: NOT decided — a line of text before each copy, so no signature sits at offset 0,
  or the limit declared; `-z "${GITLEAKS_CONFIG_TOML:-}"` with the other condition;
  `--diff-filter=ACMT`.
- Expected benefit / risk: the scan apart reads what it promises. Risk: none.
- Merged on 2026-10-13 (the retro over the backlog — the hooks' LOW findings, applied
  together):
  - IMP-096 — A clean filter's content is not scanned, and a pre-push.local can be skipped
    silently (v2.1.0's review, L1 and L16). A clean filter rewrites the content before it
    reaches the index, so the scan reads the filter's output — under git-lfs a pointer,
    while the content goes to the LFS store unscanned (measured with an LFS-like filter);
    and the generated pre-push skips a `pre-push.local` that is not executable without a
    word — if it is git-lfs's, LFS objects are never uploaded. Direction: say so, or fail,
    when `pre-push.local` exists and is not executable; weigh scanning LFS-tracked paths
    apart.
  - IMP-097 — The pre-push's CLAUDECODE fallback refuses the human in an IDE terminal
    (L7). Claude Code's environment-variable reference (read on 2026-10-13): IDE extensions
    set `CLAUDECODE` in their integrated terminals, so a human pushing from one is refused
    as a Claude Code session; `CLAUDE_CODE_CHILD_SESSION` is set for the Bash, PowerShell
    and Monitor tools and hook commands, not for IDE terminals nor stdio MCP servers.
    Direction: name the IDE terminal in the refusal, with how the human pushes from it, or
    weigh `CLAUDE_CODE_CHILD_SESSION` as the fallback, which loses stdio MCP servers.
  - IMP-098 — A second re-run of the installer overwrites the .bak (L9). `cp "${target}"
    "${target}.bak"` overwrites the `.bak` an earlier re-run left — which happens only when
    a generated hook changes again. Direction: never overwrite an existing `.bak`; number
    the copies, or keep the old one and say where.
  - IMP-101 — Each new case of the hooks' self-test edits the documentation check's
    fixtures (v2.1.0's retro). Two fixtures of `tools/test-docs-check.sh` plant their
    defects by editing the literal case count in `scripts/test-hooks-install.sh`'s header;
    five commits over v2.0.0 and v2.1.0 edited them (`77525a0`, `050b2f5`, `bfd6c90`,
    `bf3879b`, `b7e3f09`). Direction: the fixtures read the current count and plant
    count + 1.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision), as one group:
  the code waits for the next change of a generated hook, so the projects regenerate their
  hooks once; meanwhile v2.2.0 declares the limits where their claims live — the scan's in
  `SETUP.md`'s known limits, a `pre-push.local` that is not executable and the `.bak` a re-run
  writes over (IMP-091), the IDE terminal in `docs/04` (IMP-092). In the group IMP-101 goes
  first: the others add cases to the hooks' self-test.
- Resumption trigger: the first of — a release that changes a generated hook (pre-commit,
  commit-msg or pre-push); a human push refused in an IDE's integrated terminal; a project
  that tracks files with git-lfs. Verified by the user on 2026-10-13: git-lfs is absent from
  both projects using the framework; the IDE terminal is to be confirmed — the user pushes
  from macOS's Terminal.

### IMP-100 — Two latent hardenings: the upgrade check's colour, make's YES → deferred on 2026-10-13
- Date: 2026-10-13 | Origin: v2.1.0's review, L14 and L15 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: (1) `tools/upgrade-check.sh` forces `color.ui` off, which is only
  `color.diff`'s default: a user's `color.diff=always` still colours patch output — latent,
  no check parses a patch today; (2) make imports every environment variable and `$(if)` is
  true for any non-empty value: an exported `YES`, even `0` or `no`, runs `reset-task`
  without its prompt.
- Proposal: NOT decided — `-c color.diff=false`, or `--no-color`; pass `--yes` only for
  `YES=1` given on the command line.
- Expected benefit / risk: a comment that is true, a prompt that cannot be skipped by
  accident. Risk: none.
- Deferred on 2026-10-13 (the retro over the backlog, the user's decision): both latent, each
  waits for the change that makes it bite.
- Resumption trigger: (1) the first check of `tools/upgrade-check.sh` that reads patch
  output; (2) the next change to the `Makefile`'s reset-task line. The `Makefile` is HYBRID:
  that line sits three lines below the `PROTECTED_BRANCHES` slot, and the comment on `YES` is
  the line right above the slot — the change keeps both as they are (IMP-088).

### IMP-111 — Framework reads outside the working directory prompt in every session: a stable read-only rule → deferred on 2026-10-15
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 005, 2026-10-14): a greenfield graft and the following
  deliverables; measured by the user in manual mode in a later, new session
- Observed problem: the upgrade's Precondition makes the agent restate `FW=` and read with
  `git -C "${FW:?}" show <tag>:<file>`. Measured in manual mode: `FW="$HOME/…"`, an absolute
  `FW=`, and a literal `git -C /abs/path show …` ALL ask for confirmation — the cause is git
  run on a repository outside the working directory, not the syntax (the variable forms add
  "A variable in braces … can't be checked before it runs"). The prompt's option "Yes,
  allow reading from <dir> from this project" writes NO rule to any settings file, and in a
  new session, in manual mode, the same literal-path read asked again: the grant is
  session-scoped. (In auto mode reads do not prompt, so the measurement is taken in manual
  mode.)
- Checked against Claude Code's documentation (its *permissions* and *settings* pages, read
  2026-10-14, not measured): `.claude/settings.local.json` is personal, per-project,
  unversioned, above `.claude/settings.json` in precedence, and `permissions.allow` lists
  merge; "A `*` in a Bash rule matches any text, including spaces"; the space before a
  trailing `*` is part of the rule; "A rule must match each subcommand independently" (so
  `| head -1` is covered by head's built-in read-only status); a rule `git push *` does not
  match `git -C . push`, so `-C <path>` must be spelled in the rule; `additionalDirectories`
  grants "file access only". NOT stated by the documentation: that an allow rule silences
  the out-of-directory prompt for `git -C`.
- Trade-off: a permission rule matches the command TEXT, so it matches only a literal path;
  `git -C "${FW:?}" …` never matches and prompts anyway. With a literal path there is no
  variable that can be empty, so the guard of `${FW:?}` (the v1.2.1 collision) has no object
  for those reads.
- Proposal: the graft adds, once, in the project's `.claude/settings.local.json` (personal:
  the path is the user's), under `permissions.allow`, one rule per read command, the
  absolute path written out: `"Bash(git -C /abs/path/to/framework show *)"`,
  `"Bash(git -C /abs/path/to/framework ls-tree *)"`,
  `"Bash(git -C /abs/path/to/framework grep *)"` — nothing wider (never
  `git -C <path> *`, which admits writes). `SETUP.md` §0/§1 give the block; the agent's
  framework reads (Precondition, `docs/04`) use the literal absolute path, which the rules
  can match; `${FW:?}` stays for the human's blocks. `SETUP.md` says "an absolute path, not
  `~`" and warns that `git grep` with an unquoted glob still prompts in manual mode. Before
  applying: measure in manual mode that the rules silence the prompt.
- Note at recording (2026-10-14, the user — lens P1, to be verified, not measured): the
  proposal is not read-only as written. A rule on `git -C <fw> grep *` admits
  `git grep -O<command>`, which runs a command; a rule on `git -C <fw> show *` admits
  `--output=<file>`, which writes a file. `ls-tree` is harmless. The proposal is to be
  narrowed or guarded before it is applied.
- Expected benefit / risk: reads by tag, which the method mandates, stop being the noisiest
  part of every session. Risk: a grant wider than reading — the note above shows that
  `show` and `grep` already are; `git -C` on the clone must never reach a write
  (Precondition rule 1).
- Kin: IMP-050 (points 1-2), IMP-054 (a rule matches text, not the program).
- P1, verified on 2026-10-15 by the retro's agents in git 2.54.0's man pages — read, not
  measured ([[2026-10-15-harvest-retro-3.0.0]]; the verification and the protocol in full in
  the agents' output beside that note): confirmed and widened. A rule on `git -C <fw> show *`
  admits a write (`--output`), launches by flag (`--ext-diff`, `--textconv`,
  `--show-signature`) and by configuration (`log.showSignature`, `gpg.program`), and reads
  past the tag (`:<path>` is the index, `HEAD:` the checkout); one on `grep *` admits a launch
  (`-O`) and the working tree (a grep given no tree); `ls-tree` and `rev-parse` admit neither.
  The home the proposal names, `settings.local.json`, contradicts the "start empty" of
  `docs/04` and of `SETUP.md`'s §2: a definitive rule amends them.
- Deferred on 2026-10-15 (the retro; the user's decision): no definitive rule before the
  measurement, which runs after v3.0.0's tag, in a dedicated session, in manual mode —
  candidates A (allow and deny rules) and B (a fixed prefix closed by `--end-of-options`)
  first, C (a wrapper that validates the tag and the path) only if both fail S2, D
  (`additionalDirectories`) recorded. The protocol, as its verifier corrected it: S1, the
  reads, silent in two fresh sessions; S2, the writes and the launches, prompted or refused;
  S3, the residuals no rule text closes; S4, IMP-112's style cases; a throwaway clone as `FW`,
  every prompt answered No, the checks before and after from the user's own terminal. The
  next upgrade runs with the confirmations.
- Resumption trigger: the measurement run and recorded — a session note with Claude Code's
  and git's versions, each candidate's rules verbatim, a table of case by candidate — and its
  evidence line here; the rule is proposed at the retro that follows.

### IMP-112 — The command style of framework reads (shell functions, long chains) adds prompts → deferred on 2026-10-15
- Date: 2026-10-14 | Origin: [[2026-10-14-test-project-harvest]] — harvest from a test
  project (the project's entry 006, 2026-10-14): a greenfield graft
- Observed problem: the agent wrote framework reads as shell functions
  (`g(){ git -C "${FW:?}" show "<tag>:$1"; }; g …`) and as long `;`/`&&` chains with echo
  separators; Claude Code flagged them ("brace with quote character") and asked
  confirmation for read-only work. In zsh, `echo ======` fails (`=word` is a command-path
  expansion).
- Proposal: `docs/04` (or the upgrade's Precondition) gives a style rule for framework
  reads: one plain `git -C … show <tag>:<path>` per call, no shell functions, no long
  chains; several reads as parallel tool calls.
- Expected benefit / risk: fewer prompts, no loss of safety. Risk: more tool calls.
- Evidence on 2026-10-15 (the retro's agents): zsh's `=word` expansion confirmed in zsh's
  documentation and in the agents' own shell (zsh 5.9, EQUALS on: `echo ======` fails), and an
  unbraced `$t:scripts/…` is read as the `:s` modifier. As written, the rule would contradict
  `SETUP.md`'s own blocks that read the framework in chains that stop at the first failure.
- Deferred on 2026-10-15 (the retro; the user's decision), with IMP-111: its benefit is not
  measured and rides on IMP-111 — in manual mode every read outside the working directory
  prompts. If adopted, a rule for the agent's ad-hoc framework reads only, the procedure's
  blocks exempt.
- Resumption trigger: IMP-111's measurement, with its S4 cases; decided at the same retro.

## Rejected (with the reason — so they are not re-proposed)

### Session-note fields `tokens`, `duration`, `files_touched`, `difficulty` → rejected on 2026-09-23
- User decision within IMP-044 (only `model` and `turns` were added): `tokens` lives in
  the runtime's usage report — duplicating it is redundancy; `duration`/wall-clock is
  infrastructure time, not effort — an illusion of measurement; `files_touched` — git
  already knows it; `difficulty`/`complexity` — `turns` is already the objective proxy,
  and a subjective field would be the invented version of the same datum.

### IMP-023 — CODE_OF_CONDUCT.md and .github/ templates → rejected on 2026-10-13
- Deferred on 2026-07-11: without a real flow of external contributions they were ceremony;
  the trigger was the first issue or PR from a real external contributor, or the decision to
  publicise the repository.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): at the end of this
  cycle the repository becomes private and for personal use (IMP-086), which excludes the
  trigger.

### IMP-027 (the `graft.sh` option) — automated graft script → rejected on 2026-10-13
- Deferred on 2026-07-14: a script automating the graft was premature — collisions are human
  decisions, and the brownfield section of `SETUP.md` had to be tried in the field first; the
  trigger was 2-3 real brownfield grafts.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): with the
  repository for personal use, grafts will be rare and the brownfield section is enough; an
  automation would have no cases to distil.

### IMP-042 — `/change-language` (an automated translation command) → rejected on 2026-10-13
- Deferred on 2026-07-20: a command switching a project's artifact language was premature
  with one manual translation behind; the trigger was 2-3 real manual uses.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): superseded by
  rule 9 (IMP-040, 2026-07-21) — the artifacts are always English and what exists is never
  bulk-translated, so no artifact language is left to switch.

### IMP-048 — Classify file content before rewriting it (prose / values / code-read strings) → rejected on 2026-10-13
- Date: 2026-09-23 | Origin: the upgrade of a client project to v1.2.0 — the distinction
  between prose, values and strings read by code had to be derived a second time, after the
  translation of v1.1.0 (IMP-041).
- Applied in part in v1.4.0 ([[2026-10-10-upgrade-verification-1.4.0]]): rule 9 names the
  section titles and the field labels as format, `SETUP.md`'s edge case 3 (b) carries both
  tables, and the verification script compares the entries after normalising the labels.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): its two observed
  cases are covered — by v1.4.0's part, and by the coherence review's grep of the old and the
  new wording (IMP-043) —, and the general discipline left open has had no occurrence since
  2026-09-23. A third occurrence comes back through a harvest.

### IMP-072 — Mutate the paths, not only the sites → rejected on 2026-10-13
- Date: 2026-10-11 | Origin: [[2026-10-11-payload-purity-1.4.1]] (its retro) — a mutation
  campaign over the 75 report sites of the documentation check read as exhaustive: eight
  detection paths survived unseen, and nineteen more forms the check's comments name were
  never planted.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): covered by the
  Definition of Done's point 10 (IMP-071, v2.1.0) — a list that declares itself complete is
  held against its source, and a campaign's coverage is such a list; v2.1.0 had already left
  this entry out.

### IMP-080 — A guard against uncommitted changes must see what git hides from its diff → rejected on 2026-10-13
- Date: 2026-10-12 | Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro) — in the
  line-end step of `SETUP.md`, `git diff --quiet HEAD` could not see an edit behind
  `assume-unchanged` nor stop `git rm --cached` on a `skip-worktree` entry; `4f9f9ef` fixed
  both with `git ls-files -v`.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): its one site is
  fixed and tested; a general convention with a single occurrence is not motivated.

### IMP-081 — On Git Bash, git counts line ends, not grep → rejected on 2026-10-13
- Date: 2026-10-12 | Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro) — in the CI's
  fourth round a grep for a line-ending `\r` counted no CRLF file on Git Bash; `b8ccbe0`
  moved the count to `git ls-files --eol`, green at the fifth.
- Rejected on 2026-10-13 (the retro over the backlog, the user's decision): the CI on Windows
  caught it and the next round held the fix; a convention adds little.
