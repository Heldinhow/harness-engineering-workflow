# Traceability

## Purpose

Ensure every requirement has a traceable path from spec through design, tasks, execution, and evidence.

## Stable ID System

Use stable IDs throughout the workflow:

- `REQ-*` for requirements in `spec.md`
- `DES-*` for design decisions in `design.md`
- `EVAL-*` for evals in `eval.md`
- `TASK-*` for tasks in `tasks.md`

IDs must not be renumbered after creation. If a requirement is removed, its ID is retired, not reused.

## Traceability Paths

### REQ-* → Design
Every REQ-* should map to one or more design artifacts, components, or decisions in `design.md`.

### REQ-* → EVAL-*
Every REQ-* should have at least one EVAL-* that proves it or protects against regression.

### EVAL-* → Evidence
Every EVAL-* should have a defined evidence method that produces verifiable output.

### TASK-* → REQ-*
Every TASK-* should map to at least one REQ-*.

## Traceability Rules

1. **Never skip IDs**: if REQ-001 and REQ-003 exist, REQ-002 must exist or be explicitly retired.
2. **Never renumber**: once assigned, an ID is permanent for its lifetime.
3. **No orphaned requirements**: every REQ-* must appear in at least one task and one eval.
4. **No orphaned evals**: every EVAL-* must map to at least one REQ-*.

## Traceability Checklist

Before passing the SPECIFY gate:

- [ ] Every REQ-* is testable with a concrete criterion
- [ ] Every REQ-* maps to at least one acceptance criterion

Before passing the TASKS gate:

- [ ] Every TASK-* maps to at least one REQ-*
- [ ] No orphaned tasks

Before passing VERIFY:

- [ ] Every REQ-* in scope has passing EVAL-* evidence
- [ ] No orphaned EVAL-*
