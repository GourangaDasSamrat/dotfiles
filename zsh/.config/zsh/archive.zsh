# Universal extractor
extract() {
	if [ -f "$1" ]; then
		case "$1" in
		*.tar.* | *.tgz | *.tbz2 | *.txz)
			tar xvf "$1" && echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Extracted ${COLOR_TEXT}'$1'${COLOR_RESET}"
			;;
		*.zip)
			unzip "$1" && echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Extracted ${COLOR_TEXT}'$1'${COLOR_RESET}"
			;;
		*)
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} Unsupported format"
			return 1
			;;
		esac
	else
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} File not found: ${COLOR_TEXT}'$1'${COLOR_RESET}"
		return 1
	fi
}

# Universal compressor
compress() {
	if [ -z "$1" ]; then
		echo "${COLOR_WARNING}  Usage: compress <file_or_dir>${COLOR_RESET}"
		return 1
	fi

	local input=$1
	if [ ! -e "$input" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} '${COLOR_TEXT}$input${COLOR_RESET}' does not exist!"
		return 1
	fi

	echo ""
	echo "${COLOR_HEADER}  ◆  Select compression format${COLOR_RESET}"
	echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
	echo ""

	local format
	format=$(printf '%s\n' \
		"tar.gz   → Good balance, common" \
		"tar.bz2  → Better compression, slower" \
		"tar.xz   → Best compression, slowest" \
		"zip      → Cross-platform" \
		"7z       → High compression" \
		"gz       → Single file only" \
		"bz2      → Single file only" |
		fzf \
			--height=40% \
			--border=rounded \
			--prompt="  › " \
			--pointer="❯" \
			--no-info \
			--header="Enter to confirm, Ctrl+C to cancel")

	[[ -z "$format" ]] && echo "${COLOR_ERROR}  ✗ Cancelled${COLOR_RESET}" && return 1

	# extract just the format name before the space
	format="${format%% *}"

	local output="${input%/}.${format}"

	echo ""
	echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Compressing ${COLOR_TEXT}'$input'${COLOR_RESET} → ${COLOR_SUCCESS}'$output'${COLOR_RESET}"
	echo ""

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
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} .gz only supports single files!"
			return 1
		fi
		;;
	bz2)
		if [ -f "$input" ]; then
			bzip2 -c "$input" >"$output"
		else
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} .bz2 only supports single files!"
			return 1
		fi
		;;
	esac

	echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Done! Created: ${COLOR_SUCCESS}$output${COLOR_RESET}"
	echo ""
}
