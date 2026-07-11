---
date: 2026-07-11
task: consolidamento del framework — assessment (FASE 1) + registrazione IMP-009..026 (FASE 2)
branch: feat/consolidamento
status: in-progress
tags: [session, consolidamento, assessment]
---
# Session 2026-07-11 — Consolidamento: assessment e registrazione IMP

## Contesto
Prompt di consolidamento in tre fasi: (1) assessment in sola lettura dell'intero
framework; (2) registrazione delle proposte come IMP in [[LEARNINGS]], SENZA
applicarle; (3) applicazione delle sole IMP approvate dall'utente. Questa nota
persiste l'assessment della FASE 1 così la FASE 3 può PUNTARE qui senza rifare
il lavoro (una sessione futura riparte da questa nota + le IMP approvate).

## Fatto
- Letti TUTTI i file del repo (31 file tracciati): CLAUDE.md, docs/00..06, i 7
  comandi, memoria (STATE/TREE/INDEX/LEARNINGS + 4 README), scripts/*,
  settings.json, commitlint.config.cjs, Makefile, SETUP.md, README.md, .gitignore.
- Verificata l'ASSENZA di: LICENSE, SECURITY.md, CONTRIBUTING.md,
  CODE_OF_CONDUCT.md, CHANGELOG.md, `.github/`, `.claude/skills/`.
- Stato git reale al momento dell'assessment: `main` = `origin/main` = tag
  annotato `v0.1.0` su `6a1fe9e` (merge commit a due parent); `git describe
  --tags --long` = `v0.1.0-0-g6a1fe9e`; esiste un residuo `origin/master` stantio
  (→ `3b4f6d8`, pre-template); hook git locali NON installati in questo repo.
- Registrate le IMP-009..026 in [[LEARNINGS]] (12 meccaniche + 6 con decisione
  utente). Creato il branch `feat/consolidamento`; commit della sola
  registrazione (registrare ≠ applicare).

## Assessment — INPUT 1 (22 convenzioni): sintesi della mappatura
- PRESENTI in sostanza: A7 (un task = un commit, docs/01 FASE 3).
- PRESENTI IN FORMA PARZIALE/DIVERSA → colmate dalle IMP indicate:
  A1 confine di esecuzione (implicito in docs/04 + /integrate, mai dichiarato) → IMP-009;
  A2 valori reali nei blocchi utente (solo dentro /integrate) → IMP-009;
  A4 igiene tag ASCII (parziale in /integrate §4; manca rev-parse/tag -d condizionato) → IMP-010;
  A5 verifica pre-push (git log origin/.. usato solo per il bump) → IMP-010;
  B6 fasi a monte (decisions/README dice DOVE, nessun doc dice QUANDO) → IMP-011;
  C10 prompt-che-puntano (meccanica presente in plans/, principio non scritto) → IMP-013;
  C13 trigger sui debiti (esiste solo per le IMP Rimandate, non per STATE) → IMP-014;
  D20 placeholder esecutore≠utente (implicito in /integrate) → IMP-009.
- ASSENTI → IMP: A3 distruttivi isolati (IMP-009); B8 scope discipline e B9 igiene
  /clear (IMP-012); C11-C12 persistenza prima di /clear/cambio modello (IMP-013);
  C14 sopravvivenza dei debiti alle riscritture di STATE (IMP-014); D15-D17
  verifica su artefatti reali, RED→GREEN, invarianti (IMP-015); D18-D19 review
  adversariale per raggio di propagazione, completezza finding (IMP-016); E21
  modello per task (IMP-017); E22 ripresa senza turni a vuoto (IMP-013).

## Assessment — INPUT 2 (riverifica sui file reali)
- `/lint-memory` senza trigger dichiarato: CONFERMATO (00-overview e
  lint-memory.md non dicono QUANDO eseguirlo) → IMP-018.
- Legenda TREE.md 5/7 comandi: CONFERMATO (riga 35: mancano /integrate e
  /lint-memory) → IMP-018 (fix Livello 1 tracciata lì).
- Dogfooding: CONFERMATO e più ampio del previsto — LEARNINGS reale ma
  STATE/TREE/INDEX template, sessions/ vuota nonostante ~14 commit reali, chi
  copia eredita le IMP del framework, hook git non installati nel repo → IMP-024
  (APERTA con 3 opzioni, consigliata "ibrido dichiarato").
- `/new-component` inerte: CONFERMATO in forma attenuata (SETUP.md §2 ha già la
  checklist; manca solo l'avviso di inerzia) → IMP-018.
- Storia git "lineare senza merge": SMENTITO in parte — esiste il merge a due
  parent `6a1fe9e`; restano: merge locale senza PR (tensione con docs/04 →
  IMP-019), modello di branching MAI dichiarato, messaggio del merge non a
  formato + nome specifico "VORTEX" nella storia condivisa (non riscrivibile,
  evitabile in futuro), residuo `origin/master` → IMP-025 (APERTA).

## Assessment — trovato OLTRE gli input (FASE 1.4)
- CONTRADDIZIONE INTERNA: docs/04 "Merge: SEMPRE via PR, mai merge locale
  diretto" vs blocco merge LOCALE stampato da /integrate → IMP-019.
- Hook PreToolUse gitleaks in settings.json è DECORATIVO: l'`||` inghiotte anche
  il leak trovato, exit sempre 0 (mai blocco), bersaglio --staged sbagliato al
  momento di Write/Edit → IMP-020.
- Nessuna tensione tra le convenzioni INPUT 1 e le regole esistenti, con due
  note di coerenza: B9 (doc scollegata su branch separato) NON confligge con la
  regola 5 di CLAUDE.md (che riguarda la doc COLLEGATA al cambiamento); E21 va
  scritta tool-agnostica per non invecchiare (recepito in IMP-017).

## Assessment — INPUT 3/4 (file di progetto e Skill)
- Tutti i file di progetto sono ASSENTI. Classificazione due-livelli: LICENSE =
  reale sul repo + placeholder nel template (IMP-021, decisione); SECURITY =
  scaffold a placeholder utile a entrambi i livelli, CONTRIBUTING e CHANGELOG =
  livello repo-framework con contenuto reale (IMP-022, decisione); CoC e
  .github/ = rimandare con trigger, filtro anti-hype (IMP-023, decisione).
- Skill: `.claude/skills/` non esiste; valutazione scettica = NON giustificate
  ora (nessun attrito osservato; i comandi + caricamento selettivo coprono la
  funzione); rimandare con trigger esplicito (IMP-026, decisione; interpretazione
  del mandato dichiarata e da confermare).

## Lint concettuale della memoria (FASE 1.6)
- Wikilink dei file template ([[STATE]], [[TREE]], [[INDEX]], [[LEARNINGS]]):
  tutti risolvibili. Nessun link rotto nei file reali.
- Claim stantio: legenda TREE.md (sopra). Contraddizione di regime: LEARNINGS
  vivo vs resto template (sopra, dogfooding). STATE.md/INDEX.md volutamente non
  toccati in questa sessione: sono template puri e riempirli PRE-giudicherebbe
  la decisione IMP-024.
- README/SETUP coerenti con la struttura reale; ciclo citato in README §"Come si
  usa" allineato a 00-overview.

## Problemi incontrati → causa → soluzione
1. Rischio di pre-giudicare IMP-024 aggiornando STATE/INDEX con dati reali →
   scelto di NON toccarli finché l'utente non decide il regime di dogfooding;
   la memoria di questa sessione vive in questa nota + LEARNINGS.

## Proposte
- IMP-009..026 in [[LEARNINGS]] — 12 meccaniche (009-020) + 6 con decisione
  utente (021-026: licenza, file community, CoC/.github, dogfooding, branching
  del repo, skill).

## Follow-up
- FASE 3 SOLO dopo le decisioni dell'utente sulle IMP: un commit per IMP
  applicata, poi /checkpoint e /integrate (bump atteso: le sole 009-020 sono
  docs/chore → NESSUN tag; se passano IMP-021/022 — nuovi file di progetto
  sostanziali — → MINOR, v0.1.0→v0.2.0).
- La rimozione di `origin/master` (se approvata in IMP-025) è azione UTENTE su
  storia condivisa: blocco separato con verifica preventiva, mai inline.
