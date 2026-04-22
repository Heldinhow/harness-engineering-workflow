# AGENTS.md

This repository defines an operational workflow package for local agent-assisted development. Changes here model the same behavior the package recommends.

## Quick Map

```
INTAKE → SPECIFY → DESIGN → TASKS → EXECUTION CONTRACT → EXECUTE → VERIFY → REVIEW → FINALIZE
```

See [docs/workflow/overview.md](docs/workflow/overview.md) for the full phase guide.

## Core Principles

- Main agent is the **Orchestrator**: plans, classifies, sizes, delegates, consolidates, and enforces gates.
- Keep the Orchestrator's context narrow. Delegate broad reading to scoped subagents.
- Prefer explicit gates over implied completion. Keep artifacts lightweight but operational.
- Evidence must be fresh. Rollback must name a specific phase, not "earlier".
- State and run history must stay aligned. Resume from them first.

## Phase Summary

| Phase | Purpose | Primary artifact |
|---|---|---|
| INTAKE | Classify scope and complexity | feature id, complexity |
| SPECIFY | Define clear, testable requirements | `spec.md` |
| DESIGN | Define structure when it matters | `design.md` (conditional) |
| TASKS | Break work into verifiable units | `tasks.md` |
| EXECUTION CONTRACT | Lock exact run scope before implementation | `execution-contract.md` |
| EXECUTE | Implement per task with minimal context | code + evidence |
| VERIFY | Prove current status with fresh evidence | command output |
| REVIEW | Judge readiness against contract and evidence | `review.md` |
| FINALIZE | Close locally: tests done, artifacts synced, handoff clear | `finalize-report.md` |

## Artifact Expectations

Feature working set under `.specs/features/<feature>/`:

```
spec.md              # always
eval.md              # before meaningful implementation
design.md            # when structure matters
tasks.md             # when work spans files/phases/dependencies
execution-contract.md  # when real implementation work exists
review.md            # formal review gate
finalize-report.md   # local closeout (replaces REPORT+FINISH split)
state.md + state.json
run-history.md + run-history.json
```

## Subagent Firewall Rules

Delegate to subagents when any of these are true:

- more than one subsystem matters
- more than three files likely matter
- module boundaries or dependencies are unclear
- impact analysis is needed
- broad rereading would pollute the main context

Delegated task input: objective, relevant REQ-*, relevant EVAL-*, allowed paths, required artifacts, ready definition, done definition, dependencies.

Delegated output: relevant files, technical summary, expected impact, risks, dependencies, objective recommendations.

## Rollback Routing

| Failure class | Rollback target |
|---|---|
| Ambiguity or bad requirements | SPECIFY |
| Structural inconsistency or bad design | DESIGN |
| Bad task decomposition or unsafe parallelism | TASKS |
| Incomplete implementation or failing tests | EXECUTE |
| Stale or missing evidence | VERIFY |

## Vocabulary

Use only these phase names: `INTAKE`, `SPECIFY`, `DESIGN`, `TASKS`, `EXECUTION CONTRACT`, `EXECUTE`, `VERIFY`, `REVIEW`, `FINALIZE`.

Review decisions: `pass`, `rework`, `escalate`.

Execution classes: `sequential`, `parallelizable`, `blocked`.

## State and Resume

Resume in this order: `state.json` → `state.md` → latest `run-history.json` entry → `review.md` when present → only the feature artifacts referenced by current state.

## Detailed Docs

| Area | Location |
|---|---|
| Phase lifecycle and gates | `docs/workflow/phases-and-gates.md` |
| Per-phase guidance | `docs/workflow/intake.md` through `docs/workflow/finalize.md` |
| Role responsibilities | `docs/roles/orchestrator.md` through `docs/roles/eval-agent.md` |
| Operational standards | `docs/standards/rollback-rules.md` through `docs/standards/evidence-pack.md` |
| Templates | `templates/` |
| Skills | `skills/` |
| Schemas | `schemas/` |

## What This Does Not Include

CI pipelines, GitHub Actions, deploy automation, release automation, or PR checks. The workflow ends at local finalization with tests executed and evidence recorded.
