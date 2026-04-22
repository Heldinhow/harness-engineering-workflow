# Project Memory Observability

## What observability means here
- Observability comes from readable state, traceable evidence, and explicit rollback routing.
- The Orchestrator should be able to answer "where am I, what is blocked, and where do I go next?" from state artifacts alone.

## State visibility
- `state.json` is the authoritative machine-readable state.
- `state.md` is the human-readable summary.
- Both must agree on current_phase, status, rollback_target, and last_run_id.

## Evidence visibility
- Evidence refs in run-history.json point to files that exist and are current.
- Stale evidence is marked in stale_evidence_refs, not hidden.
- Finalize report captures the complete evidence pack for handoff.

## Rollback visibility
- Every gate records a specific phase name for rollback, not a vague direction.
- Rollback routing table in docs/standards/rollback-rules.md maps failure class to phase.

## Local scope note
- Observability tooling is local and self-contained.
- No remote monitoring, no external dashboards, no CI pipelines.
