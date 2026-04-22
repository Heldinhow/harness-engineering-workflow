# Report: <feature>

> **Note**: `finalize-report.md` is the canonical closeout artifact for new features.
> `report.md` is kept for backward compatibility with existing feature working sets.
> New features should use `templates/finalize-report.md`.

## Summary
- Feature: <name>
- Outcome: <pass / rework / escalate>
- Completed: <ISO 8601 timestamp>

## Scope Delivered
- <item>

## Verification
- Evidence:
- Notes:
- Evidence freshness: <current / stale - describe changes since capture>

## Review
- Decision: <pass / rework / escalate>
- Findings:

## Evals
- Capability:
- Regression:
- Thresholds used:

## Evidence Freshness Check
Before finalizing this report, verify:
- [ ] All evidence_refs point to files that exist and reflect current state
- [ ] No relevant artifacts were modified after evidence was recorded
- [ ] If evidence is stale, either re-verify or update rollback target

## Residual Risks
- <risk>

## Reopen / Rollback Target
- **Phase**: <specific phase name>
- **Trigger**: <what evidence would cause rollback>
- **Action**: <what changes would be needed>

## Final Decision
- [ ] pass
- [ ] rework
- [ ] escalate
