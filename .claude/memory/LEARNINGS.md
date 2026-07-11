---
type: learnings
updated: 2026-07-11
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

> Le IMP-009..026 vengono dal consolidamento del 2026-07-11 (assessment completo:
> [[sessions/2026-07-11-consolidamento-assessment]]). Le IMP-009..020 sono
> meccaniche/a basso rischio; le IMP-021..026 richiedono una DECISIONE dell'utente.

### IMP-009 — Confine di esecuzione git dichiarato + regole per i blocchi comandi destinati all'utente
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole A1–A3 + D20)
- Problema osservato: il confine "chi esegue cosa" è implicito ma mai DICHIARATO come
  regola unica: docs/04 e `/integrate` dicono che push/merge/tag sono azione umana, ma
  nessun doc dice che i comandi git LOCALI (commit, amend, `rm --cached`, branch locali)
  li esegue Claude Code mentre la STORIA CONDIVISA la tocca solo l'utente — l'ambiguità
  su questo confine causa incidenti. Mancano inoltre tre regole sui blocchi di comandi
  per l'utente: (a) valori REALI (SHA/branch/versione letti da `git log`/`git tag`), mai
  placeholder nudi — oggi lo fa solo `/integrate` al proprio interno, non è una regola
  generale; (b) comandi DISTRUTTIVI (`tag -d`, `branch -D`, `reset --hard`, `push
  --force`, `rm`) mai inline in un blocco copia-incolla con comandi costruttivi: blocco
  separato + condizione esatta che li giustifica ("solo se <comando> fallisce"); (c) i
  placeholder nei comandi per l'ESECUTORE (che li risolve) non vanno mai passati
  all'utente (che non deve risolverli).
- Proposta: nuova sottosezione "Confine di esecuzione e blocchi per l'utente" in
  `04-git-workflow.md` (dopo "Regole operative per Claude Code") con i quattro punti
  sopra; verifica di conformità del blocco di `/integrate` (già conforme sui valori
  reali; `git branch -d` può restare inline perché safe per costruzione).
- Beneficio atteso / rischio: elimina la classe di incidenti "comando distruttivo
  eseguito per inerzia" e i blocchi non incollabili. Rischio nullo: codifica la prassi
  già esistente.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-010 — Igiene dei tag e verifica pre-push
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole A4–A5)
- Problema osservato: docs/04 *Versioning* e `/integrate` non prescrivono: tag digitato
  a mano con un solo `-m` breve ASCII (em-dash/accenti/NBSP da copia-incolla corrompono
  il tag — il rischio è già emerso: commit 4c30dd1 ha corretto l'esempio); verifica
  `git rev-parse <tag>` SEMPRE prima del push; `tag -d` SOLO se `rev-parse` fallisce,
  mai su un tag sano. Manca anche la verifica pre-push: `git log origin/<branch>..<branch>`
  prima di pushare su un branch condiviso — un push trascina TUTTI i commit locali, non
  solo l'ultimo.
- Proposta: `04-git-workflow.md` *Versioning* (tre righe su tag a mano / ASCII /
  `rev-parse` / `tag -d` condizionato) + blocco di `/integrate`: aggiungere al passo 4
  la verifica `git rev-parse v<X.Y.Z>` prima dei push e un passo 0 "verifica cosa stai
  per pubblicare: `git log origin/<integrazione>..<integrazione>`".
- Beneficio atteso / rischio: previene tag corrotti pushati e push di commit non
  intenzionali. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-011 — Fasi a monte del deliverable: assessment → design → decisioni/ADR → piano
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regola B6)
- Problema osservato: il ciclo (docs/00) parte da "valuta onerosità → piano → esegui":
  per i deliverable con scelte STRUTTURALI mancano le fasi a monte — assessment in sola
  lettura, design, decisioni dell'utente, ADR/decisione registrata, POI il piano.
  `decisions/README.md` definisce DOVE registrare le decisioni ma nessun doc dice QUANDO
  nel flusso.
- Proposta: `00-overview.md` "Il ciclo di lavoro" + `01-task-planning.md`: per i prompt
  onerosi che comportano scelte strutturali, il piano è PRECEDUTO da assessment
  read-only → proposta con alternative → decisione utente → registrazione in
  `decisions/` (o ADR) → piano che PUNTA alla decisione. Per i task piccoli resta tutto
  com'è (stessa soglia di onerosità, niente burocrazia).
- Beneficio atteso / rischio: decisioni tracciate prima dell'implementazione, meno
  rework. Rischio: burocratizzare i task medi — mitigato legando la fase alla presenza
  di scelte strutturali, non alla sola dimensione.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-012 — Scope discipline e igiene di sessione
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole B8–B9)
- Problema osservato: nessuna regola dice: (a) un cambiamento alla volta, niente "già
  che ci siamo" — le pulizie incidentali si estraggono solo se hanno impatto reale (un
  bug), non a strascico; (b) `/clear` (o nuova sessione) tra deliverable SCOLLEGATI;
  (c) documentazione scollegata dal feature branch corrente va su branch/worktree
  separato. Nota di coerenza: la regola 5 di CLAUDE.md (doc aggiornata INSIEME alle
  modifiche) riguarda la doc COLLEGATA al cambiamento e resta valida — nessun conflitto.
- Proposta: breve sottosezione "Igiene di scope e di sessione" in `00-overview.md`
  (oppure in `01-task-planning.md` FASE 1) con i tre punti.
- Beneficio atteso / rischio: diff piccoli e tematici, review più facili, meno
  contaminazione di contesto tra deliverable. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-013 — Memoria su disco come contratto: persistere PRIMA di /clear o cambio modello; prompt che puntano
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole C10–C12 + E22)
- Problema osservato: il framework ha i contenitori (plans/, sessions/, decisions/) ma
  non il PRINCIPIO operativo: (a) finché una decisione vive solo in chat, ogni prompt
  successivo deve ripeterla; una volta su disco, il prompt ci PUNTA ("esegui il task N
  del piano") e si riduce a 3 righe — investire nell'ADR/piano all'inizio accorcia
  tutti i prompt dopo; (b) il lavoro costoso (assessment, review lunghe) va persistito
  SUBITO in nota di sessione, PRIMA di `/clear` o di un cambio modello (che perdono il
  contesto di chat), o si ripaga a caro prezzo; (c) un prompt di ripresa dà il compito
  direttamente e punta alla nota — non deve produrre un turno a vuoto ("attendo
  istruzioni") se il compito è già definito.
- Proposta: `00-overview.md` pilastro "Memoria persistente" (3-4 righe sul principio) +
  `01-task-planning.md` sezione RIPRESA (punto sul prompt di ripresa) +
  `sessions/README.md` "Quando si scrive": anche PRIMA di `/clear`/cambio modello se
  c'è lavoro costoso non ancora persistito.
- Beneficio atteso / rischio: prompt corti, nessun assessment perso, ripresa in un
  turno. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-014 — Debiti con trigger esplicito e sopravvivenza alle riscritture di STATE.md
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole C13–C14)
- Problema osservato: (a) i debiti in STATE.md ("Attenzione / problemi aperti") sono
  voci generiche: senza un TRIGGER esplicito ("X → precondizione bloccante di Fase Y")
  affogano nel rumore invece di riemergere al momento giusto; LEARNINGS.md ha già il
  campo "Trigger di ripresa" per le Rimandate, STATE.md no; (b) STATE.md si RISCRIVE a
  ogni `/checkpoint` e nessun passo verifica che i debiti critici SOPRAVVIVANO alla
  riscrittura; (c) la coerenza cross-file (una lezione in LEARNINGS presente anche nei
  debiti di STATE e viceversa) non è tra i controlli di `/lint-memory`.
- Proposta: template `STATE.md` (formato voce di debito con trigger), `checkpoint.md`
  passo 3 (dopo la riscrittura di STATE: verifica esplicita che le voci di attenzione
  preesistenti siano presenti o consapevolmente chiuse), `lint-memory.md` nuovo
  controllo "coerenza LEARNINGS ↔ STATE".
- Beneficio atteso / rischio: i debiti riemergono quando servono e non si perdono nelle
  riscritture. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-015 — Verificare su artefatti reali; test che DIMOSTRANO (RED→GREEN, invarianti per costruzione)
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole D15–D17)
- Problema osservato: docs/02 non copre tre pattern di verifica: (a) mai derivare
  decisioni dalla memoria o da un debito registrato quando l'artefatto è su disco — un
  debito può essere registrato con la CAUSA SBAGLIATA: verificarla (grep/lettura) prima
  di eseguirlo alla lettera; (b) un test verde può passare per la ragione sbagliata: il
  fix va provato in modo che DIMOSTRI la catena reale (RED→GREEN isolando la variabile),
  non con un generico "i test passano" (che potrebbero passare anche col bug); (c) dove
  conta (sicurezza/compliance), test come INVARIANTI riapplicate per COSTRUZIONE (es.
  reflection che asserisce una proprietà su TUTTE le entità, con controllo anti-vacuità),
  non asserzioni sullo stato noto oggi — così una regressione futura rompe il build.
- Proposta: `02-code-quality.md` — un punto in "Best practices" (verifica su artefatti
  reali prima di decidere) + micro-sezione "Test che dimostrano" (o estensione del punto
  3 della Definition of Done) con RED→GREEN e invarianti per costruzione.
- Beneficio atteso / rischio: elimina fix su diagnosi sbagliata e regressioni invisibili
  ai test-fotografia. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-016 — Review adversariale mirata al raggio di propagazione; completezza dei finding prima di agire
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regole D18–D19)
- Problema osservato: docs/03 definisce il gate ma non dice: (a) QUANDO la review deve
  essere adversariale (autore≠giudice): su codice di SICUREZZA in moduli CONDIVISI, dove
  un difetto si propaga a più consumer — NON su ricognizioni fattuali o fix locali
  ispezionabili, dove l'autore-che-verifica basta e l'adversariale è overhead; lo scope
  è il RAGGIO DI PROPAGAZIONE del difetto, non la severità nominale; (b) prima di AGIRE
  sui finding di una review multi-agente (specie dopo interruzioni/resume) va verificata
  la completezza: la fonte autoritativa è la SINTESI della review, non i conteggi grezzi
  del journal (gonfiabili dai retry).
- Proposta: `03-security-gate.md` — sottosezione "Quando la review deve essere
  adversariale" + nota "Prima di agire sui finding" dopo "La meccanica del gate".
- Beneficio atteso / rischio: rigore dove il difetto si propaga, niente overhead dove
  non serve. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-017 — Modello/effort per task: alto dove la correttezza ha conseguenze
- Data: 2026-07-11 | Origine: consolidamento (INPUT 1, regola E21)
- Problema osservato: nessuna indicazione su quale modello/effort usare per tipo di
  lavoro: alto effort per il ragionamento ad alto rischio (implementazione sensibile,
  security review, analisi adversariale); standard per lettura, scrittura strutturata su
  decisioni già prese, chore. Sprecare l'effort alto su lettura/doc costa; lesinarlo
  dove la correttezza ha conseguenze costa di più.
- Proposta: 3-4 righe in `00-overview.md` (accanto all'igiene di sessione di IMP-012, se
  passa) come GUIDA, non regola rigida — l'indicazione dipende dagli strumenti del
  momento e non deve invecchiare male.
- Beneficio atteso / rischio: qualità dove serve, costo/latenza risparmiati altrove.
  Rischio: indicazione tool-dependent — mitigato tenendola come principio ("effort
  proporzionale alle conseguenze dell'errore"), senza nomi di modelli.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-018 — Trigger dichiarato per /lint-memory + correzioni fattuali minori (Livello 1)
- Data: 2026-07-11 | Origine: consolidamento (INPUT 2, riverificato sui file)
- Problema osservato: (a) CONFERMATO: `/lint-memory` non ha un trigger dichiarato né nel
  ciclo (`00-overview.md`) né in `lint-memory.md` — gap simmetrico a quello risolto da
  IMP-007 per `/retro`; (b) CONFERMATO: la legenda-esempio di `TREE.md` (riga 35) elenca
  5 comandi su 7 (mancano `/integrate` e `/lint-memory`) — claim stantio nel template;
  (c) CONFERMATO (in forma attenuata): SETUP.md §2 ha già la checklist per compilare
  `new-component.md`, ma non avvisa che il comando è INERTE finché la sezione tecnica di
  CLAUDE.md non è compilata.
- Proposta: (a) `00-overview.md`: dichiarare il trigger di `/lint-memory` (periodico,
  tipicamente insieme alla retro periodica sul backlog, e dopo eventi che toccano molte
  note: merge grossi, ristrutturazioni della memoria) + riga equivalente in
  `lint-memory.md`; (b) `TREE.md` riga 35: sostituire l'elenco con un rimando a
  "CLAUDE.md → Comandi rapidi" (evita il prossimo drift) o completarlo a 7; (c) SETUP.md
  §2, riga `new-component.md`: mezza riga "(finché non compilato, `/new-component` è
  inerte)". Le voci (b) e (c) sono correzioni fattuali Livello 1, incluse qui solo per
  tracciabilità del consolidamento.
- Beneficio atteso / rischio: il lint smette di essere un comando senza momento d'uso;
  template senza claim stantii. Rischio nullo.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-019 — Riconciliare "feature→integrazione SEMPRE via PR" con il blocco merge locale di /integrate
- Data: 2026-07-11 | Origine: consolidamento (tensione interna trovata in FASE 1.4)
- Problema osservato: contraddizione interna al framework: `04-git-workflow.md` "Merge"
  impone "Feature → develop: SEMPRE via Pull Request, mai merge locale diretto", ma
  `/integrate` stampa un blocco di MERGE LOCALE (`git merge --no-ff`) che l'utente
  esegue — è il flusso reale del framework per lo sviluppatore singolo, e non è coperto
  dalla regola. Un `/lint-memory` onesto la rileverebbe a ogni passaggio.
- Proposta: `04-git-workflow.md` "Merge": parametrizzare — via PR quando esiste un
  flusso di review remoto/team; via blocco `/integrate` (merge locale `--no-ff` eseguito
  dall'UTENTE) nel flusso a sviluppatore singolo; in entrambi i casi il confine resta:
  Claude Code non mergia. Quale dei due adotta il progetto → `[DA DEFINIRE AL SETUP]`.
- Beneficio atteso / rischio: elimina una contraddizione tra doc e comando. Rischio
  nullo: entrambe le prassi restano lecite, ma dichiarate.
- Trigger di ripresa: approvazione in questa retro (meccanica).

### IMP-020 — Hook PreToolUse gitleaks decorativo: non può mai bloccare
- Data: 2026-07-11 | Origine: consolidamento (lettura di `.claude/settings.json`)
- Problema osservato: l'hook PreToolUse su Write|Edit esegue `gitleaks protect --staged
  --no-banner 2>/dev/null || echo 'WARN: gitleaks non installato...'`. Tre difetti:
  (a) l'`||` inghiotte ANCHE l'exit non-zero di un leak trovato, stampando per giunta il
  warning sbagliato ("non installato"); (b) l'exit finale è sempre 0, quindi l'hook non
  può MAI bloccare (per bloccare un PreToolUse serve exit 2); (c) scansiona l'area
  STAGED al momento di Write/Edit, quando la modifica non è ancora staged — bersaglio
  sbagliato. È un no-op che dà falsa sicurezza, e viola in piccolo la regola del
  framework stesso ("mai inghiottire un errore", docs/02). La difesa reale resta il
  pre-commit hook di `hooks-install.sh`.
- Proposta: due opzioni — (1) RIMUOVERE l'hook PreToolUse (semplicità: la baseline è il
  pre-commit); (2) sostituirlo con uno script che distingue gitleaks-assente (warn,
  exit 0) da leak-trovato (exit 2 → blocca) e scansiona il contenuto giusto (es.
  `gitleaks detect --no-git` sul file target). Consigliata la (2) se si vuole difesa in
  profondità, la (1) altrimenti.
- Beneficio atteso / rischio: niente falsa sicurezza; coerenza con le regole di error
  handling del framework. Rischio: la (2) aggiunge uno script da mantenere.
- Trigger di ripresa: approvazione in questa retro (meccanica, ma tocca settings.json →
  serve comunque l'ok esplicito dell'utente per la via scelta).

### IMP-021 — Licenza a due livelli: LICENSE reale sul repo-framework + placeholder nel template ⚖️ DECISIONE
- Data: 2026-07-11 | Origine: consolidamento (INPUT 3)
- Problema osservato: il repo-framework è pubblico su GitHub SENZA licenza → per default
  legale è "all rights reserved": nessuno può riusare il template legittimamente, in
  contraddizione con l'intento dell'utente (uso/modifica liberi, collaborazione gradita
  non obbligatoria, NO copyleft). Inoltre il template non prevede il punto "licenza del
  progetto" tra i `[DA DEFINIRE AL SETUP]`: i due livelli (licenza del framework ≠
  licenza che ogni progetto-cliente sceglierà) oggi non sono distinti da nessuna parte.
- Proposta: (a) livello repo-framework: `LICENSE` REALE alla root — default consigliato
  **MIT** (massima semplicità e adozione; niente copyleft). Alternative con trade-off:
  **Apache-2.0** (concessione esplicita di brevetti + meccanica NOTICE — più tutelante
  in contesti corporate, ma più lunga e con più attrito); **BSD-3-Clause** (≈MIT + clausola
  no-endorsement, senza patent grant). Per un template metodologico (testo + script di
  processo, niente codice brevettabile) MIT è adeguata. Holder copyright e anno:
  da fornire dall'utente (altrimenti restano da definire e il file NON si crea);
  (b) livello template: riga "Licenza del progetto: [DA DEFINIRE AL SETUP]" in CLAUDE.md
  (sezione regole tecniche) + checklist in SETUP.md §2 Root + nota in SETUP.md §1: la
  LICENSE del framework NON si copia nel progetto-cliente (la sua licenza è una scelta
  sua).
- Beneficio atteso / rischio: il riuso diventa legalmente possibile; i due livelli
  smettono di confondersi. Rischio: scelta difficilmente reversibile una volta che
  qualcuno ha forkato — per questo la decide l'utente.
- Trigger di ripresa: DECISIONE UTENTE in questa retro (licenza + holder + anno).

### IMP-022 — SECURITY.md, CONTRIBUTING.md, CHANGELOG.md del repo-framework ⚖️ DECISIONE
- Data: 2026-07-11 | Origine: consolidamento (INPUT 3)
- Problema osservato: mancano tutti e tre; per ciascuno va distinto il livello
  repo-framework (contenuto reale) dallo scaffold per il cliente (placeholder).
- Proposta:
  - `SECURITY.md` — ENTRAMBI i livelli: scheletro generico (come segnalare una
    vulnerabilità, cosa aspettarsi, aggancio alla baseline gitleaks e al gate docs/03
    SENZA duplicarli) con canale di contatto e versioni supportate `[DA DEFINIRE AL
    SETUP]`; per il repo-framework indicare come canale reale la segnalazione privata di
    GitHub (Security Advisories), evitando di committare un'email.
  - `CONTRIBUTING.md` — livello repo-framework, contenuto REALE: "collaborazione gradita,
    non obbligatoria"; il workflow effettivo del repo (Conventional Commits verificati da
    commitlint, feature branch, ciclo di fine deliverable di docs/00, cambi di regole
    solo via proposta IMP in LEARNINGS.md); rimando a SETUP.md per chi vuole USARE il
    template invece che contribuirvi. È anche il posto naturale dove dichiarare il
    modello di branching del repo (vedi IMP-025 — sinergia).
  - `CHANGELOG.md` — livello repo-framework, formato Keep a Changelog agganciato al
    SemVer di docs/04 (fit naturale: storia IMP già tracciata). Consigliato: voce
    retroattiva `v0.1.0` (sintesi da conventional commit e IMP-001..008) + sezione
    `Unreleased`; e cablare l'aggiornamento del CHANGELOG come passo di `/integrate`
    (prima del blocco) — è un cambio di comando, incluso in questa IMP.
  - Aggiornare `README.md` (diagramma struttura) e `SETUP.md` §1 (questi file NON si
    copiano nel cliente, salvo `SECURITY.md` come scaffold).
- Beneficio atteso / rischio: il repo diventa un progetto pubblico completo senza
  toccare l'agnosticità del template. Rischio: CHANGELOG = manutenzione a ogni release
  (mitigato cablandolo in `/integrate`).
- Trigger di ripresa: DECISIONE UTENTE in questa retro (ok ai tre file + scelta
  retroattivo-vs-solo-Unreleased per il CHANGELOG).

### IMP-023 — CODE_OF_CONDUCT.md e template .github/: rimandare con trigger ⚖️ DECISIONE
- Data: 2026-07-11 | Origine: consolidamento (INPUT 3, filtro anti-hype)
- Problema osservato: mancano, ma il filtro «problema reale o hype?» chiede se servono
  ORA: il repo non ha oggi un flusso di contributi esterni osservabile; un Code of
  Conduct e i template issue/PR senza comunità sono cerimonia.
- Proposta (consigliata): RIMANDARE entrambi con trigger esplicito. Se invece si vuole
  crearli ora: CODE_OF_CONDUCT = Contributor Covenant v2.1 con contatto placeholder
  `[DA DEFINIRE AL SETUP]`; `.github/` con ISSUE_TEMPLATE e PULL_REQUEST_TEMPLATE minimi
  allineati a Conventional Commits e al ciclo di fine deliverable.
- Beneficio atteso / rischio: niente file-vetrina da mantenere; si creano quando c'è chi
  li usa. Rischio: se un contributore arriva prima del trigger, si crea al volo (costo
  basso).
- Trigger di ripresa: primo issue/PR di un contributore esterno reale, oppure decisione
  dell'utente di pubblicizzare il repo.

### IMP-024 — Dogfooding: il repo-framework usa la propria memoria su di sé? ⚖️ DECISIONE
- Data: 2026-07-11 | Origine: consolidamento (INPUT 2, decisione architetturale aperta)
- Problema osservato: stato IBRIDO non dichiarato: `LEARNINGS.md` è REALE (IMP-001..008
  applicate + queste), ma `STATE.md`/`TREE.md`/`INDEX.md` sono template puri e
  `sessions/` era vuota nonostante ~14 commit di lavoro reale sul framework — per le
  regole del framework stesso ("un task senza memoria aggiornata NON è finito") il repo
  violerebbe se stesso. In più chi copia il template EREDITA le IMP del framework dentro
  `LEARNINGS.md` (SETUP.md non dice di svuotarlo) e gli hook git del repo NON risultano
  installati localmente (`make hooks-install` mai eseguito qui: la disciplina
  commitlint è stata tenuta a mano).
- Trade-off delle tre opzioni:
  1. **Dogfooding pieno** — il framework si auto-valida, le lezioni emergono dall'uso;
     MA i file memoria smettono di essere template puliti da copiare → servirebbe
     separare template da istanza (`*.template.md` o simili) = complessità strutturale.
  2. **Template puro** — file sempre puliti, copia banale; MA LEARNINGS reale andrebbe
     spostato altrove e il repo rinuncia all'auto-validazione; resta senza risposta come
     tracciare il lavoro sul framework stesso.
  3. **Ibrido dichiarato** (status quo, ma governato) — SOLO `LEARNINGS.md` e
     `sessions/` sono vivi nel repo-framework (è il loop della "Filosofia" del README:
     le lezioni tornano al template); STATE/TREE/INDEX restano template; SETUP.md
     istruisce di SVUOTARE le sezioni di LEARNINGS (e sessions/) alla copia; una riga in
     README (o CONTRIBUTING, se IMP-022 passa) dichiara quali file sono vivi.
- Proposta consigliata: opzione 3 (minimo sforzo, coerente con l'uso reale già in atto)
  + in ogni caso il fix SETUP.md ("svuota LEARNINGS/sessions alla copia"), necessario
  con qualunque opzione.
- Beneficio atteso / rischio: l'ambiguità smette di generare incoerenze rilevate a ogni
  lint. Rischio: l'opzione 3 accetta che STATE non descriva mai il repo-framework — va
  dichiarato per non sembrare drift.
- Trigger di ripresa: DECISIONE UTENTE in questa retro.

### IMP-025 — Dichiarare il modello di branching del repo-framework + regole per la storia condivisa ⚖️ DECISIONE
- Data: 2026-07-11 | Origine: consolidamento (INPUT 2, riverificato su git reale)
- Problema osservato: il finding "storia lineare su main senza feature branch/merge
  --no-ff" è SMENTITO in parte dai fatti: il blocco IMP-001..008 è passato da un branch
  mergiato con merge commit a due parent (`6a1fe9e`). Restano però quattro punti:
  (a) il merge è stato locale e diretto su `main`, senza PR — in tensione con docs/04
  finché IMP-019 non parametrizza; (b) il repo non DICHIARA da nessuna parte il proprio
  modello (trunk-based: `main` = integrazione = stabile; il tag pre-1.0 `v0.1.0` su
  `main` è coerente col regime pre-1.0 di docs/04 SOLO se `main` è dichiarato branch di
  integrazione); (c) il messaggio del merge — "feat: lezioni di metodo + ciclo fine
  deliverable da VORTEX" — non segue il formato merge di docs/04 (manca lo scope e la
  parola "merge") e trascina il nome di un progetto SPECIFICO (VORTEX) nella storia
  condivisa di un template agnostico: non riscrivibile (già pushato), evitabile in
  futuro; (d) su origin esiste un branch residuo `origin/master` stantio (punta al
  commit pre-template `3b4f6d8`), accanto a `origin/main`.
- Proposta consigliata: dichiararla ECCEZIONE VOLUTA e formalizzarla: il repo-framework
  è trunk-based (i due RUOLI di docs/04 coincidono in `main`), merge dei deliverable via
  blocco `/integrate` eseguito dall'utente, tag pre-1.0 su `main`. Dove: CONTRIBUTING.md
  (se IMP-022 passa) o README. In più: micro-regola "niente nomi di progetti specifici
  nei messaggi destinati alla storia condivisa del template" (docs/04 o CONTRIBUTING) e
  pulizia di `origin/master` — azione UTENTE su storia condivisa, da eseguire in FASE 3
  come blocco SEPARATO con verifica preventiva (`git log origin/master -1`), mai inline.
- Beneficio atteso / rischio: la "violazione" diventa un'eccezione dichiarata e
  verificabile; la storia futura resta agnostica. Rischio: la cancellazione di
  `origin/master` è irreversibile — per questo resta all'utente, con blocco separato.
- Trigger di ripresa: DECISIONE UTENTE in questa retro (trunk-based dichiarato vs
  migrazione a due branch; sì/no alla rimozione di `origin/master`).

### IMP-026 — Skill di Claude Code come artefatto gestito: NON ora, con trigger di ripresa ⚖️ DECISIONE
- Data: 2026-07-11 | Origine: consolidamento (INPUT 4, valutazione scettica richiesta)
- Interpretazione assunta (da confermare con l'utente): "il framework fa e mantiene
  aggiornate le skill" = prevedere le Skill (`.claude/skills/`) come artefatto di prima
  classe del metodo — dove vivono, quando si creano/aggiornano, come si versionano, come
  `/checkpoint` e `/lint-memory` le includono nei controlli — NON una libreria di skill
  concrete (sarebbero stack-specifiche → violerebbero l'agnosticità).
- Valutazione col filtro «problema reale o hype?»: oggi nel framework NON c'è un attrito
  osservato che le Skill risolverebbero. I 7 comandi coprono il metodo; la conoscenza di
  progetto vive in memoria e doc con caricamento selettivo, che svolge la stessa
  funzione delle Skill (contesto on-demand). Una convenzione di gestione skill
  introdotta ORA sarebbe superficie di manutenzione senza un problema concreto e
  ricorrente → NON giustificata ora.
- Proposta consigliata: NON creare `.claude/skills/` né convenzioni ora. Trigger di
  ripresa esplicito: quando un progetto costruito sul framework accumula ≥2 procedure
  operative ricorrenti che non stanno bene né nelle regole tecniche di CLAUDE.md né in
  un comando (es. runbook di deploy, procedura di release complessa), oppure quando
  l'ecosistema Claude Code rende le Skill il veicolo primario delle procedure di
  progetto → a quel punto: convenzione minima agnostica (`.claude/skills/README.md`:
  quando una procedura diventa skill, naming, aggancio a `/checkpoint` e
  `/lint-memory`), MAI una libreria di skill concrete.
- Alternativa se l'utente le vuole comunque: la sola convenzione minima (README) subito,
  senza skill concrete.
- Beneficio atteso / rischio: niente artefatto-vetrina; la porta resta aperta con un
  trigger preciso. Rischio: se l'interpretazione assunta è sbagliata (l'utente voleva
  skill CONCRETE per il repo-framework stesso), la valutazione va rifatta su quel
  perimetro.
- Trigger di ripresa: DECISIONE UTENTE in questa retro (conferma interpretazione +
  rimandare vs convenzione minima subito).

<!-- Formato di una proposta:
### IMP-001 — <titolo breve>
- Data: YYYY-MM-DD | Origine: <sessione/problema che l'ha generata>
- Problema osservato: <attrito ricorrente, errore ripetuto, gap, regola ambigua>
- Proposta: <cosa cambiare e dove: CLAUDE.md / docs/NN / comando / hook / processo>
- Beneficio atteso / rischio:
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

<!-- Formato:
### IMP-001 — <titolo> → applicata il YYYY-MM-DD, commit <sha>
- <sintesi del problema e di cosa è stato cambiato in concreto>
-->

## Rimandate (non respinte — si riprendono al momento giusto)
_(nessuna ancora)_

<!-- Formato:
### IMP-00N — <titolo> → rimandata il YYYY-MM-DD
- Decisione utente: RIMANDA. <motivo>
- Trigger di ripresa: <quale evento futuro la fa tornare in gioco>
-->

## Rifiutate (con motivo — per non riproporle)
_(nessuna ancora)_
