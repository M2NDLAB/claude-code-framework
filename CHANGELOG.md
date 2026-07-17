# Changelog

Le modifiche rilevanti di questo repo, nel formato
[Keep a Changelog](https://keepachangelog.com/it/1.1.0/); le versioni seguono il
SemVer su tag annotati definito in `.claude/docs/04-git-workflow.md`
(*Versioning*). Si aggiorna dentro `/integrate`, prima del blocco di merge+tag.

## [Unreleased]

## [0.4.0] — 2026-07-17

Comando `/harvest-framework` e ponte progetto→framework: le lezioni che riguardano
il metodo, emerse lavorando su un progetto-cliente, ora si marcano e risalgono al
template con una procedura ripetibile e sotto controllo umano (IMP-033).

### Added
- **`/harvest-framework`** (`.claude/commands/`): raccoglie dal backlog le IMP marcate
  `Destinazione: framework` e stampa un blocco copiabile, anonimizzato, pronto da
  riproporre come IMP nel repo del framework. Solo legge e stampa — nessun
  clone/copia/push/cross-repo (confine IMP-009, agnosticità); anti-vacuità sul caso
  vuoto; default sull'intero backlog, restringibile con `$ARGUMENTS` (IMP-033).
- Attributo **`Destinazione: framework`** nel formato IMP di `LEARNINGS.md` (riga
  fisica singola, grep-abile): marca, in un progetto-cliente, le lezioni da far
  risalire al framework; è un attributo di destinazione, non un livello (IMP-033).
- docs/06: sezione **"Il ponte verso il framework"** — come una lezione framework-bound
  si marca, come risale (curatela umana, con anonimizzazione) e perché il confine è
  solo-leggi-e-stampa; cross-link da README (*Filosofia*), `SETUP.md` §5 e
  `CONTRIBUTING.md` (IMP-033).

### Changed
- `CLAUDE.md` ("Comandi rapidi") e `README.md` ("Struttura"): `/harvest-framework`
  aggiunto agli elenchi dei comandi (IMP-033).

## [0.3.0] — 2026-07-17

Lezioni del primo innesto su un progetto esistente, verificate sui file e
applicate come IMP-027..030 (l'opzione `graft.sh` è rimandata con trigger).

### Added
- `SETUP.md`: sezione **"Innesto su un progetto ESISTENTE (brownfield)"** —
  criterio CASO A/B per `.claude/` preesistente, riconciliazione dei file in
  collisione (l'ospite ha la precedenza), primo comando come assessment
  read-only che popola la memoria dall'esistente, divergenze doc-vs-realtà
  registrate come debito, checklist *Igiene git ereditata* (audit dei tag,
  costanti di versione hard-coded, topologia dei branch decisa-e-dichiarata)
  (IMP-027, IMP-028a/c).
- docs/03 + `SETUP.md` passo 3: su un repo con storia preesistente la baseline
  gitleaks si completa con una scansione one-off dell'intera storia,
  `gitleaks detect` (IMP-028b).
- `/integrate`: guardia sulla base del versioning — `git describe --tags`
  accetta anche tag leggeri e nomi non-SemVer; su base non `vX.Y.Z` ci si ferma
  (IMP-028a).
- Voce "Lingua/e del progetto" nelle regole tecniche di `CLAUDE.md` e nella
  checklist di setup (IMP-029); compilazione dei `[DA DEFINIRE AL SETUP]` anche
  **in dialogo con Claude Code**, dichiarata come modalità equivalente (IMP-030).
- docs/06: perimetro del LIVELLO 1 — durante l'innesto la doc dell'ospite non si
  corregge d'ufficio (debito in `STATE.md`); a innesto completato rientra nel
  LIVELLO 1 (IMP-027).

### Fixed
- `hooks-install.sh` non sovrascrive più alla cieca: si ferma davanti a hook di
  altra origine (symlink degli hook manager inclusi) e a `core.hooksPath` attivo
  (hook installati-ma-inerti); `FORCE_OVERWRITE=1` fa backup `.bak` senza
  scrivere attraverso i symlink; le personalizzazioni dei propri hook vengono
  salvate in `.bak` al rilancio invece di essere distrutte (IMP-028d + review
  adversariale).
- docs/04 *Versioning*: razionale dei tag annotati corretto in forma descrittiva
  (`git describe` senza `--tags` usa i soli annotati; `/integrate` usa `--tags`
  e per questo verifica la base); marcatori `[DA DEFINIRE AL SETUP]` di
  `integrate.md` e di docs/04 ricompattati su una riga — erano invisibili al grep
  dichiarato dal setup.

### Changed
- Template `STATE.md`: "Debito documentazione" allargato alla doc
  esistente-ma-errata (IMP-027).

## [0.2.0] — 2026-07-11

Consolidamento: convenzioni di processo mancanti, sanatoria dei drift, file di
progetto del repo (IMP-009..025; IMP-023 e IMP-026 rimandate con trigger).

### Added
- `LICENSE` MIT del framework; licenza del progetto-cliente esplicitamente
  `[DA DEFINIRE AL SETUP]` (IMP-021).
- `SECURITY.md` (canale reale: GitHub Security Advisories + scaffold riusabile),
  `CONTRIBUTING.md` (workflow reale del repo), `CHANGELOG.md` con aggiornamento
  cablato in `/integrate` (IMP-022).
- docs/04: sezione *Confine di esecuzione e blocchi per l'utente* (IMP-009);
  igiene dei tag e verifiche pre-push, anche nel blocco di `/integrate` (IMP-010);
  regola "storia condivisa = per sempre" (niente nomi di progetti specifici)
  (IMP-025).
- docs/00: fasi a monte del deliverable strutturale (IMP-011), igiene di scope e
  di sessione (IMP-012), principio memoria-su-disco (IMP-013), effort
  proporzionale alle conseguenze (IMP-017), trigger di `/lint-memory` (IMP-018).
- docs/02: verifica su artefatti reali e *Test che dimostrano* (IMP-015);
  docs/03: review adversariale per raggio di propagazione e completezza dei
  finding (IMP-016).
- Debiti con trigger esplicito nel template `STATE.md`, verifica di sopravvivenza
  in `/checkpoint`, controllo coerenza LEARNINGS↔STATE in `/lint-memory` (IMP-014).

### Changed
- Merge parametrico in docs/04: sempre azione umana, via PR (team) o via blocco
  `/integrate` (sviluppatore singolo) — risolta la contraddizione interna (IMP-019).
- Regime di memoria del repo dichiarato "ibrido": vivi solo `LEARNINGS.md` e
  `sessions/`; svuotamento alla copia istruito in `SETUP.md` (IMP-024); modello
  trunk-based su `main` dichiarato in `CONTRIBUTING.md` (IMP-025).

### Removed
- Hook PreToolUse gitleaks da `settings.json`: non poteva mai bloccare (falsa
  sicurezza dimostrata); la difesa reale resta l'hook pre-commit (IMP-020).

## [0.1.0] — 2026-06-16

Prima versione taggata del template metodologico, estratto da un progetto reale.

### Added
- Sistema di memoria persistente: `STATE`, `TREE`, `INDEX`, `sessions/`,
  `components/`, `decisions/`, `plans/`, backlog dei miglioramenti (`LEARNINGS`).
- Doc di processo `00`–`06`: metodo e ciclo di fine deliverable (IMP-006/007),
  task planning resiliente con protocollo di refactor cross-modulo (IMP-003),
  code quality, security gate, git workflow con versioning SemVer (IMP-001) e
  branch di integrazione parametrico (IMP-008), escalation, auto-miglioramento.
- Slash command: `/checkpoint`, `/integrate` (IMP-002), `/sos`, `/retro`,
  `/security-review`, `/new-component`, `/lint-memory` (IMP-005).
- Hook git (`make hooks-install`): gitleaks (pre-commit) + commitlint
  (commit-msg); baseline dei permessi in `.claude/settings.json` (IMP-004).
- Script di processo: `hooks-install.sh`, `reset-task.sh`.
