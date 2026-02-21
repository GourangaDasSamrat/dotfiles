#!/bin/bash

setup_dotfiles() {
    if [ ! -d "$HOME/dotfiles" ]; then
        echo "Warning: ~/dotfiles directory not found. Skipping stow."
        return 1
    fi

    echo "Running stow to symlink dotfiles..."
    cd "$HOME/dotfiles" || return 1

    if stow tmux vscode zsh git alacritty; then
        echo "Stow completed successfully!"

        if [ -d "$HOME/git-hooks" ]; then
            echo "Setting execute permissions for git hooks..."
            chmod +x "$HOME/git-hooks"/*
            echo "Git hooks permissions updated!"
        else
            echo "Note: ~/git-hooks not found. Skipping chmod."
        fi
    else
        echo "Error: Stow failed."
        return 1
    fi
}

# ── Run if executed directly ──────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_dotfiles
fi