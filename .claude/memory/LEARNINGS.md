---
type: learnings
updated: 2026-07-20
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
>
> **Attributo `Destinazione: framework`.** In un progetto-CLIENTE una IMP può
> riguardare il FRAMEWORK invece che questo progetto: si marca con la riga
> `- Destinazione: framework` (riga fisica singola, così `/harvest-framework` la
> raccoglie via grep). Omessa = lezione-di-questo-progetto, che resta nel cliente.
> È un attributo di DESTINAZIONE, non un livello: la lezione resta di Livello 2 —
> vedi `docs/06-self-improvement.md`, *"Il ponte verso il framework"*. NEL REPO DEL
> FRAMEWORK l'attributo è moot (ogni IMP è già framework) e non si usa sulle voci.

## Proposte APERTE (in attesa di decisione utente)

> Nota transitoria: IMP-040/041/042 sono scritte in inglese perché registrano — e
> anticipano — la regola linguistica decisa dall'utente (artefatti futuri in
> inglese). Il resto del file sarà allineato dalla FASE 2 di IMP-041.

### IMP-040 — Two-axis language rule: interaction configurable, artifacts always English
- Data: 2026-07-20 | Origine: user decision, language deliverable phase 1 (session
  [[2026-07-20-language-rule-phase1]])
- Problema osservato: the IMP-029 model ("memory/process language vs public-doc
  language, default = the framework's language") made the ARTIFACT language a
  per-project choice. Result: an Italian-language template, mixed-language
  artifacts across projects, and reduced adoptability — against open-source
  practice, where repo artifacts are conventionally English.
- Proposta: REPLACE the IMP-029 model (do not accumulate two conflicting models)
  with two axes: (1) **INTERACTION** — the language Claude Code uses with the user
  in session — CONFIGURABLE, a `[TO BE DEFINED AT SETUP]` slot in CLAUDE.md's
  technical rules; the ONLY configurable axis. (2) **ARTIFACTS** — everything that
  lands in the repo: code, comments, files, README, documentation, memory, FUTURE
  commits, IMP entries, notes — ALWAYS English; a fixed framework rule (new
  numbered rule in CLAUDE.md), NOT a setup marker. Past git history is immutable
  and is never translated. Where it lands: new global rule in CLAUDE.md; the
  "Lingua/e del progetto" slot in the technical-rules section becomes "Interaction
  language"; SETUP.md §2 checklist and the brownfield "host language" paragraph
  rewritten accordingly.
- Beneficio atteso / rischio: coherent template and portable artifacts; the rule
  is one line, no per-note decisions. Risk: it removes pure agnosticism on the
  language axis — an imposed value choice. OPEN POINT for the user: fixed rule
  (current decision) vs `[TO BE DEFINED AT SETUP]` defaulting to English but
  overridable — raised explicitly in the phase-1 report, to be confirmed before
  application.
- Stato: decision taken in principle by the user (2026-07-20, "definitive");
  awaiting confirmation of non-configurability + phase-1 review, then applied as
  task 1 of IMP-041 phase 2.

### IMP-041 — Translate the entire framework to English (option 2 — user decision)
- Data: 2026-07-20 | Origine: user decision, language deliverable phase 1 (session
  [[2026-07-20-language-rule-phase1]])
- Decisione registrata (structural, hybrid regime — recorded here instead of
  `decisions/`): translate ALL framework content from Italian to English —
  docs/, commands/, memory templates and live memory (LEARNINGS, sessions),
  README/SETUP/CONTRIBUTING/SECURITY/CHANGELOG, CLAUDE.md, script comments and
  user-facing messages. NOT translated: past commits (immutable history), file
  NAMES (renames would break references and history), identifiers in scripts,
  conventional-commit types (already English).
- Esecuzione: phase 1 (this session) = assessment, rule text, translation
  inventory, glossary, risk analysis — STOP for user approval (glossary above
  all). Phase 2 = the translation, task-per-commit on branch
  `feat/english-translation`, behavior-bearing strings switched atomically with
  their greps (marker `[DA DEFINIRE AL SETUP]`, `Destinazione: framework`, hook
  MARKER with legacy recognition, `PRONTO PER INTEGRAZIONE`, escalation block
  delimiters, SessionStart banner).
- Bump proposto: **MAJOR (v2.0.0)** — changing the marker format and the
  grep-recognized memory strings is exactly the breaking-change definition of
  CONTRIBUTING.md/docs/04 (it breaks greps in existing grafts and upgrades);
  replacing the IMP-029 model removes a configuration axis from the method's
  contract. Final call stays with the user at `/integrate`.

## Applicate

<!-- Formato di una proposta:
### IMP-001 — <titolo breve>
- Data: YYYY-MM-DD | Origine: <sessione/problema che l'ha generata>
- Problema osservato: <attrito ricorrente, errore ripetuto, gap, regola ambigua>
- Proposta: <cosa cambiare e dove: CLAUDE.md / docs/NN / comando / hook / processo>
- Beneficio atteso / rischio:
- Trigger di ripresa: <se non è applicabile subito: quale evento la fa tornare in gioco>
- Destinazione: framework   (OPZIONALE — solo in un progetto-cliente e solo se la lezione
                             va fatta risalire al framework; riga fisica singola per il grep)
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

### IMP-031 — Marcatori `[DA DEFINIRE AL SETUP]` grep-visibili (mai spezzati dal wrap) → applicata il 2026-07-17, commit f02e6bb
- Convenzione in `SETUP.md` §2 (uno slot da compilare sta su UNA sola riga fisica, o
  sfugge al `grep -rn "DA DEFINIRE AL SETUP" .` del setup e del Passo 4 dell'upgrade);
  sentinella `grep -rn "DA DEFINIRE AL$" .` come controllo 10 di `/lint-memory`, coi
  falsi positivi NOTI dichiarati (prosa-guida di `SETUP.md`, record IMP di `LEARNINGS.md`),
  così esclude la prosa senza sopprimere uno slot spezzato altrove. Chiude con la
  PREVENZIONE la classe di cui i fix 7fc8b8e/740b575 avevano sanato le sole istanze.

### IMP-032 — `hooks-install.sh`: FORCE_OVERWRITE robusto sul symlink dangling → applicata il 2026-07-17, commit d061f6c
- Nel ramo `FORCE_OVERWRITE=1`, guardia `[[ -e "${target}" ]]` (segue il link → FALSO
  solo sul dangling): il backup `.bak` si fa dove ha senso, il `rm -f` è comune ai due
  rami, i commenti di testata sono allineati (backup "saltato se dangling"). Test
  RED→GREEN hermetic `scripts/test-hooks-install.sh` (stub gitleaks/npx + repo
  usa-e-getta) e target `make test-scripts`; RED = abort di `cp -L`, GREEN = exit 0 +
  link rimosso + hook installato + nessun `.bak` vacuo.

### IMP-033 — Comando `/harvest-framework` + ponte progetto→framework → applicata il 2026-07-17, commit d2856be, c0df16c, f50816f, 534b41d
- MARCATURA: attributo `Destinazione: framework` nel formato IMP di `LEARNINGS.md` (riga
  fisica singola grep-abile; assente = lezione-di-progetto; moot nel repo-framework).
  COMANDO: `.claude/commands/harvest-framework.md` raccoglie le IMP marcate (default intero
  backlog + `$ARGUMENTS`) e stampa un blocco copiabile ANONIMIZZATO per la curatela umana —
  solo-leggi-e-stampa: nessun clone/copia/push/cross-repo (confine IMP-009, agnosticità);
  anti-vacuità sul caso vuoto; dimostrato su fixture. PONTE: sottosezione "Il ponte verso il
  framework" in docs/06; registrazione in CLAUDE.md + README (Struttura), cross-link in
  README Filosofia / SETUP §5 / CONTRIBUTING. Assessment read-only preliminare (workflow
  multi-agente) → decisione utente sui 4 punti strutturali. CHANGELOG `[Unreleased]` alla
  release via `/integrate`.

### IMP-034 — Il piano oneroso sul repo-framework vive nella nota di sessione, non in plans/ → applicata il 2026-07-17, commit da0e158 (A+C)
- Decisione utente: **A+C** (no B, no D). A (`docs/01`): riquadro "Regime ibrido del
  repo-framework" in FASE 2 — un deliverable oneroso NON crea file in `plans/` né registra
  in `decisions/`; il piano vive come voce IMP + nota di sessione + commit `[task N/T]`
  (stessi checkpoint), regola SPECIFICA (IMP-024) sulla generale nel solo ambito dichiarato;
  più patch allo step 1 di RIPRESA (guardava solo `plans/` → falso negativo nel regime
  ibrido). C (`sessions/README.md`): sotto-formato **blocco-piano** standardizzato
  (`## Piano (un commit per task)`), che risolve la divergenza prosa-vs-checklist delle due
  applicazioni interim. Scartate: D (lex specialis = astrazione prematura da n=1, vettore di
  drift) e B (`plans/` effimero, `git rm` dimenticabile). Cross-link `CONTRIBUTING.md`
  rimandato al deliverable README/CONTRIBUTING (fuori scope). Dogfood: questo deliverable ha
  applicato la stessa interim (3ª ricorrenza).

### IMP-035 — Disambiguazione "skill"/"comando"/tool `Skill` accanto a IMP-026 → applicata il 2026-07-17, commit ee5b0f8
- Risolta con UNA riga di nota terminologica accanto a IMP-026 (dove nasce la confusione):
  "comando" = file in `.claude/commands/` (ciò che il repo usa); la FEATURE `.claude/skills/`
  (IMP-026) non è adottata; l'harness chiama "skill" anche i comandi (naming di piattaforma).
  No glossario (overload occorso 1×); la distinzione è già load-bearing (IMP-037 la cita).

### IMP-036 — Provenance pin: registrare all'innesto la `vX` del framework → applicata il 2026-07-18, commit 6de868f
- Approvata nella retro mirata post-primo-upgrade-reale (brew v0.2.0→v0.5.1, 2026-07-17):
  baseline accertata A MANO per contenuto, e il 3-way di `hooks-install.sh` richiedeva la base
  per-versione — con `vX` sbagliata il merge esce corrotto in SILENZIO. Design D1-D6 approvato
  in blocco: [[2026-07-18-retro-mirata-imp-036-037]].
- Applicata in `SETUP.md`: pin `.claude/framework-version` (righe `chiave: valore` —
  `version`/`commit`/`grafted`, niente parser) creato al passo 1 di ogni innesto; QUARTA
  classe **"stato dell'innesto"** dichiarata esplicitamente nella tassonomia dell'upgrade
  (fuori da `memory/`: l'invariante diff-vuoto resta intatta); preferenza 0 del Passo 0
  (chiedi/stima/degrada restano come fallback pre-pin); riscrittura + RETROFIT in chiusura
  (Passo 6) — scioglie la non-retroattività; riquadro "Nessuna automazione" aggiornato (resta
  rimandato il solo `/upgrade-framework`, IMP-037); clausola nel CASO A (il pin mancante
  arriva dal retrofit, non si crea a mano). Zero nuovi tool/permessi; contenuto agnostico.

### IMP-038 — Controllo di completezza delle liste-inventario in /lint-memory → applicata il 2026-07-19, commit 2f69413
- Approvata in retro mirata dedicata (precondizione della valutazione v1.0), col design
  verificato in applicazione. Controllo 11 "Inventari vs realtà" in `lint-memory.md`:
  confronto insiemistico nei DUE versi (esiste-ma-non-elencato / elencato-ma-inesistente)
  tra le liste ENUMERATE — "Comandi rapidi" di CLAUDE.md; righe `commands/`/Makefile
  della "Struttura" del README, dove presenti; tabella di `scripts/README.md` — e il
  filesystem; mai le menzioni in prosa (l'enumerazione evita i falsi positivi
  lista-vs-prosa). Target di processo del Makefile per ancoraggio STRUTTURALE (ricetta
  che invoca `scripts/`; `help` escluso): sostituisce il criterio posizionale
  "sopra il banner [DA DEFINIRE]" del design iniziale — fragile perché il setup
  compila/rimuove il banner — e tiene i target di progetto del cliente fuori perimetro.
  Equivalenze di forma ammesse (`make reset-task` ≡ `./scripts/reset-task.sh`); esclusi
  per dichiarazione CHANGELOG e record IMP (stati passati, non inventari correnti).

### IMP-039 — Regime post-1.0 e definizione di «breaking change» per il framework → applicata il 2026-07-19, commit 4604da4
- Origine: deliverable di promozione a v1.0.0. Il regime post-1.0 esisteva in `docs/04`
  come sola tabella dei bump; mancavano (a) la DEFINIZIONE del criterio MAJOR — cos'è un
  breaking change per un progetto di METODO, non di codice — e (b) un inquadramento della
  1.0 non più come evento futuro. Applicata (user-directed nel deliverable, quindi diretta
  in Applicate): `docs/04` (template, agnostico) definisce breaking change sul *contratto
  pubblico* con esempi per progetti di codice e di metodo/tooling, e presenta i regimi come
  metodo permanente; `CONTRIBUTING.md` (doc NON-template del repo) porta il modello git a
  post-1.0 e la promessa concreta di breaking change per il framework (comando
  rimosso/rinominato, formato memoria/marcatori incompatibile, struttura che rompe
  innesti/upgrade). Scelta di design NON ovvia: lo status «siamo a 1.0» vive solo nei doc
  NON-template (`CONTRIBUTING`/`CHANGELOG`), mai nel template `docs/04`, per non rompere
  l'agnosticità. Commit doc `4604da4`, CHANGELOG `e8b7ad3`.

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
- Nota terminologica (IMP-035): "skill" è sovraccarico — "comando" = file in `.claude/commands/` (ciò che il repo usa); questa IMP riguarda la FEATURE `.claude/skills/` (non adottata); l'harness chiama "skill" anche i comandi (naming di piattaforma). Non confonderli.
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

### IMP-037 — Comando `/upgrade-framework` read-and-print (gemello inverso di `/harvest-framework`) → rimandata il 2026-07-17
- Decisione utente (retro periodica): RIMANDA (conferma). Un comando che SOLO LEGGE E STAMPA
  (confine di `/harvest-framework`/IMP-009) il piano di upgrade `vX→vY` — delta dal CHANGELOG,
  tassonomia per classe, blocco di riconciliazioni — senza scritture/merge/push né git
  cross-repo. Astrae la procedura manuale di `SETUP.md`, ma con 0 upgrade reali il pattern
  comune non è distillabile: automazione prematura (filtro anti-hype, come IMP-027 `graft.sh`).
- Trigger di ripresa: dopo 2-3 upgrade reali, quando il pattern comune è distillabile dal testo
  provato (D3 è il caso #1 dei 2-3 necessari; da solo NON fa scattare il trigger).
- **Caso #1 avvenuto** (annotazione retro mirata 2026-07-18): primo upgrade reale eseguito il
  2026-07-17 (brew, v0.2.0→v0.5.1) — vedi [[2026-07-18-retro-mirata-imp-036-037]]. Attrito
  osservato: il costo era nel GIUDIZIO file-per-file (decisioni R1/R3/R4/R5 + 3-way per-versione
  di `hooks-install.sh`), che un comando read-and-print non elimina; la procedura manuale di
  `SETUP.md` ha retto (invariante memoria rispettata, verifica funzionale hook dimostrata).
  Contatore: **1 di 2-3**, trigger NON scattato. Decisione utente: rimando CONFERMATO.

### IMP-042 — `/change-language` (automated translation command) → deferred on 2026-07-20
- User decision (language deliverable, phase 1): DEFER — same anti-hype filter as
  IMP-027 (`graft.sh`) and IMP-037 (`/upgrade-framework`). A command that
  automates switching a project's artifact language (or grafting the framework
  into a non-English context) is premature with a single manual translation
  behind us: the common pattern is not yet distillable.
- Trigger di ripresa: after 2-3 real manual uses (full translations or language
  switches performed by hand), when the repeatable steps are distillable from
  practice. The framework's own translation (IMP-041) is case #1 once completed.

## Rifiutate (con motivo — per non riproporle)
_(nessuna ancora)_
