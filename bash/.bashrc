#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias feh='feh -Zxd.'

source ~/.config/bash/mocha.sh
source ~/.config/bash/git-prompt.sh

GIT_PS1_SHOWUPSTREAM="verbose"

PS1=''
PS1+='[\[\e[38;5;${MOCHA_LAVENDER}m\]\w\[\e[0m\]]'				# [Working directory]
PS1+='$(__git_ps1 "[\[\e[38;5;${MOCHA_BLUE}m\]%s\[\e[0m\]]")'	# [Git branch]
PS1+=' > '														# Prompt sign
