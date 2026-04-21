---
name: harness-planning
description: Use when the workflow needs minimal but explicit planning artifacts for a feature, including spec, optional design, optional task breakdown, and persistent feature state.
---

# Harness Planning

This skill owns the planning layer.

It keeps the workflow lightweight while preserving the best TLC patterns:
- explicit feature artifacts
- requirement IDs
- adaptive depth by complexity
- session continuity through a feature state file

## Outputs

Create or update these files under `.specs/features/<feature>/`:
- `spec.md`
- `design.md` when structure or integration matters
- `tasks.md` when the work benefits from decomposition
- `state.md`

## Planning Rules

### Spec
Always create a minimal spec before implementation.

The spec must include:
- objective
- in-scope vs out-of-scope
- requirement IDs (`REQ-001`, `REQ-002`, ...)
- acceptance criteria in clear behavioral terms

### Design
Create `design.md` when any of these are true:
- the change spans multiple components
- an interface, integration, or data flow matters
- there are meaningful trade-offs
- review would otherwise rely on guesswork

Skip `design.md` for clearly local Small changes.

### Tasks
Create `tasks.md` when any of these are true:
- the work spans multiple steps or files
- sequencing matters
- parallel or staged execution matters
- progress would otherwise be hard to track

Skip `tasks.md` when a Small change fits one short TDD cycle.

## State Tracking

Maintain `.specs/features/<feature>/state.md` with:
- current phase
- status
- complexity
- open issues
- latest evidence
- next step
- loop rule

## Lightweight Planning Standard

Do not over-design.

Default to the smallest planning surface that still makes execution, review, and evals unambiguous.

## Requirement IDs

Use simple IDs:
- `REQ-001`
- `REQ-002`
- `REQ-003`

Keep tasks and evals traceable back to those IDs.
