#!/bin/bash

# ─── Flag Parsing ────────────────────────────────────────────────────────────
UPDATE_MODE=false
for arg in "$@"; do
    case $arg in
        --update) UPDATE_MODE=true ;;
        *) echo "Unknown flag: $arg"; exit 1 ;;
    esac
done

# ─── uv Check ────────────────────────────────────────────────────────────────
if ! command -v uv &>/dev/null; then
    echo "Error: uv is not installed."
    echo "Please install it first: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi
echo "uv detected: $(uv --version)"
$UPDATE_MODE && echo "Mode: UPDATE (force reinstall all tools)" \
             || echo "Mode: INSTALL (skip already installed tools)"

# ─── Tool Definitions ────────────────────────────────────────────────────────
declare -A PY_TOOLS=(
    ["ytm-player"]="ytm-player"
)

SUCCESS_TOOLS=0
SKIPPED_TOOLS=0
FAILED_TOOLS=0

# ─── Helper: check if package is installed via uv tool list ──────────────────
is_uv_installed() {
    local package_name=$1
    uv tool list 2>/dev/null | grep -q "^$package_name "
}

# ─── Install/Update Logic ─────────────────────────────────────────────────────
install_via_uv() {
    local cmd_name=$1
    local package_name=$2
    local tool_path
    tool_path=$(command -v "$cmd_name" 2>/dev/null)

    echo "----------------------------------------"

    # Skip if already installed (via uv or system) and not in update mode
    if { is_uv_installed "$package_name" || [ -n "$tool_path" ]; } && ! $UPDATE_MODE; then
        local location=${tool_path:-"uv tools"}
        echo "SKIP: '$cmd_name' is already installed at $location (use --update to reinstall)"
        ((SKIPPED_TOOLS++))
        return 0
    fi

    if is_uv_installed "$package_name"; then
        echo ">> Updating '$package_name' via uv..."
        uv tool upgrade "$package_name"
    else
        echo ">> Installing '$package_name' via uv..."
        uv tool install "$package_name"
    fi

    if [ $? -eq 0 ]; then
        echo "Successfully processed $package_name!"
        ((SUCCESS_TOOLS++))
    else
        echo "Error: Failed to process $package_name via uv."
        ((FAILED_TOOLS++))
    fi
}

# ─── Run ─────────────────────────────────────────────────────────────────────
for cmd in "${!PY_TOOLS[@]}"; do
    install_via_uv "$cmd" "${PY_TOOLS[$cmd]}"
done

# ─── Summary ─────────────────────────────────────────────────────────────────
echo "----------------------------------------"
echo "Summary:"
echo "  Installed/Updated : $SUCCESS_TOOLS"
echo "  Skipped           : $SKIPPED_TOOLS"
echo "  Failed            : $FAILED_TOOLS"

if [ $FAILED_TOOLS -gt 0 ]; then
    echo "Some tools failed. Check the logs above."
    exit 1
else
    echo "Process completed successfully!"
    exit 0
fi
