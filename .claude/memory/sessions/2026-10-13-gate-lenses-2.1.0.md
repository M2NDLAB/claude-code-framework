---
date: 2026-10-13
task: v2.1.0 — the gate's lenses (IMP-056, IMP-058, IMP-059, IMP-071, IMP-073, IMP-084, IMP-087) — two principles, each rule written in one place; hooks-install.sh's message says what it measures
branch: feat/gate-lenses-2.1.0
status: in-progress
model: 'claude-opus-5-5'
turns: 2
tags: [session, security-gate, docs, imp, plan]
---
# Session 2026-10-13 — v2.1.0: the gate's lenses

> A dedicated branch from `main` at `b6035c3` (v2.0.0, its tag signed). Probes only in the
> session's scratchpad. Hybrid regime: no `plans/`, this note is the plan-pointer. Phase 1,
> read-only on `main`, the same day; then the user's decisions.

## The fields of this very note
- `model: 'claude-opus-5-5'` — the main session.
- `turns: 2` — the user's brief for phase 1, with v2.0.0 integrated; the user's decisions.

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

## Plan (one commit per task)
- [ ] 1. The registrations — IMP-089, the history scan's limit; the product's "contained local changes" as IMP-073's occurrence — and this note with its plan; then the agent's persistent memory emptied — commit: —
- [ ] 2. Apply IMP-056: `docs/03` gets *The lenses of the gate*, with its first lens, *Claims, not only actions*; `/security-review` recalls it in one line — commit: —
- [ ] 3. Apply IMP-058: the claims lens's perimeter — the claim's set, not the diff — commit: —
- [ ] 4. Apply IMP-073: `docs/02`'s Definition of Done gets the records' line — written after the last measurement they cite — commit: —
- [ ] 5. Apply IMP-071: the same line, no wider than the measurement — a list that declares itself complete held against its source, or narrowed — commit: —
- [ ] 6. Apply IMP-059: the second lens, *The real path*; `/security-review`'s line recalls both — commit: —
- [ ] 7. Apply IMP-087: `docs/02`'s *Tests that demonstrate* gets the tests' line — cases under the users' real configurations — commit: —
- [ ] 8. Apply IMP-084: the same line — each case checks that its datum reaches the program before it counts — commit: —
- [ ] 9. `hooks-install.sh` says what it measures — the hook differs from the one this version generates —; `scripts/README.md` and `SETUP.md` stop inferring a customisation; a case of its self-test red first — commit: —
- [ ] 10. The CI's rounds (block 0, the user's pushes): what fails, fixed with new commits, until green on the three — commit: —
- [ ] 11. ONE reviewer, read-only on git, the snapshot before and after, applying the two lenses to the framework's payload: HIGHs fixed here, MEDIUMs and LOWs recorded as IMPs, trivial text fixed; the gate's verdict written — commit: —
- [ ] 12. `/retro` and `/checkpoint`: the upgrade 2.0.0 → 2.1.0 rehearsed on the final payload — commit: —
- [ ] 13. `/integrate`: the CHANGELOG 2.1.0 entry, claiming only what was measured; the bump computed again against the expected MINOR; the final block 0 green on the three, then blocks 1 and 2 — commit: the CHANGELOG commit (its own sha cannot be written in it)

The applying commits (tasks 2 to 8) each carry their IMP's part of the text and move the
entry to Applied, as `docs/06` says. Task 10 may take several commits, one per round of the
CI; each round needs the user's push.

## Resumption notes
- The branch is local until task 10's first block 0; from then on it is public, and no
  commit is rewritten.
