$IsLegacy = $PSVersionTable.PSEdition -eq 'Desktop'

$env:DOTNET_CLI_UI_LANGUAGE = 'en'

if ($IsLinux -or $IsMacOS) {
    $env:MANPAGER = 'nvim +Man!'
}

if (Test-Path ~/.fzfrc) {
    $env:FZF_DEFAULT_OPTS_FILE = (Resolve-Path ~/.fzfrc).Path
}
