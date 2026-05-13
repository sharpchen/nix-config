param(
    [ArgumentCompleter({
            param (
                $commandName,
                $parameterName,
                $wordToComplete,
                $commandAst,
                $fakeBoundParameters
            )
            if ($fakeBoundParameters.ContainsKey('AllUsers')) {
                $registry = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
            } else {
                $registry = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
            }
            Get-Item $registry | ForEach-Object Property
        })]
    [Parameter(Mandatory, Position = 0)]
    [string]$Name,

    [switch]$AllUsers
)

begin {
    if ($AllUsers) {
        $registry = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    } else {
        $registry = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    }
}

end {
    Remove-ItemProperty -Path $registry -Name $Name
}
