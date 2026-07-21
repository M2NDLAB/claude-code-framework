---
type: tree
updated: YYYY-MM-DD
generated-by: /checkpoint
tags: [structure]
---
# Project structure

> **What this file is.** A map of the repository structure, to be consulted
> BEFORE exploring the filesystem by hand (it saves time and tokens). It is
> REGENERATED mechanically, **never edited by hand**:
>
> ```
> tree -L 3 --dirsfirst -I '<pattern to ignore for your stack>'
> ```
>
> The pattern to ignore depends on the stack — [TO BE DEFINED AT SETUP]. Typical
> examples of folders to exclude: `node_modules`, `dist`, `build`, `target`, `.git`,
> `coverage`, build output folders. If `tree` is not installed, fallback:
> `git ls-files | tree --fromfile` or `git ls-files`.
>
> Delete this block of instructions when you initialise the project.

## Tree (generated)
```
<paste here the output of `tree` regenerated at the last /checkpoint>
```

## Key directory legend
<!-- Explain what each top-level folder contains: it serves whoever (human or
     Claude) lands in the repo without knowing it. -->
| Path | What it contains |
|---|---|
| .claude/docs/ | process documentation (the "method") — load only the relevant files |
| .claude/commands/ | slash commands of the method — the authoritative list is in `CLAUDE.md`, "Quick commands" |
| .claude/memory/ | this memory: [[STATE]], [[TREE]], [[INDEX]], sessions/, decisions/, components/, plans/ |
| <path> | <what it contains> |

## Notes
<!-- Reading conventions for the tree (e.g. reduced depth for components with an
     identical structure, dotfiles not shown by `tree`, etc.). -->
- `tree` does not show dotfiles: `.claude/`, `.gitignore`, etc. also exist.
