# Eval Definition: harness-validation

## Evals

### EVAL-001: Artifact Coverage
- Type: regression
- Maps to: REQ-001, REQ-003, REQ-004, REQ-007, REQ-008
- Description: All 8 required artifacts are present (spec.md, eval.md, state.md, state.json, run-history.md, run-history.json, review.md, report.md) and non-empty.
- Evidence method: File existence check + non-empty check for each artifact.
- Rerun triggers: Any edit to artifact set.
- Thresholds:
  - 8/8 artifacts present and non-empty → score 1.0
  - 7/8 → score 0.875
  - <7/8 → score 0.0

### EVAL-002: Schema Compliance
- Type: regression
- Maps to: REQ-003, REQ-004
- Description: run-history.json and state.json pass JSON schema validation.
- Evidence method: Validate each JSON file against its schema using a scoring script.
- Rerun triggers: Any edit to run-history.json or state.json.
- Thresholds:
  - Both pass → score 1.0
  - One passes → score 0.5
  - Both fail → score 0.0

### EVAL-003: State Alignment
- Type: regression
- Maps to: REQ-004, REQ-005
- Description: state.md and state.json agree on current_phase, status, and last_run_id.
- Evidence method: Parse state.md for current_phase / status / last_run_id, compare with state.json.
- Rerun triggers: Any edit to state.md or state.json.
- Thresholds:
  - All 3 fields match → score 1.0
  - 2/3 match → score 0.66
  - <2/3 match → score 0.0

### EVAL-004: Phase Coverage
- Type: capability
- Maps to: REQ-003
- Description: run-history.json covers phases from SPECIFY through FINISH with proper transitions. Small features skip INTAKE, DESIGN, and TASKS per the workflow spec. INTAKE may be implicit (not always recorded). Small features start at SPECIFY.
- Evidence method: Inspect runs array — count unique phases and check they match the expected sequence for the feature complexity.
- Rerun triggers: Any edit to run-history.json.
- Thresholds:
  - Small: SPECIFY, EVAL DEFINE, EXECUTE, VERIFY, REVIEW, REPORT, FINISH (7/7) → score 1.0
  - Small: ≥6 of 7 phases → score 0.85
  - Medium/Large: INTAKE→FINISH all present → score 1.0
  - Any: ≥6 phases → score 0.75
  - Any: <6 phases → score 0.0

### EVAL-005: Evidence Quality
- Type: capability
- Maps to: REQ-003, REQ-005, REQ-006, REQ-007, REQ-008
- Description: Each run entry has evidence_refs pointing to valid files, rollback_target is defined at each gate, review.md has a decision field, and report.md has a rollback target section.
- Evidence method: Inspect each run's evidence_refs for file existence; check review.md for decision field; check report.md for rollback section.
- Rerun triggers: Any edit to artifacts.
- Thresholds:
  - ≥80% evidence refs valid + review has decision + report has rollback → score 1.0
  - ≥60% → score 0.75
  - ≥40% → score 0.5
  - <40% → score 0.0

### EVAL-006: State Drift Detection
- Type: regression
- Maps to: REQ-004
- Description: state.md and state.json must stay in sync. Any drift between them is a quality regression.
- Evidence method: Compare all shared fields between state.md and state.json. Any mismatch = drift detected.
- Rerun triggers: Any edit to state.md or state.json.
- Thresholds:
  - 0 mismatches → score 1.0
  - 1 mismatch → score 0.5
  - ≥2 mismatches → score 0.0

### EVAL-007: CI Pre-commit Hook
- Type: capability
- Maps to: REQ-010
- Description: The harness should include a pre-commit hook that runs score_workflow.sh on staged feature artifacts automatically.
- Evidence method: Check that scripts/pre-commit-quality-check.sh exists and is executable.
- Rerun triggers: Any edit to the installer or scripts directory.
- Thresholds:
  - Hook exists and executable → score 1.0
  - Hook exists but not executable → score 0.5
  - Hook missing → score 0.0

### EVAL-008: Spec Structure Validation
- Type: regression
- Maps to: REQ-001, REQ-002
- Description: spec.md and eval.md must have properly structured requirements and eval IDs. REQ-* IDs must follow sequential pattern. EVAL-* IDs must match between eval.md and run-history.json.
- Evidence method:
  1. Check spec.md has required sections: Objective, Context, Scope, Requirements, Acceptance Criteria.
  2. Extract REQ-* IDs from spec.md, verify sequential numbering.
  3. Extract EVAL-* IDs from eval.md, verify sequential numbering.
  4. Check run-history.json references only EVAL-* IDs that exist in eval.md.
- Rerun triggers: Any edit to spec.md, eval.md, or run-history.json.
- Thresholds:
  - All 5 sections + sequential IDs + valid EVAL refs → score 1.0
  - All sections + sequential IDs → score 0.8
  - Sections present but IDs not sequential → score 0.5
  - Missing required sections → score 0.0


## Composite Quality Score
The composite quality_score = weighted average:
- artifact_coverage × 0.15
- schema_compliance × 0.15
- state_alignment × 0.15
- state_drift × 0.05
- phase_coverage × 0.05
- evidence_quality × 0.15
- spec_structure × 0.10
- ci_hook × 0.20

## Notes
- Scoring script is defined in the experiment harness and is read-only.
- Scores are logged to autoresearch.jsonl for tracking across iterations.
- This eval is inspection-based: no runtime execution of the workflow is performed.
- EVAL-007 added after ci_hook improvement iteration.
