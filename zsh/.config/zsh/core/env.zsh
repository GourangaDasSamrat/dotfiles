# Dotfiles
export DOTFILES="$HOME/dotfiles"

# UV
export UV_LINK_MODE=copy

# BAT
export BAT_THEME="Dracula"

# Path
go_bin="$HOME/go/bin"
uv_bin="$HOME/.local/bin"

export PATH="$go_bin:$uv_bin:$PATH"

unset go_bin
unset uv_bin
