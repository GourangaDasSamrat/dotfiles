# --- Environment Variables ---
export DOTFILES="$HOME/dotfiles" # Path to dotfiles directory
export UV_LINK_MODE=copy         # Symlink mode for UV
export BAT_THEME="Dracula"       # Syntax highlighting theme
export BUN_INSTALL="$HOME/.bun"  # Bun installation directory
export NVM_DIR="$HOME/.nvm"      # NVM installation directory

# --- Completions & Loaders ---
# Load Bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Load NVM and its completions
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"                   # Main script
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion" # Shell completion

# --- Path Management ---
typeset -U path # Prevent duplicate entries in PATH

path=(
  "$BUN_INSTALL/bin"             # Add Bun binaries
  $HOME/{go/bin,.local/bin}(N-/) # Add Go and local binaries (if exist)
  $path                          # Append existing paths
)

export PATH # Sync to environment
