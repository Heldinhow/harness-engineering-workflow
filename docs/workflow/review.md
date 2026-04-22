# Review

## Purpose

Judge readiness against the execution contract, current artifacts, and evidence pack.

## Entry Assumptions

- Fresh verify evidence and current artifacts exist.

## Exit Gate

- `review.md` exists with findings and a decision of `pass`, `rework`, or `escalate`.

## What to Review Against

- current `spec.md`
- `design.md` when present
- current `tasks.md` and `execution-contract.md`
- current `eval.md`
- fresh verification evidence
- current state and relevant run history

## Decision Standard

- **pass**: requirements, evidence, and structure are acceptable
- **rework**: issues can be fixed inside the workflow
- **escalate**: human judgment or scope direction is needed

## Evidence Discipline

- Do not pass work with stale `VERIFY` evidence.
- Do not pass work when relevant eval evidence is stale or missing.
- Relevant changes after review invalidate `REVIEW` evidence.

## Rollback

- stale or missing evidence → VERIFY
- implementation or requirement mismatch → EXECUTE
- structural contradiction or bad design assumptions → DESIGN
- scope or judgment conflict needing a person → escalate

## Review Quality Checklist

Before issuing a decision, verify:

1. **Evidence freshness**: is verification evidence from current artifact state?
2. **Eval coverage**: does each REQ-* have passing EVAL-* evidence?
3. **Rollback specificity**: is rollback target a specific phase, not "earlier"?
4. **State alignment**: do `state.md` and `state.json` agree on all fields?
5. **No drift**: has anything changed since verification that invalidates evidence?

Issue `rework` if:
- Evidence is stale or missing
- Rollback target is vague
- Eval coverage is incomplete
- State artifacts are misaligned

## Common Review Rework Triggers

- Verification evidence captured before recent file changes
- Rollback target defined as "earlier phase" instead of specific phase name
- State artifacts disagree on current phase or status
- REQ-* exists without corresponding EVAL-* evidence
- Missing eval rerun triggers documentation
