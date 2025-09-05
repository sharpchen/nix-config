[[ $- != *i* ]] && return

export PS1="\n\[\033[1;32m\][\u@\h:\w]\$\[\033[0m\] "

alias ls='ls --color=auto -h'
alias ll='ls -la'
alias grep='grep --color=auto -i'
alias md='mkdir -p'
alias rd='rm -rf'
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
alias v=nvim
alias ngc='nix-collect-garbage -d && sudo $(which nix-collect-garbage) -d'

if type nix-store &>/dev/null; then
    #######################################
    # Get nix store path of a package
    # Arguments:
    #   $1 main program
    #######################################
    nsp() {
        nix-store -q --outputs "$(type -fP "$1")"
    }

    if type fzf &>/dev/null; then
        _fzf_complete_nsp() {
            _fzf_complete -- "$@" < <(compgen -c | sort -u)
        }
        _fzf_complete_type() {
            _fzf_complete -- "$@" < <(compgen -c | sort -u)
        }
        _fzf_complete_which() {
            _fzf_complete -- "$@" < <(compgen -c | sort -u)
        }

        complete -F _fzf_complete_nsp nsp
        complete -F _fzf_complete_type type
        complete -F _fzf_complete_which which
    fi

    if type blesh-share &>/dev/null; then
        # shellcheck source=/dev/null
        source -- "$(blesh-share)/ble.sh" --attach=none
        ble-import -d "$(blesh-share)/contrib/integration/fzf-completion.bash"
        ble-import -d "$(blesh-share)/contrib/integration/fzf-key-bindings.bash"

        function sharpchen/vim-load-hook {
            bleopt keymap_vi_mode_show=
        }
        blehook/eval-after-load keymap_vi sharpchen/vim-load-hook

        ble-face -s syntax_command fg=blue
        ble-face -s syntax_function_name fg=blue
        ble-face -s syntax_command fg=blue
        ble-face -s syntax_varname fg=green,bold
        ble-face -s command_builtin_dot fg=blue
        ble-face -s command_builtin fg=blue
        ble-face -s command_alias fg=blue
        ble-face -s command_function fg=blue
        ble-face -s command_file fg=blue
        ble-face -s command_keyword fg=magenta
        ble-face -s filename_executable fg=blue
        ble-face -s syntax_history_expansion fg=gray,bg=
        ble-face -s syntax_param_expansion fg=yellow,bold
        ble-face -s syntax_error fg=red
        ble-face -s argument_option fg=magenta
        ble-face -s auto_complete fg=gray
        bleopt highlight_filename=
        bleopt highlight_variable=
        bleopt prompt_eol_mark=''
        bleopt prompt_eol_mark='↵'

        [[ ! ${BLE_VERSION-} ]] || ble-attach
    fi
fi

if type fzf &>/dev/null; then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }

    eval "$(fzf --bash)"
    export FZF_DEFAULT_OPTS_FILE=~/.fzfrc
fi

if type less &>/dev/null; then
    export PAGER=less
fi

if type nvim &>/dev/null; then
    export MANPAGER='nvim +Man!'
fi

if type dotnet &>/dev/null; then
    # alias dn=dotnet

    function _dotnet_bash_complete() {
        local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
        local candidates
        read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)
        read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
    }

    complete -f -F _dotnet_bash_complete dotnet
    complete -f -F _dotnet_bash_complete dn

    # export PATH="$PATH:/home/$USER/.dotnet/tools"
fi

if type yazi &>/dev/null; then
    function y() {
        local tmp cwd
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd" || return
        fi
        rm -f -- "$tmp"
    }
fi

if type zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi
