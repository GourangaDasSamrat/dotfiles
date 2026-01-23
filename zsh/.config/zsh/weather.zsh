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
