# Theme Definitions

_fzf_theme_dracula() {
	export FZF_DEFAULT_OPTS='
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
    --color=border:#6272a4'
}

_fzf_theme_catppuccin() {
	export FZF_DEFAULT_OPTS='
    --color=fg:#cdd6f4,bg:#1e1e2e,hl:#cba6f7
    --color=fg+:#cdd6f4,bg+:#313244,hl+:#cba6f7
    --color=info:#f38ba8,prompt:#cba6f7,pointer:#f5c2e7
    --color=marker:#a6e3a1,spinner:#f5c2e7,header:#f38ba8
    --color=border:#45475a'
}

# Active Theme (switch between _fzf_theme_dracula / _fzf_theme_catppuccin)

_fzf_theme_dracula

# Initialize fzf key bindings and fuzzy completion

eval "$(fzf --zsh)"

# Search Command (fd: faster, includes hidden, excludes .git)

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Completion Generators (fd-based)

# Path completion candidates
_fzf_compgen_path() {
	fd --hidden --exclude .git . "$1"
}

# Directory completion candidates
_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "$1"
}

# Preview Settings (requires: eza, bat)

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Context-aware Preview (comprun)

_fzf_comprun() {
	local command=$1
	shift
	case "$command" in
	cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
	export | unset) fzf --preview "eval 'echo \${}'" "$@" ;;
	ssh) fzf --preview 'dig {}' "$@" ;;
	*) fzf --preview "$show_file_or_dir_preview" "$@" ;;
	esac
}

# FZF-TAB Configuration (Improved Preview Logic)

# Use your theme colors and flags
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS) --inline-info

# Enhanced Preview: handling both files and directories specifically for fzf-tab
# Note: $realpath is a special variable used by fzf-tab to point to the selected item
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [ -d $realpath ]; then
    eza --tree --color=always $realpath | head -200
  else
    bat -n --color=always --line-range :500 $realpath
  fi'

# Specific preview for 'cd' command
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always $realpath | head -200'

# Layout and group styling
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group '<' '>'


# Load fzf-tab plugin
[[ -f ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh ]] && \
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh
