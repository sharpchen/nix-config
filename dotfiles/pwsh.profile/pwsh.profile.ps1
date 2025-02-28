if ($PSVersionTable.PSEdition -eq 'Core') {
    Resolve-Path "$PSScriptRoot/Profile/*.ps1" | ForEach-Object {
        . $_.Path
    }
} else {
    . "$PSScriptRoot/Profile/set.ps1"
    . "$PSScriptRoot/Profile/keymap.ps1"
    . "$PSScriptRoot/Profile/alias.ps1"
}
