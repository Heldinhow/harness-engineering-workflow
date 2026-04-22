# Execution Contract: <feature>

## Run Scope
<what this run will accomplish>

## Included Requirements
- REQ-001
- REQ-002

## Excluded Requirements
- REQ-003
- <requirement explicitly deferred>

## Included Tasks
- TASK-001
- TASK-002

## Excluded Tasks
- TASK-003
- <task explicitly deferred>

## Dependencies
- <dependency or none>
- <resolved dependency or none>

## Parallelism
- Execution class: <sequential | parallelizable | blocked>
- Rationale: <why this class was chosen>

## Expected Codebase Surfaces
- `<path or area>`
- `<path or area>`

## Mandatory Run Tests
- <test or check that must pass during this run>
- <test or check that must pass during this run>

## Done Criteria
- <what makes this run complete>
- <what makes this run complete>

## Rollback Routing
| Failure class | Rollback target |
|---|---|
| Ambiguity or requirement mismatch | SPECIFY |
| Structural inconsistency | DESIGN |
| Bad decomposition or unsafe parallelism | TASKS |
| Incomplete implementation or failing tests | EXECUTE |
| Stale or missing evidence | VERIFY |

## Example

### EXECUTION CONTRACT
## Run Scope
Implement the validation script and update templates to support the new phase vocabulary.

## Included Requirements
- REQ-001: AGENTS.md acts as a short index
- REQ-003: Canonical phase order uses EXECUTION CONTRACT and FINALIZE

## Excluded Requirements
- REQ-007: Installer manifest update (deferred to separate run)

## Included Tasks
- TASK-001: Update AGENTS.md and README.md
- TASK-002: Update docs/ templates

## Excluded Tasks
- TASK-005: Update installer manifest (deferred)

## Dependencies
- None — repo is stable for this run

## Parallelism
- Execution class: sequential
- Rationale: vocabulary changes must be applied in order to avoid conflicts

## Expected Codebase Surfaces
- `AGENTS.md`
- `README.md`
- `docs/workflow/`
- `templates/`

## Mandatory Run Tests
- Vocabulary grep confirms EXECUTION CONTRACT and FINALIZE in canonical docs
- Vocabulary grep confirms no EVAL DEFINE, REPORT, or FINISH in canonical docs

## Done Criteria
- Root docs updated and pointing into new docs tree
- All phase references updated in docs and templates
- No old phase vocabulary in canonical docs

## Rollback Routing
| Failure class | Rollback target |
|---|---|
| Ambiguity | SPECIFY |
| Structural inconsistency | DESIGN |
| Bad task decomposition | TASKS |
| Implementation issue | EXECUTE |
| Stale evidence | VERIFY |
