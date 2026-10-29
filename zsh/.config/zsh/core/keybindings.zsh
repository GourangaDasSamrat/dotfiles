#!/usr/bin/env zsh

# Open current CLI buffer in $EDITOR

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^O' edit-command-line
