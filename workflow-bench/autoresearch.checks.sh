#!/bin/bash
# Autoresearch checks script - validates workflow integrity
# Runs after every successful benchmark to ensure correctness

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$SCRIPT_DIR"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Running Autoresearch Checks ==="
echo ""

# Track failures
FAILURES=0

# Check 1: Validate workflow artifacts in the repo
echo "--- Check: Workflow Artifact Validation ---"
if "$SCRIPT_DIR/scripts/validate-workflow-artifacts.sh" 2>/dev/null; then
    echo "PASS: Workflow artifacts valid"
else
    echo "FAIL: Workflow artifact validation failed"
    FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 2: Verify skill sync between repo and .config/opencode/skills
echo "--- Check: Skill Synchronization ---"
if "$SCRIPT_DIR/scripts/sync-opencode-skills.sh" validate 2>/dev/null; then
    echo "PASS: Skills are synchronized"
else
    echo "WARN: Skills need synchronization (will sync on next benchmark run)"
    # Don't fail checks for this - it's a soft requirement
fi
echo ""

# Check 3: Verify schemas are valid JSON
echo "--- Check: Schema Validation ---"
SCHEMAS_VALID=true
for schema in "$REPO_ROOT/schemas"/*.json; do
    if [[ -f "$schema" ]]; then
        if python3 -c "import json; json.load(open('$schema'))" 2>/dev/null; then
            echo "PASS: $(basename "$schema")"
        else
            echo "FAIL: Invalid JSON in $(basename "$schema")"
            SCHEMAS_VALID=false
            FAILURES=$((FAILURES + 1))
        fi
    fi
done

if ! $SCHEMAS_VALID; then
    echo "FAIL: One or more schemas are invalid"
fi
echo ""

# Check 4: Verify benchmark infrastructure
echo "--- Check: Benchmark Infrastructure ---"
if [[ -d "$SCRIPT_DIR/scenarios" ]] && [[ -d "$SCRIPT_DIR/evaluators" ]]; then
    echo "PASS: Benchmark directories exist"
else
    echo "FAIL: Benchmark infrastructure incomplete"
    FAILURES=$((FAILURES + 1))
fi

# Check for all required scripts
REQUIRED_SCRIPTS=(
    "run-scenario.sh"
    "run-all-scenarios.sh"
    "sync-opencode-skills.sh"
    "validate-workflow-artifacts.sh"
    "collect-session-data.sh"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [[ -x "$SCRIPT_DIR/scripts/$script" ]]; then
        echo "PASS: $script exists and is executable"
    else
        echo "FAIL: $script missing or not executable"
        FAILURES=$((FAILURES + 1))
    fi
done

# Check evaluator
if [[ -x "$SCRIPT_DIR/evaluators/score-run.sh" ]]; then
    echo "PASS: score-run.sh exists and is executable"
else
    echo "FAIL: score-run.sh missing or not executable"
    FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 5: Verify skill files exist
echo "--- Check: Required Skill Files ---"
REQUIRED_SKILLS=(
    "harness-engineering-workflow"
    "harness-planning"
    "harness-evals"
    "harness-execution"
    "harness-review"
)

for skill in "${REQUIRED_SKILLS[@]}"; do
    if [[ -f "$REPO_ROOT/skills/$skill/SKILL.md" ]]; then
        echo "PASS: $skill/SKILL.md exists"
    else
        echo "FAIL: $skill/SKILL.md missing"
        FAILURES=$((FAILURES + 1))
    fi
done
echo ""

# Summary
echo "=== Check Summary ==="
if [[ "$FAILURES" -eq 0 ]]; then
    echo "PASS: All checks passed"
    exit 0
else
    echo "FAIL: $FAILURES check(s) failed"
    exit 1
fi
