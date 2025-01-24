function adbin {
    [OutputType([void])]
    param( 
        [Parameter(Mandatory)]
        [string]$Str,
        [switch]$Enter
    )
    $special = @( ' ', '\|', '\$', '&', '\(', '\)', '~', '\*', "\'", '"', '<', '>')
    foreach ($char in $special) {
        $Str = $Str -replace $char, ($char.Length -gt 1 ? $char : "\$char")
    }
    adb shell input text $Str
    if ($Enter) {
        adb shell input keyevent KEYCODE_ENTER
    }
}

function iparam {
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
    if($PSCmdlet.ParameterSetName -eq 'Attribute') {

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
        $cmd = $cmd -is [System.Management.Automation.AliasInfo] ? (Get-Command $cmd.Definition) : $cmd
        ($cmd.ParameterSets | ForEach-Object {
            $out = [pscustomobject]@{ 
                Name = $_.Name
                Parameters = $_.Parameters | Where-Object Name -NotIn $CommonParams 
            }
            $joinParams = @{
                Property = 'Name'
                Separator = "$([System.Environment]::NewLine)`t" 
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
        [ValidateScript({ Test-Path $_ })]
        [string]$Path,
        [string]$Destination,
        [ValidateScript({ Test-Path $_ })]
        [string]$Cover
    )
    
    begin {
        Get-Command ffmpeg -ea Stop | Out-Null
        Get-Command ffprobe -ea Stop | Out-Null
        $Destination ??= $PWD.Path

        if (-not (Test-Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination -ea SilentlyContinue | Out-Null
        }

        [System.Collections.Generic.List[string]]$info = @()
    }

    end {
        $current = 0.0
        $allMusic = @($input)
        if (-not $Cover) {
            $Cover = [System.IO.Path]::GetTempFileName()
            ffmpeg -hide_banner -i $allMusic[0] -an -vcodec copy $Cover *>$null
        }
        foreach ($music in $allMusic) {
            Write-Progress -Activity 'Creating Videos' -Status $music -PercentComplete (($current++ / $allMusic.Length) * 100)
            $filename = Split-Path $music -Leaf
            if ($filename -match '^(?<Index>\d+)\.?(?<Name>.*)\..*$') {
                $index = $matches.Index
                $musicName = $matches.Name.Trim()
            } else {
                Write-Error "Cannot get index for $filename" -ea Stop
            }

            $mediaInfo = ffprobe -v error -show_format -show_streams -hide_banner -of json -i $music | ConvertFrom-Json
            $duration = [uint]$mediaInfo.format.duration + 1
            $videoname = "$index. 「$musicName」"
            $info.Add($videoname)

            # ffmpeg -i $music -c:v copy -c:a flac -sample_fmt s32 -ar 48000 (Join-Path $Destination $videoname) *>$null
            ffmpeg -v error -framerate 24 -loop 1 -i $Cover -i $music -strict -2 -t $duration -c:v libx264 -c:a copy -hide_banner (Join-Path $Destination "$videoname.mp4") *>$null
            Write-Progress -Activity 'Creating Videos' -Status $music -PercentComplete (($current / $allMusic.Length) * 100)
        }

        $head = "$($mediaInfo.format.tags.ALBUM) ($($mediaInfo.format.tags.DATE)) - $($mediaInfo.format.tags.ARTIST)"
        $info.InsertRange(0, [string[]]@($head, [string]::Empty))
        $info -join [System.Environment]::NewLine > (Join-Path $Destination "$head.txt")
    }

    clean {
        if ((Split-Path $Cover).StartsWith([System.IO.Path]::GetTempPath())) {
            Remove-Item -Path $Cover
        }
    }
}

function ago {
    param(
        [uint]$Day,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path
    )

    process {
        $item = Get-Item -Path $Path
        if ($item.CreationTime -lt [datetime]::Now.AddDays($Day)) {
            $item
        }
    }
}

function prompt {
    if ($IsWindows) {
        $pattern = 'C:\\Users\\[a-zA-Z0-9]+'
        $path = if ($pwd.ProviderPath -match $pattern) {
            "~$($pwd.ProviderPath -replace $pattern, '')" 
        } else { 
            $pwd.ProviderPath 
        }

        return "PS $path$('>' * ($nestedPromptLevel + 1)) "
    }
    return "PS $($pwd.ProviderPath -replace '/home/[a-zA-Z0-9]+', '~')$('>' * ($nestedPromptLevel + 1)) "
}
