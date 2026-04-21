# Codebase Memory Map

## Top-level layout
- `README.md`: package overview and repository structure summary.
- `AGENTS.md`: repository rules, reading policy, delegation contract, and resume order.
- `docs/workflow/`: canonical workflow reference pages.
- `skills/`: agent-facing operating instructions for workflow phases.
- `templates/`: artifact starter files.
- `schemas/`: JSON contracts for machine-readable state.
- `.specs/features/`: feature working sets used to exercise the workflow in-repo.
- `memory/`: fast orientation layer for future agents.
- `examples/`: worked example feature trees for small and medium changes.

## Recommended read paths by task

### General orientation
1. `README.md`
2. `AGENTS.md`
3. `memory/project/overview.md`
4. `memory/codebase/map.md`

### Workflow contract change
1. `AGENTS.md`
2. `docs/workflow/overview.md`
3. `docs/workflow/phases-and-gates.md`
4. `docs/workflow/codebase-reading.md`
5. affected skills and templates

### Resume / state work
1. `docs/workflow/state-and-runs.md`
2. `templates/state.*`
3. `templates/run-history.*`
4. `schemas/*.json`

### Delegation / Orchestrator behavior
1. `docs/workflow/agent-roles.md`
2. `docs/workflow/delegation.md`
3. `docs/workflow/parallelism.md`
4. `skills/harness-engineering-workflow/SKILL.md`

## Current repository note
- `memory/` did not exist before this lane; use it as the first stop for future orientation.
- `examples/` now provides artifact-only reference trees that mirror the revised workflow contract.
