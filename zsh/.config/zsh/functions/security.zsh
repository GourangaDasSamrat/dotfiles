# Secure wrapper for package managers to prevent supply chain attacks
local package_managers=(npm pnpm yarn bun)

for pkg in $package_managers; do
  (( $+commands[$pkg] )) || continue

  local cmd=$pkg

  functions[$pkg]=$'
    local args=("$@")

    # If explicitly allowed → remove flag and run normally
    if (( ${args[(Ie)--allow-scripts]} )); then
      args=(${args:#--allow-scripts})
      [[ -o interactive ]] && print -P "${COLOR_ERROR}[!] secure: allowing scripts for '"$cmd"'${COLOR_RESET}"
      command '"$cmd"' "${args[@]}"
    else
      [[ -o interactive ]] && print -P "${COLOR_NORMAL}[-] secure: ignoring scripts for '"$cmd"'${COLOR_RESET}"
      command '"$cmd"' "${args[@]}" --ignore-scripts
    fi
  '
done

# Auto lock vault every 15 min (single instance)
if ! pgrep -f "gpg-auto-lock-loop" >/dev/null; then
  (
    exec -a gpg-auto-lock-loop bash -c '
      trap "exit" SIGTERM
      while true; do
        sleep 900
        if [[ -z "$(pgrep -f "gpg-agent.*$GPG_TTY")" ]]; then
          gpg-connect-agent reloadagent /bye > /dev/null 2>&1
        fi
      done
    '
  ) &
  disown
fi
