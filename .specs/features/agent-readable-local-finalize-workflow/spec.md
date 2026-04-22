# Spec: agent-readable-local-finalize-workflow

## Objective
Update this repository so the workflow package becomes more agent-readable, more modular, and more reliable for local agent-assisted development through tested completion and local finalization.

## Context
The current repository already uses an Orchestrator-first harness workflow, but the contract is split across a large `AGENTS.md`, workflow docs, templates, and skills that still model `EVAL DEFINE`, `REPORT`, and `FINISH` as first-class phases. The requested target is a shorter index-style `AGENTS.md`, progressive disclosure through docs, a formal `EXECUTION CONTRACT`, a formal `FINALIZE` step, stronger subagent boundaries, and an explicit local-only finish model without CI/CD, deploy, release, or PR automation.

## Scope
### In
- Update the canonical workflow to `INTAKE -> SPECIFY -> DESIGN (conditional) -> TASKS -> EXECUTION CONTRACT -> EXECUTE -> VERIFY -> REVIEW -> FINALIZE`.
- Keep `eval.md` as an artifact, but remove `EVAL DEFINE` as a first-class phase.
- Rework `AGENTS.md` into a short index that points to detailed docs under `docs/`.
- Reorganize detailed documentation into `docs/workflow/`, `docs/roles/`, and `docs/standards/`.
- Add `templates/execution-contract.md` and `templates/finalize-report.md`.
- Update existing templates, skills, schemas, memory docs, examples, and installation assets to reflect the new workflow.
- Keep the workflow local-only through implementation, tests, evidence, review, and finalization.

### Out
- CI pipelines, GitHub Actions, release automation, deploy automation, remote checks, or PR automation.
- Rewriting the entire repository from scratch.
- Introducing a runtime-heavy framework instead of lightweight workflow artifacts.

## Requirements

### REQ-001
- WHEN an agent opens this repository THEN `AGENTS.md` SHALL act as a short workflow index with navigation pointers instead of an encyclopedic rules dump.

### REQ-002
- WHEN an agent needs detailed guidance THEN the repository SHALL provide progressive disclosure through dedicated docs under `docs/workflow/`, `docs/roles/`, and `docs/standards/`.

### REQ-003
- WHEN the workflow is described in docs, skills, templates, memory, examples, or schemas THEN the canonical phase order SHALL be `INTAKE`, `SPECIFY`, `DESIGN`, `TASKS`, `EXECUTION CONTRACT`, `EXECUTE`, `VERIFY`, `REVIEW`, `FINALIZE`.

### REQ-004
- WHEN a change requires real implementation work THEN the workflow SHALL require an `EXECUTION CONTRACT` artifact that records exact run scope, included requirements, included and excluded tasks, dependencies, parallelism, expected codebase surfaces, mandatory tests, done criteria, and rollback routing.

### REQ-005
- WHEN the workflow reaches local closure THEN `FINALIZE` SHALL require completed implementation, local tests or run-specific checks, organized evidence, synchronized artifacts, consistent state, recorded residual debt, and a readable handoff for the next session, agent, or human.

### REQ-006
- WHEN the Orchestrator needs context broader than a local scope THEN the workflow SHALL treat subagents as a context firewall and SHALL require bounded delegated handoffs and filtered outputs.

### REQ-007
- WHEN rollback is required THEN documentation, templates, and skills SHALL route to a specific named phase based on failure class instead of using vague instructions such as "go back" or "previous stage".

### REQ-008
- WHEN `eval.md` is needed THEN the repository SHALL preserve it as a workflow artifact tied to specification, execution contracts, verification, and finalization rather than removing it.

### REQ-009
- WHEN the repository is installed outside this checkout THEN the installed package SHALL still include the docs needed for an index-style `AGENTS.md` to remain navigable.

### REQ-010
- WHEN the workflow discusses completion and quality checks THEN it SHALL stay local-only and SHALL NOT instruct CI/CD, deploy, release, or PR automation as part of the core path.

## Acceptance Criteria
- `AGENTS.md` is short, navigable, and points to detailed docs.
- `docs/workflow/`, `docs/roles/`, and `docs/standards/` exist with phase, role, and operational rule coverage.
- `templates/execution-contract.md` and `templates/finalize-report.md` exist and align with the new workflow.
- Updated templates, skills, schemas, memory docs, examples, and installer assets use the new phase vocabulary and local-only finish model.
- Core docs no longer present CI/CD, release, deploy, or PR automation as part of the workflow contract.

## Constraints
- Preserve current philosophy where it is already sound.
- Prefer minimal edits over wholesale rewrites.
- Keep artifacts lightweight but operational.
- Keep repo navigation and terminology stable enough for existing adopters to follow the transition.

## Dependencies
- Existing workflow docs, templates, schemas, examples, installer manifest, and memory docs.

## Notes
- This feature intentionally uses the target workflow it is introducing.
