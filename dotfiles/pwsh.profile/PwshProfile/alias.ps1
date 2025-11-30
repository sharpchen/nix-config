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
Set-Alias expand Convert-Path
Set-Alias order Sort-Object
Set-Alias json ConvertFrom-Json
Set-Alias tojson ConvertTo-Json
Set-Alias csv ConvertFrom-Csv
Set-Alias tocsv ConvertFrom-Csv

function ll {
    Get-ChildItem @args -Force
}

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
            [Parameter(Position = 1, Mandatory)]
            [string]$MainProgram
        )
        nix-store -q --outputs (Get-Command $MainProgram).Source
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
    begin {
        $target = Resolve-Path $Path
    }
    end {
        if (Get-Command robocopy -ErrorAction Ignore -CommandType Application) {
            $empty = New-Item -ItemType Directory -Path (Join-Path temp:/ (New-Guid))
            # TODO: why is it slow?
            # perf similar to Remove-Item
            # use git@github.com:sharpchen/nixpkgs.git as sample repo
            robocopy $empty $target /mir /sl 1>$null
            Remove-Item $target
        } elseif (Get-Command rsync -ErrorAction Ignore -CommandType Application) {
            rsync --archive --delete "$(mktemp -d)/" "$target/"
            Remove-Item $target
        } else {
            Remove-Item -Recurse -Force -LiteralPath $Path
        }
    }
}

function now {
    Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}

function rand {
    $input | Sort-Object { Get-Random }
}
