# Start python server with validation
serve() {
  local port=${1:-}
  local bind_all=false

  # Parse flags
  for arg in "$@"; do
    case "$arg" in
      -b|--bind-all) bind_all=true ;;
      [0-9]*) port="$arg" ;;
    esac
  done

  while true; do
    if [ -z "$port" ]; then
      echo "${COLOR_HEADER}  Enter port number (default: 8000):${COLOR_RESET} "
      read port
      port=${port:-8000}
    fi
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
      echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be a number!"
      port=""
      continue
    fi
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
      echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be between 1 and 65535!"
      port=""
      continue
    fi
    if lsof -Pi :$port -sTCP:LISTEN -t > /dev/null 2>&1; then
      echo "${COLOR_WARNING}  ⚠${COLOR_RESET} Port $port is already in use!"
      echo "${COLOR_HEADER}  Try another port:${COLOR_RESET} "
      port=""
      continue
    fi
    break
  done

  if $bind_all; then
    echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://0.0.0.0:$port${COLOR_RESET} ${COLOR_WARNING}(network-wide)${COLOR_RESET}"
    python3 -m http.server "$port" --bind 0.0.0.0
  else
    echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
    python3 -m http.server "$port"
  fi
}

# Backup file/folder with timestamp
backup() {
  if [ -z "$1" ]; then
    echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: backup <file/folder>"
    echo "${COLOR_NORMAL}    Run 'backup --help' for more info${COLOR_RESET}"
    return 1
  fi

  local timestamp=$(date +%Y%m%d_%H%M%S)
  local backup_name="${1}_backup_${timestamp}.tar.gz"

  tar -czf "$backup_name" "$1" 2> /dev/null

  if [ $? -eq 0 ]; then
    echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
  else
    echo "${COLOR_ERROR}  ✗${COLOR_RESET} Backup failed!"
  fi
}

# Universal logger with timestamps
if command -v ts &> /dev/null; then
  t() {
    # Check if a command was provided as an argument
    [[ $# -eq 0 ]] && {
      echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: t <command>"
      return 1
    }

    local D_CLR=$COLOR_NORMAL
    local T_CLR=$COLOR_HEADER
    local R=$COLOR_RESET

    # 2>&1 redirects stderr to stdout so 'ts' can catch everything
    # env flags force color for tools that support it
    # stdbuf -oL -eL ensures line-buffered output for real-time logging
    echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Executing with timestamps..."

    env FORCE_COLOR=3 CLICOLOR_FORCE=1 stdbuf -oL -eL "$@" 2>&1 | ts "${D_CLR}[%Y-%m-%d${R} ${T_CLR}%H:%M:%S]${R}"
  }
fi


# Slim share tunnel with port validation
if command -v slim &> /dev/null; then
  expose() {
    local port=${1:-}
    local ttl=${2:-}

    # Port validation loop
    while true; do
      if [ -z "$port" ]; then
        echo "${COLOR_HEADER}  Enter port number (default: 4000):${COLOR_RESET} "
        read port
        port=${port:-4000}
      fi

      if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be a number!"
        port=""
        continue
      fi

      if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be between 1 and 65535!"
        port=""
        continue
      fi

      break
    done

    # Execution logic
    echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting tunnel for localhost:${COLOR_CURSOR}$port${COLOR_RESET}"

    if [ -n "$ttl" ]; then
      echo "${COLOR_NORMAL}    TTL set to: $ttl${COLOR_RESET}"
      slim share --port "$port" --ttl "$ttl"
    else
      slim share --port "$port"
    fi
  }
fi
