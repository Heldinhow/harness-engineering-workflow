#!/usr/bin/env bash
# Harness Engineering Workflow - Update command
# Reapplies adapters for installed targets without overwriting user customizations.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source libraries
. "${SCRIPT_DIR}/lib/manifest.sh"
. "${SCRIPT_DIR}/lib/detect.sh"
. "${SCRIPT_DIR}/lib/state.sh"
. "${SCRIPT_DIR}/lib/render.sh"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DRY_RUN="${DRY_RUN:-false}"

print_header() {
    echo ""
    echo -e "${BLUE}=== Harness Engineering Workflow - Update ===${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

show_usage() {
    cat << 'EOF'
Usage: update.sh [OPTIONS]

Options:
    --all                  Update all installed targets
    --target TARGET        Update a specific target
    --dry-run              Show what would be updated without making changes
    --help                 Show this help message

Examples:
    update.sh --all                  # Update all installed targets
    update.sh --target claude-code   # Update only Claude Code
EOF
}

# Load an adapter
load_adapter() {
    local target_id="$1"
    local adapter_file="${SCRIPT_DIR}/targets/${target_id}.sh"

    if [ ! -f "$adapter_file" ]; then
        adapter_file="${SCRIPT_DIR}/targets/fallback.sh"
    fi

    . "$adapter_file"
}

# Update a single target
update_target() {
    local target_id="$1"

    echo ""
    print_info "Updating target: $target_id"

    # Check if target is installed
    if ! is_target_installed "$target_id"; then
        print_warning "Target '$target_id' is not installed"
        echo "  Run 'installer/install.sh --target $target_id' to install it first."
        return 1
    fi

    # Load the adapter
    load_adapter "$target_id" || return 1

    local install_dir=$(get_install_dir)
    local mode="${CAPABILITY_MODE:-adapted}"
    local name="${TARGET_NAME:-Unknown}"
    local target_assets=$(get_install_files)

    echo "  Mode: $mode"
    echo "  Install dir: $install_dir"

    # Run pre-install hook (reuse for update)
    pre_install "$install_dir" || {
        print_error "Pre-update hook failed for $target_id"
        return 1
    }

    # Collect paths for state recording
    local installed_paths=""

    # Re-install each asset (preserves existing user files, updates package files)
    echo ""
    echo "  Updating assets..."

    for asset in $target_assets; do
        # Skip empty lines and comments
        [ -z "$asset" ] && continue
        [[ "$asset" =~ ^# ]] && continue

        install_asset "$REPO_ROOT" "$asset" "$install_dir" || {
            print_warning "Failed to update: $asset"
        }

        # Track installed path
        if [ -n "$installed_paths" ]; then
            installed_paths="${installed_paths} \"${install_dir}/${asset}\""
        else
            installed_paths="\"${install_dir}/${asset}\""
        fi
    done

    # Run post-install hook
    post_install "$install_dir" || {
        print_error "Post-update hook failed for $target_id"
        return 1
    }

    print_success "Updated $target_id successfully"

    return 0
}

# Parse arguments
parse_args() {
    local targets=""
    local update_all="false"

    while [ $# -gt 0 ]; do
        case "$1" in
            --all)
                update_all="true"
                shift
                ;;
            --target)
                targets="${targets} $2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    echo "$update_all|$targets"
}

main() {
    print_header

    # Parse arguments
    local args=$(parse_args "$@")
    local update_all=$(echo "$args" | cut -d'|' -f1)
    local targets=$(echo "$args" | cut -d'|' -f2 | xargs)

    # Determine targets to update
    if [ "$update_all" = "true" ]; then
        targets=$(get_installed_targets)

        if [ -z "$targets" ]; then
            print_warning "No targets are installed"
            exit 0
        fi

        print_info "Will update all installed targets: $targets"
    else
        if [ -z "$targets" ]; then
            print_error "No targets specified. Use --all or --target <target>"
            show_usage
            exit 1
        fi
    fi

    # Show dry-run banner
    if [ "$DRY_RUN" = "true" ]; then
        echo ""
        print_warning "DRY-RUN MODE - No changes will be made"
        echo ""
    fi

    # Update each target
    local failed=""

    for target in $targets; do
        update_target "$target" || {
            failed="${failed} ${target}"
        }
    done

    # Summary
    echo ""
    echo "=== Update Summary ==="
    echo ""

    if [ -n "$failed" ]; then
        print_warning "Some targets failed to update:${failed}"
        exit 1
    fi

    if [ "$DRY_RUN" = "true" ]; then
        print_success "Dry-run complete. Run without --dry-run to update."
    else
        print_success "Update complete!"
        echo ""
        echo "Run 'installer/doctor.sh' to verify the updated installations."
    fi
}

main "$@"
