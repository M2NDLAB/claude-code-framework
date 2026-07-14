# SETUP — iniziare un nuovo progetto da questo template

Questa guida porta da "template vuoto" a "progetto pronto a lavorare con Claude Code".
Tempo stimato: 15-30 minuti, la maggior parte per compilare le regole tecniche.

## 0. Prerequisiti

- **git** (il framework è git-centrico: branch, commit per-task, hook).
- **gitleaks** — secret scanning negli hook. macOS: `brew install gitleaks`.
- **Node.js / npx** — usato da commitlint (Conventional Commits).
- *(opzionale)* **tree** — per rigenerare `TREE.md`. Fallback: `git ls-files`.
- *(opzionale)* **Obsidian** — la cartella `.claude/` si apre come vault; i wikilink
  `[[...]]` diventano un graph navigabile. Non è necessario: i link funzionano come
  rimandi in qualsiasi editor.

## 1. Copia il template nel nuovo progetto

Copia nella root del nuovo repo: la cartella `.claude/`, `CLAUDE.md`, `Makefile`,
`commitlint.config.cjs`, `.gitignore`, `scripts/`. (README.md e questo SETUP.md
puoi lasciarli fuori dal progetto finale, o tenerli come riferimento.)

> **`LICENSE`, `CONTRIBUTING.md` e `CHANGELOG.md` NON si copiano.** Sono file del
> repo del framework (la sua licenza, il suo flusso di contributi, la sua storia):
> la licenza del TUO progetto è una scelta tua ([DA DEFINIRE AL SETUP], checklist
> Root qui sotto). `SECURITY.md` invece è uno scaffold riusabile: puoi copiarlo e
> compilare i suoi `[DA DEFINIRE AL SETUP]`.

Poi: `git init` (se non è già un repo) e crea il branch di integrazione (`develop`).

## 2. Riempi i `[DA DEFINIRE AL SETUP]`

Cerca i marcatori nel template: `grep -rn "DA DEFINIRE AL SETUP" .`
Ecco la lista completa, raggruppata per file:

### `CLAUDE.md` (il più importante)
- [ ] Header: **nome progetto**, **stack**, **repo**.
- [ ] Regola 5: **dove vive la documentazione di progetto**.
- [ ] Regola 8: **quali componenti sono "sensibili"** (soggetti al security gate).
- [ ] Sezione finale **"Regole tecniche specifiche del progetto"**: stack, comandi
      build/test/lint/run, struttura standard di un componente, convenzioni di codice,
      API design, datastore, test/coverage, deploy. È qui che il framework diventa
      *il tuo* progetto.

### `.claude/docs/`
- [ ] `02-code-quality.md`: strumento di doc-comment, formato d'errore esposto ai
      client, formatter/linter, posizione della doc, formato dell'artefatto di
      produzione. (Spesso basta definirli in CLAUDE.md e qui lasciare il rimando.)
- [ ] `03-security-gate.md`: elenco esplicito dei componenti sensibili (allineato a
      CLAUDE.md regola 8).
- [ ] `04-git-workflow.md`: modello di branching, **se** diverso da main/develop/feat.

### `.claude/commands/`
- [ ] `checkpoint.md`: pattern da ignorare per `tree`, nome del branch di integrazione.
- [ ] `new-component.md`: struttura standard di un componente del progetto
      (finché CLAUDE.md e questo file non sono compilati, `/new-component` è inerte).

### `.claude/memory/`
- [ ] `TREE.md`: il pattern `-I '...'` per `tree` adatto al tuo stack.
- [ ] **SVUOTA la memoria VIVA del framework**: `LEARNINGS.md` arriva con le IMP
      del framework stesso (regime ibrido, vedi il suo `CONTRIBUTING.md`) — riporta
      le sezioni a vuote: le IMP del TUO progetto ripartono da 001. Elimina le note
      in `sessions/` (tieni il README).
- [ ] (I template `STATE.md`, `INDEX.md` si popolano al primo comando — vedi
      punto 4; per ora lascia i blocchi di istruzioni.)

### `.claude/settings.json`
- [ ] Aggiungi alla `allow` SOLO i comandi **read-only** dei tuoi tool (build tool,
      package manager, container CLI) per ridurre i prompt — es. il comando di
      build/test. La baseline è già impostata (`allow`: ispezione git + `add`/`commit`
      sicuri; `deny`: push, `reset --hard`, cancellazioni distruttive, lettura secret)
      — i principi sono in `04-git-workflow.md` ("Configurazione dei permessi").
- [ ] Lascia `settings.local.json` fuori dal versionamento (è già in `.gitignore`) e
      parti vuoto: i permessi personali NON si committano, niente concessioni vaghe
      tipo "non chiedere più per comandi simili".

### Root
- [ ] `scripts/hooks-install.sh`: abilita e adatta il blocco **formattazione** per il
      tuo linguaggio (vedi gli esempi commentati nell'hook pre-commit).
- [ ] `Makefile`: aggiungi i target `build` / `test` / `run` del progetto.
- [ ] `.gitignore`: decommenta/aggiungi gli artefatti di build del tuo stack.
- [ ] **Licenza del progetto**: scegli la licenza del TUO progetto e crea la sua
      `LICENSE` (holder e anno tuoi). Quella del framework non si eredita; registra
      la scelta anche in `CLAUDE.md` (regole tecniche).

## 3. Installa gli hook git

```bash
make hooks-install
```

Verifica: un commit con un messaggio non-conventional deve essere rifiutato; un file
con un secret finto deve essere bloccato da gitleaks.

> **Il repo ha già una storia?** (innesto su un progetto esistente) L'hook protegge
> solo i commit da ora in poi: completa la baseline con una scansione one-off
> dell'INTERA storia, `gitleaks detect` (dalla root del repo). Valuta ogni finding
> PRIMA di proseguire: un secret nella storia pushata resta esposto anche se lo
> togli dai file correnti — ruotalo/revocalo subito; l'eventuale riscrittura della
> storia è un'operazione a parte, da decidere con giudizio (`docs/03`, baseline).

## 4. Primo comando a Claude Code

Apri Claude Code nella root del progetto e dài un comando come questo:

> Leggi `CLAUDE.md` e tutti i doc in `.claude/docs/`: voglio che tu interiorizzi il
> metodo di lavoro (memoria, task-planning, escalation, security gate, git workflow,
> auto-miglioramento). Poi **inizializza la memoria**: compila `STATE.md` con lo stato
> iniziale reale del progetto (rimuovendo i blocchi di istruzioni dei template),
> genera `TREE.md` dalla struttura attuale, e popola `INDEX.md`. Infine, fammi un
> riepilogo del metodo come l'hai capito e segnalami eventuali `[DA DEFINIRE]` ancora
> aperti. Non scrivere codice applicativo in questo passaggio.

Da qui in poi il ciclo è quello di `.claude/docs/00-overview.md` (vedi "Il ciclo di
fine deliverable"). Per ogni prompt oneroso Claude Code genererà un piano in
`.claude/memory/plans/`; a fine deliverable seguirà la sequenza [se sensibile]
`/security-review` → `/retro` → `/checkpoint` → `/integrate`; quando si blocca, `/sos`.
La review periodica del backlog IMP resta `/retro` sull'intero `LEARNINGS.md`.

## 5. Far evolvere il framework

Le lezioni di processo che emergono lavorando finiscono in `LEARNINGS.md` come
proposte IMP. Quelle che si rivelano utili a *qualsiasi* progetto sono candidate a
tornare nel template del framework, per il prossimo progetto. È il loop descritto
nella *Filosofia* del README.
