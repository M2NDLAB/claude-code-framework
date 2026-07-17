---
date: 2026-07-17
task: deliverable /harvest-framework + ponte progetto→framework (comando + marcatura + doc del ponte)
branch: feat/commands-harvest-framework
status: completed
tags: [session, improvement, harvest, ponte]
---
# Session 2026-07-17 — `/harvest-framework` + ponte progetto→framework

## Contesto
Nuovo deliverable, scollegato dal precedente (v0.3.0). Nasce da attrito reale: le lezioni
che riguardano il FRAMEWORK ma emergono lavorando su un progetto-CLIENTE si travasavano a
mano, senza procedura né marcatura. Deliverable con SCELTE STRUTTURALI → seguito il pattern
docs/01 FASE 2: assessment read-only → proposta con alternative → decisione utente → esecuzione.
Registrato come [[LEARNINGS]] IMP-033.

## Fatto
- **Assessment read-only** (workflow multi-agente, 5 lettori paralleli + gap-check
  adversariale): struttura note di sessione, convenzione di marcatura, comandi-modello, IMP
  rilevanti (009/021/026/027-032), boundary cross-repo, topologia memoria e adozione lato
  progetto. Fonte delle 4 decisioni.
- **4 decisioni strutturali dell'utente**: (1) meccanismo = COMANDO in `.claude/commands/`
  (non Skill → non riapre IMP-026); (2) marcatura = attributo `Destinazione: framework` sulla
  voce IMP (riga singola grep-abile); (3) perimetro = intero backlog `LEARNINGS.md`,
  restringibile con `$ARGUMENTS`; (4) confine = solo-leggi-e-stampa, confermato.
- **6 task, un commit ciascuno** `[task N/T]`: IMP-033 registrata (c66acae) → attributo nel
  formato IMP (d2856be) → sottosezione "Il ponte verso il framework" in docs/06 (c0df16c) →
  comando `harvest-framework.md` (f50816f) → registrazione in CLAUDE.md/README + cross-link
  SETUP §5/CONTRIBUTING/README Filosofia (534b41d) → questo checkpoint.
- **Comando dimostrato su fixture** (nel repo-framework è moot): grep seleziona solo l'IMP
  marcata, ignora quelle di progetto; caso senza marcatore → anti-vacuità (0 match, nessun
  blocco vuoto).

## Problemi incontrati → causa → soluzione
- **Premessa del prompt errata**: l'utente riteneva che le lezioni-framework fossero già
  marcate come testo libero ("materiale per il FRAMEWORK") nelle note. → CAUSA: la marcatura
  non è mai esistita (grep sui 4 termini candidati = 0 occorrenze; verifica su artefatti reali,
  docs/02). → SOLUZIONE: dichiarata la correzione nell'assessment; la marcatura è diventata
  parte del deliverable (progettata da zero come attributo IMP).
- **Dove vive il "piano" (docs/01 vs regime ibrido)**: docs/01 impone un file in `plans/`,
  ma IMP-024 tiene `plans/` template-pulito nel repo-framework. → CAUSA: docs/01 non prevede
  il deliverable oneroso sul repo-framework. → SOLUZIONE (decisa con l'utente): IMP-024
  (specifica sul repo-framework) prevale su docs/01 (generale) nel suo ambito; il piano vive
  come IMP-033 + questa nota + commit `[task N/T]`, stessi checkpoint di ripresa. Buco di
  processo registrato come IMP-034 (da valutare a freddo, non risolto qui).

## Correzioni fattuali doc (Livello 1, docs/06)
- Nessuna: il deliverable AGGIUNGE convenzioni/doc, non corregge doc in disaccordo con la realtà.

## Proposte
- IMP-033 (in [[LEARNINGS]]): comando `/harvest-framework` + attributo `Destinazione: framework`
  + ponte in docs/06 — **APPLICATA** in questo deliverable.
- IMP-034 (in [[LEARNINGS]]): docs/01 ↔ regime ibrido su `plans/` per deliverable onerosi sul
  repo-framework — **APERTA** (rimanda, valutare a freddo, come indicato dall'utente).
- IMP-035 (in [[LEARNINGS]]): "skill" sovraccarico (comando / feature Skills IMP-026 / tool
  `Skill` dell'harness) — **APERTA** (impatto basso).

## Nota di processo (non IMP)
- Disambiguazione persistita per la prossima sessione: nel repo un invocabile è un COMANDO
  (file in `.claude/commands/`); la feature Skills (`.claude/skills/`, non adottata) è oggetto
  di IMP-026 (rimandata); l'harness chiama "skill" anche i project command (naming di
  piattaforma). Alla creazione di `harvest-framework.md` l'harness l'ha subito esposto come
  "skill" — conferma dell'overload, tracciato in IMP-035.

## Follow-up
- **`/integrate`**: bump atteso **MINOR** (c'è `feat` — comando + attributo), pre-1.0 → tag
  `v0.4.0` su `main` (regime trunk-based dichiarato, IMP-025). CHANGELOG `[Unreleased]` si
  compila dentro `/integrate`. Merge + tag + push = azione umana.
- Terminata l'anonimizzazione: ricordata dentro il comando stesso (non serve azione qui).

## Collegamenti
[[LEARNINGS]] · [[2026-07-17-audit-preintegrate-closeout-v0.3.0]]
