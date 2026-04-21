# State And Runs

The workflow keeps both human-readable and machine-readable control artifacts.

## State Artifacts

### `state.md`
Human summary for current phase, blockers, latest evidence, next step, and rollback target.

### `state.json`
Machine-readable control state. This is the authoritative source for automation-friendly fields such as:

- `feature_id`
- `complexity`
- `current_phase`
- `status`
- `pending_gate`
- `owner_role`
- `owner_id`
- `last_run_id`
- `next_step`
- `blockers`
- `latest_evidence_refs`
- `stale_evidence_refs`
- `rollback_target`
- `updated_at`

## Run History Artifacts

### `run-history.md`
Human digest of key runs, transitions, failures, loops, and next actions.

### `run-history.json`
Append-only ledger of execution history. Each run should include:

- `run_id`
- timestamps
- phase
- transition
- agent role and id
- related requirements and evals
- status
- evidence refs
- failure type
- rollback target
- decision
- notes

## Resume Order

Resume in this order:

1. `state.json`
2. `state.md`
3. latest `run-history.json` entry
4. `review.md` when present
5. only the feature artifacts referenced by the current state

## Stale Evidence Rules

- Changes after verify make verify/review/report stale.
- Changes after review make review/report stale.
- Changes to requirements or eval definitions make dependent evidence stale.

## Schemas

Use the JSON schemas in `schemas/` to keep the machine-readable forms stable enough for tooling without introducing a runtime.
