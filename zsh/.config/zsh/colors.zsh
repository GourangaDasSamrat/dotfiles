# Universal Color Palette
_init_colors() {
	# Premium color scheme
	export COLOR_HEADER=$'\033[38;5;141m'  # Purple - Headers, prompts
	export COLOR_CURSOR=$'\033[38;5;49m'   # Cyan - Cursor, selected items
	export COLOR_SUCCESS=$'\033[38;5;77m'  # Green - Success messages
	export COLOR_ERROR=$'\033[38;5;204m'   # Red - Error messages
	export COLOR_WARNING=$'\033[38;5;208m' # Orange - Warnings
	export COLOR_NORMAL=$'\033[38;5;246m'  # Gray - Unselected, secondary info
	export COLOR_TEXT=$'\033[38;5;255m'    # White - Important text
	export COLOR_BORDER=$'\033[38;5;240m'  # Dark gray - Borders
	export COLOR_RESET=$'\033[0m'          # Reset
}

# Initialize colors once
_init_colors

# fzf theme
_fzf_theme_dracula() {
	export FZF_DEFAULT_OPTS='
      --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
      --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
      --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
      --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
      --color=border:#6272a4'
}

_fzf_theme_catppuccin() {
	export FZF_DEFAULT_OPTS='
      --color=fg:#cdd6f4,bg:#1e1e2e,hl:#cba6f7
      --color=fg+:#cdd6f4,bg+:#313244,hl+:#cba6f7
      --color=info:#f38ba8,prompt:#cba6f7,pointer:#f5c2e7
      --color=marker:#a6e3a1,spinner:#f5c2e7,header:#f38ba8
      --color=border:#45475a'
}

# fzf active theme
_fzf_theme_dracula
