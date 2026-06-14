---
description: Scaffold di un nuovo componente/modulo secondo le convenzioni del progetto
---
Crea un nuovo componente chiamato $ARGUMENTS seguendo ESATTAMENTE le convenzioni del
progetto. La struttura e gli strumenti specifici sono [DA DEFINIRE AL SETUP]:
documentali nelle "Regole tecniche specifiche del progetto" di CLAUDE.md e poi
allinea questo comando.

1. Leggi le regole tecniche del progetto (CLAUDE.md) e la nota del componente più
   simile in .claude/memory/components/ per replicarne struttura e convenzioni.
2. Crea il modulo/cartella del componente nella posizione standard del progetto, con
   il suo manifest delle dipendenze che eredita dalla configurazione comune.
3. Applica la struttura interna standard del progetto (es. separazione per layer o
   per concern — [DA DEFINIRE AL SETUP]).
4. Includi gli elementi base attesi da un componente "completo":
   - configurazione per ambiente (dev/prod);
   - artefatto di produzione (es. container multi-stage non-root — [DA DEFINIRE]);
   - prima migrazione di schema, se il componente persiste dati;
   - health check / endpoint di liveness, se è un servizio;
   - documentazione dell'API (se espone un'API);
   - logging strutturato con correlation-id;
   - uno **smoke test di integrazione** che avvia l'INTERO componente cablato con le
     dipendenze reali e verifica che si "wiri" davvero (i gap di wiring non emergono
     dagli unit isolati — vedi docs/02-code-quality.md, punto 3 della DoD).
5. Registra il componente nella configurazione di build complessiva e nel sistema di
   avvio locale (es. compose/orchestratore), se previsto.
6. Crea la nota in .claude/memory/components/<componente>.md e aggiorna INDEX.md,
   STATE.md, TREE.md (via /checkpoint).
