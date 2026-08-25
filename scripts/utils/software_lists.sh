#!/bin/bash

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
  "wget"
  "jq"

  "fd|fd-find"
  "ripgrep"
  "fzf"
  "eza"
  "bat|batcat"

  "shfmt"
  "just"
  "moreutils"
  "stow"

  "gh"
  "git-lfs"
  "git-delta"

  "pass"

  "starship"
  "helix"
  "httpie"

  "mpv"
  "whois"
  "openssl"
)

# ------------------------------------------------------------------------------
# Common Linux Tools
# Packages required for standard desktop and interactive terminal sessions
# across all modern Linux distributions (Debian/Ubuntu, Arch, RHEL/Fedora).
# ------------------------------------------------------------------------------
LINUX_COMMON_TOOLS=(
  "zsh"
  "pinentry-gnome3"
  "rofi"
)

# ------------------------------------------------------------------------------
# Debian/Ubuntu & Arch Linux Build Tools
# Essential build dependencies and development tools shared by Debian-based
# systems (Apt) and Arch Linux (Pacman).
# ------------------------------------------------------------------------------
DEB_ARCH_TOOLS=("build-essential|base-devel")

# ------------------------------------------------------------------------------
# RHEL / Fedora / CentOS Tools
# Development packages and system tools specific to RPM-based distributions
# using the DNF package manager.
# ------------------------------------------------------------------------------
RHEL_TOOLS=(
  "@development-tools"
  "openssl-devel"
)

# ------------------------------------------------------------------------------
# Arch Linux Specific Tools
# Full developer suite, GUI apps, and modern CLI tools intended specifically
# for Arch-based environments (installed via Pacman).
# ------------------------------------------------------------------------------
ARCH_TOOLS=(
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
  "goreleaser"

  "cloudflared"
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
  "docker"
  "colima"

  "go"
  "goimports"
  "golangci-lint"
  "gopls"
  "go-air"
  "gotests"
  "govulncheck"
  "goreleaser"

  "cloudflared"

  "visual-studio-code"
  "bruno"
  "tableplus"
  "kitty"

  "zen"
  "notion"
  "discord"
  "iina"

  "pinentry-mac"
  "raycast"
  "alt-tab"
  "hiddenbar"
  "google-drive"

  "font-jetbrains-mono-nerd-font"
)

# ------------------------------------------------------------------------------
# Termux Android tools
# Packages suited for the Termux environment, where the package manager is pkg
# and many Linux packages are installed directly on Android devices.
# ------------------------------------------------------------------------------
TERMUX_TOOLS=(
  "build-essential"
  "nodejs-lts"
  "uv"
  "biome2"

  "golang"
  "goapls"
  "goimports"
  "golangci-lint"
  "air"

  "rust"
  "cargo-binstall"
  "rust-analyzer"

  "zen-browser"
  "code-oss"
  "mousepad"
  "eog"
  "galculator"
  "helix-grammars"
)
