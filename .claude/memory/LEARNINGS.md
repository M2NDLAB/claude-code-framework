---
type: learnings
updated: 2026-07-14
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

### IMP-027 — Percorso di setup brownfield (innesto su progetto esistente)
- Data: 2026-07-14 | Origine: primo innesto reale del framework su un progetto
  esistente (brew-manager, tool shell/zsh) — frizioni documentate in presa diretta
  nella nota d'innesto; verifica sui file reali in
  [[sessions/2026-07-14-registrazione-imp-innesto-brownfield]]
- Problema osservato: `SETUP.md` è interamente greenfield ("da template vuoto";
  unico cenno al preesistente: "git init (se non è già un repo)", r.28). Quattro
  gap verificati sui file:
  1. **Collisioni file**: il passo 1 impone di copiare `.gitignore` e `Makefile`
     senza istruzioni di merge (la checklist Root r.79-80 assume come base la
     copia del framework: "aggiungi i target", "decommenta/aggiungi"); nessuna
     regola "preserva il file dell'ospite, integra solo il necessario, segnala
     ogni collisione". La copertura esistente è solo per esclusione
     (LICENSE/CONTRIBUTING/CHANGELOG non si copiano, r.22-26); per `SECURITY.md`
     ("puoi copiarlo") non dice nulla se l'ospite ne ha già uno.
  2. **Memoria non popolata dall'esistente**: il primo comando (passo 4)
     inizializza solo STATE/TREE/INDEX; niente assessment read-only del codice
     esistente (maturità, difetti, test), niente note `components/` per i
     componenti preesistenti, niente decisioni retroattive in `decisions/`. Il
     pattern di IMP-011 (assessment → proposta → decisione, docs/00 r.49-53 e
     docs/01 r.28-35) copre la tecnica ma è agganciato ai deliverable con scelte
     strutturali, non al setup; il trigger di `components/README.md` ("alla
     nascita del componente") non contempla componenti nati prima dell'innesto.
  3. **`.claude/` preesistente ambiguo**: gli artefatti dell'harness (es.
     `settings.local.json` creato dalle approvazioni permessi) fanno esistere
     `.claude/` senza innesto precedente; SETUP/README non contemplano il caso e
     manca un criterio per distinguere CASO A (innesto precedente da riprendere)
     da CASO B (soli artefatti locali da preservare) — es. presenza di
     `CLAUDE.md` + `docs/` + `memory/` del framework, non il solo "esiste `.claude/`?".
  4. **Divergenze doc-vs-realtà dell'ospite** (README che documenta feature
     inesistenti): docs/06 LIVELLO 1 letto alla lettera ("allinea la doc alla
     realtà... applica direttamente") prescriverebbe di correggerle d'ufficio
     durante l'innesto — l'opposto dell'igiene di scope (docs/00: "si annota e
     si resta nello scope corrente"). La sezione "Debito documentazione" di
     STATE è definita solo per doc MANCANTE ("cosa andrà documentato e non lo è
     ancora"), non per doc esistente-ma-errata.
- Proposta: nuova sezione "Innesto su un progetto esistente (brownfield)" in
  `SETUP.md` (con rimando dal README), che NON tocca il flusso greenfield:
  (a) regola di riconciliazione file: preserva il file dell'ospite, integra solo
  il necessario del template, segnala ogni collisione all'utente;
  (b) passo di assessment read-only che POPOLA la memoria (STATE con stato e
  maturità reali, note `components/` dei componenti esistenti, decisioni
  retroattive in `decisions/`): il pattern di IMP-011 promosso a passo esplicito
  del setup brownfield;
  (c) criterio CASO A/CASO B per `.claude/` preesistente (cosa guardare oltre
  all'esistenza della cartella, cosa preservare in entrambi i casi);
  (d) destinazione delle divergenze doc-vs-realtà dell'ospite: "Debito
  documentazione" di STATE (allargandone la definizione alla doc
  esistente-ma-errata) + chiarimento in docs/06 che il LIVELLO 1 riguarda la doc
  del METODO/configurazione, non la doc dell'ospite durante l'innesto.
  **OPZIONE da valutare (filtro anti-hype), NON decisa**: uno script
  `scripts/graft.sh` che automatizza l'innesto (copia il sottoinsieme giusto,
  azzera LEARNINGS/sessions, lancia il gitleaks detect one-off di IMP-028,
  gestisce gli hook esistenti). Pro: passi meccanici ripetibili, niente
  dimenticanze, stessa famiglia di `reset-task.sh`. Contro: le collisioni sono
  DECISIONI umane non automatizzabili (lo script può solo rilevarle), casi limite
  costosi da mantenere, rischio di falsa sicurezza; la sezione documentata può
  bastare, e lo script può nascere DOPO, distillato dal testo provato su 2-3
  innesti reali.
- Beneficio atteso / rischio: ogni prossimo innesto non riscopre le stesse
  frizioni (questa volta documentate a mano, in presa diretta). Rischio:
  appesantire SETUP.md per chi parte greenfield — mitigato dalla sezione
  separata in coda.
- Trigger di ripresa: se rimandata, il prossimo innesto su un progetto esistente
  la riporta in gioco (le frizioni si ripresenterebbero identiche).

### IMP-028 — Igiene git ereditata all'innesto (tag, storia, branch, hook)
- Data: 2026-07-14 | Origine: primo innesto reale del framework su un progetto
  esistente (brew-manager) — vedi
  [[sessions/2026-07-14-registrazione-imp-innesto-brownfield]]
- Problema osservato: quattro tensioni git/hook specifiche del brownfield, tutte
  verificate come scoperte:
  1. **Tag ereditati**: docs/04 impone tag annotati per i tag NUOVI (r.96-100,
     razionale: `git describe`) e IMP-010 copre l'igiene dei tag che si CREANO;
     nulla sui tag preesistenti. Su tag lightweight ereditati `/integrate` non si
     rompe ma DEGRADA in silenzio: usa `git describe --tags` (integrate.md
     r.20-21), che accetta anche i lightweight e qualunque nome non-SemVer come
     base del calcolo versione, senza guardie — in tensione con "mai tag leggeri"
     (il razionale di docs/04 vale per `git describe` senza `--tags`). Osservato
     inoltre il drift tra una costante di versione hard-coded in uno script
     dell'ospite e i tag: nessuna regola lo intercetta.
  2. **Storia mai scansionata**: l'hook esegue `gitleaks protect --staged`
     (hooks-install.sh r.32) = solo commit futuri; la baseline di docs/03 r.5-7
     ("nessun secret in chiaro entra nel repo") è sovra-promettente su un
     brownfield, dove la storia pre-innesto resta non verificata. Nessun
     `gitleaks detect` in tutto il framework (grep vuoto). Aggancio: è il
     completamento naturale della baseline di docs/03, non una regola nuova.
  3. **Topologia branch ereditata**: la meccanica parametrica esiste (IMP-008:
     ruoli, trunk-based previsto in docs/04 r.8-14) ma SETUP.md r.28 istruisce
     incondizionatamente a CREARE il branch di integrazione: nessuna guida a
     decidere-e-dichiarare davanti a un branch remoto dormiente (es. un
     `origin/dev` stantio): riattivarlo come integrazione o dichiarare
     trunk-based. L'unico esempio di scelta dichiarata è CONTRIBUTING.md
     (r.31-45), che per istruzione di SETUP r.22-26 NON si copia: non raggiunge
     chi fa il setup.
  4. **Hook preesistenti sovrascritti**: hooks-install.sh fa `cat >`
     incondizionato su pre-commit/commit-msg (r.26, 65): distrugge hook esistenti
     (husky, pre-commit framework) senza backup/merge/abort; e se l'ospite usa
     `core.hooksPath` (husky), gli hook del framework finiscono in `.git/hooks`
     che git IGNORA = installati ma inerti. Il commento in testa (r.6:
     "sovrascrive gli hook precedenti installati da questo script") promette
     meno di ciò che lo script fa davvero.
- Proposta: checklist "igiene git ereditata" dentro la sezione brownfield di
  SETUP.md (vedi IMP-027):
  (a) audit dei tag ereditati (`git cat-file -t` su ciascun tag: annotati vs
  lightweight; individuare la base SemVer da cui riparte il regime di docs/04;
  eventuale normalizzazione = decisione utente) + nota nel passo 1 di
  integrate.md: verificare che la base restituita da `git describe --tags` sia
  un tag SemVer sano prima di calcolare il bump, e correzione DESCRITTIVA del
  razionale impreciso di docs/04 (*Versioning*): `git describe` senza `--tags`
  usa i soli tag annotati, mentre `/integrate` usa `--tags` che accetta anche i
  lightweight — da cui la guardia. Nessun obbligo nuovo: la regola "mai tag
  leggeri" resta invariata; regola per le costanti di
  versione negli script dell'ospite (allinearle o derivarle dai tag);
  (b) `gitleaks detect` one-off sull'intera storia come passo del setup
  brownfield; esito registrato, finding → decisione utente (la storia pushata
  non si riscrive alla leggera);
  (c) passo "decidi e dichiara la topologia" (trunk-based vs ripristino del
  branch dormiente), registrato nei [DA DEFINIRE AL SETUP] di docs/04 e nei
  parametri di checkpoint/integrate;
  (d) hooks-install.sh: rilevare hook preesistenti e `core.hooksPath` PRIMA di
  scrivere — avvisare e fermarsi (o backup `.bak` + istruzioni di merge), e
  correggere il commento impreciso in testa allo script.
- Beneficio atteso / rischio: (b) chiude un buco di sicurezza reale (secret
  storici mai visti da nessuno strumento); (d) evita di distruggere la pipeline
  dell'ospite o di installare hook inerti credendoli attivi. Rischio:
  hooks-install.sh più complesso — mitigato: il rilevamento è poche righe e
  fallisce in modo parlante.
- Trigger di ripresa: se rimandata, il prossimo innesto su un repo con storia
  (per la (d): il primo ospite con husky o hook propri).

### IMP-029 — Convivenza linguistica dichiarata (framework vs progetto)
- Data: 2026-07-14 | Origine: primo innesto reale (brew-manager): framework in
  italiano, doc pubblica dell'ospite in inglese — convivenza decisa al volo,
  senza una casa nelle regole
- Problema osservato: il framework è interamente in italiano ma non lo dichiara
  mai come scelta; nessuna voce "lingua" nella checklist di SETUP.md né tra gli
  esempi delle "Regole tecniche specifiche del progetto" di CLAUDE.md (grep
  `lingua|italian|english|bilingu` → solo "linguaggio" di programmazione). Non è
  un problema solo brownfield: si pone identico in greenfield con doc pubblica
  in inglese — per questo è una IMP a sé e non una riga di IMP-027 (portata più
  ampia, punto di applicazione diverso).
- Proposta: voce "lingua/e del progetto" tra gli esempi della sezione "Regole
  tecniche specifiche del progetto" di CLAUDE.md e checkbox nella checklist di
  SETUP.md passo 2: quale lingua per memoria/processo (default: quella del
  framework), quale per README/doc pubblici dell'ospite; una riga di rimando
  nella sezione brownfield di IMP-027.
- Beneficio atteso / rischio: decisione esplicita invece di deriva incoerente
  nota-per-nota. Rischio: nullo (una voce di checklist e un esempio).
- Trigger di ripresa: se rimandata, il prossimo progetto con doc pubblica in
  lingua diversa da quella del framework.

### IMP-030 — Compilazione dei [DA DEFINIRE AL SETUP] assistita da Claude Code
- Data: 2026-07-14 | Origine: segnalazione utente al primo innesto (vale in
  greenfield e brownfield, NON è specifica del brownfield)
- Problema osservato: SETUP.md passo 2 e README "Come si usa" punto 2 sono
  formulati come istruzioni manuali all'umano ("Riempi i [DA DEFINIRE AL
  SETUP]", grep manuale, checklist, "15-30 minuti... per compilare le regole
  tecniche"). Il massimo ruolo documentato di Claude Code è passivo: "segnalami
  eventuali [DA DEFINIRE] ancora aperti" (SETUP r.103). L'alternativa reale e
  già praticabile — Code li vede, chiede i valori in dialogo e scrive le
  risposte nei file giusti — non è offerta da nessuna parte (grep su
  chied/compil/dialogo: nulla). Nulla la vieta: docs/06 vieta i cambi di REGOLE
  in autonomia, non la compilazione di placeholder su risposte dell'utente; e lo
  stesso primo comando fa già scrivere a Code STATE/TREE/INDEX.
- Proposta: in SETUP.md passo 2 dichiarare le DUE modalità equivalenti — (a) a
  mano con la checklist; (b) in dialogo: chiedi a Claude Code di intervistarti
  sui [DA DEFINIRE AL SETUP] (guidato dalla checklist esistente) e di scrivere
  le risposte — ed estendere il primo comando del passo 4 con la variante
  corrispondente; una riga allineata in README punto 2.
- Beneficio atteso / rischio: onboarding più rapido; le risposte finiscono nei
  file giusti senza che l'utente debba conoscere la mappa dei marcatori.
  Rischio: compilazione superficiale se le risposte sono frettolose — mitigato:
  l'intervista segue la checklist esistente e i marcatori senza risposta restano
  `[DA DEFINIRE AL SETUP]` (nessuna invenzione).
- Trigger di ripresa: se rimandata, il prossimo setup di un progetto (greenfield
  o brownfield).

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

## Rifiutate (con motivo — per non riproporle)
_(nessuna ancora)_
