#!/bin/bash

# Check if Go is installed
if ! command -v go &>/dev/null; then
    echo "Error: Go is not installed on this system."
    echo "Please install Go first: https://go.dev/doc/install"
    exit 1
fi

echo "Go is installed: $(go version)"

# Define Go tools to install/update
declare -A GO_TOOLS=(
    ["goimports"]="golang.org/x/tools/cmd/goimports@latest"
    ["golangci-lint"]="github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest"
    ["gopls"]="golang.org/x/tools/gopls@latest"
    ["air"]="github.com/air-verse/air@latest"
    ["gotests"]="github.com/cweill/gotests/gotests@latest"
    ["govulncheck"]="golang.org/x/vuln/cmd/govulncheck@latest"
    ["shfmt"]="mvdan.cc/sh/v3/cmd/shfmt@latest"
    ["usql"]="github.com/xo/usql@latest"
)

# Custom tags for usql to include specific database drivers
USQL_TAGS="mysql postgres sqlite3 moderncsqlite"

# Counters for tracking status
FAILED_TOOLS=0
SUCCESS_TOOLS=0

# Function to handle installation/update logic
check_and_install_tool() {
    local tool_name=$1
    local tool_package=$2
    local base_cmd="go install"

    echo "----------------------------------------"

    # Check if tool is already installed to provide better feedback
    if command -v "$tool_name" &>/dev/null; then
        echo "Updating $tool_name..."
    else
        echo "Installing $tool_name..."
    fi

    # Apply custom build tags specifically for usql
    if [ "$tool_name" == "usql" ]; then
        echo "Applying custom build tags for $tool_name: [$USQL_TAGS]"
        # Using eval to correctly handle nested quotes in the command
        eval "$base_cmd -tags '$USQL_TAGS' $tool_package"
    else
        # Standard installation for other tools
        $base_cmd "$tool_package"
    fi

    # Check the exit status of the go install command
    if [ $? -ne 0 ]; then
        echo "Error: Failed to process $tool_name"
        ((FAILED_TOOLS++))
        return 1
    else
        echo "$tool_name processed successfully!"
        ((SUCCESS_TOOLS++))
        return 0
    fi
}

# Iterate through the defined tools and process them
for tool in "${!GO_TOOLS[@]}"; do
    check_and_install_tool "$tool" "${GO_TOOLS[$tool]}"
done

# Cleanup Go module cache to free up disk space (preventing that 1.5GB bloat)
echo "----------------------------------------"
echo "Cleaning Go module cache to save storage..."
go clean -modcache

echo "----------------------------------------"
echo "Installation Summary:"
echo "  Successful: $SUCCESS_TOOLS"
echo "  Failed: $FAILED_TOOLS"

if [ $FAILED_TOOLS -eq 0 ]; then
    echo -e "\nAll tools updated successfully! Your GOPATH/bin is ready to use."
    exit 0
else
    echo -e "\nSome tools encountered issues. Please check the logs above."
    exit 1
fi
