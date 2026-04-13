# --- Environment Variables ---
export SHELL=/bin/zsh                  # Shell name
export DOTFILES="$HOME/dotfiles"       # Path to dotfiles directory
export UV_LINK_MODE=copy               # Symlink mode for UV
export BAT_THEME="Dracula"             # Syntax highlighting theme
export BUN_INSTALL="$HOME/.bun"        # Bun installation directory
export NVM_DIR="$HOME/.nvm"            # NVM installation directory
export PNPM_HOME="$HOME/.local/share/pnpm"   # PNPM home

# --- Completions & Loaders ---
# Load Bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Load NVM and its completions
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# --- Path Management ---
typeset -U path   # Prevent duplicate PATH entries

path=(
  "$PNPM_HOME"                 # pnpm global bin (IMPORTANT)
  "$BUN_INSTALL/bin"           # Bun binaries
  $HOME/{go/bin,.local/bin}(N-/)
  $path
)

export PATH
