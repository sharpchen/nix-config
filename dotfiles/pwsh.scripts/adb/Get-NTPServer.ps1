param(
    [ushort]$Port = 5037,
    [ArgumentCompleter({
            param (
                $commandName,
                $parameterName,
                $wordToComplete,
                $commandAst,
                $fakeBoundParameters
            )
            & "$PSScriptRoot/_Complete-SerialNumber.ps1" @PSBoundParameters
        })]
    [string]$SerialNumber
)

begin {
    & "$PSScriptRoot/Assert-AdbServer.ps1" @PSBoundParameters

    if (-not $SerialNumber) {
        $flags = @('-P', $Port)
    } else {
        $flags = @('-P', $Port, '-s', $SerialNumber)
    }
}

end {
    adb @flags shell settings get global ntp_server
}
