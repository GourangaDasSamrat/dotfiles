#!/usr/bin/env zsh
# extract <archive>          — auto-detects format, extracts in place
# compress <file_or_dir>     — pick a format via fzf, archive/compress it
# Formats: tar(.gz/.bz2/.xz/.zst/.lz4/.lzma), zip, rar, 7z, iso, gz, bz2,
#          xz, zst, lz4, lzma, Z, deb, rpm, cab

extract() {
	emulate -L zsh
	local file=$1

	if [[ -z $file ]]; then
		_warn "Usage: extract <archive>"
		return 1
	fi
	if [[ ! -f $file ]]; then
		_err "File not found: ${COLOR_TEXT}'$file'${COLOR_RESET}"
		return 1
	fi

	local -a cmd
	case $file in
	*.tar.gz | *.tgz) cmd=(tar xzf "$file") ;;
	*.tar.bz2 | *.tbz2) cmd=(tar xjf "$file") ;;
	*.tar.xz | *.txz) cmd=(tar xJf "$file") ;;
	*.tar.zst | *.tzst) cmd=(tar --zstd -xf "$file") ;;
	*.tar.lz4) cmd=(tar -I lz4 -xf "$file") ;;
	*.tar.lzma | *.tlz) cmd=(tar --lzma -xf "$file") ;;
	*.tar) cmd=(tar xf "$file") ;;
	*.zip) cmd=(unzip -q "$file") ;;
	*.rar) cmd=(unrar x "$file") ;;
	*.7z | *.iso) cmd=(7z x "$file") ;;
	*.gz) cmd=(gunzip -k "$file") ;;
	*.bz2) cmd=(bunzip2 -k "$file") ;;
	*.xz) cmd=(unxz -k "$file") ;;
	*.lzma) cmd=(unlzma -k "$file") ;;
	*.zst) cmd=(zstd -dk "$file") ;;
	*.lz4) cmd=(lz4 -dk "$file") ;;
	*.Z) cmd=(uncompress -k "$file") ;;
	*.deb) cmd=(dpkg-deb -x "$file" "${file:t:r}") ;;
	*.cab) cmd=(cabextract "$file") ;;
	*.rpm)
		if ((! (${+commands[rpm2cpio]} && ${+commands[cpio]}))); then
			_err "requires 'rpm2cpio' and 'cpio'"
			return 1
		fi
		if rpm2cpio "$file" | cpio -idm; then
			_ok "Extracted ${COLOR_TEXT}'$file'${COLOR_RESET}"
		else
			_err "Extraction failed"
			return 1
		fi
		return
		;;
	*)
		_err "Unsupported format: ${COLOR_TEXT}'$file'${COLOR_RESET}"
		return 1
		;;
	esac

	if ((! ${+commands[${cmd[1]}]})); then
		_err "'${cmd[1]}' is not installed"
		return 1
	fi

	if "${cmd[@]}"; then
		_ok "Extracted ${COLOR_TEXT}'$file'${COLOR_RESET}"
	else
		_err "Extraction failed"
		return 1
	fi
}

compress() {
	emulate -L zsh
	local input=$1

	if [[ -z $input ]]; then
		_warn "Usage: compress <file_or_dir>"
		return 1
	fi
	if [[ ! -e $input ]]; then
		_err "'${COLOR_TEXT}$input${COLOR_RESET}' does not exist!"
		return 1
	fi
	if ((! ${+commands[fzf]})); then
		_err "'fzf' is not installed"
		return 1
	fi

	print
	print -- "${COLOR_HEADER}  ◆  Select compression format${COLOR_RESET}"
	print -- "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
	print

	local format
	format=$(print -l \
		"tar.gz   → Good balance, common" \
		"tar.bz2  → Better compression, slower" \
		"tar.xz   → Best compression, slowest" \
		"tar.zst  → Fast + strong (zstd)" \
		"tar.lz4  → Fastest, lowest ratio" \
		"zip      → Cross-platform" \
		"7z       → High compression" \
		"rar      → Needs 'rar' installed" \
		"gz       → Single file only" \
		"bz2      → Single file only" \
		"xz       → Single file only" \
		"zst      → Single file only" \
		"lz4      → Single file only" \
		"Z        → Legacy single file" |
		fzf \
			--height=40% \
			--border=rounded \
			--prompt="  › " \
			--pointer="❯" \
			--no-info \
			--header="Enter to confirm, Ctrl+C to cancel")

	[[ -z $format ]] && {
		_err "Cancelled"
		return 1
	}
	format=${format%% *}

	local output="${input%/}.${format}"
	local -a cmd
	local -i single_file_only=0

	case $format in
	tar.gz) cmd=(tar czf "$output" "$input") ;;
	tar.bz2) cmd=(tar cjf "$output" "$input") ;;
	tar.xz) cmd=(tar cJf "$output" "$input") ;;
	tar.zst) cmd=(tar --zstd -cf "$output" "$input") ;;
	tar.lz4) cmd=(tar -I lz4 -cf "$output" "$input") ;;
	zip) cmd=(zip -rq "$output" "$input") ;;
	7z) cmd=(7z a "$output" "$input") ;;
	rar) cmd=(rar a "$output" "$input") ;;
	gz)
		cmd=(gzip -c "$input")
		single_file_only=1
		;;
	bz2)
		cmd=(bzip2 -c "$input")
		single_file_only=1
		;;
	xz)
		cmd=(xz -c "$input")
		single_file_only=1
		;;
	zst)
		cmd=(zstd -c "$input")
		single_file_only=1
		;;
	lz4)
		cmd=(lz4 -c "$input")
		single_file_only=1
		;;
	Z)
		cmd=(compress -c "$input")
		single_file_only=1
		;;
	esac

	if ((single_file_only)) && [[ ! -f $input ]]; then
		_err ".$format only supports single files!"
		return 1
	fi
	if ((! ${+commands[${cmd[1]}]})); then
		_err "'${cmd[1]}' is not installed"
		return 1
	fi

	print
	_ok "Compressing ${COLOR_TEXT}'$input'${COLOR_RESET} → ${COLOR_SUCCESS}'$output'${COLOR_RESET}"
	print

	if ((single_file_only)); then
		"${cmd[@]}" >"$output"
	else
		"${cmd[@]}"
	fi

	if (($? == 0)); then
		_ok "Done! Created: ${COLOR_SUCCESS}$output${COLOR_RESET}"
	else
		_err "Compression failed"
		return 1
	fi
	print
}
