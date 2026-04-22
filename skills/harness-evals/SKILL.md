---
name: harness-evals
description: Use when the workflow needs explicit eval definitions with stable EVAL IDs, requirement traceability, rerun triggers, and evidence rules before meaningful behavior change or final reporting.
---

# Harness Evals

This skill owns `EVAL DEFINE` and the eval-side evidence policy.

## Eval Contract

- Create `eval.md` before meaningful behavior change.
- Use stable eval IDs such as `EVAL-001`.
- Map each eval to the `REQ-*` it proves or protects.
- Prefer deterministic evidence when possible.
- Keep eval evidence and stale-evidence state explicit.

## Eval Types

- Capability evals prove new behavior.
- Regression evals protect existing behavior.

Medium work and above should name at least one concrete capability or regression eval. Large or high-risk work should usually include both.

## `eval.md`

`eval.md` should capture:

- `EVAL-*`
- linked `REQ-*`
- eval type
- evidence method
- thresholds when relevant
- assumptions or grader notes
- rerun triggers

## Rerun Triggers

Rerun dependent evals when any of these happen:

- implementation changes affect the covered behavior
- requirements change
- design changes affect the evaluated path
- thresholds or eval definitions change
- prior eval evidence is stale

## Eval Quality Checklist

Before finalizing `eval.md`, verify:

1. **Every REQ-* has EVAL-*** coverage (capability or regression)
2. **Evidence method is concrete**: command, inspection, or structured review
3. **Thresholds are measurable**: percentages, counts, or pass/fail criteria
4. **Rerun triggers are specific**: what file changes invalidate evidence?
5. **Rollback target is defined**: which phase to return to on failure?

## Common Eval Quality Issues

1. **Missing mapping**: REQ-* without corresponding EVAL-*
2. **Vague evidence method**: "inspect" instead of specific command or file
3. **No thresholds**: eval without pass/fail criteria
4. **Generic rerun triggers**: "any change" instead of specific files or patterns
5. **Missing rollback**: gate without defined rollback target

## Evidence Policy

- Eval evidence must be fresh enough for the current claim.
- Old eval results cannot justify new behavior after relevant changes.
- If eval definitions are wrong or incomplete, roll back to `EVAL DEFINE`.
- If requirements are not testable, roll back to `SPECIFY`.
- If the behavior fails the defined eval, roll back to `EXECUTE`.

## Reporting Expectations

`REPORT` should summarize which `EVAL-*` passed, which failed, what thresholds were used, and any residual risk or human judgment still required.
