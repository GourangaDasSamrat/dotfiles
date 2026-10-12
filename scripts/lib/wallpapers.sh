#!/bin/bash
set -euo pipefail

URLS_FILE="$HOME/dotfiles/scripts/config/wallpapers.url"
WALLPAPERS_DIR="$HOME/Pictures/wallpapers"

setup_wallpapers() {
  # Check if URLs file exists
  if [! -f "$URLS_FILE" ]; then
    echo "Error: Wallpapers URL file not found at $URLS_FILE" >&2
    return 1
  fi

  if [ -d "$WALLPAPERS_DIR" ]; then
    echo "Wallpapers directory already exists, skipping..."
  else
    echo "Downloading wallpapers..."

    # Create directory with error handling
    if! mkdir -p "$WALLPAPERS_DIR"; then
      echo "Error: Failed to create wallpapers directory at $WALLPAPERS_DIR" >&2
      return 1
    fi

    # Download wallpapers with error handling
    local downloader=""
    if command -v wget2 >/dev/null 2>&1; then
      downloader="wget2"
    elif command -v wget >/dev/null 2>&1; then
      downloader="wget"
    else
      echo "Error: Neither wget2 nor wget found. Please install wget or wget2." >&2
      return 1
    fi

    if! "$downloader" -i "$URLS_FILE" -P "$WALLPAPERS_DIR"; then
      echo "Error: Failed to download wallpapers with $downloader" >&2
      return 1
    fi

    echo "Wallpapers downloaded successfully!"
  fi
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_wallpapers
fi
