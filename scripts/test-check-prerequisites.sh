#!/usr/bin/env bash
# Self-test of scripts/check-prerequisites.sh. Five cases:
#   1. every tool present, at or above its minimum: exit 0 and an OK line for each tool the
#      check lists, a version equal to its minimum included — see "Case 1";
#   2. a tool missing, one installed that does not start, a userland tool missing: exit 1, a
#      FAIL line for each with where to install it, and the other tools still checked;
#   3. a version below its minimum — compared number by number: 22.9 is below 22.12 — and one
#      that cannot be read: a WARN line each, exit 0;
#   4. the platform, read from uname: the three the framework's CI verifies said to be so;
#      another architecture, WSL, Cygwin and another system said not to be;
#   5. line ends: core.autocrlf true with nothing holding the framework's files to LF warns;
#      held to LF, or core.autocrlf not true, it does not; outside a repository, not checked.
#
# HERMETIC: the tools are stubs in a PATH of the test's own, beside wrappers for the real
# tools the check itself runs — wrappers, not links: Git Bash's `ln -s` copies a binary away
# from the DLL it loads (measured in the CI on Windows). git's stub answers --version and
# hands every other call to the real git, on throwaway repositories only.
set -euo pipefail

# Hermetic against the user's own git configuration and the caller's git environment, as the
# other self-tests are: a system core.autocrlf (Git for Windows sets one) would change case 5.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset $(git rev-parse --local-env-vars) GIT_TEMPLATE_DIR

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CHECK="${SCRIPT_DIR}/check-prerequisites.sh"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT
# Keeps git from finding a repository above the throwaway ones (case 5, outside).
export GIT_CEILING_DIRECTORIES="${workdir}"
out="${workdir}/out"
rc=-

fail() {
  echo "FAIL (prerequisite check): $1" >&2
  if [[ -f "${out}" ]]; then
    echo "--- its output (exit ${rc}) ---" >&2
    cat "${out}" >&2
  fi
  exit 1
}

# The real tools the check runs on its own account, and the userland it probes, as wrappers;
# echo for xargs, which GNU's runs once on empty input. `type -P`: the program, not a builtin.
REAL_GIT="$(type -P git)"
real="${workdir}/real"
mkdir -p "${real}"
for tool in awk sed grep find xargs sort diff cmp tr uname echo; do
  printf '#!/bin/sh\nexec "%s" "$@"\n' "$(type -P "${tool}")" > "${real}/${tool}"
  chmod +x "${real}/${tool}"
done

# stub <dir> <tool> <first line> [exit code]: a tool that prints its line and exits — on
# stderr when the exit code says it did not start.
stub() {
  mkdir -p "$1"
  if [[ "${4:-0}" == 0 ]]; then
    printf '#!/bin/sh\necho %s\n' "'$3'" > "$1/$2"
  else
    printf '#!/bin/sh\necho %s >&2\nexit %s\n' "'$3'" "$4" > "$1/$2"
  fi
  chmod +x "$1/$2"
}
# git_stub <dir> <first line>: git answering --version itself and handing the rest on.
git_stub() {
  mkdir -p "$1"
  printf '#!/bin/sh\nif [ "$1" = --version ]; then echo %s; exit 0; fi\nexec "%s" "$@"\n' \
    "'$2'" "${REAL_GIT}" > "$1/git"
  chmod +x "$1/git"
}
# gitleaks_stub <dir> <first line>: gitleaks answering its `version` subcommand only, as 8.0.0
# does — `--version` came later.
gitleaks_stub() {
  mkdir -p "$1"
  printf '#!/bin/sh\nif [ "$1" = version ]; then echo %s; exit 0; fi\necho "unknown flag: $1" >&2\nexit 1\n' \
    "'$2'" > "$1/gitleaks"
  chmod +x "$1/gitleaks"
}
# good <dir>: every tool present; git and node exactly at their minimums.
good() {
  git_stub "$1" 'git version 2.31.0'
  stub "$1" bash 'GNU bash, version 3.2.57(1)-release (arm64-apple-darwin26)'
  stub "$1" make 'GNU Make 3.81'
  gitleaks_stub "$1" '8.30.1'
  stub "$1" node 'v22.12.0'
  stub "$1" npx '10.9.2'
}
# run <stub dir> <working directory> [userland dir]: the check, with only these on PATH.
run() {
  set +e
  (cd "$2" && PATH="$1:${3:-${real}}" "${BASH}" "${CHECK}") >"${out}" 2>&1
  rc=$?
  set -e
}
has() { grep -qE -e "$1" "${out}" || fail "$2"; }
lacks() { ! grep -qE -e "$1" "${out}" || fail "$2"; }

lf_repo="${workdir}/lf"
git init -q "${lf_repo}"

# --- Case 1 — every tool present, at or above its minimum --------------------------------------
# The tools are read from the check's own list, so a tool added there without a stub here fails.
tools="$(sed -n "/^PREREQUISITES='/,/'\$/p" "${CHECK}" | sed "s/^PREREQUISITES='//" | cut -d'|' -f1)"
[[ "$(printf '%s\n' "${tools}" | grep -c .)" -ge 6 ]] || fail "fewer than six tools read from the check's PREREQUISITES: the extraction is wrong"
good "${workdir}/case1"
run "${workdir}/case1" "${lf_repo}"
[[ ${rc} -eq 0 ]] || fail "every tool present: expected exit 0, got ${rc}"
for tool in ${tools}; do
  has "^OK +${tool} " "every tool present: no OK line for ${tool}"
done
has '^OK +git 2\.31\.0 \(2\.31 or later\)$' "git exactly at its minimum is not OK"
has '^OK +node 22\.12\.0 \(22\.12 or later\)$' "node exactly at its minimum is not OK"
has '^OK +bash 3\.2\.57 \(3\.2 or later\)$' "bash above its minimum is not OK"
has '^OK +make 3\.81$' "make, which has no minimum, is not a plain OK line"
has '^OK +gitleaks 8\.30\.1$' "gitleaks, through its version subcommand, is not a plain OK line"
has '^OK +npx 10\.9\.2$' "npx, which has no minimum, is not a plain OK line"
has '^OK +the POSIX userland: ' "the userland present is not OK"
lacks '^(WARN|FAIL) ' "every tool present: a WARN or a FAIL line"
has '^check-prerequisites: 0 FAIL, 0 WARN$' "every tool present: the summary is not 0 FAIL, 0 WARN"

# --- Case 2 — a tool missing, one that does not start, a userland tool missing -----------------
good "${workdir}/case2"
rm "${workdir}/case2/gitleaks"
stub "${workdir}/case2" node 'dyld[4242]: Library not loaded: @rpath/libnode.127.dylib' 134
no_cmp="${workdir}/no-cmp"
mkdir -p "${no_cmp}"
cp "${real}"/* "${no_cmp}/"
rm "${no_cmp}/cmp"
run "${workdir}/case2" "${lf_repo}" "${no_cmp}"
[[ ${rc} -eq 1 ]] || fail "tools missing or not starting: expected exit 1, got ${rc}"
has '^FAIL +gitleaks not found: .*https://github\.com/gitleaks/gitleaks#installing$' \
  "a missing gitleaks: no FAIL line with where to install it"
has '^FAIL +node is installed but does not start: dyld\[4242\]: Library not loaded.*https://nodejs\.org/' \
  "a node that does not start: no FAIL line with its error and where to install it"
has '^FAIL +the POSIX userland lacks cmp,' "a missing cmp: no FAIL line naming it"
has '^OK +npx 10\.9\.2$' "after a failure, the tools listed after it were not checked"
has '^check-prerequisites: 3 FAIL, 0 WARN$' "tools missing or not starting: the summary is not 3 FAIL, 0 WARN"

# --- Case 3 — below a minimum, or a version that cannot be read: warnings only -----------------
good "${workdir}/case3"
git_stub "${workdir}/case3" 'git version unknown'
stub "${workdir}/case3" bash 'GNU bash, version 3.1.17(1)-release (x86_64-pc-linux-gnu)'
stub "${workdir}/case3" node 'v22.9.0'
run "${workdir}/case3" "${lf_repo}"
[[ ${rc} -eq 0 ]] || fail "below a minimum: expected exit 0 (a warning, never a failure), got ${rc}"
has '^WARN +bash 3\.1\.17 is below 3\.2, needed by .*https://www\.gnu\.org/software/bash/$' \
  "bash below its minimum: no WARN line with where to install it"
has '^WARN +node 22\.9\.0 is below 22\.12, needed by ' "node 22.9.0 is not below 22.12: the comparison is not number by number"
has '^WARN +git: its version cannot be read \("git version unknown"\); 2\.31 or later is needed' \
  "git's version unread: no WARN line"
lacks '^FAIL ' "below a minimum: a FAIL line"
has '^check-prerequisites: 0 FAIL, 3 WARN$' "below a minimum: the summary is not 0 FAIL, 3 WARN"

# --- Case 4 — the platform, read from uname ------------------------------------------------------
# platform_is <uname -s> <uname -m> <uname -r> <what the first line must say>
platform_is() {
  local dir="${workdir}/case4"
  good "${dir}"
  printf '#!/bin/sh\ncase "$1" in -s) echo %s ;; -m) echo %s ;; -r) echo %s ;; esac\n' \
    "'$1'" "'$2'" "'$3'" > "${dir}/uname"
  chmod +x "${dir}/uname"
  run "${dir}" "${lf_repo}"
  [[ "$(sed -n 1p "${out}")" == "check-prerequisites: $4" ]] \
    || fail "uname $1, $2, $3: the first line is not \"check-prerequisites: $4\""
}
verified="a platform the framework's CI verifies"
not_verified="not a platform the framework's CI verifies"
platform_is Darwin arm64 25.0.0 "macOS (arm64), ${verified}"
platform_is Darwin x86_64 24.6.0 "macOS (x86_64), ${not_verified}"
platform_is Linux x86_64 6.11.0-1018-azure "Linux (x86_64), ${verified}"
platform_is Linux aarch64 6.8.0-1009-raspi "Linux (aarch64), ${not_verified}"
platform_is Linux x86_64 5.15.167.4-microsoft-standard-WSL2 "Linux under WSL (x86_64), ${not_verified}"
platform_is MINGW64_NT-10.0-26100 x86_64 3.5.4-0bc1222b.x86_64 "Windows, Git Bash (x86_64), ${verified}"
platform_is MSYS_NT-10.0-26100 x86_64 3.5.4-0bc1222b.x86_64 "Windows, Git Bash (x86_64), ${verified}"
platform_is MINGW64_NT-10.0-26100 aarch64 3.5.4-0bc1222b.aarch64 "Windows, Git Bash (aarch64), ${not_verified}"
platform_is CYGWIN_NT-10.0-26100 x86_64 3.5.4-1.x86_64 "Windows, Cygwin (x86_64), ${not_verified}"
platform_is FreeBSD amd64 14.1-RELEASE "FreeBSD (amd64), ${not_verified}"

# --- Case 5 — line ends ------------------------------------------------------------------------
good "${workdir}/case5"
crlf_repo="${workdir}/crlf"
git init -q "${crlf_repo}"
git -C "${crlf_repo}" config core.autocrlf true
held_repo="${workdir}/held"
git init -q "${held_repo}"
git -C "${held_repo}" config core.autocrlf true
cp "${REPO_ROOT}/.gitattributes" "${held_repo}/.gitattributes"
outside="${workdir}/outside"
mkdir -p "${outside}"

run "${workdir}/case5" "${crlf_repo}"
[[ ${rc} -eq 0 ]] || fail "core.autocrlf true, nothing holding LF: expected exit 0 (a warning), got ${rc}"
has '^WARN +line ends: core\.autocrlf is true and nothing holds the framework.s files to LF' \
  "core.autocrlf true with nothing holding the framework's files to LF: no WARN line"
has '^check-prerequisites: 0 FAIL, 1 WARN$' "core.autocrlf true, nothing holding LF: the summary is not 0 FAIL, 1 WARN"
run "${workdir}/case5" "${held_repo}"
has '^OK +line ends: core\.autocrlf is true, and \.gitattributes holds' \
  "core.autocrlf true with the framework's .gitattributes: no OK line for the line ends"
lacks '^WARN ' "core.autocrlf true with the framework's .gitattributes: a WARN line"
run "${workdir}/case5" "${lf_repo}"
has '^OK +line ends: core\.autocrlf is not true$' "core.autocrlf unset: no OK line for the line ends"
run "${workdir}/case5" "${outside}"
has '^SKIP +line ends: not inside a git repository$' "outside a repository: the line ends not said to be unchecked"
[[ ${rc} -eq 0 ]] || fail "outside a repository: expected exit 0, got ${rc}"

echo "PASS (prerequisite check): every tool run and held against its minimum number by number — a FAIL only for a tool missing or not starting, a WARN below a minimum or for a version unread —, the platform named as verified or not, the line ends warned about only where git would write CRLF."
