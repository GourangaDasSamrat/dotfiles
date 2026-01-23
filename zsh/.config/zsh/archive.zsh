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
