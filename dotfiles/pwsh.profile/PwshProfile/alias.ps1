Set-Alias lg lazygit
Set-Alias dn dotnet

function vim {
    nvim -u '~/.vimrc' @args
}

function vw {
    nvim -u '~/.vimrc' @args -c @'
    set wrap
'@
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
    Import-Module PwshProfile -Scope Global -Force
}

if (Get-Command 'home-manager' -ErrorAction Ignore) {
    function hms {
        home-manager switch --flake ((Resolve-Path '~/.config/home-manager').Path + '#' + $env:USER)
    }
}

if ((Get-Command scoop -ea Ignore) -and -not (Get-Command sioyek -ea Ignore -CommandType Application)) {
    if ((scoop prefix sioyek) -and $LASTEXITCODE -eq 0) {
        function sioyek {
            & (Join-Path (scoop prefix sioyek) 'sioyek.exe') @args
        }
    }
}

if (Get-Command yazi -ea Ignore) {
    function y {
        $tmp = [System.IO.Path]::GetTempFileName()
        yazi $args --cwd-file="$tmp"
        $cwd = Get-Content -Path $tmp -Encoding UTF8
        if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
            Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
        }
        Remove-Item -Path $tmp
    }
}

function vf {
    begin {
        $null = Get-Command fzf -ea Stop
        $null = Get-Command vim -ea Stop -CommandType Function
    }

    end {
        vim (fzf)
    }
}
