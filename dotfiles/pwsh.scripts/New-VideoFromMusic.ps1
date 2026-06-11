#Requires -Modules PwshProfile -Version 7.6.0

param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]$Path,

    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [Parameter(Mandatory)]
    [string]$Destination,

    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$Cover,

    [switch]$MakeInfo,
    [switch]$Convert
)

begin {
    $null = Get-Command ffmpeg -ErrorAction Stop
    $null = Get-Command ffprobe -ErrorAction Stop

    $Destination ??= $PWD.Path

    if (-not (Test-Path $Destination)) {
        Write-Verbose 'Destination does not exist, creating forcibly'
        $null = New-Item -ItemType Directory -Path $Destination -ErrorAction Ignore
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
    $allMusic = @($input)

    if (-not $Cover) {
        $Cover = [System.IO.Path]::GetTempFileName()
        Write-Verbose 'Cover unspecified, extracting from audio file'
        ffmpeg -hide_banner -i $allMusic[0] -an -vcodec copy $Cover *>$null
    }

    foreach ($music in $allMusic) {
        $json = ffprobe -v error -show_format -hide_banner -of json -i $music
        $mediaInfo = $json | ConvertFrom-Json
        $filename = Split-Path $music -Leaf
        $aname = $mediaInfo.format.tags.title

        if ($filename -match '^(?<Index>\d+)\.?(?<Name>.*)$') {
            $index = $matches.Index
            if ([string]::IsNullOrEmpty($aname)) {
                Write-Verbose 'Title not found in tags, extracting from filename'
                $aname = Split-Path $matches.Name.Trim() -LeafBase
            }
        }

        $vname = "$index.「$aname」"

        foreach ($group in $invalidChar) {
            $vname = $vname -replace $group
        }

        $info.Add($vname)

        $vout = $Convert ? [IO.Path]::GetTempFileName() -replace '\.tmp$', '.mp4' : (Join-Path $Destination "$vname.mp4")

        PwshProfile\ff-audio_with_poster -Image $Cover -Audio $music -OutFile $vout

        if ($Convert) {
            PwshProfile\ff-resample -i $vout -SampleRate 48000 -SampleFormat s32 -OutFile (Join-Path $Destination "$vname.mp4")
        }
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
        Remove-Item -Path $vout
    }
}
