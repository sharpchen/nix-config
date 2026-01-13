# this file is for restoring dotfiles on windows

if ($IsLinux -or $IsMacOS) {
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
    switch ($PSCmdlet.ParameterSetName) {
        'Normal' {
            mkdir (Split-Path $Path) -ErrorAction SilentlyContinue
            New-Item -ItemType SymbolicLink -Force -Value $Target -Path $Path
        }
        default {
            switch ($SpecialParent) {
                'HOME' {
                    New-Item -ItemType SymbolicLink -Force -Value $Target -Path (Join-Path $HOME $ChildPath)
                }
                default {
                    New-Item -ItemType SymbolicLink -Force -Value $Target -Path (Join-Path (Get-Item -Path "env:/$SpecialParent").Value $ChildPath)
                }
            }
        }
    }
}

if (Get-Command scoop -ea SilentlyContinue) {
    if (& { scoop prefix librewolf *> $null; 0 -eq $LASTEXITCODE }) {
        mklink (Join-Path (scoop prefix librewolf) 'Profiles/Default/librewolf.overrides.cfg') ./dotfiles/librewolf.cfg
    }

    if (& { scoop prefix git *> $null; 0 -eq $LASTEXITCODE }) {
        [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', (Join-Path (scoop prefix git) 'usr\bin\file.exe'), 'User')
    }

    if (& { scoop prefix sioyek *> $null; 0 -eq $LASTEXITCODE }) {
        mklink (Join-Path (scoop prefix sioyek) 'prefs_user.config') ./dotfiles/sioyek.prefs_user.config
        mklink (Join-Path (scoop prefix sioyek) 'keys_user.config') ./dotfiles/sioyek.keys_user.config
    }
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
mklink ~/.windows.gitconfig. ./dotfiles/.windows.gitconfig
mklink -SpecialParent LOCALAPPDATA -ChildPath 'lazygit/config.yml' -Target ./dotfiles/lazygit.config.yml

# vim
mklink ~/.vimrc ./dotfiles/.vimrc
mklink ~/.keymap.vim ./dotfiles/.keymap.vim
mklink ~/.vsvimrc ./dotfiles/.vsvimrc
mklink ~/.ideavimrc ./dotfiles/.ideavimrc

# shell
mklink ~/.bashrc ./dotfiles/.bashrc
mklink ~/.inputrc ./dotfiles/.inputrc

# pwsh
mklink $PROFILE ./dotfiles/pwsh.profile/pwsh.profile.ps1
mklink (Join-Path (Split-Path $PROFILE) 'PwshProfile') ./dotfiles/pwsh.profile/PwshProfile/

# powershell
$powershellProfile = (powershell -noprofile -nologo -c '$PROFILE')
mklink  $powershellProfile ./dotfiles/pwsh.profile/pwsh.profile.ps1
mklink (Join-Path (Split-Path $powershellProfile) 'PwshProfile') ./dotfiles/pwsh.profile/PwshProfile/

mklink ~/.config/wezterm/wezterm.lua ./dotfiles/.wezterm.lua

# yazi
mklink -SpecialParent APPDATA -ChildPath 'yazi/config/yazi.toml' -Target ./dotfiles/yazi.toml
mklink -SpecialParent APPDATA -ChildPath 'yazi/config/keymap.toml' -Target ./dotfiles/yazi.keymap.toml
if (Get-Command ya -ErrorAction SilentlyContinue) {
    ya pkg add yazi-rs/plugins:toggle-pane
    ya pkg add yazi-rs/plugins:jump-to-char
    ya pkg add AnirudhG07/rich-preview
}

mklink ~/.wslconfig ./dotfiles/.wslconfig
mklink (Join-Path (scoop prefix mpv) 'portable_config/mpv.conf') ./dotfiles/mpv.conf
mklink (Join-Path (scoop prefix mpv) 'portable_config/input.conf') ./dotfiles/mpv.input.conf
mklink ~/.fzfrc ./dotfiles/.fzfrc

if (& { scoop prefix vscodium *> $null; 0 -eq $LASTEXITCODE }) {
    mklink (Join-Path (scoop prefix vscodium) 'data/user-data/User/keybindings.json') ./dotfiles/vscode.keybinds.json
    mklink (Join-Path (scoop prefix vscodium) 'data/user-data/User/settings.json') ./dotfiles/vscode.settings.json
}

mklink ~/.ssh/config ./dotfiles/sshconfig

if (& { scoop prefix windows-terminal *> $null; 0 -eq $LASTEXITCODE }) {
    $settings = Join-Path (scoop prefix windows-terminal) 'settings' 'settings.json'
    if (Test-Path $settings -PathType Leaf) {
        # windows-terminal always generate profiles automatically
        # scoop would probably add profiles(wsl profiles ect) on installation too
        # so if settings.json already exists, we should add those generated profiles
        $generated = Get-Content $settings | ConvertFrom-Json
        $mySettings = Get-Content ./dotfiles/windows-terminal.settings.json | ConvertFrom-Json
        $mySettings.profiles.list = $generated.profiles.list
        $mySettings.defaultProfile = $generated.defaultProfile
        Set-Content $settings (ConvertTo-Json $mySettings)
    }
}
