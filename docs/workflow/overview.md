# Workflow Overview

This package combines four operational layers:

- Planning
- Execution
- Quality and evidence
- Harness and orchestration

The workflow stays small by making each layer explicit instead of introducing a runtime.

## Layers

### Planning Layer
- `spec.md` is always required.
- `design.md` appears when structure or interfaces matter.
- `tasks.md` appears when sequencing, dependencies, or parallelism matter.
- Requirements use stable IDs such as `REQ-001`.

### Execution Layer
- The Orchestrator plans and delegates.
- Execution happens per task, not as a giant undifferentiated change.
- Subagents receive minimal scoped context.
- Parallelism is explicit, not accidental.

### Quality and Evidence Layer
- `eval.md` exists before meaningful behavior changes.
- `verify` is a fresh proof step, not a feeling.
- `review.md` is a formal gate.
- `report.md` consolidates the story after gates pass.

### Harness and Orchestration Layer
- `state.md` and `state.json` track the current feature state.
- `run-history.md` and `run-history.json` record transitions and loops.
- Resume happens from state and run history first.
- Rollback is explicit when a gate fails.

## Complexity Model

### Small
- Local and obvious change.
- Requires `spec.md`, `eval.md`, and state.
- `design.md` and `tasks.md` are optional.

### Medium
- Multi-file or moderately risky change.
- Requires `spec.md`, `tasks.md`, `eval.md`, and state.
- `design.md` is strongly recommended.

### Large / Complex
- Cross-cutting, integration-heavy, or high-ambiguity change.
- Requires the full artifact set.
- Requires explicit delegation, rollback rules, and review discipline.

## Orchestrator-First Model

The main agent should avoid carrying raw repo context whenever possible.

It should:

- interpret the request
- classify complexity
- choose the required phases
- decide what can run in parallel
- delegate broad reading and scoped execution
- consolidate filtered outputs
- decide progress, rollback, or escalation

It should not absorb large swaths of codebase context just because it can.
