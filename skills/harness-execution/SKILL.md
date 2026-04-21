---
name: harness-execution
description: Use when a planned feature is ready to be implemented with disciplined execution, TDD for behavior changes, fresh verification evidence, and explicit loop-back when a gate fails.
---

# Harness Execution

This skill owns the execution layer.

It preserves the best operational discipline from Superpowers while staying compact.

## Execution Rules

1. Follow the approved planning artifacts.
2. Use TDD for feature work, bugfixes, and behavior changes.
3. Prefer isolated work on Medium+ changes when practical.
4. Never claim success without fresh verification output.
5. If execution reveals missing clarity, stop and loop back instead of inventing scope.

## TDD Policy

For any behavior change:
- write the failing test first
- run it and confirm the expected failure
- implement the minimum change
- run the test and confirm it passes
- run relevant regressions

If you skipped the failing test, you do not have TDD evidence.

## Verify Discipline

Before saying something is complete, fixed, or passing:
- identify the command that proves it
- run the full command now
- inspect the actual output
- report the result with evidence

## When to Loop Back

- Test failure caused by bad code → back to Execute
- Missing acceptance clarity → back to Specify
- Structural inconsistency → back to Design
- Task decomposition no longer makes sense → back to Tasks

## Review Expectations

Before finish, confirm:
- implementation matches spec
- nothing clearly out-of-scope was added
- verification output is fresh
- known issues are either fixed or explicitly recorded

## Worktree Guidance

For Small changes, inline execution is usually enough.

For Medium+ changes, isolated work is recommended when branch safety or context separation matters.
