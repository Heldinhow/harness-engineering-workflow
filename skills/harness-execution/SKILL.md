---
name: harness-execution
description: Use when planned work is ready for task-scoped execution with minimal-context delegation, fresh verification evidence, and explicit rollback when implementation or evidence becomes invalid.
---

# Harness Execution

This skill owns `EXECUTE` and the execution-side discipline that feeds `VERIFY`.

## Execution Contract

- Execute per task, not as one undifferentiated change.
- Follow the current `spec.md`, `design.md`, `tasks.md`, and `eval.md`.
- Delegate only the local context needed for the scoped task.
- Keep delegated output filtered to the standard contract.
- Mark work as complete, `blocked`, or not started. Do not report vague progress.

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

- Relevant changes after `VERIFY` invalidate `VERIFY`, `REVIEW`, and `REPORT` evidence.
- Relevant changes after `REVIEW` invalidate `REVIEW` and `REPORT` evidence.
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

- implementation issue or failing proof: back to `EXECUTE`
- requirement ambiguity: back to `SPECIFY`
- structural inconsistency: back to `DESIGN`
- bad decomposition or dependency framing: back to `TASKS`

## Parallelism Rule

Only execute tasks in parallel when planning already marked them `parallelizable` and fan-in can happen before `VERIFY`, `REVIEW`, `REPORT`, and `FINISH`.
