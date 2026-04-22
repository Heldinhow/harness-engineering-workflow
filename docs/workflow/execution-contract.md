# Execution Contract

## Purpose

Lock the exact run scope before real implementation begins. This is the handoff artifact between planning and execution.

## Entry Assumptions

- `spec.md`, `design.md` (if applicable), and `tasks.md` are stable.
- The Orchestrator has decided what to implement and how to organize the run.

## Exit Gate

- `execution-contract.md` exists with the full run contract.
- Run scope, included/excluded tasks, dependencies, parallelism, expected surfaces, mandatory tests, done criteria, and rollback routing are all explicit.

## Why This Phase Exists

`tasks.md` breaks work into units. `execution-contract.md` locks what the actual run will do, excludes from this run, and defines how to route failures. It prevents scope drift during execution and gives the Orchestrator a single document to check against before and during execution.

## What to Produce

`execution-contract.md` should define:

- **Run Scope**: what this run will accomplish
- **Included Requirements**: which REQ-* are in scope for this run
- **Excluded Requirements**: which REQ-* are explicitly out of scope
- **Included Tasks**: which tasks are in this run
- **Excluded Tasks**: which tasks are explicitly deferred
- **Dependencies**: what must be true before the run starts
- **Parallelism**: execution class for this run and rationale
- **Expected Codebase Surfaces**: what files and areas this run touches
- **Mandatory Run Tests**: what tests or checks must pass during this run
- **Done Criteria**: what makes this run complete
- **Rollback Routing**: specific phase to return to for each failure class

## Relationship to tasks.md

`tasks.md` defines all possible tasks. `execution-contract.md` selects which of those tasks are in this run and which are deferred. A deferred task may still be in `tasks.md` — the contract just makes the exclusion explicit.

## Rollback

- Scope mismatch discovered during execution → TASKS
- Structural or dependency issues → TASKS
- Implementation issues → EXECUTE
- Evidence or verification issues → VERIFY

## Contract Quality Checklist

Before passing the EXECUTION CONTRACT gate, verify:

1. **Scope is exact**: included and excluded tasks are both named
2. **Dependencies are resolved**: nothing in scope is blocked by unresolved deps
3. **Parallelism is safe**: fan-out and fan-in are planned
4. **Mandatory tests are defined**: what must pass before the run is considered done
5. **Rollback routing is specific**: each failure class maps to a named phase
