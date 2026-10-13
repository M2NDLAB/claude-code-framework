---
type: learnings
updated: 2026-10-13
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
> `- Destination: framework` (a single physical line, so `/harvest-framework` picks
> it up via grep). Omitted = a lesson about this project, which stays in the client.
> It is a DESTINATION attribute, not a level: the lesson stays a Level 2 one — see
> `docs/06-self-improvement.md`, *"The bridge to the framework"*.

## OPEN proposals (awaiting the user's decision)

### IMP-048 — Classify file content before rewriting it (prose / values / code-read strings)
- Date: 2026-09-23 | Origin: no session note in this repo (the trigger, the upgrade of a
  client project to v1.2.0, is recorded in that project) — the prose / values /
  code-read strings distinction had to be re-derived a second time
- Observed problem: when a file is REWRITTEN (a translation, a refactor, a renaming of
  sections), its content is not all of the same nature, and treating it uniformly breaks
  things. It happened twice: (1) the full translation of the framework, v1.1.0
  (IMP-041; [[2026-07-20-language-rule-phase1]], decision 3) — solved ad hoc with the
  "backward-compatible readers" task for the behavior-bearing strings (`[task 2/13]`,
  `91f0ca7`), but the distinction was never formalised as a rule; (2) the upgrade of a
  client project to v1.2.0, where the same distinction was re-derived from scratch.
  The distinction is not ABSENT from the method: it exists FRAGMENTED in four places,
  never as one rule — `SETUP.md` Step 3 (re-apply the project's setup answers on the
  hybrids), `SETUP.md` §2 *Convention (grep visibility)* (a slot on one physical line),
  Step 4's dual-form marker grep, and the coherence review of `docs/01` (section titles
  cited by name are a textual shared contract, IMP-043).
- Nature of the proposal (it changes what the retro decides): UNIFY existing pieces
  into one discipline — not add a rule from scratch.
- Proposal: before rewriting a file, classify its content into three levels and treat
  each one differently:
  1. PROSE (explanations, comments, rationales) → rewritten/translated freely.
  2. VALUES (the answers filled into the setup markers, names and identifiers,
     public-contract entries) → they stay identical; you rewrite the prose AROUND the
     datum, not the datum.
  3. STRINGS READ BY CODE (sentinels, markers, grep patterns, keys) → BYTE-IDENTICAL,
     or you prove on the source that the reader accepts both forms BEFORE changing them.
- Why level 3 is critical: a modified sentinel breaks the mechanism SILENTLY — no error,
  no red test, just a function that stops working (e.g. the command that harvests the
  marked proposals no longer finds them). The same class of silent failure as IMP-020
  (the decorative hook), IMP-031 (the broken markers) and IMP-036 (the 3-way from the
  wrong base).
- Close kin of IMP-043 — to be evaluated at the retro: two faces of the same problem,
  "when you rewrite, some parts of the text are referenced by something else" — IMP-043
  by DOCUMENTS (section titles cited by name), IMP-048 by CODE (strings read by a grep).
  At the retro, EVALUATE WHETHER TO UNIFY them into a single discipline ("before
  rewriting, map what is referenced — by docs and by code") instead of two separate
  rules that say similar things. For that evaluation: IMP-043's first version, a
  MAINTAINED canonical map, was rejected as ceremony ("the map is a grep away"); what
  was applied is a grep in the coherence review.
- Likely placement (to be decided at the retro, not now): `docs/01`, in the discipline
  of the cross-module refactor — where IMP-043 already landed — or the upgrade
  procedure in `SETUP.md`. Both already host one of the fragments above.
- Conditional, not a ritual: it must fire only when a piece of work REWRITES files that
  contain strings read by code, not at every deliverable.
- Expected benefit / risk: the third occurrence starts from ONE written rule instead of
  re-deriving it from four fragments, and a code-read string is checked BEFORE it
  changes instead of breaking the mechanism silently. Risk: a classification step turned
  into a ritual on every rewrite — the conditional trigger above guards it.
- **Evidence from a client harvest — for the unification question** (annotation
  2026-09-26, [[2026-09-26-client-harvest-registration]]; the lesson cites IMP-043 and
  this entry, and IMP-043 is Applied, so it lands here): the translation release broke
  the section titles cited by name between the method and a memory that keeps its
  original language. Verified at v1.2.1: 13 citation sites of the `STATE.md` and
  `LEARNINGS.md` headings in the payload (8 and 5; 19 title mentions), the one with the
  highest stakes being `/checkpoint`'s critical-debt check ("Caution & open issues");
  the 1.1.0 CHANGELOG lists no heading among its behaviour-bearing strings (C12 of
  [[2026-09-24-third-upgrade-lessons]] records that effect). New for the retro:
  1. The reader is the AGENT: every site is prose, and no code greps a memory heading —
     IMP-043's class (cited by documents), not level 3 of this entry; the failure is an
     agent that does not find a heading, not a mechanism that stops silently. The field
     labels `/harvest-framework` collects by name (Origin, Observed problem, …) are the
     same class.
  2. Why IMP-043's check cannot catch it: its old/new grep (`docs/01`, cross-module
     refactor) runs inside the repo being rewritten — at v1.1.0 it would have been
     green, and it only entered in v1.2.0. The broken side is the PROJECT-MEMORY of
     already-grafted projects, across a repository boundary.
  3. The memory invariant forbids the migration: edge case 3 allows only the repair of
     pointers after a doc rename, and Step 5 treats any other memory diff as a bug — so
     a renamed heading cannot be followed inside the memory (a link to IMP-046).
  4. The reverse direction: the project's memory cites METHOD section titles by name,
     nearly all renamed at v1.1.0 (`docs/04`'s *Merge* is the exception); edge case 3, Step 5's lint bullet and `/lint-memory` check 7
     cover renamed files and wikilinks, never titles.
  5. The client's answer — a title map in the technical rules of `CLAUDE.md` (English
     cited name → local heading, the headings frozen as identifiers) — is NOT IMP-043's
     rejected canonical map: "the map is a `grep` away" fails across languages, where
     the two sides share no string. Offering it as the standard answer depends on B8
     (same note): rule 9 lists the memory among the artifacts that are always English.
  Relayed proposal, for the upgrade procedure: (1) the old/new title grep in BOTH
  directions, the project's memory included — `SETUP.md` is already a candidate home
  above; (2) the title map when the memory keeps another language; (3) declaring the
  rebuild — already IMP-050 point 3.
- **Note — moving an answer means checking every entry point** (a lesson of
  [[2026-10-09-quick-fixes-1.3.2]], recorded here at the user's request on 2026-10-10,
  [[2026-10-10-upgrade-safety-1.3.3]]): when a setup answer moves — v1.3.2 moved `reset-task.sh`'s
  protected branches into the `Makefile` — every way of reaching it needs its own check:
  the script run directly, the `make` target, the unattended form an agent uses
  (`YES=1`), the docs that name the command. The reviewer found the third. It is this
  entry's discipline seen from the readers' side: before moving a VALUE (level 2), list
  who reads it. Its upgrade side lands in v1.3.3: a slot that moves to another file
  becomes an edge case of the upgrade.
- **Decision 2026-10-10 on the relayed title map above** ([[2026-10-10-upgrade-safety-1.3.3]], user
  decision 2): NO map. A map is a configurable legacy reader that every present and future
  command would have to consult — permanent complexity against a one-off cost. The section
  titles the commands look up are FORMAT, and format is method: the rename is mandatory at
  the upgrade (edge case 3 (b)), and rule 9 says so from v1.3.3. A project's own tests
  that cite the titles are updated in the same commit, by the project. Relayed proposal
  (1), the title grep in both directions, goes to v1.4.0's verification script (IMP-037).
- **Decision 2026-10-10 on the field labels** ([[2026-10-10-integrate-two-blocks-1.3.4]]): the IMP field
  labels ("Origin", "Observed problem", …) are FORMAT, like the titles — renamed at the
  upgrade with the same table. In v1.4.0, with a constraint on IMP-046's checks: the
  "LEARNINGS body unchanged" comparison runs AFTER normalising the labels by the table,
  or the mandatory rename makes it fail. To measure first, on the client project
  (read-only): how many label lines are involved.
- **Applied in v1.4.0** ([[2026-10-10-upgrade-verification-1.4.0]]): rule 9 names the section titles AND the
  field labels as format; edge case 3 (b) of `SETUP.md` carries both tables; the
  verification script compares the LEARNINGS entries after normalising them (56 label
  lines measured on the client project). The rest of this entry — the classification
  before a rewrite, as one discipline — stays open.

### IMP-051 — The memory lags one merge: `/checkpoint` runs before the merge
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — a post-merge
  reconciliation commit keeps reappearing, and each one is one more local commit to push
- Observed problem: the end-of-deliverable cycle runs `/checkpoint` (step 4) BEFORE
  `/integrate` (step 5), and the merge happens outside the session. So the memory
  records the PRE-merge state ("awaiting merge + tag + push"); `/checkpoint` itself says
  STATE "can be stale" because merges happen outside the session; and the fix is an
  optional later `/checkpoint` (`integrate.md`) — itself a new local commit, one more
  push. Recurring:
  - the client project: 5 reconcile-after-merge commits on its main, and its STATE on
    main is one merge behind TODAY — each reconcile goes through a branch + merge, which
    is again unrecorded, so the lag regresses by one step;
  - this repo (`git log --first-parent main`): four dedicated post-integration
    checkpoints made directly on `main` — `95e43bd` (v0.6.0), `d8d4036` (v0.6.1),
    `b576f37` (v0.6.2), `21ab017` (v1.0.0) — each written with main == origin/main, so
    each left `main` one commit ahead (`d8d4036` records `95e43bd` being pushed with the
    next deliverable); plus the v0.3.0 trailing note (`eaefae3`, merged by `ec59010`)
    and the v1.1.0 CHANGELOG promoted after the merge (`48fe236`). Here it is not STATE
    that lags (a clean template, hybrid regime) but the session notes: their
    "Follow-up: /integrate" is rewritten after the fact — or never, when the next
    deliverable's note absorbs the outcome and the pre-merge follow-up stays as written.
- Already declined once: the v0.3.0 note
  ([[2026-07-17-audit-preintegrate-closeout-v0.3.0]], "Process note (not an IMP)")
  called the trailing note "execution discipline, not a doc gap". The new fact is the
  recurrence — 4 dedicated post-integration checkpoints here since that note (6
  trailing commits in all), and 5 reconcile commits in the client — which makes it
  structural rather than a slip.
- Proposal: NOT decided here (retro). Directions to evaluate: the pre-merge checkpoint
  records the state as it will be once the user runs the printed block (with what to do
  if the user deviates); or `/integrate` puts the reconcile commit INSIDE the user's
  block, so it is pushed with the merge; or the reconcile is declared the FIRST step of
  the next deliverable — the de-facto practice here — so the lag is explicit and bounded.
- Expected benefit / risk: no trailing commit to push after every integration, and a
  memory that is true right after the merge. Risk: recording as done a merge the user has
  not run yet — the recorded state must say it is conditional on the block.

### IMP-052 — Resumption after an abrupt interruption: verify before continuing
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — resuming after a
  session limit or a machine sleep, the protocol says WHERE to resume, not WHETHER the
  resumed state holds
- Observed problem: `docs/01` puts interruptions explicitly in scope (usage limits,
  crashes — and rule 7), and its RESUMPTION reads the plan, confirms the committed tasks
  with `git log` and DISCARDS a dirty tree (`scripts/reset-task.sh`). Missing before
  continuing: a syntax/build check, a test run of the resumed state, a comparison with
  the design or the recorded decision. Committed tasks are verified by construction
  (PHASE 3 verifies before each commit); the unverified window is the uncommitted
  half-task and the plan tick, which may land "right after" its commit. Two gaps
  besides: (a) "verify, then continue" implies KEEPING the half-done work, while step 3
  discards it — the rule has to say when each applies; (b) scope: RESUMPTION runs "at
  the start of EVERY session" and the Cleanup section "if a session dies"; an
  interruption INSIDE the same session (a usage-limit reset or a sleep, then the
  conversation goes on) triggers neither, and for a task without a plan the only rule
  is Cleanup's discard-everything-uncommitted. Evidence in the client project: a
  deliverable with no plan was resumed after a usage limit from the dirty working tree,
  and a wiring gap — all tests green — was "found by comparing the diff with the
  design, not by a test".
- Placement: `docs/01` RESUMPTION, not `/sos` — an escalation that ends in STOP and is
  triggered by being stuck (`docs/05`, *WHEN to produce a report*), not by an
  interruption. A precedent exists: `docs/03` already asks to check COMPLETENESS
  "especially after interruptions or resumes" — for reviews only.
- Proposal: NOT decided here (retro): a short verify-before-continuing step in
  RESUMPTION — `git status`, the build/syntax check, the tests of the touched area, a
  reading of the diff against the design — valid with or without a plan, plus the rule
  for keeping vs discarding the half-done work.
- Expected benefit / risk: a resumed session does not build on a state nobody checked,
  and the wiring gaps that green tests miss are looked for at the moment they are most
  likely. Risk: ceremony on trivial resumptions — scale the check to the size of the
  uncommitted work (none → nothing to verify).
- **Evidence relayed from a client project** (annotation 2026-09-26,
  [[2026-09-26-client-harvest-registration]]): after a resumption, a branch was created
  from the wrong base. Relayed by the user together with the harvest; not found in the
  client's records read for this deliverable (a read-only search of its memory and of
  its commit subjects), so it is recorded as relayed, with no cause attributed. For the
  direction above: RESUMPTION confirms the committed tasks with `git log` on the branch,
  but nothing checks the branch's BASE — a candidate item of the verify-before-
  continuing step (e.g. the branch's merge-base against the base the plan or the
  recorded decision expects).

### IMP-053 — The security-gate verdict is always written, "not applicable" included
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — a skipped gate and a
  forgotten gate look the same in the memory
- Observed problem: `docs/00` (end-of-deliverable step 2) says "If it is not sensitive,
  skip it"; `docs/03` scopes the gate to sensitive components; `/checkpoint`,
  `/integrate` and the session-note format carry no gate line. The practice is
  inconsistent: 4 of the 13 session notes of this repo before this one record "Security
  gate: not sensitive → skipped", the other 9 are silent (the v1.0.0, v1.1.0 and v1.2.0
  notes included). In the client project one note records a not-applicable verdict —
  and one deliverable that touched components on its sensitive list has no gate record
  at all: the memory cannot tell a forgotten review from an inapplicable one, which is
  the case that matters.
- Proposal: NOT decided here (retro): the verdict is written every time, one line with
  the reason — "Security gate: not applicable — <reason>", or the outcome. Natural
  places: the Format block of `sessions/README.md`, the memory step of `/checkpoint`,
  and `docs/00` step 2 ("skip it, and write the one-line verdict").
- Expected benefit / risk: an absent verdict means a forgotten one, by construction, for
  one line per note. Risk: a boilerplate line written without thinking — the mandatory
  reason is what keeps it honest.
- **Evidence from a client harvest — the upgrade** (annotation 2026-09-26,
  [[2026-09-26-client-harvest-registration]]; recorded here and not as an entry of its
  own — the reason is in the note): an upgrade rewrites the security BASELINE —
  `hooks-install.sh` (the gitleaks hook), `settings.json` (the permissions),
  `reset-task.sh` (a destructive guard) — none of them a sensitive component, and the
  upgrade section of `SETUP.md` never names `/security-review` or a verdict: Step 6
  closes with `/checkpoint` and `/integrate` only, skipping steps 2-3 of `docs/00`'s
  cycle. Client-side, relayed: the notes of its two earlier upgrades carry no gate line
  — this entry's skipped-or-forgotten ambiguity. New for the direction above: (1) the
  upgrade (`SETUP.md` Step 5 or 6) as one more place for the one-line verdict; (2) the
  content of its reason, a diff of the EXECUTABLE lines of the baseline scripts —
  measured v1.0.0→v1.2.1: the generated hooks' executable lines identical,
  `hooks-install.sh` changing messages and the hook-ownership test, `reset-task.sh`
  messages only, the allow/deny lists of `settings.json` unchanged — which must keep
  the code-read strings that live in COMMENTS: the hooks' ownership marker is a comment,
  it changed Italian→English, and stripping comments hides exactly the change behind
  IMP-050 point 5's rollback defect (IMP-048, level 3). As a mechanical check it
  belongs with IMP-050 (points 3-4)'s Step 5 inputs. (3) Not a gate matter — a factual
  defect listed in the note for the user's decision: `reset-task.sh` is filed METHOD
  while it carries a setup slot (the protected branches) whose natural answer is
  inline, a predictable hybrid like the setup-customised commands. A plain overwrite is
  not silent (Step 4's marker grep re-surfaces the slot, edge case 7 catches the filled
  one), but the project must then re-answer a slot the §2 checklist never lists.

### IMP-057 — A test invariant over a known debt: a bidirectional allow-list, not an empty set
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project:
  a class invariant made the honest declaration the only way to break the build
- Observed problem (client-side, relayed): after the last two known violations of a
  capability registry were fixed, an invariant was added that scanned the registry and
  FAILED whenever an entry was declared as not honouring the capability. It looked like
  the natural strengthening of "close the class", but it made the honest declaration
  the only move that breaks the build: for a new unit without the capability, the
  fastest way to green is not to fix it but to declare it compliant and mention the
  flag in a comment (the other check was a grep on the file). The test pushed towards
  the lie exactly where the code needs the truth — a summary attests "nothing changed"
  on that very data (IMP-056).
- On the framework's source: `docs/02` (*Tests that demonstrate*) prescribes invariants
  "re-applied BY CONSTRUCTION" — a property over ALL entities, with an anti-vacuity
  check — and says nothing about known exceptions. The lesson QUALIFIES that example:
  when the property is an entity's self-declared flag, introspection over all entities
  measures the declaration.
- Proposal (as relayed; NOT decided here — retro): in `docs/02`, an invariant over a
  set with a KNOWN debt is written as a BIDIRECTIONAL ALLOW-LIST, not as an empty-set
  assertion: (a) an unlisted member that violates the property fails → the debt cannot
  grow silently; (b) a listed member that no longer violates it fails → an exemption
  cannot outlive its fix. General rule: if declaring the truth breaks the build, the
  test is badly designed — it measures the declaration, not the behaviour.
- For the retro: to be reconciled with `docs/02`'s "not as assertions about the state
  known today" — check (b) makes the list a shrink-only register of exemptions, the
  mirror of the anti-vacuity guard (that one guards the scanned set, (b) the list).
  Kin: the bidirectional set comparison of IMP-038 (`/lint-memory` check 11); debts
  kept with their reason (`docs/03`).
- Expected benefit / risk: removes the incentive to lie in the registries that security
  assertions rely on. Risk: an allow-list can become a comfortable parking lot —
  mitigated by check (b) and by a recorded reason for every entry.
- **First use, 2026-10-11** ([[2026-10-11-payload-purity-1.4.1]]): the documentation
  check of v1.4.1 keeps its exceptions this way, each with its reason, an unused one
  failing. Direction (b) proved itself at once: a mutation that silenced the language rule
  was caught on the unchanged repository, because the declared exceptions of the frozen
  memory stopped matching. The `docs/02` rule itself stays open.

### IMP-060 — A delegation brief quotes the user's decisions verbatim; a multi-agent report declares its coverage gaps
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project:
  agents re-opened an already-decided point as "undecided, blocking" because the brief
  paraphrased the decisions
- Observed problem (client-side, relayed): the brief given to the review agents of a
  multi-agent assessment paraphrased only one of the user's decisions and left out
  another one already taken. Several agents and verifiers then treated that decided
  point as "undecided, blocking", and the finding had to be retracted in the report.
  The same run lost 2 of 27 agents to stalls: declaring the uncovered items explicitly,
  and re-checking them by hand, kept the report honest.
- On the framework's source: (a) is absent — `docs/00` (*Scope and session hygiene*)
  has no delegation bullet (the nearest is the effort one), and `docs/05`'s self-sufficient report is the outward
  analogue; (b) exists IN PART — `docs/03`, *Before acting on the findings* (Applied
  IMP-016), is a reader-side completeness check, for reviews only. New: the writer-side
  declaration of the stalled or skipped agents and of the items they left uncovered,
  the re-check by hand, and the extension beyond reviews. The framework practised it
  once without writing it down ([[2026-07-14-registrazione-imp-innesto-brownfield]]).
  A kin case of its own: a brief that carried a wrong factual premise
  ([[2026-09-24-third-upgrade-lessons]], *Problems encountered*, 1) — both show that
  agents take the brief as ground truth.
- Proposal (as relayed — (b)'s placement corrected by the verification, the client put
  both halves in `docs/00`; NOT decided here — retro): (a) a brief for delegated agents
  quotes the user's decisions and constraints VERBATIM, never summarised — a new bullet
  in `docs/00` (*Scope and session hygiene*), or one delegation paragraph shared with
  IMP-055; (b) a multi-agent report declares its coverage gaps explicitly — `docs/03`,
  *Before acting on the findings*, generalised beyond reviews.
- Expected benefit / risk: fewer false findings and no silent coverage holes. Risk:
  longer briefs.

### IMP-061 — `/harvest-framework` re-prints entries already carried upstream: double counts at recording time
- Date: 2026-09-27 | Origin: [[2026-09-26-client-harvest-registration]] — recording a
  client project's harvest, re-harvested lessons were counted twice until the pre-commit
  review caught it
- Observed problem: `/harvest-framework` prints EVERY entry marked
  `Destination: framework`, in any section (step 2: the default perimeter is the whole
  backlog), whether or not it was already carried upstream, and by design it marks
  nothing (step 5): de-duplication is left to human curation (narrow with `$ARGUMENTS`,
  or annotate by hand). The printed block carries no provenance the framework can match
  against what it already recorded: the Origin is anonymised to a generic context. In
  the recording of 2026-09-26, seven of the fifteen harvested entries repeated, in whole
  or in part, lessons already relayed on 2026-09-24 from the same upgrade session;
  nothing in the block said so, and the draft counted three of them as "independent" or
  "second" occurrences — a double count the retro would have inherited — until the
  review caught it ([[2026-09-26-client-harvest-registration]], *Retro* and *Problems
  encountered*, 3). That client's backlog already holds more marked entries than the
  fifteen: a default harvest there re-prints the fifteen with them, unless the human
  narrows it or has annotated them.
- Proposal: NOT decided here (retro). Directions raised in the origin note, to evaluate:
  (a) a "carried upstream" mark on the client's entry (e.g. a line added by the human
  after the transfer, which the default perimeter then skips — the command itself stays
  read-only, IMP-033's boundary); (b) a matchable provenance in the printed block (the
  source session's date, the client's entry number), still anonymous; (c) on the
  framework side, a "count once" check at recording time against the lessons already
  recorded — practised by hand on 2026-09-26, written nowhere.
- Expected benefit / risk: a re-harvested lesson is recognised as such, so the retro
  weighs each lesson once. Risk: (a) adds a line to the IMP format, a backlog-format
  change that reaches client projects only through the upgrade — and the format comment
  of `LEARNINGS.md` sits under IMP-046's contradiction; (b) must stay anonymous
  (`docs/04`, shared history).

### IMP-062 — Cover remote writes through `gh` in the agent boundary
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

### IMP-063 — A fan-out has a stall cost: one independent reviewer first
- Date: 2026-10-07 | Origin: [[2026-09-27-imp-054-055-agent-git-boundary]] — the
  multi-agent review runs were the block's costliest failures, while one reviewer found a
  HIGH the prototype phase had missed
- Observed problem: in phase 1 the pre-note review workflow (3 reviewers, then 3
  skeptics) stalled: its agents were interrupted and restarted repeatedly, and after about
  an hour 0 of 3 reviewers had returned; it was stopped and the proposal reached the user
  with that coverage gap declared. The user then capped the block: one reviewer, "non un
  workflow grande: due workflow in questo blocco si sono già bloccati" (the note records
  one outright stall; the user's count is two). In phase 2 ONE reviewer returned in about
  20 minutes with 1 HIGH and 5 MEDIUM, all reproduced. `docs/03` says WHEN the verifier
  must not be the author and how to reconcile a multi-agent review's counts; nothing says
  how many agents, nor what to do when they stall.
- Proposal: NOT decided here (retro). Direction: `docs/03` (or the delegation bullet of
  IMP-060 (a)) — one independent reviewer first; a fan-out only where the blast radius
  warrants it, with an explicit stall budget (a time after which the run is stopped and
  its gap declared — IMP-060 (b)).
- Expected benefit / risk: fewer hours lost to stalled runs. Risk: one reviewer brings one
  lens — the fan-out stays available, budgeted.

### IMP-064 — Probing Claude Code's permissions in an untrusted workspace measures the wrong thing
- Date: 2026-10-07 | Origin: [[2026-09-27-imp-054-055-agent-git-boundary]] — the first
  phase-1 probe matrix would have "proved" a deny rule effective
- Observed problem: a `claude -p` session started in a directory never trusted
  interactively IGNORES the project's `permissions.allow` (stderr: "Ignoring N
  permissions.allow entries from .claude/settings.json: this workspace has not been
  trusted"), while deny rules and hooks stay active. The first matrix showed every push
  form denied — as NOT ALLOWED, not by the deny rule — and only the denial messages and
  stderr told the two apart. Fixed by putting the allow in `settings.local.json`, which is
  honoured.
- Proposal: NOT decided here (retro). Direction: wherever the method verifies permissions
  or hooks with nested sessions (a boundary's end-to-end check, an upgrade's), the probe
  declares its trust shape — the allow in `settings.local.json` — classifies each denial
  (rule match, not allowed, hook) and reads stderr. Home: `docs/02` (*Tests that
  demonstrate*) or `docs/03`.
- Expected benefit / risk: a permission probe cannot pass for the wrong reason. Risk: none.

### IMP-065 — Edit the method's own files with the file tools, so the checkpoints that guard them apply
- Date: 2026-10-07 | Origin: [[2026-09-27-imp-054-055-agent-git-boundary]] — the session
  edited `.claude/` both with the file tools and through Python one-offs
- Observed problem: `.claude/` is a protected path for Claude Code's file tools (writes are
  never auto-approved: prompted, or routed to the classifier in auto mode), and since
  v1.3.0 `ask` rules guard `settings.json` and `scripts/agent-git-guard.mjs` — both apply
  to the built-in file tools only. In the IMP-054/055 block some `.claude/` edits went
  through Python one-offs (IMP-061; the review's `docs/04` fixes; the LEARNINGS move; parts
  of the session note), which no checkpoint sees. Nothing went wrong — the writes were the
  requested work — but the same habit on `settings.json` or on the guard would skip the
  very checkpoint D6 added. Contributing factor: the auto-mode instruction to prefer the
  shell for file changes.
- Proposal: NOT decided here (retro). Direction: one line in `docs/04` (*Permission
  configuration*, next to the `ask` bullet) or `docs/02`: the method's own files are edited
  with the file tools; a shell write to them is a slip to report.
- Expected benefit / risk: the checkpoints guard what they claim to. Risk: more prompts in
  auto mode.

### IMP-067 — The framework in headless mode (`claude -p`, CI) and via the Claude Agent SDK
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

### IMP-072 — Mutate the paths, not only the sites
- Date: 2026-10-11 | Origin: [[2026-10-11-payload-purity-1.4.1]] (its retro), recorded at
  the user's request in [[2026-10-11-multiplatform-1.5.0]]
- Observed problem: a mutation campaign that disabled each of the 75 report sites of the
  documentation check read as exhaustive and was not: a detection path that feeds a site
  another planted defect already reaches survives unseen. Eight did, found by the
  reviewer's second pass; an inventory of the forms the check's comments name then found
  nineteen more that no case planted.
- Proposal: NOT decided. Where a test claims to cover a rule's forms, each form is mutated
  — each alternative of a detection pattern, each branch —, not only each report site; the
  inventory of the forms the code advertises is the campaign's input. The candidate place:
  `docs/02`, *Tests that demonstrate*.
- Expected benefit / risk: a green campaign means what it says. Risk: campaigns cost more
  runs.
- In v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]) the mutants of the review's fixes settled
  which guards to keep: two proved needed — without the check of `GIT_CONFIG_COUNT`, bash
  3.2 went on past an arithmetic error in an `export`; without `|| true`, git dying of a
  closed pipe failed the pre-commit with 141 —, and the explicit signal traps proved
  redundant, since bash runs the EXIT trap on INT, TERM and HUP, and were left out.

### IMP-074 — The bump is fixed by the brief before the content
- Date: 2026-10-11 | Origin: [[2026-10-11-multiplatform-1.5.0]] — the user's brief; the
  reviewer's L1 in [[2026-10-10-upgrade-safety-1.3.3]] and L14 in
  [[2026-10-11-payload-purity-1.4.1]]
- Priority: MEDIUM (user decision, 2026-10-11) — the process block.
- Observed problem: v1.3.3 and v1.4.1 brought new rules into the payload — MINORs by the
  criteria of `docs/04`, *Versioning* — and shipped as PATCHes, because the user's brief
  had fixed the bump before the content existed. The reviewer flagged it both times; both
  times the brief prevailed, and the version undersold what the release did.
- Proposal (the user's): the brief states the EXPECTED bump; `/integrate` computes it again
  from the commits with the criteria of `docs/04`; where the two diverge, the criteria of
  `docs/04` win, and `/integrate` says so before the tag and asks the user to confirm.
- Expected benefit / risk: the version says what the release does. Risk: a brief's
  expectation overridden — by design, and never without the user's confirmation.
- In practice, v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]): the brief expected a MINOR;
  the review's MEDIUM, decided by the user as a security minimum that refuses a gitleaks
  v1.5.0 accepted, made the release breaking. The bump was computed again by `docs/04`,
  declared a MAJOR before the tag, and confirmed by the user.
- An occurrence in v2.1.0, pointed out by the user on 2026-10-13
  ([[2026-10-13-gate-lenses-2.1.0]]): the commits that apply IMPs as `docs/06` says are typed
  `chore`, and here they carry the new rules of `docs/02` and `docs/03` into the payload.
  With the release's one `fix`, a bump computed from the types alone comes out a PATCH,
  while by `docs/04`'s criteria a new rule in the payload is a MINOR. The user's instruction:
  `/integrate` computes the bump on the content — the new rules in the payload —, not only on
  the commits' types, and declares its reasoning before the tag; v2.1.0 expected.

### IMP-075 — Auto mode and the framework's boundaries
- Date: 2026-10-11 | Origin: [[2026-10-11-multiplatform-1.5.0]] — the user ran
  `/auto-mode-setup` on 2026-10-11
- Priority: MEDIUM (user decision, 2026-10-11).
- Observed problem: from Claude Code's documentation (https://code.claude.com/docs/en/auto-mode-config,
  read on 2026-10-11): auto mode allows pushes to any branch of the working repository,
  the default branch included; content-scoped `permissions.ask` rules are evaluated before
  the classifier and always prompt, but a push written another way (`git -C <dir> push`,
  `git -c <key>=<value> push`) does not match them; the classifier reads `autoMode` only
  from the user's and the managed settings (and `--settings`), never from a project's
  `.claude/settings.json` or `settings.local.json`. So `/auto-mode-setup`, run in a
  repository, drafts entries from that repository and writes them into
  `~/.claude/settings.json`, which holds for every project. Observed: the trusted
  repository and the framework's visibility applied to all projects, and a false
  statement about the classic protection of `main`; the user corrected the file.
- Proposal (the user's): in `docs/04` and in *Hardening* of the framework's `SETUP.md` —
  (1) the `pre-push` stays the boundary on the push in auto mode too; (2) a recipe of ask
  rules as a net for the common case, with its limit; (3) a warning: auto mode's
  environment is per user, to be written in a form true for every repository.
- Weighed against IMP-067: kept apart. IMP-067 measures which of the framework's
  mechanisms LOAD in non-interactive modes (`claude -p`, `--bare`, CI, the Agent SDK);
  this one states what HOLDS in an interactive permission mode, from the documentation,
  with a text ready. They meet in one place — the Agent SDK and `--settings` carry
  `autoMode` inline —, which IMP-067's probes should cover.
- Expected benefit / risk: a user of auto mode knows which boundary stops a push, and
  writes an environment that does not leak one repository's facts into the others. Risk:
  none.

### IMP-077 — gitleaks `protect` is deprecated
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

### IMP-078 — commitlint reads a body line that starts with "word:" as the footer
- Date: 2026-10-11 | Origin: [[2026-10-11-multiplatform-1.5.0]] — observed four times
- Priority: LOW (user decision, 2026-10-11).
- Observed problem: twice a commit's body had a line that began with a single word and a
  colon — "repository:" in the CHANGELOG commit of v1.4.1, amended while it was still
  local ([[2026-10-11-payload-purity-1.4.1]]), and "measured:" in `e6597f1` of v1.5.0,
  left as it is because the branch was public — and a third time on the same day, while
  this entry was being written: "was:" in a commit of the CI's second round, written
  again while it was still local. Each time the commit-msg hook warned "footer must have
  leading blank line". How commitlint recognises a footer, checked:
  its documentation and its parser's (the README and the API page of
  conventional-commits-parser) list `noteKeywords`, `referenceActions`, `issuePrefixes`
  and `fieldPattern` without saying when a line opens the footer; the parser's source
  does — conventional-commits-parser 7.1.3, the version the hook's npx fetched,
  `dist/regex.js`, `getFooterTokenRegex`: "Footers follow the git trailer convention: the
  token starts at the beginning of the line, indented `key: value` lines are not
  footers", the pattern `^(?:BREAKING CHANGE|[\w-]+)(?::\s+|\s+#).+`, case-insensitive;
  from that line on, everything is footer. Measured with that parser: "measured: …" and
  "repository: …" open the footer and cut the body there; "the step: …" (two words), an
  indented line and "measured:" without a space do not. `@commitlint/config-conventional`
  21.2.3 sets `footer-leading-blank` to a warning, which `commitlint.config.cjs` does not
  override.
- Proposal: NOT decided — two options: (a) one line in `docs/04`, *Commit format*: in the
  body, no line begins with a single word and a colon; (b) `commitlint.config.cjs`:
  `footer-leading-blank` raised to an error, so the hook refuses such a commit while it
  is still local and its message can still be written again.
- Expected benefit / risk: the body stays whole in the parsed history, and no published
  commit carries the warning. Risk of (b): an error in every project's commit-msg hook
  where a warning was — for a footer typed without its blank line too.
- A fourth time, at v1.5.0's checkpoint: "projects:" opened a wrapped body line; the
  commit was written again while still local.
- A fifth time, in v2.0.0's review fixes ([[2026-10-12-prerequisites-1.6.0]]): "source:"
  opened a wrapped body line of the breaking commit; written again while still local, as
  `5f05004`.
- A sixth time, in v2.1.0 ([[2026-10-13-gate-lenses-2.1.0]]): "diff:" opened a wrapped body line of task 3's
  commit, written again while still local. From then on each message was checked before its
  commit with a grep for a body line opening with a word and a colon.

### IMP-079 — A parser of another shell's syntax covers the forms it was held against, not the language
- Date: 2026-10-12 | Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro), recorded at
  the user's request in [[2026-10-12-prerequisites-1.6.0]]
- Observed problem: v1.5.0's task 5 taught the guard PowerShell's syntax. Its mutants
  proved each piece of the reading (8 of 8); none could prove its coverage, and the
  reviewer got 15 of 19 ordinary forms through — an assignment, a script block, a
  here-string. IMP-071's shape, a new occurrence: "ordinary forms" claimed against the
  cases written, not against the language.
- Proposal: NOT decided. Before a parser of another language's syntax claims a coverage,
  its cases are held against the language's own list of constructs, the claim's source.
  IMP-083 pulls the other way — which forms the guard must know at all —: weigh the two
  together.
- Expected benefit / risk: a claim of coverage that holds. Risk: more cases to write and
  keep.
- An occurrence in bash, from v2.1.0's review ([[2026-10-13-gate-lenses-2.1.0]], L6, read at the guard's
  source): the guard passes git inside an unquoted heredoc's `$(…)` or backticks, which bash
  expands; a function defined with the `function` keyword; a `coproc`; and a command name
  held in a variable (`$GIT`) — its comment says it does no expansion, `docs/04` does not.

### IMP-080 — A guard against uncommitted changes must see what git hides from its diff
- Date: 2026-10-12 | Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro), recorded at
  the user's request in [[2026-10-12-prerequisites-1.6.0]]
- Observed problem: the line-end step of `SETUP.md` was to refuse a change not yet
  committed, never erase it (the user's request in v1.5.0). `git diff --quiet HEAD` cannot
  see an edit behind `assume-unchanged`, nor stop `git rm --cached` halfway on a
  `skip-worktree` entry. The review found both, the probes measured them, and `4f9f9ef`
  fixed them with `git ls-files -v`.
- Proposal: NOT decided. A step that refuses to overwrite uncommitted work reads the
  index's marks (`git ls-files -v`: a lowercase tag for assume-unchanged, `S` for
  skip-worktree) as well as the diff. Where to write it — the conventions of the
  framework's procedures, or `docs/02` — is to be decided.
- Expected benefit / risk: no step erases what it promised to keep. Risk: none.

### IMP-081 — On Git Bash, git counts line ends, not grep
- Date: 2026-10-12 | Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro), recorded at
  the user's request in [[2026-10-12-prerequisites-1.6.0]]
- Observed problem: in the CI's fourth round a grep for a line-ending `\r` counted no CRLF
  file on Git Bash; in the fifth, git counted them in the same kind of clone
  (`core.autocrlf=true`). The red was the test's, not the product's: `b8ccbe0` moved the
  count to `git ls-files --eol`.
- Proposal: NOT decided. A test that must know a file's line ends asks git
  (`git ls-files --eol`) or reads the bytes, never greps for `\r$`. The candidate place:
  the conventions of the framework's self-tests (`scripts/README.md`, `tools/README.md`).
- Expected benefit / risk: line-end tests that mean the same on every platform. Risk:
  none.

### IMP-082 — The whole suite before each commit, the documentation check included
- Date: 2026-10-12 | Origin: [[2026-10-11-multiplatform-1.5.0]] (its retro), recorded at
  the user's request in [[2026-10-12-prerequisites-1.6.0]]
- Observed problem: a prose edit in `SETUP.md` passed the self-test that reads its block and
  failed the documentation check — caught after the commit, amended while it was still
  local.
- Proposal: NOT decided. Before each commit of the framework the whole suite runs —
  `make test-scripts`, the documentation check included, and the upgrade check's
  self-test —, not only the self-test of the file touched. The candidate place:
  `CONTRIBUTING.md`, *This repo's workflow*.
- Expected benefit / risk: no commit that the CI or the next commit finds red. Risk: a few
  minutes per commit.
- An occurrence in v2.0.0 ([[2026-10-12-prerequisites-1.6.0]]): two commits that moved
  IMPs to Applied went in after the documentation check alone; the check's self-test,
  whose plant was anchored on a line the move dropped, failed, and the checkpoint's commit
  followed, its command not gated on the suite's exit. All local: rebuilt, each after a
  green suite. Gating the commit on the suite in the same command (`make test-scripts &&
  git commit …`) would have stopped it.

### IMP-083 — The guard grows beyond its threat model
- Date: 2026-10-12 | Origin: the user's request at v1.5.0's integration (2026-10-11), from
  [[2026-10-11-multiplatform-1.5.0]]; recorded in [[2026-10-12-prerequisites-1.6.0]]
- Priority: MEDIUM (user decision, 2026-10-11) — the process block.
- Observed problem: in v1.5.0 the guard learned non-ordinary PowerShell forms —
  here-strings, block comments, `${name}` — while the PowerShell tool is off by
  `CLAUDE_CODE_USE_POWERSHELL_TOOL=0`; v1.3.0's threat model covers an agent's accidental
  errors made with ordinary commands (`docs/04`, *Enforcement of the execution boundary*).
  `scripts/agent-git-guard.mjs` counts 234 lines at v1.3.0, 238 at v1.3.1, 239 from v1.3.2
  to v1.4.1 and 309 at v1.5.0 (`db1fc77` +35 −21, the review's fix `ceac061` +69 −13).
- Proposal (the user's): at a retro, review each form the guard recognises against that
  criterion, remove what is not needed, and fix an admission rule for future forms: only
  forms observed, or ordinary ones. Weigh it with IMP-079, which asks the opposite of a
  parser's claim of coverage.
- Expected benefit / risk: a guard as large as its job. Risk: a form removed that a
  developer with the PowerShell tool on would use — the tool is off by default.

### IMP-085 — The framework's files kept out of deploy artifacts
- Date: 2026-10-13 | Origin: the user's question, 2026-10-13 — recorded in
  [[2026-10-12-prerequisites-1.6.0]]
- Priority: LOW (user decision, 2026-10-13).
- Observed problem: the framework serves during development only, but its files —
  `CLAUDE.md`, `.claude/` with the project's memory, the scripts, the `Makefile` — sit in
  the project's repository. A deploy that copies the whole repository (a `COPY . .` into an
  image, for one) carries them into production, the project's memory included.
- The first check, made when recording it (2026-10-13): no page says it. `SETUP.md`,
  `CLAUDE.md`, `.claude/docs/`, `README.md` and `CONTRIBUTING.md` searched for deploy,
  production, docker, image, container, artifact and exclude: only the technical rules'
  slot for the production artifact's format and `docs/02`'s Definition of Done, point 9,
  neither about the framework's own files.
- Proposal: NOT decided — and only because it is missing: one line of principle, agnostic
  to the stack, in `SETUP.md` (its *Hardening* section, for one): keep the framework's
  paths out of deploy artifacts with the stack's own mechanism; the list of those paths
  derives from the class table (`tools/upgrade-check.sh classes <tag>`, `SETUP.md`, *The
  mental model: the classes of file, and the graft state*). No exclusion file in the
  payload: such files depend on the stack and stay the project's.
- Expected benefit / risk: a project's memory and process files do not reach production
  through a copy of the whole repository. Risk: none — a line of principle.
- Resumption trigger: the next release that touches `SETUP.md`'s *Hardening*, or the
  retrospective over the backlog.

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

### IMP-088 — A change next to a setup slot conflicts at every project's upgrade
- Date: 2026-10-13 | Origin: task 10 of v2.0.0, the upgrade rehearsed on the final payload —
  [[2026-10-12-prerequisites-1.6.0]] (the retro)
- Observed problem: the block that scans the text git shows as binary was inserted right
  after the pre-commit's protect line, and ended next to the formatting slot's line, which
  every project answers at setup: the 3-way merge of `hooks-install.sh` conflicted, 41 of
  311 lines, for every such project. Only the release's rehearsal found it, after three
  green CI rounds: the upgrade check measures the 3-way at a project's upgrade, nothing at
  the framework's commit.
- Proposal: NOT decided. At each commit that touches a HYBRID file, measure its 3-way merge
  from the latest tag against a copy whose every slot is answered — the slots the
  documentation check already knows, `SETUP.md` §2 —, in the framework's own checks; or,
  lighter, a rule in `CONTRIBUTING.md`: a change keeps unchanged lines between itself and a
  slot's line, and the release's rehearsal stays the backstop.
- Expected benefit / risk: the conflict shows at the commit that makes it. Risk: a fixture
  of answered slots to keep, or a rule no check holds.

### IMP-089 — The history scan misses a key committed in a file marked binary
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

### IMP-090 — The hooks go inert when a hook manager takes core.hooksPath after the install
- Date: 2026-10-13 | Origin: v2.1.0's review, its HIGH H1 — [[2026-10-13-gate-lenses-2.1.0]]
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

### IMP-091 — The commits git creates itself skip the pre-commit
- Date: 2026-10-13 | Origin: v2.1.0's review, M1 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: git runs the pre-commit only from `git commit`. A rebase's `--continue`
  commits a conflict's resolution through the sequencer with `-n` (measured: a key pasted
  into the resolution is committed; git's sequencer.c read by the reviewer); `git am` runs
  pre-applypatch instead; a cherry-pick or a revert commits in-process. The framework's
  own merge step resolves conflicts in `git rebase origin/<integration>` (`docs/04`,
  `/integrate`'s block 1). `docs/03`'s baseline — "on every commit … always, without
  exceptions" — and `CLAUDE.md`'s rule 1 claim more.
- Proposal: NOT decided — narrow the claims (the scan runs on `git commit`; the commits git
  creates itself are not scanned) in `docs/03`, `CLAUDE.md` and `SETUP.md`'s known limits;
  weigh compensating at publication — gitleaks over the range about to go public, in
  `/integrate`'s block 1 or in the pre-push.
- Expected benefit / risk: the baseline says what it covers; a compensation would close the
  route. Risk: a scan at publication repeats work on every push.
- Partly applied on 2026-10-13, the user's decision after v2.1.0's review: the claims
  narrowed — `docs/03`'s baseline says what the hook does and declares this limit,
  `CLAUDE.md`'s rule 1 points to it. Measured then on git 2.54.0 with a marker hook: a
  cherry-pick or a revert that applies cleanly, `git am` and a rebase's `--continue` after
  a conflict do not run the pre-commit; a cherry-pick's `--continue` after a conflict and a
  merge concluded by `git commit` do; a clean merge runs `pre-merge-commit` instead. Still
  open: `SETUP.md`'s known limits and a compensation at publication.

### IMP-092 — Claude Code's permission flow can replace the guard's verdict and the ask rules
- Date: 2026-10-13 | Origin: v2.1.0's review, M2 and I1 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem (read by the reviewer in Claude Code's documentation, 2026-10-13): a mod
  that handles `tool.check` — mods are on by default — answers after the rules and the
  PreToolUse hooks and can approve a call a hook blocked, unless the hook sits in managed
  settings, and what an ask rule would prompt for; a PermissionRequest hook can answer an
  ask prompt; `disableAllHooks: true`, the switch the documentation gives for stopping mods,
  also stops the guard and the SessionStart hook. `docs/04` says the guard's verdict "always
  stands" and that the boundary's files "always" ask. I1: a command hook's
  `"onFailure": "block"` (Claude Code 2.1.295 or later) now offers the off-switch for the
  fail-open `docs/04` declares, and would block the main session too on any failure, which
  `docs/04`'s design avoids.
- Proposal: NOT decided — declare the three routes in `docs/04` (the fail-closed bullet,
  the ask bullet, the guard's row); weigh `"disableAllHooks": false` in the project's
  `settings.json`, which overrides a user's `true`; weigh `onFailure` at a retro.
- Expected benefit / risk: the boundary's claims hold against Claude Code's own extension
  points. Risk: pinning a setting the user may have chosen.

### IMP-093 — Delegated agents can write git state outside the guard's matcher
- Date: 2026-10-13 | Origin: v2.1.0's review, M3 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem (read in Claude Code's documentation by the reviewer): the
  EnterWorktree tool, available to subagents, creates a worktree on a new branch in the
  shared repository, and ExitWorktree with `remove` deletes the worktree and its branch; a
  project's MCP git server (commit, checkout, reset) is the same class. The guard matches
  `Bash|PowerShell|Monitor`; none of these is blocked or declared.
- Proposal: NOT decided — extend the matcher to `EnterWorktree|ExitWorktree` and refuse them
  for an input with `agent_id`, or declare them, with MCP git tools, in `docs/04`'s "Outside
  this layer".
- Expected benefit / risk: the read-only rule holds for the tools Claude Code gives
  delegated agents. Risk: a matcher to keep in step with Claude Code's tools.

### IMP-094 — reset-task.sh leaves a staged change in the working tree, and reports success
- Date: 2026-10-13 | Origin: v2.1.0's review, M4 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: `git restore .` restores the working tree FROM THE INDEX, and only then
  does `git restore --staged .` reset the index: a staged change survives as an unstaged
  one, yet the script reports the task discarded (measured: staged B, then C in the working
  tree; afterwards ` M f`, the file holding B). Both restores swallow their errors, and no
  self-test covers the script; `docs/01`'s manual form leaves staged changes staged.
- Proposal: NOT decided — `git restore --source=HEAD --staged --worktree -- .`, errors not
  swallowed, a self-test with a staged change, `docs/01`'s manual form corrected.
- Expected benefit / risk: a resumption restarts from a clean task, as `docs/01` promises.
  Risk: none.

### IMP-095 — The pre-commit's scan apart has three gaps of its own
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

### IMP-096 — A clean filter's content is not scanned, and a pre-push.local can be skipped silently
- Date: 2026-10-13 | Origin: v2.1.0's review, L1 and L16 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: a clean filter rewrites the content before it reaches the index, so the
  scan reads the filter's output — under git-lfs, which the framework anticipates
  (`pre-push.local`), a pointer, while the content goes to the LFS store unscanned
  (measured with an LFS-like filter). And the generated pre-push skips a `pre-push.local`
  that is not executable without a word; if it is git-lfs's, LFS objects are never
  uploaded.
- Proposal: NOT decided — declare the filter's limit in `SETUP.md`'s known limits, and weigh
  scanning LFS-tracked paths apart; say so, or fail, when `pre-push.local` exists and is not
  executable.
- Expected benefit / risk: the known limits are complete for LFS projects. Risk: none.

### IMP-097 — The pre-push's CLAUDECODE fallback refuses the human in an IDE terminal
- Date: 2026-10-13 | Origin: v2.1.0's review, L7 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: Claude Code's environment-variable reference (read on 2026-10-13) says
  IDE extensions set `CLAUDECODE` in their integrated terminals: a human pushing from VS
  Code's terminal is refused, the refusal naming a Claude Code session. The same reference
  documents `CLAUDE_CODE_CHILD_SESSION`, set for the Bash, PowerShell and Monitor tools and
  hook commands, not for IDE terminals nor stdio MCP servers.
- Proposal: NOT decided — name the IDE terminal in `docs/04` and in the refusal, with how the
  human pushes from it; or weigh `CLAUDE_CODE_CHILD_SESSION` as the fallback, which loses
  stdio MCP servers.
- Expected benefit / risk: the human is not refused as an agent. Risk: a marker that covers
  less.

### IMP-098 — A second re-run of the installer overwrites the .bak
- Date: 2026-10-13 | Origin: v2.1.0's review, L9 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: `cp "${target}" "${target}.bak"` overwrites a `.bak` left by an earlier
  re-run: a customisation saved once is lost the next time the hook differs.
- Proposal: NOT decided — never overwrite an existing `.bak`: number the copies, or keep the
  old one and say where it is.
- Expected benefit / risk: a saved customisation survives. Risk: `.bak` files accumulate.

### IMP-099 — The platform the check names as verified is wider than the CI's images
- Date: 2026-10-13 | Origin: v2.1.0's review, L13 — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: `check-prerequisites.sh` calls any non-WSL Linux on x86_64 a platform the
  CI verifies; the CI runs Ubuntu 24.04 only, and `SETUP.md` says other distributions are not
  verified. The same holds for other macOS and Windows versions against the named images.
- Proposal: NOT decided — name what was verified ("x86_64, verified on Ubuntu 24.04"), or
  read `/etc/os-release`; the self-test changes with it.
- Expected benefit / risk: the line claims what the CI shows. Risk: none.

### IMP-100 — Two latent hardenings: the upgrade check's colour, make's YES
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

### IMP-101 — Each new case of the hooks' self-test edits the documentation check's fixtures
- Date: 2026-10-13 | Origin: v2.1.0's retro — [[2026-10-13-gate-lenses-2.1.0]]
- Observed problem: two fixtures of `tools/test-docs-check.sh` plant their defects by editing
  the literal case count in `scripts/test-hooks-install.sh`'s header ("Six cases:" to "Seven
  cases:") and expecting a message that names the counts. Every case added to that self-test
  breaks both: five commits over v2.0.0 and v2.1.0 edited them (`77525a0`, `050b2f5`,
  `bfd6c90`, `bf3879b`, `b7e3f09`), `050b2f5`'s after the suite ran red.
- Proposal: NOT decided — the fixtures read the current count from the header and plant
  count + 1, so a new case touches only the self-test it belongs to.
- Expected benefit / risk: a new case is one change, not three. Risk: none.

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

### IMP-042 — `/change-language` (an automated translation command) → deferred on 2026-07-20
- User decision (language deliverable, phase 1): DEFER — the same anti-hype filter as
  IMP-027 (`graft.sh`) and IMP-037 (`/upgrade-framework`). A command that automates
  switching a project's artifact language (or grafting the framework into a
  non-English context) is premature with a single manual translation behind us: the
  common pattern is not yet distillable.
- Resumption trigger: after 2-3 real manual uses (full translations or language switches
  performed by hand), when the repeatable steps are distillable from practice. The
  framework's own translation (IMP-041) is case #1, now completed.

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

## Rejected (with the reason — so they are not re-proposed)

### Session-note fields `tokens`, `duration`, `files_touched`, `difficulty` → rejected on 2026-09-23
- User decision within IMP-044 (only `model` and `turns` were added): `tokens` lives in
  the runtime's usage report — duplicating it is redundancy; `duration`/wall-clock is
  infrastructure time, not effort — an illusion of measurement; `files_touched` — git
  already knows it; `difficulty`/`complexity` — `turns` is already the objective proxy,
  and a subjective field would be the invented version of the same datum.
