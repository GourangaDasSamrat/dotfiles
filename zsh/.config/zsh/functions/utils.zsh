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

# Shared command runner for functions that wrap a real binary (mkdir, rm).
# Runs it through sudo when called via the sudo() wrapper below, which flags
# that with the dynamically scoped _sudo_active.
_exec_bin() {
	emulate -L zsh
	if ((_sudo_active)); then
		command sudo "$@"
	else
		command "$@"
	fi
}

# Functions that know how to run under sudo; they register in user/overrides.
typeset -ga _SUDO_AWARE=()

# sudo <cmd> [args]              — also handles `apt i`/`apt rm` and the safer mkdir/rm
# sudo only sees binaries, never shell functions, so those would be bypassed.
# Defined only when sudo exists, so a missing sudo is not highlighted as valid.
if ((${+commands[sudo]})); then
	sudo() {
		emulate -L zsh
		local cmd=$1

		# sudo apt i git -> sudo apt install git
		if ((${+_PKG_INSTALL[$cmd]})) && [[ $2 == (i|rm) ]]; then
			local sub=${_PKG_INSTALL[$cmd]}
			[[ $2 == rm ]] && sub=${_PKG_REMOVE[$cmd]}
			command sudo "$cmd" "$sub" "${@:3}"
			return
		fi

		# Run the function itself; _exec_bin elevates the real command inside it
		if ((${+functions[$cmd]})) && ((${_SUDO_AWARE[(Ie)$cmd]})); then
			local -i _sudo_active=1
			"$cmd" "${@:2}"
			return
		fi

		command sudo "$@"
	}
fi
