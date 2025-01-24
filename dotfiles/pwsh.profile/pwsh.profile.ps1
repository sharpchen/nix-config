Resolve-Path "$PSScriptRoot/Profile/*.ps1" | ForEach-Object {
    . $_.Path
}
