# Spec: operational-sdd-harness-workflow

## Objective
Strengthen this repository into an operational SDD + Harness Engineering workflow package that is lightweight, phase-driven, restartable, and explicit about delegation, evidence, and rework.

## Context
The repository already provides a compact workflow with planning, execution, eval, state, and report artifacts. The next iteration must make those layers operational: the main agent becomes an orchestrator, codebase reading is delegated to scoped subagents, parallelism becomes explicit, and state/run history become reliable enough for resume and rollback.

## Scope
### In
- Rewrite the repository framing around Orchestrator-first execution.
- Add explicit documentation for phases, gates, delegation, parallelism, codebase reading, and state/runs.
- Revise workflow skills to reflect the new operational model.
- Expand templates to cover review, delegation, codebase-reader output, state, and run history.
- Add minimal JSON schemas for machine-readable state and run history.
- Add project memory, codebase memory, and worked examples.

### Out
- A runtime CLI or automation daemon.
- Full executable enforcement of schemas or gates.
- External integrations beyond the repository artifacts and documentation.

## Requirements

### REQ-001
- WHEN a new feature enters the workflow THEN the package SHALL require a spec before execution begins.

### REQ-002
- WHEN a feature changes behavior THEN the package SHALL require eval definitions before meaningful implementation.

### REQ-003
- WHEN the main agent handles medium-or-larger analysis THEN the package SHALL define it as an orchestrator that delegates broad codebase reading to scoped subagents.

### REQ-004
- WHEN tasks are decomposed THEN the package SHALL require each task to declare requirement traceability, dependencies, and execution class (`sequential`, `parallelizable`, or `blocked`).

### REQ-005
- WHEN a subagent is delegated work THEN the package SHALL define a minimal context contract and a structured output contract.

### REQ-006
- WHEN a phase completes THEN the package SHALL define the gate, required evidence, and rollback target if the gate fails.

### REQ-007
- WHEN review runs THEN the package SHALL produce a formal decision of `pass`, `rework`, or `escalate`.

### REQ-008
- WHEN state is recorded THEN the package SHALL provide both human-readable and machine-readable state for resume and progression.

### REQ-009
- WHEN execution history is recorded THEN the package SHALL provide a minimal run history with run ids, transitions, evidence, failures, loops, and final decisions.

### REQ-010
- WHEN contributors onboard or resume work THEN the package SHALL provide project memory, codebase memory, and worked examples that reduce broad rereading of the repository.

## Acceptance Criteria
- The root documentation describes the workflow as Orchestrator-first rather than general skill-only execution.
- Skills, templates, and docs use the same phase names, decision names, and rollback vocabulary.
- Review is a dedicated artifact and gate.
- State and run history exist in both Markdown and JSON forms.
- JSON schemas exist for the machine-readable forms.
- The repository contains at least one small example and one medium example of the workflow.

## Constraints
- Keep the workflow lightweight and documentation-driven.
- Avoid introducing a heavy runtime or command-line framework.
- Prefer stable filenames and minimal conceptual overhead.

## Dependencies
- Existing skill package structure under `skills/`.
- Existing template structure under `templates/`.
- The repository README as the primary framing document to be rewritten.

## Notes
- This change intentionally dogfoods the workflow by keeping feature artifacts under `.specs/features/operational-sdd-harness-workflow/`.
