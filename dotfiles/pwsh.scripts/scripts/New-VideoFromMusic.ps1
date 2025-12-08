param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]$Path,

    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [Parameter(Mandatory)]
    [string]$Destination,

    [ValidateScript({ [IO.File]::Exists((Resolve-Path $_)) })]
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
