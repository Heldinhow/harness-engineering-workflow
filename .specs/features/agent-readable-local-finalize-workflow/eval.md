# Eval Definition: agent-readable-local-finalize-workflow

## Evals

### EVAL-001
- Type: capability
- Maps to: REQ-001, REQ-002, REQ-004, REQ-005, REQ-006
- Description: The repository exposes the new workflow through a short `AGENTS.md`, progressive-disclosure docs, an execution contract artifact, a finalize artifact, and explicit subagent-boundary guidance.
- Evidence method: Inspect `AGENTS.md`, `README.md`, the new docs tree, and the new template files.
- Rerun triggers:
  - Any edit to `AGENTS.md`, `README.md`, `docs/**`, or `templates/**`
  - Any change to workflow phase vocabulary after evidence capture
- Thresholds:
  - `AGENTS.md` is short and points into `docs/`
  - `docs/workflow/execution-contract.md` exists
  - `docs/workflow/finalize.md` exists
  - `docs/roles/codebase-reader.md` and `docs/standards/subagent-boundaries.md` exist
  - `templates/execution-contract.md` and `templates/finalize-report.md` exist
- Rollback on failure: EXECUTE

### EVAL-002
- Type: regression
- Maps to: REQ-003, REQ-007, REQ-010
- Description: Repository guidance remains internally consistent around the new phase order, rollback routing, and local-only scope, without retaining the old workflow as the canonical path.
- Evidence method: Run targeted content searches over docs, skills, templates, memory, and examples for old and new phase vocabulary and for excluded CI/CD topics.
- Rerun triggers:
  - Any edit to docs, skills, templates, memory, or examples
  - Any change to rollback or completion language
- Thresholds:
  - Canonical docs and skills use `EXECUTION CONTRACT` and `FINALIZE`
  - Canonical docs do not present `EVAL DEFINE`, `REPORT`, or `FINISH` as the primary workflow phases
  - Core workflow docs do not prescribe CI/CD, deploy, release, or PR automation
- Rollback on failure: VERIFY

### EVAL-003
- Type: regression
- Maps to: REQ-003, REQ-008, REQ-009
- Description: Templates, schemas, examples, and shipped assets remain aligned after the vocabulary and artifact-model changes.
- Evidence method: Inspect template/schema/example/installer files and validate phase enums and asset lists through targeted reads and searches.
- Rerun triggers:
  - Any edit to `templates/**`, `schemas/**`, `examples/**`, or `installer/**`
  - Any change to artifact filenames or installable assets
- Thresholds:
  - `eval.md` still exists as an artifact template
  - phase enums include `EXECUTION CONTRACT` and `FINALIZE`
  - installer manifest ships `docs/`
  - examples reflect the new phase order
- Rollback on failure: EXECUTE

## Notes
- Verification in this repo is primarily artifact inspection, schema alignment, and targeted content checks rather than a runtime test suite.
