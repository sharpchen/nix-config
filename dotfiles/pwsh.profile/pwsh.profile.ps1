#Requires -Modules PSReadLine, PSFzf

Import-Module PSReadLine, PSFzf, git-completion

$env:PSModulePath += "$([IO.Path]::PathSeparator)$PSScriptRoot"

Import-Module PwshProfile -Scope Global

if (Get-Command zoxide -ea Ignore) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
