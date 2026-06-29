$IsLegacy = $PSVersionTable.PSEdition -eq 'Desktop'
$IsNixOS = Test-Path /etc/NIXOS
$IsWSL = $null -ne $env:WSL_DISTRO_NAME

$env:DOTNET_CLI_UI_LANGUAGE = 'en'

# $env:EDITOR = 'nvim --cmd "lua vim.env.MINIMAL_NVIM = 1"'
$env:EDITOR = 'nvim'

# hugging face mirror
$env:HF_ENDPOINT = 'https://hf-mirror.com'

if ($IsWindows -or $IsLegacy) {
}

if ($IsLinux -or $IsMacOS) {
    $env:MANPAGER = 'nvim +Man!'
}

if (Test-Path ~/.fzfrc) {
    $env:FZF_DEFAULT_OPTS_FILE = (Resolve-Path ~/.fzfrc).Path
}
