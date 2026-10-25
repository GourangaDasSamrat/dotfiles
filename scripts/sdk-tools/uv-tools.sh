#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/sdk-common.sh
source "$SCRIPT_DIR/../utils/sdk-common.sh"

sdk_parse_flags "$@"

# ─── uv Check ────────────────────────────────────────────────────────────────
if ! command -v uv &>/dev/null; then
  echo "Error: uv is not installed."
  echo "Please install it first: curl -LsSf https://astral.sh/uv/install.sh | sh"
  exit 1
fi
echo "uv detected: $(uv --version)"
sdk_print_mode

# ─── Tool Definitions ────────────────────────────────────────────────────────
declare -A PY_TOOLS=(
  ["ytm-player"]="ytm-player"
)

# ─── Helper: check if package is installed via uv tool list ──────────────────
is_uv_installed() {
  local package_name=$1
  uv tool list 2>/dev/null | grep -q "^$package_name "
}

# Upgrades the package if uv already manages it, installs it otherwise.
# shellcheck disable=SC2317,SC2329  # invoked indirectly through sdk_process_tool
_uv_install_or_upgrade() {
  local package_name=$1
  if is_uv_installed "$package_name"; then
    uv tool upgrade "$package_name"
  else
    uv tool install "$package_name"
  fi
}

# ─── Install/Update Logic ─────────────────────────────────────────────────────
install_via_uv() {
  local cmd_name=$1
  local package_name=$2
  local installed=false

  # Already installed (via uv or system)?
  if is_uv_installed "$package_name" || command -v "$cmd_name" &>/dev/null; then
    installed=true
  fi

  sdk_process_tool "$cmd_name" "$installed" _uv_install_or_upgrade "$package_name"
}

# ─── Run ─────────────────────────────────────────────────────────────────────
for cmd in "${!PY_TOOLS[@]}"; do
  install_via_uv "$cmd" "${PY_TOOLS[$cmd]}"
done

# ─── Summary ─────────────────────────────────────────────────────────────────
sdk_finish "Process completed successfully!" "Some tools failed. Check the logs above."
