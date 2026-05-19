# --- Termux Specific Aliases ---
if [[ -d /data/data/com.termux ]]; then
  alias debian="TERM='xterm-256color' proot-distro login debian --user gouranga"
  alias df="cd /data/data/com.termux/files/usr/var/lib/proot-distro/containers/debian/rootfs/home/gouranga/Developer"
  alias af="cd /data/data/com.termux/files/home/storage/shared"
  alias start="/data/data/com.termux/files/home/start.sh"
fi

# --- Conditional Aliases ---
(( ${+commands[fdfind]} )) && alias fd='fdfind'
(( ${+commands[batcat]} )) && alias bat='batcat'

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
  alias lt='eza --tree -a -I "node_modules|.git"'
fi
alias la='ls -A'

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

# --- GitHub CLI's Aliases ---
if (( ${+commands[gh]} )); then
  # Present
  alias ght='gh today'
  alias ghts='gh today-summary'
  alias ghst='gh today-stats'
  alias ghm='gh this-month-summary'
  alias ghms='gh this-month-stats'
  alias ghy='gh this-year-summary'
  alias ghys='gh this-year-stats'
  alias ghstr='gh streak'
  alias ghl='gh this-year-languages'

  # Past
  alias ghyy='gh yesterday'
  alias ghyys='gh yesterday-summary'
  alias ghyyst='gh yesterday-stats'
  alias ghlm='gh last-month-summary'
  alias ghlms='gh last-month-stats'
  alias ghly='gh last-year-summary'
  alias ghlys='gh last-year-stats'
  alias ghlyl='gh last-year-languages'

  # Utilities
  alias ghp='gh prs'
  alias gho='gh open'
  alias ghc='gh co'
fi

# --- usql's Aliases ---
(( ${+commands[usql]} )) && alias usql='usql -q'
