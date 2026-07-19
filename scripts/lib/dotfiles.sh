#!/bin/bash

setup_dotfiles() {
  if [ ! -d "$HOME/dotfiles" ]; then
    echo "Warning: ~/dotfiles directory not found. Skipping stow."
    return 1
  fi

  echo "Running stow to symlink dotfiles..."
  cd "$HOME/dotfiles" || return 1

  # Default packages list for GNU Stow
  local packages=(zsh bash git gh kitty usql mongosh cspell)

  # OS detection using uname
  if [ "$(uname)" == "Darwin" ]; then
    echo "OS: macOS (Darwin) detected."

    # Ensure the specific macOS directory structure exists for VS Code
    local mac_vscode_dir="vscode-mac/Library/Application Support/Code"
    if [ ! -d "$mac_vscode_dir/User" ]; then
      echo "Setting up macOS specific VS Code directory structure..."
      mkdir -p "$mac_vscode_dir"
      # Symlink the generic VS Code config to the macOS stow structure
      ln -sfn "$HOME/dotfiles/vscode/.config/Visual Studio Code/User" "$mac_vscode_dir/User"
    fi

    # Append macOS-specific package instead of generic vscode
    packages+=(vscode-mac)
  else
    echo "OS: Linux/Other detected."
    # Append standard vscode package for Linux/other systems
    packages+=(vscode)
  fi

  # Execute Stow with the dynamically constructed package list
  if stow "${packages[@]}"; then
    echo "Stow completed successfully for: ${packages[*]}"

    if [ -d "$HOME/.git-hooks" ]; then
      echo "Setting execute permissions for git hooks..."
      chmod +x "$HOME/.git-hooks"/*
      echo "Git hooks permissions updated!"
    else
      echo "Note: ~/.git-hooks not found. Skipping chmod."
    fi
  else
    echo "Error: Stow failed."
    return 1
  fi
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_dotfiles
fi
