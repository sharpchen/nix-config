Set-Alias lg lazygit
Set-Alias dn dotnet

function vim {
    nvim -u '~/.vimrc' @args
}

function v {
    nvim @args
}

function :q {
    exit
}

function .. {
    Set-Location ..
}

function so {
    . $PROFILE
}

if (Get-Command 'home-manager' -ErrorAction SilentlyContinue) {
    function hms {
        home-manager switch --flake "~/.config/home-manager#$env:USER"
    }
}

function pj {
    begin {
        Get-Command fzf -ea SilentlyContinue | Out-Null
    }
    end {
        $folders = Get-ChildItem '~/projects' -Directory
        if (Test-Path '~/.config/home-manager/') {
            $folders += Get-Item '~/.config/home-manager/'
        }
        Set-Location ($folders | ForEach-Object FullName | fzf)
    }
}
