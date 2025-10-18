#Requires -RunAsAdministrator

# This file is for fresh installation on a new windows

if (-not (Get-Command scoop -ea SilentlyContinue)) {
    # install scoop
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

if (Get-Command scoop -ErrorAction Ignore) {
    scoop install git # NOTE: adding bucket requires git
    scoop bucket add extras
    scoop bucket add versions
    scoop bucket add nerd-fonts
    scoop bucket add fonts 'https://github.com/KnotUntied/scoop-fonts.git'

    $scoopPackages = @(
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
        'uutils-coreutils',
        'sioyek',
        'pwsh',
        'powertoys',
        'ditto',
        'perl',
        'scoop-completion',
        'less',
        'wezterm',
        'eartrumpet',
        'paint.net'
    )

    $scoopFonts = @(
        'Cascadia-Code',
        'jetbrainsmono-nl',
        'notosansmono',
        'ibmplexmono',
        'robotomono-variable'
    )

    scoop install @scoopPackages
    scoop install @scoopFonts
}

if (Test-Path ./dotfiles.ps1) {
    & ./dotfiles.ps1
}
