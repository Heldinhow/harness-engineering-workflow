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
→ DESIGN (conditional)
→ TASKS
→ EXECUTION CONTRACT
→ EXECUTE
→ VERIFY
→ REVIEW
→ FINALIZE
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
- `eval.md` is required before meaningful behavior change.
- `design.md` is required when structure matters.
- `tasks.md` is required when work spans files, phases, dependencies, or parallel lanes.
- `execution-contract.md` is required when real implementation work begins.
- `review.md` records the formal review decision.
- `finalize-report.md` records local closeout.
- `state.md` and `state.json` must stay aligned.
- `run-history.md` and `run-history.json` must stay aligned.

## Execution Classes And Parallelism

Every task should declare one execution class:

- `sequential`
- `parallelizable`
- `blocked`

Use `parallelizable` only when ownership boundaries are clear and the work can fan in safely before `VERIFY`, `REVIEW`, and `FINALIZE`.

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

Do not treat work as complete when `VERIFY` or `REVIEW` evidence is stale.

## Rollback And Resume

- Roll back to the phase named by the failing gate or invalidated artifact.
- Relevant changes after `VERIFY` make `VERIFY` and `REVIEW` stale.
- Relevant changes after `REVIEW` make `REVIEW` stale.
- Requirement or eval changes make dependent evidence stale.

When resuming, read in this order:

1. `state.json`
2. `state.md`
3. latest `run-history.json` entry
4. `review.md` when present
5. only the feature artifacts referenced by current state

## Rollback Routing

| Failure class | Rollback target |
|---|---|
| Ambiguity or bad requirements | SPECIFY |
| Structural inconsistency | DESIGN |
| Bad decomposition or unsafe parallelism | TASKS |
| Incomplete implementation or failing tests | EXECUTE |
| Stale or missing evidence | VERIFY |


## State Consistency (CRITICAL)
Always keep `state.json` and `state.md` in sync:
- After EVERY phase transition, update BOTH files
- `current_phase` MUST match exactly in both files
- Update `last_run_id` to match run-history.json
- Update `updated_at` timestamp in ISO format
- Check both files before claiming phase complete

State drift causes benchmark penalties. Verify alignment before proceeding.


## Code Scope Alignment
In `execution-contract.md`, explicitly document:
- Files to be created/modified
- Modules or components affected
- API surfaces or interfaces
- Test files required
- Any configuration changes

Without explicit scope documentation, code_scope_alignment scores drop to 0.

## Required Sub-Skills

- **REQUIRED SUB-SKILL:** `harness-planning` for `SPECIFY`, `DESIGN`, and `TASKS`
- **REQUIRED SUB-SKILL:** `harness-evals` for `eval.md` and evidence policy
- **REQUIRED SUB-SKILL:** `harness-execution` for `EXECUTE`, `EXECUTION CONTRACT`, and `VERIFY`
- **REQUIRED SUB-SKILL:** `harness-review` for `REVIEW`

## Rework Prevention

Prevent unnecessary rework by:

1. **Verify before claiming complete**: Run verification commands, inspect actual output, record evidence
2. **Keep evidence fresh**: Evidence from before recent changes is stale - re-verify
3. **Define rollback targets**: Every gate should have a specific phase to return to on failure
4. **Check state alignment**: state.md and state.json must agree before passing gates
5. **Update run history**: Every phase transition should be recorded in run-history.json

## Resume Before Delegating

When resuming or delegating, verify:
- Current phase matches state.md and state.json
- Evidence is fresh (not invalidated by recent changes)
- Next step is documented in state artifacts

## Local Scope

The workflow ends at local finalization with tests executed and evidence recorded. CI/CD, deploy, release, and PR automation are out of scope.
