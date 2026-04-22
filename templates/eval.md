# Eval Definition: <feature>

## Evals

### EVAL-001
- Type: capability
- Maps to: REQ-001
- Description: <new behavior that must pass>
- Evidence method: <command, inspection, or structured review>
- Rerun triggers:
  - <change that invalidates this eval>
  - **Stale evidence check**: Has any relevant artifact changed since evidence was recorded?
- Thresholds:
  - <threshold if relevant>
- Rollback on failure: <phase to return to>

### EVAL-002
- Type: regression
- Maps to: REQ-002
- Description: <existing behavior that must still pass>
- Evidence method: <command, inspection, or structured review>
- Rerun triggers:
  - <change that invalidates this eval>
  - **Stale evidence check**: Has any relevant artifact changed since evidence was recorded?
- Thresholds:
  - <threshold if relevant>
- Rollback on failure: <phase to return to>

## Rework Detection Checklist
Before marking work complete, verify:
- [ ] Evidence is from the current artifact state (not stale)
- [ ] All REQ-* IDs in scope have corresponding EVAL-* coverage
- [ ] Eval rerun triggers are documented for each EVAL-*
- [ ] Rollback target is specific (phase name, not "earlier phase")

## Common Rework Patterns to Avoid
1. **Stale evidence pass**: Claiming completion with evidence recorded before recent changes
2. **Missing rollback**: Gates passed without recording where to return on failure
3. **Unmapped requirements**: REQ-* without corresponding EVAL-*
4. **Vague thresholds**: Evals without measurable thresholds or evidence methods

## Notes
- <grader assumptions or limits>

## Example

### EVAL-001
- Type: capability
- Maps to: REQ-001
- Description: The feature produces a spec.md with all required sections.
- Evidence method: Inspection of spec.md for sections: Objective, Context, Scope, Requirements, Acceptance Criteria.
- Rerun triggers:
  - Any edit to spec.md
  - **Stale evidence check**: Evidence captured before spec.md edit is stale.
- Thresholds:
  - All 5 sections present → pass
  - Missing sections → fail
- Rollback on failure: SPECIFY
