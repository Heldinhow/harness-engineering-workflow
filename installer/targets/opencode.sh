# OpenCode adapter for Harness Engineering Workflow installer.
# Installs the workflow as an OpenCode native skill.

TARGET_ID="opencode"
TARGET_NAME="Sourcegraph OpenCode"
CAPABILITY_MODE="fallback"

# OpenCode skills directory
# Standard location: ~/.config/opencode/skills/
get_skills_dir() {
    echo "${HOME}/.config/opencode/skills"
}

# Get the target-specific installation directory
get_install_dir() {
    echo "$(get_skills_dir)"
}

# Check if this adapter can install (dependencies met)
check_dependencies() {
    return 0
}

# Get the list of files to install
get_install_files() {
    cat << 'FILES'
harness-engineering-workflow/SKILL.md
templates/
AGENTS.md
README.md
FILES
}

# Pre-install hook (called before installation)
pre_install() {
    local install_dir="$1"
    log "Preparing OpenCode skill installation at: $install_dir"
    log "Note: OpenCode uses the native skill system"
    return 0
}

# Install a single asset
install_asset() {
    local src_root="$1"
    local asset="$2"
    local install_dir="$3"

    # Map asset paths to source paths for special cases
    local src_path="${src_root}/${asset}"

    # The skill SKILL.md is in skills/harness-engineering-workflow/ in the repo
    # but should be installed directly to harness-engineering-workflow/SKILL.md
    if [ "$asset" = "harness-engineering-workflow/SKILL.md" ]; then
        src_path="${src_root}/skills/${asset}"
    fi

    local dest_path="${install_dir}/${asset}"

    # Skip if source doesn't exist
    if [ ! -e "$src_path" ]; then
        warn "Skipping non-existent asset: $asset (looked in $src_path)"
        return 0
    fi

    # Handle directories
    if [ -d "$src_path" ]; then
        copy_dir "$src_path" "${install_dir}/${asset}"
        return 0
    fi

    # Handle files
    copy_file "$src_path" "$dest_path" "644"
}

# Post-install hook (called after installation)
post_install() {
    local install_dir="$1"
    log "OpenCode skill installed successfully"
    log ""
    log "Usage in OpenCode:"
    log "  1. OpenCode will automatically discover the skill"
    log "  2. Use /skill invoke harness-engineering-workflow or let the agent discover it"
    log "  3. The skill will guide you through the workflow phases"
    return 0
}

# Get files that would be installed (for preview)
get_install_preview() {
    local assets_root="$1"
    echo "  harness-engineering-workflow/SKILL.md (native skill)"
    echo "  templates/ (workflow templates)"
    echo "  AGENTS.md (reference)"
    echo "  README.md (documentation)"
}

# Uninstall a single asset
uninstall_asset() {
    local asset="$1"
    local install_dir="$2"

    local path="${install_dir}/${asset}"

    if [ -d "$path" ]; then
        remove_dir "$path"
    elif [ -f "$path" ]; then
        remove_file "$path"
    fi
}

# Verify installation
verify_install() {
    local install_dir="$1"
    local errors=0

    # Check main skill directory exists
    if [ ! -d "${install_dir}/harness-engineering-workflow" ]; then
        error "Skill directory not found: ${install_dir}/harness-engineering-workflow"
        errors=$((errors + 1))
    fi

    # Check SKILL.md
    if [ -f "${install_dir}/harness-engineering-workflow/SKILL.md" ]; then
        log "✓ SKILL.md present"
    else
        error "SKILL.md not found"
        errors=$((errors + 1))
    fi

    # Check templates directory
    if [ -d "${install_dir}/templates" ]; then
        log "✓ Templates directory present"
    else
        warn "Templates directory not found (optional)"
    fi

    return $errors
}

# Get paths that this adapter manages
get_managed_paths() {
    local install_dir="$1"
    echo "${install_dir}"
}