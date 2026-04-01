#!/bin/bash

URLS_FILE="$HOME/dotfiles/scripts/config/urls.txt"
WALLPAPERS_DIR="$HOME/Pictures/wallpapers"

setup_wallpapers() {
    if [ -d "$WALLPAPERS_DIR" ]; then
        echo "Wallpapers directory already exists, skipping..."
    else
        echo "Downloading wallpapers..."
        mkdir -p "$WALLPAPERS_DIR"
        wget -i "$URLS_FILE" -P "$WALLPAPERS_DIR"
        echo "Wallpapers downloaded successfully!"
    fi
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	setup_wallpapers
fi
