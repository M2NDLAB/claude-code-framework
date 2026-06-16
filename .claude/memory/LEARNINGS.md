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

### IMP-006 — Ciclo unico di fine deliverable (sequenza-tipo ordinata)
- Data: 2026-06-16 | Origine: fotografia diagnostica dello stato del framework
- Problema osservato: i mattoni di fine deliverable esistono ma sparsi su più doc;
  nessun documento li mette in fila. Il diagramma di `00-overview.md` si ferma a
  `/checkpoint` e non include `/security-review`, `/retro`, `/integrate` nella linea
  principale: manca un runbook unico e ordinato.
- Proposta: sezione "ciclo di fine deliverable" in `00-overview.md` con sequenza
  ordinata (costruzione → [se sensibile] `/security-review` → `/retro` → `/checkpoint`
  → `/integrate`), `/security-review` CONDIZIONALE (solo se sensibile), gli altri
  passi FISSI; aggiornare il diagramma del ciclo; allineare i cenni in `README.md` e
  `SETUP.md`.
- Beneficio atteso / rischio: un runbook unico riduce i passi dimenticati a fine
  deliverable. Rischio: nullo (ordina mattoni già esistenti).

### IMP-007 — Cabla /retro nel flusso e risolvi l'incoerenza "riflessione al checkpoint"
- Data: 2026-06-16 | Origine: fotografia diagnostica dello stato del framework
- Problema osservato: `/retro` è agganciato solo al ramo escalation del diagramma
  (`00-overview.md:36`), non al flusso happy-path. Inoltre `06-self-improvement.md`
  (righe 48 e 65-66) prescrive "30 secondi di riflessione al `/checkpoint`", ma il
  comando `/checkpoint` non contiene quello step: drift doc-vs-comando.
- Proposta: rendere `/retro` un passo FISSO del ciclo di fine deliverable (IMP-006),
  PRIMA di `/checkpoint`; correggere `06-self-improvement.md` perché la riflessione
  sia il passo `/retro` a fine deliverable (non "dentro" il checkpoint); chiarire in
  `retro.md` i due livelli (registrazione leggera per-deliverable vs review periodica
  del backlog con decisioni).
- Beneficio atteso / rischio: riflessione garantita senza sovraccaricare `/checkpoint`
  (che resta allineamento-dati); doc e comando coerenti. Rischio: nullo.

### IMP-008 — Branch di integrazione parametrico (rimuovi "develop" hardcoded)
- Data: 2026-06-16 | Origine: fotografia diagnostica dello stato del framework
- Problema osservato: doc e comandi (`/integrate`, `reset-task.sh`) assumono il nome
  `develop` per il branch di integrazione, ma è il nome di UN modello (GitFlow): un
  template agnostico non deve imporlo. È anche drift doc-vs-realtà — nel repo `develop`
  non esiste, c'è solo `main` — e a runtime il blocco di `/integrate` fallirebbe.
- Proposta: opzione (b) parametrica. In `04-git-workflow.md` stabilire che "branch di
  integrazione" e "branch stabile" sono RUOLI; `develop`/`main` restano solo i default
  di esempio, il nome effettivo è `[DA DEFINIRE AL SETUP]`. Parametrizzare il blocco di
  `/integrate` (`<integrazione>`/`<stabile>`) e rendere configurabile la guardia dei
  branch protetti in `reset-task.sh`.
- Beneficio atteso / rischio: il framework non impone un modello di branching e i
  comandi non assumono un branch che potrebbe non esistere. Rischio: nullo.

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
