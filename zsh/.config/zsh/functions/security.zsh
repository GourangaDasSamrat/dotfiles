#!/usr/bin/env zsh
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

: <<-'GPG'
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

GPG

# Shared entropy guard: validates byte-length and confirms /dev/urandom
# exists before gentoken/gensalt touch the RNG.
_require_entropy() {
	emulate -L zsh
	local -i bytes=$1
	if ((bytes <= 0)); then
		_err "Byte length must be a positive number!"
		return 1
	fi
	if [[ ! -r /dev/urandom ]]; then
		_err "/dev/urandom is not readable on this system!"
		return 1
	fi
}

# Shared RNG core: pulls raw entropy from /dev/urandom and encodes it
# without ever assigning the raw bytes to a variable (a NUL byte would
# silently truncate a zsh command substitution). base64/od invocations
# here avoid GNU-only flags (-w0, -d) so this runs unmodified on both
# macOS (BSD coreutils) and Linux (GNU coreutils). Result comes back in $REPLY.
_gen_random() {
	emulate -L zsh
	local -i bytes=$1
	local mode=$2 token

	case $mode in
	hex)
		# `od` gives portable hex on both BSD and GNU (unlike `xxd`, which
		# isn't guaranteed to be preinstalled everywhere).
		token=$(head -c "$bytes" /dev/urandom | od -An -tx1 -v | tr -d ' \n')
		;;
	base64)
		token=$(head -c "$bytes" /dev/urandom | base64 | tr -d '\n')
		;;
	base64url)
		token=$(head -c "$bytes" /dev/urandom | base64 | tr -d '\n')
		token=${token//+/-}
		token=${token//\//_}
		token=${token//=/}
		;;
	*)
		_err "Unknown encoding: $mode"
		return 1
		;;
	esac

	REPLY=$token
}

# gentoken [bytes] [-x|--hex] [-b|--base64] [-u|--url]   — secure random token
# Default: 32 bytes, URL-safe base64 (no padding) — API keys, session tokens.
gentoken() {
	emulate -L zsh
	local -i bytes=32
	local mode='base64url' arg
	for arg in "$@"; do
		case $arg in
		-x | --hex) mode='hex' ;;
		-b | --base64) mode='base64' ;;
		-u | --url) mode='base64url' ;;
		<->) bytes=$arg ;;
		-h | --help)
			print -- "${COLOR_HEADER}Usage:${COLOR_RESET} gentoken [bytes] [-x|--hex] [-b|--base64] [-u|--url]"
			return 0
			;;
		*)
			_err "Unknown argument: $arg"
			return 1
			;;
		esac
	done

	_require_entropy "$bytes" || return 1
	_gen_random "$bytes" "$mode" || return 1
	_ok "Token (${bytes}B, $mode): ${COLOR_CURSOR}$REPLY${COLOR_RESET}"
}

# gensalt [bytes] [-b|--base64]   — secure random salt, hex by default
# Default: 16 bytes hex — a common size/format for bcrypt/PBKDF2-style salts.
gensalt() {
	emulate -L zsh
	local -i bytes=16
	local mode='hex' arg
	for arg in "$@"; do
		case $arg in
		-b | --base64) mode='base64' ;;
		<->) bytes=$arg ;;
		-h | --help)
			print -- "${COLOR_HEADER}Usage:${COLOR_RESET} gensalt [bytes] [-b|--base64]"
			return 0
			;;
		*)
			_err "Unknown argument: $arg"
			return 1
			;;
		esac
	done

	_require_entropy "$bytes" || return 1
	_gen_random "$bytes" "$mode" || return 1
	_ok "Salt (${bytes}B, $mode): ${COLOR_CURSOR}$REPLY${COLOR_RESET}"
}
