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
            ./Complete-SerialNumber.ps1 @PSBoundParameters
        })]
    [string]$SerialNumber,
    [Parameter(Mandatory)]
    [ArgumentCompleter({ 'ntp.ntsc.ac.cn' })]
    [string]$Server
)

begin {
    & ./Assert-AdbServer.ps1 @PSBoundParameters

    if (-not $SerialNumber) {
        $flags = @('-P', $Port)
    } else {
        $flags = @('-P', $Port, '-s', $SerialNumber)
    }
}

end {
    adb @flags shell settings put global ntp_server $Server
    Write-Warning 'Make sure your device has *Set time automatically* enabled'
    Write-Warning 'Make sure your device has network access'

    $status = adb @flags shell cmd network_time_update_service force_refresh

    if ($status -eq 'false') {
        Write-Error 'adb responsed with result: false, please ensure network access your device'
    }
}
