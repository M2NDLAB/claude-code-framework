---
date: 2026-07-19
task: retro mirata IMP-038 — controllo inventari-vs-realtà in /lint-memory
branch: fix/lint-inventari-imp-038
status: completed
tags: [session, retro, lint-memory, imp-038]
---
# Session 2026-07-19 — Retro mirata IMP-038 (approvata e applicata)

## Contesto
Retro mirata sull'unica proposta APERTA del backlog: IMP-038 (controllo
"inventari vs realtà" in `/lint-memory`). Precondizione della valutazione v1.0
(non si dichiara stabile con una IMP aperta non giudicata). Regime ibrido
(IMP-024/034): niente `plans/`; deliverable SOTTO soglia di onerosità → 2 commit
ben scopati su branch dedicato, niente blocco-piano.

## FASE 0 — verifica read-only (esiti)
- IMP-038 confermata unica voce in "Proposte APERTE"; testo presentato verbatim.
- `/lint-memory` a 10 controlli; il 10 (sentinella IMP-031) è quello coi falsi
  positivi noti gestiti per esclusione dichiarata.
- Attrito d'origine confermato nella nota [[2026-07-18-allineamento-doc-pubblica]]:
  D1/D2/D5 = tre liste ferme a pre-IMP-032, sanate a mano (5cf190f).
- Frequenza storica della classe: 2 eventi in ~5 settimane (legenda TREE 5/7 →
  IMP-018; D1/D2/D5), ma causa STRUTTURALE persistente: lo stesso inventario vive
  in fino a 4 copie su doc pubblica che legittimamente duplica → de-duplicazione
  (la cura di IMP-018) non praticabile → resta la rilevazione, casa naturale
  `/lint-memory`.
- Inventari verificati ALLINEATI al momento della retro (post-v0.6.1): 8 comandi,
  3 script + README, Makefile a 4 target (help + 3 di processo).

## Decisione utente
**APPROVA-E-APPLICA** col design del controllo 11 proposto (enumerazione, non
euristica; confronto insiemistico bidirezionale; esclusioni dichiarate). Verifica
richiesta in applicazione: la selezione dei target Makefile deve distinguere in
modo ROBUSTO processo vs progetto anche nei progetti-cliente.

## Design applicato (controllo 11)
- Liste ENUMERATE ↔ filesystem, nei DUE versi (esiste-ma-non-elencato /
  elencato-ma-inesistente); mai le menzioni in prosa.
- **Esito della verifica richiesta**: il criterio POSIZIONALE del design iniziale
  ("target sopra il banner `[DA DEFINIRE AL SETUP]`") era fragile — al setup il
  cliente compila/rimuove il banner e l'ancora sparisce. Sostituito con ancoraggio
  STRUTTURALE: target di processo = ricetta che invoca uno script di `scripts/`
  (`help` escluso). Verificato sugli artefatti reali: i 3 target di processo
  invocano `bash scripts/*.sh`, `help` no, gli esempi-cliente del banner invocano
  i comandi dello stack → nessun falso positivo nel cliente.
- Equivalenze di forma ammesse (`make reset-task` ≡ `./scripts/reset-task.sh`).
- Esclusi per dichiarazione (come nel controllo 10): CHANGELOG (append-only) e
  record IMP di LEARNINGS — registrano stati passati, non inventari correnti.

## Commit (branch `fix/lint-inventari-imp-038`)
1. 2f69413 `fix(process)`: controllo 11 in `lint-memory.md`
2. (questo checkpoint) `chore(claude)`: IMP-038 → Applicate con sha reale (niente
   backfill), nota di sessione

## Ciclo di fine deliverable
- Security gate: NON sensibile (sola doc di processo) → saltato.
- `/retro`: no-op dichiarato — l'unico attrito (criterio posizionale fragile) è
  risolto e documentato nel record IMP-038; nessuna proposta nuova. Backlog APERTE
  ora vuoto.
- Bump dichiarato per `/integrate`: **PATCH → v0.6.2**. Motivo: precedente gemello
  IMP-031/v0.5.1 — un controllo di lint che chiude una classe di drift documentata
  è un `fix` ("Fixed" nel CHANGELOG), non una capacità di metodo nuova (→ non
  MINOR) né lavoro interno puro (→ non "nessun tag": v0.5.1 taggò PATCH per la
  stessa coppia sanatoria+sentinella).

## Follow-up
- `/integrate` emesso a valle di questo checkpoint: bump **PATCH → v0.6.2**
  (describe alla mano nel blocco). Merge/tag/push = utente; trunk-based su
  `main` (integrazione = stabile, tag pre-1.0 su `main`).
- **Riconciliazione post-integrazione** (checkpoint 2026-07-19): blocco eseguito
  dall'utente — merge `9246cd8` su `main`, tag annotato **v0.6.2** su `main`
  (describe `v0.6.2` esatto; oggetto tag `930eaeb` presente ANCHE sul remoto,
  verificato con `ls-remote`), feature branch eliminato, `main` allineato a
  `origin/main` (push di branch e tag avvenuti). Nessun branch attivo oltre
  `main`, nessun piano in-progress, working tree pulito. Backlog IMP: APERTE
  vuoto. Prossimo passo di roadmap: **valutazione della promozione v1.0**
  (deliverable a sé, su decisione utente) — senza IMP aperte pendenti.

## Collegamenti
[[LEARNINGS]] · [[2026-07-18-allineamento-doc-pubblica]] ·
[[2026-07-17-retro-periodica-backlog-lint]]
