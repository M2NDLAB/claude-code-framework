---
date: 2026-07-20
task: Language rule (two axes) + full English translation of the framework — PHASE 1 (assessment, rule, glossary)
branch: feat/english-translation
status: in-progress
tags: [session, language, translation, plan]
---
# Session 2026-07-20 — Language rule + English translation, phase 1

> Written in English by design: it records — and applies — the user's language
> decision (future artifacts in English). The framework's largest deliverable so
> far; phase 2 (the translation itself) starts only after the user approves this
> phase's output (glossary above all).

## Done (phase 1)
- Read the full repo state (all tracked files, 4 647 lines; IMP backlog; behavior
  strings census). Working tree was clean at v1.0.0+1.
- Registered **IMP-040** (two-axis language rule, REPLACES the IMP-029 model),
  **IMP-041** (translate the whole framework — user decision, option 2, with the
  phase-1/phase-2 split and the proposed MAJOR bump), **IMP-042** (deferred
  `/change-language` command, trigger "after 2-3 manual uses").
- Produced the phase-1 report: rule text proposal, translation inventory,
  glossary (below), risk analysis, tension to confirm (fixed rule vs overridable
  default). STOPPED for user review as instructed.

## The rule (user decision, pending final confirmation of non-configurability)
1. **INTERACTION** (how the agent talks to the user in session): configurable,
   `[TO BE DEFINED AT SETUP]` — the only configurable axis.
2. **ARTIFACTS** (everything landing in the repo: code, comments, docs, memory,
   future commits, IMPs, notes): ALWAYS English — fixed framework rule.
3. Past git history: never translated (immutable; no rewrite/force-push).

## Plan (un commit per task) — phase 2, PROVISIONAL until glossary approval
- [x] 0. Phase 1: assessment + IMP-040/041/042 + this note — commit: (this commit)
- [ ] 1. Apply the language rule: CLAUDE.md new global rule + "Interaction
       language" tech-rules slot; SETUP.md §2 checkbox + brownfield host-language
       paragraph (replaces IMP-029 model) — commit: —
- [ ] 2. Behavior-string switch, ATOMIC repo-wide, each string together with every
       grep that reads it: `[DA DEFINIRE AL SETUP]`→`[TO BE DEFINED AT SETUP]`
       (+ short form `[DA DEFINIRE]`→`[TO BE DEFINED]`, lint sentinel),
       `Destinazione: framework`→`Destination: framework`, hook MARKER (generate
       new EN marker, RECOGNIZE legacy IT marker too), `PRONTO PER
       INTEGRAZIONE`→`READY FOR INTEGRATION`, `RACCOLTA PER IL FRAMEWORK`→
       `FRAMEWORK HARVEST`, escalation delimiters (`FINE REPORT`→`END OF REPORT`,
       `FINE RESPONSE`→`END OF RESPONSE`, `FINE RACCOLTA`→`END OF HARVEST`),
       SessionStart banner in settings.json — commit: —
- [ ] 3. Translate CLAUDE.md + docs/00-overview.md — commit: —
- [ ] 4. Translate docs/01, 02, 03 — commit: —
- [ ] 5. Translate docs/04, 05, 06 — commit: —
- [ ] 6. Translate .claude/commands/ (8 files) — commit: —
- [ ] 7. Translate memory templates: STATE, TREE, INDEX + READMEs of sessions/,
       plans/, decisions/, components/ — commit: —
- [ ] 8. Translate scripts (comments + user-facing messages) + Makefile +
       commitlint header + .gitignore + test script; run `make test-scripts` —
       commit: —
- [ ] 9. Translate README.md, SETUP.md, CONTRIBUTING.md, SECURITY.md — commit: —
- [ ] 10. Translate CHANGELOG.md (integral — pending user confirmation) — commit: —
- [ ] 11. Translate LEARNINGS.md (header + all 39+3 IMP entries) — commit: —
- [ ] 12. Translate sessions/ (8 historical notes; declared append-only exception,
       dedicated commit, faithful translation, slugs unchanged) — commit: —
- [ ] 13. Final verification: grep for residual Italian key terms and for every
       OLD section title cited cross-file (0 hits expected outside git history),
       `/lint-memory`, `make test-scripts`, glossary-consistency pass — commit: —

## Glossary (proposed — USER APPROVES; fixed translations for recurring concepts)
| Italiano | English (fixed) |
|---|---|
| regime ibrido (dichiarato) | (declared) hybrid regime |
| innesto / innestare | graft / to graft (matches `grafted:` pin field) |
| "Claude Code propone, l'umano dispone" | "Claude Code proposes, the human disposes" |
| ciclo di fine deliverable | end-of-deliverable cycle |
| prompt oneroso / onerosità | heavy prompt / heaviness |
| task atomico | atomic task |
| mezzo-task | half-done task |
| ripresa (resiliente) | (resilient) resumption; riprendi → resume |
| blocco-piano | plan block |
| nota di sessione | session note |
| cruscotto (STATE) | dashboard |
| diario (sessions) | journal |
| branch di integrazione / stabile | integration branch / stable branch |
| storia condivisa | shared history |
| confine di esecuzione | execution boundary |
| marcatore `[DA DEFINIRE AL SETUP]` | marker `[TO BE DEFINED AT SETUP]` |
| Destinazione: framework | Destination: framework |
| curatela umana | human curation |
| igiene di scope / igiene git ereditata | scope hygiene / inherited git hygiene |
| filtro anti-hype | anti-hype filter |
| anti-vacuità | anti-vacuity (check) |
| debito documentazione | documentation debt |
| trigger di ripresa | resumption trigger |
| attrito | friction |
| correzione fattuale (Livello 1/2) | factual correction (Level 1/2) |
| componenti sensibili | sensitive components |
| classi upgrade: METODO / MEMORIA-DI-PROGETTO / IBRIDO / stato dell'innesto | METHOD / PROJECT-MEMORY / HYBRID / graft state |
| usa-e-getta | throwaway |
| "un task senza memoria aggiornata NON è finito" | "a task without updated memory is NOT done" |
| STATE sections: Stato avanzamento / Cosa esiste adesso / Decisioni prese / Debito documentazione / Attenzione-problemi aperti / Branch attivi | Progress / What exists now / Decisions made (not obvious from the code) / Documentation debt / Caution & open issues / Active branches |
| Comandi rapidi (CLAUDE.md) | Quick commands |
| blocchi: PRONTO PER INTEGRAZIONE / RACCOLTA PER IL FRAMEWORK | READY FOR INTEGRATION / FRAMEWORK HARVEST |

INVARIANT (never translated): file names; wikilink targets (STATE, TREE, INDEX,
LEARNINGS, session slugs); command names; conventional-commit types; frontmatter
keys/values (`type:`, `status: in-progress|completed`, tags); IMP/ESC/ADR/MOC;
greenfield/brownfield; deliverable, checkpoint, Definition of Done, security
gate, provenance pin, `wip:`; script identifiers/variables; past commits.

## Open points (for the user, raised in the phase-1 report)
1. **Tension**: "artifacts always English, non-configurable" is an imposed value
   choice (breaks pure agnosticism on the language axis). Confirm fixed rule vs
   `[TO BE DEFINED AT SETUP]` with English default. Sub-point: on brownfield
   grafts the host's pre-existing docs are NOT bulk-translated (scope hygiene,
   like past commits) — rule applies to method artifacts and NEW artifacts.
2. CHANGELOG: integral translation proposed (it is live doc, the upgrade index) —
   confirm.
3. sessions/: translating them is an edit to append-only notes — proposed as a
   DECLARED exception in a dedicated commit; alternative: leave them Italian.
4. Bump: proposed **MAJOR v2.0.0** (marker/grep format change = breaking per
   CONTRIBUTING.md); user decides at `/integrate`.

## Collegamenti
[[LEARNINGS]] (IMP-040, IMP-041, IMP-042)
