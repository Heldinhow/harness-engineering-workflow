# Claude Code adapter for Harness Engineering Workflow installer.
# Installs the workflow as a native Claude Code skill package.

TARGET_ID="claude-code"
TARGET_NAME="Claude Code"
CAPABILITY_MODE="full"

# Claude Code skills directory
# Standard locations: ~/.claude/skills or project-local .claude/skills
get_skills_dir() {
    local user_skills="${HOME}/.claude/skills"
    local project_skills=".claude/skills"

    # Prefer user-level skills if no project-specific skills exist
    if [ -d "$user_skills" ]; then
        echo "$user_skills"
    else
        echo "$user_skills"
    fi
}

# Get the target-specific installation directory
get_install_dir() {
    echo "$(get_skills_dir)/harness-engineering-workflow"
}

# Check if this adapter can install (dependencies met)
check_dependencies() {
    return 0  # No special dependencies
}

# Get the list of files to install
get_install_files() {
    local assets_root="$1"
    cat << 'FILES'
skills/
AGENTS.md
README.md
FILES
}

# Pre-install hook (called before installation)
pre_install() {
    local install_dir="$1"
    log "Preparing Claude Code skill installation at: $install_dir"
    return 0
}

# Install a single asset
install_asset() {
    local src_root="$1"
    local asset="$2"
    local install_dir="$3"

    local src_path="${src_root}/${asset}"
    local dest_path="${install_dir}/${asset}"

    # Skip if source doesn't exist
    if [ ! -e "$src_path" ]; then
        warn "Skipping non-existent asset: $asset"
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
    log "Claude Code skill installed successfully"
    log ""
    log "Usage in Claude Code:"
    log "  1. Claude Code will automatically discover the skill"
    log "  2. Start a new conversation or use /skill invoke harness-engineering-workflow"
    log "  3. The skill will guide you through the workflow phases"
    return 0
}

# Get files that would be installed (for preview)
get_install_preview() {
    local assets_root="$1"
    echo "  skills/harness-engineering-workflow/"
    echo "  AGENTS.md"
    echo "  README.md"
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
    if [ ! -d "$install_dir" ]; then
        error "Skill directory not found: $install_dir"
        errors=$((errors + 1))
    fi

    # Check skills directory
    if [ -d "${install_dir}/skills" ]; then
        log "✓ Skills directory present"
    else
        warn "Skills directory not found (optional)"
    fi

    # Check AGENTS.md
    if [ -f "${install_dir}/AGENTS.md" ]; then
        log "✓ AGENTS.md present"
    else
        error "AGENTS.md not found"
        errors=$((errors + 1))
    fi

    # Check README.md
    if [ -f "${install_dir}/README.md" ]; then
        log "✓ README.md present"
    else
        warn "README.md not found (optional)"
    fi

    return $errors
}

# Get paths that this adapter manages
get_managed_paths() {
    local install_dir="$1"
    echo "${install_dir}"
}
