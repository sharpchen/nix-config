Set-Alias reboot Restart-Computer

function vs {
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Path
    )

    begin {
        if (-not (Get-Command devenv -ea Ignore)) {
            $null = Get-Command vswhere -ea Stop
        }
        if (-not $Path) {
            $Path = $PWD.ProviderPath
        }
    }

    end {
        $sln = Get-ChildItem $Path -Filter *.sln
        $slnx = Get-ChildItem $Path -Filter *.slnx
        $proj = Get-ChildItem $Path -Filter *.*proj

        if ($slnx) {
            $file = $slnx | Select-Object -First 1
        } elseif ($sln) {
            $file = $sln | Select-Object -First 1
        } elseif ($proj) {
            $file = $proj | Select-Object -First 1
        } else {
            Write-Warning "$($Path.FullName) contains no *proj or *.sln or *.slnx"
            return
        }

        if (Get-Command devenv -ea Ignore) {
            devenv $file.FullName
        } else {
            $devenv = (vswhere -latest -property productPath)
            & $devenv $file
        }
    }
}

function vdcompact {
    param (
        [ValidateScript({ (Test-Path -LiteralPath $_) })]
        [ValidateScript({ (Split-Path $_ -Extension) -eq '.vhdx' })]
        [Parameter(Position = 0)]
        [string]$Path
    )
    begin {
        $null = Get-Command diskpart -CommandType Application -ea Stop
        $Path = Resolve-Path $Path
    }
    end {
        $tempScript = New-TemporaryFile
        try {
            @"
            select vdisk file=`"$Path`"
            compact vdisk
"@ > $tempScript
            diskpart /s $tempScript.FullName
        } finally {
            Remove-Item $tempScript
        }
    }
}

function pathadd {
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Parameter(Position = 0)]
        [string]$Dir
    )

    $Dir = (Resolve-Path $Dir).Path
    $path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
    if (-not $path.Contains($Dir)) {
        [System.Environment]::SetEnvironmentVariable('Path', ($path + [IO.Path]::PathSeparator + $Dir), [System.EnvironmentVariableTarget]::User)
    }
}

function pathclean {
    $path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User) -split [IO.Path]::PathSeparator

    $invalid = $path | Where-Object { -not (Test-Path -LiteralPath $_) }

    [System.Environment]::SetEnvironmentVariable(
        'Path',
        [System.Linq.Enumerable]::Except([string[]]$path, [string[]]$invalid) -join [IO.Path]::PathSeparator,
        [System.EnvironmentVariableTarget]::User
    )
}

function trash {
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Alias('FullName')]
        [string]$Path
    )
    begin {
        Add-Type -AssemblyName Microsoft.VisualBasic
    }
    process {
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($abs, 'OnlyErrorDialogs', 'SendToRecycleBin')
        } elseif  (Test-Path -LiteralPath $Path -PathType Container) {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($abs, 'OnlyErrorDialogs', 'SendToRecycleBin')
        }
    }
}

function exch {
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$One,
        [Parameter(Position = 1, Mandatory)]
        [string]$Another
    )

    begin {
        # TODO: waiting mv --exchange flag being implemented on uutils/coreutils
        throw [System.NotImplementedException]::new('waiting mv --exchange flag being implemented on uutils/coreutils')
        $One = (Resolve-Path $One).Path
        $Another = (Resolve-Path $Another).Path
    }

    end {
        if (Get-Command mv -CommandType Application -ErrorAction Stop -OutVariable mv) {
            & $mv[0] $One $Another --exchange
        }
    }
}

function enterfirmware {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High')] # always prompt for confirmation
    param()

    if ($PSCmdlet.ShouldProcess('Reboot to Firmware', $null, $null)) {
        shutdown /r /fw /t 0

        # The system could not find the environment option that was entered.(203)
        if ($LASTEXITCODE -eq 203) {
            Dism /Online /Cleanup-Image /RestoreHealth
            shutdown /r /fw /t 0
        }
    }
}

function colo {
    param(
        [ValidateSet('Dark', 'Light')]
        [Parameter(Position = 0, Mandatory)]
        $Mode
    )

    begin {
        $modeRegistry = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
        $useLightMode = [int]($Mode -eq 'Light')
    }

    end {
        Set-ItemProperty -Path $modeRegistry -Name 'AppsUseLightTheme' -Value $useLightMode
        Set-ItemProperty -Path $modeRegistry -Name 'SystemUsesLightTheme' -Value $useLightMode
    }
}

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
        $empty = New-Item -ItemType Directory -Path (Join-Path temp:/ (New-Guid))
        # TODO: why is it slow?
        # perf similar to Remove-Item
        # use git@github.com:sharpchen/nixpkgs.git as sample repo
        robocopy $empty $target /mir /sl 1>$null
        Remove-Item $target
    }
}

function rall {
    begin {
        $target = Resolve-Path .
    }
    end {
        $empty = New-Item -ItemType Directory -Path (Join-Path temp:/ (New-Guid))
        robocopy $empty $target /mir /sl 1>$null
    }
}
