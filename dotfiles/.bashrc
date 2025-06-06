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
alias p='cd $(ls -d ~/projects/* | cat - <(echo -n "${HOME}/.config/home-manager/") | fzf)'
alias vim='nvim -u ~/.vimrc'
alias dn=dotnet
alias v=nvim
alias ngc='nix-collect-garbage -d && sudo $(which nix-collect-garbage) -d'

if type nix-store >/dev/null; then
    #######################################
    # Get nix store path of a package
    # Arguments:
    #   $1 main program
    #######################################
    nsp() {
        nix-store -q --outputs "$(type -fP "$1")"
    }
fi

_fzf_complete_nsp() {
    _fzf_complete -- "$@" < <(compgen -c | sort -u)
}

complete -F _fzf_complete_nsp nsp

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd" || return
    fi
    rm -f -- "$tmp"
}

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

if type less >/dev/null; then
    export PAGER=less
fi

if type nvim >/dev/null; then
    export MANPAGER='nvim +Man!'
fi

if type dotnet >/dev/null; then
    DOTNET_ROOT="$(nsp dotnet)/share/dotnet"
    export DOTNET_ROOT
fi

eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
