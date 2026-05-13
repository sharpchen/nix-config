[[ $- != *i* ]] && return

export PS1="\n\[\e[1;32m\][\u@\h:\w]\$\[\e[0m\] "
export HISTCONTROL=ignorespace:ignoredups:erasedups

alias ls='command ls -l --all --almost-all --human-readable --color=auto --sort=size --group-directories-first --time-style=long-iso -v'
alias ll='command ls -l --all --almost-all --human-readable --color=auto --sort=size --group-directories-first --time-style=long-iso -v'
alias grep='command grep --color=auto -i'
alias md='command mkdir -p'
alias new='command touch'
alias rm='command rm -i'
alias ri='command rm'
alias rn='command mv'
alias cp='command cp -i'
alias mv='command mv -i'
alias ..='builtin cd ..'
alias df='command df -h'
alias du='command du -h'
alias ds='command du -sh * | sort -rh'
alias cls='command clear'
alias now='command date "+%Y-%m-%d %H:%M:%S"'
alias so='source ~/.bashrc'
alias :q='exit'

_err() {
    local BOLD="\e[1m"
    local RED='\e[31m'
    local NC='\e[0m'
    local source="${1:-ERROR}"
    local msg="${2:-$1}"
    echo -e "${BOLD}${RED}${source}: ${msg}${NC}" >&2
}

_warn() {
    local BOLD="\e[1m"
    local WARN='\e[33m'
    local NC='\e[0m'
    local source="${1:-WARN}"
    local msg="${2:-$1}"
    echo -e "${BOLD}${WARN}${source}: ${msg}${NC}" >&2
}

_exep() {
    if ! [[ -x "$(command -v "$1")" ]]; then
        _err "$1" "executable not found."
        return 1
    fi
}

_pathp() {
    if ! tsp "$1"; then
        _err "$1" "path not found."
        return 1
    fi
}

_filep() {
    if ! [[ -f "$1" ]]; then
        _err "$1" "file not found."
        return 1
    fi
}

_dirp() {
    if ! [[ -d "$1" ]]; then
        _err "$1" "directory not found."
        return 1
    fi
}

_strlenp() {
    local string="${1:?string required}"
    local length="${2:?length required}"
    if [[ "${#string}" -ne "${length}" ]]; then
        _err "${string}" "string length is not expected ${length}"
        return 1
    fi
}

_getoptp() {
    _exep getopt || return $?
    getopt --test &>/dev/null && true
    if [[ $? -ne 4 ]]; then
        _err 'unpack' "\`getopt\` is not of the enhanced version."
        return 1
    fi
}

_confirm() {
    local source="${1:-confirm}"
    local msg="${2:-$1}"
    _warn "${source}" "${msg}"
    local res

    read -r -p "Proceed? [y/N] " res

    case "${res}" in
    [yY][eE][sS] | [yY])
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

if [[ -e /etc/NIXOS ]]; then
    hms() {
        local flake
        local configBase
        configBase="$(command realpath ~/.config/home-manager)"

        if [[ -n $WSL_DISTRO_NAME ]]; then
            flake="${configBase}#nixos-wsl"
        elif type home-manager &>/dev/null; then
            flake="${configBase}#$USER"
        fi

        sudo nixos-rebuild switch --flake "${flake}" --option fallback true
    }
elif type home-manager &>/dev/null; then
    alias hms='home-manager switch --flake ~/.config/home-manager#$USER --option fallback true'
fi

alias lg=lazygit
alias vim='MINIMAL_NVIM=1 nvim'
alias v=nvim
alias ngc='nix-collect-garbage -d && sudo $(type -p nix-collect-garbage) -d'

if type rsync &>/dev/null; then
    rall() {
        _exep rsync || return $?
        _confirm "rall" "deleting $(realpath .)/*" || return $?

        rsync --archive --delete "$(mktemp -d)/" "$(pwd)/"
    }
    rd() {
        _exep rsync || return $?

        local dir="${1:?directory required}"
        _dirp "${dir}" || return $?

        _confirm "rd" "deleting $(realpath "${dir}")" || return $?

        rsync --archive --delete "$(mktemp -d)/" "${dir}/"
        rmdir "${dir}"
    }
    complete -d rd
else
    rall() {
        _exep find || return $?
        _confirm "rall" "deleting $(realpath .)/*" || return $?
        find . -path ".*" -delete
    }
    rd() {
        _exep find || return $?

        local dir="${1:?directory required}"
        _dirp "${dir}" || return $?

        _confirm "rd" "deleting $(realpath "${dir}")" || return $?

        find "${dir}" -delete
        rmdir "${dir}"
    }
    complete -d rd
fi

p() {
    local dir
    dir=$(find ~/projects/* -maxdepth 0 -type d | cat - <(echo -n "${HOME}/.config/home-manager/") | fzf)
    if [[ -n "$dir" ]]; then
        cd "$dir" || return
    fi
}

tsp() {
    [[ -f "$1" || -d "$1" || -L "$1" ]]
}

if type nix-store &>/dev/null; then
    #######################################
    # Get nix store path of a package
    # Arguments:
    #   $1 main program
    #######################################
    nsp() {
        nix-store -q --outputs "$(type -fP "$1")"
    }
    complete -c nsp
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

# share proxy from host in WSL when using NAT mode
# if [[ $(uname --kernel-release) =~ 'WSL' ]]; then
#     ip_bridge="$(ip route show | grep -i default | awk '{ print $3}')"
#     export HTTP_PROXY="http://${ip_bridge}:10809"
#     export HTTPS_PROXY="https://${ip_bridge}:10809"
#     export http_proxy="http://${ip_bridge}:10809"
#     export https_proxy="https://${ip_bridge}:10809"
#
#     noproxy() {
#         unset HTTP_PROXY
#         unset HTTPS_PROXY
#         unset http_proxy
#         unset https_proxy
#     }
# fi

title() {
    echo -ne "\e]0;$*\007"
}

unpack() {
    local tar bsdtar win_tar
    bsdtar=$(command -v bsdtar)
    win_tar=$(type -a -p tar | command grep WINDOWS | head -1)
    tar="${win_tar:-${bsdtar:?bsdtar not found.}}"

    local long_opts short_opts PARSED_OPTS
    local direct='n'

    long_opts='direct'
    short_opts='d'

    _getoptp || return $?

    PARSED_OPTS=$(getopt --longoptions $long_opts --options $short_opts -- "${@}") || return 2
    eval set -- "${PARSED_OPTS}" # reassign $n with parsed values

    while true; do
        case "$1" in
        -d | --direct)
            direct='y'
            shift
            ;;
        --)
            shift # skip --
            break # now it's all positional
            ;;
        *)
            _err "unpack" "Unexpected option \`$1\`"
            return 3
            ;;
        esac
    done

    local archive dest
    archive="${1:?archive unspecified}"
    dest="${2}"

    if [[ -n "${dest}" ]]; then
        if [[ ! -d "${dest}" ]]; then
            command mkdir -p "${dest}"
        fi
        if ! "${tar}" xf "${archive}" --cd "${dest}"; then
            command rm -rf "$dest"
        fi
    elif [[ "${direct}" == 'y' ]]; then
        "${tar}" xf "${archive}" --cd "${PWD}"
    else
        __unpack_RootEntries=0
        __unpack_PrevFirstSegment=''
        while read -r path; do
            local normalized
            normalized="${path/#.\//}"
            local currentFirstSegment="${normalized%%/*}"
            if [[ "${currentFirstSegment}" != "${__unpack_PrevFirstSegment}" ]]; then
                ((__unpack_RootEntries++))
                __unpack_PrevFirstSegment="${currentFirstSegment}"
            fi

            if ((__unpack_RootEntries > 1)); then
                break
            fi
        done < <("${tar}" tf "${archive}" | command grep --invert-match --fixed-strings './')

        if ((__unpack_RootEntries > 1)); then
            local basename
            basename=$(command basename "${archive%.*}")
            if [[ ! -d "${basename}" ]]; then
                mkdir "${basename}"
            fi
            "${tar}" xf "${archive}" --cd "${basename}"
        else

            "${tar}" xf "${archive}" --cd "${PWD}"
        fi
    fi
}

pmclean() {
    local pm="$1"
    case "$pm" in
    scoop)
        _exep scoop || return $?
        scoop cleanup '*'
        scoop cache rm '*'
        ;;
    nuget)
        _exep dotnet || return $?
        dotnet nuget locals all --clear
        ;;
    npm)
        _exep npm || return $?
        npm cache clean --force
        ;;
    pnpm)
        _exep pnpm || return $?
        npm cache clean --force
        ;;
    nix)
        _exep nh || return $?
        nh clean all
        ;;
    esac
}

epubpack() {
    local folder="${1:?source folder is required}"
    local out_file="${2:?output file path is required}"
    _exep zip || return $?
    _dirp "${folder}" || return $?
    _filep "${folder}/mimetype" || return $?

    local output
    output=$(command realpath -m "${out_file}")

    if [[ -f "${output}" ]]; then
        command rm "${output}"
    fi

    command env --chdir="$(command realpath "${folder}")" zip -Xr9Dq "${output}" mimetype '*'
}

hisdel() {
    local pattern="${1:?pattern required}"
    pattern="${pattern//\//\\/}" # escape / for sed expr
    _pathp "$HISTFILE" || return $?
    history -a # append history of current session
    command sed -i -E "/$pattern/Id" "$HISTFILE"
    history -r "$HISTFILE" # reload history
}

ydl() {
    _exep 'yt-dlp' || return $?
    local long_opts='format:,audio-only'
    local short_opts='f:,a'

    _getoptp || return $?

    PARSED_OPTS=$(getopt --longoptions $long_opts --options $short_opts -- "${@}") || return 2
    eval set -- "${PARSED_OPTS}" # reassign $n with parsed values

    local format
    local audio='n'
    while true; do
        case "$1" in
        -f | --format)
            shift
            format="$1"
            ;;
        -a | -audio-only)
            audio='y'
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            _err "unpack" "Unexpected option \`$1\`"
            return 3
            ;;
        esac
    done

    local flags=()

    if [[ -n "${format}" ]]; then
        flags+=("${format}")
    fi

    if [[ "$audio" == 'y' ]]; then
        flags+=('--extract-audio')
    fi

    if command -v aria2c &>/dev/null; then
        flags+=('--downloader' 'aria2c')
    fi

    if command -v deno &>/dev/null; then
        flags+=('--js-runtimes' 'deno')
    elif command -v node &>/dev/null; then
        flags+=('--js-runtimes' 'node')
    elif command -v bun &>/dev/null; then
        flags+=('--js-runtimes' 'bun')
    fi

    command yt-dlp "${flags[@]}" "${@}"
}

split() {
    if [[ -n "$2" ]]; then
        local data="$1"
        local delimiter="$2"
        IFS="${delimiter}" read -ra parts <<<"${data}"
        printf '%s\n' "${parts[@]}"
    else
        local delimiter="${1:- }"
        while read -r line; do
            IFS="${delimiter}" read -ra parts <<<"${line}"
            printf '%s\n' "${parts[@]}"
        done
    fi
}
