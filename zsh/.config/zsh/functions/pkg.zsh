#!/usr/bin/env zsh

# Generic wrapper: cmd, install-flag/subcmd, remove-flag/subcmd
_pkg_wrapper() {
	local cmd=$1 install=$2 remove=$3
	(( $+commands[$cmd] )) || return

	eval "
	$cmd() {
		if [[ \$1 == i ]]; then
			shift
			command $cmd $install \"\$@\"
		elif [[ \$1 == rm ]]; then
			shift
			command $cmd $remove \"\$@\"
		else
			command $cmd \"\$@\"
		fi
	}
	"
	compdef _$cmd $cmd 2>/dev/null
}

_pkg_wrapper apt  install remove
_pkg_wrapper brew install uninstall
_pkg_wrapper dnf  install remove

unfunction _pkg_wrapper
