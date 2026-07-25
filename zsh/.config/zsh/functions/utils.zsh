#!/usr/bin/env zsh

# Shared status printers: wrap the repeated
# "${COLOR_X}  symbol${COLOR_RESET} message" pattern used across all functions.
_ok()   { print -- "${COLOR_SUCCESS}  ✓${COLOR_RESET} $1" }
_err()  { print -- "${COLOR_ERROR}  ✗${COLOR_RESET} $1" }
_warn() { print -- "${COLOR_WARNING}  ⚠${COLOR_RESET} $1" }

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
      _err "Port must be a number between 1 and 65535!"
      port=''
      continue
    fi
    if (( check_in_use )) && (( ${+commands[lsof]} )) \
        && lsof -Pi :$port -sTCP:LISTEN -t &>/dev/null; then
      _warn "Port $port is already in use!"
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
    _ok "Starting server on ${COLOR_CURSOR}http://0.0.0.0:$port${COLOR_RESET} ${COLOR_WARNING}(network-wide)${COLOR_RESET}"
    python3 -m http.server "$port" --bind 0.0.0.0
  else
    _ok "Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
    python3 -m http.server "$port"
  fi
}

# backup <file/folder>           — timestamped tar.gz backup
backup() {
  emulate -L zsh
  if [[ -z $1 ]]; then
    _err "Missing argument. Usage: backup <file/folder>"
    print -- "${COLOR_NORMAL}    Run 'backup --help' for more info${COLOR_RESET}"
    return 1
  fi
  local timestamp=${(%):-%D{%Y%m%d_%H%M%S}}
  local backup_name="${1}_backup_${timestamp}.tar.gz"
  if tar -czf "$backup_name" "$1" 2>/dev/null; then
    _ok "Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
  else
    _err "Backup failed!"
    return 1
  fi
}

# t      <command>               — run a command with timestamped output (needs `ts`)
if (( ${+commands[ts]} )); then
  t() {
    emulate -L zsh
    (( $# == 0 )) && {
      _err "Missing argument. Usage: t <command>"
      return 1
    }
    local D_CLR=$COLOR_NORMAL T_CLR=$COLOR_HEADER R=$COLOR_RESET
    _ok "Executing with timestamps..."
    env FORCE_COLOR=3 CLICOLOR_FORCE=1 stdbuf -oL -eL "$@" 2>&1 \
      | ts "${D_CLR}[%Y-%m-%d${R} ${T_CLR}%H:%M:%S]${R}"
  }
fi

# expose <port>                  — cloudflared quick-tunnel with clean, filtered output
if (( ${+commands[cloudflared]} )); then
  expose() {
    emulate -L zsh
    # nomonitor: suppress zsh's "[N] PID" / "done" job-control messages
    # printed for background jobs (including coproc) started below.
    setopt localoptions nomonitor
    local port='' url='' line
    local -i elapsed=0

    _prompt_port 4000 "$1" 0
    port=$REPLY

    _ok "Starting tunnel for localhost:${COLOR_CURSOR}$port${COLOR_RESET}"

    # coproc correctly sets $! to cloudflared's PID (process substitution
    # does not). Default log level is kept since the quick-tunnel URL is
    # itself logged at INF level; we never echo the raw stream, so no
    # noise reaches the terminal regardless of log level.
    coproc cloudflared tunnel --url "http://localhost:$port" --no-autoupdate 2>&1
    local -i pid=$!

    # Cleanup cloudflared on any exit path (success, failure, Ctrl+C).
    trap 'kill $pid 2>/dev/null' EXIT INT TERM

    # Poll the coprocess stream (1s read timeout) until the hostname line
    # appears, using zsh's native regex match ($MATCH) instead of grep/cut.
    while (( elapsed++ < 15 )); do
      kill -0 $pid 2>/dev/null || break
      read -t 1 -r line <&p || continue
      if [[ $line =~ 'https://[a-zA-Z0-9-]+\.trycloudflare\.com' ]]; then
        url=$MATCH
        break
      fi
    done

    if [[ -z $url ]]; then
      _err "Failed to establish tunnel."
      trap - EXIT INT TERM
      kill $pid 2>/dev/null
      return 1
    fi

    _ok "Tunnel ready: ${COLOR_CURSOR}$url${COLOR_RESET}"
    print -- "${COLOR_NORMAL}    Press Ctrl+C to stop${COLOR_RESET}"

    # Silently drain remaining output so the pipe never fills/blocks,
    # until cloudflared exits or Ctrl+C triggers the trap above.
    while read -r line <&p; do :; done
    trap - EXIT INT TERM
  }
fi
