param(
    [Parameter(Mandatory)]
    [string]$ExePath,

    [string[]]$ArgumentList,

    [Parameter(Mandatory)]
    [string]$Name,

    [switch]$AllUsers
)

begin {
    $ExePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ExePath)

    if ($AllUsers) {
        $registry = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    } else {
        $registry = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    }

    if ($ArgumentList) {
        $OFS = ' '
        $command = "`"$ExePath`" $ArgumentList"
    } else {
        $command = $ExePath
    }
}

end {
    New-ItemProperty -Path $registry -Name $Name -Value $command -PropertyType String
}
