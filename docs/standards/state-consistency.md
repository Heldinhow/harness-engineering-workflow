# State Consistency

## Purpose

Keep paired human-readable and machine-readable state artifacts aligned so resume is reliable.

## State Artifacts

- `state.md`: human summary for current phase, blockers, latest evidence, next step, and rollback target
- `state.json`: machine-readable control state — authoritative source for automation

Both must agree on: `current_phase`, `status`, `rollback_target`, `last_run_id`.

## Run History Artifacts

- `run-history.md`: human digest of key runs, transitions, failures, loops, and next actions
- `run-history.json`: append-only ledger of execution history

Both must agree on: `phase`, `transition`, `status`, `rollback_to_phase`, `decision`.

## Drift Prevention Checklist

Before updating state, verify:

- [ ] Both `state.md` and `state.json` are updated together
- [ ] All shared fields match (current_phase, status, rollback_target, last_run_id)
- [ ] `stale_evidence_refs` is cleared when evidence is refreshed
- [ ] `updated_at` timestamp is recent

## Common Drift Causes

1. **Incomplete updates**: only updating one format
2. **Field name mismatches**: "current_phase" vs "Current Phase"
3. **Missing fields**: new fields added to one format but not the other
4. **Case differences**: "blocked" vs "BLOCKED"

## Resume Order

When resuming work, read in this order:

1. `state.json`
2. `state.md`
3. latest `run-history.json` entry
4. `review.md` when present
5. only the feature artifacts referenced by the current state

Do not start from broad repo rereads unless rollback or stale memory requires it.
