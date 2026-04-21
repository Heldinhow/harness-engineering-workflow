# Project Memory Overview

## What this repository is
- A documentation-first workflow package for Orchestrator-led agent work.
- It defines phases, gates, artifacts, skills, templates, and schemas rather than a runtime.
- The main goal is resumable, evidence-based work without broad repo rereads.

## Read this first
1. `README.md`
2. `AGENTS.md`
3. `memory/project/*.md`
4. `memory/codebase/*.md`
5. Only then the specific `docs/`, `skills/`, or `templates/` files needed for the current task.

## Core operating model
- The main agent is the `Orchestrator`.
- Broad reading is delegated; the Orchestrator should prefer filtered outputs.
- Phase order is fixed: `INTAKE → SPECIFY → DESIGN → TASKS → EVAL DEFINE → EXECUTE → VERIFY → REVIEW → REPORT → FINISH`.
- Review decisions are fixed: `pass`, `rework`, `escalate`.

## Repository shape
- `docs/workflow/`: human-facing workflow reference.
- `skills/`: role and phase behavior.
- `templates/`: artifact skeletons.
- `schemas/`: JSON stability for machine-readable state and run history.
- `.specs/features/`: in-repo working sets for actual feature work.
- `examples/`: worked small and medium feature trees.

## What to avoid rereading
- Do not start from all skills or all templates.
- Do not scan `.specs/` broadly unless the current lane explicitly depends on feature state.
- Use memory docs to decide the smallest useful read set first.
