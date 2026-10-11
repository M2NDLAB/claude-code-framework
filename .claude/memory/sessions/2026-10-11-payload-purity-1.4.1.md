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
- [x] 7. Internal links resolve; tags and CHANGELOG entries match; no old version cited as current — the checks and the fixes — commit: d8e0113
- [x] 8. The lists that declare themselves complete (the §2 checklist, the class table, the inventories, the counts in prose) against what exists — the checks and the fixes — commit: bddd64a
- [ ] 9. No Italian residue in the artifacts, the memory checked prospectively — the check and the fixes — commit: —
- [ ] 10. `LEARNINGS.md`: the applied-entry convention in its format comment; IMP-049 and IMP-068 applied, in their final form — commit: —
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
invisible to every grep and to `upgrade-check.sh`'s slot tracking since v0.2.0;
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
