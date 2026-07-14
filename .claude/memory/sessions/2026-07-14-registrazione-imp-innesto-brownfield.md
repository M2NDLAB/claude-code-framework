---
date: 2026-07-14
task: registrazione IMP-027..030 dalle lezioni del primo innesto reale (brownfield)
branch: chore/imp-innesto-brownfield
status: completed
tags: [session, improvement, brownfield]
---
# Session 2026-07-14 — Registrazione IMP dal primo innesto brownfield

## Contesto
Primo innesto reale del framework su un progetto esistente (brew-manager, tool
shell/zsh, brownfield): l'attrito è stato documentato in presa diretta nella nota
d'innesto del progetto ospite. Questa sessione REGISTRA le lezioni come IMP
(regola 6 di CLAUDE.md: i cambi a regole/doc si propongono, si applicano solo
dopo approvazione). Nessun file di regole/doc/script toccato: solo LEARNINGS.md
e questa nota.

## Fatto
- Verificate le 10 frizioni della nota d'innesto contro i file REALI del
  framework (docs/02: mai agire sulla sola memoria) — verifica multi-agente
  read-only, un verificatore per frizione con evidenze file:riga; le 2 verifiche
  morte per session-limit (F6 ".claude/ preesistente" e lo sweep) rifatte a mano
  con grep. Esito: TUTTE confermate; nessuna già coperta per intero da regole
  esistenti.
- Registrate 4 IMP APERTE in [[LEARNINGS]] (raggruppamento, non 1:1 con le
  frizioni): IMP-027 percorso di setup brownfield (collisioni file, assessment
  che popola la memoria, criterio CASO A/B per `.claude/` preesistente,
  divergenze doc-vs-realtà dell'ospite; opzione `graft.sh` presentata coi due
  lati, NON decisa); IMP-028 igiene git ereditata (tag lightweight, gitleaks
  detect one-off sulla storia, topologia branch dormiente, hook preesistenti);
  IMP-029 convivenza linguistica (a sé: vale anche greenfield); IMP-030
  compilazione dei [DA DEFINIRE AL SETUP] assistita da Code (a sé: non
  brownfield).
- Agganci alle regole esistenti dichiarati invece di duplicare: IMP-011
  (pattern assessment→proposta→decisione, da promuovere a passo del setup),
  IMP-008 (ruoli branch parametrici: la meccanica c'è, manca la guida alla
  scelta), baseline gitleaks di docs/03 (il detect one-off ne è il
  completamento, non una regola nuova), IMP-010 (igiene dei tag creati ≠ tag
  ereditati).

## Scoperte non ovvie della verifica (oltre la nota d'innesto)
1. `/integrate` su tag lightweight NON si rompe: usa `git describe --tags`, che
   li accetta in silenzio (il razionale "annotati perché git describe li usa" di
   docs/04 vale per `git describe` SENZA `--tags`). La degradazione è silenziosa,
   peggio di un errore.
2. docs/06 LIVELLO 1 letto alla lettera prescrive l'OPPOSTO del comportamento
   giusto all'innesto: "allinea la doc alla realtà... applica direttamente" non
   distingue la doc del METODO dalla doc dell'OSPITE (che va registrata come
   debito, non corretta d'ufficio).
3. Hook + husky: con `core.hooksPath` attivo gli hook del framework finirebbero
   in `.git/hooks` che git ignora — installati ma inerti. E il commento di
   hooks-install.sh r.6 promette meno di ciò che lo script fa (sovrascrive
   QUALSIASI hook, non solo i propri).

## Problemi incontrati → causa → soluzione
1. Workflow di verifica fallito al primo lancio → gli `args` non arrivavano
   allo script (`args.frictions` undefined) → frizioni incorporate nello script
   e rilancio.
2. Due verifiche su 11 morte a metà → session-limit dell'harness → completate a
   mano con grep al reset (i 9 risultati arrivati restavano validi).

## Proposte
- IMP-027, IMP-028, IMP-029, IMP-030 in [[LEARNINGS]] — APERTE, in attesa di
  decisione utente.

## Follow-up
- Decisioni utente sulle 4 IMP → solo dopo, applicazione (un commit per IMP,
  secondo docs/06).
- Merge di questo branch in `main`: azione umana via blocco `/integrate`
  (nessun tag: solo memoria → "nessun bump").

## APPLICAZIONE (stessa data, dopo le decisioni utente)
Decisioni: APPROVATE 027 (senza `graft.sh` → Rimandate col trigger "dopo 2-3
innesti reali"), 028 (i due punti seri b/d in commit curati separati), 029, 030.
Vincolo su 028(a): correzione del razionale di docs/04 DESCRITTIVA, nessun
obbligo nuovo. Guardia di completezza pre-applicazione (S1-S3) superata con una
integrazione: la correzione del razionale docs/04 esplicitata nella proposta (a)
di IMP-028 prima di applicare.

Commit di applicazione (il piano "un commit per IMP" del Follow-up sopra è stato
raffinato dalle decisioni: 028 in tre commit + un fix da review):
- 051d02c `docs(security)` IMP-028b — gitleaks detect one-off (docs/03 + SETUP p.3)
- 1103ffb `fix(scripts)` IMP-028d — guardie hook preesistenti + core.hooksPath
- ff3c2bc `feat(setup)` IMP-027 — sezione brownfield + docs/06 perimetro L1 +
  STATE template + rimando README
- 4cd4363 `fix(git)` IMP-028a/c — guardia base SemVer in /integrate + razionale
  docs/04 + checklist igiene git ereditata
- acdefcb `docs(setup)` IMP-029 — lingua/e del progetto
- 42bc00a `docs(setup)` IMP-030 — [DA DEFINIRE] a mano o in dialogo
- c623b82 `fix(scripts)` review 028d — personalizzazioni salvate in .bak,
  symlink mai attraversati, hint hooksPath a scope corretto
- 7fc8b8e `docs(setup)` rifiniture review — forward-pointer p.1, checkbox
  integrate.md al p.2, marcatore ricompattato (fix L1), confine temporale del
  perimetro L1
- 0662cec `chore(claude)` marcatura: 027..030 → Applicate, graft.sh → Rimandate

## Review adversariale post-apply (autore ≠ giudice)
Sei lenti indipendenti con mandato di refutare (rimandi/orfani, greenfield
intatto, docs/06 integro, agnosticità, script, memoria). 9 finding, 0 blocker;
i fondati applicati nei due commit di review sopra. I due più seri, entrambi
dimostrati empiricamente dai revisori su repo usa-e-getta:
1. il rilancio di hooks-install distruggeva le personalizzazioni del blocco
   formattazione che lo script stesso chiede di fare (il marcatore le
   qualificava come "proprie") → rigenerazione via .new + confronto + .bak;
2. FORCE_OVERWRITE su un hook-symlink scriveva ATTRAVERSO il link corrompendo
   il file dell'ospite fuori da .git/hooks → symlink sempre trattati come
   estranei, backup e rimozione del link prima della scrittura.
Lente agnosticità: zero finding (nessun nome di progetto nei testi del
framework né nei messaggi di commit).

## Problemi incontrati → causa → soluzione (applicazione)
1. Comando di test negato dai permessi → conteneva `rm -rf` (deny attiva,
   correttamente) → rieseguito con `mktemp -d` e directory usa-e-getta nuove.
2. Rimando "passo 2" per integrate.md non risolvibile → il marcatore
   [DA DEFINIRE AL SETUP] di integrate.md era spezzato su due righe, invisibile
   al grep dichiarato dal passo 2 (bug preesistente, scoperto dalla review) →
   ricompattato + checkbox dedicata al passo 2 (7fc8b8e).

## Checkpoint (regime ibrido dichiarato)
STATE/TREE/INDEX restano template puliti: la modifica a STATE.md di ff3c2bc è
al TEMPLATE (definizione di "Debito documentazione"), non un popolamento.
Nessun componente in components/ (repo del metodo). Struttura invariata →
TREE.md non rigenerato. CHANGELOG: [Unreleased] si compila dentro /integrate.
