# --- Termux Specific Environment Variables ---
if [[ -d $PREFIX ]]; then
  export SSL_CERT_FILE=$PREFIX/etc/tls/cert.pem                         # Path to SSL certificates
  export XDG_DATA_HOME=$HOME/.local/share                               # Unix base directory
  export TZ=Asia/Dhaka                                                  # Set timezone

  (( $+commands[bun] )) && export BUN_OPTIONS=--os=android              # Bun os option
fi

# --- Editor & Pager ---
export EDITOR=hx        # Set Helix as default editor
export VISUAL=$EDITOR   # Set Visual editor
export PAGER=less       # Default pager for long outputs

# --- Environment Variables ---
export DOTFILES=$HOME/dotfiles             # Path to dotfiles directory
export UV_LINK_MODE=copy                   # Symlink mode for UV
export BAT_THEME=Dracula                   # Syntax highlighting theme
export BUN_INSTALL=$HOME/.bun              # Bun installation directory
export PNPM_HOME=$HOME/.local/share/pnpm   # PNPM home
export GOPATH=$HOME/go                     # Go workspace directory
export CARGO_NET_GIT_FETCH_WITH_CLI=true   # Use system git for better auth/network stability

# --- Completions & Loaders ---
# Load Bun completions
[[ -s $BUN_INSTALL/_bun ]] && source $BUN_INSTALL/_bun

# Load fnm (Fast Node Manager) and auto-switch node versions on directory change
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# --- Path Management ---
typeset -U path # Prevent duplicate PATH entries

# Load Homebrew shellenv dynamically using architecture check
[[ $CPUTYPE == arm64 && -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv) ||
[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

# Set custom paths
path=(
  $PNPM_HOME                       # pnpm global bin
  $BUN_INSTALL/bin                 # Bun binaries
  $HOME/.cargo/bin                 # Rust/Cargo binaries
  $GOPATH/bin                      # Go binaries
  $HOME/.local/bin                 # Local user binaries
  $path
)

path=($^path(N/))
