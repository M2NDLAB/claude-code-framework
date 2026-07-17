# [NOME PROGETTO] — Claude Code Index

Stack: [DA DEFINIRE AL SETUP] | Repo: [DA DEFINIRE AL SETUP]

> Questo file è l'**indice** che Claude Code legge per orientarsi: rimanda ai doc di
> processo, alla memoria persistente e fissa le regole non negoziabili. Le regole
> qui sotto sono di PROCESSO (agnostiche allo stack); le regole tecniche del
> progetto vanno nell'ultima sezione.

## Documentazione di processo — carica SOLO i file rilevanti per il task
- @.claude/docs/00-overview.md            — il metodo, il ciclo di fine deliverable, caricamento doc
- @.claude/docs/01-task-planning.md       — piano a task per prompt onerosi, ripresa resiliente
- @.claude/docs/02-code-quality.md        — commenti, error handling, Definition of Done
- @.claude/docs/03-security-gate.md       — review obbligatoria sui componenti sensibili
- @.claude/docs/04-git-workflow.md        — quando committare, branch, merge, rollback
- @.claude/docs/05-escalation-protocol.md — report strutturato quando ti blocchi
- @.claude/docs/06-self-improvement.md    — correzioni doc, backlog IMP, retrospettiva

## Memoria persistente — OBBLIGATORIA in ogni sessione
- A INIZIO sessione: leggi @.claude/memory/STATE.md (iniettato dall'hook SessionStart)
  e le note .claude/memory/components/ dei soli componenti toccati dal task; TREE.md
  prima di esplorare il filesystem a mano. Controlla se esiste un piano in-progress in
  .claude/memory/plans/ per il prompt richiesto (vedi regola 7).
- A FINE task: nota di sessione in memory/sessions/, aggiorna components/ toccati,
  riscrivi STATE.md, rigenera TREE.md se la struttura è cambiata.
  **Un task senza memoria aggiornata NON è finito.**
- Usa lo slash command /checkpoint per memoria + doc + commit insieme.

## Regole globali NON negoziabili (processo)
1. **Nessun secret in chiaro** nel codice o nei config committati — solo secret
   manager o variabili d'ambiente. L'hook gitleaks blocca i commit che violano questa
   regola (è la baseline; vedi anche il gate di sicurezza, regola 8).
2. **Code quality** secondo 02-code-quality.md: il PERCHÉ nei commenti, nessuna
   eccezione inghiottita, validazione al bordo, Definition of Done rispettata.
3. **Git** secondo 04-git-workflow.md: branch per ogni feature, commit ai checkpoint
   logici e PRIMA di cambi rischiosi, Conventional Commits, mai push senza conferma
   dell'utente.
4. **Escalation** secondo 05-escalation-protocol.md: bloccato dopo 2 tentativi
   ragionati, o davanti a un bivio non coperto dai doc/decisioni? NON insistere alla
   cieca: genera un ESCALATION REPORT e fermati. La risposta torna come blocco
   ARCHITECT RESPONSE — eseguila secondo il protocollo.
5. **Documentazione aggiornata** INSIEME alle modifiche: una modifica che tocca
   funzionalità utente, procedure, API o deploy non è finita finché la doc non è
   allineata (dove vive la doc di progetto: [DA DEFINIRE AL SETUP]). Stessa logica
   della memoria. Finché la doc di progetto non esiste, annota il debito in STATE.md.
6. **Auto-miglioramento** secondo 06-self-improvement.md: le correzioni FATTUALI alla
   doc (in disaccordo dimostrabile con la realtà) le applichi subito; i cambi di
   REGOLE e processo li PROPONI in memory/LEARNINGS.md (IMP-nnn) e li applichi solo
   dopo approvazione dell'utente. **Mai riscrivere le proprie regole in autonomia.**
7. **Task planning** secondo 01-task-planning.md: all'avvio di OGNI prompt valuta da
   solo l'onerosità; se oneroso, genera un PIANO a task atomici in .claude/memory/plans/,
   committalo, poi esegui UN COMMIT PER TASK (`[task N/T]` nel messaggio) spuntando il
   piano. Se una sessione si interrompe: NON ricominci da zero e NON elimini il branch
   — scarti solo il mezzo-task non committato (scripts/reset-task.sh) e riprendi dal
   primo task non spuntato. I commit dei task completati non si toccano mai.
8. **Security gate** secondo 03-security-gate.md: sui componenti sensibili
   ([DA DEFINIRE AL SETUP]) esegui /security-review PRIMA della PR; finding
   HIGH/CRITICAL risolti, MEDIUM risolti o accettati come debito in STATE.md (col
   motivo), LOW almeno registrati.

## Comandi rapidi
- Slash command: `/checkpoint`, `/integrate`, `/sos`, `/retro`, `/security-review`,
  `/new-component`, `/lint-memory`, `/harvest-framework`
- `make hooks-install` — installa gli hook git (gitleaks + commitlint)
- `./scripts/reset-task.sh` — scarta il mezzo-task interrotto (preserva i commit)

---

## Regole tecniche specifiche del progetto: [DA DEFINIRE AL SETUP]

> Qui vanno le scelte tecnologiche e le convenzioni che il framework NON impone.
> Compilale al setup del progetto. Esempi di cosa documentare (rimuovi quelli non
> pertinenti, aggiungi i tuoi):
>
> - **Stack**: linguaggio/i, framework, runtime, versioni.
> - **Build & run**: comandi di build, test, lint, avvio locale (anche come target
>   nel Makefile).
> - **Struttura standard di un componente** (per /new-component): layout dei moduli,
>   convenzioni di packaging.
> - **Convenzioni di codice** specifiche del linguaggio (formatter/linter usati dall'
>   hook, naming, idiomi).
> - **API design**: versioning, formato degli errori, paginazione, formati di
>   data/denaro, ecc.
> - **Dati**: datastore usati, convenzioni di naming, gestione delle migrazioni.
> - **Test**: framework, soglie di coverage, cosa richiede un test di integrazione.
> - **Componenti sensibili** soggetti al security gate (regola 8).
> - **Dove vive la documentazione di progetto** (regola 5).
> - **Lingua/e del progetto**: in quale lingua si scrivono memoria e processo
>   (default: la lingua del framework) e in quale la doc pubblica (README, doc
>   utente) — dichiarala qui se le due differiscono.
> - **Deploy**: formato dell'artefatto di produzione, ambiente target.
> - **Licenza del progetto**: quale licenza adotta QUESTO progetto e chi è l'holder
>   del copyright. Il framework non la impone: la sua `LICENSE` (MIT) copre il
>   framework stesso, NON i progetti che lo usano — vedi `SETUP.md`.
