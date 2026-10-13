# 03 — Security gate: mandatory review on sensitive components

Security has two levels in this framework:

1. **An always-on baseline** — the pre-commit hook runs secret scanning (gitleaks)
   on every commit: no secret in plaintext enters the repo (rule 1 of `CLAUDE.md`).
   It holds for everything, always, without exceptions. The hook protects commits
   from the moment it is installed, while git reads it — a hook manager that later sets
   `core.hooksPath` takes it out (`04-git-workflow.md`, *Enforcement of the execution
   boundary*): on a repo with PRE-EXISTING history (grafting the
   framework onto an existing project) the baseline is COMPLETED by a one-off scan of
   the whole history — `gitleaks detect` — as a setup step (step 3 of the framework's
   `SETUP.md`).
   Findings on the history are the user's decisions: a secret that has already been
   pushed must be rotated/revoked anyway; rewriting history is a different matter and
   is not done lightly.
2. **The gate on sensitive components** — a manual, dedicated security review BEFORE
   taking a critical component into integration. That is what this document is about.

## What "sensitive components" are

The components where a security defect has disproportionate impact:
authentication/authorisation, handling of payments or money, personal data, the edge
that performs enforcement (gateway/proxy), any surface that performs actions on
behalf of a client (e.g. a tool/automation server).

> **Which ones, concretely, in this project: [TO BE DEFINED AT SETUP].**
> List here (or in `CLAUDE.md`) the components that fall under the gate.

## How the gate works

On top of the Definition of Done (`02-code-quality.md`), BEFORE the merge request
(PR) towards the integration branch of a sensitive component:

1. **`/security-review`** run on the branch diff — and on the set a widened claim names
   (*The lenses of the gate*).
2. **HIGH/CRITICAL findings → RESOLVED** before the PR. Non-negotiable.
3. **MEDIUM findings → resolved**, or **explicitly accepted** as known debt in
   `memory/STATE.md`, with the reason for accepting them.
4. **LOW/INFO findings → at least recorded** (debt or backlog).

The gate is a GATE, not an optional activity: a component that is "complete" and has
green functional tests can still carry security defects the tests cannot see (a
bypassed check, a spoof, an exposed administrative endpoint). Only a dedicated review
finds them before they reach integration.

## The lenses of the gate

A review that reads only what the code DOES can miss what the product SAYS, and the path a
tool takes to its effect. Every review of the gate applies the two lenses below, and a
deliverable whose product asserts a security property is under the gate for that alone.

- **Claims, not only actions.** Every assertion the product makes about a security property
  — a status, a badge, a summary, an "OK", "nothing changed", "no leaks found" — is checked
  against what the code really does, not against the contract it is meant to honour. An
  assertion that something did NOT happen needs a datum that shows it — what was read, and
  how much —, kept apart from the classification it would otherwise be inferred from. A
  debt accepted below (*After the review*) turns into a broken promise the moment a label
  or a freshly written document asserts the contrary. The perimeter is the claim's, not the
  diff's: when a change widens a claim — from these N to all, a list of exceptions that
  disappears, a range of versions —, the review covers the set the claim names, beyond the
  files the change touched.
- **The real path.** A gate on an external tool covers what the tool does by itself on the
  way to its effect: what its configuration — the user's included — makes it do, and what it
  updates, writes or fetches unasked, read at its source or in its documentation. Each such
  path is closed by the tool's own off-switch, compensated, or declared as a known limit; a
  path left unread is a gap of the gate.

## When the review must be adversarial (author ≠ judge)

The criterion is not nominal severity but the **blast radius** of the defect:

- **Adversarial** — the verifier is NOT the author (a second agent, a second person,
  or a second pass with an explicit mandate to REFUTE): for security code in SHARED
  modules, where a defect propagates to several consumers. An author re-reading their
  own work tends to re-read their own assumptions.
- **Author-verifies** — sufficient (and adversarial review is overhead): for factual
  reconnaissance and inspectable local fixes, with zero blast radius.

**Before acting on the findings.** In a multi-agent review — especially after
interruptions or resumes — check COMPLETENESS against the right numbers: the
authoritative source is the review's SYNTHESIS, not the raw counts of an execution
journal (which retries can inflate). First reconcile the count, then act on the
findings.

**Review agents read, they never write.** The agents of a review are delegated agents:
read-only on git, reading the range with `git show`/`git diff` rather than checking it
out, with the shared repository's snapshot compared before and after the run —
`docs/04`, *Delegated agents and the shared working tree*.

## Prevention *by convention*

The gate finds defects; conventions prevent them. Where a whole class of errors can
be avoided with a rule (e.g. "management/diagnostics endpoints are never exposed on
the public surface", "every mutating endpoint goes through the authorisation check"),
write the convention into the project's technical rules instead of relying on a
case-by-case review.

## After the review

- The decisions to accept debt go into `STATE.md` (section *Caution & open issues*),
  with the reason.
- If the review teaches something about the **process** (e.g. a component missing
  from the list of sensitive ones, an absent convention), it becomes an IMP proposal
  in `LEARNINGS.md` — see `06-self-improvement.md`. Review lessons are among the best
  sources of improvement.
