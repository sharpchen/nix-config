#Requires -Modules PSReadLine, PSFzf, git-completion

Import-Module PSReadLine, PSFzf, git-completion

$env:PSModulePath += "$([IO.Path]::PathSeparator)$PSScriptRoot"

Import-Module PwshProfile -Scope Global

if (Get-Command zoxide -ea Ignore) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Get-Command scoop -ErrorAction Ignore) {
    Import-Module (Join-Path (scoop prefix scoop-completion) 'scoop-completion.psd1')
}
