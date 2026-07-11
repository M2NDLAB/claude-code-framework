---
type: tree
updated: YYYY-MM-DD
generated-by: /checkpoint
tags: [structure]
---
# Struttura del progetto

> **Cos'è questo file.** Una mappa della struttura del repository, da consultare
> PRIMA di esplorare il filesystem a mano (risparmia tempo e token). Si RIGENERA
> meccanicamente, **non si edita a mano**:
>
> ```
> tree -L 3 --dirsfirst -I '<pattern da ignorare per il tuo stack>'
> ```
>
> Il pattern da ignorare dipende dallo stack — [DA DEFINIRE AL SETUP]. Esempi tipici
> di cartelle da escludere: `node_modules`, `dist`, `build`, `target`, `.git`,
> `coverage`, cartelle di output dei build. Se `tree` non è installato, fallback:
> `git ls-files | tree --fromfile` oppure `git ls-files`.
>
> Cancella questo blocco di istruzioni quando inizializzi il progetto.

## Albero (generato)
```
<incolla qui l'output di `tree` rigenerato all'ultimo /checkpoint>
```

## Legenda directory chiave
<!-- Spiega cosa contiene ogni cartella di primo livello: serve a chi (umano o
     Claude) atterra nel repo senza conoscerlo. -->
| Path | Cosa contiene |
|---|---|
| .claude/docs/ | documentazione di processo (il "metodo") — caricare solo i file rilevanti |
| .claude/commands/ | slash command del metodo — l'elenco autorevole è in `CLAUDE.md`, "Comandi rapidi" |
| .claude/memory/ | questa memoria: [[STATE]], [[TREE]], [[INDEX]], sessions/, decisions/, components/, plans/ |
| <path> | <cosa contiene> |

## Note
<!-- Convenzioni di lettura dell'albero (es. profondità ridotta per componenti
     dalla struttura identica, dotfile non mostrati da `tree`, ecc.). -->
- `tree` non mostra i dotfile: esistono anche `.claude/`, `.gitignore`, ecc.
