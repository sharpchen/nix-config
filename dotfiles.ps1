# this file is for restoring dotfiles on windows

if (-not $IsWindows) {
    Write-Error 'This script is only allowed to be executed on windows' return 
}

if (Get-Command scoop) {
    $scoopRoot = [IO.Path]::GetDirectoryName([IO.Path]::GetDirectoryName((Get-Command scoop).Source))
    # librewolf overrides
    New-Item ([IO.Path]::Combine($scoopRoot, 'persist/librewolf/Profiles/Default/librewolf.overrides.cfg')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/librewolf.cfg')) -ItemType SymbolicLink -Force
    [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', ([IO.Path]::Combine($scoopRoot, 'apps\git\current\usr\bin\file.exe')), 'User')
}

$nvimConfig = [IO.Path]::Combine($env:LOCALAPPDATA, 'nvim/')
if (Get-ChildItem $nvimConfig) {
    Remove-Item -Recurse $nvimConfig 
}
New-Item $nvimConfig -Target ([IO.Path]::Combine($pwd, 'dotfiles/nvim-config/')) -ItemType SymbolicLink -Force

# git
New-Item '~/.gitconfig' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.gitconfig')) -ItemType SymbolicLink -Force
New-Item '~/.gitconfig_windows' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.gitconfig-windows')) -ItemType SymbolicLink -Force
New-Item ([IO.Path]::Combine($env:LOCALAPPDATA, 'lazygit/config.yml')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/lazygit.config.yml')) -ItemType SymbolicLink -Force

# vim
New-Item '~/.vimrc' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.vimrc')) -ItemType SymbolicLink -Force
New-Item '~/.vsvimrc' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.vsvimrc')) -ItemType SymbolicLink -Force
New-Item '~/.ideavimrc' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.ideavimrc')) -ItemType SymbolicLink -Force

# shell
New-Item '~/.bashrc' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.bashrc')) -ItemType SymbolicLink -Force
New-Item $Profile -Target ([IO.Path]::Combine($pwd, 'dotfiles/pwsh.profile.ps1')) -ItemType SymbolicLink -Force
New-Item ([IO.Path]::Combine($env:APPDATA, 'nushell/config.nu')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/config.nu')) -ItemType SymbolicLink -Force
New-Item '~/.config/wezterm/wezterm.lua' -Target ([IO.Path]::Combine($pwd, 'dotfiles/.wezterm.lua')) -ItemType SymbolicLink -Force

# yazi
New-Item ([IO.Path]::Combine($env:APPDATA, 'yazi/config/yazi.toml')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/yazi.toml')) -ItemType SymbolicLink -Force
New-Item ([IO.Path]::Combine($env:APPDATA, 'yazi/config/keymap.toml')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/yazi.keymap.toml')) -ItemType SymbolicLink -Force
if (Get-Command ya) {
    ya pack -a 'Reledia/glow'
    ya pack -a 'ndtoan96/ouch'
    ya pack -a 'Reledia/miller'
    ya pack -a 'Tyarel8/video-ffmpeg'
    ya pack -a 'kirasok/torrent-preview'
    ya pack -a 'yazi-rs/plugins:max-preview'
}

