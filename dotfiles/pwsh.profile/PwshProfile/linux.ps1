if (Test-Path alias:rd) {
    Remove-Item alias:rd
}

function rd {
    param (
        [Parameter(Position = 1, Mandatory)]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [string]$Path
    )
    begin {
        $target = Resolve-Path $Path
    }
    end {
        rsync --archive --delete "$(mktemp -d)/" "$target/"
        Remove-Item $target -Force
    }
}

function rall {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param()

    begin {
        $target = Resolve-Path .
    }
    end {
        if ($PSCmdlet.ShouldProcess("Delete all content of $target", $null, $null)) {
            rsync --archive --delete "$(mktemp -d)/" "$target/"
        }
    }
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

if (Get-Command 'home-manager' -ErrorAction Ignore) {
    function hms {
        home-manager switch --flake ((Resolve-Path '~/.config/home-manager').Path + '#' + $env:USER) `
            --option substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store' `
            @args
    }
    Set-Alias hm home-manager
}
