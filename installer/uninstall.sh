#!/usr/bin/env bash
# Harness Engineering Workflow - Uninstall command
# Removes installed workflow assets for specified or all targets.

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
    echo -e "${BLUE}=== Harness Engineering Workflow - Uninstall ===${NC}"
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
Usage: uninstall.sh [OPTIONS]

Options:
    --all                  Uninstall all installed targets
    --target TARGET        Uninstall a specific target
    --dry-run              Show what would be removed without making changes
    --help                 Show this help message

Examples:
    uninstall.sh --all                 # Uninstall all targets
    uninstall.sh --target claude-code # Uninstall only Claude Code
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

# Uninstall a single target
uninstall_target() {
    local target_id="$1"

    echo ""
    print_info "Uninstalling target: $target_id"

    # Check if target is installed
    if ! is_target_installed "$target_id"; then
        print_warning "Target '$target_id' is not installed, skipping"
        return 0
    fi

    # Load the adapter
    load_adapter "$target_id" || return 1

    local install_dir=$(get_install_dir)

    echo "  Install dir: $install_dir"

    # Remove installation directory
    if [ -d "$install_dir" ]; then
        if [ "$DRY_RUN" = "true" ]; then
            echo "  [DRY-RUN] Would remove: $install_dir"
        else
            remove_dir "$install_dir"
            print_success "Removed: $install_dir"
        fi
    else
        print_warning "Installation directory not found: $install_dir"
    fi

    # Remove from state
    if [ "$DRY_RUN" != "true" ]; then
        remove_target_install "$target_id"
    fi

    print_success "Uninstalled $target_id successfully"

    return 0
}

# Parse arguments
parse_args() {
    local targets=""
    local uninstall_all="false"

    while [ $# -gt 0 ]; do
        case "$1" in
            --all)
                uninstall_all="true"
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

    echo "$uninstall_all|$targets"
}

main() {
    print_header

    # Parse arguments
    local args=$(parse_args "$@")
    local uninstall_all=$(echo "$args" | cut -d'|' -f1)
    local targets=$(echo "$args" | cut -d'|' -f2 | xargs)

    # Determine targets to uninstall
    if [ "$uninstall_all" = "true" ]; then
        targets=$(get_installed_targets)

        if [ -z "$targets" ]; then
            print_warning "No targets are installed"
            exit 0
        fi

        print_info "Will uninstall all installed targets: $targets"
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

    # Confirm if not dry-run
    if [ "$DRY_RUN" != "true" ]; then
        echo ""
        read -p "Are you sure you want to uninstall? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Uninstall cancelled"
            exit 0
        fi
    fi

    # Uninstall each target
    local failed=""

    for target in $targets; do
        uninstall_target "$target" || {
            failed="${failed} ${target}"
        }
    done

    # Summary
    echo ""
    echo "=== Uninstall Summary ==="
    echo ""

    if [ -n "$failed" ]; then
        print_warning "Some targets failed to uninstall:${failed}"
        exit 1
    fi

    if [ "$DRY_RUN" = "true" ]; then
        print_success "Dry-run complete. Run without --dry-run to uninstall."
    else
        print_success "Uninstall complete!"
    fi
}

main "$@"
