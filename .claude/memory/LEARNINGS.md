---
type: learnings
updated: 2026-09-26
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
> IMP numbering starts at **001**. This file is born EMPTY in a new project. IN THE
> FRAMEWORK REPO, by contrast, it is LIVE (declared hybrid regime — see
> `CONTRIBUTING.md`): whoever copies the template EMPTIES it at setup (`SETUP.md`).
>
> **The `Destination: framework` attribute.** In a CLIENT project an IMP may concern
> the FRAMEWORK rather than this project: it is marked with the line
> `- Destination: framework` (a single physical line, so `/harvest-framework` picks
> it up via grep). Omitted = a lesson about this project, which stays in the client.
> It is a DESTINATION attribute, not a level: the lesson stays a Level 2 one — see
> `docs/06-self-improvement.md`, *"The bridge to the framework"*. IN THE FRAMEWORK
> REPO the attribute is moot (every IMP is already about the framework) and is not
> used on the entries.

## OPEN proposals (awaiting the user's decision)

### IMP-046 — The upgrade procedure contradicts itself on `.claude/memory/`
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
  headers — this overlaps the blob-id check recorded as input of IMP-050 (points 3-5),
  `decisions/README.md` being the hybrid exception (the third upgrade's annotation above —
  B7 of [[2026-09-24-third-upgrade-lessons]]); (4) no backfill of the
  IMP-044 fields (`sessions/README.md`, *Absent = not recorded*); (5) the scope of the
  checkpoint commits. Run on a clone, one positive and eight negative branches: all
  caught (client-side, relayed). Relayed proposal: ship them as
  `scripts/verify-memory-invariant.sh` or a Step 5 recipe, template paths only — to be
  weighed against `SETUP.md`'s "No automation, for now", IMP-037 (trigger fired on the
  count) and IMP-049 (d) (a check hosted in the payload ships to clients).

### IMP-047 — `/integrate`'s "doc-only → no tag" ignores the method-project contract
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

### IMP-049 — Payload purity: method files that only make sense in the framework repo
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — the third real
  upgrade of a client project had to prune by hand, once more, text that points at the
  framework repo
- Observed problem: the files a client receives (the payload: `.claude/`, `CLAUDE.md`,
  `Makefile`, `commitlint.config.cjs`, `.gitignore`, `scripts/` — `SETUP.md` step 1)
  carry three kinds of coupling to the framework repo, and every upgrade that touches
  those files brings them back where the client had pruned them:
  1. POINTERS TO FILES OUTSIDE THE PAYLOAD. `CONTRIBUTING.md` is never copied;
     `SETUP.md` only optionally, "for reference", and Step 2's diff never refreshes it.
     At v1.2.0: the SessionStart hook message of `settings.json` ("see SETUP.md"),
     check 10 of `lint-memory.md`, `docs/03`, `docs/06`, the licence example of
     `CLAUDE.md` — and, beyond the reported list, `docs/01` (the hybrid box),
     `harvest-framework.md` and the `LEARNINGS.md` header. None is new: they date back
     to v0.x and come back with every upgrade whose `vY` touches the file (only check
     10 at the second upgrade, all of them at the third). (Conditional pointers —
     "where present", "if the project keeps one" — are harmless.)
  2. FRAMEWORK IMP NUMBERS IN METHOD TEXT. 10 occurrences of 6 numbers in 4 payload
     files (`harvest-framework.md` IMP-009; `docs/01` IMP-024/034/043;
     `sessions/README.md` IMP-044/024; `scripts/test-hooks-install.sh` IMP-032). A
     client restarts its numbering at 001 (`SETUP.md` step 2), so they are orphans or
     they COLLIDE: v1.2.0 re-proposes the framework's IMP-009 in `/harvest-framework` —
     pruned by the client at its first upgrade, when it was only an orphan — and it now
     collides with the client's own IMP-009, an unrelated lesson recorded since. v1.2.0
     added two more numbers (IMP-043, IMP-044).
  3. FRAMEWORK-REPO-ONLY BLOCKS. The hybrid-regime box of `docs/01` and its RESUMPTION
     patch, the "Plan block" section of `sessions/README.md` (IMP-024/034). They declare
     their own scope, so they are not wrong in a client, but they are dead weight there:
     the client drops them as framework-repo-specific (a decision taken at its first
     upgrade), and they also carry the pointers and numbers of points 1-2. They return
     with upgrades whose `vY` touches those files: the `docs/01` box with the first and
     the third; the `sessions/README.md` block only with the third, since the earlier
     upgrades left `memory/` untouched (IMP-046).
- The cost is recurring: the client keeps a standing decision to prune/rephrase these
  "file by file" at every upgrade (taken at its first upgrade, re-applied at the second
  and third). Nothing in the framework catches a new occurrence when it is written.
- Proposal: NOT decided here (retro). Directions to evaluate: (a) method text cites no
  framework IMP number (the preferred option of the relayed lesson) — or a namespace
  such as `fw:IMP-NNN`; (b) pointers outside the payload removed, or made conditional;
  (c) framework-repo-only text moved out of the payload (`CONTRIBUTING.md` already
  describes the hybrid regime); (d) an AUTOMATIC check in the framework repo that greps
  the payload for these patterns — a `make` target or a lint check, NOT "CI": there is
  none in any tag. Caveat for (d): `Makefile` and `/lint-memory` are themselves
  payload, so a check hosted there ships to clients and must declare itself moot there
  — the mirror of `/harvest-framework`, which is moot in the framework repo.
- Expected benefit / risk: an upgrade stops re-deriving and re-applying the same
  pruning, and a new dangling pointer is caught when it is written, not at the next
  client upgrade. Risk: dropping IMP numbers loses traceability inside the framework
  repo — the pointer can live in the commit message or the CHANGELOG instead.

### IMP-050 (points 3-5) — Upgrade procedure hardening: the remaining mechanical traps of `SETUP.md`
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — the read-only
  assessment of the third real upgrade (v1.0.0 → v1.2.0, across the full translation of
  v1.1.0) found five traps that *Upgrading the framework* does not guard against
  (points 4-5 were then avoided rather than hit)
- Status: points 1-2 APPLIED on 2026-09-25, commit 190404a — see *Applied*, IMP-050
  (points 1-2). Points 3-5 below stay OPEN, numbered as before (IMP-037's case-#3
  annotation cites them by number).
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
  belongs with IMP-050 (points 3-5)'s Step 5 inputs. (3) Not a gate matter — a factual
  defect listed in the note for the user's decision: `reset-task.sh` is filed METHOD
  while it carries a setup slot (the protected branches) whose natural answer is
  inline, a predictable hybrid like the setup-customised commands. A plain overwrite is
  not silent (Step 4's marker grep re-surfaces the slot, edge case 7 catches the filled
  one), but the project must then re-answer a slot the §2 checklist never lists.

### IMP-054 — The `git push` deny does not catch `git -C <dir> push`: a decorative boundary
- Date: 2026-09-25 | Origin: [[2026-09-25-imp-050-read-by-tag]] — the deny list matches
  only the literal `git push …` form, while IMP-050 (points 1-2) makes `git -C "${FW:?}"`
  the upgrade's idiom (raised by the user)
- Priority: HIGH (user decision, 2026-09-25): to be verified and decided at the next
  retro, before anything else relies on the boundary. NOT corrected in the block that
  raised it (user decision).
- Observed problem: `.claude/settings.json` denies `Bash(git push:*)` — with
  `git reset --hard:*`, `git clean:*`, `git branch -D:*`, `rm -rf:*` — as the enforcement
  of the execution boundary of `docs/04` ("the configuration (`.claude/settings.json`)
  denies automatic pushes — that is intentional"). Claude Code's own documentation says a Bash rule matches the
  command text after splitting compound commands and stripping a fixed set of wrappers,
  and "doesn't match the same program invoked in a different form, so a deny or ask rule
  covers the invocation Claude usually produces and isn't a security boundary around
  the program". Its example: `Bash(git push *)` does not stop `git -C . push origin main`,
  `git -c push.default=current push origin main` or `git 'push' origin main`; the
  auto-mode page names `git -C <dir> push` explicitly (code.claude.com/docs/en/
  permissions.md, *What a Bash rule doesn't match*; auto-mode-config.md, *Add a human
  checkpoint*). The same holds for every deny prefix above (`git -C x reset --hard`,
  `git -C x clean`, `rm -r -f`, …). Established from the documentation, NOT probed: a
  probe is an attempted push, and was not run.
- Why it matters now: IMP-050 (points 1-2) normalises `git -C "${FW:?}"` — the very form
  that slips past the prefix. And on 2026-09-24 a subagent ran `switch` and `archive -o`
  on the real repo despite a written read-only constraint
  ([[2026-09-25-imp-050-read-by-tag]]): what stops an agent is a permission, not a
  sentence. A deny that holds only for the literal form is IMP-020's class — a safety
  net that gives a false sense of security.
- Proposal: NOT decided here (retro). Directions to evaluate: (a) verify on the real
  matcher against a throwaway local bare remote, run by the human or on explicit
  authorisation; (b) a `PreToolUse` hook that parses the git subcommand — the documented
  way to get "a checkpoint that inspects the full command text"; (c) extra deny patterns
  for the known forms (`git -C * push`, …) — cheap, never complete; (d) `docs/04`
  (*Permission configuration*) states that the deny list guards the usual form and is
  not the boundary, (b) being the enforcement. Related, usability side of the same
  matcher: `git -C "${FW:?}" diff` escapes the `git diff:*` allow prefix, and
  `show`/`ls-tree`/`rev-parse` are not in the allow list at all; whether Claude Code's
  built-in read-only git set covers the `-C` forms is not documented — to be observed at
  the next upgrade, not assumed.
- Expected benefit / risk: the boundary `docs/04` promises holds for the forms an agent
  actually writes. Risk: a hook is code to maintain and to prove RED→GREEN, and an
  over-broad matcher blocks legitimate reads.

### IMP-055 — Delegated agents that run git in a shared working tree: isolate them, snapshot before and after
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project:
  a multi-agent security gate over a commit range passed clean, but left the repository
  on another branch
- Observed problem (client-side, relayed): the review agents inspected the range with
  git commands in the SHARED main working directory, not isolated. At least one ran
  `git checkout` to read files, and the back-and-forth between the integration branch
  and the range's tip left HEAD on the integration branch at the end of the run: the
  feature branch was intact (no work lost) but no longer checked out, and the harness
  reported its files as "modified by user", as if the user had discarded the
  deliverable. The client's own practice (the diff passed inline, read-only tools only)
  does not scale to a ~20-file diff, where agents gain from reading whole files — and it
  was not followed.
- On the framework's source: no written practice covers how delegated agents inspect a
  repository — `docs/03` and `security-review.md` say nothing about it, and the
  Precondition of `SETUP.md` is scoped to the upgrade's reads. The practice the lesson
  would "extend" is a client-local rule, so here the proposal INTRODUCES one. Scope: any
  delegated agent that runs commands against a shared working tree, not only review
  workflows — this repo's own case was an assessment harness.
- Kin — this repo's own incident (*Applied*, IMP-050 (points 1-2), *Further evidence for
  (1)*; [[2026-09-25-imp-050-read-by-tag]], item 1): a subagent ran `switch --detach`
  and `archive -o` on the real framework repo although its prompt forbade checkout and
  switch. The client's case is a third live one of a process moving the HEAD of a
  shared tree, with a new symptom: the harness attributes the changes to the user.
- Proposal (as relayed; NOT decided here — retro), with the verification's corrections:
  (a) ISOLATION first — relayed as a linked worktree per agent (a harness option); the
  verification prefers a throwaway clone per agent, the form that held here and the
  only one compatible with `SETUP.md`'s "no `worktree add` in the framework repo" when
  the shared repo is the framework; a linked worktree defeats the incident's cwd
  default, but creating it writes into the shared repo, it shares the refs (a branch
  made in it shows in the main repo) and it does not stop an explicit
  `git -C <main> switch`. (b) A prompt ban on HEAD-moving commands is one layer, not an
  alternative to (a): the incident's prompt carried exactly that ban. And "does not move
  HEAD" is the wrong criterion: `archive -o` moves no HEAD yet wrote into the repo; the
  lesson's own allowed commands write too (`git diff --output`, `git show --output`
  under `-C` land in the repo root), and `diff A B`, `show <commit>` and `log -p` can run
  a configured textconv. (c) A BEFORE/AFTER snapshot — HEAD, branch, status and
  untracked files, reflog length, stash, worktrees — as practised in
  [[2026-09-25-imp-050-read-by-tag]], not an after-only check of HEAD and branch, which
  misses an untracked archive and a move-and-return (the reflog grows, HEAD does not
  change). Its status runs as `git --no-optional-locks status` (or
  `GIT_OPTIONAL_LOCKS=0`): a plain `git status` writes the shared `.git/index`, and its
  lock can make a concurrent git process fail (git-status(1), *BACKGROUND REFRESH*).
- The permission side, for IMP-054's retro: the incident's commands (switch, checkout,
  restore, archive) are in no deny rule in any form, and a project-wide deny would clash
  with `docs/04`, where the main session creates and switches branches itself. So a
  delegated agent's boundary is per agent — isolation, or a hook aware of the agent's
  scope (IMP-054, direction (b)). That prefix rules miss `-C` is already in IMP-054.
- Expected benefit / risk: delegated work stops leaving the shared repository in an
  unexpected state, and scales to large diffs without a giant inline. Risk: a clone per
  agent costs setup time and disk; (c) is free.

### IMP-056 — The security gate checks what the code does, not what the product claims
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project:
  a presentation-only deliverable, behaviourally clean for both adversarial lenses,
  still carried four truth defects in what it asserted
- Observed problem (client-side, relayed): behaviourally the diff really was
  presentation-only — both review lenses confirmed that consent, the dry-run branches,
  dispatch and exit codes were intact. Yet it carried four TRUTH defects: an end-of-run
  summary ATTESTED in the persistent session log that components without a dry-run
  gate had "previewed, changed nothing" (false for two of them), and a disk line could
  claim space freed on a cache that had grown. The author's reasoning was "the label
  follows the contract, the bug is elsewhere (a known debt)" — but reality did not
  honour the contract, and the user documentation just written turned the label into a
  promise. (Client-side: the gate passed only after the four were fixed.)
- On the framework's source: `docs/03` names only defects of ACTION ("a bypassed check,
  a spoof, an exposed administrative endpoint") and `security-review.md` has no
  truthfulness check: nothing covers the assertions a product emits.
- Proposal (as relayed; NOT decided here — retro): an explicit lens in `docs/03`,
  "claims, not only actions": when a deliverable produces ASSERTIONS about security
  properties (badges, states, summaries, "nothing was changed" messages) — especially
  when they end up in a persistent artifact (log, report, export) — each one is
  verified against the REAL behaviour of the code it describes, not against the
  contract that code is supposed to honour. Operating criterion: a string that asserts
  something did NOT happen needs a datum that proves it, kept separate from the
  classification it would otherwise be inferred from.
- The mechanism to name: a known, accepted debt (`docs/03`, *After the review*) becomes
  a written promise to the user through a label or a freshly written user doc.
- Open for the retro: how the lens's trigger (a deliverable that emits security
  assertions) meets `docs/03`'s sensitive-only scope (and `docs/00` step 2) — either
  the lens carries its own trigger, or "sensitive" includes the surfaces that attest
  security properties. Precedent here: IMP-020, the hook that exited 0 with a
  misleading warning. Kin: IMP-058 (its perimeter), IMP-057.
- Expected benefit / risk: a known, accepted debt can no longer become a written
  promise unnoticed. Risk: none — one more lens, applied only where there are
  assertions.

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

### IMP-058 — Widening a claim beyond the diff widens the gate's perimeter
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project:
  a small fix attested as verified a claim over a whole registry, four entries of which
  were false
- Observed problem (client-side, relayed): the task closed two known violations, but to
  do so it set every entry of an 18-entry registry to "compliant", added a class test
  and rewrote the user doc from "these units do not honour the flag" to "every unit
  stops at the preview". The diff touched 2 units; the CLAIM covered 18 — and four of
  them were false, for defects the branch had not introduced (an implicit self-update of
  an external tool — IMP-059 —, an ungated deletion, a check that executed untrusted
  input). The branch broke nothing: it ATTESTED as verified what was only declared. A
  review limited to the changed files — the normal practice — would never have seen it.
- On the framework's source: the gate is diff-scoped — `docs/03` runs `/security-review`
  "on the branch diff", `security-review.md` reviews "the modified files (`git diff`)";
  the only check beyond the diff, the coherence review of `docs/01`, is scoped to
  shared-code refactors and renamed titles (IMP-043).
- Proposal (as relayed; NOT decided here — retro): next to IMP-056's lens, a BREADTH
  criterion in `docs/03`: when a deliverable generalises a claim (from "these N" to
  "all"), the perimeter of the gate is the CLAIM's, not the diff's. Triggers: a
  registry/config value going from exception to uniformity; a test replacing point
  cases with a loop over the whole set; a doc sentence losing its exceptions (an
  "except…" that disappears).
- Close kin of IMP-056 — **evaluate unification at the retro**: IMP-056 is the lens
  (claims, not only actions), this entry its perimeter (the claim's set, not the diff's).
- The framework's own occurrence, as a pattern: C11 ([[2026-09-24-third-upgrade-lessons]])
  — decision 3 of the language deliverable scoped backward compatibility to the three
  grep-coupled tokens ([[2026-07-20-language-rule-phase1]]), while the 1.1.0 CHANGELOG
  sentence put five kinds of strings, the escalation delimiters included, under "Every
  READER accepts the legacy Italian form as well"; `docs/05` never got a dual-form
  reader. The defect is recorded there; the pattern was not. And `docs/02`'s
  ALL-entities invariant is itself a widening trigger — with a known debt, its form is
  IMP-057's.
- Expected benefit / risk: catches the defect class where the code is correct and the
  promise is false. Risk: a wider gate — to apply only when the claim really widens.

### IMP-059 — Gating an external tool's invocation is not enough: check what the tool runs by itself
- Date: 2026-09-26 | Origin: [[2026-09-26-client-harvest-registration]] — harvest from a client project:
  a dry-run gate that looked closed while the gated tool kept updating itself
- Observed problem (client-side, relayed): putting a package manager's update behind
  the dry-run gate seemed to close the issue. But the tool runs its own update
  automatically before several of its subcommands, and not even the tool's own dry-run
  flag stops it — the decision is taken before the arguments are read. A preview-only
  session kept rewriting the tool's index through units that "only list" things: the
  front door closed, the service door open — invisible to any test with a mock, because
  a mock does not reproduce the real tool's implicit behaviour.
- On the framework's source: nothing in `docs/02` (I/O, dependencies, *verify against
  REAL artifacts*) or `docs/03` covers it; it extends the Definition of Done's "not
  just isolated units with mocks" to the external tools a component drives.
- Proposal (as relayed; NOT decided here — retro): in `docs/02` (or the technical-rules
  template), when you gate the invocation of an external tool, check its source/docs
  for paths where it re-runs the gated action implicitly, and use the official
  off-switch (typically an environment variable). It applies to any tool with automatic
  behaviours: package managers, git (hooks, auto-gc), CI runners, formatters with a
  watch mode.
- Evidence inside the framework (the verification's, not the lesson's): `git status` —
  allowed as `Bash(git status)` by `settings.json`, a read-only inspection for
  `docs/04` (*Permission configuration*) — writes `.git/index` by itself (an
  optional-lock refresh); git documents the off-switch, `git --no-optional-locks` /
  `GIT_OPTIONAL_LOCKS=0` (git-status(1)). Config-dependent: `status` runs a configured
  fsmonitor, and `diff A B`, `show <commit>` and `log -p` run a configured textconv
  (off-switch `--no-textconv`). Observed, not probed: the generated `commit-msg` hook
  runs commitlint through `npx --yes` with unpinned packages, and an npm debug log of a
  commit in a grafted project shows it contacting the package registry — an implicit
  network step behind the commit gate.
- Kin: IMP-054 — the same class, a different opener (there the CALLER reaches the
  program through another syntax; here the TOOL reaches the effect by itself); IMP-020 —
  a different mechanism with the same outcome, a false sense of security.
- Expected benefit / risk: avoids gates that look closed and are not. Risk: none — a
  one-off check per tool, usually a grep in its docs.

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
- Approved in the targeted retro after the first real upgrade (brew v0.2.0→v0.5.1,
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

### IMP-050 (points 1-2) — The framework is read only by tag, via `git -C "${FW:?}"` → applied on 2026-09-25, commit 190404a
- Date: 2026-09-24 | Origin: [[2026-09-24-third-upgrade-lessons]] — the upgrade read the
  framework from its shared working tree and, by bare tag names, from the project's own
  tags (points 1-2 of IMP-050; points 3-5 stay OPEN, see IMP-050 (points 3-5))
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
  compared with `rev-parse`) is not covered: input for IMP-050 (points 3-5). Kin:
  IMP-055 (delegated agents in a shared working tree).

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

### IMP-037 — The `/upgrade-framework` read-and-print command (the inverse twin of `/harvest-framework`) → deferred on 2026-07-17
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
  performed on 2026-07-17 (brew, v0.2.0→v0.5.1) — see
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
