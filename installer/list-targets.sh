#!/usr/bin/env bash
# Harness Engineering Workflow - List Targets command
# Shows all supported targets and their current status.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source libraries
. "${SCRIPT_DIR}/lib/manifest.sh"
. "${SCRIPT_DIR}/lib/detect.sh"
. "${SCRIPT_DIR}/lib/state.sh"

print_header() {
    echo ""
    echo -e "${BLUE}=== Supported Targets ===${NC}"
    echo ""
}

print_target() {
    local id="$1"
    local name="$2"
    local mode="$3"
    local support="$4"
    local status="$5"
    local installed="$6"

    local color_mode=""
    case "$mode" in
        full) color_mode="${GREEN}$mode${NC}" ;;
        adapted) color_mode="${YELLOW}$mode${NC}" ;;
        fallback) color_mode="${RED}$mode${NC}" ;;
        *) color_mode="$mode" ;;
    esac

    local color_status=""
    case "$status" in
        detected)
            if [ "$installed" = "yes" ]; then
                color_status="${GREEN}installed${NC}"
            else
                color_status="${GREEN}available${NC}"
            fi
            ;;
        not_detected) color_status="${RED}not detected${NC}" ;;
        *) color_status="$status" ;;
    esac

    local color_support=""
    case "$support" in
        official) color_support="$support" ;;
        community) color_support="${YELLOW}$support${NC}" ;;
        experimental) color_support="${RED}$support${NC}" ;;
        *) color_support="$support" ;;
    esac

    printf "  %-15s | %-20s | %-10s | %-12s | %-15s\n" \
        "$id" "$name" "$color_mode" "$color_support" "$color_status"
}

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

main() {
    print_header

    printf "  %-15s | %-20s | %-10s | %-12s | %-15s\n" \
        "TARGET" "NAME" "MODE" "SUPPORT" "STATUS"
    printf "  %-15s-+-%-20s-+-%-10s-+-%-12s-+-%-15s\n" \
        "---------------" "--------------------" "----------" "------------" "---------------"
    echo ""

    # Get detection results
    local detection_results=$(detect_all_targets)

    echo "$detection_results" | while IFS='|' read -r id name mode support status; do
        local installed="no"
        if is_target_installed "$id" 2>/dev/null; then
            installed="yes"
        fi
        print_target "$id" "$name" "$mode" "$support" "$status" "$installed"
    done

    echo ""
    echo "Modes:"
    echo "  ${GREEN}full${NC}      - Native skill support, all assets installed"
    echo "  ${YELLOW}adapted${NC}  - Adapted mode, compatible assets installed"
    echo "  ${RED}fallback${NC} - Basic mode, essential files only"
    echo ""
    echo "Support:"
    echo "  official      - Officially supported"
    echo "  community     - Community supported"
    echo "  experimental  - Experimental support"
    echo ""
}

main "$@"
