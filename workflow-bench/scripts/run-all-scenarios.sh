#!/bin/bash
# Run all benchmark scenarios and aggregate results
# Usage: ./run-all-scenarios.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCENARIOS_DIR="$BENCH_DIR/scenarios"
RUNS_DIR="$BENCH_DIR/runs"

# Create runs directory
mkdir -p "$RUNS_DIR"

# Run single scenario with error handling
run_scenario_safe() {
    local scenario="$1"
    local output
    
    output=$("$SCRIPT_DIR/run-scenario.sh" "$scenario" 2>&1) || {
        echo "FAILED: $scenario" >&2
        echo "$output" >&2
        return 1
    }
    
    echo "$output"
}

# Main
main() {
    echo "=========================================="
    echo "  Workflow Benchmark Suite"
    echo "=========================================="
    echo "Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
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
        echo "Running: $scenario"
        echo "----------------------------------------"
        
        if output=$(run_scenario_safe "$scenario"); then
            runs_succeeded=$((runs_succeeded + 1))
            
            # Extract score
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
            echo "FAILED"
            
            if [[ "$first_score" == "true" ]]; then
                first_score=false
            else
                scenario_scores_json="${scenario_scores_json},"
            fi
            scenario_scores_json="${scenario_scores_json}\"$scenario\": \"FAILED\""
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
    echo "Failed: $runs_failed"
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
    "total_scenarios": ${#scenarios[@]},
    "scenarios_succeeded": $runs_succeeded,
    "scenarios_failed": $runs_failed,
    "total_score": $total_score,
    "average_score": $avg_score,
    "scenario_scores": $scenario_scores_json
}
EOF
    
    # Return appropriate exit code
    if [[ "$runs_failed" -gt 0 ]]; then
        exit 1
    fi
    exit 0
}

main "$@"
