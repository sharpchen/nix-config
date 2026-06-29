. "$PSScriptRoot/env.ps1"
. "$PSScriptRoot/set.ps1"
. "$PSScriptRoot/keymap.ps1"
. "$PSScriptRoot/function.ps1"
. "$PSScriptRoot/alias.ps1"
. "$PSScriptRoot/completion.ps1"

if ($IsLegacy -or $IsWindows) {
    . "$PSScriptRoot/windows.ps1"
    . "$PSScriptRoot/scoop.ps1"
}

if ($IsLinux) {
    . "$PSScriptRoot/linux.ps1"
}

if ($IsCoreCLR -and (Get-Command ffmpeg -ErrorAction Ignore)) {
    . "$PSScriptRoot/ffmpeg.ps1"
}

$export = @{
    Function = Get-ChildItem function: |
        Where-Object { $_.Source -eq 'PwshProfile' -and ($_.Name -notmatch '^__' -or $_.Name -in '__md') } |
        ForEach-Object Name

    Variable = Get-Variable -Scope Script | Where-Object Name -NotMatch '^__' |  ForEach-Object Name
    Alias    = '*'
}

Export-ModuleMember @export
