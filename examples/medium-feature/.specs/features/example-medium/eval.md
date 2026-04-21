# Eval Definition: example-medium

## Evals

### EVAL-001
- Type: capability
- Maps to: REQ-005, REQ-006, REQ-007, REQ-010
- Description: The medium example demonstrates delegated analysis, fan-in, stale-evidence invalidation, and a formal review loop.
- Evidence method: Inspect `delegation.md`, `codebase-reader-report.md`, `review.md`, and the later run-history entries.
- Rerun triggers:
  - Any edit to task boundaries or delegation scope
  - Any edit to review or report conclusions
- Thresholds:
  - One delegated analysis artifact
  - One explicit `rework` loop
  - One final `pass` review decision

### EVAL-002
- Type: capability
- Maps to: REQ-004, REQ-008, REQ-009
- Description: The example keeps task decomposition, state tracking, and run history aligned across human-readable and machine-readable forms.
- Evidence method: Compare `tasks.md`, `state.*`, and `run-history.*` for the same IDs, transitions, and rollback points.
- Rerun triggers:
  - Any edit to `tasks.md`
  - Any edit to `state.*`
  - Any edit to `run-history.*`
- Thresholds:
  - Task IDs, run IDs, and phase transitions stay internally consistent.

### EVAL-003
- Type: regression
- Maps to: REQ-001, REQ-002, REQ-010
- Description: The example stays concise and documentation-driven instead of becoming a runtime procedure.
- Evidence method: Inspect the artifact set for lightweight, human-readable guidance and no runtime-only assumptions.
- Rerun triggers:
  - Any new artifact that adds executable tooling requirements
  - Any expansion that makes the example no longer scannable as a worked example
- Thresholds:
  - The example remains artifact-only and bounded to one medium scenario.

## Notes
- This example uses inspection-based evals because the package is a workflow artifact set rather than a compiled system.
