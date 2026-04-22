# Tasks: agent-readable-local-finalize-workflow

## Execution Mode
- Plan-driven

## Tasks

### TASK-001
Objective: Establish the new root navigation and canonical workflow language.
Maps to: REQ-001, REQ-002, REQ-003, REQ-010
Related evals: EVAL-001, EVAL-002
Owner role: Execution Agent
Execution class: sequential
Depends on: none
Required artifacts:
- `spec.md`
- `design.md`
- `eval.md`
Minimal context:
- Update the root framing docs first so the rest of the repo can align to one vocabulary.
Files/areas:
- `AGENTS.md`
- `README.md`
- `docs/workflow/overview.md`
- `docs/workflow/phases-and-gates.md`
Ready definition:
- The target phase order and documentation model are fixed.
Done definition:
- Root docs describe the new canonical workflow and point to detailed docs.
Expected evidence:
- Readback of updated root docs showing new phase order and navigation links.

### TASK-002
Objective: Build the progressive-disclosure docs structure for workflow phases, roles, and standards.
Maps to: REQ-002, REQ-004, REQ-005, REQ-006, REQ-007, REQ-010
Related evals: EVAL-001, EVAL-002
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-001
Required artifacts:
- `design.md`
- `eval.md`
Minimal context:
- Introduce the new docs tree without duplicating policy unnecessarily.
Files/areas:
- `docs/workflow/`
- `docs/roles/`
- `docs/standards/`
- `docs/ci-integration.md`
Ready definition:
- Canonical vocabulary is stable from TASK-001.
Done definition:
- New docs exist and cover the requested workflow, role, standards, rollback, evidence, and local-only completion model.
Expected evidence:
- Directory listing and targeted readback of new docs.

### TASK-003
Objective: Align templates and schemas to the new workflow contract.
Maps to: REQ-003, REQ-004, REQ-005, REQ-007, REQ-008
Related evals: EVAL-001, EVAL-003
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-002
Required artifacts:
- `execution-contract.md`
- `eval.md`
Minimal context:
- Preserve existing artifact families where possible while adding the new contract and finalize artifacts.
Files/areas:
- `templates/`
- `schemas/`
Ready definition:
- The workflow semantics and docs language are stable.
Done definition:
- Templates and schemas support the new phase set and artifact model.
Expected evidence:
- Readback of new templates and schema enums.

### TASK-004
Objective: Align skills, memory docs, examples, and installer assets to the new contract.
Maps to: REQ-003, REQ-006, REQ-008, REQ-009, REQ-010
Related evals: EVAL-001, EVAL-002, EVAL-003
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-003
Required artifacts:
- `execution-contract.md`
- `finalize-report.md`
- `state.md`
- `run-history.md`
Minimal context:
- After templates and schemas are stable, update behavior guidance and shipped examples to match.
Files/areas:
- `skills/`
- `memory/`
- `examples/`
- `installer/`
Ready definition:
- Template and schema vocabulary is stable.
Done definition:
- Skills, memory, installer manifest, and examples reflect the new workflow and local-only finish model.
Expected evidence:
- Readback of key skill/example/installer files and verification output.

### TASK-005
Objective: Verify repo-wide vocabulary, artifact coverage, and local-only guidance; then review and finalize the feature working set.
Maps to: REQ-001, REQ-003, REQ-004, REQ-005, REQ-007, REQ-010
Related evals: EVAL-001, EVAL-002, EVAL-003
Owner role: Orchestrator
Execution class: sequential
Depends on: TASK-004
Required artifacts:
- `review.md`
- `finalize-report.md`
- `state.md`
- `state.json`
- `run-history.md`
- `run-history.json`
Minimal context:
- Verify against current files only and capture fresh local evidence.
Files/areas:
- repository-wide targeted checks
- `.specs/features/agent-readable-local-finalize-workflow/`
Ready definition:
- All implementation edits are complete.
Done definition:
- Fresh verification evidence is captured, review is recorded, state artifacts are aligned, and final handoff is written.
Expected evidence:
- Command output proving new phase vocabulary and doc/template presence.
