#Requires -Version 7.6.0

# NOTE: this utility only handles single(first) video stream and audio stream

using namespace System.Collections.Generic

$script:__ff_flags = '-loglevel', 'error', '-hide_banner'
# flags for concat demuxer -f concat only, not concat filter!
$script:__ff_concat_flags = $script:__ff_flags + '-safe', '0'

function __media-type-info {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    $null = Get-Item $Path -ErrorAction Stop
    $null = Get-Command file -ErrorAction Stop

    $mimetype = file $Path --mime-type -b

    [pscustomobject]@{
        IsVideo = $mimetype -match '^video/'
        IsAudio = $mimetype -match '^audio/'
    }
}

function ff-concat {
    [CmdletBinding(DefaultParameterSetName = 'SameCodec')]
    param(
        [Alias('FullName', 'i')]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$InputObject,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Alias('o')]
        [Parameter(Mandatory, ParameterSetName = 'ReEncode')]
        [Parameter(Mandatory, ParameterSetName = 'SameCodec')]
        [string]$OutFile,

        [Parameter(ParameterSetName = 'ReEncode')]
        [Parameter(ParameterSetName = 'SameCodec')]
        [switch]$Passthru,

        [Parameter(ParameterSetName = 'Defer')]
        [Alias('d')]
        [switch]$Defer, # TODO: make it a filter_complex builder along the pipeline

        [Parameter(Mandatory, ParameterSetName = 'ReEncode')]
        [switch]$ReEncode
    )

    begin {
        $ErrorActionPreference = 'Stop'

        $null = Get-Command ffmpeg -ErrorAction Stop -CommandType Application

        $tempFile = New-TemporaryFile

        $files = [List[string]]::new()
    }

    process {
        if (-not $ReEncode -and -not $Defer) {
            "file '$InputObject'" >> $tempFile
        }

        if ($ReEncode) {
            $files.Add($InputObject)
        }
    }

    end {
        # NOTE: using filter_complex to concat requires re-encoding!
        switch ($PSCmdlet.ParameterSetName) {
            'Defer' {
                # TODO: should return an object representing the status
                # including 1)current filter_complex and 2) input files
                Write-Error 'not implemented'
                [pscustomobject]@{
                    filter_complex = ''
                    files          = @()
                }
            }
            'ReEncode' {
                $inputFlags = @()
                $filterComplex = ''

                for ($i = 0; $i -lt $files.Count; $i++) {
                    $inputFlags += '-i', $files[$i]
                    $filterComplex += "[$($i):v:0][$($i):a:0]" # pick first video/audio stream from every input
                }

                # [vout] and [aout] is custom name for the output video/audio stream
                $filterComplex += "concat=n=$($files.Count):v=1:a=1[vout][aout]"

                # use -map to explicitly specify output streams
                ffmpeg @script:__ff_flags `
                    @inputFlags `
                    -filter_complex $filterComplex `
                    -map '[vout]' -map '[aout]' $OutFile `
                    2>variable:err 1>$null

                if ($LASTEXITCODE -ne 0) {
                    Write-Error ($err -join [System.Environment]::NewLine) -ErrorAction Stop
                }

                if ($Passthru) {
                    Get-Item $OutFile
                }

            }
            default {
                # this approach requires all medias have same codec
                ffmpeg @script:__ff_concat_flags `
                    -f concat `
                    -i $tempFile `
                    -c copy `
                    $OutFile `
                    2>variable:err 1>$null

                if ($LASTEXITCODE -ne 0) {
                    Write-Error ($err -join [System.Environment]::NewLine) -ErrorAction Stop
                }

                if ($Passthru) {
                    Get-Item $OutFile
                }
            }
        }
    }

    clean {
        Remove-Item $tempFile
    }
}

# generating a slide video from images
# see: https://trac.ffmpeg.org/wiki/Slideshow#Concatdemuxer
function ff-slide {
    param(
        [Alias('FullName', 'i')]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$InputObject,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Alias('o')]
        [string]$OutFile,

        [ushort[]]$Duration
    )

    begin {
        $null = Get-Command ffmpeg -ErrorAction Stop
        $tempFile = New-TemporaryFile
        $lastFile = $null
        $idx = 0
    }

    process {
        $lastFile = $InputObject
        "file '$InputObject'" >> $tempFile
        "duration $($duration.Count -gt 1 ? $duration[$idx++] : $duration[0])" >> $tempFile
    }

    end {
        "file '$lastFile'" >> $tempFile # has to add last file again without duration

        ffmpeg @script:__ff_concat_flags `
            -f concat `
            -i $tempFile `
            -vsync vfr `
            -pix_fmt yuv420p `
            $OutFile `
            2>variable:err 1>$null

        if ($LASTEXITCODE -ne 0) {
            Write-Error ($err -join [System.Environment]::NewLine) -ErrorAction Stop
        }
    }

    clean {
        Remove-Item $tempFile
    }
}

function ff-exec {
    # executes the final filter_complex
}

function ff-cat-stream {
    param(
        [Alias('FullName')]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path
    )

    begin {
        $null = Get-Command ffprobe -ErrorAction Stop
    }

    process {
        ffprobe @script:__ff_flags -show_streams -of json -i $Path | ConvertFrom-Json | ForEach-Object streams
    }
}

function ff-cat-format {
    param(
        [Alias('FullName')]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path
    )

    begin {
        $null = Get-Command ffprobe -ErrorAction Stop
    }

    process {
        ffprobe @script:__ff_flags -show_format -of json -i $Path | ConvertFrom-Json | ForEach-Object format
    }
}

function ff-audio_with_poster {
    param(
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Parameter(Mandatory)]
        [string]$Image,

        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Parameter(Mandatory)]
        [string]$Audio,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Alias('o')]
        [Parameter(Mandatory)]
        [string]$OutFile
    )

    $null = Get-Command ffmpeg -ErrorAction Stop

    # see: https://trac.ffmpeg.org/wiki/Slideshow#Addingaudio
    # -r 1 meaning output video has 1 framerate
    # you might need -strict -2 if the audio format isn't supported in mp4
    ffmpeg @script:__ff_flags `
        -loop 1 `
        -i $Image `
        -i $Audio `
        -c:v libx264 `
        -c:a copy `
        -r 1 `
        -shortest `
        $OutFile `
        2>variable:err 1>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Error ($err -join [System.Environment]::NewLine) -ErrorAction Stop
    }
}

function ff-metadata_update {
    param(
        [Alias('FullName', 'i')]
        [Parameter(Mandatory)]
        [string]$InputObject,

        # name of metadata are not guaranteed, some of them might be all capital TITLE
        [ArgumentCompletions(
            'title', 'artist', 'track',
            'genre', 'album', 'date',
            'album_artist', 'composer', 'copyright',
            'organization', 'comment', 'performer')]
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Value
    )

    Write-Error 'not implemented'
}

function ff-resample {
    param (
        [Alias('FullName', 'i')]
        [Parameter(Mandatory)]
        [string]$InputObject,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Alias('o')]
        [Parameter(Mandatory)]
        [string]$OutFile,

        [Parameter(Mandatory)]
        [ArgumentCompletions(48000)]
        [uint]$SampleRate,

        [Parameter(Mandatory)]
        [ArgumentCompletions('s32', 's16')]
        [string]$SampleFormat
    )

    $null = Get-Command ffmpeg -ErrorAction Stop

    $mediainfo = __media-type-info $InputObject
    # use -c:a flac probably because flac can handle higher sample rate
    $flags = '-i', $InputObject

    if ($mediainfo.IsVideo) {
        $flags += '-c:v', 'copy'
    }

    ffmpeg @flags `
        -c:a flac `
        -sample_fmt $SampleFormat `
        -ar $SampleRate `
        $OutFile `
        2>variable:err 1>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Error ($err -join [System.Environment]::NewLine) -ErrorAction Stop
    }
}

function ff-silent {
    param (
        [Alias('FullName', 'i')]
        [Parameter(Mandatory)]
        [string]$InputObject,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Alias('o')]
        [Parameter(Mandatory)]
        [string]$OutFile
    )

    $null = Get-Command ffmpeg -ErrorAction Stop

    $mediainfo = __media-type-info $InputObject

    $flags = '-i', $InputObject

    if ($mediainfo.IsVideo) {
        # -an removes audio stream entirely
        $flags += '-c:v', 'copy', '-an'
    } elseif ($mediainfo.IsAudio) {
        # using filter to keep the audio stream but silent it
        # otherwise the audio should have no length at all
        $flags += '-af', 'volume=0' 
    }


    ffmpeg @script:__ff_flags @flags $OutFile 2>variable:err 1>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Error ($err -join [System.Environment]::NewLine) -ErrorAction Stop
    }
}
