---
date: 2026-11-08
task: two field reports and a set of security items recorded, each reproduced at v4.1.0 first, deduplicated against the whole backlog, with a PRELIMINARY verdict — nothing applied, the triage waits for the next derived project's harvest
branch: chore/imp-intake-second-harvests
status: completed
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
- [x] 1. This note — the user's brief and this plan — commit: 82bcdbd
- [x] 2. The opening: the previous merge reconciled and `main`'s CI read with `gh` — commit: 5b3abe0
- [x] 3. The measurements at v4.1.0, in throwaway folders outside every repository: B1 to B8 and C's facts, each RED or GREEN — commit: d338345
- [x] 4. The gitleaks group: B1, C1 and C2 — commit: 82ef937
- [x] 5. The guard group: B2, its link to IMP-140 and IMP-156 — commit: c59d312
- [x] 6. The SETUP group: B3 and B4 — commit: 665d08b
- [x] 7. The scaffolds group: B5 and B6 — commit: 5051946
- [x] 8. The informational items: B7's evidence, B8's finding — commit: aaeda64
- [x] 9. The permission-settings group: C3, C4 and C5 — commit: 2e92c90
- [x] 10. Section A: the first derived project's second harvest — what the brief itself holds recorded here, the block asked for (it was not in the message) — commit: 41399d9
- [x] 11. The deduplication tables, the preliminary verdicts and the agnosticism check, gitleaks on the diff — commit: fb5c9d7
- [x] 12. The checkpoint: the IMPs' state, the gate's line, the follow-up, `status: completed` — commit: the branch's tip, this note's last commit

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

## The measurements at v4.1.0
Every one in a throwaway directory of this session's scratch space, outside every repository;
the framework read only by tag from the bare clone (`git -C "${FW:?}"`), v4.1.0 extracted with
`git archive v4.1.0 | tar -x` — tag object `8b81665`, commit `18c04a1`, the brief's —, its
signature good (`git tag -v`, exit 0). macOS, git 2.54.0, gitleaks 8.30.1, Node 26.12.1,
Claude Code 2.1.319. `main`'s shipped files are v4.1.0's (*The opening*), so each result holds
on `main` too. RED means the report's defect reproduced; GREEN, the claim or the fix's premise
holds.

- **B1 — RED.** A new repository, v4.1.0's `scripts/` and `commitlint.config.cjs`, `bash
  scripts/hooks-install.sh` (three hooks written). A random token of GitHub's PAT form
  (`ghp_` and 36 characters, generated, never a real one) staged on its own line: the
  pre-commit refused it (`github-pat`, "leaks found: 1"). The same token on a line ending `#
  gitleaks:allow`, staged with the first: the scan reported only the first file. That line
  alone: the commit passed, exit 0, the token in `HEAD`. The flag: `gitleaks protect --staged
  --redact -v --ignore-gitleaks-allow` on that staged line, "leaks found: 1"; `gitleaks detect
  --no-git --source <dir> --redact` on the file, "no leaks found", and with the flag "leaks
  found: 1". In gitleaks' source (`cmd/root.go`, read with `gh api` at each tag) the flag is
  a persistent flag of the root command — so every subcommand's, `protect` and `detect`
  included — at v8.18.2, the declared security minimum, and at v8.30.1; absent at v8.0.0,
  below the minimum. v4.1.0 names `gitleaks:allow` nowhere — `SETUP.md` §3's *What the
  pre-commit's scan reads* and its history scan, `docs/03`, `SECURITY.md` —, and the hook's
  scan apart (`detect --no-git`, the files git shows as binary) does not pass the flag either.
- **B2 — RED.** v4.1.0's guard, fed the hook's input by hand, the main session's (no
  `agent_id`) and an agent's: `git diff > "$SP/x.diff"` refused in every session, as an
  implicit `--no-index` with "an operand the guard cannot place"; `git diff > /tmp/x.diff`
  refused, the operand "outside"; `git diff --stat > "$SP/x.diff"` refused. They pass: `git
  diff >"$SP/x.diff"` (no space), `git diff > x.diff` (a target inside the work tree), `git
  diff HEAD > "$SP/x.diff"` and `git diff HEAD~1 HEAD > …` (more or fewer than two words), `git
  diff | cat > …`. The cause, read in `scripts/agent-git-guard.mjs`: redirections are dropped
  only before the command's name (its line 350, the `REDIRECTION` pattern, a bare `>` taking
  the next word); after git's words a bare `>` and its target stay two words, which
  `implicitNoIndexReason` counts as `git diff <path> <path>`. It fails on the safe side: no
  form measured lets through what it should refuse.
- **B3 — GREEN for the graft, RED for an upgrade.** `git clone --branch v4.1.0 --depth 1` from
  the remote: 912 KB, shallow, one tag, `HEAD` at `18c04a1`; `git tag -v v4.1.0` exit 0, gpg's
  good signature. A second tag fetched the same way (`git fetch --depth 1 origin tag v4.0.0`):
  `git diff --stat v4.0.0 v4.1.0` works, both signatures verify, but `git merge-base v4.0.0
  v4.1.0` exits 1 — and `tools/upgrade-check.sh preflight`'s first check is `merge-base
  --is-ancestor vX vY`, a FAIL there (read at its source, not run), and its list of the
  releases between them (`tag --merged --no-merged`) has no history to read. A full bare clone:
  2.5 MB, `git tag -v` exit 0. `SETUP.md` asks for no signature check anywhere (`git tag -v`
  and `verify-tag` appear in neither step 1 nor the Precondition); the bare clone is an option
  of the upgrade's Precondition only, step 1 saying "the framework's clone".
- **B4 — the report's claim RED in part.** Two `claude -p` sessions in a new repository with
  no `.claude/`, `--allowedTools Bash`, the workspace untrusted (Claude Code ignored the three
  `allow` entries for it, its own message). Session 1 ran step 1's copy, then probes: `git
  commit --allow-empty -n` was refused by the guard's PreToolUse hook ("BLOCKED in every
  session") and no commit was made (`git log`); `rm -rf zz` was denied by the `deny` rule and
  the directory stayed; `AGENT_GIT_BOUNDARY` read `1` — the settings file created mid-session
  was loaded, permissions, hooks and `env`, as the documentation says. The session reported no
  text of `.claude/rules/fw-core.md` in its context and no SessionStart banner — its own
  report, which is what can be had (the rule has no `paths:`, so it loads at launch only, by
  the memory documentation, "Rules without `paths` frontmatter are loaded at launch"). Session
  2, started after the copy: the same refusals, the core in its context (it quoted its fourth
  section's title), the banner received. A third session: the copy, then `claude -p --resume`
  of that same session — the core in its context and the banner received, from
  `SessionStart:resume`. Not measured: an interactive session, and `--continue` itself, which
  resumes the latest session where `--resume` names one.
- **B5 — RED.** v4.1.0's `SECURITY.md` with its three setup markers replaced by an answer: no
  marker left, and eight lines still speak of the framework — the *Two levels* note (lines
  3-6), "For this repo (the framework): use GitHub's private reporting" (10-12), "for the
  framework: best effort" (19), "For the framework: only the latest tagged version receives
  fixes" (23-24), and the title *Prevention already active in the framework* (26). A project
  that fills the slots ships a policy that sends its reporters to the framework's channel.
- **B6 — confirmed, with one correction.** `fw/new-component.md` is HYBRID at v4.1.0, not
  METHOD: the class table (`tools/upgrade-check.sh`, `classes`) and `SETUP.md`'s *The mental
  model* list it among the commands customised at setup, and `SETUP.md` step 2 asks the project
  to fill it. Its conditional items fit any project — a migration "if the component persists
  data", a health check "if it is a service", API docs "if it exposes an API", the startup
  system "if applicable" —; four are unconditional and assume a running service:
  per-environment configuration, a production artefact whose example is a container, structured
  logging with a correlation id, and an integration smoke test that "starts the WHOLE component
  wired to the real dependencies" (`docs/02`'s DoD point 3 asks it only "for a component with
  real dependencies").
- **B7 — evidence.** The npm registry, read on 2026-11-08: `@commitlint/cli` and
  `@commitlint/config-conventional` latest 21.2.4, published 2026-10-18 — a day before v4.1.0's
  tag —, 21.2.3 on 2026-09-19; 21.2.4's `engines` still `node >=22.12.0`; its release notes:
  two fixes (config arrays replaced by seed arrays in `load`; `jsonc` to v3), one performance
  change, docs and tests. v4.1.0 pins 21.2.3 in one place, `COMMITLINT=` in
  `scripts/check-prerequisites.sh`.
- **B8 — not findable where the brief looks; no false statement.** `docs/03` says nothing of a
  forge's branch protection; `docs/04`'s trunk-based lines say nothing of it either. The one
  line is `SETUP.md`'s *Hardening*: "On GitHub, rulesets are free on public repositories only;
  GitLab and Bitbucket have protected branches" — true as far as it goes, silent on GitHub's
  classic branch protection, and read by whoever reads *Hardening*, not by whoever chooses the
  branching model. GitHub's pages, read through a fetch agent, settle no plan question: the
  rulesets page names GitHub Team and Enterprise, the protected-branches page names plans only
  for one feature. The 403 asking for Pro is the project's measurement, not repeated here.
- **C's facts.** `.gitignore` line 28 is `.claude/settings.local.json`, at v4.1.0 and on
  `main`; the file never tracked (`git ls-files`, `git log --all` on it: nothing); `gitleaks
  detect --log-opts=--all` over this repository's history: "no leaks found". The CI
  (`.github/workflows/test.yml`) installs gitleaks for the hooks' tests and runs no history
  scan. gitleaks 8.30.1's default rules over a `settings.local.json`-shaped file holding one
  random password in six command forms: one found (`generic-api-key`, the `PGPASSWORD=` line);
  missed — `sshpass -p`, `mysql -p<password>`, a password in a URL's userinfo for `curl` and for
  `git clone`, `export DB_PASSWORD=`. `tools/upgrade-check.sh` reads `settings.local.json` only
  to class it LOCAL; nothing checks that `.gitignore` holds it. Claude Code's documentation,
  read on 2026-11-08 (*settings*, *Keep personal settings out of a repository*): "When Claude
  asks permission to run a Bash command and you choose "Yes, and don't ask again", Claude Code
  saves that permission approval here as an `allow` rule"; "The first time Claude Code writes
  the file in a git repository that doesn't already ignore it, it adds
  `**/.claude/settings.local.json` to your global git excludes file". The *permissions* page
  says "The permission dialog writes the space-separated form when you select "Yes, and don't
  ask again" for a command prefix", and its example offers `npm test *`; no sentence says the
  rule saved is ever the exact command. The article's claim — a password in an exact-command
  rule, in plaintext — is not measured here: it needs the interactive prompt.

## Section A — the first derived project's second harvest
The brief announces "the attached block", the project's entries 051 to 056; the message held
none. Nothing of it is recorded from elsewhere — as at the last session, when the same happened
(*Problems*, below) —, and the block is asked of the user. What the brief itself says is
kept here, for the recording to come:
- **Count once**: the project's entry 050 is excluded — it is IMP-169 already, which says its
  second harvest's copy is evidence there, never a new entry. Its pair (the entry, its date)
  is checked against [[2026-11-07-main-ci-and-imp-intake]], which lists 033 to 050, once the
  block gives the dates.
- **The user's evidence for the project's entry 055**: at the upgrade's gate too a delegated
  reviewer wrote a file outside the repository — in a temporary folder — and removed it at once,
  declaring it in its report: two cases in two consecutive gates. Which entry of this backlog it
  extends is read once the entry's text comes; candidates by theme — IMP-055 (applied: delegated
  agents isolated, a snapshot before and after, which sees only the repository), IMP-138 (the
  reviewers' fixtures prepared before the launch), IMP-060.
- **Its entry on `git diff > file`**: by the user's reading kin of IMP-140; measured this
  session as the static-site project's B2, now IMP-173 — the harvest's entry likely a repeat of
  it, evidence there, once read.

## Deduplication and preliminary verdicts
Every item read against the whole backlog — the 168 entries at `main`'s `cca84f2`, IMP-001 to
IMP-169 — and against this session's own. Each verdict is a PROPOSAL for the triage, which
waits for the next derived project's harvest (the user's word); "candidate" means candidate
for the next corrective release, whose list is the user's ([[2026-10-19-4.1.0-record]], *The
next corrective release*).

**Section A — the first derived project's second harvest** (the block not received):

| Harvest (the project's entry) | Here | Kind | Preliminary verdict |
| --- | --- | --- | --- |
| 050 — sensitive components by code path | IMP-169 | duplicate: excluded by the user, its copy evidence there | — |
| 051 to 056 | — | not read: the block was not in the message | — |
| 055 — the user's added evidence (a reviewer's write outside the repository, at two consecutive gates) | kept in *Section A*, above | to be read with its entry | — |
| the entry on `git diff > file` | likely IMP-173 | to be read with its entry | — |

**Section B — the static-site project** (origin on every entry: "a derived project — greenfield
graft of v4.1.0 on a static site with no services"):

| Report item | Measured | Here | Kind | Preliminary verdict |
| --- | --- | --- | --- | --- |
| B1 — `gitleaks:allow` honoured | RED | IMP-170 | new; kin IMP-095, IMP-077, IMP-089 | confirm — candidate, with IMP-095's group (one change of the generated pre-commit) |
| B2 — the guard on `git diff > file` | RED | IMP-173 | extends IMP-140; kin IMP-156 | confirm — candidate, with IMP-140 and IMP-156 (one change of the guard) |
| B3 — the copy's source | GREEN for a graft, RED for an upgrade | IMP-174 | new, narrowed; kin IMP-107, IMP-050 (1-2), IMP-156, IMP-066 | confirm narrowed — candidate (`SETUP.md`); the signature check the triage's |
| B4 — a session that creates `.claude/` | the report's claim RED for the guard; the core and the banner missing, GREEN | IMP-175 | new; kin IMP-104, IMP-124, IMP-149 | confirm — candidate (`SETUP.md`) |
| B5 — the `SECURITY.md` scaffold | RED | IMP-176 | new; kin IMP-022, IMP-049, IMP-086 | confirm — candidate |
| B6 — `/fw:new-component` | confirmed; HYBRID, not METHOD | IMP-177 | new — an agnosticism defect | confirm — not for the corrective release (a conflict in every customised copy, IMP-088) |
| B7 — commitlint 21.2.4 | evidence | IMP-076 (applied) | evidence on it, no entry | — the pin a release's decision |
| B8 — GitHub Free, a private repository | not findable where the model is chosen; nothing false | IMP-178 | extends IMP-086 | confirm — candidate (one doc line), or with IMP-086; Level 2, not Level 1 (*Problems*) |

**Section C — the security items**:

| Item | Here | Kind | Preliminary verdict |
| --- | --- | --- | --- |
| C1 — a history scan in the CI | IMP-171 | new; kin IMP-089, IMP-091, IMP-142 | confirm — this repository's CI, no tag, any deliverable |
| C2 — a rule for credentials in a command | IMP-172 | new; kin IMP-170 (B1), IMP-095 (2) | confirm the need — not corrective: a MINOR, its false positives measured first |
| C3 — no standing approval with a credential | IMP-179 | extends IMP-004 (applied); kin IMP-153, IMP-166 | confirm — candidate (one doc line), on the docs' wording |
| C4 — the review reads local and user settings | IMP-166 | extends IMP-166 (a line added there) | with IMP-166 at the triage |
| C5 — `.gitignore` keeps the local file out | IMP-180 | new; kin IMP-166, IMP-050 (3-4) | confirm — candidate, with the other `upgrade-check.sh` items |

**Groups, by file or theme**, for the triage:
- *gitleaks and the generated pre-commit*: IMP-170, IMP-095 (deferred, its trigger fired by
  IMP-170), IMP-077 (deferred), IMP-172; IMP-171 (the CI) beside them.
- *the guard*: IMP-173, IMP-140 (approved), IMP-156.
- *`SETUP.md`*: IMP-174, IMP-175, IMP-178 (or `docs/04`); with IMP-154, IMP-158, IMP-163,
  IMP-164, IMP-168 from the last harvest.
- *the scaffolds*: IMP-176 (`SECURITY.md`), IMP-177 (`fw/new-component.md`).
- *the permission settings*: IMP-179, IMP-166 (extended), IMP-180, IMP-153.
- *`tools/upgrade-check.sh`*: IMP-180, IMP-139 (approved), IMP-158, IMP-160.

**Agnosticism** (2026-11-08): the branch's diff and its commit messages searched for the
projects' names, this machine's paths, the user's identity, the article's site, the fake
secrets of the measurements and token prefixes — nothing; every "seco" match is "second".
`gitleaks git --log-opts=origin/main..HEAD`: "no leaks found". `git diff --no-renames
--name-only origin/main...HEAD`: `.claude/memory/LEARNINGS.md` and this note only.

## Problems encountered → cause → solution
- Section A's block was not in the message, the second session running — the last one's brief
  lacked its block and section too → a brief written ahead of the paste → nothing reconstructed
  from elsewhere; what the brief holds is kept in *Section A*, the block asked of the user.
- B8: the brief foresaw a Level 1 correction "if it is not findable" → Level 1 is for a doc in
  demonstrable disagreement with reality, and nothing written is false: the gap is a missing
  pointer, a change of content; and a fix in `docs/03` or `docs/04` changes a shipped file, a
  release, which this memory-only branch is not → recorded as IMP-178, Level 2, the call left
  to the user. No Level 1 correction was made this session.
- The first B4 run did not start: `timeout` is no macOS command ("command not found") → a GNU
  coreutils habit → run without it; nothing had run.
- A command of the C measurements carried a leftover `rm -f /dev/null`, refused by auto mode's
  classifier → a draft fragment not removed before the run — the same slip as the last
  session's leftover `sed -i` aimed at `/dev/null` → nothing ran; the command re-run without
  it. Two sessions in a row: a candidate for the next retro, not recorded as an IMP here.
- Task 11's first commit had a body line opening with `backlog:` → commitlint read it as the
  footer and warned ("footer must have leading blank line"), the trap `docs/04`'s *Commit
  format* names → the message rewritten by an amend of the local, unpushed commit (`fb5c9d7`);
  every body of the branch searched for the form afterwards — none.
- B4's measurements ran in `claude -p`, in an untrusted workspace: Claude Code ignored the
  three `allow` entries there, which no probe needed → recorded with the measurement.

## Proposals
All in [[LEARNINGS]], proposed, none decided; each carries a preliminary verdict marked as a
proposal (*Deduplication and preliminary verdicts*, above):
- the static-site project's report: IMP-170 (B1), IMP-173 (B2), IMP-174 (B3), IMP-175 (B4),
  IMP-176 (B5), IMP-177 (B6), IMP-178 (B8); B7 as evidence on IMP-076 (applied);
- the security items: IMP-171 (C1), IMP-172 (C2), IMP-179 (C3), IMP-180 (C5); C4 as an
  extension of IMP-166.

## The IMPs' state after this session
At `cca84f2`, 168 entries ([[2026-11-07-main-ci-and-imp-intake]]). This session adds 11 —
IMP-170 to IMP-180 —: 179 entries, counted by section on `LEARNINGS.md` after task 11:
- applied 113, rejected 11, deferred 12 — unchanged (IMP-076 gained an evidence line);
- open 43 — 5 approved and waiting (IMP-086 for its trigger; IMP-081, IMP-139, IMP-140 and
  IMP-141 for the next corrective release), 38 only proposed (IMP-142 to IMP-151, IMP-153 to
  IMP-180), none decided: the triage starts with the next derived project's harvest (the
  user's word).

## Security gate
- Not applicable: a memory-only change — this note and entries of `LEARNINGS.md` (`git diff
  --no-renames --name-only origin/main...HEAD` lists only `.claude/memory/` paths; the
  `LEARNINGS.md` diff touches no header, title or format comment) —; no sensitive component,
  no security property asserted by the product. The entries record security findings; none is
  applied here.

## Follow-up
- Section A's block — the first derived project's entries 051 to 056 —: ask the user at the
  next session's start; then record it against the whole backlog, IMP-173 and the user's
  evidence on its entry 055 included.
- B8, Level 1 or Level 2: the user's call (*Problems*); IMP-178 holds it until then.
- Not measured, for the triage: B4 in an interactive session and with `--continue`; the
  article's exact-command claim behind IMP-179, which needs the interactive prompt.
- The triage of the 38 entries only proposed, and the corrective release's list: when the next
  derived project's harvest comes (the user's word).
- Carried: the self-test fix, the first item of the next corrective release, on a `fix/`
  branch of its own, under the gate with one reviewer (the user's decision, 2026-11-08); the
  re-run it waited for never ran (*The opening*).

[[LEARNINGS]] · [[2026-11-07-main-ci-and-imp-intake]]
