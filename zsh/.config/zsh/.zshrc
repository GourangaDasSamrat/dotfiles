# GPG
export GPG_TTY=$(tty)

# ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_COMPDUMP=$HOME/.cache/zsh/zcompdump
mkdir -p ~/.cache/zsh

ZSH_THEME=""
plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting fzf-tab)
[[ -d "$ZSH" ]] && source "$ZSH/oh-my-zsh.sh"

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
  user/overrides
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

# Load local secrets
if [[ -f "$HOME/.zsh_secrets" ]]; then
  [[ "$(stat -c %a "$HOME/.zsh_secrets" 2>/dev/null || stat -f %OLp "$HOME/.zsh_secrets")" != "600" ]] \
    && echo "⚠️  ~/.zsh_secrets is not chmod 600" >&2
  source "$HOME/.zsh_secrets"
fi
