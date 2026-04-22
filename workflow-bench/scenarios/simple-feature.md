# Scenario: Simple Feature

## Intent
Test basic workflow adherence for a straightforward, single-file feature with clear requirements.

## Complexity
small

## Request
Add a function `format_timestamp(timestamp: number, timezone: string): string` to `workflow-bench/fixtures/timestamp-utils.js` that formats Unix timestamps in a human-readable format. Include timezone support.

## Expected Behavior
The workflow should:
1. INTAKE: Classify as small, non-complex work
2. SPECIFY: Create spec.md with REQ-* requirements
3. DESIGN: Skip (trivial structure)
4. TASKS: Create minimal tasks.md or skip entirely
5. EXECUTION CONTRACT: Create execution-contract.md for run scope
6. EXECUTE: Implement the function with tests
7. VERIFY: Run tests and capture evidence
8. REVIEW: Review against spec
9. FINALIZE: Create finalize-report.md with test evidence

## Scoring Criteria
- [x] Phase order followed correctly
- [x] spec.md contains clear REQ-* statements
- [x] execution-contract.md exists before EXECUTE
- [x] Tests pass and evidence is captured
- [x] finalize-report.md exists at completion
- [x] state.md and state.json aligned
- [x] run-history.json updated per phase

## Weight
- Baseline scenario for workflow correctness
