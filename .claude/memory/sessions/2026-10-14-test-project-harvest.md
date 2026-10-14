---
date: 2026-10-14
task: record the 15 entries a test project harvested with /harvest-framework — deduplicated against the backlog, IMP-107..121 recorded, the user's P1 note added to IMP-111
branch: chore/memory-test-harvest
status: completed
model: 'claude-opus-5-5'
turns: 2
tags: [session, imp, harvest]
---
# Session 2026-10-14 — A test project's harvest: recording

> Recording only (the user's brief): nothing applied, one branch, one commit, no push. The
> block came from a test project grafted greenfield at v2.2.0, all 15 entries dated
> 2026-10-14. Neutral label for the project here and in every Origin: "a test project".

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session throughout; no delegated work.
- `turns: 2` — the recording brief, and the user's confirmation with its precision on the
  numbering (the project's entry 005 takes this backlog's next number, and the P1 note goes
  on it).

## Done
- **Count once** (`CONTRIBUTING.md`, *A harvested lesson counts once*): no earlier
  recording holds an entry of this project dated 2026-10-14 — the only earlier harvest
  ([[2026-09-26-client-harvest-registration]]) is another project's, from another date.
- **Equivalence** checked against the whole backlog (OPEN, Applied, Deferred, Rejected) by
  topic: none of the 15 repeats an existing entry's problem AND proposal. Close kin is named
  in each new entry's *Kin* line — mostly extensions of an applied rule to a path it does
  not reach (IMP-050's read-by-tag to the greenfield copy and §0; IMP-008's branch roles to
  §1 and `integrate.md`; IMP-075's file-tools rule to the point of use at setup).
- **Spot-checked on the source** (`main` = v2.2.0), read-only: `SETUP.md` §1's copy line
  and "(`develop`)", §0's "from the framework's clone", §2's "EMPTY OUT"; the reminder in
  `scripts/hooks-install.sh` and the `Makefile`'s help; `integrate.md`'s "Replace the
  placeholders"; `docs/00`'s "(the concrete list is …)"; the class table's METHOD
  `.claude/docs/00-06`. All as the entries describe. The Claude Code measurements of the
  project's entry 005 were not re-measured here.
- **Recorded in [[LEARNINGS]]** (OPEN, from the first free number), with the mapping:

| Harvest (the project's entry) | Here | Kind |
| --- | --- | --- |
| 001 greenfield copy by tag | IMP-107 | new |
| 002 prerequisite check from the clone | IMP-108 | new |
| 003 §1 names `develop` | IMP-109 | new |
| 004 the graft commit of a new project | IMP-110 | new |
| 005 a stable read-only rule for framework reads | IMP-111 | new, + the user's P1 note |
| 006 command style of framework reads | IMP-112 | new |
| 007 the graft copies the live memory | IMP-113 | new |
| 008 the formatting reminder | IMP-114 | new |
| 009 docs' slots vs the METHOD class | IMP-115 | new |
| 010 `integrate.md` placeholders, trunk-based | IMP-116 | new |
| 011 slots filled with `sed -i` | IMP-117 | new |
| 012 slot vs mention of the marker | IMP-118 | new |
| 013 memory-only commits in trunk-based | IMP-119 | new |
| 014 the cycle for a non-heavy deliverable | IMP-120 | new |
| 015 an open question that does not reach STATE | IMP-121 | new |

- **The user's note on IMP-111** (lens P1, to be verified, not measured): a rule on
  `git -C <fw> grep *` admits `git grep -O<command>`, which runs a command; one on
  `git -C <fw> show *` admits `--output=<file>`, which writes a file; `ls-tree` is
  harmless. Recorded in the entry; the proposal is to be narrowed or guarded before it is
  applied.
- **Anonymisation**: the block carried no project name, no project path (only the generic
  `/abs/path/to/framework` and `$HOME/…`) and no SHA; the project's numbers are written as
  "the project's entry NNN", never as IMP numbers.

## Security gate
- Not applicable: a memory-only change (`LEARNINGS.md` and this note), outside the payload;
  no sensitive component, no security property asserted by the product.

## Problems encountered → cause → solution
- None.

## Proposals
- IMP-107..121 (in LEARNINGS.md), above.

## Follow-up
- IMP-111: verify the P1 note (and measure the rules in manual mode) before any decision.
- No tag: a change confined to the framework's own memory (`CONTRIBUTING.md`).

[[LEARNINGS]] · [[2026-09-26-client-harvest-registration]]
