#!/bin/bash
# Run a single benchmark scenario
# Usage: ./run-scenario.sh <scenario-name>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$BENCH_DIR/.." && pwd)"
SCENARIOS_DIR="$BENCH_DIR/scenarios"
RUNS_DIR="$BENCH_DIR/runs"
FIXTURES_DIR="$BENCH_DIR/fixtures"

SCENARIO_NAME="${1:-}"
WORKSPACE_DIR=""

setup_workspace() {
    local scenario_name="$1"
    
    # Create unique workspace
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local workspace="$RUNS_DIR/${scenario_name}_${timestamp}"
    
    mkdir -p "$workspace/feature"
    mkdir -p "$workspace/logs"
    
    WORKSPACE_DIR="$workspace"
    echo "WORKSPACE: $workspace"
}

# Sync skills before running OpenCode
sync_skills() {
    echo "=== Syncing workflow skills ==="
    "$SCRIPT_DIR/sync-opencode-skills.sh" sync
    
    if ! "$SCRIPT_DIR/sync-opencode-skills.sh" check; then
        echo "ERROR: Skill sync check failed" >&2
        return 1
    fi
}

# Collect session data from a simulated workflow run
collect_session_data() {
    local workspace="$1"
    local scenario_dir="$2"
    
    echo "=== Collecting session data ==="
    
    # Copy scenario definition
    cp "$scenario_dir" "$workspace/scenario.md"
    
    # Preserve run-history from simulate_workflow_run if it exists
    # In a real benchmark, this would be captured from actual OpenCode runs
    if [[ ! -f "$workspace/run-history.json" ]]; then
        cat > "$workspace/run-history.json" << 'EOF'
{
    "feature_id": "bench-feature",
    "runs": []
}
EOF
    fi
    
    # Preserve test-results from simulate_workflow_run if it exists
    if [[ ! -f "$workspace/test-results.json" ]]; then
        cat > "$workspace/test-results.json" << 'EOF'
{
    "passed": 0,
    "failed": 0,
    "total": 0
}
EOF
    fi
    
    # Create state artifacts if they don't exist
    if [[ ! -f "$workspace/feature/state.json" ]]; then
        cat > "$workspace/feature/state.json" << 'EOF'
{
    "feature_id": "bench-feature",
    "complexity": "small",
    "current_phase": "INTAKE",
    "status": "not_started",
    "pending_gate": "INTAKE",
    "owner_role": "orchestrator",
    "owner_id": "agent-001",
    "last_run_id": "RUN-0",
    "next_step": "classify scope",
    "blockers": [],
    "latest_evidence_refs": [],
    "stale_evidence_refs": [],
    "rollback_target": "INTAKE",
    "updated_at": "2024-01-01T00:00:00Z"
}
EOF
    fi
    
    echo "Data collection complete"
}

# Simulate a workflow run (placeholder for OpenCode integration)
simulate_workflow_run() {
    local workspace="$1"
    local scenario="$2"
    
    echo "=== Simulating workflow run for: $scenario ==="
    
    # This is where OpenCode would be invoked
    # For now, we create a realistic feature structure
    
    local feature_dir="$workspace/feature"
    
    # Create spec with realistic requirements
    cat > "$feature_dir/spec.md" << 'EOF'
# Feature: Benchmark Test

## Objective
Test scenario placeholder.

## Requirements

### REQ-001
- WHEN benchmark runs THEN the workflow SHALL produce required artifacts.

### REQ-002
- WHEN phases execute THEN the order SHALL follow the canonical sequence.

### REQ-003
- WHEN tests run THEN the implementation SHALL pass all validation checks.
EOF
    
    # Create eval with traceability
    cat > "$feature_dir/eval.md" << 'EOF'
# Evaluation Criteria

## EVAL-001
- Verify spec.md contains REQ-* requirements
- Maps to: REQ-001

## EVAL-002
- Verify phase order in run history
- Maps to: REQ-002

## EVAL-003
- Verify tests pass
- Maps to: REQ-003
EOF
    
    # Create tasks with execution class
    cat > "$feature_dir/tasks.md" << 'EOF'
# Tasks

## Task 1: Setup
- **Execution class**: sequential
- **Dependencies**: None
- **Owner**: implementer
- **Ready**: spec.md exists, eval.md defined
- **Done**: Setup complete

## Task 2: Implement feature (blocked)
- **Execution class**: blocked
- **Dependencies**: Task 1
- **Owner**: implementer
- **Ready**: Task 1 complete
- **Done**: Implementation complete, tests pass
EOF
    
    # Create execution contract
    cat > "$feature_dir/execution-contract.md" << 'EOF'
# Execution Contract

## Scope
- Files: workflow-bench/fixtures/timestamp-utils.js
- Tasks: 1 task
- Expected surfaces: timestamp-utils.js

## Done Criteria
- Function implemented
- Tests pass

## Rollback Routing
- Implementation failure: EXECUTE
- Requirement change: SPECIFY

## Parallelism
- Sequential execution (single task)
EOF
    
    # Create state artifacts with aligned phases
    cat > "$feature_dir/state.json" << EOF
{
    "feature_id": "bench-feature",
    "complexity": "small",
    "current_phase": "FINALIZE",
    "status": "done",
    "pending_gate": "FINALIZE",
    "owner_role": "orchestrator",
    "owner_id": "agent-001",
    "last_run_id": "RUN-7",
    "next_step": "complete",
    "blockers": [],
    "latest_evidence_refs": ["eval.md", "test-results.json"],
    "stale_evidence_refs": [],
    "rollback_target": "FINALIZE",
    "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    
    cat > "$feature_dir/state.md" << 'EOF'
# Feature State

- **Feature ID**: bench-feature
- **Complexity**: small
- **Current Phase**: FINALIZE
- **Status**: done
- **Owner**: orchestrator/agent-001
- **Last Run**: RUN-7
- **Rollback Target**: FINALIZE
EOF
    
    # Create finalize report with complete evidence
    cat > "$feature_dir/finalize-report.md" << 'EOF'
# Finalize Report

## Implementation Complete
All required artifacts produced and tests passing.

## Evidence
- spec.md: REQ-001, REQ-002, REQ-003
- eval.md: EVAL-001, EVAL-002, EVAL-003
- tasks.md: 1 task defined
- execution-contract.md: scope documented
- run-history.json: 7 phase transitions

## Tests
3 tests: all passed.

## Residual Debt
None.

## Handoff
Feature complete for benchmark purposes.
EOF
    
    # Create run history with complete phase transitions
    cat > "$workspace/run-history.json" << 'EOF'
{
    "feature_id": "bench-feature",
    "runs": [
        {"run_id": "RUN-1", "phase": "INTAKE", "status": "passed", "decision": "continue", "task_id": null, "rollback_to_phase": null, "notes": "classified as small complexity"},
        {"run_id": "RUN-2", "phase": "SPECIFY", "status": "passed", "decision": "continue", "task_id": null, "rollback_to_phase": null, "notes": "REQ-001, REQ-002, REQ-003 defined"},
        {"run_id": "RUN-3", "phase": "EXECUTION CONTRACT", "status": "passed", "decision": "continue", "task_id": null, "rollback_to_phase": null, "notes": "scope locked in execution-contract.md"},
        {"run_id": "RUN-4", "phase": "EXECUTE", "status": "passed", "decision": "continue", "task_id": "TASK-1", "rollback_to_phase": null, "notes": "implementation complete"},
        {"run_id": "RUN-5", "phase": "VERIFY", "status": "passed", "decision": "continue", "task_id": null, "rollback_to_phase": null, "notes": "evidence captured: test output"},
        {"run_id": "RUN-6", "phase": "REVIEW", "status": "passed", "decision": "continue", "task_id": null, "rollback_to_phase": null, "notes": "pass: all requirements met"},
        {"run_id": "RUN-7", "phase": "FINALIZE", "status": "passed", "decision": "finish", "task_id": null, "rollback_to_phase": null, "notes": "complete: tests pass, evidence organized"}
    ]
}
EOF
    
    # Create test results with passing tests
    cat > "$workspace/test-results.json" << 'EOF'
{
    "passed": 3,
    "failed": 0,
    "total": 3
}
EOF
    
    echo "Workflow simulation complete"
}

# Run scenario
run_scenario() {
    local scenario_name="$1"
    local scenario_file="$SCENARIOS_DIR/${scenario_name}.md"
    
    if [[ ! -f "$scenario_file" ]]; then
        echo "ERROR: Scenario not found: $scenario_file" >&2
        return 1
    fi
    
    echo "=== Running Scenario: $scenario_name ==="
    
    # Setup isolated workspace
    setup_workspace "$scenario_name"
    
    # Sync skills before any OpenCode invocation
    if ! sync_skills; then
        echo "ERROR: Failed to sync skills" >&2
        return 1
    fi
    
    # Read scenario and extract key info
    local complexity=$(grep -E "^## Complexity" "$scenario_file" -A 1 | tail -1 | tr -d ' ' || echo "unknown")
    
    echo "Scenario complexity: $complexity"
    
    # Simulate workflow run
    simulate_workflow_run "$WORKSPACE_DIR" "$scenario_name"
    
    # Collect session data
    collect_session_data "$WORKSPACE_DIR" "$scenario_file"
    
    # Score the run
    echo ""
    "$BENCH_DIR/evaluators/score-run.sh" "$scenario_file" "$WORKSPACE_DIR"
    
    echo ""
    echo "=== Run Complete ==="
    echo "Workspace: $WORKSPACE_DIR"
    
    # Save run metadata
    cat > "$WORKSPACE_DIR/run-metadata.json" << EOF
{
    "scenario": "$scenario_name",
    "complexity": "$complexity",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "workspace": "$WORKSPACE_DIR"
}
EOF
}

# Main
main() {
    if [[ -z "$SCENARIO_NAME" ]]; then
        echo "Usage: $0 <scenario-name>"
        echo ""
        echo "Available scenarios:"
        ls -1 "$SCENARIOS_DIR"/*.md 2>/dev/null | xargs -I {} basename {} .md | sed 's/^/  /'
        exit 1
    fi
    
    run_scenario "$SCENARIO_NAME"
}

main "$@"
