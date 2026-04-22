#!/bin/bash
# Collect session data from a workflow run
# Usage: ./collect-session-data.sh <run-directory>

set -euo pipefail

RUN_DIR="${1:-}"

if [[ -z "$RUN_DIR" ]]; then
    echo "Usage: $0 <run-directory>"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Collect all relevant data from a run
collect_artifacts() {
    local run_dir="$1"
    
    echo "=== Collecting session data from: $run_dir ==="
    
    # Check for feature directory
    local feature_dir="$run_dir/feature"
    
    if [[ ! -d "$feature_dir" ]]; then
        echo "WARNING: No feature directory found"
        return 1
    fi
    
    # Create session data file
    cat > "$run_dir/session-data.json" << EOF
{
    "run_dir": "$run_dir",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "artifacts": []
}
EOF
    
    # List all artifacts
    echo "Artifacts found:"
    find "$feature_dir" -type f -name "*.md" -o -name "*.json" 2>/dev/null | while read -r artifact; do
        local rel_path="${artifact#$feature_dir/}"
        echo "  - $rel_path"
    done
    
    # Count phases in run history
    if [[ -f "$run_dir/run-history.json" ]]; then
        local phase_count=$(python3 -c "
import json
with open('$run_dir/run-history.json') as f:
    data = json.load(f)
print(len(data.get('runs', [])))
" 2>/dev/null || echo "0")
        
        echo "Phase transitions: $phase_count"
    fi
    
    echo ""
    echo "Session data collection complete"
}

collect_artifacts "$RUN_DIR"
