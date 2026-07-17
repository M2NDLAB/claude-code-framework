---
type: learnings
updated: 2026-07-17
tags: [improvement]
---
# Learnings & proposte di miglioramento

> **Cos'è questo file.** Il backlog dell'auto-miglioramento di processo (vedi
> `.claude/docs/06-self-improvement.md`). Qui Claude Code registra le proposte di
> modifica a regole, doc, comandi e configurazione (IMP-nnn) — ma NON le applica
> da solo: le applica solo dopo approvazione dell'utente. Le correzioni puramente
> FATTUALI alla doc (Livello 1) non passano da qui, si applicano subito.
>
> La numerazione delle IMP parte da **001**. Questo file nasce VUOTO in un nuovo
> progetto. NEL REPO DEL FRAMEWORK, invece, è VIVO (regime ibrido dichiarato —
> vedi `CONTRIBUTING.md`): chi copia il template lo SVUOTA al setup (`SETUP.md`).

## Proposte APERTE (in attesa di decisione utente)

### IMP-031 — I marcatori `[DA DEFINIRE AL SETUP]` che vanno a capo sfuggono al grep del setup
- Data: 2026-07-17 | Origine: audit pre-integrate di v0.3.0 (lente internal-consistency)
- Problema osservato: `SETUP.md` (riga 37) prescrive `grep -rn "DA DEFINIRE AL SETUP" .`
  per elencare i punti da compilare al setup, ma un marcatore che si spezza su due righe
  (wrap del testo) è invisibile a quel grep single-line. È già successo DUE volte:
  `integrate.md` (sanato da 7fc8b8e in questo stesso deliverable) e `docs/04:142` (sanato
  ora, commit `740b575`). L'istanza è chiusa; resta scoperta la PREVENZIONE della classe.
- Proposta: convenzione esplicita "un marcatore `[DA DEFINIRE AL SETUP]` sta sempre su
  una riga fisica" (regole di stile / `SETUP.md`), e/o un controllo in `/lint-memory` o
  nello script di setup che segnali le occorrenze spezzate (es. `grep -rn "DA DEFINIRE AL$"`
  come sentinella).
- Beneficio atteso / rischio: il grep del setup trova TUTTI i marcatori (nessun punto da
  compilare dimenticato); rischio ~nullo (convenzione + check, nessun cambio di regola
  sostanziale).
- Trigger di ripresa: prossima retrospettiva periodica sul backlog, o alla prossima
  occorrenza di un marcatore spezzato.

### IMP-032 — `hooks-install.sh`: FORCE_OVERWRITE su symlink dangling aborta prima del backup
- Data: 2026-07-17 | Origine: audit pre-integrate di v0.3.0 (lente script-safety, confermato empiricamente)
- Problema osservato: nel ramo `FORCE_OVERWRITE=1` di `scripts/hooks-install.sh`, la
  sequenza `cp -L "${target}" "${target}.bak"` → `rm -f "${target}"` → AVVISO, sotto
  `set -euo pipefail`, su un hook che è un symlink DANGLING (bersaglio inesistente):
  `cp -L` fallisce e lo script esce non-zero PRIMA dell'avviso e prima del `rm`,
  divergendo dal commento di testata che promette un backup `.bak` garantito con FORCE.
  Nessuna perdita dati (un symlink dangling è già inerte, niente da salvare) — è un difetto
  di robustezza/coerenza, non di sicurezza.
- Proposta: gestire il caso dangling — es. `[[ -e "${target}" ]]` prima del `cp -L`; se il
  target non esiste, saltare il backup con un avviso dedicato e rimuovere comunque il link.
  Fix accompagnato da un test RED→GREEN (docs/02) sul caso "symlink dangling + FORCE_OVERWRITE=1".
- Beneficio atteso / rischio: lo script mantiene la promessa del commento in ogni caso, exit
  code coerente; rischio basso (ramo di edge già isolato).
- Trigger di ripresa: prossima retrospettiva, o quando si rimette mano a `hooks-install.sh`.

<!-- Formato di una proposta:
### IMP-001 — <titolo breve>
- Data: YYYY-MM-DD | Origine: <sessione/problema che l'ha generata>
- Problema osservato: <attrito ricorrente, errore ripetuto, gap, regola ambigua>
- Proposta: <cosa cambiare e dove: CLAUDE.md / docs/NN / comando / hook / processo>
- Beneficio atteso / rischio:
- Trigger di ripresa: <se non è applicabile subito: quale evento la fa tornare in gioco>
-->

## Applicate

### IMP-001 — Strategia di versioning SemVer su tag annotati → applicata il 2026-06-16, commit 5ad74cb
- Aggiunta in `04-git-workflow.md` la sezione "Versioning" che SOSTITUISCE la regola
  "tag solo dopo il merge su `main`": due regimi (pre-1.0 si tagga su `develop`, da
  `1.0.0` su `main`), mappatura tipo-commit→bump, tag annotati, hotfix come PATCH.

### IMP-002 — Blocco "PRONTO PER INTEGRAZIONE" a fine deliverable → applicata il 2026-06-16, commit 803e409
- Nuovo slash command `/integrate`: raccoglie lo stato in sola lettura ed emette la
  sequenza merge+tag pronta da incollare (bump, prossima versione da `git describe`,
  verifica e note anti-errore) senza eseguire push/merge. Richiamato da `/checkpoint`
  e da docs/04.

### IMP-003 — Protocollo per il refactor cross-modulo sicuro → applicata il 2026-06-16, commit 00bed56
- Sezione in `01-task-planning.md`: branch dedicato, task atomici per consumatore,
  test di TUTTI i moduli toccati verdi a OGNI passo, review di coerenza prima del merge.

### IMP-004 — Configurazione dei permessi pulita → applicata il 2026-06-16, commit 11c4c98
- `settings.json`: aggiunti `git add`/`git commit` all'`allow` e `git clean`/`branch -D`/
  `rm -rf` alla `deny`; quattro principi documentati in docs/04 ("Configurazione dei
  permessi") e checklist aggiornata in `SETUP.md`.

### IMP-005 — Lint della memoria/wiki (health-check) → applicata il 2026-06-16, commit c08631f
- Nuovo slash command `/lint-memory` (coerenza: stato-vs-realtà, contraddizioni,
  orfani, link rotti, claim stantii) col criterio "contraddizione = bug da correggere";
  nota di confine lint≠retro aggiunta in docs/06.

### IMP-006 — Ciclo unico di fine deliverable → applicata il 2026-06-16, commit 0a399f1
- Sezione "Il ciclo di fine deliverable" in `00-overview.md` con sequenza ordinata
  (costruzione → [se sensibile] `/security-review` → `/retro` → `/checkpoint` →
  `/integrate`); diagramma del ciclo aggiornato; cenni allineati in `README.md` e
  `SETUP.md`. `/security-review` è condizionale (solo se sensibile), gli altri fissi.

### IMP-007 — Cabla /retro nel flusso e risolvi l'incoerenza della riflessione → applicata il 2026-06-16, commit e016ad4
- `/retro` è ora il passo di riflessione del ciclo (PRIMA di `/checkpoint`). Corrette
  in `06-self-improvement.md` le due occorrenze "riflessione al checkpoint"; chiarite
  in `retro.md` le due intensità (registrazione leggera per-deliverable vs review
  periodica del backlog con decisioni).

### IMP-008 — Branch di integrazione parametrico → applicata il 2026-06-16, commit 86c7362
- In `04-git-workflow.md` "branch di integrazione"/"branch stabile" sono RUOLI
  (`develop`/`main` solo default di esempio, [DA DEFINIRE AL SETUP]); blocco di
  `/integrate` parametrizzato (`<integrazione>`/`<stabile>`); guardia di
  `reset-task.sh` configurabile via `PROTECTED_BRANCHES`.

### IMP-009 — Confine di esecuzione git e blocchi per l'utente → applicata il 2026-07-11, commit 6019fc6
- Nuova sezione in `04-git-workflow.md`: storia LOCALE = Claude Code, storia
  CONDIVISA = utente; blocchi utente con valori REALI (mai placeholder nudi);
  placeholder dell'esecutore mai passati all'utente; comandi distruttivi solo in
  blocco separato con la condizione esatta.

### IMP-010 — Igiene dei tag e verifiche pre-push → applicata il 2026-07-11, commit 83a6642
- docs/04 *Versioning*: tag digitato a mano con `-m` ASCII, `git rev-parse <tag>`
  prima del push, `tag -d` SOLO se la verifica fallisce, `git log
  origin/<branch>..<branch>` prima di ogni push. Blocco di `/integrate` aggiornato
  con le due verifiche e il blocco di recupero separato.

### IMP-011 — Fasi a monte del deliverable strutturale → applicata il 2026-07-11, commit fdfdb29
- `00-overview.md` + `01-task-planning.md`: per i deliverable con scelte
  strutturali, PRIMA del piano: assessment read-only → proposta con alternative →
  decisione utente → registrazione in `decisions/` (o ADR) → piano che PUNTA alla
  decisione.

### IMP-012 — Igiene di scope e di sessione → applicata il 2026-07-11, commit 27fa2d2
- `00-overview.md`: un cambiamento alla volta (niente "già che ci siamo"), `/clear`
  tra deliverable scollegati, lavoro scollegato su branch/worktree separato.

### IMP-013 — Memoria su disco come contratto → applicata il 2026-07-11, commit bd2b034
- `00-overview.md` (pilastro 1), `01` (RIPRESA), `sessions/README.md`: le decisioni
  su disco ACCORCIANO i prompt (il prompt ci punta); il lavoro costoso si persiste
  PRIMA di `/clear`/cambio modello; il prompt di ripresa dà il compito senza turni
  a vuoto.

### IMP-014 — Debiti con trigger, sopravvivenza alle riscritture di STATE → applicata il 2026-07-11, commit a9a3966
- Template `STATE.md` (voce di debito col trigger), `/checkpoint` (verifica di
  sopravvivenza delle voci dopo la riscrittura), `/lint-memory` (controllo 9:
  coerenza LEARNINGS ↔ STATE).

### IMP-015 — Verifica su artefatti reali; test che dimostrano → applicata il 2026-07-11, commit 1843352
- docs/02: la causa si verifica sugli artefatti REALI prima di agire (un debito può
  essere registrato con la causa sbagliata); sezione "Test che dimostrano":
  RED→GREEN isolando la variabile, invarianti per costruzione con anti-vacuità.

### IMP-016 — Review adversariale per raggio di propagazione → applicata il 2026-07-11, commit a20a932
- docs/03: adversariale (autore ≠ giudice) sul codice di sicurezza in moduli
  CONDIVISI; autore-che-verifica su ricognizioni e fix locali; completezza dei
  finding dalla SINTESI (non dal journal gonfiabile dai retry) prima di agire.

### IMP-017 — Effort proporzionale alle conseguenze dell'errore → applicata il 2026-07-11, commit 2e01896
- `00-overview.md`: principio tool-agnostico — ragionamento costoso dove la
  correttezza ha conseguenze, standard per lettura/decisioni già prese/chore.

### IMP-018 — Trigger di /lint-memory + fix fattuali minori → applicata il 2026-07-11, commit f910cfd
- Trigger dichiarato (periodico + eventi che toccano molte note) in `00-overview.md`
  e `lint-memory.md`; legenda di `TREE.md` ora rimanda all'elenco autorevole di
  `CLAUDE.md`; `SETUP.md` avvisa che `/new-component` è inerte finché non compilato.

### IMP-019 — Merge parametrico: PR o blocco /integrate → applicata il 2026-07-11, commit 152f6f5
- docs/04 *Merge*: risolta la contraddizione "SEMPRE via PR" vs blocco locale di
  `/integrate` — il merge è SEMPRE azione umana, in due forme [DA DEFINIRE AL
  SETUP]: via PR (flusso di review team) o via blocco `/integrate` (sviluppatore
  singolo). Allineati release e promozione 1.0.0.

### IMP-020 — Rimosso l'hook PreToolUse gitleaks decorativo → applicata il 2026-07-11, commit 6a55922
- Dimostrato sulla catena reale: exit sempre 0 (l'`||` inghiottiva il leak trovato,
  con messaggio fuorviante), bersaglio `--staged` sbagliato al momento di
  Write/Edit; il pre-commit di `hooks-install.sh` invece blocca davvero (commit con
  secret rifiutato). `settings.json` ripulito: niente falsa sicurezza.

### IMP-021 — Licenza MIT a due livelli → applicata il 2026-07-11, commit a9b7dee
- `LICENSE` MIT reale (Copyright (c) 2026 M2NDLAB) che copre il SOLO framework; la
  licenza del progetto-cliente resta una sua scelta [DA DEFINIRE AL SETUP]
  (`CLAUDE.md` regole tecniche + `SETUP.md`: LICENSE non si copia).

### IMP-022 — SECURITY, CONTRIBUTING, CHANGELOG del repo → applicata il 2026-07-11, commit 63312bf
- `SECURITY.md` (canale reale: GitHub Security Advisories, nessuna email; parti
  cliente [DA DEFINIRE AL SETUP]); `CONTRIBUTING.md` (workflow reale del repo);
  `CHANGELOG.md` Keep a Changelog con voce retroattiva `v0.1.0` + `Unreleased`;
  aggiornamento del CHANGELOG cablato come passo 3 di `/integrate`.

### IMP-024 — Regime di memoria "ibrido dichiarato" → applicata il 2026-07-11, commit 16cfe1e
- Vivi nel repo-framework SOLO `LEARNINGS.md` e `sessions/`; `STATE`/`TREE`/`INDEX`
  restano template. Dichiarato in `CONTRIBUTING.md` e nell'header di questo file;
  `SETUP.md` istruisce lo svuotamento alla copia (le IMP del cliente ripartono da 001).

### IMP-025 — Trunk-based dichiarato + storia condivisa agnostica → applicata il 2026-07-11, commit da164c8
- `CONTRIBUTING.md` dichiara l'eccezione VOLUTA: trunk-based su `main` (integrazione
  e stabile coincidono, caso previsto da docs/04), tag pre-1.0 su `main`; docs/04
  *Formato commit*: niente nomi di progetti/clienti nella storia condivisa.

### IMP-027 — Percorso di setup brownfield → applicata il 2026-07-14, commit ff3c2bc (+7fc8b8e)
- Sezione "Innesto su un progetto ESISTENTE (brownfield)" in `SETUP.md`: criterio
  CASO A/B per `.claude/` preesistente (la sola esistenza della cartella non
  basta), riconciliazione dei file in collisione (l'ospite ha la precedenza; ogni
  collisione si segnala), primo comando come assessment read-only che POPOLA la
  memoria dall'esistente (STATE reale, `components/` retroattive, decisioni
  ereditate), divergenze doc-vs-realtà registrate come debito e mai corrette
  d'ufficio. Perimetro del LIVELLO 1 precisato in docs/06 (con confine di fine
  innesto, 7fc8b8e), "Debito documentazione" allargato nel template `STATE.md`
  alla doc esistente-ma-errata, rimando dal README e forward-pointer al passo 1.
  L'opzione script `graft.sh` NON è inclusa: rimandata (vedi Rimandate).

### IMP-028 — Igiene git ereditata all'innesto → applicata il 2026-07-14, commit 051d02c, 1103ffb, 4cd4363, c623b82
- (b) 051d02c: `gitleaks detect` one-off sull'intera storia dichiarato come
  completamento della baseline (docs/03 + riquadro in SETUP passo 3).
  (d) 1103ffb + review c623b82: `hooks-install.sh` si ferma su hook di altra
  origine (symlink inclusi) e su `core.hooksPath` con rimedio a scope corretto;
  `FORCE_OVERWRITE=1` fa backup `.bak` e non scrive mai attraverso i symlink; le
  personalizzazioni dei PROPRI hook si salvano in `.bak` al rilancio; commento
  in testa allineato al comportamento reale. Sei scenari dimostrati su repo
  usa-e-getta. (a+c) 4cd4363: guardia sulla base SemVer nel passo 1 di
  `/integrate` + razionale di docs/04 corretto in forma descrittiva (`git
  describe --tags` accetta anche i lightweight; nessun obbligo nuovo) +
  checklist "Igiene git ereditata" nella sezione brownfield (audit tag, costanti
  di versione hard-coded, topologia dei branch decisa-e-dichiarata).

### IMP-029 — Convivenza linguistica dichiarata → applicata il 2026-07-14, commit acdefcb
- Voce "Lingua/e del progetto" negli esempi delle regole tecniche di `CLAUDE.md`,
  checkbox nella checklist del passo 2 di `SETUP.md`, rimando nella sezione
  brownfield: la lingua di memoria/processo vs doc pubblica si decide una volta,
  non nota-per-nota. Vale anche in greenfield.

### IMP-030 — Compilazione dei [DA DEFINIRE AL SETUP] assistita da Claude Code → applicata il 2026-07-14, commit 42bc00a
- SETUP passo 2 dichiara le due modalità equivalenti (a mano con la checklist /
  in dialogo con Claude Code che intervista e scrive le risposte), variante del
  primo comando al passo 4, riga allineata nel README. Solo documentazione del
  comportamento esistente: i marcatori senza risposta restano
  `[DA DEFINIRE AL SETUP]`, nessuna invenzione.

<!-- Formato:
### IMP-001 — <titolo> → applicata il YYYY-MM-DD, commit <sha>
- <sintesi del problema e di cosa è stato cambiato in concreto>
-->

## Rimandate (non respinte — si riprendono al momento giusto)

### IMP-023 — CODE_OF_CONDUCT.md e template .github/ → rimandata il 2026-07-11
- Decisione utente: RIMANDA. Senza un flusso reale di contributi esterni sono
  cerimonia (filtro anti-hype); si creano al volo quando servono (costo basso).
  Alla ripresa: CODE_OF_CONDUCT = Contributor Covenant v2.1 con contatto
  placeholder; `.github/` con template issue/PR minimi allineati a Conventional
  Commits e al ciclo di fine deliverable.
- Trigger di ripresa: primo issue/PR di un contributore esterno reale, oppure
  decisione dell'utente di pubblicizzare il repo.

### IMP-026 — Skill di Claude Code come artefatto gestito → rimandata il 2026-07-11
- Decisione utente: RIMANDA (interpretazione confermata: convenzione di gestione
  delle Skill come artefatto di prima classe, NON libreria di skill concrete).
  Oggi nessun attrito osservato che le giustifichi: i comandi e il caricamento
  selettivo di doc/memoria svolgono la stessa funzione (contesto on-demand).
- Trigger di ripresa: ≥2 procedure operative ricorrenti in un progetto-cliente
  senza casa naturale (né regole tecniche di CLAUDE.md né un comando), oppure le
  Skill diventano il veicolo primario delle procedure di progetto in Claude Code.
  Alla ripresa: convenzione minima agnostica (`.claude/skills/README.md` + agganci
  a `/checkpoint` e `/lint-memory`), MAI una libreria di skill concrete.

### IMP-027 (opzione `graft.sh`) — script di innesto automatizzato → rimandata il 2026-07-14
- Decisione utente: il resto di IMP-027 è APPLICATO (vedi Applicate); lo script
  che automatizza l'innesto (copia del sottoinsieme giusto, azzeramento di
  LEARNINGS/sessions, `gitleaks detect` one-off, gestione hook) NON si fa ora —
  filtro anti-hype: le collisioni sono decisioni umane (lo script può solo
  rilevarle) e la sezione brownfield di `SETUP.md` va prima provata sul campo.
- Trigger di ripresa: dopo 2-3 innesti brownfield reali, quando il pattern
  comune è distillabile dal testo provato.

## Rifiutate (con motivo — per non riproporle)
_(nessuna ancora)_
