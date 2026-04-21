# Harness Engineering Workflow

An operational SDD + Harness Engineering workflow package for lightweight but disciplined planning, execution, validation, and resume.

This repository is built around one rule: the main agent is an orchestrator, not a codebase vacuum. It plans, sizes, delegates, consolidates, enforces gates, and decides progress. Broad codebase reading, parallel execution, and scoped implementation are delegated to subagents with explicit contracts.

## What This Package Provides

- A planning layer with spec-driven artifacts, adaptive depth, and requirement IDs.
- An execution layer with task-driven work, controlled delegation, and parallelism rules.
- A quality layer with evals, verify, review, report, and explicit rollback targets.
- A harness layer with human-readable state, machine-readable state, run history, and resume guidance.

## Core Workflow

```text
INTAKE
→ SPECIFY
→ DESIGN
→ TASKS
→ EVAL DEFINE
→ EXECUTE
→ VERIFY
→ REVIEW
→ REPORT
→ FINISH
```

## Operating Principles

- Spec before execute.
- Evals before meaningful behavior change.
- The main agent consolidates filtered outputs instead of reading the whole codebase.
- Broad codebase reading is delegated to scoped `Codebase Reader` subagents.
- Every task declares requirement traceability, dependencies, and execution class.
- Every relevant phase produces evidence.
- Every gate defines its rollback target.
- State and run history must support reliable resume.

## Roles

| Role | Purpose |
| --- | --- |
| Orchestrator | Classify complexity, choose phases, decide gates, delegate, fan-out, fan-in, and consolidate outputs |
| Codebase Reader | Investigate a bounded area and return filtered findings only |
| Spec Agent | Produce and refine `spec.md` |
| Design Agent | Produce and refine `design.md` when structure matters |
| Eval Agent | Produce and refine `eval.md` before meaningful implementation |
| Execution Agent | Complete scoped tasks with minimal context |
| Reviewer | Decide `pass`, `rework`, or `escalate` |

## Repository Structure

```text
README.md
AGENTS.md
docs/
  workflow/
    overview.md
    phases-and-gates.md
    agent-roles.md
    delegation.md
    parallelism.md
    codebase-reading.md
    state-and-runs.md
memory/
  project/
  codebase/
examples/
  small-feature/
  medium-feature/
schemas/
  state.schema.json
  run-history.schema.json
skills/
  harness-engineering-workflow/
  harness-planning/
  harness-execution/
  harness-evals/
  harness-review/
templates/
  spec.md
  design.md
  tasks.md
  eval.md
  state.md
  state.json
  review.md
  report.md
  run-history.md
  run-history.json
  delegation.md
  codebase-reader-report.md
```

## Skills

### `harness-engineering-workflow`
The main workflow skill. It acts as the Orchestrator and routes work across planning, execution, eval, and review.

### `harness-planning`
Creates the planning artifacts, sizes the work, and ensures requirement traceability.

### `harness-execution`
Runs implementation through task-scoped work, controlled delegation, and verification discipline.

### `harness-evals`
Defines capability and regression evals, evidence policy, and rerun triggers.

### `harness-review`
Runs the formal review gate and decides `pass`, `rework`, or `escalate`.

## Artifact Model

Each feature should have a working set under `.specs/features/<feature>/`:

```text
.specs/features/<feature>/
  spec.md
  design.md
  tasks.md
  eval.md
  delegation.md
  codebase-reader-report.md
  review.md
  state.md
  state.json
  run-history.md
  run-history.json
  report.md
```

Small features may omit `design.md`, `tasks.md`, and delegation artifacts when the work is truly local. Medium and complex features should use the full set when structure, dependencies, or parallelism matter.

## Phase Output Summary

| Phase | Primary output | Gate summary |
| --- | --- | --- |
| Intake | feature id, scope, complexity | scope is classified |
| Specify | `spec.md` | requirements are clear and testable |
| Design | `design.md` | solution structure is explicit enough |
| Tasks | `tasks.md` | execution units, deps, and parallelism are explicit |
| Eval Define | `eval.md` | proof is defined before meaningful behavior change |
| Execute | code/docs/artifacts + evidence | tasks are complete or explicitly blocked |
| Verify | fresh command or inspection evidence | current status is proven now |
| Review | `review.md` | decision is `pass`, `rework`, or `escalate` |
| Report | `report.md` | scope and evidence are consolidated |
| Finish | completion decision | all required gates are green |

## Delegation and Codebase Reading

The Orchestrator may read local context, feature artifacts, and memory docs. Once analysis goes beyond a small local scope, codebase reading must be delegated.

Use `Codebase Reader` subagents when any of these are true:

- more than one area matters
- likely more than three files matter
- impact analysis is needed
- dependencies or boundaries are unclear
- the main agent would otherwise absorb raw context

Each delegated reader returns only:

- relevant files
- technical summary
- expected impact
- risks
- dependencies
- objective recommendations

## Parallelism

Tasks must declare one execution class:

- `sequential`
- `parallelizable`
- `blocked`

The Orchestrator decides fan-out only after planning and eval definitions are stable enough. Fan-in is required before `VERIFY`, `REVIEW`, `REPORT`, and `FINISH`.

## State and Run History

- `state.md` is the human summary.
- `state.json` is the machine-readable control state.
- `run-history.md` is the human digest.
- `run-history.json` is the append-only execution ledger.

The JSON forms are backed by schemas in `schemas/`.

## Start Here

1. Use `harness-engineering-workflow`.
2. Create `spec.md`.
3. Create `design.md` and `tasks.md` when complexity requires them.
4. Create `eval.md` before meaningful implementation.
5. Delegate broad codebase reading through `Codebase Reader` subagents when needed.
6. Execute per task with explicit evidence.
7. Verify with fresh evidence.
8. Run the review gate.
9. Write the report.
10. Finalize only after all required gates pass.

## Further Reading

- `AGENTS.md`
- `docs/workflow/overview.md`
- `docs/workflow/phases-and-gates.md`
- `docs/workflow/agent-roles.md`
- `docs/workflow/delegation.md`
- `docs/workflow/parallelism.md`
- `docs/workflow/codebase-reading.md`
- `docs/workflow/state-and-runs.md`

## Why This Package Exists

This package is meant to avoid both extremes:

- coding without spec, eval, evidence, or rollback rules
- turning every change into a heavyweight process

The result should stay pragmatic, operational, and resumable.
