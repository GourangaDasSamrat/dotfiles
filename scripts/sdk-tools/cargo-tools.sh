#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/sdk-common.sh
source "$SCRIPT_DIR/../utils/sdk-common.sh"

sdk_parse_flags "$@"

# ─── Rust & Binstall Check ───────────────────────────────────────────────────
if ! command -v cargo &>/dev/null; then
  echo "Error: Cargo is not installed. Please install Rust: https://rustup.rs/"
  exit 1
fi

if ! command -v cargo-binstall &>/dev/null; then
  echo "cargo-binstall not found. Installing it now via quick-install..."
  curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

echo "Rust is installed: $(rustc --version)"
sdk_print_mode

# ─── Tool Definitions ────────────────────────────────────────────────────────
# Format: ["binary_name"]="crate_name"
declare -A RUST_TOOLS=(
  ["cargo-watch"]="cargo-watch"
  ["cargo-cache"]="cargo-cache"
  ["cargo-dist"]="cargo-dist"
  ["cargo-modules"]="cargo-modules"
)

# ─── Install/Update Logic ─────────────────────────────────────────────────────
check_and_install_tool() {
  local bin_name=$1
  local crate_name=$2
  local installed=false
  command -v "$bin_name" &>/dev/null && installed=true

  # --no-confirm skips the [y/n] prompts
  # --force ensures it overwrites if $UPDATE_MODE is true
  local -a install_cmd=(cargo binstall --no-confirm)
  if $UPDATE_MODE; then
    install_cmd+=(--force)
  fi
  install_cmd+=("$crate_name")

  sdk_process_tool "$bin_name" "$installed" "${install_cmd[@]}"
}

# ─── Run ─────────────────────────────────────────────────────────────────────
for bin in "${!RUST_TOOLS[@]}"; do
  check_and_install_tool "$bin" "${RUST_TOOLS[$bin]}"
done

# ─── Summary ─────────────────────────────────────────────────────────────────
sdk_finish "Done! Your cargo bin directory is ready to rock."
