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
  inizio sessione                              fine task
        │                                          │
   leggi STATE.md ──▶ valuta l'onerosità ──▶ esegui ──▶ /checkpoint
   (iniettato         (oneroso? → PIANO a    task per   (memoria + doc
    dall'hook)         task atomici, 1        task,       + commit)
        │              commit ciascuno)       commit      │
        │                                                 ▼
        └──────────────── bloccato? ──▶ ESCALATION ──▶ retro / IMP
                          (2 tentativi    REPORT,        (lezioni di
                           o bivio)       poi fermati    processo →
                                                          proposte)
```

1. **Pianifica** se il prompt è oneroso → `01-task-planning.md`. Niente burocrazia
   per i task piccoli.
2. **Esegui** rispettando la qualità → `02-code-quality.md`. Ogni task lascia il
   progetto in uno stato consistente e termina con un commit.
3. **Proteggi** i componenti sensibili con il gate di sicurezza → `03-security-gate.md`.
4. **Versiona** con disciplina → `04-git-workflow.md`. Commit ai checkpoint logici;
   push solo su conferma umana.
5. **Sbloccati** senza insistere alla cieca → `05-escalation-protocol.md`.
6. **Migliora il metodo** con le lezioni raccolte → `06-self-improvement.md`. Le
   correzioni fattuali si applicano; i cambi di regole si PROPONGONO soltanto.

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
