# this file is for restoring dotfiles on windows

if (-not $IsWindows -or $PSVersionTable.PSEdition -ne 'Desktop') {
    Write-Error 'This script is only allowed to be executed on windows'
    return
}

function mklink {
    [CmdletBinding(DefaultParameterSetName = 'Normal')]
    param (
        [Parameter(Position = 0, ParameterSetName = 'Normal', Mandatory)]
        [string]$Path,

        [Parameter(Position = 1, ParameterSetName = 'Normal', Mandatory)]
        [Parameter(ParameterSetName = 'Special', Mandatory)]
        [string]$Target,

        [Parameter(ParameterSetName = 'Special', Mandatory)]
        [string]$ChildPath,

        [ValidateSet('LOCALAPPDATA', 'APPDATA', 'HOME')]
        [Parameter(ParameterSetName = 'Special', Mandatory)]
        [string]$SpecialParent
    )

    $Target = Resolve-Path $Target
    if ($PSCmdlet.ParameterSetName -eq 'Normal') {
        mkdir (Split-Path $Path) -ErrorAction SilentlyContinue
        New-Item -ItemType SymbolicLink -Force -Value $Target -Path $Path
    } else {
        if ($SpecialParent -eq 'HOME') {
            New-Item -ItemType SymbolicLink -Force -Value $Target -Path (Join-Path $HOME $ChildPath)
        } else {
            New-Item -ItemType SymbolicLink -Force -Value $Target -Path (Join-Path (Get-Item -Path "env:/$SpecialParent").Value $ChildPath)
        }
    }

}

if (Get-Command scoop -ea SilentlyContinue) {
    $scoopRoot = Resolve-Path ~/scoop
    # librewolf overrides
    mklink (Join-Path $scoopRoot 'persist/librewolf/Profiles/Default/librewolf.overrides.cfg') ./dotfiles/librewolf.cfg
    [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', ([IO.Path]::Combine($scoopRoot, 'apps\git\current\usr\bin\file.exe')), 'User')
    mklink (Join-Path $scoopRoot 'apps/sioyek/current/keys_user.config') ./dotfiles/sioyek.keys_user.config
}

if (Get-Command nvim -ea SilentlyContinue) {
    $nvimConfig = Join-Path $env:LOCALAPPDATA 'nvim'
    if (Test-Path $nvimConfig) {
        Remove-Item -Recurse $nvimConfig
    }
    mklink $nvimConfig ./dotfiles/nvim-config
}

# git
mklink ~/.gitconfig ./dotfiles/.gitconfig
mklink ~/.gitconfig_windows ./dotfiles/.gitconfig-windows
mklink -SpecialParent LOCALAPPDATA -ChildPath 'lazygit/config.yml' -Target ./dotfiles/lazygit.config.yml

# vim
mklink ~/.vimrc ./dotfiles/.vimrc
mklink ~/.vsvimrc ./dotfiles/.vsvimrc
mklink ~/.ideavimrc ./dotfiles/.ideavimrc

# shell
mklink ~/.bashrc ./dotfiles/.bashrc

# pwsh
mklink $PROFILE ./dotfiles/pwsh.profile/pwsh.profile.ps1
mklink (Join-Path (Split-Path $PROFILE) 'Profile') ./dotfiles/pwsh.profile/Profile/

# powershell
$powershellProfile = (powershell -noprofile -nologo -c '$PROFILE')
mklink  $powershellProfile ./dotfiles/pwsh.profile/pwsh.profile.ps1
mklink (Join-Path (Split-Path $powershellProfile) 'Profile') ./dotfiles/pwsh.profile/Profile/

mklink ~/.config/wezterm/wezterm.lua ./dotfiles/.wezterm.lua

# yazi
mklink -SpecialParent APPDATA -ChildPath 'yazi/config/yazi.toml' -Target ./dotfiles/yazi.toml
mklink -SpecialParent APPDATA -ChildPath 'yazi/config/keymap.toml' -Target ./dotfiles/yazi.keymap.toml
if (Get-Command ya -ErrorAction SilentlyContinue) {
    ya pack -a 'Reledia/glow'
    ya pack -a 'ndtoan96/ouch'
    ya pack -a 'Reledia/miller'
    ya pack -a 'Tyarel8/video-ffmpeg'
    ya pack -a 'kirasok/torrent-preview'
    ya pack -a 'yazi-rs/plugins:max-preview'
}

mklink ~/.wslconfig ./dotfiles/.wslconfig
mklink (Join-Path (Split-Path (scoop which mpv)) 'portable_config/mpv.conf') ./dotfiles/mpv.conf
mklink (Join-Path (Split-Path (scoop which mpv)) 'portable_config/input.conf') ./dotfiles/mpv.input.conf
