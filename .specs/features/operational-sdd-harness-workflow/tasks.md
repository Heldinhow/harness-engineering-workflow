# Tasks: operational-sdd-harness-workflow

## Execution Mode
- Plan-driven

## Tasks

### TASK-001
Objective: Rewrite the repository framing and workflow docs around the Orchestrator-first contract.
Maps to: REQ-001, REQ-003, REQ-006, REQ-010
Related evals: EVAL-001, EVAL-002
Owner role: Orchestrator
Execution class: sequential
Depends on: none
Required artifacts:
- `.specs/features/operational-sdd-harness-workflow/spec.md`
- `.specs/features/operational-sdd-harness-workflow/design.md`
- `.specs/features/operational-sdd-harness-workflow/eval.md`
Files/areas:
- `README.md`
- `AGENTS.md`
- `docs/workflow/`
Ready definition:
- Approved feature spec and design exist.
Done definition:
- Root and workflow docs describe the operational contract, gates, delegation, codebase reading, and resume behavior using aligned vocabulary.
Expected evidence:
- Repo docs show the new structure and phase/gate model.

### TASK-002
Objective: Align the skill, template, and schema layers to the new workflow vocabulary and gate model.
Maps to: REQ-001, REQ-002, REQ-003, REQ-004, REQ-005, REQ-006, REQ-007, REQ-008, REQ-009
Related evals: EVAL-001, EVAL-003
Owner role: Execution Agent
Execution class: parallelizable
Depends on: TASK-001
Required artifacts:
- `docs/workflow/overview.md`
- `docs/workflow/phases-and-gates.md`
- `docs/workflow/delegation.md`
- `docs/workflow/codebase-reading.md`
Files/areas:
- `skills/`
- `templates/`
- `schemas/`
Ready definition:
- Workflow vocabulary and gate model are stable from TASK-001.
Done definition:
- Skills, templates, and schemas share the same role model, state model, review gate, and rollback language.
Expected evidence:
- Added/updated skills and artifacts cover review, state, run history, delegation, and codebase-reader outputs.

### TASK-003
Objective: Add reusable memory docs and worked examples that reduce broad rereads and show the workflow in practice.
Maps to: REQ-010
Related evals: EVAL-001, EVAL-004
Owner role: Codebase Reader
Execution class: parallelizable
Depends on: TASK-001
Required artifacts:
- `templates/`
- `schemas/`
- `docs/workflow/state-and-runs.md`
Files/areas:
- `memory/`
- `examples/`
Ready definition:
- Workflow contract is stable enough to be documented by example.
Done definition:
- Memory docs and example feature trees reflect the final vocabulary and artifact contracts.
Expected evidence:
- Added memory docs and small/medium examples with state and run history artifacts.

### TASK-004
Objective: Verify the full repository change, resolve review findings, and close out the feature with fresh evidence.
Maps to: REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
Owner role: Reviewer
Execution class: sequential
Depends on: TASK-002, TASK-003
Required artifacts:
- `.specs/features/operational-sdd-harness-workflow/state.md`
- `.specs/features/operational-sdd-harness-workflow/state.json`
- `.specs/features/operational-sdd-harness-workflow/run-history.md`
- `.specs/features/operational-sdd-harness-workflow/run-history.json`
Files/areas:
- `.specs/features/operational-sdd-harness-workflow/`
- repository-wide consistency sweep
Ready definition:
- Docs, skills, templates, schemas, memory, and examples are all present.
Done definition:
- Final feature state, run history, review, and report reflect the implemented repository state.
Expected evidence:
- Verification output, review notes, and report are fresh.
