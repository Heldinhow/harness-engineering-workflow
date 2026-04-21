# Project Memory Observability

## Where workflow visibility comes from
- `state.md` and `state.json` show current position, blockers, owner, evidence, and rollback target.
- `run-history.md` and `run-history.json` record transitions, loops, failures, and decisions over time.
- `review.md` records the formal quality decision.
- `report.md` consolidates delivered scope and evidence after gates pass.

## Observability model
- This repo uses artifact-based observability, not runtime telemetry.
- The important question is: can a future agent resume safely from artifacts without rereading everything?

## Resume-first signals
- Read order is consistent across docs:
  1. `state.json`
  2. `state.md`
  3. latest `run-history.json` entry
  4. `review.md` when present
  5. only the referenced feature artifacts

## Staleness rules to remember
- Relevant changes after `VERIFY` stale `VERIFY`, `REVIEW`, and `REPORT` evidence.
- Relevant changes after `REVIEW` stale `REVIEW` and `REPORT` evidence.
- Requirement, eval, or design changes can stale dependent evidence.

## Why memory matters
- `memory/project/*` captures stable repository intent.
- `memory/codebase/*` captures layout, conventions, and hot spots.
- Together they reduce the need for broad discovery before resume or delegation.
