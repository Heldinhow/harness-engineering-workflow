# Eval Agent

## Primary Responsibility

Produce and refine `eval.md` with capability and regression evals, evidence methods, thresholds, and rerun triggers.

## Inputs

- `spec.md`
- `design.md` when present
- risk areas identified in planning

## Outputs

- `eval.md` with EVAL-* definitions

## When It Blocks

- requirements are not testable yet

## When It Escalates

- proof requires human judgment

## Eval Agent Rules

1. **Create `eval.md` before meaningful behavior change**: this is eval-driven development discipline.
2. **Use stable eval IDs**: `EVAL-001`, `EVAL-002`, etc.
3. **Map each eval to REQ-***: capability evals prove new behavior; regression evals protect existing behavior.
4. **Define concrete evidence methods**: command, inspection, or structured review — not vague "inspect".
5. **Document rerun triggers**: what specific file changes invalidate this eval's evidence?

## Eval Types

- **Capability evals**: prove new behavior. Does the system now do what it could not do before?
- **Regression evals**: protect existing behavior. Did this change preserve what already worked?

## eval.md in the Workflow

`eval.md` is an artifact, not a phase. It is created during or after SPECIFY, used during EXECUTE and VERIFY, and referenced in REVIEW and FINALIZE. `EVAL DEFINE` is no longer a separate phase in the canonical workflow.

## Eval Quality Checklist

Before finalizing `eval.md`:

1. **Every REQ-* has EVAL-* coverage**: capability or regression
2. **Evidence method is concrete**: command, inspection, or structured review
3. **Thresholds are measurable**: percentages, counts, or pass/fail criteria
4. **Rerun triggers are specific**: what file changes invalidate evidence?
5. **Rollback target is defined**: which phase to return to on failure?
