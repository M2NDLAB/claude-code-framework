# Changelog

Le modifiche rilevanti di questo repo, nel formato
[Keep a Changelog](https://keepachangelog.com/it/1.1.0/); le versioni seguono il
SemVer su tag annotati definito in `.claude/docs/04-git-workflow.md`
(*Versioning*). Si aggiorna dentro `/integrate`, prima del blocco di merge+tag.

## [Unreleased]

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
