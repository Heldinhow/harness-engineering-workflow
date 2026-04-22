# Finalize

## Purpose

Close the feature locally with implementation complete, tests executed, evidence organized, artifacts synchronized, state consistent, residual debt recorded, and handoff legible.

## Entry Assumptions

- `review.md` has a `pass` decision.
- All upstream gates are green.
- Evidence pack is organized and current.

## Exit Gate

- `finalize-report.md` exists and captures the complete local closeout.
- The feature is considered closed for this session.

## What to Produce

`finalize-report.md` should define:

- **Summary**: feature, outcome, completion timestamp
- **Scope Delivered**: what was implemented and verified
- **Verification**: evidence refs, notes, and freshness check
- **Review**: decision and findings from review
- **Evals**: capability and regression eval results and thresholds
- **Evidence Freshness Check**: confirmation that all evidence refs are current
- **Residual Risks**: risks that remain after finalization
- **Pendings**: known debt, follow-ups, or deferred items
- **Handoff Notes**: what the next session, agent, or human needs to know
- **Final Decision**: pass confirmation that the feature is closed locally

## What FINALIZE Is Not

- FINALIZE is not CI/CD, deploy, release, or PR automation.
- FINALIZE is not a handoff to another system. It is a local closeout with organized evidence and legible state.
- FINALIZE is not a substitute for a passing REVIEW. If REVIEW failed, finalize cannot close the feature.

## State Transition

When FINALIZE passes:

- Set `current_phase` to `FINALIZE`
- Set `status` to `done`
- Record the final run in `run-history.md` and `run-history.json`
- Ensure `state.md` and `state.json` agree on all fields

## Rollback

- If finalize finds issues → REVIEW or VERIFY depending on issue type
- If evidence is stale → VERIFY
- If review decision was wrong → REVIEW

## Finalize Quality Checklist

Before issuing the finalize decision, verify:

1. **Implementation is complete**: all tasks done or explicitly deferred
2. **Tests executed**: local tests ran and passed or are documented with rationale
3. **Evidence organized**: all evidence refs point to existing files
4. **Artifacts synchronized**: state.md and state.json agree
5. **State consistent**: current_phase and status are aligned
6. **Residual debt recorded**: pending items are noted, not hidden
7. **Handoff legible**: next session can resume from finalize-report.md
