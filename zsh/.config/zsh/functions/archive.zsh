#!/usr/bin/env zsh
# extract <archive>          — auto-detects format, extracts in place
# compress <file_or_dir>     — pick a format via fzf, archive/compress it
# Formats: tar(.gz/.bz2/.xz/.zst/.lz4/.lzma), zip, rar, 7z, iso, gz, bz2,
#          xz, zst, lz4, lzma, Z, deb, rpm, cab

extract() {
  emulate -L zsh
  local file=$1

  if [[ -z $file ]]; then
    print -- "${COLOR_WARNING}  Usage: extract <archive>${COLOR_RESET}"
    return 1
  fi
  if [[ ! -f $file ]]; then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} File not found: ${COLOR_TEXT}'$file'${COLOR_RESET}"
    return 1
  fi

  local -a cmd
  case $file in
    *.tar.gz|*.tgz)    cmd=(tar xzf "$file") ;;
    *.tar.bz2|*.tbz2)  cmd=(tar xjf "$file") ;;
    *.tar.xz|*.txz)    cmd=(tar xJf "$file") ;;
    *.tar.zst|*.tzst)  cmd=(tar --zstd -xf "$file") ;;
    *.tar.lz4)         cmd=(tar -I lz4 -xf "$file") ;;
    *.tar.lzma|*.tlz)  cmd=(tar --lzma -xf "$file") ;;
    *.tar)             cmd=(tar xf "$file") ;;
    *.zip)             cmd=(unzip -q "$file") ;;
    *.rar)             cmd=(unrar x "$file") ;;
    *.7z|*.iso)        cmd=(7z x "$file") ;;
    *.gz)              cmd=(gunzip -k "$file") ;;
    *.bz2)             cmd=(bunzip2 -k "$file") ;;
    *.xz)              cmd=(unxz -k "$file") ;;
    *.lzma)            cmd=(unlzma -k "$file") ;;
    *.zst)             cmd=(zstd -dk "$file") ;;
    *.lz4)             cmd=(lz4 -dk "$file") ;;
    *.Z)               cmd=(uncompress -k "$file") ;;
    *.deb)             cmd=(dpkg-deb -x "$file" "${file:t:r}") ;;
    *.cab)             cmd=(cabextract "$file") ;;
    *.rpm)
      if (( ! (${+commands[rpm2cpio]} && ${+commands[cpio]}) )); then
        print -- "${COLOR_ERROR}  ✗${COLOR_RESET} requires 'rpm2cpio' and 'cpio'"
        return 1
      fi
      if rpm2cpio "$file" | cpio -idm; then
        print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Extracted ${COLOR_TEXT}'$file'${COLOR_RESET}"
      else
        print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Extraction failed"
        return 1
      fi
      return
      ;;
    *)
      print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Unsupported format: ${COLOR_TEXT}'$file'${COLOR_RESET}"
      return 1
      ;;
  esac

  if (( ! ${+commands[${cmd[1]}]} )); then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} '${cmd[1]}' is not installed"
    return 1
  fi

  if "${cmd[@]}"; then
    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Extracted ${COLOR_TEXT}'$file'${COLOR_RESET}"
  else
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Extraction failed"
    return 1
  fi
}

compress() {
  emulate -L zsh
  local input=$1

  if [[ -z $input ]]; then
    print -- "${COLOR_WARNING}  Usage: compress <file_or_dir>${COLOR_RESET}"
    return 1
  fi
  if [[ ! -e $input ]]; then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} '${COLOR_TEXT}$input${COLOR_RESET}' does not exist!"
    return 1
  fi
  if (( ! ${+commands[fzf]} )); then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} 'fzf' is not installed"
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

  [[ -z $format ]] && { print -- "${COLOR_ERROR}  ✗ Cancelled${COLOR_RESET}"; return 1 }
  format=${format%% *}

  local output="${input%/}.${format}"
  local -a cmd
  local -i single_file_only=0

  case $format in
    tar.gz)  cmd=(tar czf "$output" "$input") ;;
    tar.bz2) cmd=(tar cjf "$output" "$input") ;;
    tar.xz)  cmd=(tar cJf "$output" "$input") ;;
    tar.zst) cmd=(tar --zstd -cf "$output" "$input") ;;
    tar.lz4) cmd=(tar -I lz4 -cf "$output" "$input") ;;
    zip)     cmd=(zip -rq "$output" "$input") ;;
    7z)      cmd=(7z a "$output" "$input") ;;
    rar)     cmd=(rar a "$output" "$input") ;;
    gz)      cmd=(gzip -c "$input");   single_file_only=1 ;;
    bz2)     cmd=(bzip2 -c "$input");  single_file_only=1 ;;
    xz)      cmd=(xz -c "$input");     single_file_only=1 ;;
    zst)     cmd=(zstd -c "$input");   single_file_only=1 ;;
    lz4)     cmd=(lz4 -c "$input");    single_file_only=1 ;;
    Z)       cmd=(compress -c "$input"); single_file_only=1 ;;
  esac

  if (( single_file_only )) && [[ ! -f $input ]]; then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} .$format only supports single files!"
    return 1
  fi
  if (( ! ${+commands[${cmd[1]}]} )); then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} '${cmd[1]}' is not installed"
    return 1
  fi

  print
  print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Compressing ${COLOR_TEXT}'$input'${COLOR_RESET} → ${COLOR_SUCCESS}'$output'${COLOR_RESET}"
  print

  if (( single_file_only )); then
    "${cmd[@]}" > "$output"
  else
    "${cmd[@]}"
  fi

  if (( $? == 0 )); then
    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Done! Created: ${COLOR_SUCCESS}$output${COLOR_RESET}"
  else
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Compression failed"
    return 1
  fi
  print
}