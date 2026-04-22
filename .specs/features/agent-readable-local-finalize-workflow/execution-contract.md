# Execution Contract: agent-readable-local-finalize-workflow

## Run Scope
- Update the repository's canonical workflow, documentation structure, templates, schemas, skills, memory, examples, and shipped asset set to match the new local-only, agent-readable workflow contract.

## Included Requirements
- REQ-001
- REQ-002
- REQ-003
- REQ-004
- REQ-005
- REQ-006
- REQ-007
- REQ-008
- REQ-009
- REQ-010

## Included Tasks
- TASK-001
- TASK-002
- TASK-003
- TASK-004
- TASK-005

## Excluded Tasks
- Historical migration of every existing `.specs/features/*` snapshot outside the examples and this active working set.
- CI/CD, deploy, release, GitHub Actions, or PR automation additions.

## Dependencies
- Current root docs and workflow docs
- Templates and schemas
- Skills and memory docs
- Examples and installer manifest

## Parallelism
- Execution class for this run: sequential
- Rationale: the change introduces shared vocabulary and artifact semantics across docs, templates, schemas, skills, memory, examples, and installer assets, so safe fan-in depends on a stable sequence.

## Expected Codebase Surfaces
- `AGENTS.md`
- `README.md`
- `docs/**`
- `templates/**`
- `schemas/**`
- `skills/**`
- `memory/**`
- `examples/**`
- `installer/**`

## Mandatory Run Tests
- Targeted content searches confirm the canonical workflow uses `EXECUTION CONTRACT` and `FINALIZE`.
- Targeted content searches confirm the canonical workflow does not prescribe CI/CD, release, deploy, or PR automation.
- Targeted reads confirm `templates/execution-contract.md` and `templates/finalize-report.md` exist and match the docs.
- Targeted reads confirm schemas and examples align to the updated phase vocabulary.

## Done Criteria
- Root navigation, docs, templates, schemas, skills, memory, examples, and installer assets are aligned to the new workflow.
- `eval.md` remains part of the artifact model.
- The active feature working set contains fresh verification, review, and finalize artifacts.

## Rollback Routing
- Ambiguity or requirement mismatch -> SPECIFY
- Structural mismatch in documentation layout or role model -> DESIGN
- Bad decomposition or misplaced responsibilities -> TASKS
- Incomplete or inconsistent repo edits -> EXECUTE
- Weak, stale, or contradictory evidence -> VERIFY
