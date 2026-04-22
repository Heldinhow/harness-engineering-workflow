#!/bin/bash
# Sync workflow skills to .config/opencode/skills for OpenCode benchmarking
# This ensures OpenCode runs against the current workflow, not stale skill files

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
OPENCODE_CONFIG="$REPO_ROOT/.config/opencode"
TARGET_SKILLS_DIR="$OPENCODE_CONFIG/skills"

# Validate source skills exist
validate_source_skills() {
    local required_skills=(
        "harness-engineering-workflow"
        "harness-planning"
        "harness-evals"
        "harness-execution"
        "harness-review"
    )
    
    for skill in "${required_skills[@]}"; do
        local skill_path="$SKILLS_DIR/$skill/SKILL.md"
        if [[ ! -f "$skill_path" ]]; then
            echo "ERROR: Required skill not found: $skill_path" >&2
            return 1
        fi
    done
}

# Create .config/opencode directory structure
setup_opencode_config() {
    mkdir -p "$TARGET_SKILLS_DIR"
    
    # Create main config if it doesn't exist
    if [[ ! -f "$OPENCODE_CONFIG/config.json" ]]; then
        cat > "$OPENCODE_CONFIG/config.json" << 'EOF'
{
  "version": "1.0",
  "workflow": "harness-engineering-workflow",
  "required_skills": [
    "harness-engineering-workflow",
    "harness-planning",
    "harness-evals",
    "harness-execution",
    "harness-review"
  ],
  "local_only": true
}
EOF
    fi
}

# Sync individual skill
sync_skill() {
    local skill_name="$1"
    local source="$SKILLS_DIR/$skill_name/SKILL.md"
    local target="$TARGET_SKILLS_DIR/${skill_name}.md"
    
    if [[ ! -f "$source" ]]; then
        echo "WARNING: Skill source not found: $source" >&2
        return 1
    fi
    
    cp "$source" "$target"
    echo "SYNCED: $skill_name -> $target"
}

# Sync all workflow skills
sync_all_skills() {
    echo "=== Syncing workflow skills to .config/opencode/skills ==="
    echo "Source: $SKILLS_DIR"
    echo "Target: $TARGET_SKILLS_DIR"
    echo ""
    
    validate_source_skills
    
    setup_opencode_config
    
    # Sync required workflow skills
    sync_skill "harness-engineering-workflow"
    sync_skill "harness-planning"
    sync_skill "harness-evals"
    sync_skill "harness-execution"
    sync_skill "harness-review"
    
    echo ""
    echo "=== Skill sync complete ==="
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "Skills synced: 5"
}

# Compare source and target to detect divergence
detect_divergence() {
    local has_divergence=false
    
    for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
        local skill_name="$(basename "$(dirname "$skill_md")")"
        local target="$TARGET_SKILLS_DIR/${skill_name}.md"
        
        if [[ ! -f "$target" ]]; then
            echo "DIVERGENCE: $skill_name.md missing in target"
            has_divergence=true
        elif ! diff -q "$skill_md" "$target" > /dev/null 2>&1; then
            echo "DIVERGENCE: $skill_name.md differs"
            has_divergence=true
        fi
    done
    
    if $has_divergence; then
        return 1
    fi
    return 0
}

# Main command router
case "${1:-sync}" in
    sync)
        sync_all_skills
        ;;
    validate)
        echo "=== Validating skill synchronization ==="
        if detect_divergence; then
            echo "PASS: Skills are in sync"
            exit 0
        else
            echo "FAIL: Skills have diverged - run sync to update"
            exit 1
        fi
        ;;
    check)
        # Quick check used by benchmark runs
        detect_divergence
        ;;
    *)
        echo "Usage: $0 {sync|validate|check}"
        exit 1
        ;;
esac
