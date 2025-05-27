Set-Alias lg lazygit
Set-Alias dn dotnet

function vim {
    nvim -u '~/.vimrc' @args
}

function vwrite {
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
    . $PROFILE
}

if (Get-Command 'home-manager' -ErrorAction SilentlyContinue) {
    function hms {
        home-manager switch --flake ((Resolve-Path '~/.config/home-manager').Path + '#' + $env:USER)
    }
}

function p {
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

if ((Get-Command scoop -ea SilentlyContinue) -and -not (Get-Command sioyek -ea SilentlyContinue -CommandType Application)) {
    $sioyekPrefix = scoop prefix sioyek
    if ($LASTEXITCODE -eq 0) {
        function sioyek {
            & (Join-Path $sioyekPrefix 'sioyek.exe') @args
        }
    }
}

if (Get-Command yazi -ea SilentlyContinue) {
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
