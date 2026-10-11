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
- [ ] 1. This note and its plan; the notes received for later blocks — commit: —
- [ ] 2. Assessment, read-only: the payload's impurities measured (IMP numbers, pointers, framework-only blocks), the lists that claim completeness, the links, the version mentions, the Italian residue; the check's design — commit: —
- [ ] 3. `tools/`: the check's frame and self-test (the payload's model, the OK/FAIL/CHECK lines, the bidirectional allow-list); the first check, the inventories of commands, targets and scripts against the files; wired into `make test-scripts`, moot where `tools/` is absent; `tools/README.md`, `CONTRIBUTING.md` — commit: —
- [ ] 4. Framework IMP numbers out of the payload's text, the why in prose, and the check that keeps them out — commit: —
- [ ] 5. The framework-repo-only blocks moved to `CONTRIBUTING.md`, one conditional line left in `docs/01` — commit: —
- [ ] 6. The payload's pointers to files outside it rewritten (a local assumption rephrased, a cross-repo pointer labelled), and the check — commit: —
- [ ] 7. Internal links resolve; tags and CHANGELOG entries match; no old version cited as current — the checks and the fixes — commit: —
- [ ] 8. The lists that declare themselves complete (the §2 checklist, the class table, the inventories, the counts in prose) against what exists — the checks and the fixes — commit: —
- [ ] 9. No Italian residue in the artifacts, the memory checked prospectively — the check and the fixes — commit: —
- [ ] 10. `LEARNINGS.md`: the applied-entry convention in its format comment; IMP-049 and IMP-068 applied, in their final form — commit: —
- [ ] 11. ONE reviewer + fixes — commit: —
- [ ] 12. `/checkpoint` — commit: —
- [ ] 13. `/integrate`: the CHANGELOG 1.4.1 entry; the two blocks — commit: —
