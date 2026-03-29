# GPG setup for terminal prompts
export GPG_TTY=$(tty)

# Dotfiles
export DOTFILES="$HOME/dotfiles"

# Go bin path
export PATH="$HOME/go/bin:$PATH"

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Disable Theme
ZSH_THEME=""

# Oh My Zsh Plugins
plugins=(
	git
	fzf
	zsh-autosuggestions
	zsh-syntax-highlighting
	fzf-tab
)

# history setup
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

zshaddhistory() {
  local cmd="$1"
  # Skip if matches any sensitive pattern
  [[ $cmd != pass\ *        ]] &&  # password manager
  [[ $cmd != *password*     ]] &&  # inline passwords
  [[ $cmd != *passwd*       ]] &&  # passwd variants
  [[ $cmd != *secret*       ]] &&  # secrets
  [[ $cmd != *api_key*      ]] &&  # API keys
  [[ $cmd != *token*        ]] &&  # tokens
  [[ $cmd != export\ *=*    ]] &&  # env var exports
  [[ $cmd != *Authorization* ]]    # auth headers
}

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# BAT theme
export BAT_THEME="Dracula"

# Starship
eval "$(starship init zsh)"

# Load all zsh modules
for file in ~/.config/zsh/{colors,aliases,overrides,fzf,utils,chpwd,archive,pass}.zsh; do
    [[ -f "$file" ]] && {
        source "$file"
    }
done

# Load local secrets if they exist
if [[ -f "$HOME/.zsh_secrets" ]]; then
    source "$HOME/.zsh_secrets"
fi
