#!/bin/bash

# macOS GUI applications installer via Homebrew Cask
# This script installs GUI tools on macOS using brew cask
# Can be run manually or sourced from another script

# Detect the operating system
detect_os() {
    local os=$(uname -s)
    echo "$os"
}

# Main installation function
install_gui_apps() {
    local os=$(detect_os)

    # Check if running on macOS
    if [[ "$os" == "Darwin" ]]; then
        echo "✓ Running on macOS (Darwin)"
        echo "Installing GUI applications via Homebrew Cask..."

        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            echo "✗ Error: Homebrew is not installed"
            echo "Please install Homebrew first: https://brew.sh"
            return 1
        fi

        # Array of applications to install
        local apps=(
            "visual-studio-code"
            "brave-browser"
            "firefox"
	    "alacritty"
	    "applite"
        )

        # Install each application
        for app in "${apps[@]}"; do
            echo ""
            echo "Installing $app..."
            if brew install --cask "$app" 2>/dev/null; then
                echo "✓ Successfully installed $app"
            else
                echo "✗ Failed to install $app (it might already be installed)"
            fi
        done

        echo ""
        echo "✓ Installation complete!"
        return 0
    else
        echo "✗ Error: This script only runs on macOS"
        echo "Detected OS: $os"
        return 1
    fi
}

# Run the installation if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_gui_apps
    exit $?
fi
