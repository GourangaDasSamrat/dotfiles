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
