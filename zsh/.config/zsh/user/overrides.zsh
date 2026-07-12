#!/usr/bin/env zsh

_resolve_abs() {
  emulate -L zsh
  local p=${1/#\~/$HOME}
  print -r -- ${p:A}
}

# Interactive Yes/No prompt, arrow keys + Enter. Result in $REPLY (1=Yes, 2=No).
_yn_prompt() {
  emulate -L zsh
  local question=$1
  local -i choice=2
  local key key2 key3

  tput civis
  {
    while true; do
      print -n -- $'\033[2K\r'
      print -n -- "${COLOR_HEADER}  ◆  ${question}${COLOR_RESET}"$'\n'

      if (( choice == 1 )); then
        print -n -- "     ${COLOR_CURSOR}› Yes${COLOR_RESET}  ${COLOR_NORMAL}No${COLOR_RESET}"
      else
        print -n -- "     ${COLOR_NORMAL}Yes${COLOR_RESET}  ${COLOR_CURSOR}› No${COLOR_RESET}"
      fi
      print -n -- $'\033[1A'

      read -k 1 key
      if [[ $key == $'\x1b' ]]; then
        read -k 1 -t 0.01 key2
        read -k 1 -t 0.01 key3
        key="$key$key2$key3"
      fi

      case $key in
        $'\x1b[C'|$'\x1b[D') (( choice = choice == 1 ? 2 : 1 )) ;;
        $'\n'|$'\r'|'')      break ;;
      esac
    done
  } always {
    tput cnorm
  }

  print -n -- $'\033[2K\r\033[1B'
  REPLY=$choice
}

mkdir() {
  emulate -L zsh

  (( $# == 0 )) && { command mkdir; return }

  command mkdir -p -- "$@" || return 1
  (( $# == 1 )) || return 0

  _yn_prompt "Initialize git repository in '$1'?"

  if (( REPLY == 1 )); then
    (
      cd -- "$1" || exit 1
      git init -q
      print -- "# $1" > README.md
      git add .
      git commit -q -m 'chore: initialize repository with README'
      print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Initialized git repo in ${COLOR_NORMAL}${PWD}/.git/${COLOR_RESET}"
    )
  else
    print -- "${COLOR_NORMAL}  ○ Created folder without git${COLOR_RESET}"
  fi
}

rm() {
  emulate -L zsh

  if (( $# == 0 )); then
    print -- 'Usage: rm <file or folder>'
    return 1
  fi

  local -a flags targets
  local arg
  for arg in "$@"; do
    if [[ $arg == -* ]]; then
      flags+=("$arg")
    else
      targets+=("$arg")
    fi
  done

  if (( $#targets == 0 )); then
    command rm "${flags[@]}"
    return
  fi

  local -a protected_paths=(
    '/'
    '/bin' '/sbin' '/usr' '/usr/bin' '/usr/sbin' '/usr/local'
    '/etc' '/var' '/tmp' '/opt' '/lib' '/lib64'
    '/System' '/Library' '/Applications' '/Volumes'
    '/boot' '/dev' '/proc' '/sys' '/run'
    "$HOME"
    "$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads"
    "$HOME/Library" "$HOME/Movies" "$HOME/Music" "$HOME/Pictures"
  )

  local -a protected_resolved
  local pp
  for pp in "${protected_paths[@]}"; do
    protected_resolved+=("$(_resolve_abs "$pp")")
  done

  _is_protected() {
    emulate -L zsh
    local resolved=$(_resolve_abs "$1")
    (( ${protected_resolved[(Ie)$resolved]} ))
  }

  local item
  local -i missing=0
  for item in "${targets[@]}"; do
    if [[ ! -e $item && ! -L $item ]]; then
      print -- "${COLOR_WARNING}  ✗  '$item' does not exist${COLOR_RESET}"
      missing=1
    fi
  done
  (( missing )) && return 1

  local -i blocked=0
  for item in "${targets[@]}"; do
    if _is_protected "$item"; then
      print -- "${COLOR_WARNING}  🛑  '$item' is protected${COLOR_RESET}"
      blocked=1
    fi
  done
  (( blocked )) && return 1

  # Cache trash-utility detection across calls in $_RM_TRASH_CMD.
  if [[ ! -v _RM_TRASH_CMD ]]; then
    typeset -g _RM_TRASH_CMD=''
    case $OSTYPE in
      darwin*) (( ${+commands[trash]} ))  && _RM_TRASH_CMD='trash'      ;;
      linux*)  (( ${+commands[gtrash]} )) && _RM_TRASH_CMD='gtrash put' ;;
    esac
  fi

  print
  print -- "${COLOR_WARNING}  ⚠  About to delete:${COLOR_RESET}"
  print

  for item in "${targets[@]}"; do
    if   [[ -d $item ]]; then print -- "    ${COLOR_TEXT}📁 $item${COLOR_RESET}"
    elif [[ -f $item ]]; then print -- "    ${COLOR_TEXT}📄 $item${COLOR_RESET}"
    else                      print -- "    ${COLOR_TEXT}🔗 $item${COLOR_RESET}"
    fi
  done

  if [[ -n $_RM_TRASH_CMD ]]; then
    print -- "\n    ${COLOR_NORMAL}  ↳ Will move to trash${COLOR_RESET}\n"
  else
    print -- "\n    ${COLOR_WARNING}  ↳ Will be permanently deleted (no trash available)${COLOR_RESET}\n"
  fi

  _yn_prompt 'Confirm deletion?'

  if (( REPLY == 1 )); then
    if [[ -n $_RM_TRASH_CMD ]]; then
      ${=_RM_TRASH_CMD} "${targets[@]}"
      print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Moved to trash"
    else
      command rm "${flags[@]}" "${targets[@]}"
      print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Deleted permanently"
    fi
  else
    print -- "${COLOR_NORMAL}  ○ Cancelled${COLOR_RESET}"
  fi
  print
}

# NOTE: zsh's bang-history expansion can misfire on a bare `rm!` at the
# interactive prompt. If so, use `alias rm!='rm'` instead.
rm!() {
  rm "$@"
}