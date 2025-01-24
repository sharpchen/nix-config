Set-Alias lg lazygit
Set-Alias dn dotnet

function vim {
    nvim --clean -c 'source ~/.vimrc' @args
}

function v {
    nvim @args
}

function :q {
    exit
}

if (Get-Command 'home-manager' -ErrorAction SilentlyContinue) {
    function hms {
        home-manager switch --flake "~/.config/home-manager#$env:USERNAME"
    }
}

function pj {
    Set-Location (Get-ChildItem '~/projects' -Directory | ForEach-Object FullName | fzf)
}
