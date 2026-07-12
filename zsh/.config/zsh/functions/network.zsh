#!/usr/bin/env zsh

if (( ${+commands[http]} )); then

# isup    <host>  — quick up/down + status code check (needs httpie)
  isup() {
    emulate -L zsh -o extended_glob
    local target=${1:-gouranga.eu.org}

    print -- "\n${COLOR_HEADER}󰴓 Checking status for:${COLOR_RESET} ${COLOR_TEXT}${target}${COLOR_RESET}"

    local raw_output
    raw_output=$(http -F --ignore-stdin -p=h "$target" 2>&1)  # -F follow redirects, -p=h headers only

    local -a lines=(${(f)raw_output})
    local status_line=${${(M)lines:#(#i)HTTP/*}[1]}
    local status_code=${${(z)status_line}[2]}

    local -a server_lines=(${(M)lines:#(#i)Server:*})
    local server_name=${${server_lines[-1]#*: }%$'\r'}

    if [[ -n $status_code ]]; then
      if [[ $status_code == 200 ]]; then
        print -- "${COLOR_SUCCESS}✔ ONLINE${COLOR_RESET} [${COLOR_SUCCESS}$status_code OK${COLOR_RESET}]"
      else
        print -- "${COLOR_WARNING}⚠ ISSUE${COLOR_RESET} [${COLOR_WARNING}$status_code${COLOR_RESET}]"
      fi
      [[ -n $server_name ]] && print -- "${COLOR_NORMAL}Server: $server_name${COLOR_RESET}"
    else
      print -- "${COLOR_ERROR}✘ OFFLINE${COLOR_RESET} ${COLOR_NORMAL}(Connection Failed or Timeout)${COLOR_RESET}"
    fi
    print
  }

  # Pulls "field": "value" out of a JSON blob via zsh backreference globbing —
  # used as the no-jq fallback, prints N/A on no match.
  _json_field() {
    emulate -L zsh -o extended_glob
    local json=$1 field=$2
    if [[ $json == (#b)*\"${field}\"[[:space:]]#:[[:space:]]#\"(*)\"* ]]; then
      print -r -- $match[1]
    else
      print -r -- 'N/A'
    fi
  }

# myip             — public IP / geo info via ipinfo.io (needs httpie)
  myip() {
    emulate -L zsh
    print -- "\n${COLOR_HEADER}󰩟 Fetching Public IP Info...${COLOR_RESET}"

    local ip_data
    ip_data=$(http -b ipinfo.io 2>/dev/null)

    if [[ -z $ip_data ]]; then
      print -- "${COLOR_ERROR}✘ Failed to retrieve IP data.${COLOR_RESET}"
      print
      return 1
    fi

    local ip city region org
    if (( ${+commands[jq]} )); then
      ip=$(jq -r '.ip // "N/A"' <<< "$ip_data")
      city=$(jq -r '.city // "N/A"' <<< "$ip_data")
      region=$(jq -r '.region // "N/A"' <<< "$ip_data")
      org=$(jq -r '.org // "N/A"' <<< "$ip_data")
    else
      ip=$(_json_field "$ip_data" ip)
      city=$(_json_field "$ip_data" city)
      region=$(_json_field "$ip_data" region)
      org=$(_json_field "$ip_data" org)
    fi

    print -- "${COLOR_NORMAL}Address:  ${COLOR_SUCCESS}${ip}${COLOR_RESET}"
    print -- "${COLOR_NORMAL}Location: ${COLOR_TEXT}${city}, ${region}${COLOR_RESET}"
    print -- "${COLOR_NORMAL}ISP:      ${COLOR_TEXT}${org}${COLOR_RESET}"
    print
  }

  if (( ${+commands[openssl]} )); then
# inspect <host>  — headers + TLS cert dates (needs httpie + openssl)
    inspect() {
      emulate -L zsh
      local target=${1:-gouranga.eu.org}
      local clean_url=${target#*://}
      clean_url=${clean_url%%/*}

      print -- "\n${COLOR_HEADER}󰄨 Inspecting:${COLOR_RESET} ${COLOR_TEXT}${target}${COLOR_RESET}\n"

      http -Fh "$target" 2>/dev/null \
        | grep -Ei "HTTP/|server:|content-type:|x-powered-by:|cache-control:|security|strict-transport" \
        | sed "s/\([^:]*:\)/${COLOR_NORMAL}\1${COLOR_RESET}/g"

      print -- "\n${COLOR_HEADER}󱈸 SSL/Certificate Info:${COLOR_RESET}"
      openssl s_client -connect "${clean_url}:443" 2>/dev/null </dev/null \
        | openssl x509 -noout -dates \
        | sed "s/notBefore=/${COLOR_NORMAL}Start:  ${COLOR_RESET}/" \
        | sed "s/notAfter=/${COLOR_WARNING}Expiry: ${COLOR_RESET}/"
      print
    }
  fi

fi