---
date: 2026-07-17
task: retrospettiva periodica sull'intero backlog IMP (031-037) + /lint-memory della memoria del framework
branch: chore/retro-backlog-imp
status: completed
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
- [x] 1. Branch + questa nota (plan-pointer, blocco-piano) — commit: d7194de
- [x] 2. IMP-031: convenzione in SETUP.md + sentinella in `/lint-memory` — commit: f02e6bb
- [x] 3. IMP-032: fix `hooks-install.sh` (dangling) + test RED→GREEN + `make test-scripts` — commit: d061f6c
- [x] 4. IMP-034 (A+C): riquadro docs/01 + patch RIPRESA + blocco-piano in sessions/README — commit: da0e158
- [x] 5. IMP-035: nota terminologica accanto a IMP-026 — commit: ee5b0f8
- [x] 6. Sposta IMP-036/037 in "Rimandate" coi trigger — commit: 954d72d
- [x] 7. FASE 2 `/lint-memory` + `/checkpoint` (backfill sha, finalizza nota) — commit: (questo)

## FASE 2 — /lint-memory
Health-check sulla memoria viva (regime ibrido IMP-024: vivi `LEARNINGS` + `sessions/`;
STATE/TREE/INDEX sono template). Esito **VERDE**, 0 correzioni meccaniche necessarie:
- **Link** — tutti i `[[wikilink]]` di note e LEARNINGS risolvono (4 note datate esistenti +
  INDEX/LEARNINGS/STATE/TREE). Nessun link rotto. (I `[[ -e … ]]` nei commenti IMP-032 sono
  sintassi bash, non wikilink.)
- **LEARNINGS coerente** — APERTE vuota, Applicate 001-035, Rimandate 023/026/027-graft/036/037;
  numerazione 001-037 completa; sha delle 4 nuove voci Applicate riempiti al checkpoint.
- **Riferimenti alle IMP spostate** — negli artefatti vivi non-LEARNINGS solo riferimenti
  corretti (docs/01 = ratifica IMP-034; CHANGELOG [0.5.0] cita IMP-036/037 come storia del
  rilascio, immutabile). Nessun claim stantio da correggere.
- **STATE/TREE/INDEX template** — confermato by-design (IMP-024), non un finding.
- **Orfani** — nessuno; questa nota è la più recente e linka le precedenti.
- **Osservazione (non-IMP, caso di giudizio)**: in regime ibrido il controllo 9 di
  `/lint-memory` (coerenza LEARNINGS↔STATE) è strutturalmente inerte, perché STATE è template
  e non c'è cruscotto vivo iniettato al SessionStart che rifletta un trigger IMP imminente (es.
  036/037→D3). È conseguenza NOTA e accettata di IMP-024 (il backlog vive in LEARNINGS,
  consultato on-demand), non un difetto — non aperta come IMP salvo diversa indicazione utente.

## Correzioni fattuali doc (Livello 1, docs/06)
- Nessuna: il deliverable APPLICA IMP decise (Livello 2); non corregge doc in disaccordo con
  la realtà (la convenzione di IMP-031 PREVIENE, non corregge un'istanza).

## Follow-up
- Cross-link CONTRIBUTING ↔ docs/01 (regime ibrido / blocco-piano) → **rimandato al deliverable
  README/CONTRIBUTING** (fuori scope qui, per decisione utente).
- `/integrate`: bump PATCH → `v0.5.0` → `v0.5.1`. Merge + tag + push = umano.

## Collegamenti
[[LEARNINGS]] · [[2026-07-17-upgrade-in-place-procedura]] · [[2026-07-17-harvest-framework-ponte]]
