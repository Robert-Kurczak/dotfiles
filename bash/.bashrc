#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vi='vim'
alias bonsai='cbonsai -li'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

source ~/.config/bash/mocha.sh
source ~/.config/bash/git-prompt.sh

GIT_PS1_SHOWUPSTREAM="verbose"

PS1=''
PS1+='[\[\e[38;5;${MOCHA_LAVENDER}m\]\w\[\e[0m\]]'		# [Working directory]
PS1+='$(__git_ps1 "[\[\e[38;5;${MOCHA_BLUE}m\]%s\[\e[0m\]]")'	# [Git branch]
PS1+=' > '							# Prompt sign
