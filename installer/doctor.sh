#!/usr/bin/env bash
# Harness Engineering Workflow - Doctor command
# Verifies the installation status of all installed targets.

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

print_header() {
    echo ""
    echo -e "${BLUE}=== Harness Engineering Workflow - Doctor ===${NC}"
    echo ""
}

print_ok() {
    echo -e "${GREEN}[OK]${NC} $*"
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $*" >&2
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
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

# Verify a single target installation
verify_target() {
    local target_id="$1"
    local errors=0

    echo ""
    echo "Checking: $target_id"

    # Check if target is installed
    if ! is_target_installed "$target_id"; then
        print_warn "Target '$target_id' is not installed"
        return 1
    fi

    # Load the adapter
    load_adapter "$target_id" || return 1

    local mode=$(get_installed_mode "$target_id")
    local install_dir=$(get_install_dir)

    echo "  Mode: $mode"
    echo "  Install dir: $install_dir"

    # Check if install directory exists
    if [ ! -d "$install_dir" ]; then
        print_fail "Installation directory missing: $install_dir"
        return 1
    fi

    # Run adapter verification
    if verify_install "$install_dir"; then
        print_ok "$target_id verification passed"
    else
        print_fail "$target_id verification failed"
        errors=$((errors + 1))
    fi

    return $errors
}

# Check state file
check_state_file() {
    echo ""
    echo "=== State File ==="

    if [ ! -f "${INSTALL_STATE_FILE}" ]; then
        print_warn "State file not found: ${INSTALL_STATE_FILE}"
        echo "Run 'installer/install.sh --all' to install targets first."
        return 1
    fi

    print_ok "State file exists: ${INSTALL_STATE_FILE}"

    # Validate JSON
    if command -v python3 &>/dev/null; then
        if python3 -c "import json; json.load(open('${INSTALL_STATE_FILE}'))" 2>/dev/null; then
            print_ok "State file is valid JSON"
        else
            print_fail "State file is not valid JSON"
            return 1
        fi
    else
        print_warn "Cannot validate JSON (python3 not available)"
    fi

    return 0
}

# Main doctor function
main() {
    print_header

    local total_errors=0

    # Check state file
    check_state_file || total_errors=$((total_errors + 1))

    # List installed targets
    echo ""
    echo "=== Installed Targets ==="

    local installed_targets=$(get_installed_targets)

    if [ -z "$installed_targets" ]; then
        print_warn "No targets are currently installed"
        echo ""
        echo "Run 'installer/install.sh --all' to install."
        total_errors=$((total_errors + 1))
    else
        echo "Found $# installed targets:"
        echo ""

        for target in $installed_targets; do
            verify_target "$target" || total_errors=$((total_errors + 1))
        done
    fi

    # Summary
    echo ""
    echo "=== Doctor Summary ==="

    if [ $total_errors -eq 0 ]; then
        print_ok "All checks passed!"
        echo ""
        exit 0
    else
        print_fail "$total_errors check(s) failed"
        echo ""
        echo "Run 'installer/update.sh' to repair or 'installer/uninstall.sh' to remove."
        exit 1
    fi
}

main "$@"
