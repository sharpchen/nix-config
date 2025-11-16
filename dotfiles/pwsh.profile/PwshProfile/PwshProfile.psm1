. "$PSScriptRoot/env.ps1"
. "$PSScriptRoot/set.ps1"
. "$PSScriptRoot/keymap.ps1"
. "$PSScriptRoot/function.ps1"
. "$PSScriptRoot/windows.ps1"
. "$PSScriptRoot/alias.ps1"
. "$PSScriptRoot/completion.ps1"
. "$PSScriptRoot/scoop.ps1"

Export-ModuleMember -Function * -Alias *
