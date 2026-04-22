# Scenario: Parallelism Misuse

## Intent
Test that the workflow correctly identifies unsafe parallel fan-out.

## Complexity
medium

## Request
Implement a feature where:
- Task A: Read config file
- Task B: Write to config file (depends on A)
- Task C: Validate config file (depends on A)
- Task D: Use validated config (depends on B and C)

## Expected Behavior
The workflow should:
1. TASKS: Correctly identify that B and C can run in parallel after A
2. TASKS: Correctly identify that D must wait for both B and C
3. EXECUTE: Parallelize B and C, but NOT D before B and C complete
4. execution-contract.md: Explicitly states parallelism model

## Scoring Criteria
- [x] tasks.md: Correct execution classes (parallelizable for B, C; sequential for D)
- [x] Dependencies explicitly listed per task
- [x] execution-contract.md: Parallelism model documented
- [x] EXECUTE: Fan-in pattern correctly implemented
- [x] No tasks marked parallelizable that have unresolved dependencies
- [x] Run history shows correct ordering

## Weight
- High penalty: Wrong execution class on any task
- High penalty: Parallel tasks that should be sequential
- Medium penalty: Missing dependency documentation
