#!/bin/bash

# Shared helpers for scripts/sdk-tools/*.sh (cargo, go, uv, ...).
#
# Usage (from an sdk-tools script):
#   source "$SCRIPT_DIR/../utils/sdk-common.sh"
#   sdk_parse_flags "$@"
#   sdk_print_mode
#   sdk_process_tool <name> <true|false> <command> [args...]   # once per tool
#   sdk_finish "<success message>" ["<failure message>"]
#
# This file only defines variables and functions, so it is safe to source.

UPDATE_MODE=false
SUCCESS_TOOLS=0
SKIPPED_TOOLS=0
FAILED_TOOLS=0

SDK_SEPARATOR="----------------------------------------"

# Parses the flags shared by every sdk-tools script (currently only --update).
sdk_parse_flags() {
  local arg
  for arg in "$@"; do
    case $arg in
    --update) UPDATE_MODE=true ;;
    *)
      echo "Unknown flag: $arg"
      exit 1
      ;;
    esac
  done
}

sdk_print_mode() {
  if $UPDATE_MODE; then
    echo "Mode: UPDATE (force reinstall all tools)"
  else
    echo "Mode: INSTALL (skip already installed tools)"
  fi
}

# Records a tool that was deliberately skipped (and says why).
# Usage: sdk_skip "<message>"
sdk_skip() {
  echo "$SDK_SEPARATOR"
  echo "SKIP: $1"
  SKIPPED_TOOLS=$((SKIPPED_TOOLS + 1))
}

# Runs one install/update step with the shared skip / log / counter logic.
# Usage: sdk_process_tool <name> <already_installed: true|false> <command> [args...]
#   - already installed and not --update  -> skipped
#   - otherwise                           -> <command> is run, result is counted
sdk_process_tool() {
  local name=$1 installed=$2
  shift 2

  if [ "$installed" = true ] && ! $UPDATE_MODE; then
    sdk_skip "$name is already installed (use --update to reinstall)"
    return 0
  fi

  echo "$SDK_SEPARATOR"
  if [ "$installed" = true ]; then
    echo "Updating $name..."
  else
    echo "Installing $name..."
  fi

  if "$@"; then
    echo "$name processed successfully!"
    SUCCESS_TOOLS=$((SUCCESS_TOOLS + 1))
    return 0
  fi

  echo "Error: Failed to process $name"
  FAILED_TOOLS=$((FAILED_TOOLS + 1))
  return 1
}

sdk_print_summary() {
  echo "$SDK_SEPARATOR"
  echo "Summary:"
  echo "  Installed/Updated : $SUCCESS_TOOLS"
  echo "  Skipped           : $SKIPPED_TOOLS"
  echo "  Failed            : $FAILED_TOOLS"
}

# Prints the summary and exits 0 / 1 depending on whether anything failed.
# Usage: sdk_finish "<success message>" ["<failure message>"]
sdk_finish() {
  local ok_msg=$1
  local fail_msg=${2:-"Some tools encountered issues. Check the logs above."}

  sdk_print_summary
  echo ""
  if [ "$FAILED_TOOLS" -eq 0 ]; then
    echo "$ok_msg"
    exit 0
  fi
  echo "$fail_msg"
  exit 1
}
