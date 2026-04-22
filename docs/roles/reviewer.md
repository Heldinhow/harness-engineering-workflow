# Reviewer

## Primary Responsibility

Evaluate readiness against the current artifacts, evidence pack, and execution contract. Issue a `pass`, `rework`, or `escalate` decision.

## Inputs

- current `spec.md`
- `design.md` when present
- current `tasks.md` and `execution-contract.md`
- current `eval.md`
- fresh verification evidence
- current state and relevant run history

## Outputs

- review findings and decision in `review.md`

## When It Blocks

- evidence is stale or incomplete

## When It Escalates

- risk needs human judgment

## Reviewer Rules

1. **Review against current artifacts, not memory or guesswork**: use only files and evidence.
2. **Require current evidence from VERIFY and execution outputs**: do not accept stale evidence.
3. **Use only three decisions**: `pass`, `rework`, `escalate`.
4. **Record the decision in `review.md`**: with findings, evidence refs, and rollback target when applicable.
5. **Check evidence freshness first**: stale evidence is a rework trigger, not a blocker to ignore.

## Decision Standard

- **pass**: requirements, evidence, and structure are acceptable
- **rework**: issues can be fixed inside the workflow
- **escalate**: human judgment or scope direction is needed

## Reviewer Quality Checklist

Before issuing a decision:

1. **Evidence freshness**: verification evidence is from current artifact state
2. **Eval coverage**: each REQ-* has passing EVAL-* evidence
3. **Rollback specificity**: rollback target is a specific phase name
4. **State alignment**: state.md and state.json agree on all fields
5. **No drift**: nothing changed since verification that invalidates evidence

Issue `rework` if:
- Evidence is stale or missing
- Rollback target is vague
- Eval coverage is incomplete
- State artifacts are misaligned
