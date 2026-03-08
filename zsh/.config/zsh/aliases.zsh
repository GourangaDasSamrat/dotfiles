alias debian=TERM='xterm-256color proot-distro login debian --user gouranga'
alias df='cd ~/../usr/var/lib/proot-distro/installed-rootfs/debian/home/gouranga/'
alias af='cd ~/storage/shared'

# Conditional Aliases
(( $+commands[fdfind] )) && alias fd='fdfind'
(( $+commands[batcat] )) && alias bat='batcat'

if (( $+commands[code-oss] )); then
    alias code='code-oss'
elif (( $+commands[code-insiders] )); then
    alias code='code-insiders'
fi

# Eza's Aliases
if (( $+commands[eza] )); then
    alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
    alias lt='eza --tree -a -I "node_modules|.git"'
fi
    alias la='ls -A'


# Vscode's Aliases
if (( $+commands[code] )) || alias code >/dev/null 2>&1; then
    alias code-b='code --profile "Backend Dev"'
    alias code-c='code --profile "C/C++ Dev"'
    alias code-d='code --profile "Database Dev"'
    alias code-f='code --profile "Frontend Dev"'
    alias code-g='code --profile "Go Dev"'
fi
