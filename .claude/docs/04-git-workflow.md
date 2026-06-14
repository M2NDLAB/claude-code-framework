# 04 — Git workflow: commit, branch, merge, rollback

Regole PERMANENTI. Claude Code le applica in autonomia dove indicato e chiede
conferma dove indicato.

## Modello di branching

- `main` = produzione. Solo merge da `develop` via release, mai commit diretti.
- `develop` = staging/integrazione. Solo merge di feature branch via PR.
- `feat/<area>-<descrizione>` = una feature, vita breve (giorni, non settimane).
- `fix/<area>-<descrizione>` per bugfix; `hotfix/<descrizione>` da `main` (e
  ri-merge in `develop` subito dopo).
- Claude Code crea SEMPRE un branch prima di iniziare una feature o una modifica
  significativa — mai lavorare direttamente su `develop`.

> Se il progetto usa un modello diverso (es. trunk-based puro, o nomi di branch
> differenti): [DA DEFINIRE AL SETUP]. Il resto delle regole qui sotto resta valido.

## QUANDO committare (i punti importanti)

Commit = checkpoint logico autoconsistente che compila e passa i test. Si committa:
1. PRIMA di ogni cambiamento rischioso o refactor ampio (checkpoint di sicurezza per
   il rollback).
2. Quando una unità funzionante è completa (una migrazione + il modello, un endpoint
   con i suoi test, un componente UI funzionante).
3. Alla fine di ogni task di un piano (vedi `01-task-planning.md`).
4. SEMPRE prima di chiudere una sessione, anche se il lavoro è parziale (commit con
   prefisso `wip:` SOLO su feature branch — mai `wip` su `develop`).

MAI committare: codice che non compila su `develop`/`main`; file di ambiente o
secret (gitleaks blocca, ma non contarci come unica difesa); artefatti di build e
dipendenze installate.

## Formato commit — Conventional Commits

`<tipo>(<scope>): <descrizione imperativa minuscola>`

Tipi: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `chore`.
Scope = nome del componente o area. Body (obbligatorio se il cambiamento non è
ovvio): il PERCHÉ del cambiamento, non il cosa (il cosa è nel diff). Footer per i
riferimenti (`Refs: #issue`, o un rimando alla decisione/ADR registrata).

Esempio:
```
feat(<area>): aggiungi step di compensazione al flusso X

Il flusso lasciava una risorsa bloccata quando il passo Y andava in timeout.
Aggiunto uno step di compensazione idempotente.
Refs: #123
```

Il formato è verificato dall'hook `commit-msg` (commitlint) e definito in
`commitlint.config.cjs`.

## Merge

- Feature → `develop`: SEMPRE via Pull Request, mai merge locale diretto. Prima della
  PR: rebase su `develop` (`git fetch && git rebase origin/develop`) per risolvere i
  conflitti nel branch, non nel merge.
- Strategia: squash merge per feature piccole (storia pulita), merge commit per
  feature grandi dove la storia interna dei commit ha valore. Mai fast-forward su
  `develop` (si perde la traccia del branch).
- Messaggio del merge commit: `merge:` NON è un tipo valido per commitlint. Per un
  merge esplicito (`--no-ff`) usa un tipo valido con "merge" nella descrizione, es.
  `feat(<area>): merge <feature> in develop`. I merge auto-generati da git ("Merge
  branch …") commitlint li ignora di default, ma preferiamo il messaggio conventional
  esplicito.
- `develop` → `main`: solo via PR di release, tag semver `vX.Y.Z` dopo il merge.

Conflitti: Claude Code li risolve solo se banali (import, formattazione); se toccano
logica, si FERMA e chiede all'utente mostrando le due versioni.

## Rollback — scegliere lo strumento giusto

- Commit già pushato su branch condiviso (`develop`/`main`): `git revert <sha>` —
  crea un commit inverso, la storia resta intatta. È l'UNICA opzione sui branch
  condivisi. Mai reset/force-push su `develop` o `main`.
- Commit locale non pushato: `git reset --soft HEAD~1` (tiene le modifiche) o
  `--hard` (le distrugge — chiedere SEMPRE conferma all'utente prima di `--hard`).
- Esperimento da buttare: il branch si cancella, niente da annullare — è il motivo
  per cui si lavora SEMPRE su branch.
- Release rotta in produzione: rollback del **deploy** PRIMA (riportare l'ambiente
  alla versione precedente), revert del **codice** DOPO con calma. Non si debugga in
  produzione.
- `git push --force` è VIETATO ovunque tranne sul proprio feature branch non
  condiviso, e solo come `--force-with-lease`.

## Regole operative per Claude Code

- `git status` e `git diff` prima di ogni commit: verificare che entrino SOLO i file
  attesi. Mai `git add .` alla cieca — add esplicito per path.
- Push: solo su richiesta dell'utente o a fine task completato. La configurazione
  (`.claude/settings.json`) nega il push automatico — è intenzionale: il push lo
  conferma l'umano.
- Tag e release: solo l'utente decide quando; Claude Code prepara (changelog dai
  conventional commit, bump versione) e chiede conferma.
