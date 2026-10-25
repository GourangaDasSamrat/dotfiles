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

	# Bold terminal-theme colours, used to tell project tools apart in chpwd.zsh
	export COLOR_BOLD_BLUE=$'\033[1;34m'
	export COLOR_BOLD_GREEN=$'\033[1;32m'
	export COLOR_BOLD_YELLOW=$'\033[1;33m'
	export COLOR_BOLD_CYAN=$'\033[1;36m'
}

# Initialize colors once
_init_colors

# Shared status printers: wrap the repeated
# "${COLOR_X}  symbol${COLOR_RESET} message" pattern used across all functions.
_ok() { print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} $1"; }
_err() { print -- "${COLOR_ERROR}  ✗${COLOR_RESET} $1"; }
_warn() { print -- "${COLOR_WARNING}  ⚠${COLOR_RESET} $1"; }
