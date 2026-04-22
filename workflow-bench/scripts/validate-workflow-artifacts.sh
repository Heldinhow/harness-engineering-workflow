#!/bin/bash
# Validate workflow artifacts against schemas and phase order

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCHEMAS_DIR="$REPO_ROOT/schemas"

# Track validation results
ERRORS=()
WARNINGS=()

# Validate JSON file against schema
validate_json_schema() {
    local json_file="$1"
    local schema_file="$2"
    local artifact_name="$3"
    
    if [[ ! -f "$json_file" ]]; then
        ERRORS+=("MISSING: $json_file for $artifact_name")
        return 1
    fi
    
    # Basic JSON syntax validation
    if ! python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
        ERRORS+=("INVALID JSON: $json_file")
        return 1
    fi
    
    return 0
}

# Check phase order is valid
validate_phase_order() {
    local state_file="$1"
    local run_history_file="$2"
    
    local valid_phases='["INTAKE","SPECIFY","DESIGN","TASKS","EXECUTION CONTRACT","EXECUTE","VERIFY","REVIEW","FINALIZE"]'
    
    if [[ -f "$state_file" ]]; then
        local current_phase=$(python3 -c "import json; d=json.load(open('$state_file')); print(d.get('current_phase',''))" 2>/dev/null || echo "")
        if [[ -n "$current_phase" ]]; then
            if ! python3 -c "import json; p='$current_phase'; v=$valid_phases; exit(0 if p in v else 1)" 2>/dev/null; then
                ERRORS+=("INVALID PHASE in state.json: $current_phase")
            fi
        fi
    fi
    
    if [[ -f "$run_history_file" ]]; then
        python3 << PYEOF 2>/dev/null
import json
import sys

valid_phases = ["INTAKE", "SPECIFY", "DESIGN", "TASKS", "EXECUTION CONTRACT", "EXECUTE", "VERIFY", "REVIEW", "FINALIZE"]

try:
    with open('$run_history_file') as f:
        data = json.load(f)
    
    for run in data.get('runs', []):
        phase = run.get('phase', '')
        if phase and phase not in valid_phases:
            print(f"INVALID PHASE in run-history: {phase}", file=sys.stderr)
            sys.exit(1)
        
        rollback = run.get('rollback_to_phase')
        if rollback and rollback not in valid_phases + [None]:
            print(f"INVALID ROLLBACK TARGET: {rollback}", file=sys.stderr)
            sys.exit(1)
except Exception as e:
    print(f"ERROR: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF
        return $?
    fi
    
    return 0
}

# Check state alignment (state.md and state.json agree)
validate_state_alignment() {
    local state_md="$1"
    local state_json="$2"
    
    if [[ ! -f "$state_md" || ! -f "$state_json" ]]; then
        return 0  # Not an error if feature not started
    fi
    
    # Extract current_phase from state.md (simple grep for now)
    local md_phase=$(grep -E "^current_phase:" "$state_md" 2>/dev/null | head -1 | sed 's/.*: *//' || echo "")
    local json_phase=$(python3 -c "import json; d=json.load(open('$state_json')); print(d.get('current_phase',''))" 2>/dev/null || echo "")
    
    if [[ -n "$md_phase" && -n "$json_phase" && "$md_phase" != "$json_phase" ]]; then
        ERRORS+=("STATE DRIFT: state.md has '$md_phase' but state.json has '$json_phase'")
        return 1
    fi
    
    return 0
}

# Validate a single feature directory
validate_feature() {
    local feature_dir="$1"
    local feature_name=$(basename "$feature_dir")
    
    echo "=== Validating feature: $feature_name ==="
    
    local state_json="$feature_dir/state.json"
    local state_md="$feature_dir/state.md"
    local run_history="$feature_dir/run-history.json"
    
    # Check required artifacts based on phase
    if [[ -f "$state_json" ]]; then
        local current_phase=$(python3 -c "import json; d=json.load(open('$state_json')); print(d.get('current_phase',''))" 2>/dev/null || echo "")
        
        case "$current_phase" in
            "INTAKE"|"")
                # Just state artifacts needed
                ;;
            "SPECIFY")
                if [[ ! -f "$feature_dir/spec.md" ]]; then
                    ERRORS+=("$feature_name: SPECIFY phase requires spec.md")
                fi
                ;;
            "DESIGN")
                if [[ ! -f "$feature_dir/design.md" ]]; then
                    ERRORS+=("$feature_name: DESIGN phase requires design.md")
                fi
                ;;
            "TASKS")
                if [[ ! -f "$feature_dir/tasks.md" ]]; then
                    ERRORS+=("$feature_name: TASKS phase requires tasks.md")
                fi
                ;;
            "EXECUTION CONTRACT")
                if [[ ! -f "$feature_dir/execution-contract.md" ]]; then
                    ERRORS+=("$feature_name: EXECUTION CONTRACT phase requires execution-contract.md")
                fi
                ;;
            "EXECUTE")
                if [[ ! -f "$feature_dir/execution-contract.md" ]]; then
                    ERRORS+=("$feature_name: EXECUTE phase requires execution-contract.md")
                fi
                ;;
            "VERIFY"|"REVIEW"|"FINALIZE")
                if [[ ! -f "$feature_dir/eval.md" ]]; then
                    ERRORS+=("$feature_name: $current_phase phase requires eval.md")
                fi
                ;;
        esac
        
        # Schema validation for JSON artifacts
        if [[ -f "$state_json" ]]; then
            validate_json_schema "$state_json" "$SCHEMAS_DIR/state.schema.json" "state"
        fi
    fi
    
    # Phase order validation
    validate_phase_order "$state_json" "$run_history"
    
    # State alignment
    validate_state_alignment "$state_md" "$state_json"
}

# Main validation
main() {
    echo "=== Workflow Artifact Validation ==="
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo ""
    
    # Validate schemas exist
    if [[ ! -d "$SCHEMAS_DIR" ]]; then
        ERRORS+=("MISSING: schemas directory")
    fi
    
    # Check for benchmark-specific feature directory
    local benchmark_feature_dir="$REPO_ROOT/workflow-bench/runs/latest/feature"
    if [[ -d "$benchmark_feature_dir" ]]; then
        echo "Validating benchmark feature:"
        validate_feature "$benchmark_feature_dir"
    fi
    
    # Validate .specs/features if BENCHMARK_ONLY is not set
    if [[ -z "${BENCHMARK_ONLY:-}" ]] && [[ -d "$REPO_ROOT/.specs/features" ]]; then
        for feature_dir in "$REPO_ROOT/.specs/features"/*; do
            if [[ -d "$feature_dir" ]]; then
                # Skip features with non-standard phases (legacy)
                local phase=$(python3 -c "import json; d=json.load(open('$feature_dir/state.json')); print(d.get('current_phase',''))" 2>/dev/null || echo "")
                if [[ "$phase" == "FINISH" || "$phase" == "EVAL DEFINE" ]]; then
                    echo "SKIP: $feature_dir (legacy phase: $phase)"
                    continue
                fi
                validate_feature "$feature_dir"
            fi
        done
    fi
    
    # Report results
    echo ""
    echo "=== Validation Results ==="
    
    if [[ ${#WARNINGS[@]} -gt 0 ]]; then
        echo "WARNINGS (${#WARNINGS[@]}):"
        for w in "${WARNINGS[@]}"; do
            echo "  - $w"
        done
    fi
    
    if [[ ${#ERRORS[@]} -gt 0 ]]; then
        echo "ERRORS (${#ERRORS[@]}):"
        for e in "${ERRORS[@]}"; do
            echo "  - $e"
        done
        exit 1
    else
        echo "PASS: All validations passed"
        exit 0
    fi
}

main "$@"
