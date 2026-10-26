#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/detect.sh"
source "$SCRIPT_DIR/../utils/software_lists.sh"

_is_installed() {
  local tool="$1"
  case "$PKG_MANAGER" in
  brew) brew list "$tool" &>/dev/null ;;
  pkg) pkg list-installed 2>/dev/null | grep -qE "^${tool}/" ;;
  apt) dpkg-query -W -f='${Status}' "$tool" 2>/dev/null | grep -q "ok installed" ;;
  pacman) pacman -Q "$tool" &>/dev/null || pacman -Qg "$tool" &>/dev/null ;;
  dnf)
    if [[ "$tool" == @* ]]; then
      local group_name="${tool#@}"
      dnf group list --installed 2>/dev/null | grep -qiF "$group_name"
    else
      dnf list installed "$tool" &>/dev/null
    fi
    ;;
  esac
}

# Installs ONE package name with the detected package manager.
# dnf "@group" names are installed as package groups.
_pm_install() {
  local pkg="$1"
  case "$PKG_MANAGER" in
  brew) brew install "$pkg" ;;
  pkg) pkg install -y "$pkg" ;;
  apt) $SUDO_CMD apt install -y "$pkg" ;;
  pacman) $SUDO_CMD pacman -S --noconfirm "$pkg" ;;
  dnf)
    if [[ "$pkg" == @* ]]; then
      $SUDO_CMD dnf group install -y "${pkg#@}"
    else
      $SUDO_CMD dnf install -y "$pkg"
    fi
    ;;
  esac
}

_install_tool() {
  local tool="$1"

  # "pkg1|pkg2" means OR — try each name, install whichever exists in the repo.
  # A plain name is simply a one-element list.
  local candidates candidate
  IFS='|' read -ra candidates <<<"$tool"

  for candidate in "${candidates[@]}"; do
    if _is_installed "$candidate"; then
      echo "$candidate is already installed, skipping..."
      return 0
    fi
  done

  # Normal single-tool logic
  if ((${#candidates[@]} == 1)); then
    echo "Installing $tool..."
    _pm_install "$tool"
    return
  fi

  # Try installing each candidate until one succeeds
  for candidate in "${candidates[@]}"; do
    echo "Trying to install $candidate..."
    _pm_install "$candidate" && return 0
  done

  echo "Warning: Could not install any of: $tool"
  return 1
}

# Makes sure the `dnf copr` subcommand exists. Minimal images (e.g. the Fedora
# container used in CI) ship without it: dnf5 provides it in dnf5-plugins, the
# older dnf4 in dnf-plugins-core.
_ensure_copr_plugin() {
  dnf copr --help &>/dev/null && return 0

  echo "Installing the dnf copr plugin..."
  $SUDO_CMD dnf install -y dnf5-plugins || $SUDO_CMD dnf install -y dnf-plugins-core
  dnf copr --help &>/dev/null
}

# Enables every COPR repository listed in RHEL_COPR_REPOS (dnf only).
# `dnf copr enable -y` is idempotent, so re-running is safe.
_enable_copr_repos() {
  ((${#RHEL_COPR_REPOS[@]})) || return 0

  if ! _ensure_copr_plugin; then
    echo "Warning: dnf copr plugin is unavailable, skipping COPR repositories."
    return 1
  fi

  local repo status=0
  for repo in "${RHEL_COPR_REPOS[@]}"; do
    echo "Enabling COPR repository $repo..."
    if ! $SUDO_CMD dnf copr enable -y "$repo"; then
      echo "Warning: could not enable COPR repository $repo"
      status=1
    fi
  done
  return "$status"
}

# Fills the global TOOLS array for the detected OS and package manager.
# Shared with .github/scripts/verify-software.sh so both always agree.
_select_tools() {
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
    echo "Error: unsupported OS '$OS'" >&2
    return 1
    ;;
  esac
}

install_packages() {
  if [ "$OS" = "unsupported" ] || [ "$PKG_MANAGER" = "unsupported" ]; then
    echo "Error: Unsupported OS or package manager."
    return 1
  fi

  _select_tools || return 1

  echo "Updating system..."
  case "$PKG_MANAGER" in
  brew) brew update && brew upgrade ;;
  pkg) pkg update -y && pkg upgrade -y ;;
  dnf) $SUDO_CMD dnf upgrade --refresh -y ;;
  apt) $SUDO_CMD apt update && $SUDO_CMD apt upgrade -y ;;
  pacman) $SUDO_CMD pacman -Syu --noconfirm ;;
  esac

  # Extra repositories must be enabled before the packages that live in them.
  case "$PKG_MANAGER" in
  dnf) _enable_copr_repos ;;
  esac

  for tool in "${TOOLS[@]}"; do
    _install_tool "$tool"
  done
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_packages
fi
