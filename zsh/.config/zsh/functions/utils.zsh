#!/usr/bin/env zsh

# backup <file/folder>           — timestamped tar.gz backup
backup() {
	emulate -L zsh
	if [[ -z $1 ]]; then
		_err "Missing argument. Usage: backup <file/folder>"
		print -- "${COLOR_NORMAL}    Run 'backup --help' for more info${COLOR_RESET}"
		return 1
	fi
	local timestamp=${(%):-%D{%Y%m%d_%H%M%S}}
	local backup_name="${1}_backup_${timestamp}.tar.gz"
	if tar -czf "$backup_name" "$1" 2>/dev/null; then
		_ok "Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
	else
		_err "Backup failed!"
		return 1
	fi
}

# t      <command>               — run a command with timestamped output (needs `ts`)
if ((${+commands[ts]})); then
	t() {
		emulate -L zsh
		(($# == 0)) && {
			_err "Missing argument. Usage: t <command>"
			return 1
		}
		local D_CLR=$COLOR_NORMAL T_CLR=$COLOR_HEADER R=$COLOR_RESET
		_ok "Executing with timestamps..."
		env FORCE_COLOR=3 CLICOLOR_FORCE=1 stdbuf -oL -eL "$@" 2>&1 |
			ts "${D_CLR}[%Y-%m-%d${R} ${T_CLR}%H:%M:%S]${R}"
	}
fi
