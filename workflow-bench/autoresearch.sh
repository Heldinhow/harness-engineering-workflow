#!/bin/bash
# Autoresearch benchmark script for workflow improvement
# Runs the workflow benchmark using real OpenCode execution

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$SCRIPT_DIR"

# Timeout for each OpenCode scenario (15 minutes default)
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-900}"

# Run the benchmark suite with OpenCode
run_benchmark() {
    local output
    
    # Run with OpenCode using run-opencode-scenario.sh
    export TIMEOUT_SECONDS
    
    output=$("$BENCH_DIR/scripts/run-all-opencode-scenarios.sh" 2>&1) || true
    echo "$output"
}

# Extract metrics from benchmark output
extract_metrics() {
    local output="$1"
    
    # Primary metric: average workflow score
    local avg_score=$(echo "$output" | grep "^METRIC average_score=" | head -1 | cut -d= -f2 || echo "0")
    
    # Secondary metrics
    local total_score=$(echo "$output" | grep "^METRIC total_score=" | head -1 | cut -d= -f2 || echo "0")
    local scenarios_succeeded=$(echo "$output" | grep "^METRIC scenarios_succeeded=" | head -1 | cut -d= -f2 || echo "0")
    local scenarios_failed=$(echo "$output" | grep "^METRIC scenarios_failed=" | head -1 | cut -d= -f2 || echo "0")
    local total_scenarios=$(echo "$output" | grep "^METRIC total_scenarios=" | head -1 | cut -d= -f2 || echo "0")
    
    # Output primary METRIC
    echo "METRIC workflow_score=$avg_score"
    
    # Output secondary metrics
    echo "METRIC total_score=$total_score"
    echo "METRIC scenarios_succeeded=$scenarios_succeeded"
    echo "METRIC scenarios_failed=$scenarios_failed"
    echo "METRIC total_scenarios=$total_scenarios"
}

# Main execution
main() {
    echo "=== Workflow Benchmark Autoresearch with OpenCode ==="
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "Timeout per scenario: $TIMEOUT_SECONDS seconds"
    echo ""
    
    # Run benchmark and capture output
    local benchmark_output
    benchmark_output=$(run_benchmark)
    
    # Print benchmark output for visibility
    echo "$benchmark_output"
    echo ""
    
    # Extract and output metrics
    echo "=== Metrics ==="
    extract_metrics "$benchmark_output"
}

main "$@"
