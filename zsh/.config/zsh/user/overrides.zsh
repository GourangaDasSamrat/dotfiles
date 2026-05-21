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
      echo "# $1" > README.md
      git add .
      git commit -m "chore: initialize repository with README" -q
      echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Initialized git repo in ${COLOR_NORMAL}$(pwd)/.git/${COLOR_RESET}"
    )
  else
    echo -e "${COLOR_NORMAL}  ○ Created folder without git${COLOR_RESET}"
  fi
}

# Overwrite rm
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

  # ─── PROTECTED PATHS ────────────────────────────────────────────────────────
  local -a PROTECTED_EXACT=(
    "/"
    "/bin" "/sbin" "/usr" "/usr/bin" "/usr/sbin" "/usr/local"
    "/etc" "/var" "/tmp" "/opt" "/lib" "/lib64"
    "/System" "/Library" "/Applications" "/Volumes"
    "/boot" "/dev" "/proc" "/sys" "/run"
    "$HOME"
    "$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads"
    "$HOME/Library" "$HOME/Movies" "$HOME/Music" "$HOME/Pictures"
  )

  _resolve_fast() {
    local p="${1/#\~/$HOME}"
    if [[ -d "$p" ]]; then
      (builtin cd -P -- "$p" 2>/dev/null && print -r -- "$PWD")
    elif [[ -e "$p" || -L "$p" ]]; then
      local dir="${p:h}"
      local file="${p:t}"
      (builtin cd -P -- "$dir" 2>/dev/null && print -r -- "$PWD/$file")
    else
      print -r -- "$p"
    fi
  }

  local resolved_protected_list=""
  local pp
  for pp in "${PROTECTED_EXACT[@]}"; do
    resolved_protected_list+="$(_resolve_fast "$pp")"$'\n'
  done

  _is_protected() {
    local resolved
    resolved="$(_resolve_fast "$1")"
    grep -qxF "$resolved" <<< "$resolved_protected_list"
  }
  # ────────────────────────────────────────────────────────────────────────────

  # Validate existence
  local missing=0
  for item in "${targets[@]}"; do
    if [[ ! -e "$item" && ! -L "$item" ]]; then
      echo -e "${COLOR_WARNING}  ✗  '$item' does not exist${COLOR_RESET}"
      missing=1
    fi
  done
  [[ $missing -eq 1 ]] && return 1

  # Check protected paths
  local blocked=0
  for item in "${targets[@]}"; do
    if _is_protected "$item"; then
      echo -e "${COLOR_WARNING}  🛑  '$item' is protected${COLOR_RESET}"
      blocked=1
    fi
  done
  [[ $blocked -eq 1 ]] && return 1

  # Detect trash command (cached after first call)
  if [[ -z "${_RM_TRASH_CMD+set}" ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      command -v trash &>/dev/null && _RM_TRASH_CMD="trash" || _RM_TRASH_CMD=""
    elif [[ "$OSTYPE" == "linux"* ]]; then
      command -v gtrash &>/dev/null && _RM_TRASH_CMD="gtrash put" || _RM_TRASH_CMD=""
    else
      _RM_TRASH_CMD=""
    fi
  fi

  echo
  echo -e "${COLOR_WARNING}  ⚠  About to delete:${COLOR_RESET}"
  echo

  for item in "${targets[@]}"; do
    if   [ -d "$item" ]; then echo -e "    ${COLOR_TEXT}📁 $item${COLOR_RESET}"
    elif [ -f "$item" ]; then echo -e "    ${COLOR_TEXT}📄 $item${COLOR_RESET}"
    else                      echo -e "    ${COLOR_TEXT}🔗 $item${COLOR_RESET}"
    fi
  done

  if [[ -n "$_RM_TRASH_CMD" ]]; then
    echo -e "\n    ${COLOR_NORMAL}  ↳ Will move to trash${COLOR_RESET}\n"
  else
    echo -e "\n    ${COLOR_WARNING}  ↳ Will be permanently deleted (no trash available)${COLOR_RESET}\n"
  fi

  local choice=2
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
        if [ $choice -eq 1 ]; then choice=2; else choice=1; fi ;;
      $'\n' | $'\r') break ;;
      '') break ;;
    esac
  done

  echo -ne "\033[2K\r\033[1B"
  tput cnorm
  trap - EXIT

  if [ $choice -eq 1 ]; then
    if [[ -n "$_RM_TRASH_CMD" ]]; then
      ${=_RM_TRASH_CMD} "${targets[@]}"
      echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Moved to trash"
    else
      command rm "${flags[@]}" "${targets[@]}"
      echo -e "${COLOR_SUCCESS}  ✓${COLOR_RESET} Deleted permanently"
    fi
  else
    echo -e "${COLOR_NORMAL}  ○ Cancelled${COLOR_RESET}"
  fi
  echo
}

# rm! — still prompts, but uses trash if available
rm!() {
  rm "$@"
}
