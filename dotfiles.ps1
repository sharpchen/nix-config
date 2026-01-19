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
        mklink (Join-Path (scoop prefix librewolf) 'Profiles/Default/librewolf.overrides.cfg') $PSScriptRoot/dotfiles/librewolf.cfg
    }

    if (& { scoop prefix git *> $null; 0 -eq $LASTEXITCODE }) {
        [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', (Join-Path (scoop prefix git) 'usr\bin\file.exe'), 'User')
    }

    if (& { scoop prefix sioyek *> $null; 0 -eq $LASTEXITCODE }) {
        mklink (Join-Path (scoop prefix sioyek) 'prefs_user.config') $PSScriptRoot/dotfiles/sioyek.prefs_user.config
        mklink (Join-Path (scoop prefix sioyek) 'keys_user.config') $PSScriptRoot/dotfiles/sioyek.keys_user.config
    }
}

if (Get-Command nvim -ea SilentlyContinue) {
    $nvimConfig = Join-Path $env:LOCALAPPDATA 'nvim'
    if (Test-Path $nvimConfig) {
        Remove-Item -Recurse $nvimConfig
    }
    mklink $nvimConfig $PSScriptRoot/dotfiles/nvim-config
}

# git
mklink ~/.gitconfig $PSScriptRoot/dotfiles/.gitconfig
mklink ~/.windows.gitconfig. $PSScriptRoot/dotfiles/.windows.gitconfig
mklink -SpecialParent LOCALAPPDATA -ChildPath 'lazygit/config.yml' -Target $PSScriptRoot/dotfiles/lazygit.config.yml

# vim
mklink ~/.vimrc $PSScriptRoot/dotfiles/.vimrc
mklink ~/.keymap.vim $PSScriptRoot/dotfiles/.keymap.vim
mklink ~/.vsvimrc $PSScriptRoot/dotfiles/.vsvimrc
mklink ~/.ideavimrc $PSScriptRoot/dotfiles/.ideavimrc

# shell
mklink ~/.bashrc $PSScriptRoot/dotfiles/.bashrc
mklink ~/.inputrc $PSScriptRoot/dotfiles/.inputrc

# pwsh
mklink $PROFILE $PSScriptRoot/dotfiles/pwsh.profile/pwsh.profile.ps1
mklink (Join-Path (Split-Path $PROFILE) 'PwshProfile') $PSScriptRoot/dotfiles/pwsh.profile/PwshProfile/

# powershell
$powershellProfile = (powershell -noprofile -nologo -c '$PROFILE')
mklink  $powershellProfile $PSScriptRoot/dotfiles/pwsh.profile/pwsh.profile.ps1
mklink (Join-Path (Split-Path $powershellProfile) 'PwshProfile') $PSScriptRoot/dotfiles/pwsh.profile/PwshProfile/

mklink ~/.config/wezterm/wezterm.lua $PSScriptRoot/dotfiles/.wezterm.lua

# yazi
mklink -SpecialParent APPDATA -ChildPath 'yazi/config/yazi.toml' -Target $PSScriptRoot/dotfiles/yazi.toml
mklink -SpecialParent APPDATA -ChildPath 'yazi/config/keymap.toml' -Target $PSScriptRoot/dotfiles/yazi.keymap.toml
if (Get-Command ya -ErrorAction SilentlyContinue) {
    ya pkg add yazi-rs/plugins:toggle-pane
    ya pkg add yazi-rs/plugins:jump-to-char
    ya pkg add AnirudhG07/rich-preview
}

mklink ~/.wslconfig $PSScriptRoot/dotfiles/.wslconfig
mklink (Join-Path (scoop prefix mpv) 'portable_config/mpv.conf') $PSScriptRoot/dotfiles/mpv.conf
mklink (Join-Path (scoop prefix mpv) 'portable_config/input.conf') $PSScriptRoot/dotfiles/mpv.input.conf
mklink ~/.fzfrc $PSScriptRoot/dotfiles/.fzfrc

if (& { scoop prefix vscodium *> $null; 0 -eq $LASTEXITCODE }) {
    mklink (Join-Path (scoop prefix vscodium) 'data/user-data/User/keybindings.json') $PSScriptRoot/dotfiles/vscode.keybinds.json
    mklink (Join-Path (scoop prefix vscodium) 'data/user-data/User/settings.json') $PSScriptRoot/dotfiles/vscode.settings.json
}

mklink ~/.ssh/config $PSScriptRoot/dotfiles/sshconfig

if (& { scoop prefix windows-terminal *> $null; 0 -eq $LASTEXITCODE }) {
    $settings = Join-Path (scoop prefix windows-terminal) 'settings' 'settings.json'
    if (Test-Path $settings -PathType Leaf) {
        # windows-terminal always generate profiles automatically
        # scoop would probably add profiles(wsl profiles ect) on installation too
        # so if settings.json already exists, we should add those generated profiles
        $generated = Get-Content $settings | ConvertFrom-Json
        $mySettings = Get-Content $PSScriptRoot/dotfiles/windows-terminal.settings.json | ConvertFrom-Json
        $mySettings.profiles | Add-Member -MemberType NoteProperty -Name 'list' -Value $generated.profiles.list
        $mySettings | Add-Member -MemberType NoteProperty -Name 'defaultProfile' -Value $generated.defaultProfile
        Set-Content $settings (ConvertTo-Json $mySettings -Depth 100)
    }
}
