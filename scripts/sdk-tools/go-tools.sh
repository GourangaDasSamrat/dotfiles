#!/bin/bash

# ─── Flag Parsing ────────────────────────────────────────────────────────────
UPDATE_MODE=false
for arg in "$@"; do
    case $arg in
        --update) UPDATE_MODE=true ;;
        *) echo "Unknown flag: $arg"; exit 1 ;;
    esac
done

# ─── Go Check ────────────────────────────────────────────────────────────────
if ! command -v go &>/dev/null; then
    echo "Error: Go is not installed on this system."
    echo "Please install Go first: https://go.dev/doc/install"
    exit 1
fi
echo "Go is installed: $(go version)"
$UPDATE_MODE && echo "Mode: UPDATE (force reinstall all tools)" \
             || echo "Mode: INSTALL (skip already installed tools)"

# ─── Tool Definitions ────────────────────────────────────────────────────────
declare -A GO_TOOLS=(
    # Core Development Tools
    ["goimports"]="golang.org/x/tools/cmd/goimports@latest"
    ["golangci-lint"]="github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest"
    ["gopls"]="golang.org/x/tools/gopls@latest"
    ["air"]="github.com/air-verse/air@latest"
    ["gotests"]="github.com/cweill/gotests/gotests@latest"
    ["govulncheck"]="golang.org/x/vuln/cmd/govulncheck@latest"

    # Build & Release Tools
    ["goreleaser"]="github.com/goreleaser/goreleaser/v2@latest"
    ["shfmt"]="mvdan.cc/sh/v3/cmd/shfmt@latest"

    # Utilities & Database Tools
    ["usql"]="github.com/xo/usql@latest"
    ["slim"]="github.com/kamranahmedse/slim@latest"
    ["eget"]="github.com/zyedidia/eget@latest"
    ["sheets"]="github.com/maaslalani/sheets@main"
)

USQL_TAGS="mysql postgres sqlite3 moderncsqlite"
FAILED_TOOLS=0
SUCCESS_TOOLS=0
SKIPPED_TOOLS=0

# ─── Install/Update Logic ─────────────────────────────────────────────────────
check_and_install_tool() {
    local tool_name=$1
    local tool_package=$2

    echo "----------------------------------------"

    # Skip if already installed and not in update mode
    if command -v "$tool_name" &>/dev/null && ! $UPDATE_MODE; then
        echo "SKIP: $tool_name is already installed (use --update to reinstall)"
        ((SKIPPED_TOOLS++))
        return 0
    fi

    if command -v "$tool_name" &>/dev/null; then
        echo "Updating $tool_name..."
    else
        echo "Installing $tool_name..."
    fi

    # usql needs custom build tags
    if [ "$tool_name" == "usql" ]; then
        echo "Applying custom build tags: [$USQL_TAGS]"
        eval "go install -tags '$USQL_TAGS' $tool_package"
    else
        go install "$tool_package"
    fi

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

# ─── Run ─────────────────────────────────────────────────────────────────────
for tool in "${!GO_TOOLS[@]}"; do
    check_and_install_tool "$tool" "${GO_TOOLS[$tool]}"
done

# ─── Cleanup ─────────────────────────────────────────────────────────────────
echo "----------------------------------------"
echo "Cleaning Go module cache to save storage..."
go clean -modcache

# ─── Summary ─────────────────────────────────────────────────────────────────
echo "----------------------------------------"
echo "Summary:"
echo "  Installed/Updated : $SUCCESS_TOOLS"
echo "  Skipped           : $SKIPPED_TOOLS"
echo "  Failed            : $FAILED_TOOLS"

if [ $FAILED_TOOLS -eq 0 ]; then
    echo -e "\nDone! Your GOPATH/bin is ready to use."
    exit 0
else
    echo -e "\nSome tools encountered issues. Check the logs above."
    exit 1
fi
