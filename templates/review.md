# Review: <feature>

## Scope Reviewed
- <artifact or change set>

## Findings
- <finding or none>

## Decision
- <pass / rework / escalate>

## Required Rework
- <item or none>

## Rollback Target
- <phase or none>

## Review Checklist
- [ ] Evidence is fresh (from current artifact state)
- [ ] All relevant EVAL-* have passing evidence
- [ ] Rollback target is specific: phase name, not vague ("earlier")
- [ ] No stale evidence referenced in findings
- [ ] State artifacts updated if decision is pass

## Common Rework Reasons
- Stale evidence: verification evidence recorded before recent changes
- Missing coverage: REQ-* without corresponding EVAL-* evidence
- Vague rollback: "earlier phase" instead of specific phase name
- Incomplete verification: VERIFY skipped or evidence not captured

## Example

### REVIEW
## Scope Reviewed
- Feature: example-feature
- Artifacts: spec.md, eval.md, state.md, state.json, run-history.json, review.md, finalize-report.md

## Findings
- All required artifacts present and non-empty
- state.md and state.json agree on current_phase="FINALIZE" and status="done"
- Evidence refs point to existing files (verified by grep)
- Rollback target is specific: "REVIEW"

## Decision
pass

## Required Rework
none

## Rollback Target
none (decision is pass)

## Evidence Reviewed
- grep output confirming new phase vocabulary in canonical docs
- All evals passed

## Residual Risks
- <risk or none>

## Notes
- <review context>
