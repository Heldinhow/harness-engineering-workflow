# Codebase Memory Map

## Top-level layout
- `README.md`: package overview and repository structure summary.
- `AGENTS.md`: short index pointing to detailed docs.
- `docs/workflow/`: per-phase lifecycle guidance.
- `docs/roles/`: who does what (Orchestrator, Codebase Reader, Spec Agent, etc.).
- `docs/standards/`: operational rules (rollback, evidence, parallelism, etc.).
- `skills/`: agent-facing operating instructions for workflow phases.
- `templates/`: artifact starter files.
- `schemas/`: JSON contracts for machine-readable state.
- `.specs/features/`: feature working sets used to exercise the workflow in-repo.
- `memory/`: fast orientation layer for future agents.
- `examples/`: worked example feature trees for small and medium changes.

## Recommended read paths by task

### General orientation
1. `AGENTS.md`
2. `docs/workflow/overview.md`
3. `memory/project/overview.md`
4. `memory/codebase/map.md`

### Workflow contract change
1. `AGENTS.md`
2. `docs/workflow/overview.md`
3. `docs/workflow/phases-and-gates.md`
4. `docs/standards/rollback-rules.md`
5. affected skills and templates

### Resume / state work
1. `docs/workflow/phases-and-gates.md`
2. `templates/state.*`
3. `templates/run-history.*`
4. `schemas/*.json`

### Delegation / Orchestrator behavior
1. `docs/roles/orchestrator.md`
2. `docs/standards/subagent-boundaries.md`
3. `docs/standards/parallelism.md`
4. `skills/harness-engineering-workflow/SKILL.md`

## Workflow vocabulary

Canonical phases: `INTAKE → SPECIFY → DESIGN (conditional) → TASKS → EXECUTION CONTRACT → EXECUTE → VERIFY → REVIEW → FINALIZE`

Role names: `Orchestrator`, `Codebase Reader`, `Spec Agent`, `Design Agent`, `Eval Agent`, `Implementer`, `Verifier`, `Reviewer`

Review decisions: `pass`, `rework`, `escalate`

Execution classes: `sequential`, `parallelizable`, `blocked`
