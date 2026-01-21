param(
    [ArgumentCompleter({
            param (
                $commandName,
                $parameterName,
                $wordToComplete,
                $commandAst,
                $fakeBoundParameters
            )
            & "$PSScriptRoot/_Complete-Packages.ps1" @PSBoundParameters
        })]
    [Parameter(Mandatory)]
    [string]$Name,

    [switch]$KeepData,

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

    $flags = '-P', $Port

    if ($SerialNumber) {
        $flags += '-s', $SerialNumber
    }
}

end {
    adb @flags uninstall $(if ($KeepData) { '-k' }) $Name
}
