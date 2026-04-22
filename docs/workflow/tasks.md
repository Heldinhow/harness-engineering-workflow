# Tasks

## Purpose

Break the approved work into verifiable execution units with explicit dependencies and execution class.

## Entry Assumptions

- `spec.md` exists and decomposition is needed.

## Exit Gate

- `tasks.md` exists with scoped, traceable tasks.
- Each task declares execution class and dependencies.

## What to Produce

`tasks.md` should define for each task:

- **Objective**: what this task accomplishes
- **Maps to**: which REQ-* this task satisfies
- **Related evals**: which EVAL-* this task affects
- **Owner role**: which role completes this task
- **Execution class**: `sequential`, `parallelizable`, or `blocked`
- **Depends on**: explicit dependencies
- **Required artifacts**: what must exist before this task starts
- **Minimal context**: only the local context needed to execute
- **Files/areas**: what paths this task touches
- **Ready definition**: what must be true before starting
- **Done definition**: what makes this task complete
- **Expected evidence**: what proves the task is done

## Execution Classes

- **sequential**: depends on another task, mutates shared state, or touches the same core artifact lane
- **parallelizable**: can proceed independently and safely merge back later
- **blocked**: cannot proceed until a dependency, gate, or human decision is resolved

## Rollback

- Bad decomposition or unsafe task boundaries → TASKS
- Missing dependencies or wrong execution class → TASKS
- Structural inconsistency discovered during decomposition → DESIGN

## Task Quality Checklist

Before passing the TASKS gate, verify:

1. **Each task maps to REQ-***: no orphaned tasks
2. **Dependencies are explicit**: every dependency is named
3. **Execution class is correct**: parallelizable tasks have clear ownership boundaries
4. **Ready and done definitions are concrete**: not vague or circular
5. **Fan-in can happen before VERIFY**: parallel tasks can safely merge before the verify gate
