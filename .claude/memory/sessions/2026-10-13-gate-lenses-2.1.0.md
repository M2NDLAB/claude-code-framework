---
date: 2026-10-13
task: v2.1.0 — the gate's lenses (IMP-056, IMP-058, IMP-059, IMP-071, IMP-073, IMP-084, IMP-087) — two principles, each rule written in one place; hooks-install.sh's message says what it measures
branch: feat/gate-lenses-2.1.0
status: completed
model: 'claude-opus-5-5'
turns: 3
tags: [session, security-gate, docs, imp, plan]
---
# Session 2026-10-13 — v2.1.0: the gate's lenses

> A dedicated branch from `main` at `b6035c3` (v2.0.0, its tag signed). Probes only in the
> session's scratchpad. Hybrid regime: no `plans/`, this note is the plan-pointer. Phase 1,
> read-only on `main`, the same day; then the user's decisions.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 3` — the user's brief for phase 1, with v2.0.0 integrated; the user's decisions;
  the user's follow-ups on the gate's trigger and the bump.

## The brief — persisted so a /clear does not lose it
- v2.0.0 integrated and published by the user (`b6035c3`, the tag v2.0.0 signed, the branch
  deleted locally and on GitHub); this repository's hooks regenerated with
  `make hooks-install`, the prerequisite check at 0 FAIL and 0 WARN.
- The FIRST commit of the next release records, as an OPEN IMP of LOW priority, the history
  scan's limit: `gitleaks detect` does not find a key committed in the past in a file marked
  `binary` or `-diff`; `detect --no-git` covers only the current content. Trigger: the first
  graft into a project whose `.gitattributes` marks key files as binary — IMP-089.
- Next block, the gate's lenses — PHASE 1, analysis only, no write in the repository, no
  branch: IMP-056 (the gate looks at claims too, not only actions), IMP-058 (the claim's
  perimeter), IMP-059 (the implicit behaviours of the external tools behind a gate), with
  this cycle's real cases — H1 and N1 (gitleaks depending on the user's git configuration,
  invisible to the gate and to the hermetic CI), IMP-073's occurrences, IMP-071, IMP-084,
  IMP-087. For each entry: its state on `main`, the real cases that confirm or refute it,
  options, a recommendation; whether 056, 058, 059, 073, 084 and 087 reduce to one or two
  principles applied together rather than six separate interventions. `tools/`' principle
  holds here too: no new rule without an observed defect.
- One more case for IMP-073's family, observed by the user: `hooks-install.sh` says
  "contained local changes" also when the hook it replaces is only the one the previous
  release generated, with no change of the user's.
- Deliver, for each entry, its state, options and recommendation; the proposal to merge; the
  split into releases with the EXPECTED bump; then STOP.

## Phase 1 — the analysis (read-only, on `main` at `b6035c3`)
- **State.** The seven entries all OPEN, none applied. `docs/02`, `docs/03` and
  `security-review.md` unchanged since v1.5.0: none covers a product's assertions, a claim's
  perimeter, a gated tool's implicit behaviour, or the user's configuration in a test. The
  gate is the diff's: `docs/03` runs `/security-review` "on the branch diff", which reviews
  "the modified files (`git diff`)".
- **IMP-056, confirmed in the framework's own product:** the pre-commit relayed gitleaks'
  "no leaks found" after "scanned ~0 bytes" (H1) — an assertion of absence with no datum;
  the prerequisite check's "OK gitleaks 2026" (M2); `install_generated`'s "contained local
  changes", inferred from a difference (the user's case). Refuted by none.
- **IMP-058, confirmed:** H1 lay outside the reviewed range — the pre-commit's text
  unchanged — and was found because the user scoped the review to the hooks, not the diff;
  the scan error's claim widened from what was read (8.4.0 to 8.18.1) to "before 8.18.2",
  a sentence losing its exception, in five places, one a public commit; D1's floor was a
  claim over 107 tags, and reading them all found M1.
- **IMP-059, confirmed:** H1's colour, the masking textconv, N1's attributes, M1's
  `diff.external` and 8.0.0 to 8.1.3 writing `.gitleaks.toml`, npx's registry fetch; and,
  found by measuring, macOS's `mktemp -d` ignoring `TMPDIR` and bash 3.2 going on past an
  arithmetic error in an `export`. IMP-059's own evidence of 2026-09-26 already named
  "`diff A B`, `show <commit>` and `log -p` run a configured textconv": the lesson was
  recorded and did not prevent the defect, having no place in the method.
- **IMP-073 and IMP-071:** `7d2052b`, `5f05004` and four documents; the self-test header
  "Every rule the check advertises…". **IMP-084:** applied in practice in v2.0.0 (cases 5
  to 7 check that their configuration takes hold; the CI's rounds read in the log).
  **IMP-087:** H1, N1 and the textconv, all hidden by `GIT_CONFIG_GLOBAL=/dev/null`.
- **Two principles, applied together.** P1 — a claim covers exactly what a datum shows: the
  product's (056), at the claim's perimeter (058), and the records' (073, 071). P2 — the
  gate and the test look at the real path: the gated tool's own behaviour (059), the user's
  configuration (087), the platform's transport (084). Together, because a gate's verdict, a
  green, a "no leaks found" are claims (P1) about a path (P2): H1 was both.
- **Set aside:** the hook refusing when gitleaks reports 0 bytes scanned for staged changes —
  the datum is a log line, not an interface, not verified across 8.18.2 to 8.30.1.

## The decisions (the user's, 2026-10-13)
1. **Merge: yes.** P1, a claim covers exactly what a datum shows — IMP-056, IMP-058,
   IMP-071, IMP-073; P2, the gate and the test look at the real path — IMP-059, IMP-084,
   IMP-087.
2. **Each rule in one place**, so as not to repeat the class of C11/C12 — a statement in two
   places, drifting apart. The two lenses' text ONLY in `docs/03`; `/security-review`
   recalls them in one line, without copying their text; `docs/02` gets only the Definition
   of Done's line — records written after the last measurement they cite, and no wider than
   it — and the tests' line — cases under the users' real configurations, each checking that
   its datum reaches the program before it counts.
3. **hooks-install's message: option (a)**, the test red first.
4. **One release, v2.1.0**, the EXPECTED bump MINOR — computed again by `/integrate`.
5. **The applying commits: one per IMP**, as `docs/06` says — seven.
6. **IMP-071 in P1; IMP-072 out.**
- **The reviewer's limit** (task 11): it applies the two lenses to the framework's payload;
  HIGHs are fixed in this release; MEDIUMs and LOWs are recorded as IMPs, trivial text
  corrections aside. The release does not grow beyond its scope.
- **The first commit:** the pending registrations. Then the usual flow: a dedicated branch,
  block 0 with the CI green on the three on every pushed state, ONE reviewer, `/checkpoint`,
  blocks 1 and 2 with the tested tip checked and the branch deleted locally and on GitHub.

**The user's follow-ups (2026-10-13), on the pushed tasks 1 to 9:**
- The gate's trigger as written in the lens — a deliverable whose product asserts a
  security property is under the gate for that alone — is kept.
- The bump: the new rules of `docs/02` and `docs/03` sit in commits typed `chore`, as
  `docs/06` has the applying commits. Computed from the types alone it comes out a PATCH;
  by `docs/04`'s criteria a new rule in the payload is a MINOR. `/integrate` computes it on
  the CONTENT — the new rules in the payload —, not only on the types, and declares its
  reasoning before the tag: v2.1.0 expected. Recorded as an occurrence of IMP-074.

## Plan (one commit per task)
- [x] 1. The registrations — IMP-089, the history scan's limit; the product's "contained local changes" as IMP-073's occurrence — and this note with its plan; then the agent's persistent memory emptied — commit: 6d7844a
- [x] 2. Apply IMP-056: `docs/03` gets *The lenses of the gate*, with its first lens, *Claims, not only actions*; `/security-review` recalls it in one line — commit: 4937100
- [x] 3. Apply IMP-058: the claims lens's perimeter — the claim's set, not the diff — commit: b9b003f
- [x] 4. Apply IMP-073: `docs/02`'s Definition of Done gets the records' line — written after the last measurement they cite — commit: 2f13de1
- [x] 5. Apply IMP-071: the same line, no wider than the measurement — a list that declares itself complete held against its source, or narrowed — commit: 1278bf2
- [x] 6. Apply IMP-059: the second lens, *The real path*; `/security-review`'s line recalls both — commit: 9575569
- [x] 7. Apply IMP-087: `docs/02`'s *Tests that demonstrate* gets the tests' line — cases under the users' real configurations — commit: a6f6463
- [x] 8. Apply IMP-084: the same line — each case checks that its datum reaches the program before it counts — commit: d35fc6c
- [x] 9. `hooks-install.sh` says what it measures — the hook differs from the one this version generates —; `scripts/README.md` and `SETUP.md` stop inferring a customisation; a case of its self-test red first — commit: bf3879b
- [x] 10. The CI's rounds (block 0, the user's pushes): what fails, fixed with new commits, until green on the three — commit: none to fix — round 1 green on `bf3879b` (run 38412448958), recorded with task 11
- [x] 11. ONE reviewer, read-only on git, the snapshot before and after, applying the two lenses to the framework's payload: HIGHs fixed here, MEDIUMs and LOWs recorded as IMPs, trivial text fixed; the gate's verdict written — commit: b7e3f09, 56099e3, and the record of the review (its own sha cannot be written in it)
- [x] 12. `/retro` and `/checkpoint`: the upgrade 2.0.0 → 2.1.0 rehearsed on the final payload — commit: the checkpoint (its own sha cannot be written in it)
- [x] 13. `/integrate`: the CHANGELOG 2.1.0 entry, claiming only what was measured; the bump computed again against the expected MINOR; the final block 0 green on the three, then blocks 1 and 2 — commit: the CHANGELOG commit (its own sha cannot be written in it); blocks 0, 1 and 2, the user's

The applying commits (tasks 2 to 8) each carry their IMP's part of the text and move the
entry to Applied, as `docs/06` says. Task 10 may take several commits, one per round of the
CI; each round needs the user's push.

## The applying commits (tasks 2 to 8)
- Each commit carries its IMP's part of the text and moves the entry to Applied, its heading
  dated; the commits' shas go into the headings at the checkpoint, as the earlier applying
  commits had theirs written by the commit after them (`ff7fbb6` and `63a306b`, IMP-043).
- `docs/03` gets *The lenses of the gate* (IMP-056, IMP-058, IMP-059): *Claims, not only
  actions*, its perimeter the claim's set, and *The real path*; the gate's first step points
  at the lenses, and a deliverable whose product asserts a security property is under the
  gate for that alone — the trigger IMP-056 had left open. `/security-review` recalls both
  lenses in its check 11, without their text.
- `docs/02`: the Definition of Done's point 10, the records (IMP-073, IMP-071); *Tests that
  demonstrate*'s new line, the users' configurations and the datum reaching the program
  (IMP-087, IMP-084).
- Caught on the way, each local and amended: two commit messages with a body line read as
  the footer, or a claim wider than its datum ("a month before" for sixteen days; "the
  review" for the review and the main session's measures; a forward clause about work not
  done yet) — this release's own rule, applied to its commits. And the documentation check
  refused "CHANGELOG" in a payload page: a project has no such file — "a changelog entry".

## The installer's message (task 9)
- The new case of `scripts/test-hooks-install.sh`, case 7, red first: a re-run over the hooks
  in place saved and said nothing, and over an earlier release's commit-msg — the generated
  hook with another pin — it saved a `.bak` byte for byte, but the message said "contained
  local changes". Green after: "differs from the hook this version generates (an earlier
  release's, or a local change)". Two mutants caught — no `.bak` saved; a `.bak` and a
  warning over an unchanged hook. `scripts/README.md` and `SETUP.md`'s Step 4 stop inferring
  a customisation.

## The CI's rounds (task 10)
Round 1, the branch's first push: `bf3879b`, run 38412448958, green on the three jobs —
Ubuntu in 81 s, macOS in 241 s, Windows in 685 s. Read in the log: `make test-scripts` 29
PASS on Ubuntu and macOS, 28 and the dangling-symlink SKIP on Windows, the new re-run case
passing on the three; docs-check 0 FAIL, 0 CHECK; the real hooks' PASS line on the three.

## The review (task 11) — one reviewer, read-only on git
One agent, run as a workflow, with the two lenses of `docs/03` as its mandate over the whole
payload, not only the diff, and the user's limit; its sandbox a clone at `9debae4` and a
throwaway project with the generated hooks, made by the main session. The repository's
snapshot, its tracked files, its three hooks and its `.git/config` identical before and
after. Its findings: 1 HIGH, 4 MEDIUM, 17 LOW (four marked trivial text), 1 INFO.

**The main session's measures** (throwaway repositories; the reviewer's probes):
- H1: with the hooks in place a commit holding a key is refused; after
  `git config core.hooksPath .husky/_`, as husky sets it, the same commit goes through.
  The push part of the probe was not run — a `git push` is denied to the agent, even to a
  throwaway remote —: the pre-push goes inert by the same lookup. husky 9.1.7's source sets
  `core.hooksPath` unless `HUSKY=0` (read).
- M1: a rebase stopped on a conflict, a key pasted into the resolution, `--continue`: exit
  0, the key committed. M4: `reset-task.sh --yes` with a staged change: ` M f` afterwards,
  the staged content in the working tree. L4: a symlink turned into a key file marked
  binary: the pre-commit exits 0. L1: under an LFS-like clean filter the index holds the
  pointer, the pre-commit exits 0, the store holds the key.
- L8 and L7: Claude Code's environment-variable reference documents `CLAUDECODE`, set in
  IDE terminals too, and `CLAUDE_CODE_CHILD_SESSION` (read on 2026-10-13).

**Within the user's limit:**
- H1, HIGH — fixed, `b7e3f09`: the route declared where the claims were made (`docs/04`'s
  table, `docs/03`'s baseline, the READMEs), the installer's refusal saying that a hook
  manager sets `core.hooksPath` again, integrating into it being the durable choice — the
  outcome *The real path* names for a path that cannot be closed. A new case of the
  self-test, case 8, red first; a mutant without the refusal caught. Detection at use time
  recorded (IMP-090).
- The four trivial texts — fixed, `56099e3`: `CLAUDECODE` documented (`docs/04`, the
  generated pre-push's comment); "another release's" for "an earlier release's"; the scan
  apart's directory gone "a SIGKILL apart"; `docs/00`'s cycle and `/security-review`'s
  opening following the gate's trigger and perimeter.
- Recorded, the user's limit: M1 to M4 as IMP-091 to IMP-094; L2–L4 as IMP-095; L1 and L16
  as IMP-096; L7 as IMP-097; L9 as IMP-098; L13 as IMP-099; L14 and L15 as IMP-100; L17
  with IMP-090; L5 with IMP-089; L6 as IMP-079's occurrence; I1 with IMP-092.

**The gate's verdict (`docs/03`):** HIGH H1 resolved, `b7e3f09`, its detection IMP-090.
MEDIUM M1 to M4 accepted as recorded debt by the user's limit for this release, each with
its IMP — M1's and M2's claims, in `docs/03` and `docs/04`, stay wider than the code until
their IMPs are decided. LOW: four fixed, the rest recorded. INFO recorded.

## Task 12 — the upgrade rehearsed, the retro, the checkpoint
**The upgrade 2.0.0 → 2.1.0, rehearsed on the final payload** (`8e44a42` and the draft entry,
committed and tagged v2.1.0 in a clone only; a project grafted at v2.0.0 with every setup
answer in place, its v2.0.0 hooks installed), with LF and with CRLF line ends, the same
results on both:
- the prerequisite check from `T`, 0 FAIL, 0 WARN; `preflight` 0/0; `inventory` 0 FAIL,
  0 CHECK, the same line for line — `hooks-install.sh` diverged with 0 conflicts of 312
  lines, the seven METHOD files at `vX` in the project;
- Step 3: the METHOD files with the tag's modes, the 3-way clean, the project's answers kept;
- Step 4: `make hooks-install` exit 0 — "pre-push differs from the hook this version
  generates (another release's, or a local change)", its `.bak` 2.0.0's hook byte for byte;
  the pre-commit and the commit-msg unchanged, no `.bak`. Refused in the upgraded project: a
  fake secret, a message without a type, a secret under `git -c color.ui=always`, a private
  key in a `*.key binary`; no scan directory left; the project's `make test-scripts` green,
  its new cases 7 and 8 among them;
- Step 5: `invariant` 0/0; `post` 0/0 once the pin reads v2.1.0. The rehearsal's own script
  first left the pin's version line at v2.0.0 — its substitution did not match an escaped
  regex — and was rerun with the line written right.

**The retro.** The applied entries carry their commits and, for the lenses, what their first
use verified: the review's HIGH and the MEDIUMs its perimeter reached; point 10 narrowed
three of this release's own messages before their push. IMP-078 gets a sixth occurrence,
after which each message was checked by a grep before its commit. New: IMP-101 — each new
case of the hooks' self-test edits two fixtures of the documentation check's.

## Resumption notes
- The branch is public since round 1 (`bf3879b`): no commit is rewritten. The last green
  run is round 1's; every commit after it — `9debae4` to the CHANGELOG commit — reaches the
  CI through the final block 0; block 1 waits for that run's green on the three jobs, and
  checks that the merged tree is the tested one.
- Task 13's bump, computed on the content as the user asked: by the commit types alone the
  range gives a PATCH — two `fix`, the rest `docs` and `chore`, the seven apply commits among
  the `chore`s (IMP-074's occurrence) —; by the content, new rules in shipped payload files
  (`docs/00`, `docs/02`, `docs/03`, `/security-review`) and no break of the contract, a MINOR:
  v2.1.0 from v2.0.0, as expected.
- Next: the user's blocks — the final block 0, then blocks 1 and 2.
