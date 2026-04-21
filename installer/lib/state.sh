# State management library for the Harness Engineering Workflow installer.
# Manages the installed-state file at ~/.config/harness-workflow/installed.json

# Note: SCRIPT_DIR and manifest.sh are set/sourced by the main script.

# Ensure the config directory exists
ensure_config_dir() {
    mkdir -p "${INSTALL_CONFIG_DIR}"
}

# Read installed state from file
read_installed_state() {
    if [ -f "${INSTALL_STATE_FILE}" ]; then
        cat "${INSTALL_STATE_FILE}"
    else
        echo '{}'
    fi
}

# Write installed state to file
write_installed_state() {
    local state="$1"
    ensure_config_dir
    echo "$state" > "${INSTALL_STATE_FILE}"
}

# Get installed targets from state
get_installed_targets() {
    local state=$(read_installed_state)

    # Extract target IDs from JSON (simple parsing without jq)
    echo "$state" | grep -o '"target_id": "[^"]*"' | cut -d'"' -f4
}

# Check if a target is installed
is_target_installed() {
    local target_id="$1"
    local state=$(read_installed_state)

    if echo "$state" | grep -q "\"target_id\": \"${target_id}\""; then
        return 0
    fi
    return 1
}

# Get install mode for a target
get_installed_mode() {
    local target_id="$1"
    local state=$(read_installed_state)

    # Extract mode for target (simple grep-based parsing)
    local target_block=$(echo "$state" | grep -A20 "\"target_id\": \"${target_id}\"" | head -20)
    echo "$target_block" | grep '"mode":' | head -1 | sed 's/.*"mode": *"\([^"]*\)".*/\1/'
}

# Get installed paths for a target
get_installed_paths() {
    local target_id="$1"
    local state=$(read_installed_state)

    # Extract paths array for target
    local target_block=$(echo "$state" | grep -A30 "\"target_id\": \"${target_id}\"" | head -30)
    echo "$target_block" | grep '"path":' | sed 's/.*"path": *"\([^"]*\)".*/\1/'
}

# Add or update target installation record
record_target_install() {
    local target_id="$1"
    local mode="$2"
    local version="$3"
    local install_time="$4"
    local paths_json="$5"

    local state=$(read_installed_state)

    # Remove existing record for this target if present
    local new_state=$(echo "$state" | python3 -c "
import json
import sys

try:
    data = json.loads(sys.stdin.read())
except:
    data = {}

if 'installations' not in data:
    data['installations'] = []

# Remove existing installation for this target
data['installations'] = [i for i in data.get('installations', [])
                         if i.get('target_id') != '$target_id']

# Add new installation
data['installations'].append({
    'target_id': '$target_id',
    'mode': '$mode',
    'version': '$version',
    'installed_at': '$install_time',
    'paths': $paths_json
})

print(json.dumps(data, indent=2))
" 2>/dev/null) || {
        # Fallback if python3 is not available - simple append
        echo "{\"package\":\"${PACKAGE_NAME}\",\"version\":\"${version}\",\"installations\":[{\"target_id\":\"${target_id}\",\"mode\":\"${mode}\",\"version\":\"${version}\",\"installed_at\":\"${install_time}\",\"paths\":${paths_json}}]}"
        return
    }

    write_installed_state "$new_state"
}

# Remove target installation record
remove_target_install() {
    local target_id="$1"
    local state=$(read_installed_state)

    local new_state=$(echo "$state" | python3 -c "
import json
import sys

try:
    data = json.loads(sys.stdin.read())
except:
    data = {}

if 'installations' in data:
    data['installations'] = [i for i in data.get('installations', [])
                             if i.get('target_id') != '$target_id']

print(json.dumps(data, indent=2))
" 2>/dev/null) || {
        echo '{}'
        return
    }

    write_installed_state "$new_state"
}

# List all installed targets with their status
list_installed() {
    local state=$(read_installed_state)

    echo ""
    echo "=== Installed Targets ==="
    echo ""

    local installations=$(echo "$state" | python3 -c "
import json
import sys

try:
    data = json.loads(sys.stdin.read())
    installations = data.get('installations', [])
    if installations:
        for inst in installations:
            print(f\"{inst.get('target_id', '')}|{inst.get('mode', '')}|{inst.get('version', '')}|{inst.get('installed_at', '')}\")
    else:
        print('no_installations')
except:
    print('no_installations')
" 2>/dev/null)

    if [ "$installations" = "no_installations" ] || [ -z "$installations" ]; then
        echo "No targets installed."
        echo ""
        echo "Run 'installer/install.sh --all' or 'installer/install.sh --target <target>' to install."
        return
    fi

    printf "%-15s %-10s %-10s %-25s\n" "TARGET" "MODE" "VERSION" "INSTALLED_AT"
    printf "%-15s %-10s %-10s %-25s\n" "------" "----" "-------" "-----------"
    echo ""

    echo "$installations" | while IFS='|' read -r tid mode version time; do
        printf "%-15s %-10s %-10s %-25s\n" "$tid" "$mode" "$version" "$time"
    done

    echo ""
}

# Check if installation state is valid
validate_installed_state() {
    if [ ! -f "${INSTALL_STATE_FILE}" ]; then
        echo "not_installed"
        return 1
    fi

    # Check if it's valid JSON
    python3 -c "import json; json.load(open('${INSTALL_STATE_FILE}'))" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "invalid_state"
        return 1
    fi

    echo "valid"
    return 0
}
