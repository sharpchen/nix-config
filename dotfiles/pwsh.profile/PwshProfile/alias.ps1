Set-Alias lg lazygit
Set-Alias dn dotnet
Set-Alias v nvim
Set-Alias ydl yt-dlp
Set-Alias tsp Test-Path
Set-Alias mes Measure-Object
Set-Alias mesc Measure-Command
Set-Alias each ForEach-Object
Set-Alias sel Select-Object
Set-Alias gpd Get-PSDrive
Set-Alias gpp Get-PSProvider
Set-Alias cond Where-Object
Set-Alias expand Resolve-Path
Set-Alias order Sort-Object
Set-Alias ll Get-ChildItem

if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    Set-Alias bsdtar tar
}

if (Get-Command nvim -ErrorAction Ignore) {
    function vim {
        nvim -u '~/.vimrc' @args
    }

    function vw {
        nvim -u '~/.vimrc' @args -c @'
        set wrap
'@
    }

    function vf {
        begin {
            $null = Get-Command fzf -ea Stop
            $null = Get-Command vim -ea Stop -CommandType Function
        }

        end {
            $item = fzf
            if ($item) {
                vim $item
            }
        }
    }
}

function :q {
    exit
}

function .. {
    Set-Location ..
}


function md {
    $null = New-Item -ItemType Directory @args
}

function new {
    $null = New-Item -ItemType File @args
}

function so {
    Import-Module PwshProfile -Scope Global -Force
}

if (Get-Command 'home-manager' -ErrorAction Ignore) {
    function hms {
        home-manager switch --flake ((Resolve-Path '~/.config/home-manager').Path + '#' + $env:USER) `
            --option substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store' `
            @args
    }
    Set-Alias hm home-manager
}

if (Get-Command nix-store -ErrorAction Ignore) {
    function nsp {
        param(
            [Parameter(Position = 1)]
            [string]$MainProgram
        )
        nix-store -q --outputs (Get-Command $MainProgram).Source
    }
}

if ((Get-Command scoop -ea Ignore) -and -not (Get-Command sioyek -ea Ignore -CommandType Application)) {
    if (& { scoop prefix sioyek *> $null; 0 -eq $LASTEXITCODE }) {
        function sioyek {
            & (Join-Path (scoop prefix sioyek) 'sioyek.exe') @args
        }
    }
}

if (Get-Command sioyek -ErrorAction Ignore) {
    function sio {
        begin {
            $null = Get-Command fzf -ErrorAction Stop
        }
        end {
            $file = fzf
            if ($file) {
                sioyek $file @args
            }
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

if (Get-Command tree-sitter -ErrorAction Ignore) {
    Set-Alias ts tree-sitter
}

if (Test-Path alias:rd) {
    Remove-Item alias:rd
}
function rd {
    param (
        [Parameter(Position = 1, Mandatory)]
        [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_)) })]
        [string]$Path
    )
    Remove-Item -Recurse -Force -LiteralPath $Path
}

function now {
    Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}

function rand {
    $input | Sort-Object { Get-Random }
}
