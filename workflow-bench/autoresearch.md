# Autoresearch: Workflow Benchmark Optimization

## Objective
Create and iterate on a real workflow benchmark that executes the harness-engineering-workflow through OpenCode, captures outputs, scores behavior, and improves the workflow based on empirical results.

**Goal**: Stop optimizing only docs/templates. Build a benchmark that exercises the actual workflow and measures real behavior.

## Metrics

### Primary
- **workflow_score** (0-100, higher is better) — aggregate score from benchmark suite measuring workflow correctness

### Secondary
- total_score — sum of all scenario scores
- scenarios_succeeded — count of passing scenarios
- scenarios_failed — count of failing scenarios  
- total_scenarios — total number of scenarios in suite

## How to Run
```bash
./workflow-bench/autoresearch.sh
```

The script outputs `METRIC` lines for each metric.

## Benchmark Suite Structure

```
workflow-bench/
├── scenarios/          # Scenario definitions
│   ├── simple-feature.md
│   ├── ambiguous-request.md
│   ├── task-dependency-failure.md
│   ├── stale-evidence.md
│   └── parallelism-misuse.md
├── fixtures/           # Test fixtures
│   └── timestamp-utils.js
├── runs/              # Output from benchmark runs (gitignored)
├── scripts/           # Core benchmark scripts
│   ├── run-scenario.sh
│   ├── run-all-scenarios.sh
│   ├── score-run.sh
│   ├── collect-session-data.sh
│   ├── sync-opencode-skills.sh
│   └── validate-workflow-artifacts.sh
└── evaluators/        # Scoring logic
    └── score-run.sh
```

## Scoring Dimensions

Each scenario is scored across 11 dimensions (max 100 total):

| Dimension | Max | What It Measures |
|-----------|-----|-----------------|
| phase_order | 40 | Correct sequence of workflow phases |
| artifact_quality | 45 | Presence and quality of required artifacts |
| traceability | 25 | REQ-* to EVAL-* to verification mapping |
| rollback_correctness | 25 | Specific phase targets, no vague language |
| stale_evidence_enforcement | 25 | Fresh evidence after changes |
| state_consistency | 30 | state.md and state.json alignment |
| parallelism_correctness | 25 | Correct execution class assignments |
| code_scope_alignment | 25 | Scope documented and followed |
| test_pass_rate | 25 | Tests pass and evidence captured |
| finalize_discipline | 25 | Complete finalize-report.md |

## Penalty Categories

Heavily penalized behaviors (5 points per occurrence):
- **false_pass**: Review passed without real evidence
- **stale_evidence_accepted**: Old evidence accepted as current
- **vague_rollback**: "go back" instead of phase name
- **premature_implementation**: Started EXECUTE without spec
- **skipped_phase**: Required phase not executed
- **invalid_parallel_fanout**: Parallel tasks with dependencies
- **inconsistent_state**: state.md/state.json drift

## Mandatory Skill Synchronization

**Critical Rule**: `.config/opencode/skills` must always reflect the current workflow state.

Before any OpenCode benchmark run:
1. `sync-opencode-skills.sh sync` copies skills from `skills/` to `.config/opencode/skills/`
2. `sync-opencode-skills.sh check` validates synchronization
3. Benchmark checks fail if skills diverge

This ensures OpenCode tests against the current workflow, not stale files.

## Files in Scope

### Workflow Source (immutable during benchmark)
- `skills/harness-engineering-workflow/SKILL.md`
- `skills/harness-planning/SKILL.md`
- `skills/harness-evals/SKILL.md`
- `skills/harness-execution/SKILL.md`
- `skills/harness-review/SKILL.md`
- `schemas/state.schema.json`
- `schemas/run-history.schema.json`
- `docs/workflow/*.md`

### Benchmark Infrastructure (mutable, optimized)
- `workflow-bench/scenarios/*.md`
- `workflow-bench/evaluators/score-run.sh`
- `workflow-bench/scripts/*.sh`

### Output (read-only during benchmark)
- `workflow-bench/runs/*/`

## Off Limits

- Do NOT modify workflow source files to game the benchmark
- Do NOT weaken scoring criteria to improve scores
- Do NOT add fake scenarios just to increase total_scenarios
- Do NOT treat file existence as sufficient evidence

## Constraints

1. All checks must pass: schemas valid, skills synced, infrastructure complete
2. Benchmark must run successfully without crashes
3. No new dependencies without explicit approval
4. Preserve backward compatibility with existing workflow docs

## Scenarios

### 1. simple-feature
Tests basic workflow adherence for a straightforward feature. 
**Weight**: Baseline for workflow correctness.

### 2. ambiguous-request
Tests SPECIFY gate enforcement against vague requirements.
**Weight**: Critical. High penalty for premature implementation.

### 3. task-dependency-failure
Tests correct dependency tracking and task ordering.
**Weight**: High penalty for invalid fan-out.

### 4. stale-evidence
Tests evidence freshness detection and enforcement.
**Weight**: Critical. Maximum penalty for false passes.

### 5. parallelism-misuse
Tests correct execution class assignments.
**Weight**: High penalty for wrong parallelism model.

## What's Been Tried

### Iteration 1 (baseline)
- Created benchmark infrastructure with 5 scenarios
- All scenarios pass with simulated workflow runs
- Skills sync mechanism working correctly
- Check validation operational

### Next Steps
- Add OpenCode integration for real agent runs
- Expand scenario coverage for edge cases
- Improve scoring granularity based on real runs
- Track score trends over iterations

## Success Criteria

This round succeeds only if:
1. [x] Repo has a real workflow benchmark
2. [x] Scenarios can be executed against the workflow
3. [x] .config/opencode/skills sync is enforced
4. [x] Outputs are scored from benchmark runs
5. [ ] Autoresearch can use scores to improve workflow
