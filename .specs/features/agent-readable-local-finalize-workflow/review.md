# Review: agent-readable-local-finalize-workflow

## Scope Reviewed
Repo-wide workflow refactor: canonical phase order, progressive disclosure docs tree, new artifacts, updated templates and schemas, aligned skills, memory, examples, and installer manifest.

## Findings

### docs/ tree
- `docs/workflow/`: 16 docs covering INTAKE through FINALIZE plus overview and phases-and-gates
- `docs/roles/`: 8 role docs covering Orchestrator, Codebase Reader, Spec Agent, Design Agent, Implementer, Verifier, Reviewer, Eval Agent
- `docs/standards/`: 9 standard docs covering traceability, evidence freshness, rollback rules, state consistency, parallelism, agent-readable repo, subagent boundaries, evidence pack, local quality checks

### Templates
- `templates/execution-contract.md` created with run scope, included/excluded tasks, parallelism, rollback routing
- `templates/finalize-report.md` created with evidence freshness check, residual risks, pendings, handoff notes
- `templates/report.md` updated with note pointing to `finalize-report.md` as canonical
- All existing templates updated to new phase vocabulary

### Schemas
- `state.schema.json` enum updated to new phase list
- `run-history.schema.json` enum updated to new phase list
- All JSON files validate cleanly

### Skills
- All 5 skills updated to new phase vocabulary and role names
- `EVAL DEFINE` absorbed as artifact discipline in `harness-evals`

### Installer
- `installer/lib/manifest.sh` updated to include `docs/` in all installation modes

### Examples
- Small and medium examples updated to new workflow with FINALIZE and EXECUTION CONTRACT phases
- `finalize-report.md` added to both examples
- `execution-contract.md` added to medium example

### Vocabulary
- Old phase terms (EVAL DEFINE, REPORT, FINISH) removed from canonical docs, skills, and templates
- Remaining occurrences are only in transition/compatibility notes explaining the change
- `docs/workflow/parallelism.md` fan-in rules updated to list FINALIZE instead of REPORT+FINISH

## Decision
pass

## Required Rework
none

## Rollback Target
none (decision is pass)

## Evidence Reviewed
- Vocabulary grep confirms EXECUTION CONTRACT and FINALIZE in canonical docs
- Vocabulary grep confirms no old phase terms as canonical vocabulary (only in compatibility notes)
- All JSON files pass schema validation
- All new docs/templates/artifacts exist at expected paths

## Residual Risks
- Historical `.specs/features/*` snapshots retain old phase vocabulary — treated as legacy and not rewritten

## Notes
- This refactor introduced the new canonical workflow while preserving eval.md as a standing artifact.
- Installer manifest update ensures `docs/` is shipped in all installation modes, preserving navigability of AGENTS.md.
