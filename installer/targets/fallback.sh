# Generic fallback adapter for Harness Engineering Workflow installer.
# Used for targets that don't have native skill support.

TARGET_ID="fallback"
TARGET_NAME="Generic / Unknown Agent"
CAPABILITY_MODE="fallback"

# Fallback installation directory
get_install_dir() {
    local config_dir="${HOME}/.config/harness-workflow/fallback"
    echo "$config_dir"
}

# Check if this adapter can install (dependencies met)
check_dependencies() {
    return 0  # No special dependencies
}

# Get the list of files to install
get_install_files() {
    cat << 'FILES'
AGENTS.md
templates/
FILES
}

# Pre-install hook (called before installation)
pre_install() {
    local install_dir="$1"
    log "Preparing fallback workflow installation at: $install_dir"
    log "Note: Using fallback mode - only essential files are installed"
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
    log "Fallback workflow installed successfully"
    log ""
    log "Usage (any agent):"
    log "  1. Reference ${install_dir}/AGENTS.md for workflow conventions"
    log "  2. Use templates from ${install_dir}/templates/"
    log "  3. Copy AGENTS.md to your project root as .agents.md or reference it in your agent config"
    return 0
}

# Get files that would be installed (for preview)
get_install_preview() {
    local assets_root="$1"
    echo "  AGENTS.md (fallback mode - essential)"
    echo "  templates/ (fallback mode - essential)"
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

    # Check main installation directory exists
    if [ ! -d "$install_dir" ]; then
        error "Installation directory not found: $install_dir"
        errors=$((errors + 1))
    fi

    # Check AGENTS.md (essential in fallback mode)
    if [ -f "${install_dir}/AGENTS.md" ]; then
        log "✓ AGENTS.md present"
    else
        error "AGENTS.md not found (required in fallback mode)"
        errors=$((errors + 1))
    fi

    # Check templates directory
    if [ -d "${install_dir}/templates" ]; then
        log "✓ Templates directory present"
    else
        warn "Templates directory not found (optional in fallback mode)"
    fi

    return $errors
}

# Get paths that this adapter manages
get_managed_paths() {
    local install_dir="$1"
    echo "${install_dir}"
}
