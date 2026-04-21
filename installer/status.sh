#!/usr/bin/env bash
# Harness Engineering Workflow - Status command
# Shows the current installation status for all targets.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source libraries
. "${SCRIPT_DIR}/lib/manifest.sh"
. "${SCRIPT_DIR}/lib/detect.sh"
. "${SCRIPT_DIR}/lib/state.sh"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}=== Harness Engineering Workflow - Status ===${NC}"
    echo ""
}

print_installed() {
    local tid="$1"
    local mode="$2"
    local version="$3"
    local time="$4"
    local detected="$5"

    local color_mode=""
    case "$mode" in
        full) color_mode="${GREEN}$mode${NC}" ;;
        adapted) color_mode="${YELLOW}$mode${NC}" ;;
        fallback) color_mode="${RED}$mode${NC}" ;;
        *) color_mode="$mode" ;;
    esac

    local name=$(get_target_name "$tid" 2>/dev/null || echo "$tid")

    local status=""
    if [ "$detected" = "yes" ]; then
        status="${GREEN}installed${NC}"
    else
        status="${YELLOW}installed (agent not detected)${NC}"
    fi

    printf "  %-15s | %-20s | %-10s | %-8s | %s\n" \
        "$tid" "$name" "$color_mode" "$version" "$status"
    echo "    Installed: $time"
}

main() {
    print_header

    # Check state file
    echo "Package: ${PACKAGE_NAME}"
    echo "Version: ${PACKAGE_VERSION}"
    echo "Config:  ${INSTALL_CONFIG_DIR}"
    echo "State:   ${INSTALL_STATE_FILE}"
    echo ""

    # Check if state file exists
    if [ ! -f "${INSTALL_STATE_FILE}" ]; then
        echo -e "${YELLOW}No installation found.${NC}"
        echo ""
        echo "Run 'installer/install.sh --all' or 'installer/install.sh --target <target>' to install."
        exit 0
    fi

    # Show installed targets
    echo "Installed Targets:"
    echo ""
    printf "  %-15s | %-20s | %-10s | %-8s | %s\n" \
        "TARGET" "NAME" "MODE" "VERSION" "STATUS"
    printf "  %-15s-+-%-20s-+-%-10s-+-%-8s-+-%s\n" \
        "---------------" "--------------------" "----------" "--------" "---------------"
    echo ""

    # Get installed targets from state
    local state=$(read_installed_state)
    local installations=$(echo "$state" | python3 -c "
import json
import sys

try:
    data = json.loads(sys.stdin.read())
    installations = data.get('installations', [])
    if installations:
        for inst in installations:
            detected = 'no'
            tid = inst.get('target_id', '')
            # Simple check if target detection works
            print(f\"{tid}|{inst.get('mode', '')}|{inst.get('version', '')}|{inst.get('installed_at', '')}|{detected}\")
    else:
        print('no_installations')
except Exception as e:
    print('error_reading_state')
" 2>/dev/null)

    if [ "$installations" = "no_installations" ] || [ "$installations" = "error_reading_state" ]; then
        echo -e "${YELLOW}No targets are currently installed.${NC}"
        echo ""
        echo "Run 'installer/install.sh --all' to install."
        exit 0
    fi

    echo "$installations" | while IFS='|' read -r tid mode version time detected; do
        print_installed "$tid" "$mode" "$version" "$time" "$detected"
    done

    echo ""

    # Show available but not installed targets
    echo "Available (not installed):"
    echo ""

    local available=""
    local all_targets="claude-code codex copilot-cli opencode forgecode"

    for target in $all_targets; do
        if ! is_target_installed "$target" 2>/dev/null; then
            local status=$(detect_target "$target")
            if [ "$status" = "detected" ]; then
                local name=$(get_target_name "$target")
                local mode=$(get_target_mode "$target")
                available="${available}  ${GREEN}$target${NC} - $name ($mode)"
            fi
        fi
    done

    if [ -z "$available" ]; then
        echo "  All available targets are installed."
    else
        echo "$available"
    fi

    echo ""
    echo "Commands:"
    echo "  installer/install.sh --all        Install all available targets"
    echo "  installer/doctor.sh               Verify installations"
    echo "  installer/update.sh               Update installed targets"
    echo "  installer/uninstall.sh --all      Uninstall all targets"
    echo ""
}

main "$@"
