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
_(nessuna proposta aperta)_

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
