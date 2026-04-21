# Report: example-medium

## Summary
- Feature: example-medium
- Outcome: pass

## Scope Delivered
- Added a medium worked example for stale-evidence handling across delegated analysis, fan-in, verify, review, and report.
- Demonstrated the delegation contract through a bounded `Codebase Reader` handoff and structured return artifact.
- Demonstrated a review-driven `rework` loop that rolled back to `VERIFY` after stale evidence was detected.

## Verification
- Evidence: `.specs/features/example-medium/run-history.json#RUN-008`, `.specs/features/example-medium/state.json`, `.specs/features/example-medium/run-history.md`
- Notes: Verification was rerun after the stale-evidence finding and is the fresh basis for the final review and report.

## Review
- Decision: pass
- Findings: initial stale verify evidence after fan-in required rework; final review passed after refresh.

## Evals
- Capability: EVAL-001 passed by showing delegated analysis, stale-evidence invalidation, and a formal review loop.
- Capability: EVAL-002 passed by aligning task decomposition, state, and run history.
- Regression: EVAL-003 passed by keeping the example artifact-only and concise.
- Thresholds used: one delegated report, one `rework` loop, one final `pass` decision, and aligned human/machine-readable artifacts.

## Residual Risks
- The example shows a single delegated reader and a single rework loop; more complex lanes would need additional fan-in examples.

## Reopen / Rollback Target
- VERIFY

## Final Decision
- [x] pass
- [ ] rework
- [ ] escalate
