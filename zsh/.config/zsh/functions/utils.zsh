# Start python server with validation
serve() {
  local port=${1:-}

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

  echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
  python3 -m http.server "$port"
}

# Timer
timer() {
  local total_seconds=$1

  if [ -z "$total_seconds" ]; then
    echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: timer <duration>"
    echo "${COLOR_NORMAL}    Run 'timer --help' for format options${COLOR_RESET}"
    return 1
  fi

  if [[ "$total_seconds" =~ ^[0-9]+$ ]]; then
    total_seconds=$total_seconds
  else
    local parsed_seconds=0
    if [[ "$total_seconds" =~ ([0-9]+)h ]]; then
      parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]} * 3600))
    fi
    if [[ "$total_seconds" =~ ([0-9]+)m ]]; then
      parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]} * 60))
    fi
    if [[ "$total_seconds" =~ ([0-9]+)s ]]; then
      parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]}))
    fi
    total_seconds=$parsed_seconds
  fi

  if [ $total_seconds -le 0 ]; then
    echo "${COLOR_ERROR}  ✗${COLOR_RESET} Invalid time. Run 'timer --help' for format options"
    return 1
  fi

  local remaining=$total_seconds

  tput civis
  trap 'tput cnorm; printf "\n"' EXIT INT TERM

  printf "\033[2J\033[H"

  while [ $remaining -ge 0 ]; do
    local hours=$((remaining / 3600))
    local minutes=$(((remaining % 3600) / 60))
    local seconds=$((remaining % 60))

    local progress=$((100 - (remaining * 100 / total_seconds)))
    local bar_width=40
    local filled=$((progress * bar_width / 100))
    local empty=$((bar_width - filled))

    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done

    local time_color=$COLOR_SUCCESS
    if [ $remaining -le $((total_seconds / 4)) ]; then
      time_color=$COLOR_ERROR
    elif [ $remaining -le $((total_seconds / 2)) ]; then
      time_color=$COLOR_WARNING
    fi

    local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local spin_index=$((remaining % ${#spinner[@]}))

    printf "\033[H"
    echo
    echo "${COLOR_HEADER}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
    echo "${COLOR_HEADER}  │${COLOR_RESET}              ${COLOR_CURSOR}⏱  COUNTDOWN TIMER${COLOR_RESET}              ${COLOR_HEADER}│${COLOR_RESET}"
    echo "${COLOR_HEADER}  └─────────────────────────────────────────────┘${COLOR_RESET}"
    echo
    echo

    printf "              "
    if [ $hours -gt 0 ]; then
      printf "${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $hours $minutes $seconds
    else
      printf "    ${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $minutes $seconds
    fi
    echo
    echo

    echo "     ${COLOR_BORDER}┤${COLOR_RESET}${bar}${COLOR_BORDER}├${COLOR_RESET} ${COLOR_CURSOR}${progress}%${COLOR_RESET}"
    echo
    echo

    if [ $remaining -eq 0 ]; then
      echo "        ${COLOR_SUCCESS}✓  Time's up!${COLOR_RESET}                      "
    else
      local elapsed=$((total_seconds - remaining))
      local elapsed_m=$((elapsed / 60))
      local elapsed_s=$((elapsed % 60))
      echo "        ${spinner[$spin_index]}  Elapsed: ${COLOR_NORMAL}${elapsed_m}m ${elapsed_s}s${COLOR_RESET}              "
    fi

    echo
    echo "${COLOR_BORDER}  ─────────────────────────────────────────────${COLOR_RESET}"
    echo "        ${COLOR_NORMAL}Press Ctrl+C to cancel${COLOR_RESET}"

    [ $remaining -eq 0 ] && break

    sleep 1
    ((remaining--))
  done

  printf '\a'
  command -v notify-send &> /dev/null && notify-send "Timer" "Time's up! ⏰" --urgency=critical 2> /dev/null &
  if command -v paplay &> /dev/null; then
    [ -f /usr/share/sounds/freedesktop/stereo/complete.oga ] && paplay /usr/share/sounds/freedesktop/stereo/complete.oga &> /dev/null &
    [ -f /usr/share/sounds/freedesktop/stereo/bell.oga ] && paplay /usr/share/sounds/freedesktop/stereo/bell.oga &> /dev/null &
  elif command -v aplay &> /dev/null && [ -f /usr/share/sounds/alsa/Front_Center.wav ]; then
    aplay /usr/share/sounds/alsa/Front_Center.wav &> /dev/null &
  fi

  tput cnorm
  trap - EXIT INT TERM

  echo
  echo "${COLOR_SUCCESS}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
  echo "${COLOR_SUCCESS}  │${COLOR_RESET}                  ${COLOR_SUCCESS}🎉 DONE! 🎉${COLOR_RESET}                  ${COLOR_SUCCESS}│${COLOR_RESET}"
  echo "${COLOR_SUCCESS}  └─────────────────────────────────────────────┘${COLOR_RESET}"
  echo
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

# Weather check
weather() {
  local city="${1:-${MY_LOCATION:-Khulna}}"
  echo -e "\n${COLOR_HEADER}󰖐 Fetching weather for ${COLOR_TEXT}${city}...${COLOR_RESET}"

  # ?0mTq: 0 (current only), m (metric), T (no colors to use your own), q (quiet)
  curl -s -H "Accept-Language: en" "wttr.in/${city}?0mFq&format=v2" | sed "s/^/${COLOR_NORMAL}/"

  echo -e "${COLOR_RESET}"
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

#compdef gtrash

# Only load this completion on Linux
[[ "$OSTYPE" != "linux"* ]] && return 0

compdef _gtrash gtrash

# zsh completion for gtrash                               -*- shell-script -*-

__gtrash_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_gtrash()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __gtrash_debug "\n========= starting completion logic =========="
    __gtrash_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __gtrash_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __gtrash_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., gtrash -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __gtrash_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __gtrash_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __gtrash_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __gtrash_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __gtrash_debug "No directive found.  Setting do default"
        directive=0
    fi

    __gtrash_debug "directive: ${directive}"
    __gtrash_debug "completions: ${out}"
    __gtrash_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __gtrash_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __gtrash_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __gtrash_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __gtrash_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __gtrash_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __gtrash_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __gtrash_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __gtrash_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __gtrash_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __gtrash_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __gtrash_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __gtrash_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __gtrash_debug "_describe did not find completions."
            __gtrash_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __gtrash_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __gtrash_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_gtrash" ]; then
    _gtrash
fi
