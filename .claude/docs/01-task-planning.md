# 01 — Task planning & ripresa resiliente

Protocollo PERMANENTE per eseguire prompt onerosi in modo resiliente alle
interruzioni (limiti di utilizzo, crash, stop volontari). Obiettivo: non perdere
MAI più di un singolo task di lavoro, e riprendere senza ricostruire nulla a mano.

## Principio

Un prompt non si esegue "tutto d'un fiato" sperando di arrivare in fondo. Si
valuta, e se è oneroso si trasforma in un PIANO a task piccoli e atomici, ognuno
dei quali termina con un commit. Il commit per-task è il checkpoint: se la sessione
muore al task N, i task 1..N-1 sono salvi su branch e si riprende dal task N.
Niente si butta tranne il mezzo-task interrotto.

## FASE 1 — Valutazione (sempre, prima di scrivere codice)

All'avvio di OGNI prompt, prima di toccare file, stima l'onerosità:
- Quanti file/moduli/unità/test produrrà (ordine di grandezza).
- Se supera grossomodo ~8-10 file o ~400 righe complessive, o tocca più layer
  (es. logica + persistenza + interfaccia + test), è ONEROSO → vai a FASE 2.
- Se è piccolo e autoconsistente (un fix, un endpoint, una config) → eseguilo
  direttamente con un solo commit finale, senza piano. Non burocratizzare i task
  piccoli: il piano è uno strumento, non un rito.

Questa valutazione la fai TU in autonomia, senza chiedere all'utente.

## FASE 2 — Generazione del piano

Crea `.claude/memory/plans/<id-prompt>.md` (es. `plans/03-modulo-x.md`) con questo
formato (frontmatter + checklist):

```markdown
---
type: plan
prompt: <id-prompt>
branch: <feature branch dedicato>
created: YYYY-MM-DD
status: in-progress | completed
tags: [plan, <area>]
---
# Piano: <prompt>

## Obiettivo
<1-2 righe: cosa deve esistere a piano completato>

## Task
- [ ] 1. <task atomico, committabile da solo> — commit: —
- [ ] 2. <...> — commit: —
- [ ] 3. <...> — commit: —

## Note di ripresa
<vuoto all'inizio; qui annoti stato/decisioni utili a una sessione futura>

## Collegamenti
[[<componente>]] · [[STATE]]
```

Regole per i task:
- Ogni task deve essere ATOMICO e COMMITTABILE: deve lasciare il progetto in uno
  stato consistente (compila / non peggiore di prima). Esempi buoni, agnostici allo
  stack: "scaffold del modulo + manifest delle dipendenze", "migrazione schema +
  modello dati", "implementa <unità di logica> + test", "endpoint/handler + DTO +
  validazione". Esempio cattivo: "metà della configurazione di sicurezza".
- Ordina per dipendenza: ciò che sta sotto prima di ciò che ci sta sopra.
- 6-12 task è il range sano. Più di ~15 → il prompt andava diviso a monte
  (segnalalo come IMP, vedi `06-self-improvement.md`). Meno di 4 → non era oneroso,
  non serviva il piano.
- Dopo aver scritto il piano, COMMITTALO subito (`chore: plan for <prompt>`) prima
  di iniziare i task: così il piano sopravvive anche a un crash immediato.

## FASE 3 — Esecuzione task-per-task

Per ogni task in ordine:
1. Implementalo (codice commentato + errori gestiti, vedi `02-code-quality.md`).
2. Verifica minima che il task regga (compila / test del task verdi).
3. Commit con messaggio che referenzia il task:
   `<tipo>(<scope>): [task N/T] <descrizione>`
4. Spunta il task nel piano: `- [x] N. ... — commit: <sha>` e committa
   l'aggiornamento del piano insieme o subito dopo (può stare nello stesso commit).
5. Passa al successivo.

NON accorpare più task in un commit: vanifica la granularità della ripresa.

## FASE 4 — Completamento

Quando tutti i task sono spuntati:
- `status: completed` nel frontmatter del piano.
- `/checkpoint` completo (memoria, doc, `STATE.md`: prompt fatto, prossimo).
- Il merge sul branch di integrazione e il push li gestisce l'utente, mai push
  autonomo (vedi `04-git-workflow.md`).

## RIPRESA (inizio di OGNI sessione)

L'hook `SessionStart` inietta `STATE.md`. Inoltre, all'avvio:
1. Controlla se esiste un piano con `status: in-progress` in `.claude/memory/plans/`.
2. Se sì E riguarda il prompt che l'utente ti sta chiedendo (o l'utente dice
   "riprendi"): leggi il piano, fai `git log --oneline` sul branch per confermare
   quali task sono già committati, e RIPRENDI dal primo task non spuntato. NON
   ricominciare i task già fatti. NON ricreare il branch.
3. Prima di riprendere il task interrotto: se il working tree è sporco (codice del
   mezzo-task), scartalo con lo script `reset-task` o manualmente
   (`git restore . && git clean -fd`) — riparti dal task pulito, non da macerie.

## Cleanup di un task interrotto — CHIRURGICO, mai distruttivo

Se una sessione muore a metà di un task:
- Si scarta SOLO il lavoro NON committato (il mezzo-task): `git restore .`,
  `git restore --staged .`, `git clean -fd`.
- NON si elimina il branch. NON si toccano i commit dei task precedenti.
- Lo script `scripts/reset-task.sh` fa esattamente questo, con guardia di sicurezza
  (rifiuta di operare sui branch condivisi).
- Poi si rilancia il prompt: il protocollo di ripresa riparte dal task giusto.
