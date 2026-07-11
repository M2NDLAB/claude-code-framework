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

## In pratica, per una proposta di modifica

1. Apri un feature branch da `main`.
2. Commit conventional, hook installati, nessun secret (gitleaks blocca comunque).
3. Se la modifica tocca regole o doc del metodo: allega la voce IMP (problema →
   proposta → beneficio/rischio) in `LEARNINGS.md`.
4. Nessun riferimento a progetti o stack specifici nei file del template.

Per segnalare una vulnerabilità: [SECURITY.md](SECURITY.md).
