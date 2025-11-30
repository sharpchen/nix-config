function adbin {
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Str,
        [switch]$Enter
    )
    begin {
        $null = Get-Command adb -ErrorAction Stop -CommandType Application
    }
    end {
        $special = @( ' ', '\|', '\$', '&', '\(', '\)', '~', '\*', "\'", '"', '<', '>')
        foreach ($char in $special) {
            $repl = if ($char.Length -gt 1) {
                $char
            } else {
                "\$char"
            }
            $Str = $Str -replace $char, $repl
        }
        adb shell input text $Str
        if ($Enter) {
            adb shell input keyevent KEYCODE_ENTER
        }
    }
}

function pinfo {
    [CmdletBinding(DefaultParameterSetName = 'Attribute')]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateScript({ Get-Command $_ -ErrorAction Ignore })]
        [string]$Command,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$Positional,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$Pipeline,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$Alias,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$Mandatory,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$ParameterType,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$All,

        [Parameter(ParameterSetName = 'ParameterSet')]
        [switch]$ParameterSet
    )

    begin {
        $info = @{}
        $CommonParams = @(
            'Verbose',
            'Debug',
            'ErrorAction',
            'WarningAction',
            'InformationAction',
            'ProgressAction',
            'ErrorVariable',
            'WarningVariable',
            'InformationVariable',
            'OutVariable',
            'OutBuffer',
            'PipelineVariable',
            'WhatIf',
            'Confirm'
        )
    }

    end {
        $cmd = Get-Command $Command
        switch ($PSCmdlet.ParameterSetName) {
            'Attribute' {
                $cmd.Parameters.GetEnumerator() | Where-Object { $_.Value.Name -notin $CommonParams } | ForEach-Object {
                    $name, $attr = $_.Value.Name, $_.Value.Attributes
                    $pipe = [System.Collections.Generic.List[string]]@()
                    $paramInfo = [pscustomobject]@{}

                    if ($Pipeline -or $All) {
                        if ($attr.ValueFromPipeline) {
                            $pipe.Add('Value')
                        }
                        if ($attr.ValueFromPipelineByPropertyName) {
                            $pipe.Add('Property')
                        }
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Pipeline -Value $pipe
                    }
                    # MinValue meaning Position attribute is not assigned
                    if ($All -or $Positional -and $attr.Position -ne [int]::MinValue) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Position -Value $attr.Position
                    }
                    if ($Alias -or $All) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Alias -Value $attr.AliasNames
                    }
                    if (($Mandatory -or $All) -and $attr.Mandatory) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Mandatory -Value $attr.Mandatory
                    }
                    if ($ParameterType -or $All) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name ParameterType -Value $_.Value.ParameterType.FullName
                    }

                    $info.Add($name, $paramInfo)
                }
                $format = @{
                    Property = @(
                        @{ Name = 'Parameter'; Expression = 'Key' }
                        if ($Positional -or $All) {
                            @{ Name = 'Position'; Expression = { $_.Value.Position } }
                        }
                        if ($Mandatory -or $All) {
                            @{ Name = 'Mandatory'; Expression = { $_.Value.Mandatory } }
                        }
                        if ($Pipeline -or $All) {
                            @{ Name = 'Pipeline'; Expression = { $_.Value.Pipeline -join ', ' } }
                        }
                        if ($Alias -or $All) {
                            @{ Name = 'Alias'; Expression = { $_.Value.Alias -join ', ' } }
                        }
                        if ($ParameterType -or $All) {
                            @{ Name = 'ParameterType'; Expression = { $_.Value.ParameterType } }
                        }
                    )
                }
                $info.GetEnumerator() | Format-Table @format -AutoSize
            }
            default {
                # TODO: group by ParameterSetName
                throw [System.NotImplementedException]::new()
                $cmd.Parameters.GetEnumerator() | Group-Object { $_.Value.ParameterSets.Keys }
            }
        }
    }
}

function daysago {
    param(
        [Parameter(Mandatory)]
        [uint]$Days,
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$CreationTime
    )

    process {
        if ($CreationTime -gt [datetime]::Now.AddDays(-$Days)) {
            $_
        }
    }
}

function play {
    [CmdletBinding(DefaultParameterSetName = 'Extension')]
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Path,
        [switch]$Recurse,
        [switch]$ByDate,
        [switch]$Randomize,

        [Parameter(ParameterSetName = 'Extension')]
        [ValidateSet('mp4', 'flac', 'mp3')]
        [string[]]$Extension = 'mp4',

        [Parameter(ParameterSetName = 'Filter')]
        [SupportsWildcards()]
        [string]$Filter
    )
    begin {
        $null = Get-Command mpv -ea Stop

        if (-not $Path) {
            $Path = $PWD.Path
        }
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Extension' {
                $playlist = Get-ChildItem -Path $Path -Recurse:$Recurse -File -Include ($Extension | ForEach-Object { "*.$_" })
            }
            'Filter' {
                $playlist = Get-ChildItem -Path $Path -Recurse:$Recurse -File -Filter $Filter
            }
        }

        if ($ByDate) {
            $playlist = $playlist | Sort-Object CreationTime -Descending
        } elseif ($Randomize) {
            $playlist = $playlist | Sort-Object { Get-Random }
        }

        $playlist | ForEach-Object FullName | mpv --playlist=-
    }
}

function dnpack {
    begin {
        $null = Get-Command dotnet -ea Stop
        $null = Get-Command fzf -ea Stop
        $null = Get-Command tr -ea Stop
    }

    end {
        $res = dotnet package search @args --format json | ConvertFrom-Json

        $res.searchResult.packages |
            ForEach-Object { "$($_.id)`tLatest Version: $($_.latestVersion)`tTotal Downloads: $($_.totalDownloads)`tOwners: $($_.owners)" } |
            fzf  --delimiter='\t' `
                --with-nth=1 `
                --preview-window=down `
                --preview='echo {2..} | tr "\t" "\n"' `
                --bind 'enter:execute(dotnet add package {1})+abort'
    }
}

function pmclean {
    param (
        [ValidateSet('scoop', 'npm', 'nuget', 'nix')]
        [Parameter(Position = 1)]
        [string]$PackageManager
    )

    switch -Exact ($PackageManager) {
        'scoop' {
            $null = Get-Command scoop -ea Stop
            scoop cleanup *
            scoop cache rm *
        }
        'nuget' {
            $null = Get-Command dotnet -ea Stop
            dotnet nuget locals all --clear
        }
        'npm' {
            $null = Get-Command npm -ea Stop
            npm cache clean --force
        }
        'nix' {
            $null = Get-Command nh -ErrorAction Stop
            nh clean all
        }
        default {
            Write-Warning "Cannot handle $PackageManager"
        }
    }
}

function p {
    begin {
        $null = Get-Command fzf -ea Stop
    }
    end {
        $folders = @(Get-ChildItem '~/projects' -Directory)
        if (Test-Path '~/.config/home-manager/') {
            $folders += Get-Item '~/.config/home-manager/'
        }
        $dest = $folders | ForEach-Object FullName | fzf
        if ($dest) {
            Push-Location
            Set-Location $dest
        }
    }
}

function ds {
    [CmdletBinding(DefaultParameterSetName = 'Directory')]
    param (
        [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_)) })]
        [Parameter(Position = 0, ParameterSetName = 'Directory')]
        [string]$Dir,

        [ValidateSet('kb', 'mb', 'gb')]
        [string]$Unit,

        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'Pipeline')]
        [Alias('FullName')]
        [string]$InputObject
    )
    begin {
        if (-not $Dir) {
            $Dir = $PWD.Path
        }
        $length = 0
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Pipeline' {
                $files = $input | Where-Object { [IO.File]::Exists($_) }
                if (Get-Command du -CommandType Application -ErrorAction Ignore -OutVariable du) {
                    $length = (((& $du[0] -L --bytes --total --summarize @files)[-1] -split '\s+')[0]) -as [long]
                } else {
                    $length = ($input | ForEach-Object { Get-Item $_ -Force } | Measure-Object Length -Sum).Sum
                }
            }
            'Directory' {
                if (Get-Command du -CommandType Application -ErrorAction Ignore -OutVariable du) {
                    $length = (((& $du[0] -L --bytes --total --summarize $Dir)[-1] -split '\s+')[0]) -as [long]
                } else {
                    $length = (Get-ChildItem -File -Force -Recurse -LiteralPath $Dir | Measure-Object Length -Sum).Sum
                }
            }
        }

        switch ($Unit) {
            'kb' {
                $length / 1kb
            }
            'mb' {
                $length / 1mb
            }
            'gb' {
                $length / 1gb
            }
            default {
                $length
            }
        }
    }
}

function any {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 1)]
        [scriptblock]$Condition
    )

    process {
        if ($Condition -and $Condition.InvokeWithContext($null, [psvariable]::new('_', $_)) -or $_) {
            $true
            break
        }
    }

    end {
        $false
    }
}

function all {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 1, Mandatory)]
        [scriptblock]$Condition
    )

    process {
        if (-not $Condition.InvokeWithContext($null, [psvariable]::new('_', $_))) {
            $false
            break
        }
    }

    end {
        $true
    }
}

function except {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 1, Mandatory)]
        [psobject[]]$Exclude
    )

    process {
        if ($_ -cnotin $Exclude) {
            $_
        }
    }
}

function skip {
    param (
        [uint]$Count
    )
    begin {
        $i = 1
    }
    process {
        if ($i -gt $Count) {
            $_
        }
        $i++
    }
}

function first {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 1, Mandatory)]
        [scriptblock]$Condition
    )
    process {
        if ($Condition.InvokeWithContext($null, [psvariable]::new('_', $_))) {
            $_
            break
        }
    }
}

function reverse {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject
    )

    for ($i = $input.Count - 1; $i -ge 0 ; $i--) {
        $input[$i]
    }
}

function get {
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$PropertyPath,
        [Parameter(ValueFromPipeline, Mandatory)]
        [psobject]$InputObject
    )
    begin {
        $propertyNames = $PropertyPath -split '\.'
    }

    process {
        $type = $InputObject.GetType()
        $val = $InputObject

        $count = 0
        while ($prop = $val."$($propertyNames[$count])") {
            if ($propertyNames[$count] -eq 'GetType') {
                $val = $type
            } elseif ($prop -is [System.Management.Automation.PSMethod]) {
                $val = $prop.Invoke()
            } else {
                $val = $prop
            }
            $count++
        }

        if ($count -eq $propertyNames.Length) {
            $val
        }
    }
}

function rall {
    begin {
        $target = Resolve-Path .
    }
    end {
        if (Get-Command robocopy -ErrorAction Ignore -CommandType Application) {
            $empty = New-Item -ItemType Directory -Path (Join-Path temp:/ (New-Guid))
            robocopy $empty $target /mir /sl 1>$null
        } elseif (Get-Command rsync -ErrorAction Ignore -CommandType Application) {
            rsync --archive --delete "$(mktemp -d)/" "$target/"
        } else {
            Remove-Item * -Recurse -Force
        }
    }
}

function epubpack {
    param (
        [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_)) })]
        [Parameter(Position = 0, Mandatory)]
        [string]$Folder,
        [Parameter(Position = 1)]
        [ValidateScript({ Test-Path -IsValid $_ })]
        [string]$Destination
    )

    begin {
        $zip = Get-Command zip -CommandType Application -ErrorAction Stop
        $null = Get-Item (Join-Path $Folder 'mimetype') -ErrorAction Stop
        $output = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
        # delete if file already exist, otherwise zip would *append* contents to it.
        if (Test-Path $output) {
            Remove-Item $output -Confirm
        }
    }

    end {
        $parameters = @{
            FilePath         = $zip.Source
            WorkingDirectory = Resolve-Path $Folder
            ArgumentList     = "-Xr9Dq $output mimetype *"
        }

        Start-Process @parameters -Wait -NoNewWindow -UseNewEnvironment
    }
}

function unpack {
    # NOTE: to enforce pwsh accept a shorter syntax
    # __AllParameterSets can be a arbitrary name other than defined ParameterSetNames
    [CmdletBinding(DefaultParameterSetName = '__AllParameterSets')]
    param (
        [ValidateScript({ [IO.File]::Exists((Resolve-Path $_)) })]
        [Parameter(Position = 0, Mandatory)]
        [string]$Path,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Parameter(Position = 1, ParameterSetName = 'Destination')]
        [string]$Destination,

        [Parameter(ParameterSetName = 'Auto')]
        [switch]$Direct
    )
    begin {
        $tar = Get-Command bsdtar -ErrorAction Stop
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Direct' {
                & $tar xf $Path --cd $PWD
            }
            'Destination' {
                if (-not $Destination) {
                    $Destination = $PWD
                } elseif ($Destination -and -not [IO.Directory]::Exists((Convert-Path $Destination))) {
                    $null = New-Item -ItemType Directory -Path $Destination
                }
                & $tar xf $Path --cd $Destination
            }
            default {
                [string]$first = & $tar tf $Path | Select-Object -First 1
                # if first entry is a folder
                # should unpack it directly
                # TODO: what if the list is invisible?
                if ($first.EndsWith('/') -and ($first -split '/').Count -eq 2) {
                    & $tar xf $Path --cd $PWD
                } else {
                    # if not, create a dedicated directory in the basename of the archive
                    $basename = (Get-Item $Path).BaseName
                    $null = New-Item -ItemType Directory -Path $basename
                    try {
                        & $tar xf $Path --cd $basename
                    } catch {
                        Remove-Item -Recurse $basename
                    }
                }
            }
        }
    }
}

function cptree {
    param (
        [Alias('Root')]
        [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_)) })]
        [Parameter(Position = 0, Mandatory)]
        [string]$Path,
        [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_)) })]
        [Parameter(Position = 1, Mandatory)]
        [string]$Destination,
        [switch]$ExcludeRoot,
        [switch]$Force
    )

    begin {
        $root = Convert-Path $Path
        $dest = Convert-Path $Destination
        if (-not $ExcludeRoot) {
            $dest = Join-Path $dest (Split-Path $root -Leaf)
        }
    }

    end {
        $null = Get-ChildItem -Path $root -Directory -Recurse -Force:$Force |
            Resolve-Path -Relative -RelativeBasePath $root |
            ForEach-Object { [pscustomobject]@{ Path = Join-Path $dest $_ } } | # NOTE: wrap it as Path property, New-Item requires to do so
            New-Item -ItemType Directory
    }
}
