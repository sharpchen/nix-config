param(
    [ushort]$Port = 5037,
    [ArgumentCompleter({ & "$PSScriptRoot/_Complete-SerialNumber.ps1" @args })]
    [string]$SerialNumber,
    [ArgumentCompleter({ & "$PSScriptRoot/_Complete-Packages.ps1" @args })]
    [Parameter(Mandatory, Position = 0)]
    [string]$Name,
    [string]$OutFile
)

begin {
    & "$PSScriptRoot/Assert-AdbServer.ps1" @PSBoundParameters

    $flags = '-P', $Port

    if ($SerialNumber) {
        $flags += '-s', $SerialNumber
    }

    $apk = (adb @flags shell pm path $Name) -replace '^package:', ''

    if (-not $OutFile) {
        $OutFile = Join-Path $PWD "$Name.apk"
    }
}

end {
    adb @flags pull $apk $OutFile
}
