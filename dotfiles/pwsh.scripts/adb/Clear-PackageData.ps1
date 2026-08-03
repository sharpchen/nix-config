param(
    [ArgumentCompleter({ & "$PSScriptRoot/_Complete-Packages.ps1" @args })]
    [Parameter(Mandatory, Position = 0)]
    [string]$Name,

    [ushort]$Port = 5037,

    [ArgumentCompleter({ & "$PSScriptRoot/_Complete-SerialNumber.ps1" @args })]
    [string]$SerialNumber
)

begin {
    & "$PSScriptRoot/Assert-AdbServer.ps1" @PSBoundParameters

    $flags = '-P', $Port

    if ($SerialNumber) {
        $flags += '-s', $SerialNumber
    }
}

end {
    adb @flags pm clear $Name
}
