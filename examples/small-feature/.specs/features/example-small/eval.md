# Eval Definition: example-small

## Evals

### EVAL-001
- Type: capability
- Maps to: REQ-006
- Description: The report template includes a clear rollback target reminder for late gate failures.
- Evidence method: Inspect the updated report template and the example report output.
- Rerun triggers:
  - Any edit to `templates/report.md`
  - Any edit to the example report wording that changes rollback semantics
- Thresholds:
  - The report contains one explicit rollback target line.

### EVAL-002
- Type: regression
- Maps to: REQ-001, REQ-002, REQ-008, REQ-009, REQ-010
- Description: The example still demonstrates the lightweight small-feature path with spec, eval, state, run history, review, and report artifacts aligned.
- Evidence method: Inspect the example feature tree and compare the state and run history entries.
- Rerun triggers:
  - Any edit to `state.*`
  - Any edit to `run-history.*`
  - Any file add or remove inside the example feature tree
- Thresholds:
  - All required artifact files are present and internally consistent.

## Notes
- Deterministic verification is based on artifact inspection rather than executable runtime behavior.
