# Scenario: Task Dependency Failure

## Intent
Test that the workflow correctly identifies and handles task dependency violations.

## Complexity
medium

## Request
Implement a feature with the following constraints:
- Task B depends on Task A
- Task C depends on Task B
- All tasks must be executed in order

**Feature**: Create a simple build pipeline with three stages: validate, build, test.

## Expected Behavior
The workflow should:
1. TASKS: Correctly identify dependencies (B blocks C, A blocks B)
2. EXECUTE: Execute in dependency order
3. VERIFY: Evidence shows dependencies were respected
4. If tasks executed out of order: rollback to TASKS or EXECUTE

## Scoring Criteria
- [x] tasks.md shows correct dependency graph
- [x] execution-contract.md respects dependencies
- [x] Tasks executed in correct order
- [x] Blocked tasks show explicit "blocked" status
- [x] Rollback targets named correctly (TASKS or EXECUTE)
- [x] No dependency violations in run history

## Weight
- High penalty for: invalid fan-out, wrong execution class
- Tests parallelism misuse scoring
