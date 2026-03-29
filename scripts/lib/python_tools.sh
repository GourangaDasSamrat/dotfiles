#!/bin/bash

# 1. Detect Pip/Python
if command -v pip3 &>/dev/null; then
    PIP_CMD="pip3"
elif command -v pip &>/dev/null; then
    PIP_CMD="pip"
else
    echo "Error: pip is not installed. Please install Python first."
    exit 1
fi

echo "Using $PIP_CMD for potential installations."

# 2. Define Tools (Command Name => PyPI Package Name)
declare -A PY_TOOLS=(
    ["http"]="httpie"
    ["ytm-player"]="ytm-player"
)

SUCCESS_TOOLS=0
SKIPPED_TOOLS=0
FAILED_TOOLS=0

# 3. Check and Install Function
install_if_missing() {
    local cmd_name=$1
    local package_name=$2

    # Check if the command is already available in the system PATH
    # This detects if it was installed via brew, apt, or pip previously
    if command -v "$cmd_name" &>/dev/null; then
        echo ">> $cmd_name is already installed ($(which "$cmd_name")). Skipping..."
        ((SKIPPED_TOOLS++))
        return 0
    fi

    echo ">> $cmd_name not found. Installing $package_name via $PIP_CMD..."

    # Try to install
    $PIP_CMD install "$package_name"

    if [ $? -eq 0 ]; then
        echo "Successfully installed $package_name!"
        ((SUCCESS_TOOLS++))
    else
        echo "Error: Failed to install $package_name."
        ((FAILED_TOOLS++))
    fi
}

# 4. Loop through tools
for cmd in "${!PY_TOOLS[@]}"; do
    echo "----------------------------------------"
    install_if_missing "$cmd" "${PY_TOOLS[$cmd]}"
done

# 5. Summary
echo "----------------------------------------"
echo "Final Status:"
echo "  Installed: $SUCCESS_TOOLS"
echo "  Skipped:   $SKIPPED_TOOLS (Already present)"
echo "  Failed:    $FAILED_TOOLS"

if [ $FAILED_TOOLS -gt 0 ]; then
    exit 1
fi