#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/detect.sh"

COMMON_TOOLS=(
	"curl"
	"wget"
	"eza"
	"fd|fd-find"
	"fzf"
	"stow"
	"alacritty"
	"tmux"
	"starship"
	"bat|batcat"
	"jq"
	"shfmt"
	"gh"
)
LINUX_TOOLS=("zsh" "build-essential" "rofi")
MACOS_TOOLS=() # Add macOS-specific tools here if needed in future

_is_installed() {
	local tool="$1"
	case "$PKG_MANAGER" in
	brew) brew list "$tool" &>/dev/null ;;
	apt) dpkg -l | grep -q "^ii  $tool " ;;
	pacman) pacman -Q "$tool" &>/dev/null ;;
	esac
}

_install_tool() {
	local tool="$1"

	# Handle "pkg1|pkg2" OR logic — try each name, install whichever exists in repo
	if [[ "$tool" == *"|"* ]]; then
		local candidates
		IFS='|' read -ra candidates <<<"$tool"

		for candidate in "${candidates[@]}"; do
			if _is_installed "$candidate"; then
				echo "$candidate is already installed, skipping..."
				return
			fi
		done

		# Try installing each candidate until one succeeds
		for candidate in "${candidates[@]}"; do
			echo "Trying to install $candidate..."
			case "$PKG_MANAGER" in
			brew) brew install "$candidate" && return ;;
			apt) $SUDO_CMD apt install -y "$candidate" && return ;;
			pacman) $SUDO_CMD pacman -S --noconfirm "$candidate" && return ;;
			esac
		done

		echo "Warning: Could not install any of: $tool"
		return 1
	fi

	# Normal single-tool logic
	if _is_installed "$tool"; then
		echo "$tool is already installed, skipping..."
		return
	fi
	echo "Installing $tool..."
	case "$PKG_MANAGER" in
	brew) brew install "$tool" ;;
	apt) $SUDO_CMD apt install -y "$tool" ;;
	pacman) $SUDO_CMD pacman -S --noconfirm "$tool" ;;
	esac
}

install_packages() {
	if [ "$OS" = "unsupported" ] || [ "$PKG_MANAGER" = "unsupported" ]; then
		echo "Error: Unsupported OS or package manager."
		return 1
	fi

	case "$OS" in
	macos) TOOLS=("${COMMON_TOOLS[@]}" "${MACOS_TOOLS[@]}") ;;
	linux) TOOLS=("${COMMON_TOOLS[@]}" "${LINUX_TOOLS[@]}") ;;
	esac

	echo "Updating system..."
	case "$PKG_MANAGER" in
	brew) brew update && brew upgrade ;;
	apt) $SUDO_CMD apt update && $SUDO_CMD apt upgrade -y ;;
	pacman) $SUDO_CMD pacman -Syu --noconfirm ;;
	esac

	for tool in "${TOOLS[@]}"; do
		_install_tool "$tool"
	done
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	install_packages
fi
