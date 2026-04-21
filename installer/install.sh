#!/usr/bin/env bash
# Harness Engineering Workflow - Universal Installer
# Installs the workflow package for multiple coding agents.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source libraries
. "${SCRIPT_DIR}/lib/manifest.sh"
. "${SCRIPT_DIR}/lib/detect.sh"
. "${SCRIPT_DIR}/lib/state.sh"
. "${SCRIPT_DIR}/lib/render.sh"

# Global flags
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
TARGETS_REQUESTED=""
INSTALL_ALL="false"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_header() {
    echo ""
    echo -e "${BLUE}=== Harness Engineering Workflow Installer ===${NC}"
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

# Show usage
show_usage() {
    cat << 'EOF'
Usage: install.sh [OPTIONS]

Options:
    --all                  Install for all detected coding agents
    --target TARGET        Install for a specific target (claude-code, codex, copilot-cli, opencode, forgecode, fallback)
    --dry-run              Show what would be installed without making changes
    --verbose              Show detailed output
    --help                 Show this help message

Examples:
    install.sh --all                    # Install for all detected agents
    install.sh --target claude-code    # Install only for Claude Code
    install.sh --target claude-code --target codex  # Install for multiple targets
    install.sh --dry-run --all          # Preview installation

Supported Targets:
    claude-code    - Claude Code (full mode)
    codex          - OpenAI Codex (adapted mode)
    copilot-cli    - GitHub Copilot CLI (adapted mode)
    opencode       - Sourcegraph OpenCode (fallback mode)
    forgecode      - ForgeCode (fallback mode)
    fallback       - Generic fallback for unknown agents
EOF
}

# Parse command line arguments
parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --all)
                INSTALL_ALL="true"
                shift
                ;;
            --target)
                TARGETS_REQUESTED="${TARGETS_REQUESTED} $2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            --verbose)
                VERBOSE="true"
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

    # Trim whitespace from TARGETS_REQUESTED
    TARGETS_REQUESTED=$(echo "$TARGETS_REQUESTED" | xargs)
}

# Load an adapter
load_adapter() {
    local target_id="$1"
    local adapter_file="${SCRIPT_DIR}/targets/${target_id}.sh"

    if [ ! -f "$adapter_file" ]; then
        # Try fallback adapter for unknown targets
        if [ "$target_id" != "fallback" ]; then
            warn "Adapter not found for '$target_id', using fallback"
            adapter_file="${SCRIPT_DIR}/targets/fallback.sh"
        else
            print_error "Fallback adapter not found"
            return 1
        fi
    fi

    . "$adapter_file"
}

# Install for a single target
install_target() {
    local target_id="$1"

    echo ""
    print_info "Processing target: $target_id"

    # Load the adapter
    load_adapter "$target_id" || return 1

    # Check if target is detected (unless using fallback)
    if [ "$target_id" != "fallback" ]; then
        local detected=$(detect_target "$target_id")
        if [ "$detected" != "detected" ]; then
            print_warning "$target_id not detected on this system, skipping"
            return 0
        fi
    fi

    # Get installation details
    local install_dir=$(get_install_dir)
    local mode="${CAPABILITY_MODE:-adapted}"
    local name="${TARGET_NAME:-Unknown}"
    local target_assets=$(get_install_files)

    echo ""
    echo "  Target: $name"
    echo "  Mode: $mode"
    echo "  Install dir: $install_dir"

    # Run pre-install hook
    pre_install "$install_dir" || {
        print_error "Pre-install hook failed for $target_id"
        return 1
    }

    # Collect paths for state recording
    local installed_paths=""

    # Install each asset
    echo ""
    echo "  Installing assets..."

    for asset in $target_assets; do
        # Skip empty lines and comments
        [ -z "$asset" ] && continue
        [[ "$asset" =~ ^# ]] && continue

        install_asset "$REPO_ROOT" "$asset" "$install_dir" || {
            print_warning "Failed to install: $asset"
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
        print_error "Post-install hook failed for $target_id"
        return 1
    }

    # Record installation in state
    local install_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local version="${PACKAGE_VERSION:-0.1.0}"

    if [ -z "$installed_paths" ]; then
        installed_paths="[]"
    else
        installed_paths="[${installed_paths}]"
    fi

    if [ "$DRY_RUN" != "true" ]; then
        record_target_install "$target_id" "$mode" "$version" "$install_time" "$installed_paths"
    fi

    print_success "Installed $target_id successfully"

    return 0
}

# Main installation process
main() {
    print_header

    # Parse arguments
    parse_args "$@"

    # Validate we have targets to install
    if [ -z "$TARGETS_REQUESTED" ] && [ "$INSTALL_ALL" != "true" ]; then
        print_error "No targets specified. Use --all or --target <target>"
        show_usage
        exit 1
    fi

    # Show capability matrix
    print_capability_matrix

    # Determine targets to install
    local targets_to_install=""

    if [ "$INSTALL_ALL" = "true" ]; then
        # Install for all detected targets
        targets_to_install=$(detect_all_targets | grep "|detected$" | cut -d'|' -f1 | tr '\n' ' ')

        if [ -z "$targets_to_install" ]; then
            print_warning "No coding agents detected on this system"
            echo ""
            echo "You can still install in fallback mode:"
            echo "  install.sh --target fallback"
            exit 0
        fi

        print_info "Will install for detected targets: $targets_to_install"
    else
        targets_to_install="$TARGETS_REQUESTED"
    fi

    # Show dry-run banner if applicable
    if [ "$DRY_RUN" = "true" ]; then
        echo ""
        print_warning "DRY-RUN MODE - No changes will be made"
        echo ""
    fi

    # Install each target
    local failed_targets=""

    for target in $targets_to_install; do
        install_target "$target" || {
            failed_targets="${failed_targets} ${target}"
        }
    done

    # Summary
    echo ""
    echo "=== Installation Summary ==="
    echo ""

    if [ -n "$failed_targets" ]; then
        print_warning "Some targets failed to install:${failed_targets}"
        exit 1
    fi

    if [ "$DRY_RUN" = "true" ]; then
        print_success "Dry-run complete. Run without --dry-run to install."
    else
        print_success "Installation complete!"
        echo ""
        echo "Run 'installer/status.sh' to see installed targets."
        echo "Run 'installer/doctor.sh' to verify the installation."
        echo ""
    fi
}

# Run main
main "$@"
