#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

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
alias pj='cd $(ls -d ~/projects/* | cat - <(echo -n "${HOME}/.config/home-manager/") | fzf)'
alias vim='nvim --clean -c "source ~/.vimrc"'
alias dn=dotnet
alias v=nvim

#######################################
# Get nix store path of a package
# Arguments:
#   $1 main program
#######################################
nsp() {
    nix-store -q --outputs "$(type -fP "$1")"
}

eval "$(starship init bash)"
