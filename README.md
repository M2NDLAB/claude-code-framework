# Claude Code Framework

Un framework di lavoro riutilizzabile per progetti gestiti con Claude Code,
**agnostico allo stack tecnologico**. Non contiene codice applicativo né scelte
tecnologiche: porta il *metodo* — come strutturare la collaborazione con Claude
Code perché sia resiliente, tracciabile e auto-migliorante.

Estratto da un progetto reale (una piattaforma enterprise) e raffinato attraverso
decine di sessioni, questo framework cattura ciò che funziona indipendentemente
dal dominio: e-commerce, SaaS, data pipeline, qualsiasi cosa.

## Cosa include

- **Sistema di memoria persistente** — STATE, TREE, INDEX, sessioni, decisioni,
piani, backlog di miglioramenti, con un health-check di coerenza (`/lint-memory`).
Claude Code mantiene contesto tra le sessioni.
- **Task-planning resiliente** — i prompt onerosi si spezzano in task atomici con
un commit ciascuno; un'interruzione non costa il rifacimento da zero.
- **Protocollo di escalation** — quando Claude Code si blocca su un bivio, genera
un report strutturato invece di insistere alla cieca.
- **Auto-miglioramento (IMP)** — le lezioni di processo diventano proposte di
miglioramento approvate dall'umano, mai auto-applicate.
- **Security gate & git workflow** — review obbligatoria sui componenti sensibili,
conventional commits, versioning SemVer su tag annotati, blocco "pronto per
integrazione" da incollare, hook pre-commit (secret scan + formattazione).

## Cosa NON include (per scelta)

Nessuna tecnologia specifica. Niente linguaggi, framework, database. Quelli li
aggiunge ogni progetto al setup, nei punti segnalati come `[DA DEFINIRE]`.

## Come si usa

In breve (la guida completa, con l'elenco di tutti i `[DA DEFINIRE AL SETUP]` da
riempire, è in **[SETUP.md](SETUP.md)**):

1. **Copia** il contenuto del framework nella root del tuo nuovo progetto (la
   cartella `.claude/`, più `CLAUDE.md`, `Makefile`, `commitlint.config.cjs`,
   `.gitignore`, `scripts/`).
2. **Riempi i `[DA DEFINIRE AL SETUP]`** — soprattutto in `CLAUDE.md` (nome
   progetto, stack, regole tecniche, componenti sensibili) e nei punti elencati in
   `SETUP.md`.
3. **Installa gli hook**: `make hooks-install` (richiede `gitleaks` e Node.js per
   commitlint). Abilita la formattazione automatica nell'hook per il tuo linguaggio.
4. **Primo comando a Claude Code** — fagli leggere `CLAUDE.md` e i doc in
   `.claude/docs/`, poi inizializzare la memoria (`STATE.md`, `TREE.md`). Il comando
   esatto suggerito è in `SETUP.md`.

Da lì in poi si lavora con il ciclo descritto in `.claude/docs/00-overview.md`:
pianifica → esegui per task → [se sensibile] `/security-review` → `/retro` →
`/checkpoint` → `/integrate` (push deciso dall'umano); se ti blocchi, `/sos`.

### Struttura

```
.
├── CLAUDE.md                  indice + regole di processo + regole tecniche [DA DEFINIRE]
├── README.md                  questo file
├── SETUP.md                   come partire da zero, elenco dei [DA DEFINIRE]
├── Makefile                   solo target di processo (hooks-install, reset-task)
├── commitlint.config.cjs      tipi Conventional Commits
├── .gitignore                 base (secrets + IDE/OS) + sezione [DA DEFINIRE]
├── scripts/
│   ├── hooks-install.sh       gitleaks + commitlint (sempre) + formattazione (esempio)
│   ├── reset-task.sh          cleanup chirurgico del task interrotto
│   └── README.md
└── .claude/
    ├── settings.json          hook SessionStart (inietta STATE.md) + secret scan + permessi
    ├── docs/                  00-overview, 01-task-planning ... 06-self-improvement
    ├── commands/              /checkpoint /integrate /sos /retro /security-review /new-component /lint-memory
    └── memory/                STATE, TREE, INDEX, LEARNINGS (template) + 4 sottocartelle
```

## Filosofia

Il framework migliora con l'uso: ogni progetto che ci costruisci sopra genera
lezioni di processo che tornano qui come miglioramenti per il prossimo.
