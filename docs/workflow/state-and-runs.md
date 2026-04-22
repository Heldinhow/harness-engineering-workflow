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

## State Drift Prevention

State drift occurs when `state.md` and `state.json` disagree. This causes:
- Confusing resume context
- Inconsistent automation behavior
- Scoring failures

### Prevention Checklist

Before updating state, verify:
- [ ] Both `state.md` and `state.json` are updated together
- [ ] All shared fields match (current_phase, status, rollback_target, last_run_id)
- [ ] `stale_evidence_refs` is cleared when evidence is refreshed
- [ ] `updated_at` timestamp is recent

### Common Drift Causes

1. **Incomplete updates**: Only updating one format
2. **Field name mismatches**: "current_phase" vs "Current Phase"
3. **Missing fields**: New fields added to one format but not the other
4. **Case differences**: "blocked" vs "BLOCKED"

### Drift Detection

The scoring script (`score_workflow.sh`) checks for drift and penalizes misalignment. Run it before committing to catch drift early.

## Schemas

Use the JSON schemas in `schemas/` to keep the machine-readable forms stable enough for tooling without introducing a runtime.
