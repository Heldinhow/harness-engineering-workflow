# Report: <feature>

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

## Example

### REPORT
## Summary
- Feature: example-feature
- Outcome: pass
- Completed: 2026-04-21T12:00:00Z

## Scope Delivered
- Added validation script `scripts/validate.sh`
- Updated `templates/tasks.md` with example

## Verification
- Evidence: `bash scripts/validate.sh example-feature` output
- Notes: All artifacts present, validation passes
- Evidence freshness: current (captured after last change)

## Review
- Decision: pass
- Findings: All requirements met, evals passed

## Evals
- Capability: EVAL-001 passed (validation script works)
- Regression: EVAL-002 passed (existing scripts still work)
- Thresholds used: exit code 0 = pass

## Evidence Freshness Check
- [x] All evidence_refs point to files that exist and reflect current state
- [x] No relevant artifacts were modified after evidence was recorded
- [x] Evidence is fresh (timestamp: 2026-04-21T12:00:00Z)

## Residual Risks
- None identified

## Reopen / Rollback Target
- **Phase**: REVIEW
- **Trigger**: New evidence shows validation script fails on some feature
- **Action**: Return to EXECUTE and fix validation script

## Final Decision
- [x] pass
- [ ] rework
- [ ] escalate
