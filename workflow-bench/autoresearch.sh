#!/bin/bash
# Autoresearch benchmark script for workflow improvement
# Uses simulated workflows for fast iteration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$SCRIPT_DIR"

# Run the benchmark suite (simulation mode for fast iteration)
# Use USE_OPENCODE=true for real OpenCode runs (slow)
run_benchmark() {
    local output
    
    if [[ "${USE_OPENCODE:-false}" == "true" ]]; then
        echo "=== Running with OpenCode (slow) ==="
        export TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-1800}"
        output=$("$BENCH_DIR/scripts/run-all-opencode-scenarios.sh" 2>&1) || true
    else
        echo "=== Running simulation (fast) ==="
        output=$("$BENCH_DIR/scripts/run-all-scenarios.sh" 2>&1) || true
    fi
    
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
    echo "=== Workflow Benchmark Autoresearch ==="
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "Mode: ${USE_OPENCODE:-simulation}"
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
