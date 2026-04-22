# Report: example-small

> **Note**: `finalize-report.md` is the canonical closeout artifact for new features.
> `report.md` is kept for backward compatibility with existing feature working sets.
> This example demonstrates the new canonical workflow ending in FINALIZE.

## Summary
- Feature: example-small
- Outcome: pass

## Scope Delivered
- Updated `templates/report.md` to reflect the new workflow and add evidence freshness check.
- Demonstrated the complete small-path workflow: SPECIFY (with embedded eval) → EXECUTE → VERIFY → REVIEW → FINALIZE.
- Demonstrated that EVAL DEFINE is absorbed into SPECIFY as an artifact discipline.
- Demonstrated FINALIZE as the canonical closeout phase replacing REPORT+FINISH.

## Verification
- Evidence: `templates/report.md`, `.specs/features/example-small/state.json`, `.specs/features/example-small/run-history.json`
- Notes: Verify confirmed the example kept fresh evidence and aligned machine-readable artifacts after execution.

## Review
- Decision: pass
- Findings: Small feature follows the canonical new workflow correctly.

## Evals
- Capability: EVAL-001 passed by inspection of the report artifact contract.
- Regression: EVAL-002 passed by inspection of the compact artifact set and aligned state/run history.
- Thresholds used: all evals green

## Residual Risks
- None identified

## Reopen / Rollback Target
- **Phase**: REVIEW
- **Trigger**: New evidence shows template update was incomplete
- **Action**: Return to VERIFY and re-run checks

## Final Decision
- [x] pass
- [ ] rework
- [ ] escalate
