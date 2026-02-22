# Start python server with validation
serve() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  serve — Start a Python HTTP server${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    serve [port]${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    port${COLOR_RESET}    ${COLOR_NORMAL}Port number to listen on (1–65535, default: 8000)${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    serve           → starts on port 8000${COLOR_RESET}"
		echo "${COLOR_NORMAL}    serve 3000      → starts on port 3000${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  NOTES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Validates port range and checks if already in use${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Prompts for a new port if the given one is occupied${COLOR_RESET}"
		echo ""
		return 0
	fi

	local port=${1:-}

	while true; do
		if [ -z "$port" ]; then
			echo "${COLOR_HEADER}  Enter port number (default: 8000):${COLOR_RESET} "
			read port
			port=${port:-8000}
		fi

		if ! [[ "$port" =~ ^[0-9]+$ ]]; then
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be a number!"
			port=""
			continue
		fi

		if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be between 1 and 65535!"
			port=""
			continue
		fi

		if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
			echo "${COLOR_WARNING}  ⚠${COLOR_RESET} Port $port is already in use!"
			echo "${COLOR_HEADER}  Try another port:${COLOR_RESET} "
			port=""
			continue
		fi

		break
	done

	echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
	python3 -m http.server "$port"
}

# File finder with preview
ff() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  ff — Find files by name${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff <search_term>${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    search_term${COLOR_RESET}    ${COLOR_NORMAL}Filename or partial name to search for${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff config         → finds all files with 'config' in name${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff .env           → finds all .env files${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff README         → finds all README files${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  NOTES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Searches recursively from current directory${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Case-insensitive matching${COLOR_RESET}"
		echo ""
		return 0
	fi

	if [ -z "$1" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: ff <search_term>"
		echo "${COLOR_NORMAL}    Run 'ff --help' for more info${COLOR_RESET}"
		return 1
	fi

	echo "${COLOR_HEADER}  ◆  Searching for '$1'${COLOR_RESET}"
	find . -iname "*$1*" -type f 2>/dev/null | while read file; do
		echo "    ${COLOR_SUCCESS}→${COLOR_RESET} ${COLOR_TEXT}$file${COLOR_RESET}"
	done
}

# Timer
timer() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  timer — Countdown timer${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer <duration>${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    duration${COLOR_RESET}    ${COLOR_NORMAL}Time to count down from${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  FORMAT${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Seconds only     timer 90${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Minutes          timer 5m${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Hours            timer 2h${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Combined         timer 1h30m45s${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 60          → 60 second countdown${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 5m          → 5 minute countdown${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 1h30m       → 1 hour 30 minute countdown${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 2h15m30s    → 2h 15m 30s countdown${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  NOTES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Progress bar changes color: green → orange → red${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Desktop notification on completion (if notify-send available)${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Audio alert on completion (if paplay/aplay available)${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Press Ctrl+C to cancel${COLOR_RESET}"
		echo ""
		return 0
	fi

	local total_seconds=$1

	if [ -z "$total_seconds" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: timer <duration>"
		echo "${COLOR_NORMAL}    Run 'timer --help' for format options${COLOR_RESET}"
		return 1
	fi

	if [[ "$total_seconds" =~ ^[0-9]+$ ]]; then
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
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Invalid time. Run 'timer --help' for format options"
		return 1
	fi

	local remaining=$total_seconds

	tput civis
	trap 'tput cnorm; printf "\n"' EXIT INT TERM

	printf "\033[2J\033[H"

	while [ $remaining -ge 0 ]; do
		local hours=$((remaining / 3600))
		local minutes=$(((remaining % 3600) / 60))
		local seconds=$((remaining % 60))

		local progress=$((100 - (remaining * 100 / total_seconds)))
		local bar_width=40
		local filled=$((progress * bar_width / 100))
		local empty=$((bar_width - filled))

		local bar=""
		for ((i = 0; i < filled; i++)); do bar+="█"; done
		for ((i = 0; i < empty; i++)); do bar+="░"; done

		local time_color=$COLOR_SUCCESS
		if [ $remaining -le $((total_seconds / 4)) ]; then
			time_color=$COLOR_ERROR
		elif [ $remaining -le $((total_seconds / 2)) ]; then
			time_color=$COLOR_WARNING
		fi

		local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
		local spin_index=$((remaining % ${#spinner[@]}))

		printf "\033[H"
		echo
		echo "${COLOR_HEADER}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
		echo "${COLOR_HEADER}  │${COLOR_RESET}              ${COLOR_CURSOR}⏱  COUNTDOWN TIMER${COLOR_RESET}              ${COLOR_HEADER}│${COLOR_RESET}"
		echo "${COLOR_HEADER}  └─────────────────────────────────────────────┘${COLOR_RESET}"
		echo
		echo

		printf "              "
		if [ $hours -gt 0 ]; then
			printf "${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $hours $minutes $seconds
		else
			printf "    ${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $minutes $seconds
		fi
		echo
		echo

		echo "     ${COLOR_BORDER}┤${COLOR_RESET}${bar}${COLOR_BORDER}├${COLOR_RESET} ${COLOR_CURSOR}${progress}%${COLOR_RESET}"
		echo
		echo

		if [ $remaining -eq 0 ]; then
			echo "        ${COLOR_SUCCESS}✓  Time's up!${COLOR_RESET}                      "
		else
			local elapsed=$((total_seconds - remaining))
			local elapsed_m=$((elapsed / 60))
			local elapsed_s=$((elapsed % 60))
			echo "        ${spinner[$spin_index]}  Elapsed: ${COLOR_NORMAL}${elapsed_m}m ${elapsed_s}s${COLOR_RESET}              "
		fi

		echo
		echo "${COLOR_BORDER}  ─────────────────────────────────────────────${COLOR_RESET}"
		echo "        ${COLOR_NORMAL}Press Ctrl+C to cancel${COLOR_RESET}"

		[ $remaining -eq 0 ] && break

		sleep 1
		((remaining--))
	done

	printf '\a'
	command -v notify-send &>/dev/null && notify-send "Timer" "Time's up! ⏰" --urgency=critical 2>/dev/null &
	if command -v paplay &>/dev/null; then
		[ -f /usr/share/sounds/freedesktop/stereo/complete.oga ] && paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &
		[ -f /usr/share/sounds/freedesktop/stereo/bell.oga ] && paplay /usr/share/sounds/freedesktop/stereo/bell.oga &>/dev/null &
	elif command -v aplay &>/dev/null && [ -f /usr/share/sounds/alsa/Front_Center.wav ]; then
		aplay /usr/share/sounds/alsa/Front_Center.wav &>/dev/null &
	fi

	tput cnorm
	trap - EXIT INT TERM

	echo
	echo "${COLOR_SUCCESS}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
	echo "${COLOR_SUCCESS}  │${COLOR_RESET}                  ${COLOR_SUCCESS}🎉 DONE! 🎉${COLOR_RESET}                  ${COLOR_SUCCESS}│${COLOR_RESET}"
	echo "${COLOR_SUCCESS}  └─────────────────────────────────────────────┘${COLOR_RESET}"
	echo
}

# Backup file/folder with timestamp
backup() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  backup — Backup a file or folder with timestamp${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    backup <file/folder>${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    file/folder${COLOR_RESET}    ${COLOR_NORMAL}Path to the file or directory to back up${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  OUTPUT${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Creates: <name>_backup_YYYYMMDD_HHMMSS.tar.gz${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    backup project/          → project_backup_20240210_153045.tar.gz${COLOR_RESET}"
		echo "${COLOR_NORMAL}    backup config.json       → config.json_backup_20240210_153045.tar.gz${COLOR_RESET}"
		echo ""
		return 0
	fi

	if [ -z "$1" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: backup <file/folder>"
		echo "${COLOR_NORMAL}    Run 'backup --help' for more info${COLOR_RESET}"
		return 1
	fi

	local timestamp=$(date +%Y%m%d_%H%M%S)
	local backup_name="${1}_backup_${timestamp}.tar.gz"

	tar -czf "$backup_name" "$1" 2>/dev/null

	if [ $? -eq 0 ]; then
		echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
	else
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Backup failed!"
	fi
}
