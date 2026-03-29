#!/bin/bash

# 1. Check if uv is installed
if ! command -v uv &>/dev/null; then
    echo "Error: uv is not installed."
    echo "Please install it first: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

echo "uv detected: $(uv --version)"

# 2. Define Tools (Command Name => Package Name)
# We map the executable name to the PyPI package name
declare -A PY_TOOLS=(
    ["http"]="httpie"
    ["ytm-player"]="ytm-player"
)

# Counters for tracking status
SUCCESS_TOOLS=0
SKIPPED_TOOLS=0
FAILED_TOOLS=0

# 3. Installation Function
install_via_uv() {
    local cmd_name=$1
    local package_name=$2

    # Check if the command already exists in the system PATH (brew, pip, etc.)
    if command -v "$cmd_name" &>/dev/null; then
        echo ">> '$cmd_name' is already installed at $(which "$cmd_name"). Skipping..."
        ((SKIPPED_TOOLS++))
        return 0
    fi

    echo ">> '$cmd_name' not found. Installing '$package_name' via uv..."
    
    # 'uv tool install' creates an isolated environment for each tool (like pipx)
    uv tool install "$package_name"

    if [ $? -eq 0 ]; then
        echo "Successfully installed $package_name!"
        ((SUCCESS_TOOLS++))
    else
        echo "Error: Failed to install $package_name via uv."
        ((FAILED_TOOLS++))
    fi
}

# 4. Loop through tools and install if missing
for cmd in "${!PY_TOOLS[@]}"; do
    echo "----------------------------------------"
    install_via_uv "$cmd" "${PY_TOOLS[$cmd]}"
done

# 5. Final Summary
echo "----------------------------------------"
echo "Installation Summary:"
echo "  Installed: $SUCCESS_TOOLS"
echo "  Skipped:   $SKIPPED_TOOLS (Already present)"
echo "  Failed:    $FAILED_TOOLS"

if [ $FAILED_TOOLS -gt 0 ]; then
    echo "Some tools failed to install. Check the logs above."
    exit 1
else
    echo "Process completed successfully!"
    exit 0
fi
