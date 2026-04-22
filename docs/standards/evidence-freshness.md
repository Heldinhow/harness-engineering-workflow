# Evidence Freshness

## Purpose

Ensure evidence used to prove status is current, not stale from before relevant changes.

## The Freshness Rule

Evidence is fresh when it was captured after the last change relevant to the claim it supports. Evidence captured before a relevant change is stale and cannot prove current status.

## Freshness Triggers

Evidence becomes stale when any of these happen after evidence capture:

- files in the evidence scope are modified
- requirements are updated
- design decisions change
- task boundaries change
- eval definitions are modified
- new implementation is added

## Staleness Detection Checklist

Before passing VERIFY or REVIEW:

1. **Compare timestamps**: is evidence newer than all relevant artifacts?
2. **Check for changes**: were any files modified after evidence was recorded?
3. **Review eval rerun triggers**: do any changed files match rerun triggers in `eval.md`?
4. **Validate state**: do `state.md` and `state.json` agree on current phase?

## When Evidence Is Stale

- Do not use stale evidence to justify passing a gate.
- Mark the stale evidence explicitly in `stale_evidence_refs` in state artifacts.
- Re-run the relevant verification to capture fresh evidence.
- If re-verification would take significant time, roll back to EXECUTE instead.

## Evidence That Is Always Fresh

- Command output captured in the current session after the last change
- Test results run after the last implementation change
- Inspection notes recorded after the last artifact modification

## Evidence That Is Always Stale

- "Looks good" without a timestamped output
- Evidence from a previous session that has had changes since
- Memory of what passed — not the actual output
