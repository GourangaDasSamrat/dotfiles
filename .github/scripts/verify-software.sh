#!/bin/bash

# Verifies that every package selected by scripts/lib/softwares.sh is installed.
#
# softwares.sh keeps going when a single package fails, so its exit code only
# reflects the last package. This script checks each one explicitly and prints
# (and, in CI, summarises) whatever is missing.
#
# NOTE: the tool selection below mirrors install_packages() in softwares.sh.
# Keep both in sync if the selection logic changes.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# shellcheck source=../../scripts/lib/softwares.sh
source "$REPO_ROOT/scripts/lib/softwares.sh"

case "$OS" in
macos) TOOLS=("${CROSS_PLATFORM_TOOLS[@]}" "${MACOS_TOOLS[@]}") ;;
linux)
  case "$PKG_MANAGER" in
  pkg) TOOLS=("${CROSS_PLATFORM_TOOLS[@]}" "${LINUX_COMMON_TOOLS[@]}" "${TERMUX_TOOLS[@]}") ;;
  dnf) TOOLS=("${CROSS_PLATFORM_TOOLS[@]}" "${LINUX_COMMON_TOOLS[@]}" "${RHEL_TOOLS[@]}") ;;
  pacman) TOOLS=("${CROSS_PLATFORM_TOOLS[@]}" "${LINUX_COMMON_TOOLS[@]}" "${ARCH_TOOLS[@]}") ;;
  *) TOOLS=("${CROSS_PLATFORM_TOOLS[@]}" "${LINUX_COMMON_TOOLS[@]}" "${DEBIAN_TOOLS[@]}") ;;
  esac
  ;;
*)
  echo "Error: unsupported OS '$OS'"
  exit 1
  ;;
esac

echo "Verifying ${#TOOLS[@]} entries (OS=$OS, package manager=$PKG_MANAGER)..."

missing=()
for tool in "${TOOLS[@]}"; do
  IFS='|' read -ra candidates <<<"$tool"
  found=false
  for candidate in "${candidates[@]}"; do
    if _is_installed "$candidate"; then
      found=true
      break
    fi
  done

  if $found; then
    echo "  ok       $tool"
  else
    echo "  MISSING  $tool"
    missing+=("$tool")
  fi
done

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "### Software install verification ($PKG_MANAGER)"
    echo ""
    echo "Checked **${#TOOLS[@]}** entries, **${#missing[@]}** missing."
    if [ "${#missing[@]}" -gt 0 ]; then
      echo ""
      for tool in "${missing[@]}"; do
        echo "- \`$tool\`"
      done
    fi
  } >>"$GITHUB_STEP_SUMMARY"
fi

if [ "${#missing[@]}" -gt 0 ]; then
  echo ""
  echo "${#missing[@]} package(s) missing."
  exit 1
fi

echo ""
echo "All packages verified."
