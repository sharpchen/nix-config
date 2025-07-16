Set-Alias lg lazygit
Set-Alias dn dotnet
Set-Alias tsp Test-Path
Set-Alias ms Measure-Object
Set-Alias msc Measure-Command
Set-Alias for ForEach-Object
Set-Alias map ForEach-Object
Set-Alias sel Select-Object
Set-Alias gpd Get-PSDrive
Set-Alias gpp Get-PSProvider
Set-Alias now Get-Date
Set-Alias cond Where-Object
Set-Alias expand Resolve-Path
Set-Alias order Sort-Object

if (Get-Command nvim -ErrorAction Ignore) {
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

function so {
    Import-Module PwshProfile -Scope Global -Force
}

if (Get-Command 'home-manager' -ErrorAction Ignore) {
    function hms {
        home-manager switch --flake ((Resolve-Path '~/.config/home-manager').Path + '#' + $env:USER) @args --option substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store'
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
    function ts {
        tree-sitter @args
    }
}
