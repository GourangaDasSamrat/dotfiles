# GPG
export GPG_TTY=$(tty)

# ZSH
export ZDOTDIR="$HOME/.config/zsh"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""
plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting fzf-tab)
[[ -d "$ZSH" ]] && source "$ZSH/oh-my-zsh.sh"

# Starship
eval "$(starship init zsh)"

# Load modules
zsh_modules=(
  env colors
  aliases overrides
  fzf utils
  chpwd archive pass
  history
)
for mod in "${zsh_modules[@]}"; do
  file="$ZDOTDIR/${mod}.zsh"
  [[ -f "$file" ]] && source "$file" || echo "⚠️  missing: ${mod}.zsh" >&2
done
unset zsh_modules mod file

# Load local secrets
if [[ -f "$HOME/.zsh_secrets" ]]; then
  [[ "$(stat -c %a "$HOME/.zsh_secrets" 2>/dev/null || stat -f %OLp "$HOME/.zsh_secrets")" != "600" ]] \
    && echo "⚠️  ~/.zsh_secrets is not chmod 600" >&2
  source "$HOME/.zsh_secrets"
fi
