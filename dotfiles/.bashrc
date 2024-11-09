#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -h'
alias ll='ls -la'
alias grep='grep --color=auto -i'
alias mkdir='mkdir -pv'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'
alias df='df -h'
alias du='du -h'
alias history='history | nl'
alias ds='du -sh * | sort -rh'
alias cls='clear'
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias so='source ~/.bashrc'
alias :q='exit'
alias hms='home-manager switch --flake ~/.config/home-manager#$USER'
alias lg=lazygit
alias proj='cd $(ls -d ~/projects/* ~/.config/* | fzf)'

PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"
