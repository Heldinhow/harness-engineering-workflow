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
    
    # Create mock run history based on what was executed
    # In a real benchmark, this would be captured from actual OpenCode runs
    cat > "$workspace/run-history.json" << 'EOF'
{
    "feature_id": "bench-feature",
    "runs": []
}
EOF
    
    # Create mock test results
    cat > "$workspace/test-results.json" << 'EOF'
{
    "passed": 0,
    "failed": 0,
    "total": 0
}
EOF
    
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
    # For now, we create a minimal feature structure
    
    local feature_dir="$workspace/feature"
    
    # Create minimal spec
    cat > "$feature_dir/spec.md" << 'EOF'
# Feature: Benchmark Test

## Objective
Test scenario placeholder.

## Requirements

### REQ-001
- WHEN benchmark runs THEN the workflow SHALL produce required artifacts.

### REQ-002
- WHEN phases execute THEN the order SHALL follow the canonical sequence.
EOF
    
    # Create eval
    cat > "$feature_dir/eval.md" << 'EOF'
# Evaluation Criteria

## EVAL-001
- Verify spec.md contains REQ-* requirements

## EVAL-002
- Verify phase order in run history

## EVAL-003
- Verify state consistency between state.md and state.json
EOF
    
    # Create state artifacts
    cat > "$feature_dir/state.json" << EOF
{
    "feature_id": "bench-feature",
    "complexity": "small",
    "current_phase": "FINALIZE",
    "status": "done",
    "pending_gate": "FINALIZE",
    "owner_role": "orchestrator",
    "owner_id": "agent-001",
    "last_run_id": "RUN-9",
    "next_step": "complete",
    "blockers": [],
    "latest_evidence_refs": ["eval.md"],
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
- **Last Run**: RUN-9
- **Rollback Target**: FINALIZE
EOF
    
    # Create finalize report
    cat > "$feature_dir/finalize-report.md" << 'EOF'
# Finalize Report

## Implementation Complete
All required artifacts produced.

## Evidence
- spec.md: REQ-001, REQ-002
- eval.md: EVAL-001, EVAL-002, EVAL-003
- run-history.json: 9 phase transitions

## Tests
No tests required for this scenario.

## Residual Debt
None.

## Handoff
Feature complete for benchmark purposes.
EOF
    
    # Create run history
    cat > "$workspace/run-history.json" << 'EOF'
{
    "feature_id": "bench-feature",
    "runs": [
        {"run_id": "RUN-1", "phase": "INTAKE", "status": "passed", "decision": "continue", "notes": "classified as small"},
        {"run_id": "RUN-2", "phase": "SPECIFY", "status": "passed", "decision": "continue", "notes": "REQ-001, REQ-002 defined"},
        {"run_id": "RUN-3", "phase": "EXECUTION CONTRACT", "status": "passed", "decision": "continue", "notes": "scope locked"},
        {"run_id": "RUN-4", "phase": "EXECUTE", "status": "passed", "decision": "continue", "notes": "implementation complete"},
        {"run_id": "RUN-5", "phase": "VERIFY", "status": "passed", "decision": "continue", "notes": "evidence captured"},
        {"run_id": "RUN-6", "phase": "REVIEW", "status": "passed", "decision": "continue", "notes": "pass"},
        {"run_id": "RUN-7", "phase": "FINALIZE", "status": "passed", "decision": "finish", "notes": "complete"}
    ]
}
EOF
    
    # Create test results
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
