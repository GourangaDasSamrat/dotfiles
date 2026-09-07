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
