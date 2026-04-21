# Spec: example-small

## Objective
Add a rollback-target reminder to the final report template so a local documentation change still leaves a clear rework destination when a late gate fails.

## Context
The workflow already requires rollback targets at each phase, but the final report artifact can still be written without restating where the feature should return if a last-minute verify or review issue appears.

## Scope
### In
- Update the report template to carry an explicit rollback target reminder.
- Keep the change local to one template and document the workflow evidence for the example.

### Out
- Changes to execution logic, schemas, or delegation guidance.
- Any medium-or-larger planning artifacts.

## Requirements

### REQ-001
- WHEN this local template change enters the workflow THEN the example SHALL show that `spec.md` existed before execution.

### REQ-002
- WHEN the template changes the report contract THEN the example SHALL define eval criteria before execution.

### REQ-006
- WHEN the feature reaches each gate THEN the example SHALL record required evidence and a rollback target.

### REQ-008
- WHEN the example records state THEN it SHALL include aligned `state.md` and `state.json` artifacts.

### REQ-009
- WHEN the example records execution history THEN it SHALL include aligned `run-history.md` and `run-history.json` artifacts.

### REQ-010
- WHEN a contributor wants to understand a small local lane THEN the example SHALL be concise enough to read without broad repo rereads.

## Acceptance Criteria
- The artifact set shows a small feature that skips design and tasks while still recording evals, state, runs, review, and report.
- The report outcome makes the rollback target explicit.
- The example vocabulary matches the repository phase, review, and rollback terms.

## Constraints
- Keep the example artifact-only and local in scope.
- Keep the scenario realistic for a documentation-driven repository.

## Dependencies
- Root workflow vocabulary from `README.md`, `AGENTS.md`, and `docs/workflow/phases-and-gates.md`.

## Notes
- This example intentionally ends in `FINISH` with fresh evidence already consolidated.
