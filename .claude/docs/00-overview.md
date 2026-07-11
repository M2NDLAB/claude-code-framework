# 00 — Overview: il metodo

Questa cartella `.claude/docs/` non descrive un dominio applicativo: descrive il
**metodo di lavoro** con cui Claude Code collabora a questo progetto. È il cuore
del framework — agnostico allo stack — e vale in ogni sessione, qualunque cosa il
progetto costruisca.

## I due pilastri

1. **Memoria persistente** (`.claude/memory/`) — Claude Code non ha memoria tra le
   sessioni: gliela diamo noi, come file. `STATE.md` (il presente), `TREE.md` (la
   mappa), `INDEX.md` (la rotta), più le note in `sessions/`, `components/`,
   `decisions/`, `plans/`. La memoria si legge a inizio sessione e si aggiorna a
   fine task. *Un task senza memoria aggiornata non è finito.*
2. **Doc di processo** (`.claude/docs/`) — le regole permanenti di COME si lavora:
   pianificare, scrivere codice di qualità, fare la review di sicurezza, usare git,
   sbloccarsi quando ci si blocca, migliorare il metodo stesso.

## Caricamento selettivo

Carica **solo i file rilevanti per il task in corso**, non tutto in blocco: è una
scelta di token-efficiency. `CLAUDE.md` è l'indice; da lì si tira dentro ciò che
serve. La stessa logica vale per la memoria: si caricano le note dei soli
componenti toccati dal task.

## Il ciclo di lavoro

```
  INIZIO SESSIONE                              FINE DELIVERABLE
        │                                             │
  leggi STATE.md ─▶ valuta onerosità ─▶ esegui ───────┤
  (hook SessionStart)  (oneroso? → PIANO)   (per task) │
        │                                             ▼
        │   CICLO DI FINE DELIVERABLE (in ordine):
        │     1. /security-review — solo se sensibile (gate)
        │     2. /retro           — rifletti, registra IMP
        │     3. /checkpoint      — allinea memoria/doc al reale
        │     4. /integrate       — blocco merge+tag, push = umano
        │
        └─ bloccato? (2 tentativi / bivio) ─▶ ESCALATION REPORT, poi fermati
```

1. **Pianifica** se il prompt è oneroso → `01-task-planning.md`. Niente burocrazia
   per i task piccoli. Se il deliverable comporta SCELTE STRUTTURALI, il piano è
   preceduto da: assessment in sola lettura → proposta con alternative → decisione
   dell'utente → registrazione in `decisions/` (o ADR) → il piano PUNTA alla
   decisione registrata invece di ridiscuterla.
2. **Esegui** rispettando la qualità → `02-code-quality.md`. Ogni task lascia il
   progetto in uno stato consistente e termina con un commit.
3. **Proteggi** i componenti sensibili con il gate di sicurezza → `03-security-gate.md`.
4. **Versiona** con disciplina → `04-git-workflow.md`. Commit ai checkpoint logici;
   push solo su conferma umana.
5. **Sbloccati** senza insistere alla cieca → `05-escalation-protocol.md`.
6. **Migliora il metodo** con le lezioni raccolte → `06-self-improvement.md`. Le
   correzioni fattuali si applicano; i cambi di regole si PROPONGONO soltanto.

## Il ciclo di fine deliverable (sequenza-tipo)

Un *deliverable* (un'unità onerosa completa: una feature, un componente, un blocco di
lavoro) si chiude SEMPRE con questa sequenza ordinata. I mattoni esistono già nei doc;
qui è fissato il loro ORDINE, così non se ne dimentica nessuno. Per i task piccoli e
isolati non serve il rito completo (vedi `01-task-planning.md`): bastano la Definition
of Done e il commit.

1. **Costruzione** — esecuzione per task atomici, ognuno con la sua Definition of Done
   verde (`01-task-planning.md`, `02-code-quality.md`). È la precondizione di tutto il
   resto: il deliverable compila e i test passano. Se ti blocchi qui, esci con
   l'escalation (`/sos`, `05-escalation-protocol.md`): non è un passo della sequenza,
   è la via d'uscita.
2. **`/security-review` — CONDIZIONALE: solo se il deliverable è sensibile.** Sensibile
   = auth/authz, pagamenti/denaro, dati personali, edge di enforcement, superfici che
   agiscono per conto di un client (`03-security-gate.md`; l'elenco concreto è
   `[DA DEFINIRE AL SETUP]`). Se sensibile è un GATE: i finding HIGH/CRITICAL si
   risolvono PRIMA di proseguire. Se non sensibile, si salta.
3. **`/retro` — riflessione di fine deliverable (FISSO).** C'è stato attrito? una
   regola/doc che avrebbe aiutato? → registra le proposte come IMP in `LEARNINGS.md`
   (`06-self-improvement.md`). È leggera: senza attrito, è un no-op di pochi secondi.
   Le DECISIONI sulle IMP accumulate si prendono nella retrospettiva periodica (sempre
   `/retro`, ma sull'intero backlog). Va PRIMA del checkpoint, così le IMP appena
   registrate vengono persistite dal commit successivo.
4. **`/checkpoint` — allinea memoria e doc allo stato reale (FISSO).** Nota di
   sessione, `STATE.md`, `TREE.md`, `INDEX.md`, riconciliazione branch/merge, commit
   (`04-git-workflow.md`). NON pusha.
5. **`/integrate` — blocco merge + tag pronto da incollare (FISSO).** Calcola bump e
   prossima versione (`04-git-workflow.md`, *Versioning*) ed emette i comandi. Push,
   merge e tag li esegue l'UMANO: è l'unico passo che esce dal controllo dell'agente.

> In breve: passi FISSI 1·3·4·5; passo CONDIZIONALE 2 (`/security-review`, solo se
> sensibile). L'ordine non è arbitrario — `/retro` prima di `/checkpoint` perché il
> checkpoint persista le IMP appena registrate; `/integrate` per ultimo perché è
> l'unico che tocca lo stato condiviso, e solo dopo che memoria e doc sono allineate.

## Principi di processo (in ordine di priorità)

1. **Sicurezza per default** — nessun secret in chiaro (hook gitleaks), least
   privilege, review obbligatoria sui componenti sensibili.
2. **Resilienza** — il lavoro è frazionato in unità committabili: un'interruzione
   non costa mai più di un singolo task.
3. **Tracciabilità** — ogni decisione non ovvia è scritta (memoria, decisioni); lo
   stato è sempre ricostruibile da `STATE.md`.
4. **Controllo umano** — Claude Code propone, l'umano dispone su ciò che è
   irreversibile o che cambia le regole: push, operazioni distruttive, modifica
   delle proprie regole.
5. **Auto-miglioramento** — il metodo non è congelato: migliora con l'uso, ma in
   modo controllato e mai in autonomia silenziosa.

> Le scelte tecnologiche del progetto (linguaggio, framework, build, datastore,
> test) NON stanno qui: stanno in `CLAUDE.md`, sezione *"Regole tecniche specifiche
> del progetto"*, e nei punti marcati `[DA DEFINIRE AL SETUP]`.
