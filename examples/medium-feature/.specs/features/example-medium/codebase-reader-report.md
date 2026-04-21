# Codebase Reader Report: example-medium

## Relevant Files
- `docs/workflow/delegation.md`
- `docs/workflow/parallelism.md`
- `docs/workflow/state-and-runs.md`
- `templates/state.md`
- `templates/state.json`
- `templates/run-history.md`
- `templates/run-history.json`
- `schemas/state.schema.json`
- `schemas/run-history.schema.json`

## Technical Summary
- Delegation guidance already defines the minimum context contract and merge-back rule for stale evidence.
- Parallelism guidance requires fan-in before `VERIFY`, `REVIEW`, `REPORT`, and `FINISH`.
- State guidance tracks both `latest_evidence_refs` and `stale_evidence_refs`, which is the right surface for a stale-evidence example.
- Run history guidance already supports failures, rollback targets, and decisions, so the example only needs to model a realistic loop.

## Expected Impact
- The Orchestrator can keep the medium example narrow by reusing the current doc and schema vocabulary instead of inventing new fields.
- Execution can be split into state and run-history lanes after the delegated read with low merge risk.

## Risks
- A shared wording change across state and run-history lanes could still make verify evidence stale after fan-in.
- If the example skips the rework loop, it will underrepresent the stale-evidence rule.

## Dependencies
- Shared vocabulary from `docs/workflow/phases-and-gates.md`
- Existing schema enums for phases, statuses, and decisions

## Objective Recommendations
- Keep the delegated lane read-only and bounded to docs, templates, and schemas.
- Use one explicit rework cycle where review rejects stale verify evidence after a late fan-in edit.
- Finish with aligned `state.*` and `run-history.*` entries that point to the refreshed evidence.
