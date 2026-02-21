#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/packages.sh"
source "$SCRIPT_DIR/lib/plugins.sh"
source "$SCRIPT_DIR/lib/wallpapers.sh"
source "$SCRIPT_DIR/lib/dotfiles.sh"

install_packages
install_plugins
setup_wallpapers
setup_dotfiles

echo ""
echo "Installation complete!"
echo "Note: Run 'source ~/.zshrc' or restart your terminal to apply changes."
