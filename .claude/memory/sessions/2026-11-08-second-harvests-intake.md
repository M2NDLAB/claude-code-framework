---
date: 2026-11-08
task: two field reports and a set of security items recorded, each reproduced at v4.1.0 first, deduplicated against the whole backlog, with a PRELIMINARY verdict — nothing applied, the triage waits for the next derived project's harvest
branch: chore/imp-intake-second-harvests
status: in-progress
model: 'claude-opus-5-5'
turns: 1
tags: [session, imp, harvest, security]
---
# Session 2026-11-08 — The second harvests' intake

> Recording only: a branch of its own from `main` at `cca84f2`, its diff meant to stay inside
> the framework's records — this note and entries of [[LEARNINGS]] —, so no gate, no retro and
> no tag (`CONTRIBUTING.md`, *This repo's workflow*). A Level 1 correction to a shipped file,
> if one is found, is declared here and changes that.

## The user's brief, 2026-11-08 (translated from Italian)
Project names replaced by neutral labels, as everywhere in this repository: "the first derived
project" for the one whose second harvest section A brings; "the static-site project" for
section B's; "the next derived project" for the one whose harvest the triage waits for.

"Session on the framework: the intake of two field reports plus the security items.
Reproduction, recording, deduplication and a PRELIMINARY verdict. Do NOT apply any IMP (Level
2). A purely factual correction follows Level 1, but declare it. The final triage, and the
choice of what goes into the corrective release, are made when the next derived project's
harvest arrives too.

Rules of the session: branch chore/imp-intake-second-harvests. No project or person name in
branch names, commit messages or LEARNINGS. Small commits, one per logical change. Memory
updated. /fw:checkpoint at the end. No push, merge or tag: prepare blocks 0, 1 and 2 for me.
No multi-agent workflow without asking me. The method's files changed only with the file
tools. Measurements in throwaway folders OUTSIDE every repo. The framework read only by tag,
from the bare clone, with -C "${FW:?}". Artifacts in English.

0. Opening. The first checkpoint records the previous session's merge (20a5287..cca84f2,
IMP-142…169 integrated) and the outcome of the CI on main, read with gh.

A. The first derived project's second harvest (the attached block, IMP-051…056 in the
project). The project's IMP-050 is excluded: it is IMP-169 already. More evidence for the
entry that is IMP-055 in the project: at the upgrade's gate too the delegated reviewer had
written a file outside the repository (in a temporary folder) and removed it at once,
declaring it in its report — two cases in two consecutive gates. The entry on the guard's false
positive with "git diff > file" is to be compared with IMP-140 (the parser's backlog) and with
B2 below.

B. Field report: a greenfield graft of v4.1.0 (tag object 8b81665…, commit 18c04a1…) on a
static site with no services; macOS, gitleaks 8.30.1, git 2.54.0. The graft's security review
closed with no CRITICAL, HIGH or MEDIUM. Origin for each entry: "a derived project — greenfield
graft of v4.1.0 on a static site with no services". No name, URL or path of the project.
Reproduce every point at the v4.1.0 tag BEFORE recording it, and write the measurement in the
entry.
B1 [LOW, security] The pre-commit scripts/hooks-install.sh generates does not pass
--ignore-gitleaks-allow to gitleaks, so a line with the inline comment gitleaks:allow is left
out of the scan. The limit is not declared in SETUP §3. Measure the RED in a throwaway repo:
the generated hook, a fake token plus gitleaks:allow, the commit passes. Verify that the flag
exists for the subcommand the hook uses (protect --staged) and for SETUP §3's one-off scan
(detect --no-git), in the minimum supported gitleaks version. Do not fix.
B2 [a false positive of the guard, failing on the safe side] scripts/agent-git-guard.mjs
refuses `git diff > "$SP/…"`: it seems to treat the redirection's target as an argument of git
diff. Reproduce it and link it to IMP-140 and to the first derived project's entry. Do not fix.
B3 [SETUP, the copy's source] Step 1 reads the tag from "the framework's clone". In the
project, during the copy, another session switched branch in the framework's working clone:
the read was by tag, so no harm, but it is fragile. The project proposes a temporary clone of
the tag alone (git clone --branch vX.Y.Z --depth 1 <remote> "$(mktemp -d)/…"), for upgrades
and harvests too. Compare it with the bare clone SETUP's Precondition already recommends, and
with the theme of the clone's provenance. Measure whether a --depth 1 clone by tag still allows
`git tag -v` on the signed tag.
B4 [SETUP, a session started before .claude/ exists] The report says the guard and the hooks
stay inactive until the restart. Claude Code's documentation (settings, "When edits take
effect") says instead: "Claude Code also loads a settings file you create mid-session if its
folder existed when the session started. For the project's .claude/ folder, it loads the file
even when you create the folder in the same session." MEASURE what is really active after step
1, without restarting: the guard's PreToolUse hook, SessionStart (it will not run again),
.claude/rules/fw-core.md. Then word the entry on the measurement. The project's proposal: SETUP
says to restart from the root (claude --continue) before step 2 and to check the banner.
B5 [the SECURITY.md scaffold] The scaffold mixes the framework repo's policy (e.g. "For this
repo (the framework): use GitHub's private reporting") with the template for the projects:
filling only the slots, framework lines stay in the project. Proposal: a scaffold for the
project only, separate from the framework's policy.
B6 [/fw:new-component and agnosticism] new-component.md assumes services (containers,
migrations, health checks) and does not fit a static site. If you confirm it, it is a defect of
AGNOSTICISM in a METHOD file: flag it as such. Proposal: "n/a" items allowed and declared, or a
guide for projects with no services.
B7 [INFO] commitlint is pinned at 21.2.3 and 21.2.4 exists. The transitive dependencies are
not pinned (declared already). Check the current version on the registry and record only an
evidence for the next upgrade.
B8 [INFO] On GitHub Free a private repo cannot protect main (the API answers 403 and asks for
Pro). Verify that docs/03 says it findably for whoever chooses trunk-based with a private repo.
If it is not findable, it is a factual Level 1 correction, to be declared.

C. Security items from the article "Claude Code's Don't Ask Again file" (a news site, November
2026). A fact confirmed by Claude Code's documentation: "Yes, and don't ask again" saves an
allow rule in .claude/settings.local.json, and at the first write Claude Code adds the file to
the GLOBAL git excludes, not to the project's .gitignore. By the article, if the rule is the
exact command, a password written in the command lands in the file in plaintext. Scanners miss
many of them (a password after PGPASSWORD=, sshpass -p, mysql -p). Verified in the framework:
settings.local.json never tracked, present in .gitignore (line 28), gitleaks on the history 0
results. Proposals, to record:
C1 The CI scans the whole history with gitleaks at every run. Today the CI installs it only for
the hooks' tests, and the pre-commit scans only the stage.
C2 A gitleaks rule of the framework for credentials passed in a command (an inline variable, a
-p option, user:password@ in a URL), worded generically. Link it to B1.
C3 docs/04, Permission configuration: never "Yes, and don't ask again" for a command that
holds a credential; rules are written by hand after reading them. Recall that IMP-153 shows
that a pattern on a check-only option can run code too.
C4 /fw:security-review also reads the local and the user settings, looking for secrets and
over-wide rules (extends IMP-166).
C5 The upgrade's check verifies that the derived project's .gitignore holds
settings.local.json.

D. Deduplication and preliminary verdict. Every item of A, B and C compared with the whole of
LEARNINGS (1–169) and with this session's new entries: new / duplicate of IMP-xxx / extends
IMP-xxx. For each, a PRELIMINARY verdict, marked as a proposal: confirm / discard (with why) /
candidate for the corrective release. Group the items that touch the same file or theme (guard,
gitleaks, SETUP, scaffold). Agnosticism: in the diff and the commit messages no name, URL, path
or secret of a project. Run gitleaks on the diff.

E. At the end report to me: the deduplication table for the first derived project (A); the
table for the static-site project (B), with the preliminary verdict; the C items with their id;
the measurements taken, with their RED or GREEN outcome; the state of LEARNINGS; the
integration blocks."

The article's URL is left out of this note on purpose: it names no project, but this
repository cites no external news source in its records, and the claim it makes is checked
against Claude Code's own documentation instead (*C*, below).

## Plan (one commit per task)
- [ ] 1. This note — the user's brief and this plan — commit: —
- [ ] 2. The opening: the previous merge reconciled and `main`'s CI read with `gh` — commit: —
- [ ] 3. The measurements at v4.1.0, in throwaway folders outside every repository: B1 to B8 and C's facts, each RED or GREEN — commit: —
- [ ] 4. The gitleaks group: B1, C1 and C2 — commit: —
- [ ] 5. The guard group: B2, its link to IMP-140 and IMP-156 — commit: —
- [ ] 6. The SETUP group: B3 and B4 — commit: —
- [ ] 7. The scaffolds group: B5 and B6 — commit: —
- [ ] 8. The informational items: B7's evidence, B8's finding — commit: —
- [ ] 9. The permission-settings group: C3, C4 and C5 — commit: —
- [ ] 10. Section A: the first derived project's second harvest — commit: —
- [ ] 11. The deduplication tables, the preliminary verdicts and the agnosticism check, gitleaks on the diff — commit: —
- [ ] 12. The checkpoint: the IMPs' state, the gate's line, the follow-up, `status: completed` — commit: the branch's tip

## The opening — the previous merge, and `main`'s CI
- **The merge, reconciled** (this repository's first checkpoint after a merge, `fw/checkpoint.md`
  step 3): `origin/main` and `main` at `cca84f2`, the `--no-ff` merge of
  `chore/memory-main-ci-and-imp-intake` — `20a5287..cca84f2`, its ten `[task N/10]` and
  `[task N/9]` commits —, which brought IMP-142 to IMP-169 into the backlog, as proposed;
  [[2026-11-07-main-ci-and-imp-intake]] holds them. The branch was deleted by block 2's atomic
  push (`git branch -a` lists no remote branch but `main`).
- **`main`'s CI, read with `gh`, read-only**: run 42511514580, the push of `main` at `cca84f2`
  (2026-11-08 18:44 UTC), `completed/success`, its three jobs green — ubuntu-24.04, macos-26,
  windows-2025. `main` is green again.
- **The re-run the last note waited for never ran**: `gh run view 39250087583 --json attempt`
  reads `"attempt":1`, conclusion `failure`, last updated 2026-10-19 12:28 UTC, and the API
  has no attempt 2 (404). The last note's follow-up — "the re-run, launched by the user" — is
  closed by this datum, not by a re-run: what brought `main` back is the next push's run, on a
  tree whose shipped files are v4.1.0's (`git diff --stat v4.1.0 main` over `scripts/`, the
  docs, the commands, the rules, `settings.json`, `SETUP.md`, `SECURITY.md` and `.github/` is
  empty), whose Windows job ran the same self-test green. The diagnosis's class — a
  non-deterministic test — stands, and the fix stays the first item of the next corrective
  release (the user's decision of 2026-11-08).

[[LEARNINGS]] · [[2026-11-07-main-ci-and-imp-intake]]
