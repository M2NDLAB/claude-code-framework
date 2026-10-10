---
description: Generates the "READY FOR INTEGRATION" blocks — paste-ready commands, merge + tag + checks then the push, without running them
---
At the end of a deliverable, prepare the READY FOR INTEGRATION blocks for: $ARGUMENTS
(if empty: for the current branch).

Claude Code **does not push and does not merge** — that is a human action (see
@.claude/docs/04-git-workflow.md). Here it COLLECTS the state with read-only commands
and PRODUCES two blocks of exact commands, ready to paste. Run ONLY the read commands of
steps 1-2, the CHANGELOG update of step 3 (local commit) and the read-only computations
of step 4; everything else must be PRINTED, not executed.

## 1. Collect the state (read-only)
- Current branch (feature): `git branch --show-current`.
- Integration branch `<integration>` and stable branch `<stable>`: they are the ROLES
  of docs/04 (example defaults `develop`/`main`; actual names
  [TO BE DEFINED AT SETUP]). Replace the placeholders with the project's real names.
- Branch commits not yet in the integration branch: `git log --oneline origin/<integration>..HEAD`
  (fallback without a remote: `<integration>..HEAD`).
- Current version and distance: `git describe --tags --long` (if no tags exist,
  start from `v0.0.0`).
- Guard on the BASE: `git describe --tags` also accepts lightweight tags and
  non-SemVer names (typical of a history inherited from a graft onto an existing
  repo). If the base tag is not in the `vX.Y.Z` format, STOP and flag it: the
  versioning base must be decided with the user (typical candidate: the highest
  SemVer tag, `git tag --list 'v*' --sort=-v:refname | head -1`).

## 2. Compute the bump and the next version
Apply the *Versioning* rules of docs/04 to the branch's set of commits:
- the bump is the HIGHEST among those of the commits: `feat`→MINOR, `fix`→PATCH,
  breaking (`type!`/`BREAKING CHANGE:`)→MAJOR;
- if there are only `refactor`/`perf`/`test`/`docs`/`build`/`ci`/`chore` or
  memory/doc-only commits → **no tag** (it is internal work, not a release: state it
  explicitly above the blocks and omit the tag commands) — EXCEPT in a project whose
  documentation is the product (docs/04, *Versioning*, "When the documentation IS the
  product"): there a change to the files it ships is a release, at least a PATCH,
  whatever the commit types, and only a change confined to its own memory or to files
  it does not ship is no tag;
- respect the regime: **pre-1.0** (`0.y.z`) tags on the integration branch
  (`<integration>`); **post-1.0** the feature→`<integration>` merge is NOT tagged — the
  tag comes at the `<integration>`→`<stable>` release (see the note at the bottom).
  Compute the next version from step 1's `git describe`.

## 3. Update the CHANGELOG (if the project keeps one)

If a `CHANGELOG.md` exists at the root (Keep a Changelog format):
- bump = "no tag" → do NOT touch it (internal work is not a release);
- otherwise: move the content of `## [Unreleased]` under a new entry
  `## [X.Y.Z] — YYYY-MM-DD` (version computed at step 2, today's date),
  integrating it with what emerges from the branch commits, and COMMIT on the feature
  branch BEFORE printing the blocks: this way the changelog goes into the merge.

## 4. Print the READY FOR INTEGRATION blocks — two, never one
Two copyable code blocks, with the placeholders replaced by the real computed values,
and between them ONE line of plain text. Do NOT run them. They are two because a pause
written as a comment inside a copyable block is not a pause: pasted whole, the push runs
before anyone has read the checks. Block 1 touches only LOCAL history and ends with the
checks; block 2 publishes (docs/04, "Execution boundary and blocks for the user").

How the blocks are written, because they are pasted whole:
- **No comment lines inside them.** In zsh with its default options a `#` at the prompt
  is a command, not a comment (`command not found: #`), and inside a chain it breaks the
  chain. Every explanation goes in the text around the blocks.
- **The constructive lines are ONE chain** (each line ends with `&&`, which continues the
  command in bash and zsh): after a failure — a rebase conflict, a refused checkout or
  merge, a tag that already exists — nothing else runs, and no tag lands on the wrong
  commit.
- **Every check prints a fixed line when it passes** (`tag on <integration>: OK`,
  `count: OK (<N>)`, `signature: OK`), whatever language git or gpg answer in; the
  user looks for those lines, not for a reading of the output.

First compute, read-only:
- `N` = `git rev-list --count origin/<integration>..<feature>` + 1 (fallback without a
  remote: `<integration>..<feature>`): the branch's commits plus the merge commit — what
  `origin/<integration>..<integration>` holds after the merge;
- the tag is free: `git rev-parse -q --verify refs/tags/v<X.Y.Z>` prints nothing. If it
  prints a sha, the version is taken: if it is this deliverable's own tag, left by an
  earlier paste of block 1 (it points at the `--no-ff` merge of `<feature>` on
  `<integration>`), print only block 1's checks and block 2; otherwise STOP and report
  it;
- SIGNED = `git config --type=bool --get tag.gpgSign` prints `true` (the repository's
  config or the global one). Then `git tag -a` signs the tag by itself, and block 1
  verifies it. Otherwise leave out the signature line: signing stays optional, and a
  project that does not sign sees no check.

Block 1 — local only: the rebase, the merge (`--no-ff`, with a valid conventional type,
never `merge:`), the annotated tag with the computed bump (its `-m` short and pure ASCII),
then the checks — the tag on the integration tip, the signature (ONLY if SIGNED), the
commits about to become public, their count:
```
git checkout <feature> &&
git fetch origin &&
git rebase origin/<integration> &&
git checkout <integration> &&
git merge --ff-only origin/<integration> &&
git merge --no-ff <feature> -m "<type>(<scope>): merge <feature> into <integration>" &&
git tag -a v<X.Y.Z> -m "v<X.Y.Z> - <deliverable summary>" &&
echo "block 1: merged and tagged"
test "$(git rev-parse 'v<X.Y.Z>^{commit}')" = "$(git rev-parse <integration>)" && echo "tag on <integration>: OK"
git tag -v v<X.Y.Z> && echo "signature: OK"
git --no-pager log --oneline origin/<integration>..<integration>
test "$(git rev-list --count origin/<integration>..<integration>)" = <N> && echo "count: OK (<N>)"
```

Then the line, as plain text OUTSIDE any code block, with the real values:

> Copy block 2 only if block 1 printed `block 1: merged and tagged`, `tag on <integration>:
> OK`, `count: OK (<N>)` and `signature: OK` (the last only if SIGNED). If any is
> missing, do not publish: repair what failed, then run `/integrate` again — it
> recomputes the blocks.

Block 2 — publication, YOU run it: the branch and the tag in ONE atomic push — the remote
takes both or neither, so a tag never goes public on a commit the remote branch lacks —
then, only after the push succeeded, the safe deletion (`-d`, never `-D`) of the merged
feature branch:
```
git push --atomic origin <integration> v<X.Y.Z> &&
git branch -d <feature>
```

With "no tag": block 1 without the `git tag -a` line, its marker `block 1: merged`, and
neither the tag nor the signature check; block 2 `git push origin <integration> &&
git branch -d <feature>`; the line names the marker and the count.

If (and ONLY if) the tag exists but `tag on <integration>: OK` did not appear — a tag
left by an earlier, failed paste — ALSO print this recovery block, SEPARATE from the ones
above (docs/04, "Execution boundary and blocks for the user"): never `tag -d` on a sound
tag.
```
git tag -d v<X.Y.Z>
```
Then repair what failed and run `/integrate` again. If `signature: OK` does not appear,
the tag is not published either: find out why first — an SSH signature, for one,
verifies only with `gpg.ssh.allowedSignersFile` configured.

## 5. Final verification (print it as a checklist)
- the merge commit header is within the commit-linter limit: **100 characters**
  (conventional default, not overridden in `commitlint.config.cjs`);
- the merge commit type is a valid type (`feat`/`fix`/...), NEVER `merge:`;
- the tag version is consistent with the computed bump and with `git describe`, and
  the tag is free;
- the git arguments use **normal spaces** and ASCII hyphens: no non-breaking/unicode
  spaces nor "long" dashes copied from an editor — a `--no-ff` with a wrong character
  fails obscurely;
- no comment line inside the blocks; block 1's constructive lines form one `&&` chain
  ending with its marker;
- block 1 is local only and ends with the checks: the tag on the integration tip, the
  signature only when SIGNED, the log of `origin/<integration>..<integration>` (what
  becomes public) and its count against `N`, each printing its fixed line;
- block 2 holds only the atomic push and the branch deletion, and the line before it,
  outside the blocks, names every line block 1 must have printed;
- every destructive command (e.g. `tag -d`) is in a SEPARATE block with its
  condition, never inline (docs/04, "Execution boundary and blocks for the user").

## Release variant (1.0.0 and post-1.0)
For the `<integration>`→`<stable>` promotion the two blocks are the same, on the stable
branch: block 1 checks out `<stable>`, fetches, merges `--ff-only origin/<stable>` and
then `--no-ff <integration>`, and tags (`v1.0.0` or the MAJOR/MINOR/PATCH bump) on
`<stable>` — see *Versioning* in docs/04; its checks look at `<stable>`, with `N` =
`git rev-list --count origin/<stable>..<integration>` + 1. Block 2 is
`git push --atomic origin <stable> v<X.Y.Z>` alone: the integration branch is never
deleted.

Do NOT run push/merge/tag: the blocks are for the user. Once integration has happened,
the user can run `/checkpoint` to reconcile `STATE.md` and the active branches.
