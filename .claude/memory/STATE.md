---
type: state
updated: YYYY-MM-DD
branch: <branch di integrazione, es. develop>
tags: [state]
---
# STATE — [NOME PROGETTO]

> **Cos'è questo file.** È il punto d'ingresso della memoria: l'hook `SessionStart`
> lo inietta in ogni nuova sessione di Claude Code (vedi `.claude/settings.json`).
> Deve sempre rispondere a: *dove siamo, cosa esiste, cosa è stato deciso e non è
> ovvio dal codice, cosa è in sospeso*. Si RISCRIVE a ogni `/checkpoint` (non è
> append-only come le sessioni). Tienilo sintetico: è un cruscotto, non un diario.
>
> Cancella questo blocco di istruzioni quando inizializzi il progetto e sostituisci
> i contenuti di esempio qui sotto con quelli reali.

> Aggiornato: YYYY-MM-DD | Ultimo: **<ultima cosa completata>** | Indice: [[INDEX]]

## Stato avanzamento
<!-- Checklist degli obiettivi / milestone / "prompt" di alto livello. Spunta ciò
     che è fatto e annota il riferimento (commit/branch). Esempio: -->
- [ ] 01 — <primo blocco di lavoro> ← PROSSIMO
- [ ] 02 — <...>

## Cosa esiste adesso
<!-- Sintesi di ciò che è stato costruito, con rimando alle note di componente e
     di sessione (wikilink [[...]]). Una riga o due per componente, non un dump. -->
- Albero directory: vedi [[TREE]].
- <componente> — <stato (es. production-ready / scaffold / WIP)>, vedi
  [[<componente>]] e [[sessions/YYYY-MM-DD-<slug>]].

## Decisioni prese (non ovvie dal codice)
<!-- Solo ciò che NON si capisce leggendo il codice: scelte, alternative scartate,
     insidie. Le decisioni architetturali formali vanno in decisions/ (vedi il suo
     README); qui resta la sintesi + il rimando. -->
- <decisione> → motivo / alternativa scartata. Rimando: [[YYYY-MM-DD-<slug>]].

## Debito documentazione
<!-- Cosa andrà documentato e non lo è ancora (utile se la doc di progetto nasce
     dopo il codice). Si svuota man mano che il debito viene saldato. -->
- <sezione/pagina da scrivere> — <cosa deve contenere>

## Attenzione / problemi aperti
<!-- Trappole note, debito tecnico accettato, cose fragili da non rompere.
     Il debito di sicurezza accettato dal security gate (docs/03) va QUI, col motivo.
     Ogni voce col suo TRIGGER esplicito ("X → precondizione bloccante di Y",
     "riprendere quando Z"), MAI generica ("X da sistemare"): un debito col trigger
     riemerge al momento giusto, uno generico affoga nel rumore. Le voci devono
     SOPRAVVIVERE alle riscritture di questo file (verifica di /checkpoint). -->
- <problema aperto / debito accettato> — <motivo> → <trigger: quando blocca/riprende>
- [[LEARNINGS]]: stato delle proposte IMP (aperte / applicate / rimandate).

## Branch attivi
<!-- Quali branch esistono e a cosa servono. /checkpoint riconcilia questa sezione
     con `git branch --merged <integrazione>` perché i merge avvengono fuori sessione. -->
- **<branch di integrazione>** = integrazione.
- **feat/<...>** = <feature in corso>.
