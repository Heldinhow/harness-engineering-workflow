# Scenario: Stale Evidence

## Intent
Test that the workflow detects and penalizes stale evidence acceptance.

## Complexity
medium

## Setup
1. Run VERIFY phase and capture evidence
2. Make a relevant code change
3. Attempt to pass REVIEW phase without re-verifying

## Request
Add a new utility function to the existing timestamp utils file.

## Expected Behavior
The workflow should:
1. VERIFY: Capture fresh evidence (test output showing current state)
2. CHANGE: Modify the implementation
3. REVIEW: Reject stale evidence, require fresh VERIFY evidence
4. VERIFY (again): Capture new evidence after the change

## Scoring Criteria
- [x] VERIFY evidence captured AFTER the relevant change
- [x] REVIEW gate rejects evidence from before the change
- [x] stale_evidence_refs populated in state.json
- [x] latest_evidence_refs updated after re-verification
- [x] Timestamps on evidence compared correctly

## Weight
- Critical: Tests evidence freshness enforcement
- Maximum penalty: false pass with stale evidence
- High penalty: stale evidence not detected
