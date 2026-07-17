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

> **Progetto ESISTENTE?** Leggi prima la sezione *Innesto su un progetto
> ESISTENTE (brownfield)* in coda a questa guida: la lista di copia qui sotto
> assume file assenti, e lì trovi le regole di riconciliazione per quelli già
> presenti (più il criterio per un `.claude/` preesistente).

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

Due modalità equivalenti — scegli quella che preferisci:
- **a mano**, spuntando la checklist qui sotto;
- **in dialogo con Claude Code**: chiedigli di intervistarti sui
  `[DA DEFINIRE AL SETUP]` (guidato da questa checklist) e di scrivere le tue
  risposte nei file giusti. Non inventa nulla: ciò che non rispondi resta
  `[DA DEFINIRE AL SETUP]`, e lo completi quando vuoi. (Vedi anche la variante
  del primo comando, passo 4.)

Ecco la lista completa, raggruppata per file:

### `CLAUDE.md` (il più importante)
- [ ] Header: **nome progetto**, **stack**, **repo**.
- [ ] Regola 5: **dove vive la documentazione di progetto**.
- [ ] Regola 8: **quali componenti sono "sensibili"** (soggetti al security gate).
- [ ] Sezione finale **"Regole tecniche specifiche del progetto"**: stack, comandi
      build/test/lint/run, struttura standard di un componente, convenzioni di codice,
      API design, datastore, test/coverage, deploy. È qui che il framework diventa
      *il tuo* progetto.
- [ ] **Lingua/e del progetto** (nelle regole tecniche): quale lingua per
      memoria/processo, quale per la doc pubblica — da dichiarare se diverse
      (es. metodo in una lingua, README del progetto in un'altra).

### `.claude/docs/`
- [ ] `02-code-quality.md`: strumento di doc-comment, formato d'errore esposto ai
      client, formatter/linter, posizione della doc, formato dell'artefatto di
      produzione. (Spesso basta definirli in CLAUDE.md e qui lasciare il rimando.)
- [ ] `03-security-gate.md`: elenco esplicito dei componenti sensibili (allineato a
      CLAUDE.md regola 8).
- [ ] `04-git-workflow.md`: modello di branching, **se** diverso da main/develop/feat.

### `.claude/commands/`
- [ ] `checkpoint.md`: pattern da ignorare per `tree`, nome del branch di integrazione.
- [ ] `integrate.md`: nomi reali dei branch di integrazione e stabile (i RUOLI di
      `docs/04`) usati nel blocco di integrazione.
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

*(Se al passo 2 hai scelto la modalità in dialogo)* aggiungi in coda al comando:

> Poi intervistami sui `[DA DEFINIRE AL SETUP]` ancora aperti, seguendo la
> checklist del passo 2 di `SETUP.md`, e scrivi le mie risposte nei file giusti;
> ciò che non so ancora rispondere resta `[DA DEFINIRE AL SETUP]`.

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

In pratica: marca quelle IMP con la riga `- Destinazione: framework` (formato IMP
nell'header di `LEARNINGS.md`), poi lancia `/harvest-framework` — raccoglie le voci
marcate e ne stampa un blocco copiabile, già da anonimizzare, pronto da riproporre
come IMP nel repo del framework (`CONTRIBUTING.md`). Il comando solo legge e stampa:
il travaso resta un tuo gesto esplicito. Dettagli in
`.claude/docs/06-self-improvement.md`, *"Il ponte verso il framework"*.

---

## Innesto su un progetto ESISTENTE (brownfield)

I passi 1-5 valgono anche per un progetto già avviato (codice, storia git, doc
propri), con le differenze di questa sezione. Principio guida: **il progetto
ospite ha la precedenza** — il template si INTEGRA, non si impone; ogni collisione
si segnala all'utente invece di risolverla in silenzio.

### Prima di copiare: `.claude/` esiste già?

L'esistenza della cartella da sola NON basta a decidere: guarda cosa contiene.

- **CASO A — innesto precedente del framework** (c'è `CLAUDE.md` alla root del
  progetto e `.claude/` contiene `docs/` e `memory/` del framework): NON ricopiare
  il template sopra — quella è la memoria del progetto. Riprendi da `STATE.md`; se
  vuoi aggiornare il framework a una versione più recente, **segui la procedura
  dedicata *«Aggiornare il framework su un progetto già innestato»*** in coda a
  questa guida — riconciliazione file-per-file per classe (metodo / memoria di
  progetto / ibridi), con le differenze dichiarate all'utente.
- **CASO B — soli artefatti locali dell'harness** (tipicamente
  `settings.local.json` creato dalle approvazioni dei permessi; nessun doc o
  memoria del framework): procedi con la copia del template e PRESERVA quei file
  locali (non sono versionati e non vanno sovrascritti).

### Riconciliazione dei file in collisione

La lista di copia del passo 1 assume file assenti. Se il progetto ospite li ha già:

| File | Regola |
|---|---|
| `README.md` dell'ospite | Si PRESERVA: è la doc pubblica del progetto (il README del framework non si copia comunque, passo 1). |
| `.gitignore` | Si INTEGRA: aggiungi al file dell'ospite le voci del template (secrets, `settings.local.json`, ecc.), non sovrascriverlo. |
| `Makefile` | Si INTEGRA: aggiungi i target di processo (`hooks-install`, `reset-task`) a quello dell'ospite. |
| `SECURITY.md` | Se l'ospite ne ha già uno, si preserva/integra; lo scaffold del template serve solo se manca. |
| `LICENSE` | Resta quella dell'ospite (la LICENSE del framework non si copia mai, passo 1). |
| Hook git esistenti | Vedi passo 3: `hooks-install.sh` si ferma da solo davanti a hook non suoi o a `core.hooksPath` attivo, e ti dice come procedere. |

Regola generale per ogni altra collisione: **preserva il file dell'ospite, integra
solo il necessario del template, segnala la collisione all'utente**.

### Igiene git ereditata

Su una storia git preesistente, prima di adottare il flusso di `docs/04`:

- [ ] **Storia scansionata**: `gitleaks detect` one-off sull'intera storia (vedi
      il riquadro del passo 3) — l'hook protegge solo i commit futuri.
- [ ] **Audit dei tag ereditati**: `git cat-file -t <tag>` su ciascuno (`tag` =
      annotato, `commit` = leggero). Il regime di `docs/04` (*Versioning*) crea
      tag annotati SemVer: individua da quale base SemVer riparte il versioning
      (la guardia di `/integrate` si ferma su una base non-SemVer); l'eventuale
      normalizzazione dei tag ereditati è una decisione dell'utente — i tag
      pushati sono storia condivisa.
- [ ] **Costanti di versione negli script/config dell'ospite**: se una versione è
      hard-coded, allineala ai tag (o derivala da `git describe`) e annota la
      scelta — il drift tra costante e tag è un bug latente.
- [ ] **Topologia dei branch**: davanti a un branch di integrazione remoto
      dormiente (es. un vecchio `dev`), DECIDI e DICHIARA la scelta: trunk-based
      (i due ruoli coincidono — caso previsto da `docs/04`) oppure ripristino del
      branch come integrazione. Registra la scelta nei `[DA DEFINIRE AL SETUP]`
      di `docs/04` e nei parametri dei comandi (`checkpoint.md`, `integrate.md` —
      passo 2 di questa guida).

### Il primo comando diventa un ASSESSMENT che popola la memoria

Su un progetto esistente la memoria non parte vuota: parte dalla fotografia
dell'esistente. Al posto del comando del passo 4, usa:

> Leggi `CLAUDE.md` e tutti i doc in `.claude/docs/`: interiorizza il metodo. Poi
> fai un **assessment in SOLA LETTURA** del progetto esistente: struttura,
> componenti, maturità reale (test? doc? build?), difetti evidenti, scelte
> architetturali visibili nel codice. Con quello **inizializza la memoria**:
> compila `STATE.md` con lo stato REALE (inclusi difetti e debiti osservati),
> crea una nota in `.claude/memory/components/` per ogni componente significativo
> già esistente, registra in `.claude/memory/decisions/` le scelte architetturali
> ereditate che ricostruisci (decisioni retroattive, marcate come tali), genera
> `TREE.md` e popola `INDEX.md`. Le divergenze tra la doc dell'ospite e la realtà
> del codice NON correggerle: registrale in `STATE.md`, sezione "Debito
> documentazione". Infine riepilogami il metodo e segnalami i `[DA DEFINIRE]`
> ancora aperti. Non scrivere codice applicativo in questo passaggio.

È il pattern assessment → proposta → decisione di `00-overview.md` e
`01-task-planning.md`, promosso a passo del setup: l'assessment FOTOGRAFA, le
decisioni su cosa correggere restano all'utente.

### Divergenze doc-vs-realtà dell'ospite

Un README che documenta feature inesistenti (o simili) NON si corregge durante
l'innesto: prevale l'igiene di scope (`00-overview.md`, un cambiamento alla
volta). Si registra in `STATE.md` → "Debito documentazione" e si corregge solo
come task deciso dall'utente. Il LIVELLO 1 di `06-self-improvement.md`
(correzioni fattuali immediate) riguarda la doc del METODO e del progetto
gestito, NON la doc preesistente dell'ospite durante l'innesto — vedi la
precisazione di perimetro lì. A innesto completato, la doc dell'ospite è a tutti
gli effetti doc del progetto gestito: le divergenze scoperte DOPO seguono le
regole normali di `docs/06`; i debiti registrati durante l'innesto si
smaltiscono come task decisi dall'utente.

### Lingua del progetto ospite

Se la doc pubblica dell'ospite è in una lingua diversa da quella del framework,
dichiara la convivenza — quale lingua per memoria/processo, quale per la doc
pubblica — nelle regole tecniche di `CLAUDE.md` (voce "Lingua/e del progetto",
checklist del passo 2): decisa una volta, non nota-per-nota.

---

## Aggiornare il framework su un progetto già innestato (`vX` → `vY`)

Il **terzo caso**, accanto a greenfield (passi 0-5) e brownfield (innesto su un
progetto SENZA framework). Qui il progetto ha GIÀ una versione del framework
innestata — `CLAUDE.md` alla root, `.claude/docs/` e `.claude/memory/` popolati: è
esattamente la condizione del **CASO A** più sopra — e va portato a una versione più
recente **preservando la memoria di progetto accumulata** (STATE, sessioni, decisioni,
componenti, il backlog IMP).

È il verso DISCENDENTE del ponte descritto in `docs/06` (*"Il ponte verso il
framework"*): mentre `/harvest-framework` fa RISALIRE le lezioni dal progetto al
framework, l'upgrade fa SCENDERE una nuova versione del framework nel progetto. È anche
il veicolo con cui i fix del framework (es. a `hooks-install.sh`) e i nuovi
`[DA DEFINIRE AL SETUP]` di una versione raggiungono i progetti già avviati.

> **Nessuna automazione, per ora — è una scelta, non una mancanza.** Con pochi upgrade
> reali alle spalle questa è una procedura MANUALE guidata che orchestra primitive già
> esistenti (branch usa-e-getta, `reset-task.sh`, `/checkpoint`, `/integrate`,
> `make hooks-install`, `/lint-memory`). Un comando/script che la automatizzi — e un
> *pin* che registri all'innesto da quale versione si è partiti, per irrobustirne la
> baseline — restano rimandati finché più upgrade reali non li giustificano: stesso
> criterio anti-hype con cui il framework rimanda l'innesto automatizzato. Si documenta
> prima, si prova sul campo, si automatizza dopo.

### Il modello mentale: tre classi di file

Un upgrade tocca SOLO il layer di PROCESSO, MAI la memoria di progetto. Ogni file
ricade in una di tre classi:

- **METODO** (puro-framework, si porta a `vY`): `.claude/docs/00-06`, i comandi in
  `.claude/commands/` non personalizzati, i README-guida dentro `.claude/memory/*/`,
  `scripts/reset-task.sh`, `scripts/README.md`, `commitlint.config.cjs`.
- **MEMORIA-DI-PROGETTO** (resta INTATTA): `.claude/memory/STATE.md`, `TREE.md`,
  `INDEX.md`, `sessions/`, `components/`, `decisions/`, `plans/`. **Invariante di
  verifica: dopo l'upgrade il `git diff` su `.claude/memory/` deve essere VUOTO** (unica
  eccezione: i rimandi rotti da un rename di doc — vedi *Casi limite*).
- **IBRIDO** (parte-framework che evolve + parte-progetto da preservare, si
  riconcilia): `CLAUDE.md`, `.claude/settings.json`, `scripts/hooks-install.sh`,
  `.gitignore`, `Makefile`, `LEARNINGS.md`, e i comandi personalizzati al setup
  (`checkpoint.md`, `integrate.md`, `new-component.md`).

> **Perché gli ibridi non si separano "a sezioni".** Il fill dei `[DA DEFINIRE AL
> SETUP]` è DISTRUTTIVO: quando il progetto compila un marcatore, la stringa sparisce e
> viene sostituita dalla risposta. A setup fatto il file è un impasto di prosa-framework
> + risposte-progetto senza più un confine grep-abile. L'unico meccanismo robusto per
> riconciliarli è il **merge a 3 vie** con il template alla versione DI PARTENZA (`vX`)
> come base comune.

### Precondizione: procurati il framework a `vX` e `vY`

Il progetto ha COPIATO i file del framework, non la sua storia git: i tag di versione
vivono solo nel repo del framework. Il "cosa è cambiato" si deriva perciò LÌ, non nel
progetto (aggiungere il framework come *remote* del progetto è sconsigliato: inquina il
grafo e mescola due linee di versione). Prima di iniziare, procurati due checkout (o
export) del repo del framework: uno alla versione INNESTATA (`vX`) e uno alla versione
TARGET (`vY`). Sono la *base* e i *loro* del merge a 3 vie.

### Passo 0 — Determina la baseline `vX`

Il progetto non registra da quale versione è stato innestato. Determina `vX` così, in
ordine di preferenza:

1. **Chiedila** a chi ha fatto l'innesto (spesso la ricorda o l'ha annotata).
2. **Stimala** sul contenuto: scegli il tag del framework la cui copia dei file di
   classe METODO combacia meglio con quelli attuali del progetto — un confronto sul
   contenuto reale batte l'euristica "tag più vicino alla data d'innesto".
3. **Degrada** con onestà: se `vX` resta incerta, NON fingere un 3-way pulito. Ricadi
   sulla riconciliazione file-per-file guidata dal CHANGELOG come indice (è ciò che il
   CASO A già prescrive), ispezionando ogni file dubbio.

### Passo 1 — Punto di ripristino e branch usa-e-getta

Da branch di integrazione con working tree pulito:
`git checkout -b chore/framework-upgrade-vX-to-vY`. L'HEAD pre-upgrade è il punto di
ripristino: **la memoria vive in git, quindi il commit di sicurezza È già il backup**
(ripristino selettivo con `git checkout <sha-pre-upgrade> -- .claude/memory/`). L'intero
upgrade è un'unità buttabile — se va male, si cancella il branch (vedi *Rollback* in
`docs/04`). Nessuna copia extra della memoria fuori dal tree è necessaria.

### Passo 2 — Deriva il "cosa è cambiato" (framework-side)

Nel repo del framework, combina due fonti complementari:

- **Il CHANGELOG come INDICE** ("quali file e perché"): le sezioni tra `vX` e `vY` —
  ogni voce cita l'IMP e nomina il file toccato. È la mappa del cambiamento. (Il
  CHANGELOG non è copiato nel progetto: si legge nel repo del framework.)
- **`git diff` come TESTO ESATTO**, con scope ai soli path del METODO ed ESCLUDENDO la
  memoria del framework:

  ```bash
  git diff vX vY -- .claude/docs .claude/commands .claude/settings.json \
    CLAUDE.md scripts Makefile commitlint.config.cjs .gitignore
  ```

  L'esclusione di `.claude/memory/` è deliberata: la memoria del framework è la SUA, non
  deve MAI sovrascrivere quella del progetto.

### Passo 3 — Riconcilia per classe

- **METODO** → porta la versione `vY`.
- **MEMORIA-DI-PROGETTO** → non toccare; il `diff` su `.claude/memory/` resta vuoto.
- **IBRIDI** → merge a 3 vie con `base = template@vX`, `loro = template@vY`,
  `mio = file del progetto` (`git merge-file`/`diff3`). Il 3-way deve ottenere: un
  marcatore AGGIUNTO da `vY` si **ri-materializza** nel file (nuovo `[DA DEFINIRE]` da
  compilare); uno RIMOSSO **sparisce**; uno SPOSTATO o co-editato emerge come
  **conflitto** da risolvere a mano. Ri-applica sempre le risposte `[DA DEFINIRE AL
  SETUP]` del progetto (nomi dei branch, pattern di `tree`, formatter, allow-list dello
  stack, l'intera sezione "Regole tecniche" di `CLAUDE.md`). Gli ibridi banali
  (`.gitignore`, `Makefile`) si INTEGRANO (union additiva: garantisci presenti le righe
  della base `vY` senza rimuovere quelle di progetto); su `LEARNINGS.md` si aggiorna al
  più l'header/formato, MAI le voci IMP del progetto.

> **Confine di esecuzione (`docs/04`, sezione omonima).** L'agente PREPARA e committa in
> LOCALE sul branch di upgrade; NON mergia, NON pusha, NON tagga. Dove `vY` cambia una
> REGOLA (non è una correzione fattuale), scatta il Livello 2 di `docs/06`: si PROPONE,
> non si applica in silenzio — *"Mai riscrivere le proprie regole in autonomia"*
> (`CLAUDE.md`, regola 6).

### Passo 4 — Re-sync degli hook e audit dei marcatori

`make hooks-install` (idempotente; salva un `.bak` del blocco formattazione del
progetto). Verifica reale: un secret finto bloccato da gitleaks, un messaggio
non-conventional rifiutato da commitlint. Poi `grep -rn "DA DEFINIRE AL SETUP" .` per
intercettare i marcatori NUOVI introdotti da `vY`, da compilare con le risposte del
progetto (riusa il dialogo del passo 2 di questa guida).

### Passo 5 — Verifica prima di finalizzare

- `git diff --stat` e diff per-file; **conferma il `diff` VUOTO su `.claude/memory/`**
  (invariante forte: un diff non vuoto = bug dell'upgrade, fermati e indaga).
- Le customizzazioni `[DA DEFINIRE]` del progetto sono sopravvissute nei file
  riconciliati.
- `/lint-memory` sulla memoria preservata contro i nuovi doc (rimandi a doc
  rinominati/spostati, STATE vs git, coerenza `LEARNINGS`↔`STATE`, pagine orfane).
- Build/test del progetto verdi (anche se l'upgrade è solo-processo, conferma che il
  progetto continua a compilare e committare).

### Passo 6 — Chiusura e hand-off

`/checkpoint` (nota di sessione dell'upgrade — `vX→vY`, cosa riconciliato, cosa deciso
dall'utente; `STATE.md` con la versione framework aggiornata; `TREE.md` se la struttura
è cambiata). Poi `/integrate`: un upgrade solo-processo del progetto NON porta
feature/fix del prodotto → bump **"nessun tag"** (`chore`, lavoro interno, non una
release): dichiaralo e ometti il tag. Il merge del branch di upgrade e il push sono
azioni UMANE. Se alla review qualcosa non torna, si butta il branch: la memoria è salva
nel commit pre-upgrade.

### Casi limite (da trattare esplicitamente)

La riconciliazione "porta la versione `vY`" del Passo 3 è un OVERWRITE, non un `sync`, e
il 3-way copre i co-edit ma non tutto. Questi sette casi vanno gestiti apposta, o
l'upgrade lascia il progetto in uno stato incoerente:

1. **File CANCELLATO in `vY` (orfano).** Se `vY` rimuove un file di METODO (un doc
   accorpato, un comando deprecato), sovrascrivere non lo cancella: resta orfano. Il
   `git diff vX vY` mostra le rimozioni come hunk di delete — **applica anche quelle**
   (`git rm`), e chiudi con un check anti-orfano: l'insieme dei file di METODO del
   progetto deve combaciare con quello di `vY`.

2. **File RINOMINATO/RINUMERATO in `vY` (duplicato).** Se `vY` rinomina o rinumera un
   doc/comando (es. una rinumerazione di `docs/`), l'overwrite crea il nuovo nome e
   **lascia il vecchio** → due file e un indice `CLAUDE.md`/`TREE.md` ambiguo. Usa
   `git diff -M` come indice dei rename per applicare lo spostamento (rimuovi il vecchio,
   porta il nuovo), non un add+delete cieco.

3. **Rimandi della memoria verso doc rinominati — l'unica eccezione all'invariante.**
   Se `vY` rinomina/rinumera un doc, i `[[wikilink]]` e i rimandi (`docs/04:142`, …) in
   `STATE.md` e nelle sessioni **penzolano**, e `/lint-memory` li segnalerà rotti. Qui
   l'invariante "diff vuoto su `memory/`" e la riparazione confliggono: la via d'uscita è
   trattare la riparazione dei rimandi come **eccezione ESPLICITA e DICHIARATA**, in un
   **commit separato** (`docs(memory): aggiorna i rimandi ai doc rinominati da vY`),
   distinto dai commit dell'upgrade. Così l'invariante resta utile (intercetta gli edit
   ACCIDENTALI della memoria) e la riparazione necessaria non passa di nascosto. È
   l'unico tocco lecito alla memoria durante un upgrade, e solo se un rename lo impone.

4. **Hook installati (`.git/hooks/*`) fuori dal grafo git.** `make hooks-install` del
   Passo 4 materializza gli hook in `.git/hooks/`, che NON è tracciato né sul branch. Due
   conseguenze: (a) se dimentichi il re-run, gli hook installati restano vecchi mentre
   `hooks-install.sh` è aggiornato — incoerenza silenziosa; (b) **lo scarto del branch
   NON disinstalla** gli hook nuovi già materializzati, e il commit di sicurezza non li
   ha mai catturati. Quindi: il re-run è OBBLIGATORIO, non opzionale; e se abortisci
   l'upgrade dopo il Passo 4, ri-esegui `make hooks-install` dalla versione `vX` per
   riportare gli hook coerenti col codice ripristinato.

5. **Attraversare la `1.0.0` (`0.x → 1.0`) cambia REGOLE vive.** Aggiornare `docs/04`
   attraverso la prima release stabile non è solo testo: cambia il regime di versioning
   (in `0.x` i tag vivono sul branch di sviluppo, da `1.0.0` sul branch stabile) sotto un
   progetto che sta già operando con la vecchia regola. Se il progetto è a metà di un
   proprio ciclo di release, **fermati e segnalalo all'utente**: aggiornare un doc di
   PROCESSO può cambiare semantiche VIVE, non solo prosa.

6. **Salto multi-versione (`v0.1 → v0.4`): ordine delle migrazioni.** Un `git diff` fra
   gli ESTREMI collassa gli intermedi: va bene per aggiunte/rimozioni che si annullano,
   ma **perde l'ordine delle migrazioni non-commutative** (es. un file rinominato in `vX+1`
   e poi ristrutturato in `vX+2`) e conflonde fix multipli sullo stesso file in un unico
   hunk. Per un salto di più versioni, usa il CHANGELOG **per-versione** come indice
   dell'ordine e, sui file più intricati (tipicamente `hooks-install.sh`), riconcilia
   **una versione alla volta** invece che in un colpo solo.

7. **Pre-flight: il file "METODO-puro" è stato personalizzato inline?** La classe METODO
   assume che `docs/02/03/04` restino template (i loro `[DA DEFINIRE]` si risolvono per
   convenzione in `CLAUDE.md` con un rimando). Ma se il progetto li ha compilati **inline**
   — o ha editato liberamente un file altrimenti puro (`commitlint.config.cjs`, un doc) —
   quel file è di fatto un IBRIDO, e l'overwrite ne distrugge la personalizzazione in
   silenzio. Prima di sovrascrivere un file di classe METODO, **ispeziona** che sia
   davvero intatto rispetto a `vX`; se diverge, trattalo come ibrido (3-way).

> **Fuori dal payload dell'upgrade.** `LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md` sono
> file del REPO DEL FRAMEWORK (non copiati nel progetto, passo 1): non spingerli nel
> progetto e non leggerli dal progetto. `SECURITY.md`, `README.md` e questo `SETUP.md`
> nel progetto sono opzionali/di riferimento — e attenzione a **non sovrascrivere il
> `README.md` del progetto** con quello del framework. `settings.local.json` (non
> versionato) resta intatto per costruzione.
