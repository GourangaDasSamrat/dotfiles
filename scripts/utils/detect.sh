#!/bin/bash

# Detects OS, package manager, and sudo availability
# Usage: source this file to get OS, PKG_MANAGER, SUDO_CMD variables

detect_os() {
	OS=$(uname -s)
	case "$OS" in
	Darwin) echo "macos" ;;
	Linux) echo "linux" ;;
	*)
		echo "unsupported"
		;;
	esac
}

detect_package_manager() {
	if command -v brew &>/dev/null; then
		echo "brew"
		return
	fi
	if command -v apt &>/dev/null; then
		echo "apt"
		return
	fi
	if command -v pacman &>/dev/null; then
		echo "pacman"
		return
	fi
	echo "unsupported"
}

detect_sudo() {
	if command -v sudo &>/dev/null; then
		echo "sudo"
	else
		echo ""
	fi
}

# Export variables for use in other scripts
OS=$(detect_os)
PKG_MANAGER=$(detect_package_manager)
SUDO_CMD=$(detect_sudo)

export OS PKG_MANAGER SUDO_CMD
