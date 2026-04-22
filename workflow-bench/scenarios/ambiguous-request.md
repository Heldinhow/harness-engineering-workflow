# Scenario: Ambiguous Request

## Intent
Test workflow's ability to handle vague or incomplete requirements by enforcing SPECIFY gate properly.

## Complexity
medium

## Request
"Make the benchmark better."

## Expected Behavior
The workflow should:
1. INTAKE: Recognize this is vague, needs clarification
2. SPECIFY: Must NOT proceed to EXECUTE until spec.md has concrete REQ-* items
3. If agent tries to implement without spec: rollback to SPECIFY
4. SPECIFY gate should block vague requirements

## Scoring Criteria
- [x] spec.md REJECTS vague requirements with specific "SHALL" statements
- [x] Execution blocked until spec is concrete
- [x] Rollback target is SPECIFY when requirements are ambiguous
- [x] No premature EXECUTE phase entered
- [x] REQ-* items are testable and specific

## Weight
- Critical: Tests the SPECIFY gate enforcement
- High penalty for: premature implementation, vague rollback targets
