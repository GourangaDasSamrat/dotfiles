#!/bin/bash

FONTS_DIR="$HOME/.local/share/fonts"

# Prints the name of a 7-Zip binary: `7z` (p7zip, Arch's 7zip) or `7zz` (upstream).
_find_7z() {
  local cmd
  for cmd in 7z 7zz; do
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "$cmd"
      return 0
    fi
  done
  return 1
}

# Downloads, unpacks and installs one Apple font family (e.g. "SF-Pro").
# All the work happens in a throw-away temp directory, so nothing is written
# to, or deleted from, the directory the script was started in.
_install_font() {
  local font_name="$1" sevenzip="$2"
  local pkg_name="${font_name/-/ } Fonts.pkg"
  local dest="$FONTS_DIR/$font_name"
  local workdir status=0

  if [ -n "$(ls -A "$dest" 2>/dev/null)" ]; then
    echo "${font_name} is already installed, skipping..."
    return 0
  fi

  workdir="$(mktemp -d)" || return 1

  # Explicit `|| exit 1` keeps this safe whether or not the caller uses `set -e`.
  if ! (
    cd "$workdir" || exit 1

    echo "Downloading ${font_name}..."
    curl -fL --progress-bar -o "${font_name}.dmg" \
      "https://devimages-cdn.apple.com/design/resources/download/${font_name}.dmg" || exit 1

    echo "Extracting ${font_name}..."
    "$sevenzip" x -y "${font_name}.dmg" >/dev/null || exit 1
    "$sevenzip" x -y "${pkg_name}" >/dev/null || exit 1
    "$sevenzip" x -y Payload~ >/dev/null || exit 1

    mkdir -p "$dest" || exit 1
    mv Library/Fonts/* "$dest/" || exit 1
  ); then
    status=1
  fi

  rm -rf "$workdir"
  return "$status"
}

setup_fonts() {
  if [ "$(uname)" = "Darwin" ]; then
    echo "Fonts: skipping, macOS has native support for these fonts."
    return 0
  fi

  local sevenzip font failed=0

  if ! command -v curl >/dev/null 2>&1; then
    echo "Error: Required tool 'curl' is not installed. Please install it and try again." >&2
    return 1
  fi

  if ! sevenzip="$(_find_7z)"; then
    echo "Error: Required tool '7z' (or '7zz') is not installed. Please install it and try again." >&2
    return 1
  fi

  for font in "SF-Pro" "SF-Mono"; do
    if ! _install_font "$font" "$sevenzip"; then
      echo "Error: Failed to install ${font}." >&2
      failed=1
    fi
  done

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONTS_DIR" >/dev/null 2>&1 || true
  fi

  return "$failed"
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_fonts
fi
