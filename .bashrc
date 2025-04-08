#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lhA'
alias update='sudo pacman -Syu'
alias oops='sudo $(fc -ln -1)' 
alias grep='grep --color=auto'

PS1='[\u@\h \W]\$ '
