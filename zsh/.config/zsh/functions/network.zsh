# 1. Define 'isup' only if httpie (http) is installed
if command -v http &> /dev/null; then
  
  isup() {
    local target="${1:-gouranga.eu.org}"
    echo -e "\n${COLOR_HEADER}󰴓 Checking status for:${COLOR_RESET} ${COLOR_TEXT}${target}${COLOR_RESET}"

    local raw_output
    # -F: Follow redirects, -p=h: Print only headers
    raw_output=$(http -F --ignore-stdin -p=h "$target" 2>&1)

    local status_line=$(echo "$raw_output" | grep -Ei "HTTP/.* [0-9]{3}")
    local status_code=$(echo "$status_line" | awk '{print $2}')
    local server_name=$(echo "$raw_output" | grep -Ei "^Server:" | tail -n 1 | cut -d' ' -f2- | tr -d '\r')

    if [[ -n "$status_code" ]]; then
      if [[ "$status_code" == "200" ]]; then
        echo -e "${COLOR_SUCCESS}✔ ONLINE${COLOR_RESET} [${COLOR_SUCCESS}$status_code OK${COLOR_RESET}]"
      else
        echo -e "${COLOR_WARNING}⚠ ISSUE${COLOR_RESET} [${COLOR_WARNING}$status_code${COLOR_RESET}]"
      fi
      [[ -n "$server_name" ]] && echo -e "${COLOR_NORMAL}Server: $server_name${COLOR_RESET}"
    else
      echo -e "${COLOR_ERROR}✘ OFFLINE${COLOR_RESET} ${COLOR_NORMAL}(Connection Failed or Timeout)${COLOR_RESET}"
    fi
    echo ""
  }

  # 2. Define 'myip' to show public IP details using httpie
  myip() {
    echo -e "\n${COLOR_HEADER}󰩟 Fetching Public IP Info...${COLOR_RESET}"

    # Fetching from ipinfo.io for a nice JSON response
    local ip_data
    ip_data=$(http -b ipinfo.io 2>/dev/null)

    if [[ -z "$ip_data" ]]; then
      echo -e "${COLOR_ERROR}✘ Failed to retrieve IP data.${COLOR_RESET}"
      echo ""
      return 1
    fi

    if command -v jq &> /dev/null; then
      local ip city region org
      ip=$(echo "$ip_data"     | jq -r '.ip     // "N/A"')
      city=$(echo "$ip_data"   | jq -r '.city   // "N/A"')
      region=$(echo "$ip_data" | jq -r '.region // "N/A"')
      org=$(echo "$ip_data"    | jq -r '.org    // "N/A"')
    else
      # Fallback: POSIX-safe grep (no -P flag) for macOS/BSD compatibility
      local ip city region org
      ip=$(echo "$ip_data"     | grep -o '"ip":[[:space:]]*"[^"]*"'     | cut -d'"' -f4)
      city=$(echo "$ip_data"   | grep -o '"city":[[:space:]]*"[^"]*"'   | cut -d'"' -f4)
      region=$(echo "$ip_data" | grep -o '"region":[[:space:]]*"[^"]*"' | cut -d'"' -f4)
      org=$(echo "$ip_data"    | grep -o '"org":[[:space:]]*"[^"]*"'    | cut -d'"' -f4)
    fi

    echo -e "${COLOR_NORMAL}Address:  ${COLOR_SUCCESS}${ip}${COLOR_RESET}"
    echo -e "${COLOR_NORMAL}Location: ${COLOR_TEXT}${city}, ${region}${COLOR_RESET}"
    echo -e "${COLOR_NORMAL}ISP:      ${COLOR_TEXT}${org}${COLOR_RESET}"
    echo ""
  }

  # 3. Define 'inspect' only if BOTH httpie and openssl are installed
  if command -v openssl &> /dev/null; then
    inspect() {
      local target="${1:-gouranga.eu.org}"
      # Strip protocol for openssl (e.g., https://google.com -> google.com)
      local clean_url="${target#*://}"
      clean_url="${clean_url%%/*}"

      echo -e "\n${COLOR_HEADER}󰄨 Inspecting:${COLOR_RESET} ${COLOR_TEXT}${target}${COLOR_RESET}\n"

      # Fetching headers and highlighting keys
      http -Fh "$target" 2> /dev/null | grep -Ei "HTTP/|server:|content-type:|x-powered-by:|cache-control:|security|strict-transport" |
        sed "s/\([^:]*:\)/${COLOR_NORMAL}\1${COLOR_RESET}/g"

      echo -e "\n${COLOR_HEADER}󱈸 SSL/Certificate Info:${COLOR_RESET}"
      # Fetch SSL dates and format with your palette
      echo | openssl s_client -connect "${clean_url}":443 2> /dev/null | openssl x509 -noout -dates |
        sed "s/notBefore=/${COLOR_NORMAL}Start:  ${COLOR_RESET}/" |
        sed "s/notAfter=/${COLOR_WARNING}Expiry: ${COLOR_RESET}/"
      echo ""
    }
  fi

fi
