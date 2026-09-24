#!/usr/bin/env zsh

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
		if ((check_in_use)) && ((${+commands[lsof]})) &&
			lsof -Pi :$port -sTCP:LISTEN -t &>/dev/null; then
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
		-b | --bind-all) bind_all=1 ;;
		<->) port=$arg ;;
		esac
	done
	_prompt_port 8000 "$port" 1
	port=$REPLY
	if ((bind_all)); then
		_ok "Starting server on ${COLOR_CURSOR}http://0.0.0.0:$port${COLOR_RESET} ${COLOR_WARNING}(network-wide)${COLOR_RESET}"
		python3 -m http.server "$port" --bind 0.0.0.0
	else
		_ok "Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
		python3 -m http.server "$port"
	fi
}

# expose <port>                  — cloudflared quick-tunnel with clean, filtered output
if ((${+commands[cloudflared]})); then
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
		while ((elapsed++ < 15)); do
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

if ((${+commands[http]})); then

	# isup    <host>  — quick up/down + status code check (needs httpie)
	isup() {
		emulate -L zsh -o extended_glob
		local target=${1:-gouranga.eu.org}

		print -- "\n${COLOR_HEADER}󰴓 Checking status for:${COLOR_RESET} ${COLOR_TEXT}${target}${COLOR_RESET}"

		local raw_output
		raw_output=$(http -F --ignore-stdin -p=h "$target" 2>&1) # -F follow redirects, -p=h headers only

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

	if ((${+commands[openssl]})); then
		# inspect <host>  — headers + TLS cert dates (needs httpie + openssl)
		inspect() {
			emulate -L zsh
			local target=${1:-gouranga.eu.org}
			local clean_url=${target#*://}
			clean_url=${clean_url%%/*}

			print -- "\n${COLOR_HEADER}󰄨 Inspecting:${COLOR_RESET} ${COLOR_TEXT}${target}${COLOR_RESET}\n"

			http -Fh "$target" 2>/dev/null |
				grep -Ei "HTTP/|server:|content-type:|x-powered-by:|cache-control:|security|strict-transport" |
				sed "s/\([^:]*:\)/${COLOR_NORMAL}\1${COLOR_RESET}/g"

			print -- "\n${COLOR_HEADER}󱈸 SSL/Certificate Info:${COLOR_RESET}"
			openssl s_client -connect "${clean_url}:443" 2>/dev/null </dev/null |
				openssl x509 -noout -dates |
				sed "s/notBefore=/${COLOR_NORMAL}Start:  ${COLOR_RESET}/" |
				sed "s/notAfter=/${COLOR_WARNING}Expiry: ${COLOR_RESET}/"
			print
		}
	fi

fi
