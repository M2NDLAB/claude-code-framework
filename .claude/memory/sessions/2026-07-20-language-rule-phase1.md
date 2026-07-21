---
date: 2026-07-20
task: Language rule (two axes) + full English translation of the framework — PHASE 1 (assessment, rule, glossary), PHASE 2 (translation)
branch: feat/english-translation
status: completed
tags: [session, language, translation, plan]
---
# Session 2026-07-20 — Language rule + English translation

> Written in English by design: it records — and applies — the user's language
> decision (artifacts in English). The framework's largest deliverable so far.
> This note is the plan-pointer: hybrid regime, so no file in `plans/` and no
> record in `decisions/` (see `01-task-planning.md`, hybrid-regime box).

## Done (phase 1)
- Read the full repo state (all tracked files, 4 647 lines at that point; IMP
  backlog; behavior-string census). Working tree was clean at v1.0.0+1.
- Registered **IMP-040** (two-axis language rule, REPLACES the IMP-029 model),
  **IMP-041** (translate the whole framework — user decision, option 2, with the
  phase-1/phase-2 split), **IMP-042** (deferred `/change-language` command,
  trigger "after 2-3 manual uses").
- Produced the phase-1 report: rule text proposal, translation inventory,
  glossary, risk analysis, tension to confirm. STOPPED for user review.

## Decisions taken by the user (2026-07-21, phase 2 authorisation)
1. **The tension is resolved as a DECLARED OPINIONATED CHOICE.** "Artifacts always
   English, not configurable" is not a leftover of the framework's own language: it
   is a deliberate stance, to be stated openly in `CLAUDE.md`/`SETUP.md` and in
   IMP-040. Rationale: English code and documentation is a universal open-source
   best practice, and the portability of artifacts outweighs agnosticism on this
   one axis. Interaction language stays configurable — it is the only axis that is.
2. **The glossary is LAW**: applied literally and identically in every file.
   Confirmed key terms: innesto → **graft**, regime ibrido → **hybrid regime**,
   the cardinal principle → **"the agent proposes, the human disposes"**. The
   **IMP** acronym is a stable identifier and is NOT translated; only its
   expansion is (→ *improvement proposal*).
3. **Behavior-bearing strings: translated WITH backward compatibility.** The three
   grep-coupled tokens switch to English, but every READER recognises the legacy
   Italian form as well (`/lint-memory` sentinel, `/harvest-framework` grep,
   `hooks-install.sh` marker). Consequence — the atomicity requirement of the
   phase-1 plan is DROPPED: what must come first is only that the readers accept
   both forms (task 2). Every later commit is consistent on its own.
4. **`CHANGELOG.md` is translated in full** — it is live documentation (the
   upgrade index), not history. Versions, dates and shas stay untouched.
5. **`sessions/` are translated** as a DECLARED exception to the append-only rule,
   in a dedicated commit, faithfully, with slugs unchanged.

## Version bump — reasoning (final call is the user's at `/integrate`)
**MINOR**, not MAJOR. The phase-1 proposal was MAJOR on the grounds that changing
the marker format breaks greps in existing grafts and upgrades. Decision 3 removes
that premise: the readers keep recognising the legacy tokens, so no existing graft
breaks and the public contract of the method is not broken. What is left is (a) a
massive content change that adds no capability — by itself not even a release, and
(b) one genuinely new rule (the language rule) plus one configuration slot renamed
and one axis removed from the setup surface. A backward-compatible addition of a
rule is exactly the MINOR case of `04-git-workflow.md`. Post-1.0 the tag lives on
the stable branch, after the release merge.

## The rule (as applied in phase 2)
1. **INTERACTION** — how the agent talks to the user in session: configurable,
   `[TO BE DEFINED AT SETUP]`. The only configurable axis.
2. **ARTIFACTS** — everything landing in the repo (code, comments, docs, memory,
   future commits, IMP entries, notes): ALWAYS English. Fixed rule, declared as a
   deliberate opinionated choice.
3. Past git history: never translated (immutable; no rewrite, no force-push).

## Plan (one commit per task) — phase 2 — COMPLETE
- [x] 0. Phase 1: assessment + IMP-040/041/042 + this note — commit: b292d30
- [x] 1. Phase-2 plan block + confirmed decisions in this note — commit: 7ce255a
- [x] 2. Backward-compatible READERS (before any token switch): `/lint-memory`
       sentinel, `/harvest-framework` grep, `hooks-install.sh` marker +
       `test-hooks-install.sh` — commit: 91f0ca7
- [x] 3. `CLAUDE.md`: translation + new two-axis language rule (IMP-040 applied),
       "Interaction language" slot replacing "Lingua/e del progetto" — commit: 0d725df
- [x] 4. `docs/00-overview.md`, `01-task-planning.md`, `02-code-quality.md`,
       `03-security-gate.md` — commit: ebd6be0
- [x] 5. `docs/04-git-workflow.md`, `05-escalation-protocol.md`,
       `06-self-improvement.md` — commit: b978a76
- [x] 6. `SETUP.md` (replaces the IMP-029 model; brownfield host-language
       paragraph) — commit: 5a499e6
- [x] 7. `README.md`, `CONTRIBUTING.md`, `SECURITY.md` — commit: 614a0e5
- [x] 8. `.claude/commands/` (8 files) — commit: 46f6bb1
- [x] 9. Memory templates: `STATE.md`, `TREE.md`, `INDEX.md` + the READMEs of
       `sessions/`, `plans/`, `decisions/`, `components/` — commit: b36a2a9
- [x] 10. `LEARNINGS.md`: header + all IMP entries; IMP-040 rewritten as a declared
       opinionated choice; duplicate `## Applicate` heading fixed — commit: 0c50dad
- [x] 11. `sessions/` (10 historical notes — declared append-only exception) —
       commit: 3002db2
- [x] 12. `scripts/` + `Makefile` + commitlint header + `.gitignore` +
       `settings.json` banner + `CHANGELOG.md` — commits: b401ae6, e00efad
- [x] 13. Final verification: single-form grep for every glossary term, wikilink
       and cross-reference check, `/lint-memory` (incl. check 11),
       `make test-scripts` — commit: (this commit)

> Tasks 7 and 12 landed out of numeric order: the fan-out for the independent
> file groups (tasks 8/9/11) ran in the background while the delicate single
> files were translated in the foreground, and each group was committed as soon
> as it was verified. The plan order is the source of truth, not the git order.

## Final verification (task 13) — outcome
- **Glossary, single form**: 20 key terms grepped repo-wide; each resolves to one
  rendering. Two apparent variants inspected and cleared: `retrofit` is the
  provenance-pin retrofit (it was "retrofit" in the Italian too, not a `graft`
  variant), and `END OF DELIVERABLE` in caps is the diagram label of docs/00.
  One real variant found and fixed: `doc debt` → `documentation debt` in INDEX.
- **Wikilinks**: every target resolves; all session slugs are still Italian, as
  intended.
- **Cross-references**: one broken pointer found and fixed — README pointed at
  *"Evolving the framework"* where the Italian pointed at the upgrade section.
  This is precisely the risk flagged in the phase-1 analysis.
- **Markers**: 22 files carry `[TO BE DEFINED AT SETUP]`; the only remaining
  Italian occurrences are the deliberate dual-form greps and historical quotes
  inside IMP records and session notes.
- **`/lint-memory`, including check 11**: GREEN. Check 11 matches in all three
  directions (8 commands on disk = 8 in "Quick commands" = 8 in the README
  structure; the three Makefile process targets present, `reset-task` in its
  equivalent form; 3 scripts = 3 rows in `scripts/README.md`). Check 10's
  sentinel returns zero hits. Checks 1, 8 and 9 are not applicable in the hybrid
  regime: `STATE`/`TREE`/`INDEX` are clean templates here.
  Check 4 found two orphan session notes — **pre-existing**, with zero incoming
  references already at b292d30, so not caused by this deliverable. Fixed by
  linking them from this note rather than by editing append-only history.
- **`make test-scripts`**: green. `settings.json` parses with its permission
  lists unchanged; `make help` lists the same four targets.

## Glossary (APPROVED — law for phase 2)
| Italiano | English (fixed) |
|---|---|
| regime ibrido (dichiarato) | (declared) hybrid regime |
| innesto / innestare | graft / to graft (matches `grafted:` pin field) |
| "Claude Code propone, l'umano dispone" | "the agent proposes, the human disposes" |
| ciclo di fine deliverable | end-of-deliverable cycle |
| a fine deliverable (avverbiale) | at the end of a deliverable |
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
| `[DA DEFINIRE]` (short form) | `[TO BE DEFINED]` |
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
| proposta di miglioramento | improvement proposal (acronym IMP unchanged) |
| backlog IMP | IMP backlog |
| "un task senza memoria aggiornata NON è finito" | "a task without updated memory is NOT done" |
| STATE sections: Stato avanzamento / Cosa esiste adesso / Decisioni prese / Debito documentazione / Attenzione-problemi aperti / Branch attivi | Progress / What exists now / Decisions made (not obvious from the code) / Documentation debt / Caution & open issues / Active branches |
| LEARNINGS sections: Proposte APERTE / Applicate / Rimandate / Rifiutate | OPEN proposals / Applied / Deferred / Rejected |
| Comandi rapidi (CLAUDE.md) | Quick commands |
| blocchi: PRONTO PER INTEGRAZIONE / RACCOLTA PER IL FRAMEWORK | READY FOR INTEGRATION / FRAMEWORK HARVEST |
| FINE REPORT / FINE RESPONSE / FINE RACCOLTA | END OF REPORT / END OF RESPONSE / END OF HARVEST |

INVARIANT (never translated): file names; wikilink targets (STATE, TREE, INDEX,
LEARNINGS, session slugs); command names; conventional-commit types; frontmatter
keys/values (`type:`, `status: in-progress|completed`, tags); IMP/ESC/ADR/MOC;
greenfield/brownfield; deliverable, checkpoint, Definition of Done, security
gate, provenance pin, `wip:`; script identifiers/variables; shas quoted in notes;
past commits.

## Resumption notes
Resume from the first unticked task above. `git log --oneline` on this branch
confirms what is already committed (`[task N/13]` in every message). If the
working tree is dirty, discard the half-done task with `scripts/reset-task.sh`
before resuming — never re-run a committed task.

## Links
[[LEARNINGS]] (IMP-040, IMP-041, IMP-042)

Linked here to give them an incoming reference (lint check 4): they were orphans
before this deliverable, and in the hybrid regime `INDEX.md` stays a clean
template, so it cannot index them —
[[2026-07-11-consolidamento-assessment]] (the framework's first consolidation
assessment) and [[2026-07-19-promozione-v1.0.0]] (the promotion to the first
stable release, which set the post-1.0 regime this deliverable's bump is judged
against).
