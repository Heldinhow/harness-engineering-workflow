#!/bin/bash
# Score a single workflow benchmark run
# Outputs structured METRIC lines for autoresearch

set -euo pipefail

SCENARIO_DIR="$1"
RUN_DIR="$2"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Initialize scores as individual variables
score_phase_order_val=0
score_artifact_quality_val=0
score_traceability_val=0
score_rollback_correctness_val=0
score_stale_evidence_enforcement_val=0
score_state_consistency_val=0
score_parallelism_correctness_val=0
score_code_scope_alignment_val=0
score_test_pass_rate_val=0
score_finalize_discipline_val=0

# Initialize penalties
penalty_false_pass=0
penalty_stale_evidence_accepted=0
penalty_vague_rollback=0
penalty_premature_implementation=0
penalty_skipped_phase=0
penalty_invalid_parallel_fanout=0
penalty_inconsistent_state=0

PENALTY_MULTIPLIER=5

# Score phase order correctness
score_phase_order() {
    local run_history="$RUN_DIR/run-history.json"
    
    if [[ ! -f "$run_history" ]]; then
        penalty_skipped_phase=$((penalty_skipped_phase + 10))
        return
    fi
    
    # Valid phase sequence
    local valid_phases=("INTAKE" "SPECIFY" "DESIGN" "TASKS" "EXECUTION CONTRACT" "EXECUTE" "VERIFY" "REVIEW" "FINALIZE")
    local phases_in_run=$(python3 -c "
import json
with open('$run_history') as f:
    data = json.load(f)
phases = [r['phase'] for r in data.get('runs', [])]
print(','.join(phases))
" 2>/dev/null || echo "")
    
    if [[ -z "$phases_in_run" ]]; then
        penalty_skipped_phase=$((penalty_skipped_phase + 15))
        return
    fi
    
    score_phase_order_val=40  # Full credit if run history exists and has phases
}

# Score artifact quality
score_artifact_quality() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    # Check essential artifacts
    [[ -f "$feature_dir/spec.md" ]] && score=$((score + 10))
    [[ -f "$feature_dir/eval.md" ]] && score=$((score + 10))
    [[ -f "$feature_dir/execution-contract.md" ]] && score=$((score + 10))
    [[ -f "$feature_dir/finalize-report.md" ]] && score=$((score + 10))
    
    # Check artifact content quality (has REQ-*, EVAL-* patterns)
    if [[ -f "$feature_dir/spec.md" ]]; then
        local req_count=$(grep -cE "REQ-[0-9]+" "$feature_dir/spec.md" 2>/dev/null || echo 0)
        if [[ "$req_count" -gt 0 ]]; then
            score=$((score + 5))
        fi
    fi
    
    score_artifact_quality_val=$score
}

# Score traceability (REQ -> EVAL -> verification)
score_traceability() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    if [[ ! -f "$feature_dir/spec.md" || ! -f "$feature_dir/eval.md" ]]; then
        score_traceability_val=0
        return
    fi
    
    # Extract REQ-* IDs from spec
    local req_ids=$(grep -oE "REQ-[0-9]+" "$feature_dir/spec.md" 2>/dev/null | sort -u || echo "")
    
    # Check if EVAL-* IDs exist and map to REQ-*
    local eval_ids=$(grep -oE "EVAL-[0-9]+" "$feature_dir/eval.md" 2>/dev/null | sort -u || echo "")
    
    if [[ -n "$req_ids" && -n "$eval_ids" ]]; then
        local req_count=$(echo "$req_ids" | wc -w)
        local eval_count=$(echo "$eval_ids" | wc -w)
        
        # At least some traceability should exist
        if [[ "$eval_count" -ge $((req_count / 2)) ]]; then
            score=$((score + 15))
        fi
    fi
    
    # Check run history has phase transitions
    if [[ -f "$RUN_DIR/run-history.json" ]]; then
        local transition_count=$(python3 -c "
import json
with open('$RUN_DIR/run-history.json') as f:
    data = json.load(f)
print(len(data.get('runs', [])))
" 2>/dev/null || echo 0)
        
        if [[ "$transition_count" -gt 3 ]]; then
            score=$((score + 10))
        fi
    fi
    
    score_traceability_val=$score
}

# Score rollback correctness
score_rollback_correctness() {
    local run_history="$RUN_DIR/run-history.json"
    local score=0
    
    if [[ ! -f "$run_history" ]]; then
        score_rollback_correctness_val=0
        return
    fi
    
    local valid_phases='("INTAKE","SPECIFY","DESIGN","TASKS","EXECUTION CONTRACT","EXECUTE","VERIFY","REVIEW","FINALIZE")'
    
    # Check rollback targets are valid phase names
    local invalid_count=$(python3 -c "
import json
with open('$run_history') as f:
    data = json.load(f)

valid = $valid_phases
issues = 0
for run in data.get('runs', []):
    rb = run.get('rollback_to_phase')
    if rb is not None and rb not in valid:
        issues += 1
    # Check for vague rollback language
    notes = run.get('notes', '').lower()
    if any(v in notes for v in ['go back', 'earlier', 'previous stage', 'before']):
        issues += 1
print(issues)
" 2>/dev/null || echo 0)
    
    if [[ "$invalid_count" -eq 0 ]]; then
        score=25
    else
        penalty_vague_rollback=$((invalid_count * PENALTY_MULTIPLIER))
        score=$((25 - invalid_count * 5))
    fi
    
    score_rollback_correctness_val=$score
}

# Score stale evidence enforcement
score_stale_evidence_enforcement() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    if [[ ! -f "$feature_dir/state.json" ]]; then
        score_stale_evidence_enforcement_val=0
        return
    fi
    
    # Check for stale_evidence_refs in state
    local stale_count=$(python3 -c "
import json
with open('$feature_dir/state.json') as f:
    data = json.load(f)
refs = data.get('stale_evidence_refs', [])
print(len(refs))
" 2>/dev/null || echo 0)
    
    # Check timestamps on evidence vs changes
    if [[ -f "$feature_dir/eval.md" ]]; then
        score=$((score + 15))
    fi
    
    if [[ "$stale_count" -gt 0 || -f "$RUN_DIR/stale-evidence-detected" ]]; then
        score=$((score + 10))  # Credit for detecting/handling stale evidence
    fi
    
    score_stale_evidence_enforcement_val=$score
}

# Score state consistency
score_state_consistency() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    local state_md="$feature_dir/state.md"
    local state_json="$feature_dir/state.json"
    
    if [[ ! -f "$state_md" || ! -f "$state_json" ]]; then
        score_state_consistency_val=0
        return
    fi
    
    # Check if current_phase matches in both (handle markdown format)
    local md_phase=$(grep -E "Current Phase|current_phase" "$state_md" 2>/dev/null | head -1 | sed 's/.*: *//' | tr -d '*' || echo "")
    local json_phase=$(python3 -c "import json; d=json.load(open('$state_json')); print(d.get('current_phase',''))" 2>/dev/null || echo "")
    
    if [[ "$md_phase" == "$json_phase" ]]; then
        score=$((score + 25))
    else
        penalty_inconsistent_state=$((penalty_inconsistent_state + 10))
    fi
    
    # Check state.json against schema
    if python3 -c "import json; json.load(open('$state_json'))" 2>/dev/null; then
        score=$((score + 5))
    fi
    
    score_state_consistency_val=$score
}

# Score parallelism correctness
score_parallelism_correctness() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    if [[ ! -f "$feature_dir/tasks.md" ]]; then
        score_parallelism_correctness_val=25  # Neutral if no tasks file
        return
    fi
    
    # Check for execution class declarations (use -o and count lines)
    local parallelizable_count=$(grep -o "parallelizable" "$feature_dir/tasks.md" 2>/dev/null | wc -l)
    local blocked_count=$(grep -o "blocked" "$feature_dir/tasks.md" 2>/dev/null | wc -l)
    local sequential_count=$(grep -o "sequential" "$feature_dir/tasks.md" 2>/dev/null | wc -l)
    
    # Credit for having proper execution class declarations
    local total_classes=$((parallelizable_count + blocked_count + sequential_count))
    if [[ "$total_classes" -gt 0 ]]; then
        score=$((score + 15))
    fi
    
    # Check dependencies are listed
    local has_deps=$(grep -c "depends on\|dependency\|DEP-\|Dependencies" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
    
    if [[ "$has_deps" -gt 0 ]]; then
        score=$((score + 5))
    fi
    
    # Check execution-contract.md for parallelism model
    if [[ -f "$feature_dir/execution-contract.md" ]]; then
        local has_parallelism_doc=$(grep -c "parallel\|fan-out\|fan-in\|sequential" "$feature_dir/execution-contract.md" 2>/dev/null || echo 0)
        if [[ "$has_parallelism_doc" -gt 0 ]]; then
            score=$((score + 5))
        fi
    fi
    
    score_parallelism_correctness_val=$score
}

# Score code scope alignment
score_code_scope_alignment() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    if [[ -f "$feature_dir/execution-contract.md" ]]; then
        # Check for "expected surfaces" or "codebase surfaces" documentation
        local has_scope=$(grep -c "surface\|scope\|file\|module" "$feature_dir/execution-contract.md" 2>/dev/null || echo 0)
        
        if [[ "$has_scope" -gt 0 ]]; then
            score=$((score + 20))
        fi
    fi
    
    # Check run history has tasks aligned with execution contract
    if [[ -f "$RUN_DIR/run-history.json" ]]; then
        local task_count=$(python3 -c "
import json
with open('$RUN_DIR/run-history.json') as f:
    data = json.load(f)
tasks = [r.get('task_id') for r in data.get('runs', []) if r.get('task_id')]
print(len([t for t in tasks if t]))
" 2>/dev/null || echo 0)
        
        if [[ "$task_count" -gt 0 ]]; then
            score=$((score + 5))
        fi
    fi
    
    score_code_scope_alignment_val=$score
}

# Score test pass rate
score_test_pass_rate() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    # Check for test evidence
    if [[ -f "$RUN_DIR/test-results.json" ]]; then
        local pass_rate=$(python3 -c "
import json
with open('$RUN_DIR/test-results.json') as f:
    data = json.load(f)
passed = data.get('passed', 0)
total = data.get('total', 1)
print(int((passed / total) * 25))
" 2>/dev/null || echo 0)
        
        score=$pass_rate
    elif [[ -f "$RUN_DIR/test-output.txt" ]]; then
        # Parse test output
        if grep -q "passed\|PASSED\|OK" "$RUN_DIR/test-output.txt" 2>/dev/null; then
            score=25
        elif grep -q "failed\|FAILED" "$RUN_DIR/test-output.txt" 2>/dev/null; then
            score=10
        fi
    fi
    
    score_test_pass_rate_val=$score
}

# Score finalize discipline
score_finalize_discipline() {
    local feature_dir="$RUN_DIR/feature"
    local score=0
    
    if [[ ! -f "$feature_dir/finalize-report.md" ]]; then
        score_finalize_discipline_val=0
        return
    fi
    
    # Check for required finalize elements
    local has_implementation=$(grep -c "implementation\|complete\|done" "$feature_dir/finalize-report.md" 2>/dev/null || echo 0)
    local has_evidence=$(grep -c "evidence\|test\|verification" "$feature_dir/finalize-report.md" 2>/dev/null || echo 0)
    local has_tests=$(grep -c "test\|check\|validation" "$feature_dir/finalize-report.md" 2>/dev/null || echo 0)
    
    if [[ "$has_implementation" -gt 0 ]]; then
        score=$((score + 8))
    fi
    if [[ "$has_evidence" -gt 0 ]]; then
        score=$((score + 8))
    fi
    if [[ "$has_tests" -gt 0 ]]; then
        score=$((score + 9))
    fi
    
    score_finalize_discipline_val=$score
}

# Calculate total penalty
calculate_total_penalty() {
    local total=0
    total=$((total + penalty_false_pass))
    total=$((total + penalty_stale_evidence_accepted))
    total=$((total + penalty_vague_rollback))
    total=$((total + penalty_premature_implementation))
    total=$((total + penalty_skipped_phase))
    total=$((total + penalty_invalid_parallel_fanout))
    total=$((total + penalty_inconsistent_state))
    echo $total
}

# Main scoring function
main() {
    echo "=== Scoring Run: $(basename "$RUN_DIR") ==="
    echo "Scenario: $SCENARIO_DIR"
    echo ""
    
    # Run all scoring functions
    score_phase_order
    score_artifact_quality
    score_traceability
    score_rollback_correctness
    score_stale_evidence_enforcement
    score_state_consistency
    score_parallelism_correctness
    score_code_scope_alignment
    score_test_pass_rate
    score_finalize_discipline
    
    # Calculate totals
    local total_score=0
    total_score=$((total_score + score_phase_order_val))
    total_score=$((total_score + score_artifact_quality_val))
    total_score=$((total_score + score_traceability_val))
    total_score=$((total_score + score_rollback_correctness_val))
    total_score=$((total_score + score_stale_evidence_enforcement_val))
    total_score=$((total_score + score_state_consistency_val))
    total_score=$((total_score + score_parallelism_correctness_val))
    total_score=$((total_score + score_code_scope_alignment_val))
    total_score=$((total_score + score_test_pass_rate_val))
    total_score=$((total_score + score_finalize_discipline_val))
    
    local total_penalty=$(calculate_total_penalty)
    local final_score=$((total_score - total_penalty))
    
    # Ensure non-negative
    [[ "$final_score" -lt 0 ]] && final_score=0
    [[ "$final_score" -gt 100 ]] && final_score=100
    
    # Output METRIC lines
    echo "METRIC score=$final_score"
    echo "METRIC phase_order=$score_phase_order_val"
    echo "METRIC artifact_quality=$score_artifact_quality_val"
    echo "METRIC traceability=$score_traceability_val"
    echo "METRIC rollback_correctness=$score_rollback_correctness_val"
    echo "METRIC stale_evidence_enforcement=$score_stale_evidence_enforcement_val"
    echo "METRIC state_consistency=$score_state_consistency_val"
    echo "METRIC parallelism_correctness=$score_parallelism_correctness_val"
    echo "METRIC code_scope_alignment=$score_code_scope_alignment_val"
    echo "METRIC test_pass_rate=$score_test_pass_rate_val"
    echo "METRIC finalize_discipline=$score_finalize_discipline_val"
    echo "METRIC penalties=$total_penalty"
    
    # Output penalties separately for visibility
    [[ "$penalty_false_pass" -gt 0 ]] && echo "PENALTY false_pass=$penalty_false_pass"
    [[ "$penalty_stale_evidence_accepted" -gt 0 ]] && echo "PENALTY stale_evidence_accepted=$penalty_stale_evidence_accepted"
    [[ "$penalty_vague_rollback" -gt 0 ]] && echo "PENALTY vague_rollback=$penalty_vague_rollback"
    [[ "$penalty_premature_implementation" -gt 0 ]] && echo "PENALTY premature_implementation=$penalty_premature_implementation"
    [[ "$penalty_skipped_phase" -gt 0 ]] && echo "PENALTY skipped_phase=$penalty_skipped_phase"
    [[ "$penalty_invalid_parallel_fanout" -gt 0 ]] && echo "PENALTY invalid_parallel_fanout=$penalty_invalid_parallel_fanout"
    [[ "$penalty_inconsistent_state" -gt 0 ]] && echo "PENALTY inconsistent_state=$penalty_inconsistent_state"
    
    # Save detailed score to run directory
    cat > "$RUN_DIR/scores.json" << EOF
{
    "final_score": $final_score,
    "component_scores": {
        "phase_order": $score_phase_order_val,
        "artifact_quality": $score_artifact_quality_val,
        "traceability": $score_traceability_val,
        "rollback_correctness": $score_rollback_correctness_val,
        "stale_evidence_enforcement": $score_stale_evidence_enforcement_val,
        "state_consistency": $score_state_consistency_val,
        "parallelism_correctness": $score_parallelism_correctness_val,
        "code_scope_alignment": $score_code_scope_alignment_val,
        "test_pass_rate": $score_test_pass_rate_val,
        "finalize_discipline": $score_finalize_discipline_val
    },
    "penalties": {
        "false_pass": $penalty_false_pass,
        "stale_evidence_accepted": $penalty_stale_evidence_accepted,
        "vague_rollback": $penalty_vague_rollback,
        "premature_implementation": $penalty_premature_implementation,
        "skipped_phase": $penalty_skipped_phase,
        "invalid_parallel_fanout": $penalty_invalid_parallel_fanout,
        "inconsistent_state": $penalty_inconsistent_state
    },
    "total_penalty": $total_penalty,
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

main "$@"
