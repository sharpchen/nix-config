#Requires -Modules PSReadLine, PSFzf, git-completion

Import-Module PSReadLine, PSFzf, git-completion

$env:PSModulePath += "$([IO.Path]::PathSeparator)$PSScriptRoot"

Import-Module PwshProfile -Scope Global -DisableNameChecking

if (Get-Command zoxide -ea Ignore) {
    zoxide init powershell | Out-String | Invoke-Expression
}

if (Get-Command scoop -ErrorAction Ignore) {
    Import-Module (Join-Path (scoop prefix scoop-completion) 'scoop-completion.psd1')
}
