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
- Artifacts: spec.md, eval.md, state.md, state.json, run-history.json, review.md, report.md

## Findings
- All 8 required artifacts present and non-empty
- state.md and state.json agree on current_phase="FINISH" and status="done"
- Evidence refs point to existing files (verified by score_workflow.sh)
- Rollback target is specific: "REVIEW"

## Decision
pass

## Required Rework
none

## Rollback Target
none (decision is pass)

## Evidence Reviewed
- `.specs/features/example-feature/score_workflow.sh` output: quality_score=1.0
- All evals passed

## Evidence Reviewed
- <evidence ref>

## Residual Risks
- <risk or none>

## Notes
- <review context>
