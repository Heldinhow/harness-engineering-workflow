# Spec: harness-validation

## Objective
Validate the harness engineering workflow by executing a small feature end-to-end and measuring quality against defined evals.

## Context
The workflow package has no automated quality gate. Running a real feature through the workflow lets us measure: artifact completeness, schema compliance, phase coverage, evidence quality, and state alignment. Results feed back into improving the workflow itself.

## Scope
### In
- Execute one small feature (add quick-start section to README) using the workflow.
- Produce all required artifacts: spec.md, eval.md, state.md, state.json, run-history.md, run-history.json, review.md, report.md.
- Score the quality of each artifact.

### Out
- Changes to installer or execution logic.
- Design or tasks artifacts (this is a small feature, scope is local).

## Requirements

### REQ-001
- WHEN the feature enters the workflow THEN spec.md SHALL exist before execution.

### REQ-002
- WHEN the feature modifies workflow behavior THEN eval criteria SHALL be defined before execution.

### REQ-003
- WHEN the feature completes each phase THEN run-history.json SHALL record phase, transition, evidence_refs, and decision.

### REQ-004
- WHEN the feature records state THEN state.json SHALL match state.md content.

### REQ-005
- WHEN the feature reaches VERIFY THEN state SHALL reflect current phase and evidence refs SHALL be valid files.

### REQ-006
- WHEN the feature reaches each gate THEN rollback_target SHALL be defined.

### REQ-007
- WHEN the feature reaches REVIEW THEN review.md SHALL contain pass/rework/escalate decision with rationale.

### REQ-008
- WHEN the feature completes THEN report.md SHALL consolidate evidence and include a rollback target.

### REQ-009
- WHEN the feature is scored THEN quality_score SHALL be computed from: artifact coverage (0-1), schema compliance (0-1), phase coverage (0-1), evidence quality (0-1), state alignment (0-1).

## Acceptance Criteria
- All 8 required artifacts are present and non-empty.
- run-history.json passes JSON schema validation.
- state.json passes JSON schema validation.
- state.md and state.json agree on current_phase, status, and last_run_id.
- review.md contains a decision field with value pass, rework, or escalate.
- quality_score ≥ 0.7 on baseline.

## Constraints
- Feature is small: no design.md, tasks.md, or delegation.md.
- Scoring script is read-only (does not modify artifacts).
- Score is computed from artifact inspection only.

## Dependencies
- Schema files: schemas/run-history.schema.json, schemas/state.schema.json.
- Templates: templates/state.md, templates/state.json, templates/run-history.md, templates/run-history.json.

## Notes
- This is a meta-feature: it validates the workflow by running the workflow.
- Score drives the next iteration of workflow improvements.
