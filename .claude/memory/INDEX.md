---
type: index
updated: YYYY-MM-DD
tags: [moc]
---
# INDEX — persistent memory [PROJECT NAME] (MOC)

> **What this file is.** The Map Of Content of the memory. [[STATE]] is the
> operational entry point (injected by the hook); from here, instead, you navigate
> everything else. The `.claude/` folder is designed to open as an Obsidian vault
> too: the `[[...]]` wikilinks generate the graph view, but they work just as well
> as plain pointers in any editor.
>
> Delete this block of instructions when you initialise the project and populate
> the sections as the notes come into being.

## State
- [[STATE]] — current state: progress, decisions, documentation debt, open issues
- [[TREE]] — repository structure (regenerated, never edited by hand)
- [[LEARNINGS]] — backlog of process improvements (IMP): open / applied / deferred

## By component
<!-- One pointer for every note in components/. A stub until the component exists. -->
- [[<component>]] — <a one-line status>

## By phase (sessions — append-only)
<!-- One pointer for every note in sessions/, in chronological order. -->
- [[sessions/YYYY-MM-DD-<slug>]] — <what happened in that session>

## Decisions
<!-- One pointer for every note in decisions/ (or to your formal ADRs). -->
- [[YYYY-MM-DD-<slug>]] — <summary of the decision>

## Plans
<!-- Task plans for heavy prompts (see docs/01-task-planning.md). -->
- [[plans/<id-prompt>]] — <objective> (status: in-progress | completed)
