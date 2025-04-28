#Requires -RunAsAdministrator

# This file is for fresh installation on a new windows

function RefreshPath {
    $env:Path =
    [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
    + ';'
    + [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
}

if (-not (Get-Command scoop -ea SilentlyContinue)) {
    # install scoop
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add fonts 'https://github.com/KnotUntied/scoop-fonts.git'
RefreshPath
#endregion

$scoopPackages = @(
    'git',
    'vswhere',
    'neovim',
    'bat',
    'tokei',
    'pnpm',
    'adb',
    'gcc',
    'ripgrep',
    'lazygit',
    'nodejs-lts',
    'wiztree',
    '7zip',
    'fzf',
    'vscodium',
    'carnac',
    'librewolf',
    'abdownloadmanager',
    'mpv',
    'ffmpeg',
    'yazi',
    'imagemagick',
    'poppler',
    'jq',
    'fd',
    'miller',
    'ouch',
    'glow',
    'uutils-coreutils',
    'sioyek',
    'pwsh',
    'powertoys',
    'ditto'
)

$scoopFonts = @(
    'Cascadia-Code',
    'jetbrainsmono-nl',
    'notosansmono'
)

$wingetPackages = @(
    'wez.wezterm',
    'Microsoft.VisualStudio.2022.Community',
    'File-New-Project.EarTrumpet',
    'dotPDN.PaintDotNet',
    'Ditto.Ditto',
    'Google.Chrome'
)

& ./dotfiles.ps1

scoop install @scoopPackages
scoop install @scoopFonts
winget add --silent --accept-source-agreements @wingetPackages

RefreshPath
