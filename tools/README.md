# tools/ — the framework repository's own tools

This directory is NOT part of the payload: setup does not copy it into a project
(`SETUP.md`, step 1), and no project keeps a copy. A project's upgrade reads it from the
framework's clone, at the tag it upgrades to — never from the framework's working tree.

| File | What it is |
| --- | --- |
| `upgrade-check.sh` | The read-only checks of an upgrade (`SETUP.md`, *Upgrading the framework*): `classes`, `preflight`, `inventory`, `invariant`, `post`. It reads the framework only by tag and the project read-only, writes only under `"$T/upgrade-check/"`, and decides nothing: each finding is an `OK`, `FAIL` or `CHECK` line, and the exit code is 1 on any `FAIL`. Its header says how an upgrade runs it. Its class table is the authority, file by file, for the classes of `SETUP.md`. |
| `test-upgrade-check.sh` | Its hermetic self-test, `bash tools/test-upgrade-check.sh`: throwaway repositories under a temporary directory, the real script run end to end. Among its cases, the one that fails when a payload file has no class: run it before every release. |
| `docs-check.mjs` | The mechanical documentation check of this repository, `node tools/docs-check.mjs`: the payload's purity, and the documents' lists, links, versions and language against what exists. It reads the working tree, the tags and the commits, and writes nothing; each finding is an `OK`, `FAIL` or `CHECK` line, the exit code 1 on any `FAIL`. What its rules cannot tell apart is declared in its allow-list, each entry with its reason; an entry that matches nothing fails. A phrase in quotes right after a file name is read as one of that file's section titles, never as a quotation. `make test-scripts` runs it, here only. |
| `.gitattributes` | LF line ends for these tools on every platform: the CI runs them on Windows too. |
| `test-docs-check.sh` | Its hermetic self-test, `bash tools/test-docs-check.sh`: a throwaway clone of this repository, its tags and its working tree, checked as it is and with one defect per case. `make test-scripts` runs it before the check. |
| `test-real-hooks.sh` | The generated hooks with the REAL gitleaks and commitlint, `bash tools/test-real-hooks.sh` — the shipped self-tests stub both: six cases, the pre-commit hook refusing a staged secret (built at run time) — also with a colour the user's git config forces and behind a textconv driver that masks it — and letting a clean change through, the commit-msg hook, at the pinned commitlint, accepting a conforming message and refusing one without a type. It needs gitleaks, npx and the network; the CI runs it on the three platforms, with gitleaks at a fixed version and checksum. |

**A new rule answers an observed defect.** Together these tools exceed 3000 lines. A new
rule in `upgrade-check.sh` or `docs-check.mjs` answers a defect that was OBSERVED — in an
upgrade, a review, a CI run, a measured simulation —, never a hypothetical one.

Prerequisites: git 2.31 or later, bash 3.2 or later (the scripts avoid what bash 3.2,
macOS's `/bin/bash`, lacks); Node.js 22.12 or later, the framework's minimum, for the
documentation check; for `test-real-hooks.sh`, gitleaks 8.0.0 or later and npx too.
