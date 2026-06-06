#Requires -Version 7.6.0

param(
    [Alias('FullName', 'Files')]
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$Path,

    [ValidateScript({ Test-Path $_ -IsValid })]
    [Parameter(Mandatory, Position = 1)]
    [string]$OutFile,

    [switch]$Passthru
)

begin {
    $ErrorActionPreference = 'Stop'

    $null = Get-Command ffmpeg -ErrorAction Stop -CommandType Application
    $tempFile = New-TemporaryFile
}

end {
    $null = ($MyInvocation.ExpectingInput ? $input : $Path) | ForEach-Object { "file '$_'" >> $tempFile }
    ffmpeg -loglevel error -hide_banner -f concat -safe 0 -i $tempFile -c copy $OutFile 2>variable:err 1>$null

    if ($LASTEXITCODE -ne 0) {
        throw ($err -join [System.Environment]::NewLine)
    }

    if ( $Passthru) {
        Get-Item $OutFile
    }
}

clean {
    Remove-Item $tempFile
}
