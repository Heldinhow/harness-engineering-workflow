# Target detection library for the Harness Engineering Workflow installer.
# Detects which coding agents are installed on the system.

# Note: SCRIPT_DIR is set by the main script that sources this library.

# Detection functions for each target

detect_claude_code() {
    if command -v claude &>/dev/null; then
        # Check if claude command exists and has a version or help
        if claude --version &>/dev/null || claude --help &>/dev/null; then
            echo "detected"
            return 0
        fi
    fi

    # Also check common installation paths
    local paths="
        /usr/local/bin/claude
        /usr/bin/claude
        ${HOME}/.local/bin/claude
        ${HOME}/.claude/bin/claude
    "

    for path in $paths; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            echo "detected"
            return 0
        fi
    done

    echo "not_detected"
    return 1
}

detect_codex() {
    # Check for OpenAI Codex CLI
    if command -v codex &>/dev/null; then
        if codex --version &>/dev/null || codex --help &>/dev/null; then
            echo "detected"
            return 0
        fi
    fi

    # Check common paths
    local paths="
        /usr/local/bin/codex
        /usr/bin/codex
        ${HOME}/.local/bin/codex
    "

    for path in $paths; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            echo "detected"
            return 0
        fi
    done

    echo "not_detected"
    return 1
}

detect_copilot_cli() {
    # Check for GitHub Copilot CLI
    if command -v gh &>/dev/null; then
        # Copilot is a gh extension
        if gh copilot --version &>/dev/null || gh extension list 2>/dev/null | grep -q copilot; then
            echo "detected"
            return 0
        fi
    fi

    # Also check for direct copilot command
    if command -v copilot &>/dev/null; then
        if copilot --version &>/dev/null || copilot --help &>/dev/null; then
            echo "detected"
            return 0
        fi
    fi

    # Check common paths
    local paths="
        /usr/local/bin/gh-copilot
        /usr/local/bin/copilot
        ${HOME}/.local/bin/gh-copilot
    "

    for path in $paths; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            echo "detected"
            return 0
        fi
    done

    echo "not_detected"
    return 1
}

detect_opencode() {
    # Check for Sourcegraph OpenCode
    if command -v opencode &>/dev/null; then
        if opencode --version &>/dev/null || opencode --help &>/dev/null; then
            echo "detected"
            return 0
        fi
    fi

    # Check common paths
    local paths="
        /usr/local/bin/opencode
        /usr/bin/opencode
        ${HOME}/.local/bin/opencode
    "

    for path in $paths; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            echo "detected"
            return 0
        fi
    done

    echo "not_detected"
    return 1
}

detect_forgecode() {
    # Check for ForgeCode (generic detection for unknown agents)
    if command -v forgecode &>/dev/null; then
        if forgecode --version &>/dev/null || forgecode --help &>/dev/null; then
            echo "detected"
            return 0
        fi
    fi

    # Check common paths
    local paths="
        /usr/local/bin/forgecode
        /usr/bin/forgecode
        ${HOME}/.local/bin/forgecode
    "

    for path in $paths; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            echo "detected"
            return 0
        fi
    done

    echo "not_detected"
    return 1
}

# Main detection dispatcher
detect_target() {
    local target_id="$1"
    case "$target_id" in
        claude-code) detect_claude_code ;;
        codex) detect_codex ;;
        copilot-cli) detect_copilot_cli ;;
        opencode) detect_opencode ;;
        forgecode) detect_forgecode ;;
        *) echo "unknown_target" ;;
    esac
}

# Detect all targets and return a summary
detect_all_targets() {
    local targets="claude-code codex copilot-cli opencode forgecode"
    local detected=""
    local not_detected=""

    for target in $targets; do
        local name=$(get_target_name "$target")
        local mode=$(get_target_mode "$target")
        local support=$(get_target_support "$target")
        local status=$(detect_target "$target")

        if [ "$status" = "detected" ]; then
            detected="${detected}${target}|${name}|${mode}|${support}|detected\n"
        else
            not_detected="${not_detected}${target}|${name}|${mode}|${support}|not_detected\n"
        fi
    done

    # Print detected first, then not detected
    if [ -n "$detected" ]; then
        echo -e "$detected"
    fi
    if [ -n "$not_detected" ]; then
        echo -e "$not_detected"
    fi
}

# Print capability matrix
print_capability_matrix() {
    echo ""
    echo "=== Capability Matrix ==="
    echo ""
    printf "%-15s %-20s %-10s %-12s %-15s\n" "TARGET" "NAME" "MODE" "SUPPORT" "STATUS"
    printf "%-15s %-20s %-10s %-12s %-15s\n" "------" "----" "----" "-------" "------"
    echo ""

    detect_all_targets | while IFS='|' read -r id name mode support status; do
        local color=""
        case "$status" in
            detected) color="✓ installed" ;;
            not_detected) color="○ available" ;;
        esac
        printf "%-15s %-20s %-10s %-12s %-15s\n" "$id" "$name" "$mode" "$support" "$color"
    done

    echo ""
}
