---
type: state
updated: YYYY-MM-DD
branch: <integration branch, e.g. develop>
tags: [state]
---
# STATE — [PROJECT NAME]

> **What this file is.** It is the entry point of the memory: the `SessionStart` hook
> injects it into every new Claude Code session (see `.claude/settings.json`).
> It must always answer: *where we are, what exists, what has been decided and is not
> obvious from the code, what is pending*. It is REWRITTEN at every `/checkpoint` (it
> is not append-only like the sessions). Keep it terse: it is a dashboard, not a journal.
>
> Delete this block of instructions when you initialise the project and replace
> the example contents below with the real ones.

> Updated: YYYY-MM-DD | Last: **<last thing completed>** | Index: [[INDEX]]

## Progress
<!-- Checklist of goals / milestones / high-level "prompts". Tick what is done
     and note the reference (commit/branch). Example: -->
- [ ] 01 — <first block of work> ← NEXT
- [ ] 02 — <...>

## What exists now
<!-- Summary of what has been built, pointing at the component and session notes
     (wikilinks [[...]]). One line or two per component, not a dump. -->
- Directory tree: see [[TREE]].
- <component> — <state (e.g. production-ready / scaffold / WIP)>, see
  [[<component>]] and [[sessions/YYYY-MM-DD-<slug>]].

## Decisions made (not obvious from the code)
<!-- Only what you CANNOT grasp by reading the code: choices, discarded alternatives,
     pitfalls. Formal architectural decisions go in decisions/ (see its
     README); here stays the summary + the pointer. -->
- <decision> → reason / discarded alternative. Pointer: [[YYYY-MM-DD-<slug>]].

## Documentation debt
<!-- What will need documenting and is not documented yet (useful if the project doc
     is born after the code), AND the EXISTING doc found in disagreement with reality —
     e.g. when grafting onto an existing project: it is recorded here, not corrected
     ex officio (docs/06, "Scope of LEVEL 1"). It is emptied as the
     debt is paid off. -->
- <section/page to write or to correct> — <what it must contain / what diverges>

## Caution & open issues
<!-- Known traps, accepted technical debt, fragile things not to break.
     The security debt accepted by the security gate (docs/03) goes HERE, with the reason.
     Every entry with its explicit TRIGGER ("X → blocking precondition of Y",
     "resume when Z"), NEVER generic ("X to be fixed"): a debt with a trigger
     resurfaces at the right moment, a generic one drowns in the noise. The entries must
     SURVIVE the rewrites of this file (a /checkpoint check). -->
- <open issue / accepted debt> — <reason> → <trigger: when it blocks/resumes>
- [[LEARNINGS]]: state of the IMP proposals (open / applied / deferred).

## Active branches
<!-- Which branches exist and what they are for. /checkpoint reconciles this section
     with `git branch --merged <integration>` because merges happen outside the session. -->
- **<integration branch>** = integration.
- **feat/<...>** = <feature in progress>.
