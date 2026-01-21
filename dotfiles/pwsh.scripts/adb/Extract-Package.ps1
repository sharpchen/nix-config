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
    [string]$SerialNumber,
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
