# Spec: example-medium

## Objective
Add stale-evidence handling to state and run-history guidance so medium work can survive delegated fan-in without losing track of which gate evidence must be refreshed.

## Context
The workflow already defines stale-evidence rules, but a medium feature that uses delegated analysis and multiple execution lanes needs a worked example showing how stale evidence appears, how rollback targets are chosen, and how review returns `rework` until verification is refreshed.

## Scope
### In
- Show a medium feature with spec, design, tasks, eval, delegation, codebase-reader output, review, state, run history, and report.
- Demonstrate one delegated `Codebase Reader` lane.
- Demonstrate one review-driven rework loop caused by stale verify evidence after fan-in.

### Out
- Executable automation for invalidating evidence.
- Additional runtime tools or command-line helpers.

## Requirements

### REQ-001
- WHEN this medium feature starts THEN the example SHALL show a stable `spec.md` before execution.

### REQ-002
- WHEN the feature changes workflow guidance THEN the example SHALL define evals before meaningful implementation.

### REQ-004
- WHEN work is decomposed THEN each task SHALL declare requirement traceability, dependencies, and execution class.

### REQ-005
- WHEN the Orchestrator delegates analysis THEN the example SHALL use the minimal context contract and structured output contract.

### REQ-006
- WHEN each phase exits THEN the example SHALL record required evidence and a rollback target.

### REQ-007
- WHEN review runs THEN the example SHALL show a formal `pass`, `rework`, or `escalate` decision.

### REQ-008
- WHEN progress is recorded THEN the example SHALL keep `state.md` and `state.json` aligned.

### REQ-009
- WHEN execution history is recorded THEN the example SHALL keep `run-history.md` and `run-history.json` aligned with transitions, failures, loops, and decisions.

### REQ-010
- WHEN a contributor wants to resume a medium feature THEN the example SHALL reduce repo rereading by showing delegated findings, task boundaries, and final consolidated evidence.

## Acceptance Criteria
- The artifact set includes every required medium-work file and uses the repository vocabulary exactly.
- Delegation is visible through both `delegation.md` and `codebase-reader-report.md`.
- Review shows a `rework` loop tied to stale evidence and a final `pass` after rerunning verify.
- State and run history tell the same story.

## Constraints
- Keep the example concise enough to scan in one sitting.
- Keep the scenario realistic for a docs-and-templates repository.

## Dependencies
- Workflow guidance in `docs/workflow/delegation.md`, `docs/workflow/parallelism.md`, and `docs/workflow/state-and-runs.md`.
- Template and schema structure under `templates/` and `schemas/`.

## Notes
- This example uses delegated reading only for bounded analysis; the Orchestrator still owns fan-in, verify, review, report, and finish.
