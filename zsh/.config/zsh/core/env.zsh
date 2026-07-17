# --- Termux Specific Environment Variables ---
if [[ -d $PREFIX ]]; then
  export SSL_CERT_FILE=$PREFIX/etc/tls/cert.pem 		# Path to SSL certificates
  export XDG_DATA_HOME="$HOME/.local/share"  			# Unix base directory
  export TZ="Asia/Dhaka"                                        # Set timezone

  (( ${+commands[bun]} )) && export BUN_OPTIONS="--os=android"  # Bun os option

  if (( ${+commands[moto_server]} )); then
    export MOTO_ENABLE_RECORDING=True				# Enable Moto server recording
    export MOTO_RECORDER_FILE="$HOME/.moto_history"		# Path to save Moto recording history
  fi
fi

# --- Editor & Pager ---
export EDITOR="hx"      # Set Helix as default editor
export VISUAL="$EDITOR" # Set Visual editor
export PAGER="less"     # Default pager for long outputs

# --- Environment Variables ---
export DOTFILES="$HOME/dotfiles"           # Path to dotfiles directory
export UV_LINK_MODE=copy                   # Symlink mode for UV
export BAT_THEME="Dracula"                 # Syntax highlighting theme
export BUN_INSTALL="$HOME/.bun"            # Bun installation directory
export PNPM_HOME="$HOME/.local/share/pnpm" # PNPM home
export GOPATH="$HOME/go"                   # Go workspace directory
export CARGO_NET_GIT_FETCH_WITH_CLI=true   # Use system git for better auth/network stability

# --- Completions & Loaders ---
# Load Bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Load fnm (Fast Node Manager) and auto-switch node versions on directory change
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# --- Path Management ---
typeset -U path # Prevent duplicate PATH entries

# Load Homebrew shellenv dynamically using architecture check
if [[ "$CPUTYPE" == "arm64" && -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Set custom paths
path=(
  "$PNPM_HOME"            # pnpm global bin
  "$BUN_INSTALL/bin"      # Bun binaries
  "$HOME/.cargo/bin"      # Rust/Cargo binaries
  "$GOPATH/bin"           # Go binaries
  "$HOME/.local/bin"      # Local user binaries
  $path
)
export PATH
