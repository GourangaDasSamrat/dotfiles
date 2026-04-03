# Dotfiles
export DOTFILES="$HOME/dotfiles"

# UV
export UV_LINK_MODE=copy

# BAT
export BAT_THEME="Dracula"

# Unique paths only
typeset -U path

# Add dirs to path if they exist (silently)
path=($HOME/{go/bin,.local/bin}(N-/) $path)
