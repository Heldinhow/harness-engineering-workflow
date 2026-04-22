# Execution Contract: example-medium

## Run Scope
Demonstrate the EXECUTION CONTRACT phase as part of the medium-path workflow, showing how it locks run scope before fan-out.

## Included Requirements
- REQ-004: task definitions with deps and execution classes
- REQ-005: delegated analysis with bounded handoff
- REQ-006: state alignment discipline
- REQ-008: run-history transition recording
- REQ-009: stale evidence detection

## Excluded Requirements
- REQ-007 (installer manifest update) — deferred to separate run

## Included Tasks
- TASK-001: delegated codebase reading
- TASK-002: state artifact updates
- TASK-003: run-history artifact updates
- TASK-004: fan-in, verify, and review

## Excluded Tasks
- none

## Dependencies
- All dependencies resolved before fan-out

## Parallelism
- Execution class: parallelizable (TASK-001, TASK-002, TASK-003 can fan out; TASK-004 fans in)
- Rationale: delegated read, state update, and run-history update are independent lanes

## Expected Codebase Surfaces
- `templates/state.md`, `templates/state.json`
- `templates/run-history.md`, `templates/run-history.json`
- `docs/workflow/state-and-runs.md`
- `schemas/state.schema.json`, `schemas/run-history.schema.json`

## Mandatory Run Tests
- Vocabulary grep confirms canonical phase terms in updated docs
- State and run-history files pass JSON schema validation

## Done Criteria
- TASK-001, TASK-002, TASK-003 complete
- TASK-004 fan-in complete
- Evidence captured for each task
- State aligned and run history updated

## Rollback Routing
| Failure class | Rollback target |
|---|---|
| Scope mismatch | TASKS |
| Structural issue | DESIGN |
| Bad decomposition | TASKS |
| Implementation issue | EXECUTE |
| Stale evidence | VERIFY |
