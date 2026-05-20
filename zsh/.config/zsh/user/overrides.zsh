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

  # Detect trash command based on OS
  local trash_cmd=""
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v trash &>/dev/null; then
      trash_cmd="trash"
    fi
  elif [[ "$OSTYPE" == "linux"* ]]; then
    if command -v gtrash &>/dev/null; then
      trash_cmd="gtrash put"
    fi
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

  # Show trash vs permanent delete indicator
  if [[ -n "$trash_cmd" ]]; then
    echo
    echo -e "    ${COLOR_NORMAL}  ↳ Will move to trash${COLOR_RESET}"
  else
    echo
    echo -e "    ${COLOR_WARNING}  ↳ Will be permanently deleted (no trash available)${COLOR_RESET}"
  fi

  echo
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
    if [[ -n "$trash_cmd" ]]; then
      # Flags don't apply to trash commands — pass targets only
      ${=trash_cmd} "${targets[@]}"
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
