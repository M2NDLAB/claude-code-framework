#!/usr/bin/env bash
# Self-test of scripts/hooks-install.sh. Five cases:
#   1. "dangling symlink + FORCE_OVERWRITE=1": a leftover link never aborts the install —
#      below; skipped, said aloud, where `ln -s` cannot make a dangling link (Git Bash);
#      the commit-msg hook it installs runs commitlint at the version
#      scripts/check-prerequisites.sh pins;
#   2. the generated pre-push is the push boundary (docs/04): a push launched with a Claude
#      Code session marker is REFUSED in every form, a push without markers (the human's
#      terminal) goes through — see "Case 2";
#   3. where the hooks land: the repository's common git directory, from a linked worktree
#      or from a subdirectory; outside any repository, or from a copy below the top level of
#      the repository it sits in, a refusal — see "Case 3";
#   4. the prerequisites: the install runs the prerequisite check first — a gitleaks that
#      does not start stops it before any hook is written; a make that does not start does
#      not, the hooks never run make — see "Case 4";
#   5. the git gitleaks reads through the generated pre-commit: the colour off and each
#      textconv driver turned into `cat`, after the caller's own environment configuration,
#      which stays; a GIT_CONFIG_COUNT that is not a number stops the hook before gitleaks —
#      see "Case 5" at the end.
#
# Case 1.
# Defect (RED, before the fix): in the FORCE_OVERWRITE=1 branch, a pre-existing hook that is a
# DANGLING symlink (non-existent target) makes `cp -L "${target}" "${target}.bak"` fail
# (cp dereferences the link → target absent → error); under `set -euo pipefail` the script
# ABORTS with exit!=0 BEFORE the backup and the `rm`, diverging from the header comment that
# promises "we proceed: backup then removal". No data loss (a dangling link has no
# content), but the declared contract is violated and the error is cryptic.
#
# Expected (GREEN, after the fix): the script skips the vacuous backup with a dedicated warning,
# removes the link anyway and installs the generated hook, exiting 0.
#
# The test is HERMETIC: stubs for gitleaks/npx (the prerequisites are unrelated to the logic under
# test) and a throwaway git repo. It runs the REAL script end-to-end (smoke, not just the isolated unit).
set -euo pipefail

# Hermetic against the user's own git configuration: a global tag.gpgSign or
# commit.gpgSign, for one, would make the throwaway repository's tags and commits ask for
# a signature (git 2.32+ reads GIT_CONFIG_GLOBAL; older ones ignore it). And against the
# caller's git environment: run from a git hook, GIT_DIR or GIT_INDEX_FILE would point the
# throwaway commands at the REAL repository.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_INSTALL="${SCRIPT_DIR}/hooks-install.sh"
# hooks-install.sh reads commitlint's pin from the prerequisite check, next to it in every
# copy of the framework's scripts/.
CHECK_PREREQ="${SCRIPT_DIR}/check-prerequisites.sh"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

# --- Prerequisite stubs: they isolate the FORCE logic from the gitleaks/npx checks ----------
# Each answers its version command as the prerequisite check asks it, and does nothing else.
stub_bin="${workdir}/bin"
mkdir -p "${stub_bin}"
printf '#!/usr/bin/env bash\n[[ "${1:-}" == version ]] && echo 8.30.1\nexit 0\n' > "${stub_bin}/gitleaks"
printf '#!/usr/bin/env bash\n[[ "${1:-}" == --version ]] && echo 10.9.2\nexit 0\n' > "${stub_bin}/npx"
chmod +x "${stub_bin}/gitleaks" "${stub_bin}/npx"
export PATH="${stub_bin}:${PATH}"

# --- Throwaway repo with a COPY of the script (REPO_ROOT derives from the script's location)
repo="${workdir}/repo"
mkdir -p "${repo}/scripts"
git init -q "${repo}"
cp "${HOOKS_INSTALL}" "${repo}/scripts/hooks-install.sh"
cp "${CHECK_PREREQ}" "${repo}/scripts/check-prerequisites.sh"

# --- Case 1 — a dangling symlink and FORCE_OVERWRITE=1 -------------------------------------
# Plant a DANGLING symlink as the pre-existing pre-commit hook. Git Bash cannot make one —
# `ln -s` to a missing target fails there (measured in the CI on Windows) —: the case is
# then SKIPPED, said aloud, and the install below still runs, for the cases after it.
dangling=yes
if ! ln -s "/path/that/does/not/exist/xyz" "${repo}/.git/hooks/pre-commit" 2>"${workdir}/ln.err"; then
  dangling=no
  echo "SKIP (dangling symlink): this platform cannot make a dangling symlink — $(head -n 1 "${workdir}/ln.err")"
elif [[ ! -L "${repo}/.git/hooks/pre-commit" || -e "${repo}/.git/hooks/pre-commit" ]]; then
  echo "SETUP FAILED: the dangling symlink was not created as expected" >&2
  exit 1
fi

# --- Run the script under test with FORCE_OVERWRITE=1 ---------------------------------------
set +e
FORCE_OVERWRITE=1 bash "${repo}/scripts/hooks-install.sh" >"${workdir}/out.log" 2>&1
rc=$?
set -e

fail() {
  echo "FAIL (dangling symlink): $1" >&2
  echo "--- script output (rc=${rc}) ---" >&2
  cat "${workdir}/out.log" >&2
  exit 1
}

# --- GREEN assertions -----------------------------------------------------------------------
target="${repo}/.git/hooks/pre-commit"
[[ ${rc} -eq 0 ]]      || fail "expected exit code 0, got ${rc} (did cp -L on the dangling link abort the script?)"
[[ ! -L "${target}" ]] || fail "the dangling symlink was not removed"
[[ -f "${target}" ]]   || fail "the generated hook was not installed in place of the link"
grep -q "Hook generated by scripts/hooks-install.sh" "${target}" \
                       || fail "the installed pre-commit is not the one generated by the framework"
[[ ! -e "${target}.bak" ]] \
                       || fail "a dangling link has no content: it must not create a vacuous .bak"
# The commit-msg hook runs commitlint's two packages at the pinned version, never npx's latest.
pin="$(bash "${CHECK_PREREQ}" --commitlint-version)"
grep -qF -- "--package @commitlint/cli@${pin} --package @commitlint/config-conventional@${pin}" \
  "${repo}/.git/hooks/commit-msg" || fail "the commit-msg hook does not run commitlint at the pin, ${pin}"

[[ ${dangling} == no ]] \
  || echo "PASS (dangling symlink): dangling + FORCE_OVERWRITE=1 → no abort, link removed, hook installed, no vacuous .bak."

# --- Case 2 — the pre-push push boundary --------------------------------------------------
# The pre-push installed above must refuse every push that carries a session marker
# (AGENT_GIT_BOUNDARY, or the CLAUDECODE fallback), whatever form launched it, and let a
# push without markers through. The remote is a LOCAL bare repo reached via file:// only
# (every other transport disabled): nothing ever leaves the machine. The test controls the
# markers explicitly, so it gives the same answer inside or outside a Claude Code session.
fail2() {
  echo "FAIL (push boundary): $1" >&2
  [[ -f "${workdir}/push.log" ]] && { echo "--- last push output ---" >&2; cat "${workdir}/push.log" >&2; }
  exit 1
}
pre_push="${repo}/.git/hooks/pre-push"
[[ -x "${pre_push}" ]] || fail2 "the pre-push hook was not installed (or is not executable)"
grep -q "Hook generated by scripts/hooks-install.sh" "${pre_push}" || fail2 "the installed pre-push is not the generated one"

remote="${workdir}/remote.git"
git init -q --bare "${remote}"
git -C "${repo}" config user.name self-test
git -C "${repo}" config user.email self-test@example.invalid
git -C "${repo}" config protocol.allow never
git -C "${repo}" config protocol.file.allow always
git -C "${repo}" remote add origin "file://${remote}"
git -C "${repo}" commit -q --allow-empty -m "chore: self-test commit"

landed() { git -C "${remote}" rev-parse -q --verify "refs/heads/$1" >/dev/null; }

# try_push <branch> <marker assignment, or ""> <form>: one push of a fresh branch, from a
# clean environment plus the marker under test.
try_push() {
  local branch="$1" marker="$2" form="$3"
  local -a cmd
  git -C "${repo}" branch "${branch}"
  case "${form}" in
    direct) cmd=(git push -q origin "${branch}") ;;
    dash-C) cmd=(git -C "${repo}" push -q origin "${branch}") ;;
    sh-c)   cmd=(sh -c "git push -q origin ${branch}") ;;
    script) printf 'git push -q origin %s\n' "${branch}" > "${workdir}/push.sh"; cmd=(sh "${workdir}/push.sh") ;;
  esac
  ( cd "${repo}" && env -u AGENT_GIT_BOUNDARY -u CLAUDECODE ${marker:+"${marker}"} "${cmd[@]}" ) \
    >"${workdir}/push.log" 2>&1 || true
}

for form in direct dash-C sh-c script; do
  try_push "agent-${form}" AGENT_GIT_BOUNDARY=1 "${form}"
  ! landed "agent-${form}" || fail2 "a push with AGENT_GIT_BOUNDARY=1 (${form}) reached the remote"
  grep -q "pre-push: REFUSED" "${workdir}/push.log" || fail2 "the ${form} push was not refused BY THE pre-push hook"
done
try_push claudecode-direct CLAUDECODE=1 direct
! landed claudecode-direct || fail2 "a push with only CLAUDECODE=1 (the fallback marker) reached the remote"
grep -q "pre-push: REFUSED" "${workdir}/push.log" || fail2 "the CLAUDECODE push was not refused BY THE pre-push hook"
try_push human-direct "" direct
landed human-direct || fail2 "a push WITHOUT markers (the human's terminal) was refused: the boundary blocks the human too"

# A project's own pre-push (e.g. git-lfs's) lives in pre-push.local: it runs, with git's
# stdin, after the check — for the human's push only. It records what it received.
cat > "${repo}/.git/hooks/pre-push.local" <<HOOK
#!/usr/bin/env bash
cat > "${workdir}/local-hook.ran"
HOOK
chmod +x "${repo}/.git/hooks/pre-push.local"
try_push agent-with-local AGENT_GIT_BOUNDARY=1 direct
[[ ! -e "${workdir}/local-hook.ran" ]] || fail2 "pre-push.local ran for an agent-session push (it must come AFTER the refusal)"
try_push human-with-local "" direct
landed human-with-local || fail2 "the human's push did not land with a pre-push.local present"
grep -q "refs/heads/human-with-local" "${workdir}/local-hook.ran" 2>/dev/null \
  || fail2 "pre-push.local did not run, or did not receive git's ref list on stdin"

echo "PASS (push boundary): pre-push refuses agent-session pushes (direct, -C, sh -c, script; CLAUDECODE fallback), lets the human's push through, and chains pre-push.local after the check."

# --- Case 3 — where the hooks land: the repository's COMMON git directory ------------------
# In a linked worktree `.git` is a FILE, and the hooks of every worktree live in the main
# repository's `.git/hooks` (git's common directory). The script must install there when it
# runs from a linked worktree — an upgrade on its own worktree, for one; must not create a
# stray `.git/hooks` under a working directory other than the repository root; and must
# refuse to run outside a repository instead of creating a `.git` there.
fail3() {
  echo "FAIL (hooks directory): $1" >&2
  [[ -f "${workdir}/out3.log" ]] && { echo "--- script output ---" >&2; cat "${workdir}/out3.log" >&2; }
  exit 1
}
# Keeps git from discovering a repository ABOVE the throwaway ones (case 3c).
export GIT_CEILING_DIRECTORIES="${workdir}"
wt_repo="${workdir}/wt-repo"
git init -q "${wt_repo}"
git -C "${wt_repo}" -c user.name=self-test -c user.email=self-test@example.invalid \
  commit -q --allow-empty -m "chore: self-test commit"
git -C "${wt_repo}" worktree add -q --detach "${workdir}/wt"
mkdir -p "${workdir}/wt/scripts" "${wt_repo}/scripts"
cp "${HOOKS_INSTALL}" "${workdir}/wt/scripts/hooks-install.sh"
cp "${HOOKS_INSTALL}" "${wt_repo}/scripts/hooks-install.sh"
cp "${CHECK_PREREQ}" "${workdir}/wt/scripts/check-prerequisites.sh"
cp "${CHECK_PREREQ}" "${wt_repo}/scripts/check-prerequisites.sh"

# 3a. From a linked worktree: every hook the generator lists lands in the main repository's
# .git/hooks — the list read from the generator's own loop, so a hook added there is checked.
set +e
bash "${workdir}/wt/scripts/hooks-install.sh" >"${workdir}/out3.log" 2>&1
rc=$?
set -e
[[ ${rc} -eq 0 ]] || fail3 "from a linked worktree: expected exit 0, got ${rc}"
hooks="$(sed -n 's/^for hook in \(.*\); do$/\1/p' "${HOOKS_INSTALL}")"
[[ -n "${hooks}" ]] || fail3 "no hook list found in scripts/hooks-install.sh"
for hook in ${hooks}; do
  grep -qF "Hook generated by scripts/hooks-install.sh" "${wt_repo}/.git/hooks/${hook}" 2>/dev/null \
    || fail3 "from a linked worktree: ${hook} is not installed in the common hooks directory"
done
[[ -f "${workdir}/wt/.git" ]] || fail3 "from a linked worktree: the worktree's .git file was replaced"

# 3b. From a subdirectory of the repository: nothing created under the working directory.
set +e
( cd "${wt_repo}/scripts" && bash ./hooks-install.sh ) >"${workdir}/out3.log" 2>&1
rc=$?
set -e
[[ ${rc} -eq 0 ]] || fail3 "from a subdirectory: expected exit 0, got ${rc}"
[[ ! -e "${wt_repo}/scripts/.git" ]] || fail3 "from a subdirectory: a stray .git was created under the working directory"

# 3c. Outside any repository: a refusal that says why, and no .git created.
norepo="${workdir}/norepo"
mkdir -p "${norepo}/scripts"
cp "${HOOKS_INSTALL}" "${norepo}/scripts/hooks-install.sh"
cp "${CHECK_PREREQ}" "${norepo}/scripts/check-prerequisites.sh"
set +e
bash "${norepo}/scripts/hooks-install.sh" >"${workdir}/out3.log" 2>&1
rc=$?
set -e
[[ ${rc} -ne 0 ]] || fail3 "outside a repository: expected a refusal, got exit 0"
[[ ! -e "${norepo}/.git" ]] || fail3 "outside a repository: a stray .git was created"
grep -q "not inside a git repository" "${workdir}/out3.log" || fail3 "outside a repository: the refusal does not say why"

# 3d. A copy that is not at the top level of the repository it sits in (inside someone
# else's working tree): a refusal, and no hook installed into that repository.
nested="${wt_repo}/vendor/framework"
mkdir -p "${nested}/scripts"
cp "${HOOKS_INSTALL}" "${nested}/scripts/hooks-install.sh"
cp "${CHECK_PREREQ}" "${nested}/scripts/check-prerequisites.sh"
rm -f "${wt_repo}/.git/hooks/pre-commit" "${wt_repo}/.git/hooks/commit-msg" "${wt_repo}/.git/hooks/pre-push"
set +e
bash "${nested}/scripts/hooks-install.sh" >"${workdir}/out3.log" 2>&1
rc=$?
set -e
[[ ${rc} -ne 0 ]] || fail3 "a copy below the top level: expected a refusal, got exit 0"
[[ ! -e "${wt_repo}/.git/hooks/pre-commit" ]] || fail3 "a copy below the top level: hooks were installed into the enclosing repository"
grep -q "not the top level of its git repository" "${workdir}/out3.log" || fail3 "a copy below the top level: the refusal does not say why"

echo "PASS (hooks directory): from a linked worktree the hooks land in the common .git/hooks; no stray .git from a subdirectory; outside a repository or below its top level, a refusal."

# --- Case 4 — the prerequisites: the install runs the prerequisite check first ---------------
# A gitleaks that is installed but does not start stops the install before any hook is
# written, the check's own line naming it; a make that does not start does not: the hooks
# never run make, and `bash scripts/hooks-install.sh` needs none.
fail4() {
  echo "FAIL (prerequisites): $1" >&2
  [[ -f "${workdir}/out4.log" ]] && { echo "--- script output ---" >&2; cat "${workdir}/out4.log" >&2; }
  exit 1
}
broken="${workdir}/broken-bin"
mkdir -p "${broken}"
printf '#!/usr/bin/env bash\necho "gitleaks: cannot execute binary file" >&2\nexit 126\n' > "${broken}/gitleaks"
chmod +x "${broken}/gitleaks"
pq_repo="${workdir}/pq-repo"
git init -q "${pq_repo}"
mkdir -p "${pq_repo}/scripts"
cp "${HOOKS_INSTALL}" "${pq_repo}/scripts/hooks-install.sh"
cp "${CHECK_PREREQ}" "${pq_repo}/scripts/check-prerequisites.sh"
set +e
PATH="${broken}:${PATH}" bash "${pq_repo}/scripts/hooks-install.sh" >"${workdir}/out4.log" 2>&1
rc=$?
set -e
[[ ${rc} -ne 0 ]] || fail4 "a gitleaks that does not start: expected a refusal, got exit 0"
grep -q '^FAIL  *gitleaks is installed but does not start' "${workdir}/out4.log" \
  || fail4 "a gitleaks that does not start: the refusal does not name it"
[[ ! -e "${pq_repo}/.git/hooks/pre-commit" ]] || fail4 "a hook was written although a prerequisite does not start"
printf '#!/usr/bin/env bash\necho "make: error while loading shared libraries" >&2\nexit 127\n' > "${broken}/make"
chmod +x "${broken}/make"
rm "${broken}/gitleaks"
set +e
PATH="${broken}:${PATH}" bash "${pq_repo}/scripts/hooks-install.sh" >"${workdir}/out4.log" 2>&1
rc=$?
set -e
[[ ${rc} -eq 0 ]] || fail4 "a make that does not start stopped the install, which needs no make: exit ${rc}"

echo "PASS (prerequisites): the install runs the prerequisite check first — a gitleaks that does not start stops it before any hook is written; a broken make does not, the hooks never run it."

# --- Case 5 — the git gitleaks reads through the generated pre-commit ----------------------
# gitleaks scans what `git diff` prints, which the user's git configuration can empty (a
# forced colour) or replace (a textconv driver). The pre-commit adds git's documented
# environment configuration after the caller's: a stub gitleaks reports what git then reads.
fail5() {
  echo "FAIL (pre-commit environment): $1" >&2
  [[ -f "${workdir}/out5.log" ]] && { echo "--- hook output ---" >&2; cat "${workdir}/out5.log" >&2; }
  exit 1
}
probe="${workdir}/probe-bin"
mkdir -p "${probe}"
cat > "${probe}/gitleaks" <<'STUB'
#!/usr/bin/env bash
case "${1:-}" in
  version) echo 8.30.1 ;;
  protect)
    echo "color.diff=$(git config --get color.diff || true)"
    echo "textconv=$(git config --get diff.mask.textconv || true)"
    echo "quotepath=$(git config --get core.quotepath || true)"
    echo "count=${GIT_CONFIG_COUNT:-}" ;;
esac
exit 0
STUB
chmod +x "${probe}/gitleaks"
git -C "${repo}" config diff.mask.textconv "sed -e 's/=.*/= ***/'"
set +e
(cd "${repo}" && PATH="${probe}:${PATH}" GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.quotepath \
  GIT_CONFIG_VALUE_0=false bash .git/hooks/pre-commit) >"${workdir}/out5.log" 2>&1
rc=$?
set -e
[[ ${rc} -eq 0 ]] || fail5 "the hook failed: exit ${rc}"
grep -qx 'color.diff=never' "${workdir}/out5.log" || fail5 "gitleaks' git does not have the colour off"
grep -qx 'textconv=cat' "${workdir}/out5.log" || fail5 "gitleaks' git still runs the project's textconv"
grep -qx 'quotepath=false' "${workdir}/out5.log" || fail5 "the caller's own environment configuration was lost"
grep -qx 'count=3' "${workdir}/out5.log" || fail5 "the entries are not added after the caller's one"
set +e
(cd "${repo}" && PATH="${probe}:${PATH}" GIT_CONFIG_COUNT='1; x' bash .git/hooks/pre-commit) \
  >"${workdir}/out5.log" 2>&1
rc=$?
set -e
[[ ${rc} -ne 0 ]] || fail5 "a GIT_CONFIG_COUNT that is not a number: the hook went on"
grep -q 'GIT_CONFIG_COUNT is not a number' "${workdir}/out5.log" \
  || fail5 "a GIT_CONFIG_COUNT that is not a number: the refusal does not say so"
! grep -q '^color.diff=' "${workdir}/out5.log" \
  || fail5 "a GIT_CONFIG_COUNT that is not a number: gitleaks ran anyway"

echo "PASS (pre-commit environment): gitleaks' git reads the colour off and each textconv as cat, after the caller's own environment configuration, which stays; a GIT_CONFIG_COUNT that is not a number stops the hook before gitleaks."
