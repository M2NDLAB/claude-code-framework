---
date: 2026-07-18
task: allineamento doc pubblica a v0.6.0 — README/SECURITY/CONTRIBUTING + badge
branch: docs/allineamento-doc-pubblica-v0.6.0
status: completed
tags: [session, docs, readme, badge, allineamento]
---
# Session 2026-07-18 — Allineamento doc pubblica + badge (v0.6.0)

## Contesto
Ultimo deliverable sostanziale prima della valutazione v1.0: allineare la doc
pubblica (README, SECURITY, CONTRIBUTING) allo stato reale dopo i 5 deliverable
v0.3.0→v0.6.0, più 2 badge. Lavoro di ALLINEAMENTO (Livello 1 dove la doc
divergeva dalla realtà), non riscrittura. Regime ibrido (IMP-024/034): niente
`plans/`, questa nota è il diario; SOTTO soglia di onerosità → 4 commit diretti
ben scopati su branch dedicato, niente blocco-piano.

## FASE 0 — assessment read-only (approvato dall'utente)
7 disallineamenti: **D1** CLAUDE.md "Comandi rapidi" senza `make test-scripts`
(drift classe "legenda TREE 5/7"); **D2** README "Struttura" — `scripts/` 3/4
(manca `test-hooks-install.sh`), riga Makefile a 2 target; **D3** README fermo
alla v0.2 — "Cosa include" senza innesto brownfield/upgrade-in-place/pin/ponte,
passo 1 senza la creazione del pin; **D4** badge assenti; **D5**
`scripts/README.md` tabella 2/3; **D6** SECURITY baseline senza la scansione
one-off della storia (IMP-028b, v0.3.0); **D7** CONTRIBUTING senza il cross-link
al blocco-piano del regime ibrido (debito DICHIARATO in IMP-034: "rimandato al
deliverable README/CONTRIBUTING" — saldato qui).
Dichiarati A POSTO e NON toccati: SETUP.md (fresco di v0.6.0), CHANGELOG
(append-only: la lista storica v0.1.0 resta con 7 comandi, era corretta allora),
il resto di SECURITY/CONTRIBUTING, template memoria, settings.json, docs/00-06.

## Decisioni
- **Badge**: repo verificato PUBBLICO (API GitHub anonima → 200, tag leggibili)
  → versione DINAMICA `github/v/tag?sort=semver` linkata a /tags; licenza
  statica → LICENSE. Etichette in italiano (coerenza col README). Solo i 2 veri:
  niente CI/size/community — rifletterebbero fatti inesistenti.
- **Ponte progetto→framework**: estende la voce "Auto-miglioramento (IMP)" di
  "Cosa include" (sua casa naturale), NON una voce nuova; "Filosofia" resta il
  racconto. Voce nuova unica: "Innesto e aggiornamento" (greenfield, brownfield,
  upgrade `vX→vY`, provenance pin).
- **Bump: PATCH** (utente d'accordo) — il set contiene un `fix` (drift
  documentale, come il precedente v0.5.1); i `docs` puri da soli = nessun tag;
  nessuna capacità nuova del metodo → non MINOR.

## Commit (branch `docs/allineamento-doc-pubblica-v0.6.0`)
1. 5cf190f `fix(docs)`: liste comandi/script allineate (D1+D2+D5)
2. c7d870e `docs(readme)`: badge + capacità v0.3–v0.6 + pin nel passo 1 (D3+D4)
3. e25c066 `docs(security)`: baseline completata con one-off storia (D6)
4. 00902de `docs(contributing)`: cross-link blocco-piano regime ibrido (D7)

## DoD (esiti verificati)
- Badge dinamico RISOLVE `v0.6.0` (curl a shields.io — verificato sul reale,
  non presunto dalla teoria).
- Sentinella slot (`"DA DEFINIRE AL$"`): solo i 3 falsi positivi NOTI di
  IMP-031, preesistenti; il testo nuovo non introduce slot né marcatori.
- Agnosticità: 0 nomi di progetto-cliente nel diff `main..HEAD` e nei commit.
- Vincoli rispettati: LICENSE intatta, nessuna sezione nuova, niente v1.0.
- Security gate: non sensibile (sola documentazione) → saltato.

## /retro
- **IMP-038 registrata (APERTA)**: controllo "inventari vs realtà" in
  `/lint-memory` — SECONDA ricorrenza della classe lista-parziale (TREE 5/7 →
  IMP-018; oggi D1/D2/D5 nate da IMP-032 non propagata alle liste). Decisione
  rimandata alla retro periodica. Nessun altro attrito.

## Follow-up
- `/integrate` emesso a valle di questo checkpoint: bump **PATCH → v0.6.1**
  (describe alla mano nel blocco). Merge/tag/push = utente; trunk-based su
  `main` (integrazione = stabile, tag pre-1.0 su `main`).
- **Riconciliazione post-integrazione** (checkpoint 2026-07-18): blocco eseguito
  dall'utente — merge `ad65ac7` su `main`, tag annotato **v0.6.1** su `main`
  (describe `v0.6.1` esatto; oggetto tag `f143ec8` presente ANCHE sul remoto,
  verificato con `ls-remote`), feature branch eliminato, `main` allineato a
  `origin/main` (push di branch e tag avvenuti — incluso il checkpoint `95e43bd`
  della sessione precedente, come anticipato nel blocco). Il badge versione del
  README ora risolve v0.6.1 dai tag GitHub. Nessun branch attivo oltre `main`,
  nessun piano in-progress, working tree pulito. Prossimo passo di roadmap:
  valutazione della promozione v1.0 (deliverable a sé, su decisione utente).

## Collegamenti
[[LEARNINGS]] · [[2026-07-18-retro-mirata-imp-036-037]] ·
[[2026-07-17-harvest-framework-ponte]]
