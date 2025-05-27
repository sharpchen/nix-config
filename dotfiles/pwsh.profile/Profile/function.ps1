function adbin {
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Str,
        [switch]$Enter
    )
    $special = @( ' ', '\|', '\$', '&', '\(', '\)', '~', '\*', "\'", '"', '<', '>')
    foreach ($char in $special) {
        $repl = if($char.Length -gt 1) {
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
        [ValidateScript({ Get-Command $_ -ErrorAction SilentlyContinue })]
        [string]$Command,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$Positional,
        [Parameter(ParameterSetName = 'Attribute')]
        [switch]$Pipeline,

        [Parameter(ParameterSetName = 'ParameterSet')]
        [switch]$ParameterSet
    )
    if ($PSCmdlet.ParameterSetName -eq 'Attribute') {

        if ($Positional) {
            help $Command | Select-String 'Position\??\s*\d' -Context 3, 5
        } elseif ($Pipeline) {
            help $Command | Select-String 'Accept pipeline input\??\s*true.*$' -Context 5, 4
        }
    } else {
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
        $cmd = Get-Command $Command
        if ($cmd -is [System.Management.Automation.AliasInfo]) {
            $cmd = Get-Command $cmd.Definition
        }
        ($cmd.ParameterSets | ForEach-Object {
            $out = [pscustomobject]@{
                Name       = $_.Name
                Parameters = $_.Parameters | Where-Object Name -NotIn $CommonParams
            }
            $joinParams = @{
                Property     = 'Name'
                Separator    = "$([System.Environment]::NewLine)`t"
                OutputPrefix = "$($out.Name):$([System.Environment]::NewLine)`t"
                OutputSuffix = "`n"
            }
            $out.Parameters | Join-String @joinParams
        }) -join "`n"
    }
}

function mkvideo {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Path,
        [string]$Destination,
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string]$Cover,
        [switch]$MakeInfo,
        [switch]$Convert
    )

    begin {
        Get-Command ffmpeg -ea Stop | Out-Null
        Get-Command ffprobe -ea Stop | Out-Null
        if (-not $Destination) {
            $Destination = $PWD.Path
        }

        if (-not (Test-Path $Destination)) {
            Write-Verbose 'Destination does not exist, creating forcibly'
            New-Item -ItemType Directory -Path $Destination -ea SilentlyContinue | Out-Null
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
        Get-Command mpv -ea Stop | Out-Null

        if ([string]::IsNullOrEmpty($Path)) {
            $Path = $pwd.Path
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
        }

        if ($Randomize) {
            $playlist = $playlist | Sort-Object { Get-Random }
        }

        $playlist | ForEach-Object FullName | mpv --playlist=-
    }
}

function dnnew {
    begin {
        Get-Command dotnet -ea Stop | Out-Null
        Get-Command fzf -ea Stop | Out-Null
        Get-Command tr -ea Stop | Out-Null
    }

    end {
        $templates = dotnet new list | Select-Object -Skip 4 | ForEach-Object {
            if ($_ -match '^(?<Name>.+?)\s{2,}(?<ShortName>.+?)\s{2,}(?<Lang>(\s{2,}|\S+))(\s{2,})?(?<Tags>.*$)') {
                $Lang = $Matches.Lang
                $Tags = if ([string]::IsNullOrEmpty($Matches.Tags)) {
                    $Matches.Lang
                    $Lang = [string]::Empty
                } else {
                    $Matches.Tags
                }

                if ($Matches.ShortName.Contains(',')) {
                    $Matches.ShortName -split ',' | ForEach-Object {
                        "$_`tDesc: $($Matches.Name)`tLang: $($Lang)`tTags: $($Tags)"
                    }
                } else {
                    "$($Matches.ShortName)`tDesc: $($Matches.Name)`tLang: $($Lang)`tTags: $($Tags)"
                }
            }
        }
        $templates | fzf --delimiter='\t' `
            --with-nth=1 `
            --preview-window=down `
            --preview='echo {2..} | tr "\t" "\n"' `
            --bind "enter:execute(dotnet new {1} $($args -join ' '))+abort"
    }
}

function dnpack {
    begin {
        Get-Command dotnet -ea Stop | Out-Null
        Get-Command fzf -ea Stop | Out-Null
        Get-Command tr -ea Stop | Out-Null
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
            if (-not (Get-Command devenv -ea SilentlyContinue)) {
                Get-Command vswhere -ea Stop | Out-Null
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

            if (Get-Command devenv -ea SilentlyContinue) {
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
            [string]$Path,
            [switch]$IsNotWSL
        )
        begin {
            Get-Command diskpart -CommandType Application -ea Stop | Out-Null

            if (-not $IsNotWSL) {
                $origEncoding = [Console]::OutputEncoding
                [Console]::OutputEncoding = [System.Text.Encoding]::Unicode # wsl outputs unicode 16
                if (wsl --list --verbose | Select-String Running) {
                    Write-Warning 'Please make sure distro were terminated by `wsl -t <distro>`'
                    return
                }
                [Console]::OutputEncoding = $origEncoding
                wsl –-shutdown
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
}
