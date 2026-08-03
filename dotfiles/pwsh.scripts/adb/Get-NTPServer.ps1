param(
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
    adb @flags shell settings get global ntp_server
}
