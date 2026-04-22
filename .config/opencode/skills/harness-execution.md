---
name: harness-execution
description: Use when planned work is ready for task-scoped execution with minimal-context delegation, fresh verification evidence, and explicit rollback when implementation or evidence becomes invalid.
---

# Harness Execution

This skill owns `EXECUTE`, the `EXECUTION CONTRACT` phase, and the execution-side discipline that feeds `VERIFY`.

## Execution Contract

- Execute per task, not as one undifferentiated change.
- Follow the current `spec.md`, `design.md`, `tasks.md`, `execution-contract.md`, and `eval.md`.
- Delegate only the local context needed for the scoped task.
- Keep delegated output filtered to the standard contract.
- Mark work as complete, `blocked`, or not started. Do not report vague progress.

## Execution Contract Phase

Before real implementation, create `execution-contract.md` to lock:

- exact run scope
- included and excluded tasks
- dependencies and their resolution status
- parallelism class and rationale
- expected codebase surfaces
- mandatory run tests
- done criteria
- rollback routing by failure class

## Task-Scoped Execution

Each execution unit should carry:

- the task objective
- relevant `REQ-*`
- relevant `EVAL-*` when applicable
- allowed paths
- dependencies
- ready definition
- done definition

If execution reveals missing scope, unclear requirements, or broken task boundaries, stop and roll back instead of inventing new contract.

## Verification Discipline

`VERIFY` requires fresh evidence.

Before claiming something is complete, fixed, or passing:

- identify the command or inspection that proves it
- run it now
- inspect the actual output
- record the evidence reference

## Evidence Invalidation

- Relevant changes after `VERIFY` invalidate `VERIFY` and `REVIEW` evidence.
- Relevant changes after `REVIEW` invalidate `REVIEW` evidence.
- Requirement, eval, or design changes invalidate dependent execution claims.

When evidence is stale, mark it stale in state and roll back to the needed gate.

## Stale Evidence Detection Checklist

Before passing work to `VERIFY` or `REVIEW`, run this checklist:

1. **Compare timestamps**: Is evidence newer than all relevant artifacts?
2. **Check for changes**: Were any files modified after evidence was recorded?
3. **Review eval triggers**: Do any changed files match rerun triggers in `eval.md`?
4. **Validate state**: Do `state.md` and `state.json` agree on current phase?

If any check fails, the evidence is stale. Do not pass work without fresh evidence.

## Common Rework Traps

1. **Early commit**: Recording evidence before verification commands run
2. **Skip verify**: Claiming completion without running verification
3. **Vague evidence**: Recording "looks good" instead of command output
4. **Missing rollback**: Gates passed without defining rollback target

## Rollback Rules

| Failure class | Rollback target |
|---|---|
| Ambiguity or requirement mismatch | SPECIFY |
| Structural inconsistency | DESIGN |
| Bad decomposition | TASKS |
| Implementation issue or failing proof | EXECUTE |
| Stale or missing evidence | VERIFY |

## Parallelism Rule

Only execute tasks in parallel when planning already marked them `parallelizable` and fan-in can happen before `VERIFY`, `REVIEW`, and `FINALIZE`.

## Local Scope

Testing and verification are local. CI/CD, deploy, release, and PR automation are out of scope.
