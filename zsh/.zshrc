# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Disable Theme
ZSH_THEME=""

# Oh My Zsh Plugins
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# BAT theme
export BAT_THEME="Dracula"

# Starship
eval "$(starship init zsh)"

# Custom alias
alias debian=TERM='xterm-256color proot-distro login debian --user gouranga'
alias df='cd ~/../usr/var/lib/proot-distro/installed-rootfs/debian/home/gouranga/'

alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias lt='eza --tree -a -I "node_modules|.git"'
alias la='ls -A'

alias code=code-oss
alias code-c='code --profile "C/C++ Dev"'
alias code-f='code --profile "Frontend Dev"'
alias code-b='code --profile "Backend Dev"'
alias code-p='code --profile "Python Dev"'

# Load colors
source ~/.config/zsh/colors.zsh

# Core overrides
source ~/.config/zsh/overrides.zsh

# Archive tools
source ~/.config/zsh/archive.zsh

# Utilities
source ~/.config/zsh/utils.zsh

# Weather
source ~/.config/zsh/weather.zsh
