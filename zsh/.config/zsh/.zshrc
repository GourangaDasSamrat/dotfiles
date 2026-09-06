# GPG
export GPG_TTY=$(tty)

# ZSH completion cache
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
mkdir -p ~/.cache/zsh

# Some oh-my-zsh plugins expect $ZSH_CACHE_DIR to already
# be set — normally oh-my-zsh.sh does this; we do it ourselves for antidote.
export ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"

# Antidote plugin manager
ANTIDOTE_HOME="$HOME/.antidote"
[[ -d "$ANTIDOTE_HOME" ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
source "$ANTIDOTE_HOME/antidote.zsh"

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

antidote load "$ZDOTDIR/.zsh_plugins.txt"

# Starship
eval "$(starship init zsh)"

# Load modules
zsh_modules=(
	core/env
	core/colors
	core/history
	functions/utils
	functions/archive
	functions/chpwd
	plugins/fzf
	plugins/pass
	user/aliases
	functions/security
	user/overrides
	functions/whois
	functions/network
)

for mod in "${zsh_modules[@]}"; do
	file="$ZDOTDIR/${mod}.zsh"
	if [[ -f "$file" ]]; then
		source "$file"
	else
		echo "⚠️  missing: $file" >&2
	fi
done
unset zsh_modules mod file

# Display session start time
if [[ -n "$COLOR_HEADER" ]]; then
	echo -e "${COLOR_HEADER}󱑎 Session started:${COLOR_RESET} ${COLOR_NORMAL}$(date '+%A, %d %B %Y | %I:%M %p')${COLOR_RESET}"
else
	date '+%A, %d %B %Y | %I:%M %p'
fi

# Load local secrets
if [[ -f "$HOME/.zsh_secrets" ]]; then
	[[ "$(stat -c %a "$HOME/.zsh_secrets" 2>/dev/null || stat -f %OLp "$HOME/.zsh_secrets")" != "600" ]] &&
		echo "⚠️  ~/.zsh_secrets is not chmod 600" >&2
	source "$HOME/.zsh_secrets"
fi
