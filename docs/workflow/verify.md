# Verify

## Purpose

Prove the current implementation status with fresh evidence captured now.

## Entry Assumptions

- Execution produced a candidate implementation or artifact set.

## Exit Gate

- Fresh command or inspection evidence proves current status.
- Evidence was captured after the last relevant change.

## The Freshness Rule

`VERIFY` requires fresh evidence. Evidence from before recent changes is stale and cannot be used to prove current status. Before claiming something is complete, fixed, or passing:

1. Identify the command or inspection that proves it
2. Run it now
3. Inspect the actual output
4. Record the evidence reference

Do not record "looks good" or memory of what passed. Record the actual command output.

## Evidence Invalidation

- Relevant changes after `VERIFY` invalidate `VERIFY` and `REVIEW` evidence.
- Relevant changes after `REVIEW` invalidate `REVIEW` evidence.
- Requirement, eval, or design changes invalidate dependent execution claims.

When evidence is stale, mark it stale in state and roll back to the needed gate.

## What Counts as Evidence

- Command output captured at the time of verification
- Structured inspection notes pointing to specific files or artifacts
- Test results with pass/fail output
- Diff showing the change that was verified

What does NOT count:

- Memory of what passed earlier
- "Verified locally" without output
- Evidence captured before the last relevant change

## Rollback

- Stale evidence → VERIFY (re-run the verification)
- Implementation issue → EXECUTE
- Requirement or design issue → respective phase

## Verify Quality Checklist

Before passing the VERIFY gate, verify:

1. **Evidence is fresh**: timestamped after the last relevant change
2. **Evidence is direct**: actual command output, not memory or assumption
3. **No relevant changes since capture**: compare timestamps on all relevant files
4. **eval rerun triggers checked**: if eval definitions exist, confirm triggers have not fired
5. **State is aligned**: verify evidence is reflected in state artifacts
