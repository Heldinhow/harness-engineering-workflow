# Local Quality Checks

## Purpose

Define what quality checks are local, repeatable, and under the developer's control — without CI/CD, GitHub Actions, deploy, release, or PR automation.

## What Local Means Here

Local quality checks are checks that the developer or agent running the workflow can execute directly in the current environment. They do not require remote infrastructure, external services, or automated pipelines.

## Local Quality Check Types

### Artifact Inspection
- All required artifacts exist and are non-empty
- Artifact content uses canonical vocabulary (phase names, role names, decision names)
- Required sections are present in each artifact

### Schema Validation
- `state.json` passes JSON schema validation
- `run-history.json` passes JSON schema validation

### State Alignment
- `state.md` and `state.json` agree on `current_phase`, `status`, `rollback_target`, and `last_run_id`
- Run history transitions are sequential (no backward jumps without rationale)

### Vocabulary Consistency
- All docs, templates, and skills use the canonical phase list: `INTAKE`, `SPECIFY`, `DESIGN`, `TASKS`, `EXECUTION CONTRACT`, `EXECUTE`, `VERIFY`, `REVIEW`, `FINALIZE`
- No old phase vocabulary (`EVAL DEFINE`, `REPORT`, `FINISH`) in canonical docs and skills

### Evidence Freshness
- All evidence_refs in run history point to existing files
- Evidence timestamps are after the last relevant artifact change
- Stale evidence is marked in `stale_evidence_refs`

## What Is Not Local Scope

The following are explicitly out of scope for the local quality layer:

- CI pipelines and GitHub Actions
- Automated deploy or release workflows
- Remote PR checks or merge automation
- External service health checks

## Local Verification Before Finalize

Before issuing a finalize decision:

1. Run schema validation on `state.json` and `run-history.json`
2. Check state alignment between Markdown and JSON forms
3. Confirm all evidence_refs point to existing files
4. Verify canonical vocabulary is used consistently across docs and templates
