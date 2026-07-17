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

**Prima del piano, se ci sono scelte strutturali.** Se il prompt comporta decisioni
costose da invertire (architettura, contratti tra moduli, scelta di un approccio),
il piano NON è il primo artefatto: prima un assessment in SOLA LETTURA dello stato
reale, poi la proposta con le alternative e i trade-off, poi la DECISIONE
dell'utente, registrata in `decisions/` (o come ADR — vedi il README di
`decisions/`). Solo allora il piano, che PUNTA alla decisione registrata invece di
ridiscuterla a ogni task. Per i prompt onerosi ma senza bivi strutturali si va
direttamente al piano.

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

> **Regime ibrido del repo-framework (IMP-024/IMP-034).** Nel repo del *framework*
> stesso — dove `plans/`, `decisions/`, `STATE`/`TREE`/`INDEX` restano TEMPLATE PULITI
> (vivi solo `LEARNINGS.md` e `sessions/`; vedi `CONTRIBUTING.md`) — un deliverable
> oneroso NON crea un file in `plans/` e non registra la decisione strutturale in
> `decisions/`: sporcherebbe il template. Il "piano" e l'assessment vivono altrove, con
> gli STESSI checkpoint di ripresa:
> - COSA/PERCHÉ (piano + decisione) → una voce in `LEARNINGS.md` (IMP-nnn) e/o la nota
>   di sessione;
> - FASI e contesto di ripresa → la nota di sessione, in un **blocco-piano
>   standardizzato** (`## Piano (un commit per task)` con checklist + sha — vedi
>   `sessions/README.md`): la nota è insieme plan-pointer e diario;
> - GRANULARITÀ di ripresa → i commit `[task N/T]` (FASE 3, invariata);
> - COMPLETAMENTO (FASE 4) → `status: completed` nel frontmatter della NOTA di sessione,
>   non di un file di piano.
>
> È la regola SPECIFICA (IMP-024, il regime ibrido) che prevale sulla generale (`plans/`)
> nel suo SOLO ambito dichiarato; nei progetti-CLIENTE (memoria piena) `plans/` e
> `decisions/` restano pienamente validi.

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

## Caso speciale — refactor cross-modulo (codice condiviso)

Estrarre o spostare codice usato da più moduli (una utility comune, un tipo
condiviso, una libreria interna) è un refactor a rischio sproporzionato: un singolo
modulo "verde" non dice nulla sugli altri consumatori. Trattalo come un prompt
oneroso (FASE 2 → piano), e applica in più questa disciplina:

- **Branch dedicato, task atomici per consumatore.** Un passo = un'estrazione
  coerente e committabile: "introduci il modulo condiviso", poi "migra il consumatore
  A", poi "migra il consumatore B". Mai "sposta tutto" in un unico task.
- **Test di TUTTI i moduli toccati verdi a OGNI passo** — non solo del modulo in cui
  stai lavorando, e non solo alla fine. Dopo ogni task ri-esegui le suite di ogni
  modulo che consuma il codice spostato: una regressione introdotta al passo 2 si
  scopre al passo 2, non tre task dopo, quando la causa è già sepolta.
- **Commit di sicurezza prima di iniziare** (docs/04, "QUANDO committare"): il
  refactor ampio parte da un punto di ripristino pulito.
- **Review di coerenza prima del merge.** Oltre alla Definition of Done (docs/02) e
  — se tocca componenti sensibili — al gate di sicurezza (docs/03), verifica che
  l'estrazione sia coerente ovunque: nessun consumatore rimasto sulla vecchia copia,
  nessuna duplicazione residua, l'API condivisa usata allo stesso modo dappertutto.

> Il "wiring" tra moduli è esattamente ciò che gli unit isolati non vedono: per un
> refactor cross-modulo lo smoke del sistema cablato (DoD, docs/02 punto 3) conta
> ancora di più.

## RIPRESA (inizio di OGNI sessione)

L'hook `SessionStart` inietta `STATE.md`. Inoltre, all'avvio:
1. Controlla se esiste un piano con `status: in-progress` in `.claude/memory/plans/`.
   (Nel regime ibrido del repo-framework, dove `plans/` resta vuoto, il piano
   in-progress vive nel **blocco-piano della nota di sessione** più recente — vedi il
   riquadro in FASE 2: controllalo lì, o concluderesti a torto "niente in corso".)
2. Se sì E riguarda il prompt che l'utente ti sta chiedendo (o l'utente dice
   "riprendi"): leggi il piano, fai `git log --oneline` sul branch per confermare
   quali task sono già committati, e RIPRENDI dal primo task non spuntato. NON
   ricominciare i task già fatti. NON ricreare il branch.
3. Prima di riprendere il task interrotto: se il working tree è sporco (codice del
   mezzo-task), scartalo con lo script `reset-task` o manualmente
   (`git restore . && git clean -fd`) — riparti dal task pulito, non da macerie.
4. Un prompt di ripresa ben fatto dà il COMPITO direttamente ("riprendi dal primo
   task non spuntato del piano X") e PUNTA a piano e note di sessione per il
   contesto: non deve produrre un turno a vuoto ("attendo istruzioni") né
   ricostruire in chat ciò che è già su disco.

## Cleanup di un task interrotto — CHIRURGICO, mai distruttivo

Se una sessione muore a metà di un task:
- Si scarta SOLO il lavoro NON committato (il mezzo-task): `git restore .`,
  `git restore --staged .`, `git clean -fd`.
- NON si elimina il branch. NON si toccano i commit dei task precedenti.
- Lo script `scripts/reset-task.sh` fa esattamente questo, con guardia di sicurezza
  (rifiuta di operare sui branch condivisi).
- Poi si rilancia il prompt: il protocollo di ripresa riparte dal task giusto.
