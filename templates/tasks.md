# Tasks: <feature>

## Execution Mode
- Inline | Plan-driven

## Tasks

### TASK-001
Objective: <what this task is meant to accomplish>
Maps to: REQ-001
Related evals: EVAL-001
Owner role: <Orchestrator | Codebase Reader | Spec Agent | Design Agent | Eval Agent | Execution Agent | Reviewer>
Execution class: sequential
Depends on: none
Required artifacts:
- `<artifact>`
Minimal context:
- <only the local context needed to execute>
Files/areas:
- `<path>`
Ready definition:
- <what must already be true>
Done definition:
- <what makes this task complete>
Expected evidence:
- <command output, inspection note, or artifact>

## Verification Checklist (run before marking complete)
- [ ] All file changes are intentional and documented
- [ ] Evidence command was run and output captured
- [ ] Evidence is from current artifact state (not stale)
- [ ] State artifacts (state.md, state.json) are updated
- [ ] Run history (run-history.md, run-history.json) is updated
- [ ] Rollback target is defined for this gate

### TASK-002
Objective: <what this task is meant to accomplish>
Maps to: REQ-002
Related evals: EVAL-002
Owner role: <Orchestrator | Codebase Reader | Spec Agent | Design Agent | Eval Agent | Execution Agent | Reviewer>
Execution class: parallelizable
Depends on: TASK-001
Required artifacts:
- `<artifact>`
Minimal context:
- <only the local context needed to execute>
Files/areas:
- `<path>`
Ready definition:
- <what must already be true>
Done definition:
- <what makes this task complete>
Expected evidence:
- <command output, inspection note, or artifact>

## Example Task

### TASK-001
Objective: Add validation to check that all required artifacts exist
Maps to: REQ-001
Related evals: EVAL-001
Owner role: Execution Agent
Execution class: sequential
Depends on: none
Required artifacts:
- `scripts/validate.sh`
Minimal context:
- REQ-001 requirement: all required artifacts MUST be present
- Feature directory structure: `.specs/features/<feature>/`
Files/areas:
- `scripts/validate.sh`
Ready definition:
- Feature ID is known (`<feature>`)
- Required artifacts list is defined in spec.md
Done definition:
- `scripts/validate.sh` exists and returns 0 when all artifacts present
- Returns non-zero with message when artifacts are missing
Expected evidence:
- Output of `bash scripts/validate.sh <feature>` showing all artifacts present
