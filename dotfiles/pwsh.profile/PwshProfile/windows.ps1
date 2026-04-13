Set-Alias reboot Restart-Computer
Set-Alias uptime Get-Uptime

function which {
    param ([string]$Name)
    (Get-Command $Name).Source
}

function vs {
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$LiteralPath
    )

    begin {
        if (-not (Get-Command devenv -ErrorAction Ignore)) {
            $null = Get-Command vswhere -ErrorAction Stop
        }
        if (-not $LiteralPath) {
            $LiteralPath = $PWD.ProviderPath
        }
    }

    end {
        $sln = Get-ChildItem $LiteralPath -Filter *.sln
        $slnx = Get-ChildItem $LiteralPath -Filter *.slnx
        $proj = Get-ChildItem $LiteralPath -Filter *.*proj

        if ($slnx) {
            $file = $slnx | Select-Object -First 1
        } elseif ($sln) {
            $file = $sln | Select-Object -First 1
        } elseif ($proj) {
            $file = $proj | Select-Object -First 1
        } else {
            Write-Warning "$($LiteralPath.FullName) contains no *proj or *.sln or *.slnx"
            return
        }

        if (Get-Command devenv -ErrorAction Ignore) {
            devenv $file.FullName
        } else {
            $devenv = (vswhere -latest -property productPath)
            & $devenv $file
        }
    }
}

function vdcompact {
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [ValidateScript({ (Split-Path $_ -Extension) -eq '.vhdx' })]
        [Parameter(Position = 0)]
        [string]$LiteralPath
    )
    begin {
        $null = Get-Command diskpart -CommandType Application -ErrorAction Stop
        $path = Resolve-Path $LiteralPath
    }
    end {
        $tempScript = New-TemporaryFile
        try {
            @"
            select vdisk file=`"$path`"
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
        [string]$Directory,
        [EnvironmentVariableTarget]$Target
    )
    begin {
        $add = (Resolve-Path $Directory).Path
        $sep = [IO.Path]::PathSeparator

        if (-not $Target) {
            $target = [System.EnvironmentVariableTarget]::User
        }
    }

    end {
        $before = [System.Environment]::GetEnvironmentVariable('Path', $target)
        $paths = [System.Environment]::GetEnvironmentVariable('Path', $target) -split $sep

        if ($add -notin $paths) {
            # Path is empty, do not insert leading separator
            if ($paths.Length -eq 1 -and $paths[0] -eq [string]::Empty) {
                [System.Environment]::SetEnvironmentVariable('Path', "$add", $target)
            } else {
                [System.Environment]::SetEnvironmentVariable('Path', "$before$sep$add", $target)
            }
        }
    }
}

function pathdel {
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Parameter(Position = 0)]
        [string]$Directory,
        [EnvironmentVariableTarget]$Target
    )
    begin {
        $del = (Resolve-Path $Directory).Path
        $sep = [IO.Path]::PathSeparator
        if (-not $Target) {
            $target = [System.EnvironmentVariableTarget]::User
        }
    }

    end {
        $before = [System.Environment]::GetEnvironmentVariable('Path', $target)
        $after = [System.Linq.Enumerable]::Except(
            [string[]]($before -split $sep),
            [string[]]@($del)
        ) -join $sep

        [System.Environment]::SetEnvironmentVariable('Path', $after, $target)
    }
}

function pathclean {
    param(
        [EnvironmentVariableTarget]$Target
    )

    begin {
        $sep = [IO.Path]::PathSeparator
        if (-not $Target) {
            $target = [System.EnvironmentVariableTarget]::User
        }
    }

    end {
        $paths = [System.Environment]::GetEnvironmentVariable('Path', $target) -split $sep
        $valid = $paths | Where-Object { Test-Path -LiteralPath $_ }
        [System.Environment]::SetEnvironmentVariable(
            'Path',
            $valid -join $sep,
            $target
        )
    }
}

function trash {
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Alias('FullName')]
        [string]$LiteralPath
    )
    begin {
        Add-Type -AssemblyName Microsoft.VisualBasic
    }
    process {
        $abs = Convert-Path $LiteralPath -ErrorAction Continue
        if (Test-Path -LiteralPath $LiteralPath -PathType Leaf) {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($abs, 'OnlyErrorDialogs', 'SendToRecycleBin')
        } elseif  (Test-Path -LiteralPath $LiteralPath -PathType Container) {
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
        Set-ItemProperty -Path $modeRegistry -Name AppsUseLightTheme -Value $useLightMode
        Set-ItemProperty -Path $modeRegistry -Name SystemUsesLightTheme -Value $useLightMode
    }
}

if (Test-Path alias:rd) {
    Remove-Item alias:rd
}

function rd {
    param (
        [Parameter(Position = 1, Mandatory)]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [string]$LiteralPath
    )
    begin {
        $target = Resolve-Path $LiteralPath
    }
    end {
        $empty = New-Item -ItemType Directory -Path (Join-Path temp:/ (New-Guid))
        # TODO: why is it slow?
        # perf similar to Remove-Item
        # use git@github.com:sharpchen/nixpkgs.git as sample repo
        robocopy $empty $target /mir /sl 1>$null
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
            $empty = New-Item -ItemType Directory -Path (Join-Path temp:/ (New-Guid))
            robocopy $empty $target /mir /sl 1>$null
        }
    }
}
