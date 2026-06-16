---
type: learnings
updated: 2026-06-16
tags: [improvement]
---
# Learnings & proposte di miglioramento

> **Cos'è questo file.** Il backlog dell'auto-miglioramento di processo (vedi
> `.claude/docs/06-self-improvement.md`). Qui Claude Code registra le proposte di
> modifica a regole, doc, comandi e configurazione (IMP-nnn) — ma NON le applica
> da solo: le applica solo dopo approvazione dell'utente. Le correzioni puramente
> FATTUALI alla doc (Livello 1) non passano da qui, si applicano subito.
>
> La numerazione delle IMP parte da **001**. Questo file nasce VUOTO.

## Proposte APERTE (in attesa di decisione utente)

### IMP-001 — Strategia di versioning: SemVer su tag annotati (riconciliata)
- Data: 2026-06-16 | Origine: lezioni di metodo maturate su un progetto reale
- Problema osservato: `04-git-workflow.md` nomina i tag SemVer (`vX.Y.Z` "dopo il
  merge su `main`") ma non definisce *quando* e *quanto* bumpare; manca del tutto il
  regime pre-1.0 (tag sul branch di sviluppo) e post-1.0; la regola attuale "tag solo
  su `main`" CONTRADDICE la strategia in cui in 0.x si tagga su `develop`.
- Proposta: in `04-git-workflow.md` RICONCILIARE (non sovrapporre) con una sezione
  "Versioning": tag annotati `vX.Y.Z`, mappatura tipo-commit→bump, pre-1.0 si tagga
  su `develop`, `1.0.0` alla promozione su `main`, post-1.0 si tagga su `main`,
  hotfix = PATCH con doppio merge. La nuova regola SOSTITUISCE quella incompleta.
- Beneficio atteso / rischio: versioning deterministico e tracciabile da `git
  describe`. Rischio: nullo — rimpiazza una regola incompleta e contraddittoria.

### IMP-002 — Blocco "PRONTO PER INTEGRAZIONE" a fine deliverable
- Data: 2026-06-16 | Origine: lezioni di metodo maturate su un progetto reale
- Problema osservato: il principio "l'agente prepara, l'umano integra" è solido e la
  meccanica del merge è descritta in prosa in `04`, ma manca un *deliverable
  copia-incolla*: `/checkpoint` si ferma al commit e non emette i comandi di
  integrazione, che restano da ricostruire a mano (con i relativi errori).
- Proposta: nuovo slash command `/integrate` che — senza eseguire push/merge — emette
  la sequenza esatta (checkout feature → fetch+rebase su sviluppo → `merge --no-ff` →
  push esplicito → `branch -d`), il messaggio di merge entro il limite del
  commit-linter, il tag col bump corretto (o esplicito "nessun tag"), il calcolo della
  prossima versione da `git describe`, la verifica finale e le note anti-errore.
- Beneficio atteso / rischio: integrazione ripetibile e senza errori manuali; l'umano
  resta l'unico esecutore di push/merge/tag. Rischio: nullo.

### IMP-003 — Protocollo per il refactor cross-modulo sicuro
- Data: 2026-06-16 | Origine: lezioni di metodo maturate su un progetto reale
- Problema osservato: gli ingredienti esistono sparsi (task atomici su branch in
  `01`, DoD con smoke del wiring in `02`, review prima della PR in `03`), ma manca il
  pattern nominato e soprattutto la disciplina distintiva: i test di TUTTI i moduli
  toccati verdi a OGNI passo, non solo del modulo in lavorazione né solo alla fine.
- Proposta: sezione dedicata in `01-task-planning.md` ("refactor cross-modulo") che
  consolida gli ingredienti e fissa la regola dei test di tutti i consumatori a ogni
  step + review di coerenza prima del merge.
- Beneficio atteso / rischio: niente regressioni silenziose nei consumatori del codice
  spostato. Rischio: nullo.

### IMP-004 — Configurazione dei permessi pulita
- Data: 2026-06-16 | Origine: lezioni di metodo maturate su un progetto reale
- Problema osservato: in `settings.json` l'`allow` non include i comandi sicuri di
  staging/commit (ogni commit genera un prompt) e la `deny` non copre le cancellazioni
  distruttive (`clean`, `branch -D`, `rm -rf`); il principio "file locale non
  versionato, si parte vuoti" e il divieto di auto-approvazioni vaghe non sono
  documentati da nessuna parte.
- Proposta: aggiornare `settings.json` (allow: + `git add`/`git commit`; deny: +
  cancellazioni distruttive) e documentare i quattro principi in `04-git-workflow.md`
  + checklist in `SETUP.md`.
- Beneficio atteso / rischio: meno prompt sulle operazioni innocue, blocco netto sulle
  distruttive, nessun permesso implicito e dimenticato. Rischio: nullo.

### IMP-005 — Lint della memoria/wiki (health-check della base di conoscenza)
- Data: 2026-06-16 | Origine: lezioni di metodo maturate su un progetto reale
- Problema osservato: non esiste un controllo di COERENZA della memoria (stato
  disallineato dalla realtà git, note contraddittorie, pagine orfane, concetti senza
  pagina, cross-reference e link mancanti, claim stantii). `/retro` copre il PROCESSO,
  non la salute dei DATI: sono due cose distinte.
- Proposta: nuovo slash command `/lint-memory` (health-check) + nota di confine in
  `06-self-improvement.md`. Criterio: trattandosi di un framework per software, una
  contraddizione è un BUG da correggere (allinea lo stato alla realtà), non una
  tensione da preservare; il lint segnala E propone/applica la correzione.
- Beneficio atteso / rischio: la base di conoscenza non mente nel tempo. Rischio:
  nullo (le correzioni a rischio richiedono comunque conferma).

<!-- Formato di una proposta:
### IMP-001 — <titolo breve>
- Data: YYYY-MM-DD | Origine: <sessione/problema che l'ha generata>
- Problema osservato: <attrito ricorrente, errore ripetuto, gap, regola ambigua>
- Proposta: <cosa cambiare e dove: CLAUDE.md / docs/NN / comando / hook / processo>
- Beneficio atteso / rischio:
-->

## Applicate
_(nessuna ancora)_

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
