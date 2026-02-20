#!/bin/bash

# Define common tools for both OS
COMMON_TOOLS=("alacritty" "bat" "eza" "starship" "stow" "jq" "tmux" "git-lfs")

# Define OS-specific tools
LINUX_TOOLS=("zsh" "build-essential" "rofi")
MACOS_TOOLS=() # Add macOS-specific tools here if needed in future

# Check operating system
OS=$(uname -s)

case "$OS" in
Darwin)
	# macOS
	echo "Updating Homebrew..."
	brew update && brew upgrade

	# Merge common and macOS-specific tools
	TOOLS=("${COMMON_TOOLS[@]}" "${MACOS_TOOLS[@]}")

	for tool in "${TOOLS[@]}"; do
		if brew list "$tool" &>/dev/null; then
			echo "$tool is already installed, skipping..."
		else
			echo "Installing $tool..."
			brew install "$tool"
		fi
	done
	;;

Linux)
	# Merge common and Linux-specific tools
	TOOLS=("${COMMON_TOOLS[@]}" "${LINUX_TOOLS[@]}")

	# Set SUDO_CMD based on sudo availability
	if command -v sudo &>/dev/null; then
		SUDO_CMD="sudo"
	else
		SUDO_CMD=""
	fi

	# Check package manager and install tools
	if command -v apt &>/dev/null; then
		echo "Updating system with apt..."
		$SUDO_CMD apt update && $SUDO_CMD apt upgrade -y

		for tool in "${TOOLS[@]}"; do
			if dpkg -l | grep -q "^ii  $tool "; then
				echo "$tool is already installed, skipping..."
			else
				echo "Installing $tool..."
				$SUDO_CMD apt install -y "$tool"
			fi
		done

	elif command -v pacman &>/dev/null; then
		echo "Updating system with pacman..."
		$SUDO_CMD pacman -Syu --noconfirm

		for tool in "${TOOLS[@]}"; do
			if pacman -Q "$tool" &>/dev/null; then
				echo "$tool is already installed, skipping..."
			else
				echo "Installing $tool..."
				$SUDO_CMD pacman -S --noconfirm "$tool"
			fi
		done
	fi
	;;

*)
	echo "Unsupported operating system: $OS"
	exit 1
	;;
esac

# Post-installation setup (common for both macOS and Linux)
echo "Running post-installation setup..."

if [ -d "$HOME/.oh-my-zsh" ]; then
	echo "Oh My Zsh is already installed, skipping..."
else
	echo "Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
	echo "TPM is already installed, skipping..."
else
	echo "Installing TPM (Tmux Plugin Manager)..."
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	echo "zsh-autosuggestions is already installed, skipping..."
else
	echo "Installing zsh-autosuggestions..."
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
	echo "zsh-syntax-highlighting is already installed, skipping..."
else
	echo "Installing zsh-syntax-highlighting..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Run stow command in ~/dotfiles directory
if [ -d "$HOME/dotfiles" ]; then
	echo "Running stow to symlink dotfiles..."
	cd "$HOME/dotfiles" || exit 1

	if stow tmux vscode zsh wallpapers git alacritty; then
		echo "Stow completed successfully!"

		# Make git hooks executable if the directory exists
		if [ -d "$HOME/git-hooks" ]; then
			echo "Setting execute permissions for git hooks..."
			chmod +x "$HOME/git-hooks"/*
			echo "Git hooks permissions updated!"
		else
			echo "Note: ~/git-hooks directory not found. Skipping chmod."
		fi
	else
		echo "Error: Stow command failed. Skipping git-hooks chmod."
		exit 1
	fi
else
	echo "Warning: ~/dotfiles directory not found. Skipping stow command."
fi

echo "Installation complete!"
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
