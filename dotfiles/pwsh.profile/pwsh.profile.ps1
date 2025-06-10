#Requires -Modules PSReadLine, PSFzf

Import-Module PSReadLine, 'PSFzf'

$env:PSModulePath += "$([IO.Path]::PathSeparator)$PSScriptRoot"

Import-Module PwshProfile -Scope Global
# Import-Module "$PSScriptRoot/Profile/PwshProfile.psm1" -Scope Global

if (Get-Command zoxide -ea SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
