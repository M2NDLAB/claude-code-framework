---
description: Scaffold a new component/module according to the project's conventions
---
Create a new component named $ARGUMENTS following the project's conventions EXACTLY.
The specific structure and tools are [TO BE DEFINED AT SETUP]: document them in the
"Project-specific technical rules" of CLAUDE.md and then align this command.

1. Read the project's technical rules (CLAUDE.md) and the note of the most similar
   component in .claude/memory/components/ to replicate its structure and conventions.
2. Create the component's module/folder in the project's standard location, with its
   dependency manifest inheriting from the shared configuration.
3. Apply the project's standard internal structure (e.g. separation by layer or by
   concern — [TO BE DEFINED AT SETUP]).
4. Include the basic elements expected of a "complete" component:
   - per-environment configuration (dev/prod);
   - production artefact (e.g. multi-stage non-root container — [TO BE DEFINED]);
   - first schema migration, if the component persists data;
   - health check / liveness endpoint, if it is a service;
   - API documentation (if it exposes an API);
   - structured logging with correlation-id;
   - an **integration smoke test** that starts the WHOLE component wired to the real
     dependencies and verifies that it really "wires" together (wiring gaps do not
     emerge from isolated units — see docs/02-code-quality.md, point 3 of the DoD).
5. Register the component in the overall build configuration and in the local startup
   system (e.g. compose/orchestrator), if applicable.
6. Create the note in .claude/memory/components/<component>.md and update INDEX.md,
   STATE.md, TREE.md (via /checkpoint).
