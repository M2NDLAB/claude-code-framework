# tools/ — the framework repository's own tools

This directory is NOT part of the payload: setup does not copy it into a project
(`SETUP.md`, step 1), and no project keeps a copy. A project's upgrade reads it from the
framework's clone, at the tag it upgrades to — never from the framework's working tree.

| File | What it is |
| --- | --- |
| `upgrade-check.sh` | The read-only checks of an upgrade (`SETUP.md`, *Upgrading the framework*): `classes`, `preflight`, `inventory`, `invariant`, `post`. It reads the framework only by tag and the project read-only, writes only under `"$T/upgrade-check/"`, and decides nothing: each finding is an `OK`, `FAIL` or `CHECK` line, and the exit code is 1 on any `FAIL`. Its header says how an upgrade runs it. Its class table is the authority, file by file, for the classes of `SETUP.md`. |
| `test-upgrade-check.sh` | Its hermetic self-test, `bash tools/test-upgrade-check.sh`: throwaway repositories under a temporary directory, the real script run end to end. Among its cases, the one that fails when a payload file has no class: run it before every release. |

Prerequisites: git 2.31 or later, bash 3.2 or later (the script avoids what bash 3.2,
macOS's `/bin/bash`, lacks).
