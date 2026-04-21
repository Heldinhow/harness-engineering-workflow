# Render library for the Harness Engineering Workflow installer.
# Handles copying and transforming assets for each target.

# Note: SCRIPT_DIR and manifest.sh are set/sourced by the main script.

# Global variables for tracking operations
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"

# Log a message
log() {
    if [ "$VERBOSE" = "true" ]; then
        echo "[INFO] $*" >&2
    fi
}

# Log a warning
warn() {
    echo "[WARN] $*" >&2
}

# Log an error
error() {
    echo "[ERROR] $*" >&2
}

# Execute or simulate a copy operation
copy_file() {
    local src="$1"
    local dest="$2"
    local mode="${3:-644}"

    if [ ! -f "$src" ]; then
        warn "Source file not found: $src"
        return 1
    fi

    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY-RUN] cp $src -> $dest (mode: $mode)"
        return 0
    fi

    # Ensure destination directory exists
    local dest_dir=$(dirname "$dest")
    mkdir -p "$dest_dir"

    # Copy the file
    cp "$src" "$dest"
    chmod "$mode" "$dest"
    log "Copied: $src -> $dest"
}

# Execute or simulate a directory copy
copy_dir() {
    local src="$1"
    local dest="$2"

    if [ ! -d "$src" ]; then
        warn "Source directory not found: $src"
        return 1
    fi

    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY-RUN] cp -r $src/ -> $dest/ (recursive)"
        return 0
    fi

    # Ensure destination directory exists
    mkdir -p "$dest"

    # Copy directory contents
    cp -r "$src/"* "$dest/"
    log "Copied directory: $src/ -> $dest/"
}

# Remove a file
remove_file() {
    local file="$1"

    if [ ! -e "$file" ]; then
        log "File already absent: $file"
        return 0
    fi

    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY-RUN] rm $file"
        return 0
    fi

    rm -f "$file"
    log "Removed: $file"
}

# Remove a directory
remove_dir() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        log "Directory already absent: $dir"
        return 0
    fi

    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY-RUN] rm -rf $dir"
        return 0
    fi

    rm -rf "$dir"
    log "Removed directory: $dir"
}

# Check if a file exists
file_exists() {
    [ -e "$1" ]
}

# Check if a directory exists
dir_exists() {
    [ -d "$1" ]
}

# Get the list of files that would be installed for a given asset spec
preview_install() {
    local assets_root="$1"
    local asset_spec="$2"

    echo "$asset_spec" | while read -r line; do
        # Skip empty lines and comments
        [ -z "$line" ] && continue
        [[ "$line" =~ ^# ]] && continue

        # Parse asset specification
        local src="$assets_root/$line"
        local dest_dir=""
        local filename=""

        if [ -d "$src" ]; then
            # Directory - list contents
            find "$src" -type f 2>/dev/null | sed "s|^$assets_root/||" | while read -r f; do
                echo "  $f"
            done
        elif [ -f "$src" ]; then
            # Single file
            echo "  $line"
        fi
    done
}

# Generate a JSON array of paths from a list
generate_paths_json() {
    local prefix="$1"
    shift
    local paths="$*"

    local json="["
    local first=true
    for path in $paths; do
        if [ "$first" = "true" ]; then
            first=false
        else
            json="${json},"
        fi
        json="${json}\"${prefix}${path}\""
    done
    json="${json}]"
    echo "$json"
}
