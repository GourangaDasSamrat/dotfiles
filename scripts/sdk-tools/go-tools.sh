#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/sdk-common.sh
source "$SCRIPT_DIR/../utils/sdk-common.sh"

sdk_parse_flags "$@"

# ─── Go Check ────────────────────────────────────────────────────────────────
if ! command -v go &>/dev/null; then
  echo "Error: Go is not installed on this system."
  echo "Please install Go first: https://go.dev/doc/install"
  exit 1
fi
echo "Go is installed: $(go version)"
sdk_print_mode

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

  # Utilities & Database Tools
  ["usql"]="github.com/xo/usql@latest"
  ["eget"]="github.com/zyedidia/eget@latest"
  ["sheets"]="github.com/maaslalani/sheets@main"
)

USQL_TAGS="mysql postgres sqlite3 moderncsqlite"

# ─── Install/Update Logic ─────────────────────────────────────────────────────
# shellcheck disable=SC2317  # invoked indirectly through sdk_process_tool
_go_install() {
  local tool_name=$1
  local tool_package=$2

  # usql needs custom build tags
  if [ "$tool_name" == "usql" ]; then
    echo "Applying custom build tags: [$USQL_TAGS]"
    go install -tags "$USQL_TAGS" "$tool_package"
  else
    go install "$tool_package"
  fi
}

check_and_install_tool() {
  local tool_name=$1
  local tool_package=$2
  local installed=false
  command -v "$tool_name" &>/dev/null && installed=true

  sdk_process_tool "$tool_name" "$installed" _go_install "$tool_name" "$tool_package"
}

# ─── gtrash (Linux always, macOS only if native trash unavailable) ────────────
install_gtrash() {
  if [[ "$OSTYPE" == "linux"* ]]; then
    check_and_install_tool "gtrash" "github.com/umlx5h/gtrash@latest"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v trash &>/dev/null; then
      echo "$SDK_SEPARATOR"
      echo "macOS: native 'trash' not found (requires macOS 15+), installing gtrash..."
      check_and_install_tool "gtrash" "github.com/umlx5h/gtrash@latest"
    else
      sdk_skip "gtrash — native 'trash' command already available on this macOS"
    fi
  fi
}

# ─── Run ─────────────────────────────────────────────────────────────────────
for tool in "${!GO_TOOLS[@]}"; do
  check_and_install_tool "$tool" "${GO_TOOLS[$tool]}"
done

install_gtrash

# ─── Cleanup ─────────────────────────────────────────────────────────────────
echo "$SDK_SEPARATOR"
echo "Cleaning Go module cache to save storage..."
go clean -modcache

# GNU strip accepts --strip-all; BSD strip does not and
# uses -x (drop local symbols) instead.
if [[ "$OSTYPE" == "darwin"* ]]; then
  STRIP_FLAGS=(-x)
else
  STRIP_FLAGS=(--strip-all)
fi

echo "Stripping Go binaries and adding symlink for golangci-lint..."
strip "${STRIP_FLAGS[@]}" "$GOPATH/bin"/* && ln -s "$GOPATH/bin/golangci-lint" "$GOPATH/bin/golangci-lint-v2"

# ─── Summary ─────────────────────────────────────────────────────────────────
sdk_finish "Done! Your GOPATH/bin is ready to use."
