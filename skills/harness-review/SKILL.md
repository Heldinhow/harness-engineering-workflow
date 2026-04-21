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

## Output

`review.md` should capture findings, decision, evidence references, rollback target when applicable, and residual risks.
