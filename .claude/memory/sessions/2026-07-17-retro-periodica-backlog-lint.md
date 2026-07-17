---
date: 2026-07-17
task: retrospettiva periodica sull'intero backlog IMP (031-037) + /lint-memory della memoria del framework
branch: chore/retro-backlog-imp
status: in-progress
tags: [session, improvement, retro, lint]
---
# Session 2026-07-17 — Retro periodica del backlog IMP + lint-memory

## Contesto
Deliverable scollegato dai precedenti (repo a `v0.5.0`, working tree pulito). NON il `/retro`
leggero di fine deliverable: **retrospettiva periodica** sull'intero backlog (6 IMP aperte:
031, 032, 034, 035, 036, 037), accompagnata da `/lint-memory` (health-check dopo 5 deliverable
e 5 merge). Motivo dell'ordine: la retro precede D3 (upgrade di brew-manager `v0.2→v0.4`, altro
repo) perché ≥4 delle 6 IMP toccano D3 — entrare nel collaudo col backlog pulito.

Questa nota è il **plan-pointer** (risoluzione interim di **IMP-034**, che questo stesso
deliverable ratifica al task 4): sul repo-framework in regime ibrido il piano NON vive in
`plans/` ma qui, come **blocco-piano standardizzato** + commit `[task N/T]`. Piccolo ricorsivo
dichiarato: applichiamo l'eccezione mentre la ratifichiamo (3ª ricorrenza, dopo harvest e upgrade).

## FASE 1 — Retro: verifica adversariale (workflow multi-agente)
6 verificatori paralleli (uno per IMP, mandato di CONFERMARE/REFUTARE le claim sui file reali) +
1 analista di design per IMP-034. Esito: **tutte le claim confermate** sui file reali. 2
precisazioni minori (034: committare=FASE 2, spuntare=FASE 3; 035: "ricorrente" è ipotetico, 1
occorrenza). Tabella presentata all'utente → decisioni prese.

## Decisioni utente (FASE 1 → applicazione)
1. **IMP-031** → APPROVA. Convenzione "marcatore su una riga fisica" + sentinella `/lint-memory`
   che ESCLUDE i 3 riferimenti in prosa (falsi positivi).
2. **IMP-032** → APPROVA. Fix `[[ -e ]]` + test RED→GREEN, `rm -f` comune ai due rami.
3. **IMP-034** → **A+C, NO D, NO B**. A ratifica l'eccezione E ripara lo step di RIPRESA
   (docs/01:129, oggi guarda solo in `plans/`); C standardizza il blocco-piano nella nota. Vale
   per la CLASSE (`plans/` E `decisions/`). D scartata (lex specialis = astrazione prematura da
   n=1, vettore di drift); B scartata (`git rm` dimenticabile). IN-SCOPE: docs/01 +
   sessions/README; NON toccare CONTRIBUTING (cross-link annotato per il deliverable README/CONTRIBUTING).
4. **IMP-035** → RISOLVI. Una riga accanto a IMP-026 in LEARNINGS. No glossario (overload 1×).
5. **IMP-036** → CONFERMA RIMANDATA. Trigger: dopo il 1° upgrade reale (D3).
6. **IMP-037** → CONFERMA RIMANDATA. Trigger: dopo 2-3 upgrade reali.
Bump del deliverable: **PATCH** (031/032 sono `fix`; il resto è docs/chore).

## Piano (un commit per task)
- [ ] 1. Branch + questa nota (plan-pointer, blocco-piano) — commit: —
- [ ] 2. IMP-031: convenzione in SETUP.md + sentinella in `/lint-memory` — commit: —
- [ ] 3. IMP-032: fix `hooks-install.sh` (dangling) + test RED→GREEN + `make test` — commit: —
- [ ] 4. IMP-034 (A+C): riquadro docs/01 + patch RIPRESA + blocco-piano in sessions/README — commit: —
- [ ] 5. IMP-035: nota terminologica accanto a IMP-026 — commit: —
- [ ] 6. Sposta IMP-036/037 in "Rimandate" coi trigger — commit: —
- [ ] 7. FASE 2 `/lint-memory` + `/checkpoint` (backfill sha, finalizza nota) — commit: —

## FASE 2 — /lint-memory
<!-- da compilare al task 7 -->

## Correzioni fattuali doc (Livello 1, docs/06)
<!-- da compilare: il deliverable APPLICA IMP, non corregge doc in disaccordo -->

## Follow-up
- Cross-link CONTRIBUTING ↔ docs/01 (regime ibrido / blocco-piano) → **rimandato al deliverable
  README/CONTRIBUTING** (fuori scope qui, per decisione utente).
- `/integrate`: bump PATCH → `v0.5.0` → `v0.5.1`. Merge + tag + push = umano.

## Collegamenti
[[LEARNINGS]] · [[2026-07-17-upgrade-in-place-procedura]] · [[2026-07-17-harvest-framework-ponte]]
