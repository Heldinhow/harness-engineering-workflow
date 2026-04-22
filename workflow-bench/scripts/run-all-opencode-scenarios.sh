#!/bin/bash
# Run all benchmark scenarios using real OpenCode execution
# Usage: ./run-all-opencode-scenarios.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCENARIOS_DIR="$BENCH_DIR/scenarios"
RUNS_DIR="$BENCH_DIR/runs"

# Timeout for each scenario (default 15 minutes)
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-900}"

# Create runs directory
mkdir -p "$RUNS_DIR"

# Run single scenario with timeout
run_scenario_safe() {
    local scenario="$1"
    local output
    
    # Set timeout for this run
    export TIMEOUT_SECONDS
    
    output=$("$SCRIPT_DIR/run-opencode-scenario.sh" "$scenario" 2>&1) || {
        echo "WARNING: $scenario failed or timed out, but continuing..." >&2
        echo "$output" >&2
        return 0  # Don't fail the entire benchmark
    }
    
    echo "$output"
}

# Main
main() {
    echo "=========================================="
    echo "  Workflow Benchmark Suite (OpenCode)"
    echo "=========================================="
    echo "Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "Timeout per scenario: $TIMEOUT_SECONDS seconds"
    echo ""
    
    # List scenarios
    local scenarios=()
    for scenario_file in "$SCENARIOS_DIR"/*.md; do
        if [[ -f "$scenario_file" ]]; then
            scenarios+=("$(basename "$scenario_file" .md)")
        fi
    done
    
    echo "Found ${#scenarios[@]} scenarios:"
    for s in "${scenarios[@]}"; do
        echo "  - $s"
    done
    echo ""
    
    # Run each scenario and collect scores
    local total_score=0
    local runs_succeeded=0
    local runs_failed=0
    local scenario_scores_json="{"
    local first_score=true
    
    for scenario in "${scenarios[@]}"; do
        echo "----------------------------------------"
        echo "Running: $scenario (timeout: ${TIMEOUT_SECONDS}s)"
        echo "----------------------------------------"
        
        if output=$(run_scenario_safe "$scenario"); then
            runs_succeeded=$((runs_succeeded + 1))
            
            # Extract score from scoring output
            local score=$(echo "$output" | grep "^METRIC score=" | head -1 | cut -d= -f2 || echo "0")
            total_score=$((total_score + score))
            
            echo "$output"
            
            # Add to JSON
            if [[ "$first_score" == "true" ]]; then
                first_score=false
            else
                scenario_scores_json="${scenario_scores_json},"
            fi
            scenario_scores_json="${scenario_scores_json}\"$scenario\": $score"
        else
            runs_failed=$((runs_failed + 1))
            echo "FAILED or TIMEOUT: $scenario"
            
            if [[ "$first_score" == "true" ]]; then
                first_score=false
            else
                scenario_scores_json="${scenario_scores_json},"
            fi
            scenario_scores_json="${scenario_scores_json}\"$scenario\": 0"
        fi
        
        echo ""
    done
    
    scenario_scores_json="${scenario_scores_json}}"
    
    # Calculate aggregate score
    local avg_score=0
    if [[ "$runs_succeeded" -gt 0 ]]; then
        avg_score=$((total_score / runs_succeeded))
    fi
    
    # Print summary
    echo "=========================================="
    echo "  Benchmark Summary"
    echo "=========================================="
    echo ""
    echo "Total scenarios: ${#scenarios[@]}"
    echo "Succeeded: $runs_succeeded"
    echo "Failed/Timeout: $runs_failed"
    echo ""
    echo "Per-scenario scores:"
    for scenario in "${scenarios[@]}"; do
        printf "  %-30s\n" "$scenario"
    done
    echo ""
    echo "Average score: $avg_score"
    echo "Total score: $total_score"
    echo ""
    echo "Completed: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    
    # Output aggregate METRIC lines
    echo ""
    echo "METRIC total_scenarios=${#scenarios[@]}"
    echo "METRIC scenarios_succeeded=$runs_succeeded"
    echo "METRIC scenarios_failed=$runs_failed"
    echo "METRIC total_score=$total_score"
    echo "METRIC average_score=$avg_score"
    
    # Save aggregated results
    cat > "$RUNS_DIR/aggregated-results.json" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "executor": "opencode",
    "timeout_seconds": $TIMEOUT_SECONDS,
    "total_scenarios": ${#scenarios[@]},
    "scenarios_succeeded": $runs_succeeded,
    "scenarios_failed": $runs_failed,
    "total_score": $total_score,
    "average_score": $avg_score,
    "scenario_scores": $scenario_scores_json
}
EOF
    
    exit 0
}

main "$@"
