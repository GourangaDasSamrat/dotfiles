# Define server mapping
typeset -A WHOIS_SERVERS
WHOIS_SERVERS=(
  "dp"    "whois.digitalplat.org"
  "iana"  "whois.iana.org"
  "com"   "whois.verisign-grs.com"
)

dzw() {
  local arg1=$1
  local arg2=$2
  local target_server=""
  local domain=""

  # Logic: Determine if the first argument is a key or a domain
  if [[ -n "$arg2" ]]; then
    target_server="${WHOIS_SERVERS[$arg1]}"
    domain="$arg2"
    
    if [[ -z "$target_server" ]]; then
        echo "${COLOR_ERROR}Error:${COLOR_NORMAL} Server key '${COLOR_TEXT}$arg1${COLOR_NORMAL}' not found!"
        return 1
    fi
  elif [[ -n "$arg1" ]]; then
    domain="$arg1"
  else
    echo "${COLOR_ERROR}Error:${COLOR_NORMAL} No domain specified."
    return 1
  fi

  # Header Output
  echo -n "${COLOR_HEADER}🔍 Querying:${COLOR_TEXT} $domain"
  [[ -n "$target_server" ]] && echo " ${COLOR_NORMAL}via ${COLOR_CURSOR}$target_server" || echo " ${COLOR_NORMAL}(Default)"
  echo "${COLOR_BORDER}------------------------------------------${COLOR_RESET}"

  # Execute and Filter Output
  # We use grep -E to pick specific fields and ignore empty lines/legal junk
  local raw_output
  if [[ -z "$target_server" ]]; then
    raw_output=$(whois "$domain")
  else
    raw_output=$(whois -h "$target_server" "$domain")
  fi

  # Store exit code safely
  local cmd_status=$?

  if [[ $cmd_status -eq 0 ]]; then
    # Filtering: Only show lines starting with key labels, stop before the 'Terms of Use'
    echo "$raw_output" | grep -E "^(Domain Name|Registrar|Creation Date|Registry Expiry Date|Registrant Name|Registrant Email|Registrant Address|Registrant Phone|Name Server|Domain Status|>>> Last update)" | sed "s/: /: ${COLOR_TEXT}/g" | sed "s/^/${COLOR_NORMAL}/"
    
    echo "${COLOR_BORDER}------------------------------------------${COLOR_RESET}"
    echo "${COLOR_SUCCESS}✅ Done.${COLOR_RESET}"
  else
    echo "${COLOR_ERROR}❌ Failed to fetch WHOIS data.${COLOR_RESET}"
  fi
}
