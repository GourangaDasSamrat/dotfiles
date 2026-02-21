#!/bin/bash

WALLPAPERS_DIR="$HOME/Pictures/wallpapers"

setup_wallpapers() {
	if [ -d "$WALLPAPERS_DIR" ]; then
		echo "Wallpapers directory already exists, skipping clone..."
	else
		echo "Cloning wallpapers repository..."
		mkdir -p "$HOME/Pictures"
		git clone --depth 1 https://github.com/blueisharch/wallpapers.git "$WALLPAPERS_DIR"
		echo "Wallpapers cloned successfully!"
	fi
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	setup_wallpapers
fi
