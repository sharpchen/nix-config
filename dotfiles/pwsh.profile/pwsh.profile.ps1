#Requires -Modules PSFzf

Import-Module git-completion -ErrorAction SilentlyContinue

$env:PSModulePath += "$([IO.Path]::PathSeparator)$PSScriptRoot"

Import-Module PwshProfile -Scope Global -DisableNameChecking

if (Get-Command zoxide -ErrorAction Ignore) {
    zoxide init powershell | Out-String | Invoke-Expression
}
