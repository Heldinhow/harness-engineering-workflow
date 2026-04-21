---
name: harness-planning
description: Use when the Orchestrator needs to size work, choose planning artifact depth, maintain requirement traceability, and decide whether codebase reading can stay local or must be delegated.
---

# Harness Planning

This skill owns `SPECIFY`, `DESIGN`, and `TASKS`.

## Planning Contract

- Keep planning as small as possible, but explicit enough for `EXECUTE`, `VERIFY`, `REVIEW`, and resume.
- Use stable requirement IDs such as `REQ-001`.
- Keep tasks and evals traceable back to the relevant `REQ-*`.
- Keep `state.md` and `state.json` aligned when planning changes the current phase, scope, blockers, or next step.

## Artifact Depth By Complexity

### Small
- Require `spec.md`.
- `design.md` is optional for clearly local work.
- `tasks.md` is optional when one short execution loop is enough.

### Medium
- Require `spec.md`, `tasks.md`, and state updates.
- Strongly recommend `design.md` when interfaces, data flow, or trade-offs matter.

### Large / Complex
- Require `spec.md`, `design.md`, `tasks.md`, delegation planning, and explicit rollback targets.

## `spec.md`

`spec.md` should define:

- objective
- in-scope and out-of-scope
- `REQ-*`
- acceptance criteria in testable terms

Do not allow `EXECUTE` to start while requirements remain vague or contradictory.

## `design.md`

Create `design.md` when:

- more than one component or interface matters
- structure or integration decisions affect execution or review
- design trade-offs need to be recorded
- review would otherwise rely on guesswork

Skip it only for clearly local work where structure is already obvious.

## `tasks.md`

Create `tasks.md` when work spans multiple files, phases, dependencies, or parallel lanes.

Each task should include:

- scope
- related `REQ-*`
- dependencies
- execution class: `sequential`, `parallelizable`, or `blocked`

## Codebase Reading Rule

The Orchestrator may read a small local scope directly. Delegate codebase reading when more than one area matters, more than three files likely matter, boundaries are unclear, impact analysis is needed, or broad reading would pollute main-agent context.

Use the standard delegation contract and keep the returned output filtered.

## Planning Rollback

- Requirement ambiguity or contradiction rolls back to `SPECIFY`.
- Structural uncertainty rolls back to `DESIGN`.
- Bad decomposition or unsafe task boundaries roll back to `TASKS`.
