---
name: harness-review
description: Use when the workflow reaches the formal review gate and needs a pass, rework, or escalate decision with explicit evidence checks and rollback behavior.
---

# Harness Review

This skill owns `REVIEW`.

## Review Contract

- Review against the current artifacts, not memory or guesswork.
- Require current evidence from `VERIFY`, `eval.md`, and execution outputs.
- Use only these decisions: `pass`, `rework`, `escalate`.
- Record the decision in `review.md`.

## Review Inputs

Review should use:

- current `spec.md`
- `design.md` when present
- current `tasks.md` when present
- current `eval.md`
- fresh verification evidence
- current state and relevant run history

## Decision Standard

- `pass`: requirements, evidence, and structure are acceptable
- `rework`: issues can be fixed inside the workflow
- `escalate`: human judgment or scope direction is needed

## Review Failure And Rollback

- stale or missing evidence: roll back to `VERIFY`
- implementation or requirement mismatch: roll back to `EXECUTE`
- structural contradiction or bad design assumptions: roll back to `DESIGN`
- scope or judgment conflict needing a person: `escalate`

## Evidence Discipline

- Do not pass work with stale `VERIFY` evidence.
- Do not pass work when relevant eval evidence is stale or missing.
- Relevant changes after review invalidate `REVIEW` and `REPORT` evidence.

## Rework Detection Checklist

Before issuing `pass`, verify:

1. **Evidence freshness**: Is verification evidence from current artifact state?
2. **Eval coverage**: Does each REQ-* have passing EVAL-* evidence?
3. **Rollback specificity**: Is rollback target a specific phase, not "earlier"?
4. **State alignment**: Do `state.md` and `state.json` agree on all fields?
5. **No drift**: Has anything changed since verification that invalidates evidence?

Issue `rework` if:
- Evidence is stale or missing
- Rollback target is vague
- Eval coverage is incomplete
- State artifacts are misaligned

## Common Review Rework Triggers

- Verification evidence captured before recent file changes
- Rollback target defined as "earlier phase" instead of specific phase name
- State artifacts (state.md/json) disagree on current phase or status
- REQ-* exists without corresponding EVAL-* evidence
- Missing eval rerun triggers documentation

## Output

`review.md` should capture findings, decision, evidence references, rollback target when applicable, and residual risks.
