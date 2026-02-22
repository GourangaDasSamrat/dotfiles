# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Fzf preview
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window rounded:right:60%"

# Disable Theme
ZSH_THEME=""

# Oh My Zsh Plugins
plugins=(
	git
	fzf
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# history setup
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# BAT theme
export BAT_THEME="Dracula"

# Starship
eval "$(starship init zsh)"

# Load all zsh modules
for file in ~/.config/zsh/{colors,overrides,utils,aliases,archive,weather,apireq}.zsh; do
    [[ -f "$file" ]] && {
        source "$file"
    }
done
