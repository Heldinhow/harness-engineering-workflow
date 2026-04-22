# OpenCode adapter for Harness Engineering Workflow installer.
# Installs skills to ~/.config/opencode/skills/ and docs/templates/schemas
# to ~/.config/opencode/harness-workflow/.

TARGET_ID="opencode"
TARGET_NAME="Sourcegraph OpenCode"
CAPABILITY_MODE="fallback"

OPENCODE_SKILLS_DIR="${HOME}/.config/opencode/skills"
OPENCODE_WORKFLOW_DIR="${HOME}/.config/opencode/harness-workflow"

get_install_dir() {
    echo "$OPENCODE_WORKFLOW_DIR"
}

get_skills_install_dir() {
    echo "$OPENCODE_SKILLS_DIR"
}

check_dependencies() {
    return 0
}

get_install_files() {
    cat << 'FILES'
docs/
templates/
schemas/
AGENTS.md
README.md
FILES
}

get_skills_files() {
    cat << 'SKILLS'
skills/harness-engineering-workflow/
skills/harness-planning/
skills/harness-execution/
skills/harness-evals/
SKILLS
}

pre_install() {
    local install_dir="$1"
    log "Preparing OpenCode workflow installation"
    log "  Skills: ${OPENCODE_SKILLS_DIR}/"
    log "  Docs/Templates: ${OPENCODE_WORKFLOW_DIR}/"
    return 0
}

install_asset() {
    local src_root="$1"
    local asset="$2"
    local install_dir="$3"

    local src_path="${src_root}/${asset}"
    local dest_path="${install_dir}/${asset}"

    if [ ! -e "$src_path" ]; then
        warn "Skipping non-existent asset: $asset"
        return 0
    fi

    if [ -d "$src_path" ]; then
        copy_dir "$src_path" "${install_dir}/${asset}"
    else
        copy_file "$src_path" "$dest_path" "644"
    fi
}

install_skills() {
    local src_root="$1"
    local skills_src="${src_root}/skills"
    local skills_dest="$(get_skills_install_dir)"

    mkdir -p "$skills_dest"

    for skill_dir in harness-engineering-workflow harness-planning harness-execution harness-evals; do
        local src_skill="${skills_src}/${skill_dir}"
        local dest_skill="${skills_dest}/${skill_dir}"

        if [ -d "$src_skill" ]; then
            log "Installing skill: $skill_dir"
            copy_dir "$src_skill" "$dest_skill"
        else
            warn "Skill not found: $skill_dir"
        fi
    done
}

post_install() {
    local install_dir="$1"
    install_skills "$REPO_ROOT"
    log "OpenCode workflow installed successfully"
    log ""
    log "Skills installed to:"
    log "  ${OPENCODE_SKILLS_DIR}/"
    log ""
    log "Docs/templates/schemas installed to:"
    log "  ${OPENCODE_WORKFLOW_DIR}/"
    log ""
    log "Usage in OpenCode:"
    log "  1. Reference ${OPENCODE_WORKFLOW_DIR}/AGENTS.md for workflow index"
    log "  2. Use skills: harness-engineering-workflow, harness-planning, etc."
    log "  3. Use docs/ for detailed phase, role, and standard references"
    log "  4. Copy AGENTS.md to your project as .agents.md for local workflow"
    return 0
}

get_install_preview() {
    local assets_root="$1"
    echo "  docs/ (workflow, roles, standards)"
    echo "  templates/ (artifact templates)"
    echo "  schemas/ (JSON schemas)"
    echo "  AGENTS.md"
    echo "  README.md"
    echo "  skills/harness-engineering-workflow/"
    echo "  skills/harness-planning/"
    echo "  skills/harness-execution/"
    echo "  skills/harness-evals/"
}

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

uninstall_skills() {
    local skills_dest="$(get_skills_install_dir)"

    for skill_dir in harness-engineering-workflow harness-planning harness-execution harness-evals; do
        local path="${skills_dest}/${skill_dir}"
        if [ -d "$path" ]; then
            remove_dir "$path"
        fi
    done
}

verify_install() {
    local install_dir="$1"
    local errors=0
    local skills_dest="$(get_skills_install_dir)"

    if [ ! -d "$install_dir" ]; then
        error "Installation directory not found: $install_dir"
        errors=$((errors + 1))
    fi

    if [ -f "${install_dir}/AGENTS.md" ]; then
        log "✓ AGENTS.md present"
    else
        error "AGENTS.md not found"
        errors=$((errors + 1))
    fi

    if [ -d "${install_dir}/docs" ]; then
        log "✓ docs/ present"
    else
        warn "docs/ not found (optional)"
    fi

    if [ -d "${install_dir}/templates" ]; then
        log "✓ templates/ present"
    else
        warn "templates/ not found (optional)"
    fi

    if [ -d "${skills_dest}/harness-engineering-workflow" ]; then
        log "✓ skill: harness-engineering-workflow present"
    else
        warn "skill harness-engineering-workflow not found"
    fi

    return $errors
}

get_managed_paths() {
    local install_dir="$1"
    echo "${install_dir}"
    echo "$(get_skills_install_dir)/harness-engineering-workflow"
    echo "$(get_skills_install_dir)/harness-planning"
    echo "$(get_skills_install_dir)/harness-execution"
    echo "$(get_skills_install_dir)/harness-evals"
}
