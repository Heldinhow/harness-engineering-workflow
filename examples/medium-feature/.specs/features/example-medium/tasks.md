# Tasks: example-medium

## Execution Mode
- Plan-driven

## Tasks

### TASK-001
Objective: Produce a bounded codebase-reading report that isolates only the workflow material needed for the medium example.
Maps to: REQ-005, REQ-010
Related evals: EVAL-001, EVAL-003
Owner role: Codebase Reader
Execution class: sequential
Depends on: none
Required artifacts:
- `spec.md`
- `eval.md`
- `delegation.md`
Minimal context:
- Review only the workflow docs and artifacts that define delegation, fan-in, stale evidence, and state/run structure.
Files/areas:
- `docs/workflow/delegation.md`
- `docs/workflow/parallelism.md`
- `docs/workflow/state-and-runs.md`
- `templates/state.md`
- `templates/state.json`
- `templates/run-history.md`
- `templates/run-history.json`
- `schemas/state.schema.json`
- `schemas/run-history.schema.json`
Ready definition:
- `spec.md` and `eval.md` exist.
Done definition:
- `codebase-reader-report.md` returns only relevant files, a technical summary, expected impact, risks, dependencies, and objective recommendations.
Expected evidence:
- `.specs/features/example-medium/codebase-reader-report.md`

### TASK-002
Objective: Update the example state guidance and artifacts using only the delegated reader output and the scoped state files.
Maps to: REQ-004, REQ-006, REQ-008
Related evals: EVAL-001, EVAL-002
Owner role: Execution Agent
Execution class: parallelizable
Depends on: TASK-001
Required artifacts:
- `codebase-reader-report.md`
- `state.md`
- `state.json`
Minimal context:
- Use the reader report to update state guidance and state artifacts without rereading unrelated files.
Files/areas:
- `docs/workflow/state-and-runs.md`
- `templates/state.md`
- `templates/state.json`
- `schemas/state.schema.json`
Ready definition:
- Shared stale-evidence vocabulary is stable from TASK-001.
Done definition:
- State guidance and artifacts explicitly distinguish fresh evidence from stale evidence and define resume-safe ownership fields.
Expected evidence:
- updated state docs and aligned example `state.*`

### TASK-003
Objective: Update the example run-history guidance and ledger artifacts using the same bounded delegated context.
Maps to: REQ-004, REQ-006, REQ-009
Related evals: EVAL-001, EVAL-002
Owner role: Execution Agent
Execution class: parallelizable
Depends on: TASK-001
Required artifacts:
- `codebase-reader-report.md`
- `run-history.md`
- `run-history.json`
Minimal context:
- Use the reader report to update run-history guidance and machine-readable ledger details without changing state semantics.
Files/areas:
- `templates/run-history.md`
- `templates/run-history.json`
- `schemas/run-history.schema.json`
Ready definition:
- Shared stale-evidence vocabulary is stable from TASK-001.
Done definition:
- Run history examples clearly record transitions, stale-evidence failures, rollback targets, and final decisions.
Expected evidence:
- updated run-history docs and aligned example `run-history.*`

### TASK-004
Objective: Fan in the execution lanes, refresh stale evidence when needed, and close the medium example with review and report artifacts.
Maps to: REQ-004, REQ-006, REQ-007, REQ-010
Related evals: EVAL-001, EVAL-002, EVAL-003
Owner role: Orchestrator
Execution class: sequential
Depends on: TASK-002, TASK-003
Required artifacts:
- `review.md`
- `report.md`
- `state.md`
- `state.json`
- `run-history.md`
- `run-history.json`
Minimal context:
- Fan in both execution lanes, refresh state, and review the consolidated evidence.
Files/areas:
- `.specs/features/example-medium/`
Ready definition:
- Both parallel lanes are complete and non-conflicting.
Done definition:
- Verify, review, and report evidence are fresh; if stale evidence is found, the lane loops back explicitly before finishing.
Expected evidence:
- `.specs/features/example-medium/review.md`
- `.specs/features/example-medium/report.md`
