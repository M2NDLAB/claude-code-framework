---
date: 2026-07-19
task: promozione del framework a v1.0.0 (primo release stabile)
branch: docs/promozione-v1.0.0
status: completed
tags: [session, release, versioning]
---
# Session 2026-07-19 — Promozione a v1.0.0

Passaggio dal regime pre-1.0 (0.x, nessuna stabilità promessa) al post-1.0 (contratto
del metodo stabile; breaking → MAJOR). Deliverable trattato con assessment, non
meccanicamente: la v1.0 è una PROMESSA pubblica, non un tag più alto. Base: v0.6.2.

## Assessment di prontezza (FASE 1, read-only) — esito: PRONTO
- Backlog: APERTE = nessuna; rimandate 023/026/027-graft/037, tutte roadmap post-1.0 col
  trigger (nessun debito bloccante). Numerazione 001–038 senza buchi.
- Contraddizioni: nessuna. IMP-034 ratificata e chiusa (cross-link CONTRIBUTING saldato in
  v0.6.1); riquadro "Nessuna automazione" di `SETUP.md` coerente (pin promosso = IMP-036;
  resta rimandato solo `/upgrade-framework` = IMP-037).
- `/lint-memory` 11 controlli: zero drift. Controllo 11 (inventari) allineato: 8 comandi ↔
  CLAUDE.md/README; 3 target di processo Makefile; 3 script ↔ `scripts/README`. STATE/TREE/
  INDEX = template puliti (corretto nel regime ibrido).
- Tag: v0.1.0…v0.6.2 tutti ANNOTATI, SemVer pulito. `git describe` = base v0.6.2.
- docs/04: la tabella dei bump post-1.0 c'era già; MANCAVANO la definizione di breaking
  change e il reframe della 1.0-come-futuro → elevato a GAP 1 bloccante (giustamente).

## Fatto
- **GAP 1** (`4604da4`, `docs(process)`): `docs/04` — definizione agnostica di «breaking
  change» come criterio del MAJOR (contratto pubblico; esempi per progetti di codice e di
  metodo/tooling) + reframe dei regimi come metodo permanente e della 1.0 come atto che
  attiva la promessa. `CONTRIBUTING.md` — modello git a post-1.0 (tag su `main` in entrambi
  i regimi, trunk-based) + promessa concreta di breaking change per il framework.
- **GAP 2** (`e8b7ad3`, `docs(changelog)`): voce `[1.0.0] — 2026-07-19`, primo release
  stabile, con sintesi del percorso 0.1→1.0 (capacità consolidate) e la definizione come
  parte della promessa.
- **Checkpoint** (questo commit, `chore(claude)`): IMP-039 in `LEARNINGS.md` (Applicate) +
  questa nota. STATE/TREE/INDEX intatti (template, regime ibrido).

## Piano (un commit per task)
- [x] 1. GAP 1 — docs/04 (breaking change + reframe post-1.0) + CONTRIBUTING (modello git post-1.0 + promessa) — commit: 4604da4
- [x] 2. GAP 2 — CHANGELOG voce [1.0.0] — commit: e8b7ad3
- [x] 3. Checkpoint — IMP-039 in LEARNINGS + questa nota — commit: (questo checkpoint)

## Decisioni prese (non ovvie)
1. **Dove vive «siamo a 1.0».** `docs/04` è un file TEMPLATE copiato nei progetti-cliente
   (che possono essere a 0.x): non può asserire che il framework È a v1.0 senza rompere
   l'agnosticità. Quindi la definizione di breaking change in `docs/04` è AGNOSTICA (col
   caso metodo/tooling come esempio), mentre l'asserzione "il framework È post-1.0" +
   la promessa concreta vivono in `CONTRIBUTING.md`/`CHANGELOG.md`, che NON sono template.
   Così i doc di versioning non contraddicono la realtà e il template resta pulito.
2. **Il tag v1.0.0 è una promozione DELIBERATA, non un bump auto-calcolato.** I commit del
   deliverable sono `docs`/`chore` → il bump automatico di `/integrate` direbbe "nessun
   tag". Il MAJOR v1.0.0 lo decide l'utente (regime "Rilascio 1.0.0" di docs/04, "la
   decisione finale resta dell'utente"). Il blocco `/integrate` lo dichiara esplicitamente.

## Retro (riflessione di fine deliverable)
- Attrito: l'assessment iniziale aveva dichiarato docs/04 "già a posto" perché la tabella
  dei bump c'era, mancando che la DEFINIZIONE portante di breaking change fosse assente e
  che la prosa inquadrasse la 1.0 come futura. Lezione: la presenza di una regola ≠ la sua
  completezza; su una release-promessa va verificato lo spirito (framing + definizione
  load-bearing), non solo la meccanica. Decisione: NESSUNA nuova IMP — è n=1 su un evento
  raro (promozione MAJOR), formalizzare un "checklist di promozione" ora sarebbe prematuro
  (stesso filtro anti-hype di IMP-027/037). Se le promozioni MAJOR ricorrono, una retro
  futura potrà distillarlo.

## Follow-up — /integrate (da eseguire con l'utente)
- Variante release trunk-based: merge `docs/promozione-v1.0.0` → `main`, tag **v1.0.0** su
  `main` (integrazione = stabile), base v0.6.2. CHANGELOG già committato (GAP 2), quindi
  `/integrate` non sposta nulla da `[Unreleased]`.
- Merge/tag/push = UTENTE. Questo tag (il più significativo del progetto) si verifica
  insieme PRIMA di pubblicarlo: `git rev-parse v1.0.0` + `git log origin/main..main`.

## Collegamenti
[[LEARNINGS]] · [[2026-07-19-retro-mirata-imp-038]] · [[2026-07-18-allineamento-doc-pubblica]]
