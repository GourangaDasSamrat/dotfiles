#!/bin/bash

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Error: Go is not installed on this system."
    echo "Please install Go first: https://go.dev/doc/install"
    exit 1
fi

echo "Go is installed: $(go version)"

# Define Go tools to install/update
declare -A GO_TOOLS=(
    ["goimports"]="golang.org/x/tools/cmd/goimports@latest"
    ["golangci-lint"]="github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    ["gopls"]="golang.org/x/tools/gopls@latest"
)

# Counter for tracking failures
FAILED_TOOLS=0
SUCCESS_TOOLS=0

# Function to check if a command exists and get its version
check_and_install_tool() {
    local tool_name=$1
    local tool_package=$2
    
    if command -v "$tool_name" &> /dev/null; then
        echo "$tool_name is installed, checking for updates..."
        echo "Installing/updating $tool_name..."
        go install "$tool_package"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to update $tool_name"
            echo "Possible causes: internet connection, permissions, or package issues"
            ((FAILED_TOOLS++))
            return 1
        else
            echo "$tool_name updated successfully!"
            ((SUCCESS_TOOLS++))
            return 0
        fi
    else
        echo "$tool_name is not installed, installing..."
        go install "$tool_package"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install $tool_name"
            echo "Possible causes: internet connection, permissions, or package issues"
            ((FAILED_TOOLS++))
            return 1
        else
            echo "$tool_name installed successfully!"
            ((SUCCESS_TOOLS++))
            return 0
        fi
    fi
}

# Install/update each tool
for tool in "${!GO_TOOLS[@]}"; do
    echo "----------------------------------------"
    check_and_install_tool "$tool" "${GO_TOOLS[$tool]}"
done

echo "----------------------------------------"
echo "Installation Summary:"
echo "  Successful: $SUCCESS_TOOLS"
echo "  Failed: $FAILED_TOOLS"

if [ $FAILED_TOOLS -eq 0 ]; then
    echo ""
    echo "All Go tools have been installed/updated successfully!"
    echo ""
    echo "Note: Make sure your GOPATH/bin is in your PATH:"
    echo "export PATH=\$PATH:\$(go env GOPATH)/bin"
    exit 0
else
    echo ""
    echo "Some tools failed to install. Please check the errors above."
    echo "Common issues:"
    echo "  - No internet connection"
    echo "  - Permission issues (check GOPATH permissions)"
    echo "  - Network firewall blocking Go module downloads"
    exit 1
fi
