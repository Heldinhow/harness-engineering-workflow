# Harness Engineering Workflow - Installer Manifest
# This file declares the installable assets and target mappings.

PACKAGE_NAME="harness-engineering-workflow"
PACKAGE_VERSION="0.1.0"
INSTALL_CONFIG_DIR="${HOME}/.config/harness-workflow"
INSTALL_STATE_FILE="${INSTALL_CONFIG_DIR}/installed.json"

# Core assets that are installable
ASSETS_ROOT="${SCRIPT_DIR}/.."

ASSET_GROUPS="
skills:skills:SKILL.md
templates:templates:*.md
schemas:schemas:*.json
root:.:AGENTS.md
root:.:README.md
"

# Supported targets and their metadata
# Format: TARGET_ID|TARGET_NAME|CAPABILITY_MODE|SUPPORT_LEVEL
# CAPABILITY_MODE: full | adapted | fallback
# SUPPORT_LEVEL: official | community | experimental
TARGETS="
claude-code|Claude Code|full|official
codex|OpenAI Codex|adapted|official
copilot-cli|GitHub Copilot CLI|adapted|official
pi-agent|Pi Agent|full|official
opencode|Sourcegraph OpenCode|fallback|experimental
forgecode|ForgeCode|fallback|experimental
:"
# Assets to install per capability mode
ASSETS_FULL="
skills/
templates/
schemas/
AGENTS.md
"

ASSETS_ADAPTED="
templates/
schemas/
AGENTS.md
"

ASSETS_FALLBACK="
AGENTS.md
templates/
"

# Get target info by ID
get_target_name() {
    local target_id="$1"
    echo "$TARGETS" | grep "^${target_id}|" | cut -d'|' -f2
}

get_target_mode() {
    local target_id="$1"
    echo "$TARGETS" | grep "^${target_id}|" | cut -d'|' -f3
}

get_target_support() {
    local target_id="$1"
    echo "$TARGETS" | grep "^${target_id}|" | cut -d'|' -f4
}

# Get assets for a given mode
get_assets_for_mode() {
    local mode="$1"
    case "$mode" in
        full) echo "$ASSETS_FULL" ;;
        adapted) echo "$ASSETS_ADAPTED" ;;
        fallback) echo "$ASSETS_FALLBACK" ;;
        *) echo "" ;;
    esac
}
