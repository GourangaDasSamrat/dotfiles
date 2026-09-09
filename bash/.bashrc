# Only load in interactive shells
[[ $- != *i* ]] && return
# ── Environment
export DOTFILES="$HOME/dotfiles"
export BAT_THEME="Dracula"
export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.bun/bin:$HOME/.cargo/bin:$PATH"
# ── History
HISTFILE="$HOME/.bash_history"
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="pass *:op *:bw *:gpg *:openssl *:curl *:wget *:docker login*:gh auth*"
shopt -s histappend cmdhist
# ── Shell options
shopt -s checkwinsize globstar autocd cdspell
# ── Aliases (mirrored from user/aliases.zsh)
command -v fdfind &>/dev/null && alias fd='fdfind'
command -v batcat &>/dev/null && alias bat='batcat'
if command -v code-oss &>/dev/null; then
  alias code='code-oss'
elif command -v code-insiders &>/dev/null; then
  alias code='code-insiders'
fi
[[ -d "$DOTFILES" ]] && alias dot='cd "$DOTFILES"'
alias reload="source ~/.bashrc && echo 'Bash config reloaded!'"
alias cp='cp -iv'
alias mv='mv -iv'
if command -v eza &>/dev/null; then
  alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
  alias lt='eza --tree -a -I "node_modules|.git"'
fi
alias la='ls -A'
if command -v go &>/dev/null; then
  alias gr='go run .'
  alias gb='go build'
  alias gmod='go mod'
fi
alias lock-vault="gpg-connect-agent reloadagent /bye > /dev/null 2>&1"
# ── Safe delete (rm → trash)
if [[ "$(uname -s)" == "Darwin" ]] && command -v trash &>/dev/null; then
  alias rm='trash'
elif [[ "$(uname -s)" == "Linux" ]] && command -v gtrash &>/dev/null; then
  alias rm='gtrash put'
fi

# ── Completion
bash_comp_bases=(
    "/data/data/com.termux/files/usr/share/bash-completion"  # Termux
    "/usr/share/bash-completion"                             # Linux
    "/opt/homebrew/share/bash-completion"                    # Mac Apple Silicon
    "/usr/local/share/bash-completion"                       # Mac Intel
)

for comp_file in "${bash_comp_bases[@]}"; do
    if [ -f "$comp_file" ]; then
        . "$comp_file"
        break
    fi
done
