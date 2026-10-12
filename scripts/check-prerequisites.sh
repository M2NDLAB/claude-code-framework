#!/usr/bin/env bash
# The framework's prerequisites, checked. Each tool is RUN, not only found — a tool can be
# installed and still not start —, its version compared with the minimum below, the platform
# named, and the line ends git would give the framework's files looked at.
#
#   bash scripts/check-prerequisites.sh
#
# Runnable without make, from the project's root or from the framework's clone: the working
# directory is the repository whose line ends it reads. It installs NOTHING — installing
# system software stays a human action. Exit 1 only when a tool is missing or does not
# start; a version below its minimum, or one it cannot read, is a warning: a minimum is the
# tool's own requirement read from its source, not a release run here.
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "usage: bash scripts/check-prerequisites.sh" >&2
  exit 2
fi

# --- The prerequisites, in one place ---------------------------------------------------------
# One line per tool: its name | its minimum ("-": none) | what needs it | where to install it.
#   git 2.31    `git rev-parse --path-format`, which hooks-install.sh and the upgrade use
#   bash 3.2    the oldest bash the framework's scripts are written for (macOS's /bin/bash)
#   node 22.12  the `engines` of commitlint's 21.x line, which the commit-msg hook runs
#               through npx; the agent git guard needs less
PREREQUISITES='git|2.31|the hooks and the upgrade (git rev-parse --path-format)|https://git-scm.com/downloads
bash|3.2|the scripts and the hooks|https://www.gnu.org/software/bash/
make|-|the process targets (make hooks-install, make test-scripts, make reset-task)|https://www.gnu.org/software/make/
gitleaks|-|the secret scan of the pre-commit hook|https://github.com/gitleaks/gitleaks#installing
node|22.12|commitlint (the commit-msg hook) and the agent git guard|https://nodejs.org/en/download
npx|-|commitlint, which the commit-msg hook runs|https://nodejs.org/en/download'
# The POSIX userland the scripts and the hooks run, beyond bash's builtins.
USERLAND='awk sed grep find xargs sort diff cmp'

fails=0
warns=0
say() { printf '%-6s %s\n' "$1" "$2"; }
fail() { fails=$((fails + 1)); say FAIL "$1"; }
warn() { warns=$((warns + 1)); say WARN "$1"; }

# first_line <text>: its first line, without the carriage return a Windows program ends it with.
first_line() { printf '%s\n' "$1" | sed -n '1p' | tr -d '\r' || true; }

# version_number <line>: the first dotted number in it — 2.39.5 in "git version 2.39.5 (Apple
# Git-154)", 3.2.57 in "GNU bash, version 3.2.57(1)-release".
version_number() { printf '%s\n' "$1" | sed -n 's/^[^0-9]*\([0-9][0-9]*\(\.[0-9][0-9]*\)*\).*/\1/p' || true; }

# at_least <version> <minimum>: true when the version is at or above the minimum, compared
# number by number — 22.9 is below 22.12, which a comparison of strings gets wrong. No
# `sort -V`: the BSD sort of older macOS releases lacks it.
at_least() {
  awk -v v="$1" -v m="$2" 'BEGIN {
    n = split(v, a, "."); k = split(m, b, ".")
    for (i = 1; i <= (n > k ? n : k); i++) {
      if (a[i] + 0 > b[i] + 0) exit 0
      if (a[i] + 0 < b[i] + 0) exit 1
    }
    exit 0
  }'
}

# version_of <tool>: the tool's version command — for gitleaks the `version` subcommand, which
# every 8.x release has (its `--version` came later).
version_of() {
  if [[ "$1" == gitleaks ]]; then gitleaks version; else "$1" --version; fi
}

# check_tool <tool> <minimum> <what needs it> <where to install it>
check_tool() {
  local tool="$1" min="$2" why="$3" page="$4" out line version
  if ! command -v "${tool}" >/dev/null 2>&1; then
    fail "${tool} not found: needed by ${why} — install it: ${page}"
    return 0
  fi
  if ! out="$(version_of "${tool}" 2>&1 </dev/null)"; then
    fail "${tool} is installed but does not start: $(first_line "${out}") — install it again: ${page}"
    return 0
  fi
  line="$(first_line "${out}")"
  version="$(version_number "${line}")"
  if [[ "${min}" == - ]]; then
    if [[ -n "${version}" ]]; then say OK "${tool} ${version}"; else say OK "${tool} runs"; fi
  elif [[ -z "${version}" ]]; then
    warn "${tool}: its version cannot be read (\"${line}\"); ${min} or later is needed by ${why} — ${page}"
  elif at_least "${version}" "${min}"; then
    say OK "${tool} ${version} (${min} or later)"
  else
    warn "${tool} ${version} is below ${min}, needed by ${why} — ${page}"
  fi
}

# probe <tool>: runs a userland tool on nothing, the same way on GNU and BSD.
probe() {
  case "$1" in
    awk) awk 'BEGIN { exit 0 }' ;;
    sed) sed -n '1p' </dev/null ;;
    grep) printf 'x\n' | grep -q x ;;
    find) find /dev/null -prune ;;
    xargs) xargs </dev/null ;;
    sort) sort </dev/null ;;
    diff) diff /dev/null /dev/null ;;
    cmp) cmp /dev/null /dev/null ;;
  esac
}

check_userland() {
  local tool missing=""
  for tool in ${USERLAND}; do
    probe "${tool}" >/dev/null 2>&1 || missing="${missing} ${tool}"
  done
  if [[ -n "${missing}" ]]; then
    fail "the POSIX userland lacks${missing}, missing or not starting — macOS and Linux ship it; on Windows Git for Windows brings it: https://git-scm.com/downloads"
  else
    say OK "the POSIX userland: ${USERLAND}"
  fi
}

# The platform, and whether the framework's CI verifies it: macOS on arm64, Linux on x86_64
# (WSL excluded), Windows on x86_64 through Git Bash.
platform() {
  local os arch name verified=no
  os="$(uname -s 2>/dev/null || echo unknown)"
  arch="$(uname -m 2>/dev/null || echo unknown)"
  case "${os}" in
    Darwin)
      name=macOS
      if [[ "${arch}" == arm64 ]]; then verified=yes; fi ;;
    Linux)
      case "$(uname -r 2>/dev/null || true)" in
        *[Mm]icrosoft*) name="Linux under WSL" ;;
        *)
          name=Linux
          if [[ "${arch}" == x86_64 ]]; then verified=yes; fi ;;
      esac ;;
    MINGW* | MSYS*)
      name="Windows, Git Bash"
      if [[ "${arch}" == x86_64 ]]; then verified=yes; fi ;;
    CYGWIN*) name="Windows, Cygwin" ;;
    *) name="${os}" ;;
  esac
  if [[ "${verified}" == yes ]]; then
    echo "check-prerequisites: ${name} (${arch}), a platform the framework's CI verifies"
  else
    echo "check-prerequisites: ${name} (${arch}), not a platform the framework's CI verifies"
  fi
}

# Line ends: with core.autocrlf true, git checks text out with CRLF unless an attribute holds
# the file to LF — and bash cannot run a script with CRLF line ends. The test is the one the
# upgrade's line-end step makes: `git check-attr eol` on CLAUDE.md.
line_ends() {
  local autocrlf eol
  if ! command -v git >/dev/null 2>&1 \
    || [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null || true)" != true ]]; then
    say SKIP "line ends: not inside a git repository"
    return 0
  fi
  autocrlf="$(first_line "$(git config --get core.autocrlf 2>/dev/null || true)")"
  case "${autocrlf}" in
    [Tt][Rr][Uu][Ee] | [Yy][Ee][Ss] | [Oo][Nn] | 1) ;;
    *)
      say OK "line ends: core.autocrlf is not true"
      return 0 ;;
  esac
  eol="$(first_line "$(git check-attr eol -- CLAUDE.md 2>/dev/null || true)")"
  if [[ "${eol}" == "CLAUDE.md: eol: lf" ]]; then
    say OK "line ends: core.autocrlf is true, and .gitattributes holds the framework's files to LF"
  else
    warn "line ends: core.autocrlf is true and nothing holds the framework's files to LF — a checkout writes them with CRLF, which bash cannot run: bring in the framework's .gitattributes (the framework's SETUP.md, step 1)"
  fi
}

platform
while IFS='|' read -r tool min why page; do
  [[ -n "${tool}" ]] || continue
  check_tool "${tool}" "${min}" "${why}" "${page}"
done <<EOF
${PREREQUISITES}
EOF
check_userland
line_ends
echo "check-prerequisites: ${fails} FAIL, ${warns} WARN"
exit $((fails > 0))
