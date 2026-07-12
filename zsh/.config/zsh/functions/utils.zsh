#!/usr/bin/env zsh

# Shared port-entry loop: prompts until a valid 1-65535 port is chosen.
# Set check_in_use=1 to also reject ports already listening (via lsof).
# Result comes back in $REPLY.
_prompt_port() {
  emulate -L zsh
  local default=$1 port=$2
  local -i check_in_use=${3:-0}

  while true; do
    if [[ -z $port ]]; then
      read "port?${COLOR_HEADER}  Enter port number (default: $default): ${COLOR_RESET}"
      port=${port:-$default}
    fi

    if [[ $port != <1-65535> ]]; then
      print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be a number between 1 and 65535!"
      port=''
      continue
    fi

    if (( check_in_use )) && (( ${+commands[lsof]} )) \
        && lsof -Pi :$port -sTCP:LISTEN -t &>/dev/null; then
      print -- "${COLOR_WARNING}  ⚠${COLOR_RESET} Port $port is already in use!"
      port=''
      continue
    fi

    break
  done

  REPLY=$port
}

# serve  <port> [-b|--bind-all]  — python3 http.server with port validation
serve() {
  emulate -L zsh
  local port='' arg
  local -i bind_all=0

  for arg in "$@"; do
    case $arg in
      -b|--bind-all) bind_all=1 ;;
      <->)           port=$arg ;;
    esac
  done

  _prompt_port 8000 "$port" 1
  port=$REPLY

  if (( bind_all )); then
    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://0.0.0.0:$port${COLOR_RESET} ${COLOR_WARNING}(network-wide)${COLOR_RESET}"
    python3 -m http.server "$port" --bind 0.0.0.0
  else
    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
    python3 -m http.server "$port"
  fi
}

# backup <file/folder>           — timestamped tar.gz backup
backup() {
  emulate -L zsh

  if [[ -z $1 ]]; then
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: backup <file/folder>"
    print -- "${COLOR_NORMAL}    Run 'backup --help' for more info${COLOR_RESET}"
    return 1
  fi

  local timestamp=${(%):-%D{%Y%m%d_%H%M%S}}
  local backup_name="${1}_backup_${timestamp}.tar.gz"

  if tar -czf "$backup_name" "$1" 2>/dev/null; then
    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
  else
    print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Backup failed!"
    return 1
  fi
}

# t      <command>               — run a command with timestamped output (needs `ts`)
if (( ${+commands[ts]} )); then
  t() {
    emulate -L zsh

    (( $# == 0 )) && {
      print -- "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: t <command>"
      return 1
    }

    local D_CLR=$COLOR_NORMAL T_CLR=$COLOR_HEADER R=$COLOR_RESET

    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Executing with timestamps..."
    env FORCE_COLOR=3 CLICOLOR_FORCE=1 stdbuf -oL -eL "$@" 2>&1 \
      | ts "${D_CLR}[%Y-%m-%d${R} ${T_CLR}%H:%M:%S]${R}"
  }
fi

# expose <port> [ttl]            — slim share tunnel with port validation (needs `slim`)
if (( ${+commands[slim]} )); then
  expose() {
    emulate -L zsh
    local port=${1:-} ttl=${2:-}

    _prompt_port 4000 "$port" 0
    port=$REPLY

    print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting tunnel for localhost:${COLOR_CURSOR}$port${COLOR_RESET}"

    if [[ -n $ttl ]]; then
      print -- "${COLOR_NORMAL}    TTL set to: $ttl${COLOR_RESET}"
      slim share --port "$port" --ttl "$ttl"
    else
      slim share --port "$port"
    fi
  }
fi