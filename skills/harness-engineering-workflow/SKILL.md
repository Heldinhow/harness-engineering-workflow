---
name: harness-engineering-workflow
description: Use when work in this repository or an adopting repository needs the full Orchestrator-first harness workflow, including phase selection, delegation, fan-out and fan-in control, and stateful resume.
---

# Harness Engineering Workflow

Use this as the main workflow skill. The main agent is the `Orchestrator`: it classifies work, chooses phases, delegates broad reading and scoped execution, consolidates filtered outputs, and decides whether to continue, roll back, rework, or escalate.

## Phase Order

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

## Orchestrator Contract

- Keep the main agent context narrow.
- Read directly only the request, root framing docs, feature artifacts, memory docs, or one clearly local file or diff.
- Delegate codebase reading when more than one area matters, more than three files likely matter, dependencies are unclear, impact analysis is needed, or broad rereading would pollute context.
- Delegate with only: objective, relevant `REQ-*`, relevant `EVAL-*` when applicable, allowed paths or areas, required artifacts, ready definition, done definition, dependencies.
- Accept delegated results only as: relevant files, technical summary, expected impact, risks, dependencies, objective recommendations.

## Artifact Expectations

Keep the feature working set under `.specs/features/<feature>/`.

- `spec.md` is always required before execution.
- `design.md` is required when structure matters.
- `tasks.md` is required when work spans files, phases, dependencies, or parallel lanes.
- `eval.md` is required before meaningful behavior change.
- `review.md` records the formal review decision.
- `state.md` and `state.json` must stay aligned.
- `run-history.md` and `run-history.json` must stay aligned.

## Execution Classes And Parallelism

Every task should declare one execution class:

- `sequential`
- `parallelizable`
- `blocked`

Use `parallelizable` only when ownership boundaries are clear and the work can fan in safely before `VERIFY`, `REVIEW`, `REPORT`, and `FINISH`.

## Gate Rules

Every relevant phase must define:

- entry assumptions
- exit conditions
- evidence
- rollback target on failure

Use only these review decisions:

- `pass`
- `rework`
- `escalate`

Do not treat work as complete when `VERIFY`, `REVIEW`, or `REPORT` evidence is stale.

## Rollback And Resume

- Roll back to the phase named by the failing gate or invalidated artifact.
- Relevant changes after `VERIFY` make `VERIFY`, `REVIEW`, and `REPORT` stale.
- Relevant changes after `REVIEW` make `REVIEW` and `REPORT` stale.
- Requirement or eval changes make dependent evidence stale.

When resuming, read in this order:

1. `state.json`
2. `state.md`
3. latest `run-history.json` entry
4. `review.md` when present
5. only the feature artifacts referenced by current state

## Required Sub-Skills

- **REQUIRED SUB-SKILL:** `harness-planning` for `SPECIFY`, `DESIGN`, and `TASKS`
- **REQUIRED SUB-SKILL:** `harness-evals` for `EVAL DEFINE`
- **REQUIRED SUB-SKILL:** `harness-execution` for `EXECUTE` and `VERIFY`
- **REQUIRED SUB-SKILL:** `harness-review` for `REVIEW`
