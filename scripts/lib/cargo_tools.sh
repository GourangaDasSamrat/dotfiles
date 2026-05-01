#!/bin/bash

# ─── Flag Parsing ────────────────────────────────────────────────────────────
UPDATE_MODE=false
for arg in "$@"; do
  case $arg in
  --update) UPDATE_MODE=true ;;
  *)
    echo "Unknown flag: $arg"
    exit 1
    ;;
  esac
done

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
$UPDATE_MODE && echo "Mode: UPDATE (force reinstall all tools)" ||
  echo "Mode: INSTALL (skip already installed tools)"

# ─── Tool Definitions ────────────────────────────────────────────────────────
# Format: ["binary_name"]="crate_name"
declare -A RUST_TOOLS=(
  ["cargo-watch"]="cargo-watch"
)

FAILED_TOOLS=0
SUCCESS_TOOLS=0
SKIPPED_TOOLS=0

# ─── Install/Update Logic ─────────────────────────────────────────────────────
check_and_install_tool() {
  local bin_name=$1
  local crate_name=$2

  echo "----------------------------------------"

  # Skip if already installed and not in update mode
  if command -v "$bin_name" &>/dev/null && ! $UPDATE_MODE; then
    echo "SKIP: $bin_name is already installed (use --update to reinstall)"
    ((SKIPPED_TOOLS++))
    return 0
  fi

  if command -v "$bin_name" &>/dev/null; then
    echo "Updating $bin_name ($crate_name)..."
  else
    echo "Installing $bin_name ($crate_name)..."
  fi

  # --no-confirm skips the [y/n] prompts
  # --force ensures it overwrites if $UPDATE_MODE is true
  if $UPDATE_MODE; then
    cargo binstall --no-confirm --force "$crate_name"
  else
    cargo binstall --no-confirm "$crate_name"
  fi

  if [ $? -ne 0 ]; then
    echo "Error: Failed to process $crate_name"
    ((FAILED_TOOLS++))
    return 1
  else
    echo "$bin_name processed successfully!"
    ((SUCCESS_TOOLS++))
    return 0
  fi
}

# ─── Run ─────────────────────────────────────────────────────────────────────
for bin in "${!RUST_TOOLS[@]}"; do
  check_and_install_tool "$bin" "${RUST_TOOLS[$bin]}"
done

# ─── Summary ─────────────────────────────────────────────────────────────────
echo "----------------------------------------"
echo "Summary:"
echo "  Installed/Updated : $SUCCESS_TOOLS"
echo "  Skipped           : $SKIPPED_TOOLS"
echo "  Failed            : $FAILED_TOOLS"

if [ $FAILED_TOOLS -eq 0 ]; then
  echo -e "\nDone! Your cargo bin directory is ready to rock."
  exit 0
else
  echo -e "\nSome tools encountered issues. Check the logs above."
  exit 1
fi
