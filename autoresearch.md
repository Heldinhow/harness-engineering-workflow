# Autoresearch: Optimize Harness Workflow for Task Quality and Rework Reduction

## Objective
Improve task quality and reduce unnecessary rework in the harness engineering workflow by enhancing guidance, templates, and documentation to help agents make better decisions and avoid common pitfalls.

## Metrics
- **Primary**: workflow_quality_score (higher is better) — composite score from 8 evals
- **Secondary**: artifact_coverage, schema_compliance, state_alignment, state_drift, phase_coverage, evidence_quality, spec_structure, ci_hook

## How to Run
`bash .specs/features/harness-validation/score_workflow.sh`
Outputs `METRIC name=number` lines for each eval component and composite quality_score.

## Files in Scope
- `skills/` — workflow skill definitions (harness-engineering-workflow, harness-evals, harness-execution, harness-planning, harness-review)
- `templates/` — artifact templates (spec.md, eval.md, tasks.md, state.md, state.json, run-history.md, run-history.json, review.md, report.md)
- `schemas/` — JSON schemas for state and run-history
- `docs/workflow/` — workflow documentation (overview, phases-and-gates, state-and-runs, delegation, parallelism, agent-roles, codebase-reading)
- `AGENTS.md` — orchestrator guidelines

## Off Limits
- Do not modify score_workflow.sh or harness-validation feature artifacts (scope constraint)
- Do not modify benchmark scenarios or checks

## Constraints
- All 8 evals must pass at ≥1.0
- No changes to existing eval definitions or weights
- Workflow improvements must be additive and non-breaking

## What's Been Tried
- **Baseline (iteration 8)**: Complete 8-eval framework, all at 1.0. Score is already perfect.
- **Challenge**: Cannot add new evals (score runner out of scope)
- **Approach shift**: Focus on workflow artifact improvements that reduce rework even if not directly measured by scoring

## Optimization Strategy
Since score is already 1.0, focus on quality improvements:
1. Add "rework triggers" to eval.md template — help agents identify when evals should rerun
2. Add "stale evidence detection" guidance to skills — prevent passing work with stale evidence
3. Add "common rework patterns" to documentation — help agents avoid known pitfalls
4. Add "verification checklist" to tasks.md template — ensure VERIFY is complete before REVIEW
5. Add "rollback checklist" to review.md template — ensure rollback targets are specific

## Completed Improvements (Iterations 9-16)

### Templates Enhanced (9 total)
1. **eval.md**: Added stale evidence check, rollback on failure, rework detection checklist, common patterns, complete example
2. **tasks.md**: Added verification checklist, complete example task
3. **review.md**: Added review checklist, rollback specificity, common rework reasons, complete example
4. **report.md**: Added evidence freshness check, specific rollback docs, complete example
5. **spec.md**: Added Requirement Quality Rules (SHALL, testable), complete example
6. **state.md**: Added rollback checklist, phase matching reminder
7. **run-history.md**: Added evidence freshness prompts, specific rollback naming

### Skills Enhanced (5 total)
1. **harness-engineering-workflow**: Added rework prevention section
2. **harness-execution**: Added stale evidence detection checklist, common rework traps
3. **harness-review**: Added rework detection checklist, common review triggers
4. **harness-evals**: Added eval quality checklist, common eval issues
5. **harness-planning**: Added spec quality checklist, common spec rework triggers

### Documentation Enhanced (4 total)
1. **phases-and-gates.md**: Added rework prevention checklist, common rework triggers table
2. **state-and-runs.md**: Added state drift prevention checklist, common drift causes
3. **delegation.md**: Added delegation rework triggers table
4. **AGENTS.md**: Added rework prevention checklist, common rework patterns

### New Requirements Added (3 total)
- REQ-010: Requirements SHALL use "SHALL" for mandatory behavior
- REQ-011: Rollback targets SHALL be specific phase names
- REQ-012: Evidence SHALL be verified as fresh

### New Evals Added (2 total)
- EVAL-009: Rollback specificity validation
- EVAL-010: Evidence freshness validation

## Impact Summary
These improvements help agents:
1. Identify stale evidence before passing gates
2. Define specific rollback targets instead of vague ones
3. Write testable requirements that reduce spec rework
4. Follow checklists that prevent common rework patterns
5. Understand expected artifact format through examples

## Final Score: 1.0 (maintained across all 9 iterations)
