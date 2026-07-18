# Contribuire al claude-code-framework

La collaborazione è GRADITA, non obbligatoria: la licenza [MIT](LICENSE) ti
permette di usare, copiare e modificare il framework senza dovere nulla in
cambio. Se però vuoi restituire qualcosa — una correzione, una lezione di
processo, un miglioramento del metodo — questo file dice come farlo, nel modo che
il framework stesso usa su di sé.

> Vuoi USARE il template in un tuo progetto, non contribuirvi? Parti da
> [SETUP.md](SETUP.md).

## Il workflow di questo repo

Questo repo si auto-applica il metodo che descrive (`.claude/docs/`):

- **Feature branch** per ogni modifica significativa (`feat/...`, `fix/...`,
  `docs/...`): mai lavoro diretto sul branch di integrazione.
- **Conventional Commits**, verificati dall'hook commit-msg: tipi in
  `commitlint.config.cjs`, formato e regole in
  `.claude/docs/04-git-workflow.md`. Installa gli hook con `make hooks-install`
  (richiede gitleaks e Node.js).
- **Ciclo di fine deliverable** (`.claude/docs/00-overview.md`): [se sensibile]
  `/security-review` → `/retro` → `/checkpoint` → `/integrate`.
- **I cambi alle REGOLE passano da una proposta IMP** in
  `.claude/memory/LEARNINGS.md` (`.claude/docs/06-self-improvement.md`): prima la
  proposta, poi la decisione umana, poi l'applicazione con un commit dedicato.
- **Agnosticità non negoziabile**: il template non contiene istanze specifiche di
  un progetto (stack, nomi, valori concreti); dove serve concretezza si usa
  `[DA DEFINIRE AL SETUP]`.

## Il modello git di questo repo (eccezione dichiarata)

Il default che il framework DESCRIVE è a due branch (`.claude/docs/04`), ma il
repo del framework stesso è **trunk-based su `main`**: i due RUOLI del doc —
branch di integrazione e branch stabile — qui COINCIDONO (caso previsto dal doc
stesso). In concreto:

- i deliverable passano da un feature branch mergiato in `main` con `--no-ff` via
  blocco `/integrate`, eseguito da un umano (una PR verso se stessi non aggiunge
  controllo);
- in regime pre-1.0 i tag annotati (`v0.x.y`) vivono su `main`, che qui È la
  linea di integrazione;
- nella storia condivisa (commit, merge, tag) niente nomi di progetti o clienti
  specifici — vedi la regola in docs/04, *Formato commit*: per un template
  l'agnosticità vale anche nei messaggi, perché la storia pushata non si riscrive.

## La memoria di questo repo: regime "ibrido dichiarato"

Il repo usa su di sé solo UNA PARTE del proprio sistema di memoria:

- **VIVI**: `.claude/memory/LEARNINGS.md` (il backlog IMP del framework — è il
  loop della *Filosofia* del README: le lezioni d'uso tornano nel template) e
  `.claude/memory/sessions/` (il diario del lavoro sul framework).
- **Template puliti**, mai popolati qui: `STATE.md`, `TREE.md`, `INDEX.md`,
  `components/`, `decisions/`, `plans/` — restano pronti da copiare.

Non è una dimenticanza: è la scelta che tiene il template copiabile senza
rinunciare al loop di auto-miglioramento. Chi copia il template nel proprio
progetto SVUOTA la parte viva (istruzioni in `SETUP.md`, passo 2).

Conseguenza operativa del regime: un deliverable oneroso qui NON crea file in
`plans/` — il piano vive nella nota di sessione come blocco-piano standardizzato,
un commit per task (vedi `.claude/docs/01-task-planning.md`, riquadro sul regime
ibrido, e `.claude/memory/sessions/README.md`).

## In pratica, per una proposta di modifica

Una proposta può nascere dal lavoro su questo repo, oppure **risalire da un
progetto-cliente**: là la lezione si marca `Destinazione: framework` e
`/harvest-framework` ne produce un blocco copiabile (già anonimizzato) da portare
qui (vedi `.claude/docs/06-self-improvement.md`, *"Il ponte verso il framework"*).
In entrambi i casi diventa una voce IMP in `LEARNINGS.md`.

1. Apri un feature branch da `main`.
2. Commit conventional, hook installati, nessun secret (gitleaks blocca comunque).
3. Se la modifica tocca regole o doc del metodo: allega la voce IMP (problema →
   proposta → beneficio/rischio) in `LEARNINGS.md`.
4. Nessun riferimento a progetti o stack specifici nei file del template.

Per segnalare una vulnerabilità: [SECURITY.md](SECURITY.md).
