# Project Memory Overview

## What this repository is
- A documentation-first workflow package for Orchestrator-led agent work.
- It defines phases, gates, artifacts, skills, templates, and schemas rather than a runtime.
- The main goal is resumable, evidence-based work without broad repo rereads.

## Read this first
1. `AGENTS.md` — quick map and principles
2. `docs/workflow/overview.md` — layered workflow overview
3. `docs/workflow/phases-and-gates.md` — phase table with entry/exit/gate/rollback
4. `memory/project/*.md` — project orientation
5. `memory/codebase/*.md` — codebase orientation
6. Only then the specific `docs/`, `skills/`, or `templates/` files needed for the current task.

## Core operating model
- The main agent is the `Orchestrator`.
- Broad reading is delegated; the Orchestrator should prefer filtered outputs.
- Phase order is fixed: `INTAKE → SPECIFY → DESIGN → TASKS → EXECUTION CONTRACT → EXECUTE → VERIFY → REVIEW → FINALIZE`.
- Review decisions are fixed: `pass`, `rework`, `escalate`.

## Repository shape
- `docs/workflow/`: per-phase lifecycle guidance
- `docs/roles/`: who does what
- `docs/standards/`: operational rules (rollback, evidence, parallelism, etc.)
- `skills/`: role and phase behavior
- `templates/`: artifact skeletons
- `schemas/`: JSON stability for machine-readable state and run history
- `.specs/features/`: in-repo working sets for actual feature work
- `examples/`: worked small and medium feature trees

## What to avoid rereading
- Do not start from all skills or all templates.
- Do not scan `.specs/` broadly unless the current lane explicitly depends on feature state.
- Use memory docs to decide the smallest useful read set first.
