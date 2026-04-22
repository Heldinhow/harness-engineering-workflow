# Spec: <feature>

## Objective
<what this change achieves — be specific: "Add X behavior" not "improve X">

## Context
<why this work is needed now>

## Scope
### In
- <item>

### Out
- <item>

## Requirements

**Requirement Quality Rules:**
- Use "SHALL" for mandatory behavior (not "should" or "will")
- Each REQ-* must be testable with concrete evidence
- Avoid vague conditions like "when appropriate" — be specific

### REQ-001
- WHEN <condition> THEN the workflow SHALL <behavior>

### REQ-002
- WHEN <condition> THEN the workflow SHALL <behavior>

## Acceptance Criteria
- <observable outcome>

## Constraints
- <constraint>

## Dependencies
- <dependency or none>

## Notes
- <assumption or follow-up>

## Example

### REQ-001
- WHEN a user runs `harness validate` THEN the system SHALL exit with code 0 when all required artifacts are present.
