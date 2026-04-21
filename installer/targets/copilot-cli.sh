# GitHub Copilot CLI adapter for Harness Engineering Workflow installer.
# Installs the workflow using Copilot CLI conventions.

TARGET_ID="copilot-cli"
TARGET_NAME="GitHub Copilot CLI"
CAPABILITY_MODE="adapted"

# Copilot CLI configuration directory
# Standard locations: ~/.config/copilot or project-local .copilot/
get_config_dir() {
    local user_config="${HOME}/.config/copilot"
    local xdg_config="${XDG_CONFIG_HOME:-${HOME}/.config}/copilot"

    if [ -d "$xdg_config" ]; then
        echo "$xdg_config"
    else
        echo "$user_config"
    fi
}

# Get the target-specific installation directory
get_install_dir() {
    echo "$(get_config_dir)/harness-workflow"
}

# Check if this adapter can install (dependencies met)
check_dependencies() {
    return 0  # No special dependencies
}

# Get the list of files to install
get_install_files() {
    cat << 'FILES'
templates/
schemas/
AGENTS.md
README.md
FILES
}

# Pre-install hook (called before installation)
pre_install() {
    local install_dir="$1"
    log "Preparing Copilot CLI workflow installation at: $install_dir"
    log "Note: Copilot CLI uses adapted mode - templates and schemas are installed"
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
    log "Copilot CLI workflow installed successfully in adapted mode"
    log ""
    log "Usage with Copilot CLI:"
    log "  1. Reference the AGENTS.md file for workflow conventions"
    log "  2. Use templates from the templates/ directory"
    log "  3. Schemas in schemas/ validate machine-readable state"
    log "  4. gh copilot will pick up these conventions in your projects"
    return 0
}

# Get files that would be installed (for preview)
get_install_preview() {
    local assets_root="$1"
    echo "  templates/ (adapted mode)"
    echo "  schemas/ (adapted mode)"
    echo "  AGENTS.md (adapted mode)"
    echo "  README.md (adapted mode)"
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

    # Check templates directory
    if [ -d "${install_dir}/templates" ]; then
        log "✓ Templates directory present"
    else
        error "Templates directory not found"
        errors=$((errors + 1))
    fi

    # Check schemas directory
    if [ -d "${install_dir}/schemas" ]; then
        log "✓ Schemas directory present"
    else
        error "Schemas directory not found"
        errors=$((errors + 1))
    fi

    # Check AGENTS.md
    if [ -f "${install_dir}/AGENTS.md" ]; then
        log "✓ AGENTS.md present"
    else
        error "AGENTS.md not found"
        errors=$((errors + 1))
    fi

    return $errors
}

# Get paths that this adapter manages
get_managed_paths() {
    local install_dir="$1"
    echo "${install_dir}"
}
