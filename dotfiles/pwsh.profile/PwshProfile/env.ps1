$IsLegacy = $PSVersionTable.PSEdition -eq 'Desktop'
$IsNixOS = Test-Path /etc/NIXOS
$IsWSL = $null -ne $env:WSL_DISTRO_NAME

$env:DOTNET_CLI_UI_LANGUAGE = 'en'
$env:EDITOR = 'nvim'

if ($IsWindows -or $IsLegacy) {
    $env:INVALID_FILENAME_CHARS = ':"<>|?*/\'
}

if ($IsLinux -or $IsMacOS) {
    $env:MANPAGER = 'nvim +Man!'
}

if (Test-Path ~/.fzfrc) {
    $env:FZF_DEFAULT_OPTS_FILE = (Resolve-Path ~/.fzfrc).Path
}
