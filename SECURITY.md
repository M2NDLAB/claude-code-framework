# Security Policy

> **Due livelli.** Questo file è la security policy del REPO DEL FRAMEWORK e, allo
> stesso tempo, lo scheletro da copiare in un progetto costruito sul framework: le
> parti `[DA DEFINIRE AL SETUP]` le compila il progetto; per il framework valgono
> i valori dichiarati qui.

## Segnalare una vulnerabilità

- **Per questo repo (il framework):** usa la segnalazione privata di GitHub
  (*Security → Report a vulnerability*, Security Advisories). NON aprire issue
  pubbliche per una vulnerabilità e non pubblicare PoC prima del fix.
- **Per un progetto costruito sul framework:** canale di segnalazione
  `[DA DEFINIRE AL SETUP]` (advisory privata della forge, indirizzo dedicato,
  bug bounty).

Cosa aspettarsi da una segnalazione: conferma di ricezione, valutazione
dell'impatto, fix o mitigazione, credito se gradito. Tempi di risposta:
`[DA DEFINIRE AL SETUP]` — per il framework: best effort.

## Versioni supportate

`[DA DEFINIRE AL SETUP]` per i progetti. Per il framework: riceve correzioni solo
l'ultima versione taggata (`git tag -l`).

## Prevenzione già attiva nel framework

Le difese vivono nel metodo, non duplicate qui:

- baseline anti-secret: hook pre-commit **gitleaks** (`make hooks-install`,
  regola 1 di `CLAUDE.md`); su un repo con storia preesistente si completa con
  la scansione one-off `gitleaks detect` dell'intera storia
  (`.claude/docs/03-security-gate.md`);
- review obbligatoria sui componenti sensibili: **security gate**,
  `.claude/docs/03-security-gate.md` (comando `/security-review`).
