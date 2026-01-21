param(
    [ArgumentCompletions('CodeName', 'SerialNumber', 'IMEI', 'IMEI1', 'IMEI2', 'APIVersion', 'AndriodVersion')]
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
    switch ($Property) {
        'CodeName' {
            adb @flags shell getprop ro.product.device
        }
        'SerialNumber' {
            adb @flags shell getprop ro.serialno
        }
        { $_ -in 'IMEI', 'IMEI1' } {
            # https://xdaforums.com/t/is-there-an-android-adb-shell-command-that-i-could-get-the-imei2-eid.4619891/post-90425269
            adb @flags shell "service call iphonesubinfo 1 s16 com.android.shell | awk -F `"'`" '{print `$2}' | tr -d '.[:space:]'"
        }
        'IMEI2' {
            # https://xdaforums.com/t/is-there-an-android-adb-shell-command-that-i-could-get-the-imei2-eid.4619891/post-90425269
            adb @flags shell "service call iphonesubinfo 4 i32 1 s16 com.android.shell | awk -F `"'`" '{print `$2}' | tr -d '.[:space:]'"
        }
        'AndriodVersion' {
            adb @flags shell getprop ro.build.version.release
        }
        'APIVersion' {
            adb @flags shell getprop ro.build.version.sdk
        }
    }
}
