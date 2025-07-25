function adbin {
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Str,
        [switch]$Enter
    )
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

function pinfo {
    [CmdletBinding(DefaultParameterSetName = 'Attribute')]
    [OutputType([string], ParameterSetName = 'ParameterSet')]
    [OutputType([void], ParameterSetName = 'Attribute')]
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
        if (Get-Command $Command -ErrorAction SilentlyContinue -OutVariable cmd) {
            if ($PSCmdlet.ParameterSetName -eq 'Attribute') {
                $cmd.Parameters.GetEnumerator() | Where-Object { $_.Value.Name -notin $CommonParams } | ForEach-Object {
                    $name, $attr = $_.Value.Name, $_.Value.Attributes
                    $pipe = [System.Collections.Generic.List[string]]@()
                    $paramInfo = [pscustomobject]@{}

                    if ($Pipeline) {
                        if ($attr.ValueFromPipeline) {
                            $pipe.Add('Value')
                        }
                        if ($attr.ValueFromPipelineByPropertyName) {
                            $pipe.Add('Property')
                        }
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Pipeline -Value $pipe
                    }
                    # MinValue meaning Position attribute is not assigned
                    if ($Positional -and $attr.Position -ne [int]::MinValue) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Position -Value $attr.Position
                    }
                    if ($Alias) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Alias -Value $attr.AliasNames
                    }

                    $info.Add($name, $paramInfo)
                }
                $format = @{
                    Property = @(
                        @{ Name = 'Parameter'; Expression = 'Key' }
                        @{ Name = 'Pipeline'; Expression = { $_.Value.Pipeline -join ', ' } }
                        @{ Name = 'Position'; Expression = { $_.Value.Position } }
                        @{ Name = 'Alias'; Expression = { $_.Value.Alias -join ', ' } }
                    )
                }
                $info.GetEnumerator() | Format-Table @format -AutoSize
            } else {
                # TODO: group by ParameterSetName
                throw [System.NotImplementedException]::new()
                $cmd.Parameters.GetEnumerator() | Group-Object { $_.Value.ParameterSets.Keys }
            }
        } else {
            Write-Error $Error[-1]
        }
    }
}

function mkvideo {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Destination,
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Cover,
        [switch]$MakeInfo,
        [switch]$Convert
    )

    begin {
        $null = Get-Command ffmpeg -ea Stop
        $null = Get-Command ffprobe -ea Stop
        if (-not $Destination) {
            $Destination = $PWD.Path
        }

        if (-not (Test-Path $Destination)) {
            Write-Verbose 'Destination does not exist, creating forcibly'
            $null = New-Item -ItemType Directory -Path $Destination -ea Ignore
        }

        [System.Collections.Generic.List[string]]$info = @()
        $invalidChar = @(
            ('\\', '.'),
            ('/', '.'),
            (':', '：'),
            ('\?', '？')
        )
    }

    end {
        $current = 0.0
        $allMusic = @($input)
        if (-not $Cover) {
            $Cover = [System.IO.Path]::GetTempFileName()
            Write-Verbose 'Cover unspecified, extracting from audio file'
            ffmpeg -hide_banner -i $allMusic[0] -an -vcodec copy $Cover *>$null
        }
        foreach ($music in $allMusic) {
            Write-Progress -Activity 'Creating Videos' -Status $music -PercentComplete (($current++ / $allMusic.Length) * 100)

            $json = ffprobe -v error -show_format -show_streams -hide_banner -of json -i $music
            $mediaInfo = $json | ConvertFrom-Json
            $filename = Split-Path $music -Leaf
            $musicName = $mediaInfo.format.tags.title

            if ($filename -match '^(?<Index>\d+)\.?(?<Name>.*)$') {
                $index = $matches.Index
                if ([string]::IsNullOrEmpty($musicName)) {
                    Write-Verbose 'Title not found in tags, extracting from filename'
                    $musicName = Split-Path $matches.Name.Trim() -LeafBase
                }
            }

            $duration = [uint]$mediaInfo.format.duration + 1
            $videoname = "$index.「$musicName」"
            foreach ($group in $invalidChar) {
                $videoname = $videoname -replace $group
            }
            $info.Add($videoname)

            $output = if ($Convert) {
                [IO.Path]::GetTempFileName() -replace '\.tmp$', '.mp4'
            } else {
                Join-Path $Destination "$videoname.mp4"
            }

            ffmpeg -v error -framerate 24 -loop 1 -i $Cover -i $music -strict -2 -t $duration -c:v libx264 -c:a copy -hide_banner $output *>$null

            if ($Convert) {
                ffmpeg -i $output -c:v copy -c:a flac -sample_fmt s32 -ar 48000 (Join-Path $Destination "$videoname.mp4") *>$null
            }

            Write-Progress -Activity 'Creating Videos' -Status $musicName -PercentComplete (($current / $allMusic.Length) * 100)
        }

        if ($MakeInfo) {
            $head = "$($mediaInfo.format.tags.ALBUM) ($($mediaInfo.format.tags.DATE)) - $($mediaInfo.format.tags.ARTIST)"
            $info.InsertRange(0, [string[]]@($head, [string]::Empty))
            $info -join [System.Environment]::NewLine > (Join-Path $Destination "$head.txt")
        }

        if ((Split-Path $Cover).TrimEnd([IO.Path]::DirectorySeparatorChar) -eq ([System.IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar)) {
            Remove-Item -Path $Cover
        }

        if ($Convert) {
            Remove-Item -Path $output
        }
    }
}

function ago {
    param(
        [uint]$Days,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Path
    )

    process {
        $item = Get-Item -Path $Path
        if ($item.CreationTime -gt [datetime]::Now.AddDays(-$Days)) {
            $item
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
        if ($PSCmdlet.ParameterSetName -eq 'Extension') {
            $playlist = Get-ChildItem -Path $Path -Recurse:$Recurse -File -Include ($Extension | ForEach-Object { "*.$_" })
        } else {
            $playlist = Get-ChildItem -Path $Path -Recurse:$Recurse -File -Filter $Filter
        }

        if ($ByDate) {
            $playlist = $playlist | Sort-Object CreationTime -Descending
        } elseif ($Randomize) {
            $playlist = $playlist | Sort-Object { Get-Random }
        }

        $playlist | ForEach-Object FullName | mpv --playlist=-
    }
}

function dnnew {
    begin {
        $null = Get-Command dotnet -ea Stop
        $null = Get-Command fzf -ea Stop
        $null = Get-Command tr -ea Stop
    }

    end {
        $templateStrings = (dotnet new list | Select-Object -Skip 4) -replace '\s{2,}', ';'

        $csvEntries = ($templateStrings | ConvertFrom-Csv -Delimiter ';' -Header 'FullName', 'Alias', 'Lang', 'Tag' | ForEach-Object {
                [PSCustomObject]@{
                    FullName = $_.FullName
                    Alias    = $_.Alias
                    Lang     = $_.Lang
                    Tag      = $_.Tag
                }
            })

        $fzfEntries = $csvEntries | ForEach-Object {
            if ($_.Lang -notmatch '\[.*?\]') {
                $_.Tag = $_.Lang;
                $_.Lang = [string]::Empty;
            }
            if ($_.Alias -match ',') {
                foreach ($alias in $_.Alias -split ',') {
                    $new = $_.psobject.Copy()
                    $new.Alias = $alias
                    $new
                }
            } else {
                $_
            }
        } | ForEach-Object {
            "$($_.Alias)`tDesc: $($_.FullName)`tAlias: $($_.Alias)`tLang: $($_.Lang)`tTag: $($_.Tag)"
        }


        $fzfEntries | fzf --delimiter='\t' `
            --with-nth=1 `
            --preview-window=down `
            --preview='echo {2..} | tr "\t" "\n"' `
            --bind "enter:execute(dotnet new {1} $($args -join ' '))+abort"
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
if ($PSVersionTable.PSEdition -eq 'Desktop' -or $IsWindows) {
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
            [ValidateScript({ (Test-Path -LiteralPath $_) -and (Split-Path $_ -Extension) -eq '.vhdx' })]
            [Parameter(Position = 1)]
            [string]$Path,
            [switch]$IsNotWSL
        )
        begin {
            $null = Get-Command diskpart -CommandType Application -ea Stop

            if (-not $IsNotWSL) {
                $origEncoding = [Console]::OutputEncoding
                [Console]::OutputEncoding = [System.Text.Encoding]::Unicode # wsl outputs unicode 16
                if (wsl --list --verbose | Select-String Running) {
                    Write-Warning 'Please make sure distro were terminated by `wsl -t <distro>`'
                    return
                }
                [Console]::OutputEncoding = $origEncoding
                wsl --shutdown
            }
        }
        end {
            $tempScript = New-TemporaryFile
            @"
            select vdisk file=`"$Path`"
            compact vdisk
"@ > $tempScript

            diskpart /s $tempScript.FullName
            Remove-Item $tempScript
        }
    }

    function pathadd {
        param (
            [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_).Path) })]
            [Parameter(Position = 0)]
            [string]$Dir
        )

        $Dir = (Resolve-Path $Dir).Path
        $path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
        if (-not $path.Contains($Dir)) {
            [System.Environment]::SetEnvironmentVariable('Path', ($path + [IO.Path]::PathSeparator + $Dir), [System.EnvironmentVariableTarget]::User)
        }
    }
}

function pmclean {
    param (
        [ValidateSet('scoop', 'npm', 'nuget')]
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
        $folders = Get-ChildItem '~/projects' -Directory
        if (Test-Path '~/.config/home-manager/') {
            $folders += Get-Item '~/.config/home-manager/'
        }
        $dest = $folders | ForEach-Object FullName | fzf
        if ($dest) {
            Set-Location $dest
        }
    }
}

function ds {
    param (
        [ValidateScript({ [IO.Directory]::Exists((Resolve-Path $_)) })]
        [string]$Dir,

        [ValidateSet('kb', 'mb', 'gb')]
        [string]$Unit,

        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'Pipeline')]
        [ValidateScript({ [IO.File]::Exists((Resolve-Path $_)) })]
        [Alias('PSPath')]
        [string]$Path
    )
    begin {
        if (-not $Dir) {
            $Dir = $PWD.Path
        }
    }

    end {
        if (Get-Command du -CommandType Application -ErrorAction Ignore -OutVariable du) {
            if ($PSCmdlet.ParameterSetName -eq 'Pipeline') {
                $length = (((& $du[0] --bytes --total --summarize @input)[-1] -split '\s+')[0]) -as [long]
            } else {
                $length = (((& $du[0] --bytes --total --summarize $Dir)[-1] -split '\s+')[0]) -as [long]
            }
        } else {
            if ($PSCmdlet.ParameterSetName -eq 'Pipeline') {
                $length = ($input | ForEach-Object { Get-Item $_ -Force } | Measure-Object Length -Sum).Sum
            } else {
                $length = (Get-ChildItem -File -Force -Recurse -LiteralPath $Dir | Measure-Object Length -Sum).Sum
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
        [Parameter(Position = 1, Mandatory)]
        [scriptblock]$Condition
    )

    process {
        if ($Condition.InvokeWithContext($null, [psvariable]::new('_', $_))) {
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

function fir {
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
