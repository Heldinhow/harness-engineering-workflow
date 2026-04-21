# Eval Definition: operational-sdd-harness-workflow

## Evals

### EVAL-001
- Type: capability
- Maps to: REQ-001, REQ-003, REQ-004, REQ-005, REQ-006, REQ-010
- Description: The repository documents and demonstrates an Orchestrator-first workflow with explicit phases, gates, delegation rules, and codebase-reading isolation.
- Evidence method: Inspect the root docs, workflow docs, memory layer, and worked examples.
- Rerun triggers:
  - any edit to `README.md`
  - any edit to `AGENTS.md`
  - any edit to `docs/workflow/*.md`
  - any edit to `memory/` or `examples/`
- Thresholds:
  - the repo contains the required docs, memory files, and small/medium examples

### EVAL-002
- Type: capability
- Maps to: REQ-006, REQ-007, REQ-008, REQ-009
- Description: The repository provides a formal review gate plus resumable state and run history artifacts in both Markdown and JSON forms.
- Evidence method: Inspect `skills/harness-review/`, the review template, the state/run-history templates, schemas, and worked examples.
- Rerun triggers:
  - any edit to `skills/harness-review/`
  - any edit to `templates/review.md`, `templates/state.*`, or `templates/run-history.*`
  - any edit to `schemas/*.json`
- Thresholds:
  - review decisions stay limited to `pass`, `rework`, and `escalate`
  - state and run history exist in paired Markdown and JSON forms

### EVAL-003
- Type: regression
- Maps to: REQ-002, REQ-006
- Description: The repository remains a lightweight package rather than drifting into a runtime-heavy system.
- Evidence method: Inspect the repository structure and root framing for docs-first, artifact-first guidance.
- Rerun triggers:
  - any new runtime scaffolding or automation framework added to the repo root
  - any rewrite of the root README positioning
- Thresholds:
  - the repository still centers docs, skills, templates, schemas, memory, and examples rather than a runtime toolchain

### EVAL-004
- Type: regression
- Maps to: REQ-001, REQ-002, REQ-010
- Description: The original planning, execution, and eval layering remains understandable while being strengthened operationally.
- Evidence method: Inspect `README.md`, `docs/workflow/overview.md`, the four core skills, and the worked examples.
- Rerun triggers:
  - any edit to the layer descriptions in the README or overview docs
  - any rename or removal of the core skills
- Thresholds:
  - planning, execution, quality/evidence, and harness/orchestration are all still identifiable as separate layers

## Notes
- These evals are documentation and artifact-structure oriented; deterministic verification is based on file presence, content alignment, and schema-constrained JSON shapes rather than compiled code.
