#!/bin/bash

# OS Check
if [ "$(uname)" = "Darwin" ]; then
    echo "This script is designed for Linux only. macOS has native support for these fonts."
    # Return if sourced, exit if executed
    (return 0 2>/dev/null) && return 0 || exit 0
fi

# Dependency Check
for cmd in wget 7z; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required tool '$cmd' is not installed. Please install it and try again." >&2
        # Return if sourced, exit if executed
        (return 0 2>/dev/null) && return 1 || exit 1
    fi
done

# Script dynamic configuration for source / execute
if (return 0 2>/dev/null); then
    # Sourced mode: variables become local to function or prefixed to avoid pollution
    set -uo pipefail
else
    # Executed mode
    set -euo pipefail
fi

_install_fonts_main() {
    local FONTS=("SF-Pro" "SF-Mono")
    local font font_name pkg_name

    for font in "${FONTS[@]}"; do
        font_name="$font"
        pkg_name="${font_name/-/ } Fonts.pkg"

        echo "Downloading ${font_name}..."
        wget -q --show-progress "https://devimages-cdn.apple.com/design/resources/download/${font_name}.dmg"

        echo "Extracting ${font_name}..."
        7z x "${font_name}.dmg" > /dev/null
        7z x "${pkg_name}" > /dev/null
        7z x Payload~ > /dev/null

        mkdir -p "$HOME/.local/share/${font_name}"
        mv Library/Fonts/* "$HOME/.local/share/${font_name}/"

        rm -rf "${font_name}.dmg" "${pkg_name}" Payload~ Library/ [[:digit:]]*
    done
}

_install_fonts_main
unset -f _install_fonts_main
