---
date: 2026-10-11
task: v1.4.1 — the payload's purity (IMP-049) and the mechanical documentation check (IMP-068), outside the payload, with its self-test, in make test-scripts; the convention for applied IMP entries
branch: fix/payload-purity-1.4.1
status: in-progress
model: 'claude-opus-5-5'
turns: 1
tags: [session, payload, tools, docs, imp, plan]
---
# Session 2026-10-11 — v1.4.1: the payload's purity and the documentation check

> A dedicated branch from `main` at `2bb8f08` (v1.4.0, its tag signed). Probes only under
> `/tmp`. Hybrid regime: no `plans/`, this note is the plan-pointer. The decisions on
> IMP-049 are the ones recorded in [[2026-10-10-upgrade-safety-1.3.3]] (user decision 5)
> and in the entry itself; the brief below is the user's message of 2026-10-11.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 1` — the user's brief for v1.4.1, with v1.4.0 integrated and pushed (`2bb8f08`,
  tag v1.4.0 signed). The user confirmed that rewriting the local history to drop the
  client's branch name (M7 of [[2026-10-10-upgrade-verification-1.4.0]]) was correct.

## The brief (2026-10-11) — persisted so a /clear does not lose it
v1.4.1 is a PATCH: the payload's purity and the mechanical checks. Decisions already taken
on IMP-049:
1. framework IMP numbers out of ALL the payload's text, the scripts' header comments
   included; the why in prose;
2. the payload's pointers to files outside the payload rewritten;
3. the blocks that only hold in the framework repository moved to `CONTRIBUTING.md`, with
   at most one conditional line in `docs/01`;
4. a mechanical check that prevents the regression.

The check lives outside the payload, has its own self-test, covers the documentation too
and hosts IMP-068 ("a list that declares itself complete deserves a mechanical check"):
- no framework IMP number in the payload;
- no pointer from the payload to a file outside the payload;
- the commands listed in `README.md` and `CLAUDE.md` match the files of
  `.claude/commands/`, in both directions;
- every tag has its CHANGELOG entry, and every entry its tag;
- no document cites an old version as the current one;
- the internal links resolve;
- every list that declares itself complete (the §2 slot checklist of `SETUP.md`, the class
  table, …) matches what really exists;
- no Italian residue in the ARTIFACTS — the existing memory stays as it is: the rule is
  prospective.
The check runs in `make test-scripts`. What it finds is fixed in this same release.

A convention to make explicit: an IMP entry, once applied, moves under *Applied* and is
rewritten in its final form — what was verified, the decisions, what stays uncovered —
with the evidence condensed; the detail stays in the session notes it cites and in the git
history. If the format comment of `LEARNINGS.md` does not say so already, one line says it,
with the constraint that every applied entry cites the session note its evidence comes
from.

ONE reviewer. At the end `/checkpoint` and the `/integrate` block in two blocks; merge, tag
and push are the user's.

## Received for later blocks
- **v1.5.0 (multi-platform, IMP-070).** The CI must include `tools/test-upgrade-check.sh`
  from its first run: it is the framework's largest bash code and the most exposed to the
  GNU/BSD differences and to Git Bash.
- **The client project's upgrade, at the end of the cycle.** Its pin reads
  `version: 1.2.0`, without the `v`: correct that line by hand before `preflight`, which
  stops on it — the intended behaviour (an explicit error, never a silent normalisation).

## Plan (one commit per task)
- [x] 1. This note and its plan; the notes received for later blocks — commit: f1357c8
- [x] 2. Assessment, read-only: the payload's impurities measured (IMP numbers, pointers, framework-only blocks), the lists that claim completeness, the links, the version mentions, the Italian residue; the check's design — commit: 6444ac6
- [x] 3. `tools/`: the check's frame and self-test (the payload's model, the OK/FAIL/CHECK lines, the bidirectional allow-list); the first check, the inventories of commands, targets and scripts against the files; wired into `make test-scripts`, moot where `tools/` is absent; `tools/README.md`, `CONTRIBUTING.md` — commit: b2248cf
- [x] 4. The framework-repo-only blocks moved to `CONTRIBUTING.md`, one conditional line left in `docs/01` — commit: a1779d5
- [x] 5. Framework IMP numbers out of the payload's text, the why in prose, and the check that keeps them out — commit: 33f7263
- [x] 6. The payload's pointers to files outside it rewritten (a local assumption rephrased, a cross-repo pointer labelled), and the check — commit: 18873cf
- [x] 7. Internal links resolve; tags and CHANGELOG entries match; no old version cited as current — the checks and the fixes — commit: 1c6093d
- [x] 8. The lists that declare themselves complete (the §2 checklist, the class table, the inventories, the counts in prose) against what exists — the checks and the fixes — commit: 66f3e50
- [x] 9. No Italian residue in the artifacts, the memory checked prospectively — the check and the fixes — commit: 603fa6b
- [x] 10. `LEARNINGS.md`: the applied-entry convention in its format comment; IMP-049 and IMP-068 applied, in their final form — commit: 88513b3
- [ ] 11. ONE reviewer + fixes — commit: —
- [ ] 12. `/checkpoint` — commit: —
- [ ] 13. `/integrate`: the CHANGELOG 1.4.1 entry; the two blocks — commit: —

## Assessment (task 2) — read-only, five analysts
One workflow of five read-only analysts over `f1357c8` (payload impurities, lists that
claim completeness, internal links, versions and the CHANGELOG, Italian residue), about
twelve minutes; the repository's snapshot and status identical before and after. Each
measured the current state and proposed the rule its check would apply, with the false
positives it measured.

**The payload's impurities** (the payload: the 36 files setup copies, plus the header and
the format comment of `LEARNINGS.md`).
- Framework IMP numbers: 23 occurrences on 22 lines in 9 files — IMP-009, 024, 032, 034,
  043, 044, 054, 055, 062; ten of them are self-test PASS/FAIL labels, which nothing reads
  (the third case of `test-hooks-install.sh` already prints a descriptive label). One
  legitimate form: the format comment's `### IMP-001 — <short title>`.
- Pointers to files a project does not have: 14 lines in 9 files. Assuming a local file
  (to rephrase): `settings.json`'s SessionStart message, `CLAUDE.md`'s licence example,
  `docs/03`, `docs/06` (brownfield), `lint-memory.md` check 10 (twice). Cross-repo (to
  label as the framework's): `docs/04` (*Hardening*; "setup step 3; upgrade Step 4"),
  `docs/06` (the README's *Philosophy*, SETUP §5, CONTRIBUTING), `harvest-framework.md`,
  `lint-memory.md` (§2, Step 4 of the upgrade). Two leave with the blocks below. Harmless:
  the conditional CHANGELOG of `integrate.md` and `lint-memory.md`, "the framework repo" as
  the bridge's destination; data, not pointers: the guard's self-test feeding
  `cat README.md` to the guard.
- Framework-repo-only text: `docs/01`'s hybrid-regime box and its RESUMPTION patch,
  `sessions/README.md`'s *Plan block*, `docs/06`'s final box, `harvest-framework.md` §1, two
  sentences of the `LEARNINGS.md` header, `docs/04`'s "(as this framework is)" —
  `CONTRIBUTING.md` already states the framework's own breaking-change criterion. The only
  citation of the moved blocks is `CONTRIBUTING.md`'s own paragraph on the regime.
- A constraint for the applied-entry convention: the format comment must stay ONE block —
  Step 3's recipe gathers the merged blocks at the first one, and `invariant` fails on an
  extra block. The convention goes inside it.
- Factual, found on the way: `docs/06` and `SETUP.md` §5 place the IMP format "in the header
  of `LEARNINGS.md`"; it is the format comment, in the body.

**Lists that claim completeness** — 41 checked against their source; 33 match. The eight
that do not: `SETUP.md` calls the pin "the FOURTH species" (fifth since v1.4.0 added the
memory templates); `new-component.md` holds a slot in the short form `[TO BE DEFINED]`,
invisible to every grep and to `upgrade-check.sh`'s slot tracking since v0.1.0 (the reviewer's
correction: "v0.2.0" here first);
`checkpoint.md` is in §2 with no marker (its slots are angle-bracket placeholders);
`SETUP.md`'s "Its subcommands:" omits `classes`; the brownfield `Makefile` row omits
`test-scripts`; "OPEN / Applied / Deferred — the whole backlog" (`harvest-framework.md`,
`INDEX.md`, `STATE.md`) omits Rejected; `test-hooks-install.sh` hard-codes the hook list
instead of reading the generator's loop; minor ones (step 1 never names `tools/` though two
files cite it for that; the TREE legend without `LEARNINGS.md`; README's step 4 without
`INDEX.md`; "three real upgrades", true until the next one). Matching today: the class
table against the payload at every tag, both ways; the four copy lists of the payload; the
README tree; the commands, targets and script tables; the counts of hooks, edge cases and
guide READMEs; the commit types; the title and label tables. Replayed on the tags, a
file-level §2 check plus a tripwire on the release's new slots catches all six historical
§2 gaps; the file level alone, four.

**Links**: 5 relative Markdown links (no anchors), 156 wikilinks, 17 `@`-imports — all
resolve. Backticked repository paths: none broken in the present documents, given a small
list of names that are not meant to exist here (the pin, `settings.local.json`, `.git/`
paths, generic examples). Section titles cited by name with their file: 39, all present.

**Versions**: 19 tags, all annotated, 19 CHANGELOG entries, both ways; order, format and
dates sound (each entry dated no later than its tag). The one real past drift: v1.1.0 was
tagged with its notes still under `[Unreleased]` — the tag-to-entry direction catches it. No
document cites an old version as current, today or at any audited tag: the rule is
preventive.

**Italian residue**: the payload has four real lines — the example slugs of
`sessions/README.md` (`setup-iniziale`, `modulo-pagamenti`) and `plans/README.md`
(`03-modulo-x.md`), a fixture path in `test-hooks-install.sh` (`/percorso/che/non/esiste`);
two the vocabulary cannot see — the calque `<id-prompt>` (`INDEX.md`, `plans/README.md`;
`docs/01` says `<prompt-id>`) and guillemets used as quotes (`docs/04`, `SETUP.md`). The
memory is English since its translation, but for the approved glossary of
[[2026-07-20-language-rule-phase1]], one frontmatter line the translation missed, verbatim
quotes and ten Italian file names (one created after the rule). Commits since v1.1.0: none
Italian. The memory stays as it is: what the check sees there is declared, not rewritten.

## The check's design (declared choices, inside the user's decisions)
- **Where, and in what.** `tools/docs-check.mjs`, Node.js with no dependency, and its
  self-test `tools/test-docs-check.sh`. Node, not bash: paragraphs, Unicode, anchors and set
  comparisons are where bash 3.2 and BSD awk are weakest, and v1.5.0 will run it on Linux
  and Windows; Node is already a prerequisite (the guard). The self-test runs the real check
  on a throwaway clone of this repository — its tags, and its working tree as it is — and
  breaks one thing per case: a realistic fixture, not a toy one.
- **Wiring.** `make test-scripts` runs both after the scripts' self-tests, in a line guarded
  by the file's presence: in a project, where `tools/` does not exist, the line does
  nothing. The upgrade check's own self-test stays outside it (v1.5.0's CI takes it).
- **What it reads.** The working tree, new files included; its tags; its commits since
  v1.1.0 (the release that brought the language rule). Three scopes: the PAYLOAD (from
  `PAYLOAD_PATHS` in `tools/upgrade-check.sh`, plus the `SECURITY.md` scaffold; of
  `LEARNINGS.md`, its header and format comment); the PRESENT documents (everything but
  history); HISTORY (the CHANGELOG, the session notes, the IMP entries), never held to the
  present.
- **What it says.** `OK`, `FAIL`, `CHECK` lines as in `upgrade-check.sh`, a floor on what each
  check scanned, exit 1 on any `FAIL`. What the rules cannot tell apart is declared in an
  allow-list inside the script, each entry with its reason, bidirectional: an entry that
  matches nothing fails.
- **The checks.** Payload: no framework IMP number; no pointer outside unless labelled
  ("the framework's …") or conditional; no slot in the short form. Inventories: the
  commands, the process targets, the self-tests, the script and tool tables, the docs
  list, the README tree, against the files. CHANGELOG and tags: format, order,
  `[Unreleased]`, annotated tags, both directions with at most ONE pending entry (the
  topmost, one SemVer step above the latest tag, no later than today), dates, the
  *Upgrading from* chain; no tag at all = a clone without tags, a `FAIL`. Versions: no
  framework version older than the current one next to a currency word, a heading, a
  `version:` line. Links: Markdown links and anchors, wikilinks, `@`-imports, backticked
  repository paths, section titles cited with their file. Complete lists: §2 against the
  payload's markers both ways, plus the tripwire on slots added since the latest tag; the
  class table against the payload of every tag, both ways, and `SETUP.md`'s class bullets;
  the copy lists; the counts in prose (hooks, edge cases, guide READMEs, self-test cases);
  the subcommands; the sections of the backlog; the commit types; the title and label
  tables. Italian: a word list and the accented forms, legacy strings the method reads
  stripped, quotes exempt outside the payload, the frozen memory declared; guillemets; file
  names; commit messages.
- **Declared limits.** The version rule sees explicit currency only; the vocabulary misses
  calques and words outside its list; a list that enumerates without a structure the check
  can extract is out of reach — such a list stops claiming completeness instead ("three
  real upgrades", "the FOURTH species").

## Resumption notes
- Tasks 4 and 5 swapped before either started: the blocks move first, so no IMP number is
  rewritten in text that leaves the payload a task later.
- The check is written whole in the scratchpad first (its rules tuned against this
  repository: 161 findings on the first run, 64 once the rules were right — every one of
  them real), then brought in one family per task, each with the fixes it needs, so
  `make test-scripts` stays green at every commit.
- The single reviewer's findings made two commit messages false (the mutations of task 7,
  "since v0.2.0" in task 8): the four unpublished commits from task 7 on were replayed
  from `18873cf` with those two messages corrected — the trees identical, the earlier
  commits untouched. Old tips: task 7 `d8e0113`, 8 `bddd64a`, 9 `dbefeff`, 10 `bca957a`;
  now `1c6093d`, `66f3e50`, `603fa6b`, `88513b3`.

## Rehearsing the Upgrading note (before the review)
A project grafted at v1.4.0 was simulated in a throwaway clone — the framework's live
memory emptied, `checkpoint.md`'s placeholders answered, the hybrid box of `docs/01` and the
plan block of `sessions/README.md` pruned by hand, a pin — and upgraded to this branch,
tagged v1.4.1 in the clone only. `inventory` flagged what the note says: edge case 7 on
`docs/01`, one new slot each in `checkpoint.md` and `new-component.md`, their §2 items
re-worded. Every 3-way merged with 0 conflicts — the answered `checkpoint.md`, the pruned
`docs/01` and `sessions/README.md`, the `LEARNINGS.md` header and format comment through
Step 3's recipes. `invariant`: 0 FAIL, 0 CHECK — the new line inside the format comment
crosses the upgrade's machinery. `post`: the hooks not reinstalled in the rehearsal
(Step 4) and the new slots to confirm, as expected.

## Review (task 11) — one reviewer, dispositions
One independent reviewer over `2bb8f08..HEAD`, the uncommitted CRLF hardening and the
CHANGELOG draft, about thirty minutes, its experiments in copies under the scratchpad;
the repository identical before and after. Verdict: fit to merge after one HIGH, four
MEDIUM and the record corrections. Its second pass, the verification round below,
replayed every attack on the fixed tree: all caught, but L11's English homographs.

| Finding | Severity | Disposition |
| --- | --- | --- |
| H1 — a pointer written as a link, a relative path, an @-import or a session note's path passed the payload's purity | HIGH | FIXED: links, cited paths, @-imports and wikilinks of the payload are resolved, and one that lands outside it is a pointer like a name; six planted cases |
| M1 — an allow-list entry hid every other finding of its line | MEDIUM | FIXED: an entry matches the finding's subject (its message); the line only through an explicit field |
| M2 — titles cited as `(docs/04, "Title")`, and in the scripts, were never checked | MEDIUM | FIXED: the quoted form, in the docs and in the code files' comments and strings: 23 → 44 titles checked. A fallback that accepted a quoted phrase found anywhere in the file was tried and dropped — `docs/04` quotes its own old titles, and the rename passed |
| M3 — several advertised rules had no planted defect, and the record said every mutation failed the self-test | MEDIUM | FIXED in two steps: planted defects and a mutation campaign over every place the check reports (below), the two false commit messages reworded; the verification round found eight forms still unplanted (V1), planted then |
| M4 — a slot wrapped after `[TO` or `[TO BE` passed | MEDIUM | FIXED: `BROKEN_MARKER_RE`, read from `tools/upgrade-check.sh`, applied to the payload |
| L1 — counts and attributions in the record | LOW | FIXED: 12 pointers rewritten and 2 moved; the commit lists; "since v0.1.0" |
| L2 — IMP-068 without its Verified part | LOW | FIXED in the verification round (V5) |
| L3 — the convention line unqualified; `docs/06` silent | LOW | FIXED: older entries are not backfilled; step 2 of `docs/06` points to the format comment |
| L4, L5 — the Upgrading note's "take `vY`'s copy" unconditional; `CLAUDE.md` would conflict in every project | LOW | FIXED in the draft |
| L6 — `docs/01`'s line named `plans/` only | LOW | FIXED: `plans/` and `decisions/` |
| L7 — a malformed `%`-escape crashed the check (exit 1, a stack trace) | LOW | FIXED: a finding; any error of the check itself exits 2 |
| L8 — the self-test's fake `v9.0.0` moved the current version | LOW | FIXED: `v0.0.9`; the pending case asserts its CHECK, not the exit code |
| L9, L10 — "The latest release, v1.3.0", a static badge; "e.g." exempting every path of its sentence | LOW | FIXED |
| L11 — accented names (José, café) read as Italian, a co-author trailer would fail `make test-scripts` | LOW | FIXED: an accent counts only at an Italian word's end; trailers are names; the English homographs out of the word list (V8) |
| L12 — the SessionStart message said step 4 creates `STATE.md` | LOW | FIXED: step 1 copies it, step 4 fills it |
| L13 — a pending entry failed in a time zone behind its author's | LOW | FIXED: it may carry tomorrow's date |
| L14 — a new rule in a shipped file reads as a MINOR | LOW | FOR THE USER: PATCH kept, as the brief decided; the convention is filed under Changed — it makes explicit what the applied entries did |
| I1-I3 — the `Makefile`'s guarded line undeclared; `/harvest-framework` in the framework repository; `checkpoint.md`'s marker surviving setup | INFO | FIXED: `CONTRIBUTING.md` declares the line, and `docs/01`'s (V6); the harvest's grep anchored at the line's start, a hit counting only inside an entry (V4); the paragraph says setup deletes it, and §2 too |
| I4, I6, I7, I8 — CRLF partial; a misleading message; overlong lines; task 10 unticked | INFO | FIXED |
| I5, I9 — the self-test's duration; `.github/` or `.gitattributes` will fail three checks by design | INFO | RECORDED for v1.5.0 |

### The verification round — the same reviewer, a second pass
Over the fixed working tree on top of `88513b3`, the CHANGELOG draft inserted in a copy.
Verdict: fit to merge after V1 and V5, ideally V2 and V4; no HIGH. The replayed commits of
task 7 on carry exactly the trees of the old tips.

| Finding | Severity | Disposition |
| --- | --- | --- |
| V1 — eight forms without a planted defect, each mutated with the self-test still green: the wikilink and @-import pointers, the currency word, a version in a heading, the commit-trailer skip, the tomorrow tolerance, `§N`, wrapped comments — and the records claimed every rule planted | MEDIUM | FIXED: one planted line each, the floors raised (titles 40, pointers 15); each of the eight mutants now dies in its own case. An inventory of the forms the check's comments name found 19 more unplanted — the pointer's six other name forms and six section forms, the three checkout forms, curly quotes, a bare file name, a script's message, an accent alone —: planted, each mutant killed. The self-test's header no longer claims more than its cases name |
| V2 — a labelled first mention hid a bare one on the same line, a regression of the de-duplication; `tools/` reported twice | LOW | FIXED: every mention judged, a line reported once per target, a directory's trailing `/` normalised; planted, its mutant killed |
| V3 — a quotation right after a file name is read as a section title | LOW | KEPT AND DECLARED: the check's comment and `tools/README.md` say so |
| V4 — `/harvest-framework` counted prose mentions of the marker | LOW | FIXED: the grep anchored at the line's start |
| V5 — the records not true yet | LOW | FIXED: IMP-049's Verified part rewritten, IMP-068's written, this note's rows and the CHANGELOG's claims made to match what was measured |
| V6 — `CONTRIBUTING.md` named the `Makefile` line as the only framework-only text | LOW | FIXED: `docs/01`'s conditional line named too |
| V7 — an error before the checks exited 1 with a stack trace | LOW | FIXED: any error of the check itself exits 2; planted (a CHANGELOG moved away), its mutant killed |
| V8 — "modulo", "pronto", "tutti", "momento" failed in English text | LOW | FIXED: out of the word list; the attack replayed, an Italian control still failing |
| INFO — the floors; the POSIX translation; the badge scan; `../` paths; a ragged line; the self-test's cost | INFO | FIXED: the floors raised, an untranslated POSIX class stops the check, the badge scan limited to releases, the line reflowed; `../` paths outside the repository and the cost RECORDED for v1.5.0 |

## Building the check (tasks 3-11) — what it found, and what it taught
- **What it found, fixed in this release.** IMP numbers 23 (19 after the move), pointers
  14 (12 rewritten, 2 moved), framework-only blocks 6, lists out of step 8 (the short-form
  slot invisible since v0.1.0, `checkpoint.md` unmarked, the brownfield row without
  `test-scripts`, step 1 silent on `tools/`, `classes` missing, the backlog without
  Rejected, the hard-coded hook loop, the "FOURTH species"), Italian residue 6 (two
  example-name lines, a fixture path, the calque, two pairs of guillemets), one factual
  error (the IMP format "in the header").
- **It found itself, twice.** Its word list and legacy forms are Italian by design: the
  check's own two files are declared out of the language scan (and of the title scan,
  their planted defects being data). And the commit-message rule flagged this branch's
  task-9 commit, whose message quoted the slugs it fixed: code spans count as quotes in
  commit messages, as in the memory, and the message was amended before anything else
  was built on it.
- **The tripwire asks for a §2 change whenever a file gains a marker.** Two files did in
  this release (`checkpoint.md` 0 → 1, `new-component.md` 2 → 3), and their §2 items were
  reworded to name the new slot — which is the point.
- **The fixture is the repository itself.** The self-test clones this repository, tags
  and working tree included: realistic (the toy-fixture lesson of v1.4.0), but coupled to
  its state — the CHANGELOG cases first tag the topmost entry when it is still pending, a
  fake tag stays below every release, the pointer case cites the most recent note.
- **Mutation, measured rather than sampled.** After the review, every place where the
  check reports — each `report(` and each list comparison, 75 of them — was disabled in
  turn in its own copy of the repository, and the self-test run against it. The 24
  survivors were exactly the paths no planted defect reached (the guards that fail when
  an extraction finds nothing, `[Unreleased]`, the recipe of `test-scripts`); each got
  its case, and a second campaign killed all 24. Some mutants die on the unchanged
  repository rather than in their own case: the declared exceptions they feed go unused,
  and the bidirectional allow-list fails.
- **A report site is not a rule.** That campaign could not see a detection path feeding a
  site another planted defect already reaches: the verification round found eight such
  paths alive. The remedy was an inventory, not more sampling — every form the check's
  comments name, set against what the cases plant: 19 more were missing. Each of the 29
  mutants of a form (with the pointer rule's link and path branches) and the two of the
  verification round's regressions now dies in its own case, the control passing.
- **The environment moved under the session.** A `brew upgrade` in the user's terminal
  replaced `simdjson` while Node 26.8.1 still linked the old library: `node` stopped
  starting for a few minutes (dyld), and with it the guard (delegated agents blocked, the
  main session notified) and the commit-msg hook's `npx`. Nothing was touched; the work
  resumed when Homebrew had relinked Node (26.11.1).

## Received for later blocks (additions of this session)
- **v1.5.0**: the documentation check needs the tags (a CI checkout with its full
  history — it fails on a clone without tags, by design) and Node.js 18 or later. Its
  self-test runs the check about sixty times on clones of the repository: about a minute
  and a half here, more on Windows. Adding `.github/` or `.gitattributes` fails three of
  its checks by design (the README tree, step 1's list of what is not copied, the
  "Outside the upgrade payload" box): update those documents in the same change. A path a
  document cites outside the repository (a sibling clone, `../other/…`) fails "names no
  file" unless written as a placeholder (`$FW/…`). The self-test costs about 2.5× the CPU
  of its first version. A Node
  that is installed but does not START (the dyld failure above) is the case the
  prerequisite check of IMP-070 (point 7) must catch: run it, do not only find it.
