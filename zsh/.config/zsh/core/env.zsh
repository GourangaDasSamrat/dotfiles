# --- Environment Variables ---
export DOTFILES="$HOME/dotfiles"             # Path to dotfiles directory
export UV_LINK_MODE=copy                     # Symlink mode for UV
export BAT_THEME="Dracula"                   # Syntax highlighting theme
export BUN_INSTALL="$HOME/.bun"              # Bun installation directory
export NVM_DIR="$HOME/.nvm"                  # NVM installation directory
export PNPM_HOME="$HOME/.local/share/pnpm"   # PNPM home

# --- Completions & Loaders ---
# Load Bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
# Load NVM and its completions
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# --- Path Management ---
typeset -U path   	       # Prevent duplicate PATH entries
path=(
  "$PNPM_HOME"                 # pnpm global bin (IMPORTANT)
  "$BUN_INSTALL/bin"           # Bun binaries
  "/opt/homebrew/bin"          # Homebrew binaries (Apple Silicon)
  "/opt/homebrew/sbin"         # Homebrew sbin (Apple Silicon)
  "$HOME/.cargo/bin"           # Rust/Cargo binaries
  $HOME/{go/bin,.local/bin}(N-/)
  $path
)
export PATH

# Load Homebrew shellenv (sets HOMEBREW_PREFIX and other vars)
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
