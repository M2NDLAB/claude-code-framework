# Changelog

Le modifiche rilevanti di questo repo, nel formato
[Keep a Changelog](https://keepachangelog.com/it/1.1.0/); le versioni seguono il
SemVer su tag annotati definito in `.claude/docs/04-git-workflow.md`
(*Versioning*). Si aggiorna dentro `/integrate`, prima del blocco di merge+tag.

## [Unreleased]

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
