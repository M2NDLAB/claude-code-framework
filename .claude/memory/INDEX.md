---
type: index
updated: YYYY-MM-DD
tags: [moc]
---
# INDEX — memoria persistente [NOME PROGETTO] (MOC)

> **Cos'è questo file.** La mappa dei contenuti (Map Of Content) della memoria.
> [[STATE]] è il punto d'ingresso operativo (iniettato dall'hook); da qui invece
> si naviga tutto il resto. La cartella `.claude/` è pensata per aprirsi anche
> come vault Obsidian: i wikilink `[[...]]` generano il graph view, ma funzionano
> comunque come semplici rimandi in qualsiasi editor.
>
> Cancella questo blocco di istruzioni quando inizializzi il progetto e popola
> le sezioni man mano che nascono le note.

## Stato
- [[STATE]] — stato corrente: avanzamento, decisioni, debito doc, problemi aperti
- [[TREE]] — struttura del repository (rigenerata, mai editata a mano)
- [[LEARNINGS]] — backlog dei miglioramenti di processo (IMP): aperte / applicate / rimandate

## Per componente
<!-- Un rimando per ogni nota in components/. Stub finché il componente non nasce. -->
- [[<componente>]] — <una riga di stato>

## Per fase (sessioni — append-only)
<!-- Un rimando per ogni nota in sessions/, in ordine cronologico. -->
- [[sessions/YYYY-MM-DD-<slug>]] — <cosa è successo in quella sessione>

## Decisioni
<!-- Un rimando per ogni nota in decisions/ (o ai tuoi ADR formali). -->
- [[YYYY-MM-DD-<slug>]] — <sintesi della decisione>

## Piani
<!-- Piani di task per i prompt onerosi (vedi docs/01-task-planning.md). -->
- [[plans/<id-prompt>]] — <obiettivo> (status: in-progress | completed)
