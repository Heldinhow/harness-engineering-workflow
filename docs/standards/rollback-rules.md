# Rollback Rules

## Purpose

Route failures to the correct phase so rework is targeted and efficient.

## Rollback Routing Table

| Failure Class | Rollback Target |
|---|---|
| Ambiguity or bad requirements | SPECIFY |
| Structural inconsistency or bad design | DESIGN |
| Bad task decomposition or unsafe parallelism | TASKS |
| Incomplete implementation or failing tests | EXECUTE |
| Stale or missing evidence | VERIFY |

## What "Rollback" Means

Rollback means returning to a named phase to redo work that was insufficient. It does not mean undoing all changes or starting over. It means fixing the specific problem at the phase where it occurred.

## Rollback Specificity Rule

Every gate must define a specific phase as its rollback target. "go back", "earlier", "previous", or "before" are not valid rollback targets. Only phase names are valid: `SPECIFY`, `DESIGN`, `TASKS`, `EXECUTE`, or `VERIFY`.

## Rollback Documentation

Every gate should record:

- **Rollback target**: the specific phase to return to
- **Trigger**: what evidence would cause rollback
- **Action**: what changes would be needed at that phase

## Rollback in State Artifacts

- `state.json`'s `rollback_target` field must contain a specific phase name
- `run-history.json`'s `rollback_to_phase` field must contain a specific phase name
- `review.md` must name a specific phase in its Rollback Target section

## What Rollback Does NOT Mean

- Rollback does not delete all changes made after the target phase.
- Rollback does not mean "start over from scratch".
- Rollback does not happen at "the previous phase" without naming it.
