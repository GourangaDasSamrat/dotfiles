# Auto lock vault every 15 min (single instance)
if ! pgrep -f "gpg-auto-lock-loop" > /dev/null; then
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


# --- GPG Agent & Pinentry Configuration ---
local pinentry_path=""

# Use Zsh built-ins ($OSTYPE and $+commands) for instant OS and binary detection
if [[ "$OSTYPE" == linux* ]] && (( $+commands[pinentry-gnome3] )); then
  pinentry_path="$commands[pinentry-gnome3]"
elif [[ "$OSTYPE" == darwin* ]] && (( $+commands[pinentry-mac] )); then
  pinentry_path="$commands[pinentry-mac]"
fi

if [[ -n "$pinentry_path" ]]; then
  local gpg_conf="$HOME/.gnupg/gpg-agent.conf"

  # Check if the correct pinentry is already set
  if [[ ! -f "$gpg_conf" ]] || ! grep -q "^pinentry-program $pinentry_path" "$gpg_conf" 2>/dev/null; then

    (
      mkdir -p ~/.gnupg
      
      # 1. Create a truly unique temporary file to avoid parallel write conflicts
      local tmp_conf
      tmp_conf=$(mktemp "$HOME/.gnupg/gpg-agent.conf.XXXXXX")

      # 2. Safely construct the new config in the unique temp file
      if [[ -f "$gpg_conf" ]]; then
        grep -v "^pinentry-program" "$gpg_conf" > "$tmp_conf" 2>/dev/null || true
      fi
      echo "pinentry-program $pinentry_path" >> "$tmp_conf"

      # 3. Use mv for an ATOMIC replacement (no blank-file gap like 'cat' has)
      mv "$tmp_conf" "$gpg_conf"

      # 4. Silently reload gpg-agent
      gpg-connect-agent reloadagent /bye >/dev/null 2>&1
    ) &!

  fi
fi
