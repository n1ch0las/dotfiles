#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
alias hrep='history | grep' 	# requires an argument
alias ls='ls --color=auto'
alias ll='ls -lhA'
alias oops='sudo $(fc -ln -1)'
alias pkgdump='pacman -Qqen > ~/.pkglist && pacman -Qqem > ~/.aurlist' 
alias update='sudo pacman -Syu'

PS1='[\u@\h \W]\$ '
