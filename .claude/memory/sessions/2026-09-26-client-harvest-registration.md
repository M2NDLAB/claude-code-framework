---
date: 2026-09-26
task: deduplicate, verify on the source and record the 15 entries a client project harvested with /harvest-framework — IMP-055..060 recorded, IMP-046/048/050/052/053 and the Applied IMP-050 (points 1-2) annotated, two duplicates of factual defects and new defect candidates listed for the user
branch: main
status: completed
model: 'claude-opus-5-5'
turns: 2
tags: [session, imp, harvest, verification]
---
# Session 2026-09-26 — A client project's harvest: verification and recording

> Verification + recording only (user constraint): nothing applied, no `docs/`, no
> `SETUP.md`, no `plans/` (hybrid regime). Two files, so no plan block. The client
> wrote its entries reading the framework through v1.2.0, so it did not know IMP-049..054
> nor the v1.2.1 fix — IMP-048 it knew only because the framework's working tree had
> moved past v1.2.0 during its assessment (the moved HEAD of its own "read by tag"
> lesson). Each entry was verified on the source (v1.2.1 = `main` = `77e0dfb`) BEFORE
> being classified. The block arrived damaged by a terminal (`[…]`): the meaning was
> recovered, read-only, from the client's own backlog, then anonymised and translated.
> The Origin of each new entry (IMP-055..060) says "harvest from a client project", per
> the user's wording.
>
> **Provenance — count once.** Client 012-021 were written in the SAME upgrade session
> (the client's third, v1.0.0 → v1.2.0) whose lessons were relayed and recorded on
> 2026-09-24 ([[2026-09-24-third-upgrade-lessons]]): where they match a lesson recorded
> then (B4/B5, B7, B9, B10, C11, C12, C13), they are the same lesson RE-HARVESTED, not a new
> occurrence — the annotations record only what they add. Client 006 and 008-011 come
> from earlier, unrelated deliverables of the client.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session throughout. Delegated work: two
  workflows (4 verifiers + 4 adversarial skeptics; the pre-commit review), all on the
  main model.
- `turns: 2` — the recording prompt, and "continua" after the usage limit. Not
  counted: `/clear`, the background notifications and the scheduled wake-ups.

## Done
- **Verification** (one workflow): 4 verifiers by group of entries (hooks; slots and
  reads; memory and gate; method lessons), each followed by a skeptic mandated to
  overturn every verdict in BOTH directions. The brief quoted the user's instructions
  VERBATIM from a file, not paraphrased (IMP-060, applied to itself). Read-only on both
  real repositories; experiments only in throwaway clones and fixtures under the job's
  scratch directory (hooks installed from linked worktrees and across the marker
  switch, the sentinel against every wrap, commitlint offline, fixture projects with
  their own tags, a moved `vY`).
- **Outcome**: 0 not reproducible. The user's expected classification held for all 15
  entries; 6 CONFIRMED and 9 PARTIAL (the core holds, a scope or a wording corrected
  before recording). The skeptics raised 63 challenges: 25 upheld, 35 corrected, 3
  overturned. The 7 must-fix among them: a `.bak` can be stale; the executable-lines
  diff must keep code-read comments; a plain overwrite of `reset-task.sh` is not
  silent; pin-identity needs a real pin commit; a `vY` anchor does exist (the
  CHANGELOG's first heading); IMP-043's rejected map must be distinguished from the
  client's title map; and the per-agent permission side of IMP-055.
- **Pre-commit review** (a second workflow, author ≠ judge): 3 reviewers (facts of the
  entries; facts of this note; fidelity, anonymisation and format) — 29 findings
  (7 must-fix, three of them raised by two reviewers). Their 3 skeptics DID NOT RUN
  (the session's usage limit): a declared coverage gap. The main session judged each
  finding on the source instead: all applied but one (see *Problems encountered*, 3).
- **Recorded in [[LEARNINGS]]** (OPEN, from the first free number): IMP-055 delegated
  agents in a shared working tree, IMP-056 a gate lens on claims, IMP-057 the
  bidirectional allow-list, IMP-058 the claim's perimeter (kin of IMP-056: evaluate
  unification at the retro), IMP-059 what an external tool runs by itself, IMP-060 the
  verbatim delegation brief. Annotated as evidence: IMP-046, IMP-048, IMP-050 (points
  3-5) — points 4, 5 and the point-3 input —, IMP-052, IMP-053, and the Applied
  IMP-050 (points 1-2).

## Verification, entry by entry
Entries are named by the client's own numbering ("client 006"), never as `IMP-nnn`:
here those numbers belong to other entries (the collision of IMP-049). Line refs are on
v1.2.1. "Recovered" = what the damaged block lost and the client's backlog restored.

| Entry | Verdict | Class → recorded as | Verification (v1.2.1) | Recovered from the source |
| --- | --- | --- | --- | --- |
| client 006 | PARTIAL | NEW → IMP-055 | No practice in `docs/03`:43-58 or `security-review.md`; `SETUP.md`:375-384 is upgrade-scoped; no deny on switch/checkout/restore/archive (`settings.json`:12-17). The ban in the prompt is what failed in this repo's incident ([[2026-09-25-imp-050-read-by-tag]], item 1); "does not move HEAD" is the wrong criterion (`archive -o`, `--output`); plain `git status` writes the index. | Yes — title, the HEAD thrashing, "modified by user", options (a)-(c); original in Italian |
| client 008 | CONFIRMED | NEW → IMP-056 | `docs/03`:38-41 names only defects of action; `security-review.md`:8-23 has no truthfulness check. | Yes — the four truth defects, the lens's name; original in Italian |
| client 009 | CONFIRMED | NEW → IMP-057 | `docs/02`:81-86 (ALL entities, anti-vacuity) says nothing on known exceptions — the lesson qualifies its example. | Yes — the incentive mechanism, checks (a)/(b), the reason per entry; original in Italian |
| client 010 | CONFIRMED | NEW → IMP-058 | Diff-scoped gate: `docs/03`:32, `security-review.md`:4; `docs/01`:137-145 is refactor/title-scoped. Framework occurrence: the C11 pattern (CHANGELOG.md:80-87 vs decision 3 of [[2026-07-20-language-rule-phase1]]). | Yes — the three false-claim causes, the triggers; original in Italian |
| client 011 | CONFIRMED | NEW → IMP-059 | Absent from `docs/02` (I/O :35-37, dependencies, DoD 3 :92-98) and `docs/03`. Framework-side: `git status` writes `.git/index` though allowed as read-only (`settings.json`:4, `docs/04`:239-240). | Yes — "paths that re-run it implicitly", the tool list; original in Italian |
| client 012 | PARTIAL | DUPLICATE → IMP-050 (3-5), point 5 | Hard-coded in every tag v0.1.0-v1.2.1 (`hooks-install.sh`:16-17 at v1.2.1); linked worktree: `mkdir: …/.git: Not a directory`. Both one-liners fail (no anchor / relative path, tested); the fix that passes is `-C "${REPO_ROOT}" rev-parse --path-format=absolute --git-common-dir`. The v1.2.1 check (`SETUP.md`:398-404) passes from a linked worktree. | Yes — the block's bracketed guess "[… or installs the hooks relative] to the current one" does NOT match the source, which says the failure spans "every version from v0.2.0 to v1.2.0"; the source's meaning recorded, the span verified wider |
| client 013 | PARTIAL | DUPLICATE → IMP-050 (3-5), point 5 | Edge case 4 (`SETUP.md`:596-604); the Italian-only refusal only for `vX` v0.3.0-v1.0.0; the `.bak` restore works only if THIS Step 4 wrote it; FORCE lossless only for script-level customisation; Step 4's `.bak` wording (:527). | Yes — "the old script only knows the Italian marker", "expected WARNING + `.bak` pair" |
| client 014 | PARTIAL | DUPLICATE → factual defect C11 (this note) | CHANGELOG.md:80-87 (was :58-65); `docs/05`:57, :78, rule 1 :82-83. Only the RESPONSE closer has a reader; "would be bounced" → "may be asked to paste again". | Yes — minor ("across the translation release") |
| client 015 | PARTIAL | DUPLICATE → IMP-050 (3-5), point 4 + the sentinel | `CLAUDE.md`:86 (heading marker), :104-106 (marker-less bullet; re-scoped, not added); sentinel `lint-memory.md`:47 catches 3-4 of 16 wrap variants; `SETUP.md`:63-69 promises more. | Yes — the missed breaks (`[TO⏎BE`, a trailing space), "every internal break" |
| client 016 | PARTIAL | DUPLICATE → evidence IMP-048 (IMP-043 is Applied) | 13 citation sites (8 STATE, 5 LEARNINGS); `checkpoint.md`:21-24; CHANGELOG.md:80-87 lists no heading; `docs/01`:141-145 runs inside the rewritten repo; edge 3 `SETUP.md`:585-594 and Step 5 :537-539 block a heading migration. | Yes — "critical debt", the reverse direction, "as the standard answer"; a local decision reference dropped |
| client 017 | PARTIAL | PARTIAL → evidence IMP-053 (decision below) | Upgrade section `SETUP.md`:304-641 never names `/security-review`; Step 6 :558-562; `reset-task.sh`:20-23 slot vs METHOD filing :334-337; edge 7 :624-633 and the Step 4 grep :530 surface it. | Yes — "the gitleaks baseline", "0 verdicts in the notes of the two previous upgrades"; a local branch name dropped |
| client 018 | PARTIAL | ALREADY APPLIED → evidence in Applied IMP-050 (1-2) | Covered by `SETUP.md`:368-389 (Precondition, rules 1-2). Re-harvested: the client's trap (2) = B4 (point 1), its trap (1) = B5 (point 2). The blob sanity check is NOT in v1.2.1 (:398-404 checks roots, common-dir and `vY`'s existence) → input for point 3. | Yes — "(a different blob)", "two silent wrong-source reads" |
| client 019 | CONFIRMED | DUPLICATE → factual defect C13 (this note) | `docs/04`:35-36, `checkpoint.md`:45-46, `commitlint.config.cjs`:6-10; `wip: test` → rc 1 (commitlint 21.2.3, offline). | Yes — "(feature branches only)", which is the one new part |
| client 020 | CONFIRMED | DUPLICATE → evidence IMP-046 + the script proposal | Invariant `SETUP.md`:338-341, :537-539; no verification script in `scripts/`; no-backfill rule `sessions/README.md`:57-58. | Yes — the allowed-path diff and the no-backfill check, both lost in the block |
| client 021 | PARTIAL | NEW → IMP-060 | (a) absent: `docs/00`:107-124 (no delegation bullet; the nearest is effort), `docs/05`:61-62 the outward analogue; (b) partly in `docs/03`:54-58 (Applied IMP-016), reader-side and reviews-only. | Yes — "treated that decided point", "declares its coverage gaps" |

Also recorded, at the user's request: **IMP-052** gets the relayed occurrence "after a
resumption, a branch was created from the wrong base".

## Decision on client 017 — evidence for IMP-053, not an entry of its own
Its core, a written gate verdict for an upgrade, IS IMP-053's proposal, and its symptom
("the gate was silently skipped in two previous upgrades") is IMP-053's exact problem —
a skipped gate and a forgotten one look the same. A separate entry would split one
retro decision in two. Its two new parts are not gate verdicts and go where they
belong, cross-referenced from IMP-053: the executable-lines diff is the content of the
upgrade verdict's reason and, as a mechanical Step 5 check, an input of IMP-050
(points 3-5) — with the caveat that it must keep the code-read strings living in
comments (the hooks' ownership marker); the reclassification of `reset-task.sh` is a
classification defect of `SETUP.md`, listed below with the §2-slots finding of
[[2026-09-24-third-upgrade-lessons]], whose `reset-task.sh`:20 item it extends.

## Factual defects — awaiting the user's decision (NOT applied)
The duplicates first (C11 and C13 live only in the append-only
[[2026-09-24-third-upgrade-lessons]], so their new evidence is recorded here):
- **C11 + client 014** — the same lesson, re-harvested from the same upgrade (no new
  occurrence). Refinements: of the strings the 1.1.0 CHANGELOG lists, only the
  escalation RESPONSE closer (`docs/05`:78, read at rule 1 :82-83) has a reader without
  the legacy form; the REPORT closer is read only by
  the external Architect, and the two printed blocks have no reader at all ("empty
  rather than false"); `FINE RISPOSTA` never existed in any tag. A dual-form clause in
  `docs/05` would concern the RESPONSE closer only.
- **C13 + client 019** — the same lesson, re-harvested (no new occurrence). New: "add
  `wip` to the enum (feature branches only)" cannot be expressed natively — commitlint's
  `type-enum` has no branch context; it needs custom code in a payload file (a config
  computing the enum at load time, a local plugin rule, or a branch test in the
  generated `commit-msg` hook; the first two measured). With a feature-branch
  allow-list, a detached HEAD rejects `wip` by construction (measured for the load-time
  config) — and CI checkouts usually run detached.
New candidates found by the verification:
- **The check-10 sentinel overclaims** (Level 1 candidate): `SETUP.md`:67 and check 10
  (`lint-memory.md`:43-47) promise a sentinel that "flags broken slots"; it catches only
  a break right before `SETUP` (the widening is recorded in IMP-050 (points 3-5)).
- **`reset-task.sh` filed METHOD** (`SETUP.md`:336) while it carries a setup slot
  (`reset-task.sh`:20, since v0.1.0; the METHOD filing dates from v0.5.0) — with the §2
  checklist that never lists it (2026-09-24 note, side finding).
- **The Precondition check's limit is not in `SETUP.md`**: it passes for a separate
  clone of the project or an unrelated repo with a same-named `vY`; only
  [[2026-09-25-imp-050-read-by-tag]] says so.
- **Where to customise the formatting block — conflicting guidance**: `SETUP.md`:128-129
  says the script; the generated hook's header says "do not edit by hand" while its body
  says "Uncomment and adapt". It decides whether `FORCE_OVERWRITE=1` is lossy (IMP-050,
  point 5 annotation).

For the fixers — the 2026-09-24 note pins its line refs to v1.2.0 (not a defect; the
note is append-only): at v1.2.1, C11's `CHANGELOG.md`:58-65 is :80-87, B9's :46-48 is
:68-70, B8's `SETUP.md`:284-290 is :291-297, the §2 finding's "complete list" (:72) is
:79; B4's "two checkouts (or exports)" no longer exists (rewritten by v1.2.1).

## Side findings (recorded in the entries, listed here for traceability)
- `hooks-install.sh` run outside a repository prints OK and creates a stray `.git/hooks`
  (IMP-050 (3-5), point 5).
- Plain `git status` writes `.git/index`; the framework allows it as read-only (IMP-059,
  IMP-055).
- The generated `commit-msg` hook runs `npx --yes` with unpinned packages; an npm debug
  log of a commit in a grafted project shows a registry request — observed, not probed
  (IMP-059).
- The client's backlog holds more entries marked `Destination: framework` than the 15
  harvested (two applied, four open — some dated after the harvest): candidates for the
  next harvest, not recorded here.

## Anonymisation
Nothing of the client enters the framework: no project name, component or module name,
tool name (the package manager stays "a package manager"), branch name, local path,
SHA, date, or local decision reference (the client's session-note path, its decision
labels, its IMP numbers as `IMP-nnn`). Checked with a grep of the added lines for the
client's name, components, tool and variable names, branch names, SHAs, dates, decision
labels and local paths, before the commit and again after the review's fixes: no hit
(the only matches were the framework's own note names and SHA, and words such as
"second"); the review's anonymisation pass found no leak either, and on its advice the
clock times of the client's commits were dropped from this note. The
pre-existing mentions of the client (IMP-036 and IMP-037 in [[LEARNINGS]], older session
notes) were left untouched — outside this scope.

## Problems encountered → cause → solution
1. The client repository moved DURING the verification (a new branch, commits and a
   merge) → a parallel session working on the client, not this one: its reflog shows
   commit/merge entries with the client's own messages, and every agent reported no git
   command there → the merge rewrote the client's backlog file mid-run, but entries
   006-021 kept their line ranges, and the review compared the recorded text with the
   post-merge file, so the verdicts stand. The framework repo's snapshot (HEAD, branch,
   status, reflog, stash, worktrees, root listing) was identical before and after both
   workflows.
2. The relayed "branch created from the wrong base" is not in the client's records
   (read-only search of its memory and commit subjects) → recorded in IMP-052 as
   relayed, with no cause attributed (the prudent version).
3. The pre-commit review's skeptics died on the usage limit → no second pass on the 29
   findings → the main session re-checked each on the source (the client's re-harvest
   provenance, the gate record of the "claims" lesson, the *Merge* heading, the
   unchanged entry ranges) and applied all but one. Rejected: rewording "a check that
   executed untrusted input" (IMP-058) — it is the client's own wording in the
   harvested block, which the reviewer did not have. The biggest catch: the draft
   called the re-harvested lessons "independent" or "second" occurrences — a
   double count the retro would have inherited.

## Retro (end of deliverable)
One friction worth a lesson: seven of the fifteen entries (client 012-016, 018, 019)
repeat, in whole or in part, lessons already relayed on 2026-09-24, and nothing in the
harvest said so — the draft counted three of them twice until the review caught it. `/harvest-framework` prints every entry
marked `Destination: framework`, whether or not it was ever sent upstream, and the
printed block carries no provenance a framework can match. Candidate IMP (e.g. a "sent
upstream" mark on the client's entry, or the source session in the printed Origin), NOT
recorded here — the user listed what this deliverable records; offered to the user.

## Security gate
Not applicable — process memory only (two files under `.claude/memory/`); no
auth/money/personal data/enforcement code changed.

## Follow-up — the open backlog, proposed order for the retro
1. **IMP-054** (HIGH, user decision) with **IMP-055** — the same question: what enforces
   a boundary on an agent (IMP-055 carries the per-agent permission input).
2. **The upgrade cluster**: IMP-050 (points 3-5) — now with the corrected one-liner, the
   rollback, the sentinel and the `vY` anchor —, IMP-046 (with its verification half),
   IMP-037 (trigger fired), IMP-049.
3. **The quick fixes**: C13, C11, B8, C12, the §2 slots with `reset-task.sh`'s class, the
   sentinel's overclaim, the check's undocumented limit, the formatting-block guidance,
   `SETUP.md`:313's backtick ([[2026-09-25-imp-050-read-by-tag]]).
4. **The gate lenses**: IMP-056 + IMP-058 (unify?), IMP-059 (it has live instances in the
   framework itself).
5. **The process IMPs**: IMP-053, IMP-048 (the IMP-043 unification), IMP-060, IMP-052,
   IMP-051, IMP-047, IMP-057.
- Push of this commit: the user's.
