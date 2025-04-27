#Requires -Modules PSReadLine, PSFzf
Import-Module PSReadLine
Import-Module PSFzf

Resolve-Path "$PSScriptRoot/Profile/*.ps1" | ForEach-Object {
    . $_.Path
}

if (Get-Command zoxide -ea SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
