# Security Policy

> **Two levels.** This file is the security policy of the FRAMEWORK REPO and, at the
> same time, the skeleton to copy into a project built on the framework: the
> `[TO BE DEFINED AT SETUP]` parts are filled in by the project; for the framework
> the values declared here apply.

## Reporting a vulnerability

- **For this repo (the framework):** use GitHub's private reporting
  (*Security → Report a vulnerability*, Security Advisories). Do NOT open public
  issues for a vulnerability and do not publish a PoC before the fix.
- **For a project built on the framework:** reporting channel
  `[TO BE DEFINED AT SETUP]` (private advisory on the forge, dedicated address,
  bug bounty).

What to expect from a report: acknowledgement of receipt, impact assessment, fix or
mitigation, credit if desired. Response times:
`[TO BE DEFINED AT SETUP]` — for the framework: best effort.

## Supported versions

`[TO BE DEFINED AT SETUP]` for projects. For the framework: only the latest tagged
version receives fixes (`git tag -l`).

## Prevention already active in the framework

The defences live in the method, they are not duplicated here:

- anti-secret baseline: **gitleaks** pre-commit hook (`make hooks-install`,
  rule 1 of `CLAUDE.md`); on a repo with pre-existing history it is completed by
  the one-off `gitleaks detect` scan of the entire history
  (`.claude/docs/03-security-gate.md`);
- mandatory review on sensitive components: **security gate**,
  `.claude/docs/03-security-gate.md` (command `/security-review`).
