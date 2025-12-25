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

if ($IsWindows -or $IsLegacy) {
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

function :map {
    Get-PSReadLineKeyHandler -Chord @args
}

function .. {
    Set-Location ..
}

function __md {
    $null = New-Item -ItemType Directory @args
}

Set-Alias md __md -Option AllScope -Scope Global

function new {
    $null = New-Item -ItemType File @args
}

function so {
    Import-Module PwshProfile -Scope Global -Force
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

function now {
    Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}

function rand {
    $input | Sort-Object { Get-Random }
}
