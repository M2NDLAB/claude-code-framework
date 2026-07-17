---
date: 2026-07-17
task: deliverable D2 — procedura di upgrade-in-place di un framework già innestato (terzo caso, accanto a greenfield/brownfield)
branch: feat/upgrade-in-place-procedure
status: in-progress
tags: [session, upgrade, setup, brownfield]
---
# Session 2026-07-17 — Procedura di upgrade-in-place (`vX→vY`)

## Contesto
Nuovo deliverable scollegato dai precedenti (repo a `v0.4.0`). Problema reale non coperto:
`SETUP.md` guida greenfield e brownfield (innesto su progetto SENZA framework, IMP-027), ma
manca il **terzo caso**: un progetto che ha GIÀ una versione del framework innestata e va
aggiornato a una nuova, PRESERVANDO la memoria di progetto accumulata (caso atteso:
brew-manager `v0.2.0` → `v0.4.0`, che è D3, altro repo, dopo — NON qui).

Deliverable con SCELTE STRUTTURALI → pattern docs/01 FASE 2: assessment read-only → proposta
con alternative → **decisione utente** → esecuzione. Questa nota è il **plan pointer**
(risoluzione interim di **IMP-034**, aggancio dichiarato non risolto: sul repo-framework in
regime ibrido il piano NON vive in `plans/` ma come nota di sessione + commit `[task N/T]`).

## Assessment (sola lettura, workflow multi-agente)
6 lettori paralleli (tassonomia dei 41 file, anatomia ibridi, marcatori, what-changed,
sicurezza, precedenti) + panel adversariale di 3 approcci + critico di completezza.

**Insight strutturale chiave:** il fill dei `[DA DEFINIRE AL SETUP]` è **distruttivo** — a
setup fatto il file è un impasto indistinguibile prosa-framework + risposte-progetto, senza
confine grep-abile. Per gli ibridi a ownership interleaved (`CLAUDE.md`, `settings.json`,
`hooks-install.sh`) l'unico meccanismo robusto è il **3-way merge** con `base = template@vX`.
Ma il progetto **non registra da quale `vX` è partito** (nessun provenance pin; i tag vivono
solo nel repo-framework) → il 3-way non ha base certa. È il cuore del deliverable.

## Decisioni utente (3 forks)
1. **Machinery = Approccio A (doc-only)**: ZERO artefatti nuovi ora; `provenance-pin` e
   `/upgrade-framework` rimandati come IMP APERTE (trigger: 1° upgrade reale), gemelle di
   IMP-027 `graft.sh`. Motivo: 1 innesto, 0 upgrade → automazione prematura; precedente
   vincolante IMP-027 ("documenta prima, prova sul campo, automatizza dopo 2-3 casi").
2. **Collocazione = Mix**: stub di rimando nel CASO A brownfield + **sezione dedicata**
   `## Aggiornare il framework (vX→vY)` in `SETUP.md`.
3. **Edge case = tutti e 7 obbligatori** nella prosa della procedura.

## Modello dell'upgrade (tassonomia)
- **METODO** (→ `vY`): `docs/00-06`, commands puri, i 4 README di `memory/*/`, `reset-task.sh`,
  `scripts/README.md`, `commitlint.config.cjs`.
- **MEMORIA-DI-PROGETTO** (intatta, invariante `diff` vuoto su `memory/`): `STATE`/`TREE`/`INDEX`
  pieni, `sessions/*`, e nel cliente `components/decisions/plans/*`.
- **IBRIDI** (3-way `base=vX`): `CLAUDE.md` (ALTA), `settings.json` (media), `hooks-install.sh`
  (ALTA, richiede `make hooks-install` post-merge), `LEARNINGS.md` (do-not-touch sulle voci),
  `.gitignore`/`Makefile` (INTEGRA), `checkpoint`/`integrate`/`new-component.md` (leggeri).
- **What-changed**: framework-side (unico coi tag) = CHANGELOG per-versione (indice) +
  `git diff vX vY -- <metodo, escluso .claude/memory>` (testo esatto). Mai `git apply` cieco.

## 7 edge case che la procedura DEVE coprire
1. File **cancellato** in `vY` resta orfano (overwrite ≠ sync) → applica anche le delete + check anti-orfano.
2. File **rinominato/rinumerato** genera duplicato → gestione rename (`git diff -M`).
3. **Tensione `diff-vuoto-su-memory` ↔ wikilink rotti** da rename doc → via d'uscita: eccezione esplicita + commit separato dichiarato.
4. Hook `.git/hooks/*` **fuori dal grafo git**: `make hooks-install` ha effetti che il rollback branch-based non annulla → passo di verifica/disinstallazione.
5. Regime **`0.x→1.0`** di `docs/04`: aggiornare un doc di processo cambia semantiche vive → avviso "cambio-regole".
6. **Salto multi-versione** `v0.1→v0.4`: il diff agli estremi collassa migrazioni non-commutative → ordinare per versione.
7. **Pre-flight** puro/ibrido: `docs/02/03/04` sono METODO SALVO fill inline → ispeziona prima di sovrascrivere.

## Piano (un commit per task)
- [ ] 1. Branch + questa nota (plan pointer) — commit: —
- [ ] 2. `SETUP.md` sezione dedicata `## Aggiornare il framework (vX→vY)` — commit: —
- [ ] 3. `SETUP.md` i 7 edge case nella procedura — commit: —
- [ ] 4. `SETUP.md` stub di rimando nel CASO A — commit: —
- [ ] 5. `LEARNINGS.md` IMP-036 (provenance-pin) + IMP-037 (`/upgrade-framework`) APERTE — commit: —
- [ ] 6. `CHANGELOG` `[Unreleased]` + cross-link minimo + `/checkpoint` — commit: —

## Agganci a IMP aperte (dichiarati, non risolti)
- **IMP-031** (marcatori spezzati sfuggono al grep) → l'upgrade eredita la dipendenza per rilevare i nuovi marcatori di `vY`.
- **IMP-032** (fix `hooks-install`) → l'upgrade è il veicolo con cui la fix arriva ai progetti esistenti.
- **IMP-034** (docs/01 ↔ regime ibrido) → costruire questa procedura È un deliverable oneroso sul repo-framework: segue la risoluzione interim (questa nota come plan pointer, niente `plans/`).
- **IMP-035** (naming "comando") → l'eventuale `/upgrade-framework` sarà un "comando", non la feature Skills.
- Sibling **rimandata**: IMP-027 opzione `graft.sh`.

## Follow-up
- **Security gate**: non sensibile (documentazione) → `/security-review` saltato.
- **`/integrate`**: bump da valutare (coerenza col precedente brownfield `[0.3.0]` MINOR). CHANGELOG `[Unreleased]` compilato dentro `/integrate`. Merge + tag + push = umano.
- **Disciplina di scope**: espandere CASO A senza riscrivere le regole d'innesto esistenti; le 2 IMP separate dalla procedura.

## Collegamenti
[[LEARNINGS]] · [[STATE]] · [[2026-07-17-harvest-framework-ponte]]
