# Start python server with validation
serve() {
    local port=${1:-}
    
    # If no port provided, ask user
    while true; do
        if [ -z "$port" ]; then
            echo -e "${COLOR_HEADER}Enter port number (default: 8000):${COLOR_RESET} "
            read port
            # Use default if empty
            port=${port:-8000}
        fi
        
        # Validate if port is a number
        if ! [[ "$port" =~ ^[0-9]+$ ]]; then
            echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Error: Port must be a number!"
            port=""  # Reset to ask again
            continue
        fi
        
        # Validate port range (1-65535)
        if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
            echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Error: Port must be between 1 and 65535!"
            port=""
            continue
        fi
        
        # Check if port is already in use
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 ; then
            echo -e "${COLOR_WARNING}  ⚠${COLOR_RESET} Warning: Port $port is already in use!"
            echo -e "${COLOR_HEADER}Try another port?${COLOR_RESET} "
            port=""
            continue
        fi
        
        # All validations passed
        break
    done
    
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

# Backup file/folder with timestamp
backup() {
    if [ -z "$1" ]; then
        echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Usage: backup <file/folder>"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="${1}_backup_${timestamp}.tar.gz"
    
    tar -czf "$backup_name" "$1" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
    else
        echo -e "${COLOR_ERROR}  ✗${COLOR_RESET} Backup failed!"
    fi
}

