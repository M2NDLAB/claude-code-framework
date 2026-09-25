---
date: 2026-09-25
task: retro block 1 — apply IMP-050 points 1-2 to SETUP.md's upgrade procedure (the framework is read only by tag, `-C "${FW:?}"` on every framework-side command), plus the graft-time pin comment (D2) and a bare-clone aside (D3); IMP-054 recorded
branch: fix/setup-upgrade-read-by-tag
status: completed
model: 'claude-opus-5-5'
turns: 3
tags: [session, imp, upgrade, retro, verification]
---
# Session 2026-09-25 — IMP-050 points 1-2: the framework is read only by tag

> First block of the retro over the open backlog. Hybrid regime: no `plans/`; one
> deliverable = one apply commit + this checkpoint + the CHANGELOG entry. Scope, by the
> user: IMP-050 points 1-2 only (+ D2, D3); points 3-5 and every other IMP untouched,
> except IMP-054, recorded at the user's request.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session throughout. Delegated: three workflows
  (the phase-1 assessment: 4 analysts + 1 critic; the pre-commit review: 4 reviewers +
  4 skeptics; the checkpoint fact-check: 2 reviewers) and one documentation lookup, all
  on the main model.
- `turns: 3` — the retro prompt (phase 1, proposal), "continue", and the decisions with
  the phase-2 go-ahead. Not counted: `/clear`, `/feedback`, background notifications.

## Phase 1 — assessment and proposal (2026-09-24)
- One workflow, read-only by instruction: an inventory of every framework-side site of
  *Upgrading the framework*, an empirical reproduction in throwaway directories, the
  "separate read-only clone" alternative, the bump, then an adversarial critic.
- Verdict on the clone alternative: reading by tag is sufficient. Which repository
  resolves a tag is decided by `-C`/the cwd, not by how the clone was made (a bare
  clone next to the project did not stop the bare read from returning the project's
  file). A second normal clone adds only "nobody works here" by convention — the very
  property that failed. A bare clone adds one real thing: checkouts and working-tree
  reads fail loudly there (defence in depth). `--mirror` is worse: its fetch silently
  follows a re-created tag.
- User decisions (2026-09-25): D1 the core only — a mechanised `vX` estimate in Step 0,
  a blob-id check in Step 5 and an anti-orphan command in edge case 1 go to the point-3
  block; D2 yes, the graft-time pin comment (`SETUP.md`:40) resolved like Step 6; D3 yes,
  one optional line on a bare clone, `--mirror` excluded; PATCH v1.2.1 as `fix(setup)`,
  the deviation from `docs/06` declared in the commit body.

## Done
- `190404a` `fix(setup)` — `SETUP.md` (+145/−39) and the IMP-050 heading marked "being
  applied" (`LEARNINGS.md` +1/−1). The Precondition rewritten in place (headings and
  step numbers unchanged: they are cited by number from `SETUP.md` itself and from
  `lint-memory.md`):
  - the false premise "the version tags live only in the framework repo" corrected — a
    project versions itself with `vX.Y.Z` too;
  - rule 1: the framework is read ONLY as immutable objects, by tag (two refs per diff;
    no checkout/switch/stash/`worktree add`/commit in the framework; extraction by shell
    redirection into a scratch directory `T` outside both repos, never git's `-o`);
  - rule 2: `-C "${FW:?}"` on every framework-side command and only there;
  - `FW`/`T` set once per shell — an agent restates them and the `cd` in every command;
    `${FW:?}` because `git -C ""` runs in the cwd; `: "${FW:?}" &&` before `$( )`/pipes;
  - a read-only check (exit 1 on STOP) and `fetch --tags` left to the human;
  - by-tag reads in Step 0 (fallbacks 2-3), Step 2, Step 3 (METHOD after the edge-7
    pre-flight; the chained 3-way, never `<( … )`; the trivial hybrids and the
    LEARNINGS header), the mental model's box on hybrids (the 3-way base read at the tag
    `vX`), the Execution boundary box, Step 6 (the pin's `commit` with `^{commit}`),
    edge cases 1, 2, 6, 7, the payload box;
  - graft step 1: the pin's `commit` resolved the same way (D2).
- This checkpoint: IMP-050 split — *Applied* "IMP-050 (points 1-2)", *OPEN* "IMP-050
  (points 3-5)", not renumbered (IMP-037 cites them by number), with the D1 items and the
  review's out-of-perimeter findings as input for its block; IMP-054 recorded (OPEN);
  this note. `STATE`/`TREE`/`INDEX` are clean templates here (hybrid regime): untouched.

## Verification — RED → GREEN, throwaway clones only
Script and logs in the job's scratch directory, never committed (a new script would be
an addition, and would enter the inventory of `/lint-memory` check 11). Fixtures: a
pristine clone, a bare clone, and a HOSTILE `FW` clone (detached at `v0.1.0`, tracked
files dirtied, a change staged, an untracked CHANGELOG), plus a fixture project grafted
from v1.0.0, customised, with its OWN annotated `v1.0.0`/`v1.2.0` and a pin.

| Check | Result |
| --- | --- |
| RED, old text | the Step 2 diff and edge 1's diff run from the project: the project's own diff, rc 0; the old pin command from a host with a same-named tag: the host's commit, not `7d6a9f7`, rc 0; the CHANGELOG read with no ref: whatever the working tree holds (by construction: the fixture's untracked CHANGELOG) |
| GREEN, new text | every framework-side command extracted from the text AS WRITTEN (22 command × file combinations, `<path>` tried on two files) in bash and zsh: 44 runs with identical results for `FW` = hostile, pristine and bare; `FW` unset → loud failure, project untouched; all 21 read combinations (the check block aside) collide with the project's tags once their `-C` is dropped (bash) |
| Static | the verifier: 17 guarded lines; bare reads checked per chain segment — only the 7 declared bare forms (anti-examples + the rule-1 list); one declared write (`fetch --tags`, human). An independent per-segment audit written by a reviewer (allow-list updated for rule 1's `^{commit}`): 19 guarded `git -C "${FW:?}"` segments (the write included), 7 bare, 0 findings |
| The check | OK: framework clone, bare clone, cwd = a linked worktree of the project. STOP with a non-zero exit (1 by construction; logged for the cwd cases): `FW` = the project, a linked worktree of it, a subdir of either repo, a non-repo, empty; `vY` missing; cwd = `FW`'s own clone, a project subdir, outside any repo |
| `merge-file` + `<( )` | differs from the file-based merge in 10/10 runs (bash, zsh; 7 KB and 18 KB inputs); by hand on `CLAUDE.md`: rc 1 both ways, 8554 vs 8610 bytes of output; phase 1, on a small file: rc 0 and no change at all (inputs read as empty) — `merge-file` sizes its inputs with `stat`, which a pipe does not answer with the input's size |
| Real repo | read-only snapshot (HEAD, branch, status, reflog length, stash, worktrees, root listing) identical before and after every logged run (3-6) |

Declared limits (reviewed, left as is): the check cannot tell the framework from a
separate clone of the project, or from another repository with a same-named `vY`; `vX`
is not checked there (it is not known yet for a pre-pin graft, and fails loudly at first
use).

## Pre-commit review (author ≠ judge)
4 reviewers (commands, scope, a first-time reader who ran the procedure, the verifier's
critic), each followed by a skeptic mandated to refute. 55 findings; after refutation
the distinct changes applied were: the check's worktree hole (`--git-common-dir`
instead of `--absolute-git-dir`); STOP now exits 1; trailing `#` comments removed from
the command blocks (in an interactive zsh without `interactivecomments` — this user's
shell — they break the paste and leave `FW`/`T` unset); the cwd reset of an agent
(restate the `cd`; the check now requires the cwd to be a repository root); the precise
reason for banning `-o`/`--output` (relative paths only); `^{commit}` in rule 1's list;
no bare `$FW` left after "never `$FW`" (rule 2's `make -C` anti-example, "commit there"
in the Execution boundary box); `test -s` dropped as redundant; the mode note; the
bare-clone aside cut from six lines to three (D3); "an export has no tags to read by";
a pointer to edge 7's pre-flight in Step 3; CASE A's antecedent in Step 0. The verifier
was hardened too (per-segment guard check, a counted allow-list, the old text read from
`1c39166`). Refuted or out of scope, not
applied (among them): a `vX`/`T`/absolute-path check, a warning that a bare clone is not
write-proof, pathspecs on edges 1-2; the graft copy from the tag, a pin-identity check
and which copy of `SETUP.md` governs (all three recorded for point 3).

## The three items the user asked to record
1. **The incident — evidence for IMP-050 point 1.** On 2026-09-24 at 22:10:16 a
   subagent of the phase-1 workflow, told in its prompt "READ-ONLY on the repo: no
   checkout/switch/…; experiments ONLY under the job tmp", built a RED→GREEN harness
   whose first version took `git rev-parse --show-toplevel` — the real framework repo —
   as its execution target, and executed doc-extracted mutation commands there:
   `git -C … switch --detach v1.2.0` and `git -C … archive -o v1.2.0.tar v1.2.0`. The
   repo was left detached at `v1.2.0` with an untracked archive in its root; `main`
   stayed at `1c39166`, nothing was lost. The agent's own restore was denied by the
   permission classifier; the user restored it (2026-09-25 22:31). While detached, the
   working tree's `LEARNINGS.md` lacked IMP-048..053 and the third upgrade's note — a
   second live case of point 1's cause, a process moving the HEAD of a shared clone.
   **Constraints written in a prompt are not a boundary; permissions are.** In this
   block: the verifier refuses any cwd or `FW` inside the real repo and only clones and
   reads it;
   the reviewers worked on a throwaway snapshot; the real repo's state was compared
   before and after every run. The push side of the same lesson is item 2.
2. **The `git push` deny and `git -C <dir> push` → IMP-054, OPEN, priority HIGH, NOT
   corrected here.** Established from Claude Code's documentation, not probed (a probe is
   an attempted push): a Bash rule matches the command as written, after splitting
   compound commands and stripping a fixed set of wrappers; the docs list
   `git -C . push origin main` among the forms `Bash(git push *)` does not stop, and call
   such a rule "not a security boundary around the program". If it can be bypassed, the
   execution boundary of `docs/04` is decorative — IMP-020's class.
3. **Level 1, out of this block's perimeter:** `SETUP.md`:306 at `1c39166` (313 after
   `190404a`), "`` `docs/06* (*"The bridge to the framework"*) ``" — an unclosed backtick,
   to become `` `docs/06` (*"The bridge to the framework"*) ``. Not fixed here (one change
   at a time). Side effect seen in this block: a code-span extractor that pairs
   backticks across paragraphs mis-reads everything after it.

## Problems encountered → cause → solution
1. A subagent wrote into the real repo → a written constraint is not enforcement, and
   its harness defaulted to the cwd's repository → the user restored it; the phase-2
   scripts refuse the real repo by construction and snapshot its state.
2. The phase-1 critic measured `merge-file` reading `<( )` as EMPTY with exit 0 (a small
   file, on this machine); on 7 KB and 18 KB inputs the verifier saw a result different
   from the file-based merge in 10/10 runs → the text says "EMPTY or TRUNCATED".
3. The verifier's own false signals (backtick pairing across paragraphs; conflict labels
   embedding `T`'s path; a guard case run from a DIFFERENT clone than `FW`; the
   `make -C "${FW:?}"` anti-example flagged as a project-side `-C`) → fixed in the
   verifier; none was a defect of the text.
4. The checkpoint's first draft carried wrong facts (IMP-049..053 for 048..053, the
   commit's stat, IMP-047 attached to the wrong rule, an unmeasured Linux claim) → an
   independent fact-check before the commit caught them all.

## Factual doc corrections (Level 1, docs/06)
- None applied: the one found (`SETUP.md`:306 → 313) is outside this block, see item 3.

## Proposals
- IMP-054 (OPEN, HIGH) in LEARNINGS.md — item 2.
- IMP-050 (points 3-5) gains this block's inputs (D1 items, the review's
  out-of-perimeter findings).

## Retro (end of deliverable)
The friction was the incident; its lessons are recorded above, in the IMP-050 (points
1-2) entry and in IMP-054. No other IMP: the review loop worked as designed (it found
the worktree hole and the zsh paste break before the commit).

## Security gate
Not applicable — process documentation, no auth/money/personal data/enforcement code
changed (IMP-054 concerns the enforcement edge, but is only recorded).

## Follow-up
- `/integrate`: the 1.2.1 CHANGELOG entry (including "an upgrade needs a clone with its
  tags; an export no longer suffices"), then merge, tag `v1.2.1` and push — the user's.
- Next retro blocks: IMP-054 (HIGH), IMP-050 points 3-5 with the inputs recorded in its
  entry, IMP-046, IMP-037 (trigger fired), IMP-049; then the quick fixes of the
  2026-09-24 note (C13, C11, B8, C12, the `SETUP.md` §2 slots) and this note's Level 1;
  then the process IMPs (IMP-053, IMP-048, IMP-051, IMP-052, IMP-047).
