# Design: example-medium

## Summary
Use a delegated reader to bound the initial analysis, split execution into state-lane and run-history-lane tasks, then force fan-in before verify so the example can demonstrate stale evidence invalidation and recovery.

## Existing Context / Reuse
- `docs/workflow/delegation.md` defines the minimum context contract and output contract.
- `docs/workflow/parallelism.md` defines fan-out and fan-in rules.
- `docs/workflow/state-and-runs.md` defines stale evidence semantics.
- `templates/state.*` and `templates/run-history.*` define the machine-readable and human-readable artifact surfaces.

## Key Decisions
- DES-001: Use one delegated `Codebase Reader` lane before execution to keep the Orchestrator context narrow.
- DES-002: Split execution into a state lane and a run-history lane after the reader report identifies the shared vocabulary.
- DES-003: Model stale evidence explicitly by recording a review `rework` decision when verify evidence becomes outdated after fan-in edits.
- DES-004: End with fresh verify, review, and report evidence so the final state can safely sit in `FINISH`.

## Requirement Mapping
- REQ-001, REQ-002 -> `spec.md`, `eval.md`
- REQ-004 -> `tasks.md`
- REQ-005 -> `delegation.md`, `codebase-reader-report.md`
- REQ-006, REQ-007 -> `review.md`, `run-history.*`, `report.md`
- REQ-008 -> `state.md`, `state.json`
- REQ-009 -> `run-history.md`, `run-history.json`
- REQ-010 -> the full example working set and bounded delegated summary

## Risks
- The example could overcomplicate the stale-evidence loop and stop feeling realistic.
- The delegated report could drift from the actual task boundaries.

## Mitigations
- Keep the loop to one concrete `rework` cycle.
- Reuse the same file paths, IDs, and lane names across design, tasks, state, and run history.
