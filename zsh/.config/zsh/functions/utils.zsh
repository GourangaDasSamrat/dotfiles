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
