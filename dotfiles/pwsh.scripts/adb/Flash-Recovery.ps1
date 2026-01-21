[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$Recovery,
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
    [string]$SerialNumber,
    [ushort]$Port = 5037
)

begin {
    & "$PSScriptRoot/Assert-AdbServer.ps1" @PSBoundParameters
    $null = Get-Command fastboot -ErrorAction Stop -CommandType Application

    if (-not $SerialNumber) {
        $flags = @('-P', $Port)
    } else {
        $flags = @('-P', $Port, '-s', $SerialNumber)
    }
}

end {
    adb @flags reboot bootloader
    if ($PSCmdlet.ShouldProcess('Please confirm after the device entered fastboot', $null, $null)) {
        fastboot flash recovery $Recovery
    }
}
