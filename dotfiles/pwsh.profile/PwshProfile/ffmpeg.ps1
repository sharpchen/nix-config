#Requires -Version 7.6.0

# NOTE: this utility only handles single(first) video stream and audio stream

# TODO:
# To have a proper composable cmdlets to build filter_complex,
# 1. A context object along the pipeline, including following properties:
#   - Inputs: FFInput[]
#   - FilterComplex: FFFilterComplex a builder instead of pure string
# 2. Handle -map at the end

using namespace System.Collections.Generic

$script:__ff_flags = '-loglevel', 'error', '-hide_banner'
# flags for concat demuxer -f concat only, not concat filter!
$script:__ff_concat_flags = $script:__ff_flags + '-safe', '0'

function __ff_error {
    param(
        [Parameter(Position = 0)]
        [int]$ExitCode,
        [Parameter(Position = 1)]
        $ErrVar
    )

    if ($ExitCode -ne 0) {
        Write-Error ($ErrVar -join [System.Environment]::NewLine) -ErrorAction Stop
    }
}

function __media-type-info {
    param(
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(Mandatory, Position = 0)]
        [string]$LiteralPath
    )

    $null = Get-Command file -ErrorAction Stop

    $mimetype = file $LiteralPath --mime-type -b

    [pscustomobject]@{
        IsVideo = $mimetype -match '^video/'
        IsAudio = $mimetype -match '^audio/'
    }
}

function ff-concat {
    [CmdletBinding(DefaultParameterSetName = 'SameCodec')]
    param(
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Alias('FullName', 'i')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$LiteralPath,

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
            if ($LiteralPath.Contains("'")) {
                Write-Error "$LiteralPath contains single quote, please rename it and try again." -ErrorAction Stop
            }
            "file '$LiteralPath'" >> $tempFile
        }

        if ($ReEncode) {
            $files.Add($LiteralPath)
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

                __ff_error $LASTEXITCODE $err

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

                __ff_error $LASTEXITCODE $err

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
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$LiteralPath,

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
        $lastFile = $LiteralPath
        "file '$LiteralPath'" >> $tempFile
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

        __ff_error $LASTEXITCODE $err
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
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$LiteralPath
    )

    begin {
        $null = Get-Command ffprobe -ErrorAction Stop
    }

    process {
        ffprobe @script:__ff_flags -show_streams -of json -i $LiteralPath | ConvertFrom-Json | ForEach-Object streams
    }
}

function ff-cat-format {
    param(
        [Alias('FullName')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$LiteralPath
    )

    begin {
        $null = Get-Command ffprobe -ErrorAction Stop
    }

    process {
        ffprobe @script:__ff_flags -show_format -of json -i $LiteralPath | ConvertFrom-Json | ForEach-Object format
    }
}

function ff-audio_with_poster {
    param(
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(Mandatory)]
        [string]$Image,

        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
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

    __ff_error $LASTEXITCODE $err
}

function ff-metadata_update {
    param(
        [Alias('i')]
        [Parameter(Mandatory)]
        [string]$LiteralPath,

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
        [Alias('i')]
        [Parameter(Mandatory)]
        [string]$LiteralPath,

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

    $mediainfo = __media-type-info $LiteralPath
    # use -c:a flac probably because flac can handle higher sample rate
    $flags = '-i', $LiteralPath

    if ($mediainfo.IsVideo) {
        $flags += '-c:v', 'copy'
    }

    ffmpeg @flags `
        -c:a flac `
        -sample_fmt $SampleFormat `
        -ar $SampleRate `
        $OutFile `
        2>variable:err 1>$null

    __ff_error $LASTEXITCODE $err
}

function ff-silent {
    param (
        [Alias('FullName', 'i')]
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Alias('o')]
        [Parameter(Mandatory)]
        [string]$OutFile
    )

    $null = Get-Command ffmpeg -ErrorAction Stop

    $flags = '-i', $LiteralPath

    $mediainfo = __media-type-info $LiteralPath

    if ($mediainfo.IsVideo) {
        # -an removes audio stream entirely
        $flags += '-c:v', 'copy', '-an'
    } elseif ($mediainfo.IsAudio) {
        # using filter to keep the audio stream but silent it
        # otherwise the audio should have no length at all
        $flags += '-af', 'volume=0'
    }


    ffmpeg @script:__ff_flags @flags $OutFile 2>variable:err 1>$null

    __ff_error $LASTEXITCODE $err
}

function ff-loudness-get {
    param(
        [Alias('i')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(Mandatory, Position = 0)]
        [string]$LiteralPath
    )

    $null = Get-Command ffmpeg -ErrorAction Stop

    $result = ffmpeg -hide_banner -i $LiteralPath -af volumedetect -f null - 2>&1 | Select-String '(?:mean|max)_volume: (?<value>.*) dB'

    $mean = $result.Matches | Where-Object Value -Match 'mean' | ForEach-Object { $_.Groups['value'].Value }
    $max = $result.Matches | Where-Object Value -Match 'max' | ForEach-Object { $_.Groups['value'].Value }

    # unit in dB
    [pscustomobject]@{
        Mean = [float]::Parse($mean)
        Max  = [float]::Parse($max)
    }
}

# TIP: based on personal experience, > -12dB is too loud, < 30dB is too quiet
function ff-loudness-normalize {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Alias('FullName', 'i')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$LiteralPath,

        [ValidateScript({ $_ -is [scriptblock] -or (Test-Path $_ -IsValid) })]
        [Alias('o')]
        [Parameter(Mandatory)]
        $OutFile,

        [ValidateSet('EbuR128', 'YouTube', 'Spotify', 'AtscA85', 'AppleMusic', 'Netflix', 'AmazonPrime')]
        [string]$Target = 'EbuR128'
    )

    begin {
        $null = Get-Command ffmpeg -ErrorAction Stop

        if ($MyInvocation.ExpectingInput -and $OutFile -isnot [scriptblock]) {
            Write-Error '-OutFile must be of [scriptblock] when accepting pipeline input.' -ErrorAction Stop
        }

        # See: https://ffmpeg.org/ffmpeg-filters.html#loudnorm
        # See also: https://docs.rs/oximedia-metering/0.1.1/oximedia_metering/enum.Standard.html
        # TIP: Personally recommend EbuR128 to louden, YouTube to quieten
        switch ($Target) {
            # European Broadcasting Union, good for tv shows maybe
            'EbuR128' {
                $integrated_loudness_target = -23
                $max_true_peak = -1
            }
            { $_ -in 'YouTube', ' Spotify' } {
                $integrated_loudness_target = -14
                $max_true_peak = -1
            }
            'Netflix' {
                $integrated_loudness_target = -27
                $max_true_peak = -2
            }
            # Advanced Television Systems Committee - US
            { $_ -in 'AtscA85', 'AmazonPrime' } {
                $integrated_loudness_target = -24
                $max_true_peak = -2
            }
            'AppleMusic' {
                $integrated_loudness_target = -16
                $max_true_peak = -1
            }
            default {
                # don't really know if this is good for anything
                # from current experience, EbuR128 is good as default
                $integrated_loudness_target = -16
                $max_true_peak = -1.5
            }
        }

        Write-Verbose "Using target [$Target] with Integrated Loudness Target: $integrated_loudness_target, Max True Peak: $max_true_peak"

        $measure_log = New-TemporaryFile
    }

    process {
        $out = if ($OutFile -is [scriptblock]) {
            $OutFile.InvokeWithContext($null, [psvariable]::new('_', (Get-Item -LiteralPath $LiteralPath)))
        } else {
            $OutFile
        }

        $rel_in = Resolve-Path -RelativeBasePath $PWD -LiteralPath $LiteralPath -Relative

        if ($PSCmdlet.ShouldProcess("$rel_in => $out", $null, $null)) {
            # See: https://dev.to/masonwritescode/two-pass-loudness-normalization-with-ffmpeg-loudnorm-the-right-way-1nm3
            # don't use $__ff_flags here as -loglevel error suppresses expected output
            ffmpeg -hide_banner -i $LiteralPath -af "loudnorm=I=$($integrated_loudness_target):TP=$($max_true_peak):LRA=11:print_format=json" -f null - 2>$measure_log

            $json = Get-Content $measure_log -Raw | Select-String '(?m)^\{[^{}]+\}' | ForEach-Object { $_.Matches.Value } | ConvertFrom-Json

            $flags = @(
                '-i', $LiteralPath,
                '-af', "loudnorm=I=$($integrated_loudness_target):TP=$($max_true_peak):LRA=11:measured_I=$($json.input_i):measured_TP=$($json.input_tp):measured_LRA=$($json.input_lra):measured_thresh=$($json.input_thresh):offset=$($json.target_offset):linear=true",
                '-c:a', 'aac',
                '-b:a', '192k',
                '-ar', '48000'
            )

            $mediainfo = __media-type-info $LiteralPath

            if ($mediainfo.IsVideo) {
                $flags += '-c:v', 'copy'
            }

            # it seems confirm prompt is redirected as well
            ffmpeg @script:__ff_flags @flags -y $out 2>variable:err 1>$null

            __ff_error $LASTEXITCODE $err
        }
    }

    clean {
        Remove-Item $measure_log -ErrorAction Ignore
    }
}
