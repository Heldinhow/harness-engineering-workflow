# Specify

## Purpose

Transform the classified request into clear, testable requirements with stable IDs and explicit scope boundaries.

## Entry Assumptions

- Feature id and goal are known from INTAKE.

## Exit Gate

- `spec.md` exists with scope, `REQ-*` IDs, and acceptance criteria.
- Requirements are specific, testable, and traceable.

## What to Produce

`spec.md` must define:

- **Objective**: what exactly changes, not why
- **Scope In / Out**: what is included and explicitly excluded
- **REQ-***: each requirement using "SHALL" for mandatory behavior
- **Acceptance Criteria**: observable outcomes that prove the requirement is met
- **Dependencies**: what must be true before execution
- **Constraints**: any non-negotiable limits

## Requirement Quality Rules

- Use "SHALL" for mandatory behavior, not "should", "will", or "may".
- Each REQ-* must be testable with concrete evidence.
- Avoid vague conditions like "when appropriate" — be specific.
- Requirements must not contradict each other.

## eval.md Placement

`eval.md` is created during or immediately after SPECIFY, but `EVAL DEFINE` is no longer a separate phase. The eval artifact lives here as part of the specification discipline and carries forward into execution, verification, and finalization.

## Rollback

- Ambiguity or contradiction in requirements → SPECIFY
- Missing scope or untestable REQ-* → SPECIFY

## Spec Quality Checklist

Before passing the SPECIFY gate, verify:

1. **Objective is concrete**: describes what changes, not why
2. **Scope is bounded**: explicit In and Out sections
3. **REQ-* are testable**: "SHALL" statements with measurable criteria
4. **REQ-* are traceable**: each maps to an acceptance criterion
5. **No conflicting requirements**: REQ-* do not contradict each other
