# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Disable Theme
ZSH_THEME=""

# Oh My Zsh Plugins
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# BAT theme
export BAT_THEME="Dracula"

# Starship
eval "$(starship init zsh)"

# Custom alias
alias debian=TERM='xterm-256color proot-distro login debian --user gouranga'
alias df='cd ~/../usr/var/lib/proot-distro/installed-rootfs/debian/home/gouranga/'

alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias lt='eza --tree -a -I "node_modules|.git"'
alias la='ls -A'

alias code=code-oss
alias code-c='code --profile "C/C++ Dev"'
alias code-f='code --profile "Frontend Dev"'
alias code-b='code --profile "Backend Dev"'
alias code-p='code --profile "Python Dev"'

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

# Overwrite mkdir
mkdir() {
	if [ $# -eq 0 ]; then
		command mkdir
		return
	fi

	command mkdir -p "$@" || return 1

	if [ $# -ne 1 ]; then
		return 0
	fi

	local choice=2 # Default to "No"
	local key

	tput civis
	trap 'tput cnorm' EXIT

	while true; do
		echo -ne "\033[2K\r"
		echo -ne "${COLOR_HEADER}  ◆  Initialize git repository in '$1'?${COLOR_RESET}\n"

		if [ $choice -eq 1 ]; then
			echo -ne "     ${COLOR_CURSOR}› Yes${COLOR_RESET}  ${COLOR_NORMAL}No${COLOR_RESET}"
		else
			echo -ne "     ${COLOR_NORMAL}Yes${COLOR_RESET}  ${COLOR_CURSOR}› No${COLOR_RESET}"
		fi
		echo -ne "\033[1A"

		read -k1 key
		if [[ $key == $'\x1b' ]]; then
			read -k1 -t 0.01 key2
			read -k1 -t 0.01 key3
			key="$key$key2$key3"
		fi

		case "$key" in
		$'\x1b[C' | $'\x1b[D')
			if [ $choice -eq 1 ]; then choice=2; else choice=1; fi
			;;
		$'\n' | $'\r') break ;;
		'') break ;;
		esac
	done

	echo -ne "\033[2K\r\033[1B"
	tput cnorm
	trap - EXIT

	if [ $choice -eq 1 ]; then
		(
			cd "$1" || exit
			git init -q
			echo "# $1" >README.md
			git add .
			git commit -m "Initial commit" -q
			echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Initialized git repo in ${COLOR_NORMAL}$(pwd)/.git/${COLOR_RESET}"
		)
	else
		echo -e "${COLOR_NORMAL}  ○ Created folder without git${COLOR_RESET}"
	fi
}

# Overwrite rm -rf
rm() {
	if [ $# -eq 0 ]; then
		echo "Usage: rm <file or folder>"
		return 1
	fi

	local flags=()
	local targets=()

	for arg in "$@"; do
		if [[ "$arg" == -* ]]; then
			flags+=("$arg")
		else
			targets+=("$arg")
		fi
	done

	if [ ${#targets[@]} -eq 0 ]; then
		command rm "${flags[@]}"
		return
	fi

	echo
	echo -e "${COLOR_WARNING}  ⚠  About to delete:${COLOR_RESET}"
	echo
	for item in "${targets[@]}"; do
		if [ -d "$item" ]; then
			echo -e "    ${COLOR_TEXT}📁 $item${COLOR_RESET}"
		elif [ -f "$item" ]; then
			echo -e "    ${COLOR_TEXT}📄 $item${COLOR_RESET}"
		else
			echo -e "    ${COLOR_TEXT}❓ $item${COLOR_RESET}"
		fi
	done
	echo

	local choice=2 # Default to "No"
	local key

	tput civis
	trap 'tput cnorm' EXIT

	while true; do
		echo -ne "\033[2K\r"
		echo -ne "${COLOR_HEADER}  ◆  Confirm deletion?${COLOR_RESET}\n"

		if [ $choice -eq 1 ]; then
			echo -ne "     ${COLOR_CURSOR}› Yes${COLOR_RESET}  ${COLOR_NORMAL}No${COLOR_RESET}"
		else
			echo -ne "     ${COLOR_NORMAL}Yes${COLOR_RESET}  ${COLOR_CURSOR}› No${COLOR_RESET}"
		fi
		echo -ne "\033[1A"

		read -k1 key
		if [[ $key == $'\x1b' ]]; then
			read -k1 -t 0.01 key2
			read -k1 -t 0.01 key3
			key="$key$key2$key3"
		fi

		case "$key" in
		$'\x1b[C' | $'\x1b[D')
			if [ $choice -eq 1 ]; then choice=2; else choice=1; fi
			;;
		$'\n' | $'\r') break ;;
		'') break ;;
		esac
	done

	echo -ne "\033[2K\r\033[1B"
	tput cnorm
	trap - EXIT

	if [ $choice -eq 1 ]; then
		command rm "${flags[@]}" "${targets[@]}"
		echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Deleted successfully"
	else
		echo -e "${COLOR_NORMAL}  ○ Cancelled${COLOR_RESET}"
	fi
	echo
}

# Universal extractor
extract() {
	if [ -f "$1" ]; then
		case "$1" in
		*.tar.* | *.tgz | *.tbz2 | *.txz)
			tar xvf "$1" && echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Extracted ${COLOR_TEXT}'$1'${COLOR_RESET}"
			;;
		*.zip)
			unzip "$1" && echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Extracted ${COLOR_TEXT}'$1'${COLOR_RESET}"
			;;
		*)
			echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Unsupported format"
			return 1
			;;
		esac
	else
		echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} File not found: ${COLOR_TEXT}'$1'${COLOR_RESET}"
		return 1
	fi
}

# Universal compressor
compress() {
	if [ -z "$1" ]; then
		echo "📦 Usage: compress <file_or_dir>"
		return 1
	fi
	local input=$1
	if [ ! -e "$input" ]; then
		echo "❌ '$input' does not exist!"
		return 1
	fi

	local -a options=(
		"tar.gz   → Good balance, common"
		"tar.bz2  → Better compression, slower"
		"tar.xz   → Best compression, slowest"
		"zip      → Cross-platform"
		"7z       → High compression"
		"gz       → Single file only"
		"bz2      → Single file only"
	)

	local selected=1
	local key key2 key3 i

	tput civis
	trap 'tput cnorm' EXIT

	while true; do
		printf "\033[2J\033[H"
		echo
		echo -e "${COLOR_HEADER}  ◆  Select compression format${COLOR_RESET}"
		echo -e "${COLOR_BORDER}  ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${COLOR_RESET}"
		echo

		for ((i = 1; i <= ${#options[@]}; i++)); do
			if ((i == selected)); then
				echo -e "${COLOR_CURSOR}  ›${COLOR_RESET} ${COLOR_TEXT}${options[i - 1]}${COLOR_RESET}"
			else
				echo -e "    ${COLOR_NORMAL}${options[i - 1]}${COLOR_RESET}"
			fi
		done

		echo
		echo -e "${COLOR_BORDER}  ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${COLOR_RESET}"
		echo -e "${COLOR_NORMAL}  ↑/↓ to select • Enter to confirm${COLOR_RESET}"

		read -k1 key
		if [[ $key == $'\x1b' ]]; then
			read -k1 key2
			read -k1 key3
			key="$key$key2$key3"
		fi

		case "$key" in
		$'\x1b[A')
			((selected--))
			((selected < 1)) && selected=${#options[@]}
			;;
		$'\x1b[B')
			((selected++))
			((selected > ${#options[@]})) && selected=1
			;;
		$'\n' | $'\r') break ;;
		'') break ;;
		esac
	done

	tput cnorm
	trap - EXIT

	local format="${options[selected - 1]%% *}"
	local output="${input%/}.${format}"

	echo
	echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Compressing ${COLOR_TEXT}'$input'${COLOR_RESET} → ${COLOR_SUCCESS}'$output'${COLOR_RESET}"

	case "$format" in
	tar.gz) tar czf "$output" "$input" ;;
	tar.bz2) tar cjf "$output" "$input" ;;
	tar.xz) tar cJf "$output" "$input" ;;
	zip) zip -r "$output" "$input" ;;
	7z) 7z a "$output" "$input" ;;
	gz)
		if [ -f "$input" ]; then
			gzip -c "$input" >"$output"
		else
			echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} .gz only supports single files!"
			return 1
		fi
		;;
	bz2)
		if [ -f "$input" ]; then
			bzip2 -c "$input" >"$output"
		else
			echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} .bz2 only supports single files!"
			return 1
		fi
		;;
	esac

	echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} ${COLOR_TEXT}Done!${COLOR_RESET} Created: ${COLOR_SUCCESS}$output${COLOR_RESET}"
	echo
}

# Start python server
serve() {
	port=${1:-8000}
	echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
	python3 -m http.server "$port"
}

# File finder with preview
ff() {
	local search_term="$1"
	if [ -z "$search_term" ]; then
		echo "Usage: ff <search_term>"
		return 1
	fi
	echo -e "${COLOR_HEADER}  ◆  Searching for '$search_term'${COLOR_RESET}"
	find . -iname "*$search_term*" -type f 2>/dev/null | while read file; do
		echo -e "    ${COLOR_SUCCESS}→${COLOR_RESET} ${COLOR_TEXT}$file${COLOR_RESET}"
	done
}

# Timer
timer() {
	local total_seconds=$1

	if [ -z "$total_seconds" ]; then
		echo "Usage: timer <seconds>"
		echo "Examples: timer 60, timer 5m, timer 2h30m"
		return 1
	fi

	# Parse time format (supports: 60, 5m, 2h, 1h30m45s)
	if [[ "$total_seconds" =~ ^[0-9]+$ ]]; then
		# Just seconds
		total_seconds=$total_seconds
	else
		local parsed_seconds=0
		if [[ "$total_seconds" =~ ([0-9]+)h ]]; then
			parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]} * 3600))
		fi
		if [[ "$total_seconds" =~ ([0-9]+)m ]]; then
			parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]} * 60))
		fi
		if [[ "$total_seconds" =~ ([0-9]+)s ]]; then
			parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]}))
		fi
		total_seconds=$parsed_seconds
	fi

	if [ $total_seconds -le 0 ]; then
		echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Invalid time"
		return 1
	fi

	local remaining=$total_seconds

	# Hide cursor
	tput civis
	trap 'tput cnorm; printf "\n"' EXIT INT TERM

	# Clear screen
	printf "\033[2J\033[H"

	while [ $remaining -ge 0 ]; do
		local hours=$((remaining / 3600))
		local minutes=$(((remaining % 3600) / 60))
		local seconds=$((remaining % 60))

		# Calculate progress
		local progress=$((100 - (remaining * 100 / total_seconds)))
		local bar_width=40
		local filled=$((progress * bar_width / 100))
		local empty=$((bar_width - filled))

		# Progress bar
		local bar=""
		for ((i = 0; i < filled; i++)); do bar+="█"; done
		for ((i = 0; i < empty; i++)); do bar+="░"; done

		# Choose color based on time remaining
		local time_color=$COLOR_SUCCESS
		if [ $remaining -le $((total_seconds / 4)) ]; then
			time_color=$COLOR_ERROR
		elif [ $remaining -le $((total_seconds / 2)) ]; then
			time_color=$COLOR_WARNING
		fi

		# Animated spinner
		local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
		local spin_index=$((remaining % ${#spinner[@]}))

		# Clear and draw
		printf "\033[H"
		echo
		echo -e "${COLOR_HEADER}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
		echo -e "${COLOR_HEADER}  │${COLOR_RESET}              ${COLOR_CURSOR}⏱  COUNTDOWN TIMER${COLOR_RESET}              ${COLOR_HEADER}│${COLOR_RESET}"
		echo -e "${COLOR_HEADER}  └─────────────────────────────────────────────┘${COLOR_RESET}"
		echo
		echo

		# Big clock display
		printf "              "
		if [ $hours -gt 0 ]; then
			printf "${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $hours $minutes $seconds
		else
			printf "    ${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $minutes $seconds
		fi
		echo
		echo

		# Progress bar
		echo -e "     ${COLOR_BORDER}┤${COLOR_RESET}${bar}${COLOR_BORDER}├${COLOR_RESET} ${COLOR_CURSOR}${progress}%${COLOR_RESET}"
		echo
		echo

		# Status message with spinner
		if [ $remaining -eq 0 ]; then
			echo -e "        ${COLOR_SUCCESS}✓  Time's up!${COLOR_RESET}                      "
		else
			local elapsed=$((total_seconds - remaining))
			local elapsed_m=$((elapsed / 60))
			local elapsed_s=$((elapsed % 60))
			echo -e "        ${spinner[$spin_index]}  Elapsed: ${COLOR_NORMAL}${elapsed_m}m ${elapsed_s}s${COLOR_RESET}              "
		fi

		echo
		echo -e "${COLOR_BORDER}  ─────────────────────────────────────────────${COLOR_RESET}"
		echo -e "        ${COLOR_NORMAL}Press Ctrl+C to cancel${COLOR_RESET}"

		if [ $remaining -eq 0 ]; then
			break
		fi

		sleep 1
		((remaining--))
	done

	# Sound notification when timer completes
	# Terminal bell (works everywhere)
	printf '\a'

	# Try desktop notification if available
	if command -v notify-send &>/dev/null; then
		notify-send "Timer" "Time's up! ⏰" --urgency=critical 2>/dev/null &
	fi

	# Try to play sound if available (silent fail)
	if command -v paplay &>/dev/null; then
		if [ -f /usr/share/sounds/freedesktop/stereo/complete.oga ]; then
			paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &
		elif [ -f /usr/share/sounds/freedesktop/stereo/bell.oga ]; then
			paplay /usr/share/sounds/freedesktop/stereo/bell.oga &>/dev/null &
		fi
	elif command -v aplay &>/dev/null && [ -f /usr/share/sounds/alsa/Front_Center.wav ]; then
		aplay /usr/share/sounds/alsa/Front_Center.wav &>/dev/null &
	fi

	# Restore cursor
	tput cnorm
	trap - EXIT INT TERM

	# Celebration
	echo
	echo -e "${COLOR_SUCCESS}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
	echo -e "${COLOR_SUCCESS}  │${COLOR_RESET}                  ${COLOR_SUCCESS}🎉 DONE! 🎉${COLOR_RESET}                  ${COLOR_SUCCESS}│${COLOR_RESET}"
	echo -e "${COLOR_SUCCESS}  └─────────────────────────────────────────────┘${COLOR_RESET}"
	echo
}

# Weather
weather() {
	local city=${1:-Khulna}

	# Check if jq is available
	if ! command -v jq &>/dev/null; then
		echo -e "${COLOR_WARNING}  ⚠  Installing 'jq' recommended for better output${COLOR_RESET}"
		echo -e "${COLOR_NORMAL}  Install with: ${COLOR_CURSOR}sudo apt install jq${COLOR_RESET} or ${COLOR_CURSOR}sudo pacman -S jq${COLOR_RESET}"
		echo

		# Fallback to simple format
		echo -e "${COLOR_HEADER}  ╔═══════════════════════════════════════════════════╗${COLOR_RESET}"
		echo -e "${COLOR_HEADER}  ║${COLOR_RESET}                🌤️  ${COLOR_TEXT}WEATHER REPORT${COLOR_RESET}  ${COLOR_HEADER}║${COLOR_RESET}"
		echo -e "${COLOR_HEADER}  ╚═══════════════════════════════════════════════════╝${COLOR_RESET}"
		echo
		echo -e "  ${COLOR_CURSOR}📍 Location:${COLOR_RESET} ${COLOR_TEXT}$city${COLOR_RESET}"
		echo
		curl -s "wttr.in/$city?0QF"
		echo
		return 0
	fi

	echo -e "${COLOR_HEADER}  ◆  Fetching weather data...${COLOR_RESET}"

	# Fetch weather data in JSON format
	local weather_data
	weather_data=$(curl -s "wttr.in/$city?format=j1" 2>/dev/null)

	# Check if data is valid
	if [ -z "$weather_data" ]; then
		echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Failed to fetch weather data. Check your internet connection."
		return 1
	fi

	# Check for error in response
	if echo "$weather_data" | grep -q "Unknown location"; then
		echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Unknown location: ${COLOR_TEXT}'$city'${COLOR_RESET}"
		echo -e "${COLOR_NORMAL}  Try: weather \"New York\" or weather Dhaka${COLOR_RESET}"
		return 1
	fi

	# Parse JSON data using jq
	local temp=$(echo "$weather_data" | jq -r '.current_condition[0].temp_C // "N/A"' 2>/dev/null)
	local feels_like=$(echo "$weather_data" | jq -r '.current_condition[0].FeelsLikeC // "N/A"' 2>/dev/null)
	local humidity=$(echo "$weather_data" | jq -r '.current_condition[0].humidity // "N/A"' 2>/dev/null)
	local wind_speed=$(echo "$weather_data" | jq -r '.current_condition[0].windspeedKmph // "N/A"' 2>/dev/null)
	local wind_dir=$(echo "$weather_data" | jq -r '.current_condition[0].winddir16Point // "N/A"' 2>/dev/null)
	local pressure=$(echo "$weather_data" | jq -r '.current_condition[0].pressure // "N/A"' 2>/dev/null)
	local visibility=$(echo "$weather_data" | jq -r '.current_condition[0].visibility // "N/A"' 2>/dev/null)
	local uv_index=$(echo "$weather_data" | jq -r '.current_condition[0].uvIndex // "N/A"' 2>/dev/null)
	local description=$(echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value // "N/A"' 2>/dev/null)

	# Validate parsed data
	if [ "$temp" = "N/A" ] || [ -z "$temp" ]; then
		echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Failed to parse weather data"
		return 1
	fi

	# Get weather icon
	local weather_icon="🌤️"
	case "$description" in
	*[Cc]lear* | *[Ss]unny*) weather_icon="☀️" ;;
	*[Cc]loudy* | *[Oo]vercast*) weather_icon="☁️" ;;
	*[Pp]artly*) weather_icon="⛅" ;;
	*[Rr]ain* | *[Ss]hower* | *[Dd]rizzle*) weather_icon="🌧️" ;;
	*[Tt]hunder*) weather_icon="⛈️" ;;
	*[Ss]now*) weather_icon="❄️" ;;
	*[Ff]og* | *[Mm]ist* | *[Hh]aze*) weather_icon="🌫️" ;;
	esac

	# Temperature color coding
	local temp_color=$COLOR_SUCCESS
	if [ "$temp" -ge 35 ]; then
		temp_color=$COLOR_ERROR
	elif [ "$temp" -ge 25 ]; then
		temp_color=$COLOR_WARNING
	elif [ "$temp" -le 10 ]; then
		temp_color=$COLOR_CURSOR
	fi

	# Clear screen and display
	clear
	echo
	echo -e "${COLOR_HEADER}  ╔═══════════════════════════════════════════════════╗${COLOR_RESET}"
	echo -e "${COLOR_HEADER}  ║${COLOR_RESET}                ${weather_icon}  ${COLOR_TEXT}WEATHER REPORT${COLOR_RESET}                 ${COLOR_HEADER}║${COLOR_RESET}"
	echo -e "${COLOR_HEADER}  ╚═══════════════════════════════════════════════════╝${COLOR_RESET}"
	echo

	# Location
	echo -e "  ${COLOR_BORDER}┌─────────────────────────────────────────────────┐${COLOR_RESET}"
	echo -e "  ${COLOR_BORDER}│${COLOR_RESET}  ${COLOR_CURSOR}📍 Location${COLOR_RESET}                                   ${COLOR_BORDER}│${COLOR_RESET}"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_TEXT}%-40s${COLOR_RESET}  ${COLOR_BORDER}│${COLOR_RESET}\n" "$city"
	echo -e "  ${COLOR_BORDER}└─────────────────────────────────────────────────┘${COLOR_RESET}"
	echo

	# Current conditions
	echo -e "  ${COLOR_BORDER}┌─────────────────────────────────────────────────┐${COLOR_RESET}"
	echo -e "  ${COLOR_BORDER}│${COLOR_RESET}  ${COLOR_CURSOR}🌡️  Current Conditions${COLOR_RESET}                       ${COLOR_BORDER}│${COLOR_RESET}"
	echo -e "  ${COLOR_BORDER}│${COLOR_RESET}                                                 ${COLOR_BORDER}│${COLOR_RESET}"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}Condition:${COLOR_RESET}   %-30s  ${COLOR_BORDER}│${COLOR_RESET}\n" "$description"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}Temperature:${COLOR_RESET}  ${temp_color}%-3s°C${COLOR_RESET}                              ${COLOR_BORDER}│${COLOR_RESET}\n" "$temp"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}Feels Like:${COLOR_RESET}   ${COLOR_TEXT}%-3s°C${COLOR_RESET}                              ${COLOR_BORDER}│${COLOR_RESET}\n" "$feels_like"
	echo -e "  ${COLOR_BORDER}└─────────────────────────────────────────────────┘${COLOR_RESET}"
	echo

	# Temperature visualization
	local temp_int=${temp%.*}
	local bar_length=$((temp_int > 50 ? 50 : temp_int < 0 ? 0 : temp_int))
	local temp_bar=""
	for ((i = 0; i < bar_length; i++)); do
		if [ $i -lt 10 ]; then
			temp_bar+="${COLOR_CURSOR}█${COLOR_RESET}"
		elif [ $i -lt 25 ]; then
			temp_bar+="${COLOR_SUCCESS}█${COLOR_RESET}"
		elif [ $i -lt 35 ]; then
			temp_bar+="${COLOR_WARNING}█${COLOR_RESET}"
		else
			temp_bar+="${COLOR_ERROR}█${COLOR_RESET}"
		fi
	done

	echo -e "  ${COLOR_BORDER}┌─────────────────────────────────────────────────┐${COLOR_RESET}"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}  %-52s${COLOR_BORDER}│${COLOR_RESET}\n" "$temp_bar"
	echo -e "  ${COLOR_BORDER}│${COLOR_RESET}  ${COLOR_CURSOR}0°${COLOR_RESET}     ${COLOR_SUCCESS}15°${COLOR_RESET}     ${COLOR_WARNING}30°${COLOR_RESET}     ${COLOR_ERROR}45°${COLOR_RESET}                   ${COLOR_BORDER}│${COLOR_RESET}"
	echo -e "  ${COLOR_BORDER}└─────────────────────────────────────────────────┘${COLOR_RESET}"
	echo

	# Additional details
	echo -e "  ${COLOR_BORDER}┌─────────────────────────────────────────────────┐${COLOR_RESET}"
	echo -e "  ${COLOR_BORDER}│${COLOR_RESET}  ${COLOR_CURSOR}📊 Details${COLOR_RESET}                                    ${COLOR_BORDER}│${COLOR_RESET}"
	echo -e "  ${COLOR_BORDER}│${COLOR_RESET}                                                 ${COLOR_BORDER}│${COLOR_RESET}"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}💧 Humidity:${COLOR_RESET}     ${COLOR_TEXT}%-4s%%${COLOR_RESET}                         ${COLOR_BORDER}│${COLOR_RESET}\n" "$humidity"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}💨 Wind:${COLOR_RESET}         ${COLOR_TEXT}%-4s km/h %-3s${COLOR_RESET}                  ${COLOR_BORDER}│${COLOR_RESET}\n" "$wind_speed" "$wind_dir"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}🔽 Pressure:${COLOR_RESET}     ${COLOR_TEXT}%-6s mb${COLOR_RESET}                       ${COLOR_BORDER}│${COLOR_RESET}\n" "$pressure"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}👁️  Visibility:${COLOR_RESET}   ${COLOR_TEXT}%-4s km${COLOR_RESET}                         ${COLOR_BORDER}│${COLOR_RESET}\n" "$visibility"
	printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_NORMAL}☀️  UV Index:${COLOR_RESET}     ${COLOR_TEXT}%-2s${COLOR_RESET}                             ${COLOR_BORDER}│${COLOR_RESET}\n" "$uv_index"
	echo -e "  ${COLOR_BORDER}└─────────────────────────────────────────────────┘${COLOR_RESET}"
	echo

	# Forecast
	echo -e "${COLOR_HEADER}  ╔═══════════════════════════════════════════════════╗${COLOR_RESET}"
	echo -e "${COLOR_HEADER}  ║${COLOR_RESET}                  ${COLOR_TEXT}3-DAY FORECAST${COLOR_RESET}                  ${COLOR_HEADER}║${COLOR_RESET}"
	echo -e "${COLOR_HEADER}  ╚═══════════════════════════════════════════════════╝${COLOR_RESET}"
	echo

	# Parse 3-day forecast
	for day in 0 1 2; do
		local day_name=""
		case $day in
		0) day_name="Today    " ;;
		1) day_name="Tomorrow " ;;
		2) day_name="Day After" ;;
		esac

		local f_date=$(echo "$weather_data" | jq -r ".weather[$day].date // \"N/A\"" 2>/dev/null)
		local f_condition=$(echo "$weather_data" | jq -r ".weather[$day].hourly[4].weatherDesc[0].value // \"N/A\"" 2>/dev/null)
		local f_max=$(echo "$weather_data" | jq -r ".weather[$day].maxtempC // \"N/A\"" 2>/dev/null)
		local f_min=$(echo "$weather_data" | jq -r ".weather[$day].mintempC // \"N/A\"" 2>/dev/null)

		# Get icon for forecast
		local f_icon="🌤️"
		case "$f_condition" in
		*[Cc]lear* | *[Ss]unny*) f_icon="☀️" ;;
		*[Cc]loudy* | *[Oo]vercast*) f_icon="☁️" ;;
		*[Pp]artly*) f_icon="⛅" ;;
		*[Rr]ain*) f_icon="🌧️" ;;
		*[Tt]hunder*) f_icon="⛈️" ;;
		*[Ss]now*) f_icon="❄️" ;;
		esac

		echo -e "  ${COLOR_BORDER}┌─────────────────────────────────────────────────┐${COLOR_RESET}"
		printf "  ${COLOR_BORDER}│${COLOR_RESET}  ${f_icon}  ${COLOR_CURSOR}${day_name}${COLOR_RESET} ${COLOR_NORMAL}(${f_date})${COLOR_RESET}%*s${COLOR_BORDER}│${COLOR_RESET}\n" $((30 - ${#f_date})) ""
		printf "  ${COLOR_BORDER}│${COLOR_RESET}     %-42s  ${COLOR_BORDER}│${COLOR_RESET}\n" "$f_condition"
		printf "  ${COLOR_BORDER}│${COLOR_RESET}     ${COLOR_CURSOR}Low: ${f_min}°C${COLOR_RESET}  ${COLOR_ERROR}High: ${f_max}°C${COLOR_RESET}%*s${COLOR_BORDER}│${COLOR_RESET}\n" $((24 - ${#f_min} - ${#f_max})) ""
		echo -e "  ${COLOR_BORDER}└─────────────────────────────────────────────────┘${COLOR_RESET}"
		echo
	done

	# Footer with timestamp
	local current_time=$(date "+%A, %B %d, %Y • %I:%M %p")
	echo -e "${COLOR_BORDER}  ─────────────────────────────────────────────────${COLOR_RESET}"
	echo -e "  ${COLOR_NORMAL}Updated: $current_time${COLOR_RESET}"
	echo -e "  ${COLOR_NORMAL}Source: wttr.in${COLOR_RESET}"
	echo
}
