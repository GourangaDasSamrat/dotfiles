# --- Termux Specific Aliases ---
if [[ -d /data/data/com.termux ]]; then
  alias debian="TERM='xterm-256color' proot-distro login debian --user gouranga"
  alias lf="cd $PREFIX/var/lib/proot-distro/containers/debian/rootfs/home/gouranga"
  alias af="cd /storage/emulated/0"
  alias start="$HOME/start.sh"
  alias apt='apt ' i='install' && compdef _apt i=apt 2>/dev/null
fi

# --- Conditional Aliases ---
(( ${+commands[fdfind]} )) && alias fd='fdfind'
(( ${+commands[batcat]} )) && alias bat='batcat'
(( $+commands[bun] )) && bun() {
    (( $# == 0 )) && { [[ -f package.json ]] && command bun install || command bun repl; } || command bun "$@"
}

# --- Navigation and Config Aliases ---
if [[ -d "$DOTFILES" ]]; then
  alias dot='cd "$DOTFILES"'
  alias dots='cd "$DOTFILES/scripts"'
fi
alias reload="source ~/.config/zsh/.zshrc && echo 'ZSH Config Reloaded!'"

# --- Safety ---
alias cp='cp -iv'
alias mv='mv -iv'
alias afk="lock-vault && clear && exit"
alias play="cat > /dev/null"

# --- Gpg's Aliases ---
alias lock-vault="gpg-connect-agent reloadagent /bye > /dev/null 2>&1"

# --- Eza's Aliases ---
if (( ${+commands[eza]} )); then
  alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
  alias lt='eza --tree -a -I "node_modules|.git|target"'
fi
alias la='ls -A'

# --- Open command for Linux (mimicking macOS 'open') ---
if (( ${+commands[xdg-open]} )); then
  alias open='xdg-open'
fi

# --- Vscode's Aliases ---
if (( ${+commands[code-oss]} )); then
  alias code='code-oss --profile Default'
elif (( ${+commands[code-insiders]} )); then
  alias code='code-insiders --profile Default'
elif (( ${+commands[code]} )); then
  alias code='command code --profile Default'
fi

if alias code >/dev/null 2>&1 || (($ + commands[code])); then
  alias code-b='code --profile "Backend Dev"'
  alias code-c='code --profile "C/C++ Dev"'
  alias code-d='code --profile "Database Dev"'
  alias code-f='code --profile "Frontend Dev"'
  alias code-g='code --profile "Go Dev"'
  alias code-l='code --profile "Lua Dev"'
  alias code-p='code --profile "Python Dev"'
  alias code-r='code --profile "Rust Dev"'
  alias code-w='code --profile "Wiki Dev"'
fi

# --- Go's Aliases ---
if (( ${+commands[go]} )); then
  alias gr='go run .'
  alias gb='go build'
  alias gmod='go mod'
fi

# --- Cargo's Aliases ---
if (( ${+commands[cargo]} )); then
  # Basic Workflow
  alias cr='cargo run'
  alias cb='cargo build'
  alias ct='cargo test'
  alias cc='cargo check'
  alias cn='cargo new'

  # Cleanup & Docs
  alias ccl='cargo clean'
  alias cdoc='cargo doc --open'
  alias cdc='cargo doc --no-deps --open'
fi

# --- usql's Aliases ---
(( ${+commands[usql]} )) && alias usql='usql -q'
