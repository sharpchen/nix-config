param(
    [ValidateSet('CodeName', 'SerialNumber')]
    [string]$Property,
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
    [string]$SerialNumber
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
    switch ($Property) {
        'CodeName' {
            adb @flags shell getprop ro.product.device
        }
        'SerialNumber' {
            adb @flags shell getprop ro.serialno
        }
    }
}
