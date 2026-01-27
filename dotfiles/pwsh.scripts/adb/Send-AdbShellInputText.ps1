<#
    This script helps to input text for terminal like Termux on Android
    It may not function on input scenarios other than shell on Android
    It DOES NOT start shell on Android but simulate key press to input text.
    NOTE: if default port fails, try another port
#>

param(
    [Parameter(Mandatory)]
    [string]$InputText,
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
    [switch]$AcceptLine
)

begin {
    & "$PSScriptRoot/Assert-AdbServer.ps1" @PSBoundParameters

    $flags = '-P', $Port

    if ($SerialNumber) {
        $flags += '-s', $SerialNumber
    }

    $specials = @'
|$%;\&~*'"`<>()
'@

}

end {
    $InputText = $InputText -replace "[$([regex]::Escape($specials))]", '\$0'
    $InputText = $InputText -replace ' ', '%s'

    adb @flags shell input text $InputText

    if ($AcceptLine) {
        adb @flags shell input keyevent KEYCODE_ENTER
    }
}

