# Project Memory Testing

## What testing means here
- This repository is mostly workflow documentation and artifact definitions.
- Validation is primarily consistency checking, artifact inspection, and schema alignment rather than application runtime tests.
- Local quality checks are self-contained and do not require CI/CD infrastructure.

## Typical verification targets
- Workflow docs use the same phase names and decision names as `AGENTS.md` and `README.md`.
- Skills use the same ownership, gate, and rollback language as the docs.
- Templates reflect the documented artifact model.
- Schemas still match the machine-readable examples and templates.

## Practical read order for verification
1. Read the changed memory/docs/templates/skills files.
2. Cross-check against `AGENTS.md` and `README.md`.
3. Cross-check affected workflow reference docs under `docs/workflow/`.
4. If machine-readable artifacts changed, inspect `schemas/*.json` and matching templates.
5. Run local vocabulary checks to confirm canonical phase terms are used and old terms are removed.

## Evidence style used by this repo
- Fresh inspection evidence matters more than assumptions.
- Claims should be tied to current files, not remembered repository state.
- After relevant changes, treat previous verify/review conclusions as stale.

## Local quality check approach
- Use `score_workflow.sh` when present in a feature directory.
- Use targeted grep for vocabulary consistency across docs and templates.
- Schema validation is done against the JSON schemas in `schemas/`.
