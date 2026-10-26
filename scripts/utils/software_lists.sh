#!/bin/bash

# This file is only ever sourced (by softwares.sh and verify-software.sh); the
# arrays below are consumed there, so ShellCheck cannot see their use here.
# shellcheck disable=SC2034

# ==============================================================================
# Software Package Lists
# Categorized by Operating System, Linux Distribution, and Environment
# ==============================================================================

# ------------------------------------------------------------------------------
# Cross-Platform Core Tools
# Essential utilities, CLI power-tools, and common packages installed across
# all supported operating systems (Linux distros & macOS).
# ------------------------------------------------------------------------------
CROSS_PLATFORM_TOOLS=(
  "curl"
  "wget2|wget"
  "httpie"
  "openssl"

  "bash-completion"
  "starship"
  "eza"
  "bat|batcat"
  "duf"
  "fd|fd-find"
  "ripgrep"
  "fzf"

  "jq"
  "shfmt"
  "shellcheck"
  "just"
  "moreutils"

  "gh|github-cli"
  "git-lfs"
  "git-delta"
  "stow"
  "pass"
)

# ------------------------------------------------------------------------------
# Common Linux Tools
# Packages required for standard desktop and interactive terminal sessions
# across all modern Linux distributions (Debian/Ubuntu, Arch, RHEL/Fedora).
# ------------------------------------------------------------------------------
LINUX_COMMON_TOOLS=(
  "rofi"
  "pinentry-gnome3|pinentry-gnome|pinentry"

  "llvm"
  "clang"
  "7zip|p7zip-full|p7zip"
  "zsh"
)

# ------------------------------------------------------------------------------
# Debian/Ubuntu Tools
# Essential build dependencies and system helpers intended for apt-based
# Linux distributions.
# ------------------------------------------------------------------------------
DEBIAN_TOOLS=(
  "build-essential"
  "command-not-found"
)

# ------------------------------------------------------------------------------
# RHEL / Fedora / CentOS Tools
# Development packages and system tools specific to RPM-based distributions
# using the DNF package manager.
# ------------------------------------------------------------------------------
RHEL_TOOLS=(
  "@development-tools"
  "openssl-devel"
  "PackageKit-command-not-found"
  "helix"
)

# ------------------------------------------------------------------------------
# RHEL / Fedora COPR Repositories
# Enabled (via `dnf copr enable`) before the packages above are installed, so
# tools that are not in the official Fedora repos can be listed in RHEL_TOOLS.
# Format: "owner/project"
# ------------------------------------------------------------------------------
RHEL_COPR_REPOS=(
  "atim/starship"
)

# ------------------------------------------------------------------------------
# Arch Linux Specific Tools
# Full developer suite, GUI apps, and modern CLI tools intended specifically
# for Arch-based environments (installed via Pacman).
# ------------------------------------------------------------------------------
ARCH_TOOLS=(
  "base-devel"
  "rustup"
  "cargo-binstall"
  "uv"
  "bun"
  "fnm"
  "docker"
  "biome"

  "go"
  "golangci-lint"
  "gopls"

  "openai-codex"
  "cloudflared"
  "pkgfile"
  "helix"

  "ghostty"
)

# ------------------------------------------------------------------------------
# macOS Workstation Setup
# Development runtimes, productivity GUI applications, system tweaks, and Homebrew
# specific packages intended solely for macOS environments.
# ------------------------------------------------------------------------------
MACOS_TOOLS=(
  "rustup"
  "cargo-binstall"
  "uv"
  "oven-sh/bun/bun"
  "fnm"
  "biome"
  "llvm"

  "go"
  "goimports"
  "golangci-lint"
  "gopls"
  "go-air"

  "codex"
  "docker"
  "colima"
  "sccache"
  "xo/xo/usql"
  "cloudflared"
  "helix"

  "visual-studio-code"
  "bruno"
  "dbeaver-community"
  "ghostty"

  "firefox"
  "discord"
  "iina"
  "raycast"
  "alt-tab"
  "hiddenbar"
  "pinentry-mac"

  "font-jetbrains-mono-nerd-font"
)

# ------------------------------------------------------------------------------
# Termux Android tools
# Packages suited for the Termux environment, where the package manager is pkg
# and many Linux packages are installed directly on Android devices.
# ------------------------------------------------------------------------------
TERMUX_TOOLS=(
  "rust"
  "cargo-binstall"
  "rust-analyzer"
  "build-essential"
  "nodejs-lts"
  "bun"
  "biome2"
  "uv"

  "golang"
  "gopls"
  "goimports"
  "golangci-lint"
  "air"

  "code-oss"
  "bruno"
  "ghostty"
  "firefox"
  "mousepad"
  "galculator"
  "eog"

  "codex"
  "usql"
  "helix"
  "helix-grammars"
  "gtrash"
  "cloudflared"
  "openssl-tool"
  "xdg-utils"
  "mpv-x"
  "python-yt-dlp"
)
