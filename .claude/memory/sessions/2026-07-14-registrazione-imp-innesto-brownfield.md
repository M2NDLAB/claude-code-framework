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
