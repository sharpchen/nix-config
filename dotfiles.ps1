# this file is for restoring dotfiles on windows

if (-not $IsWindows) { Write-Error 'This script is only allowed to be executed on windows' return }

if (gcm scoop) {
    $scoopRoot = [IO.Path]::GetDirectoryName([IO.Path]::GetDirectoryName((gcm scoop).Source))
    # librewolf overrides
    ni ([IO.Path]::Combine($scoopRoot, 'persist/librewolf/Profiles/Default/librewolf.overrides.cfg')) -Target ([IO.Path]::Combine($pwd, "dotfiles/librewolf.cfg")) -ItemType SymbolicLink -Force
    [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', ([IO.Path]::Combine($scoopRoot, 'apps\git\current\usr\bin\file.exe')), 'User')
}

$nvimConfig = [IO.Path]::Combine($env:LOCALAPPDATA, 'nvim/')
if (gci $nvimConfig) { ri -rec $nvimConfig }
ni $nvimConfig -Target ([IO.Path]::Combine($pwd, 'dotfiles/nvim-config/')) -ItemType SymbolicLink -Force

# git
ni "~/.gitconfig" -Target ([IO.Path]::Combine($pwd, "dotfiles/.gitconfig")) -ItemType SymbolicLink -Force
ni "~/.gitconfig_windows" -Target ([IO.Path]::Combine($pwd, "dotfiles/.gitconfig-windows")) -ItemType SymbolicLink -Force
ni ([IO.Path]::Combine($env:LOCALAPPDATA, "lazygit/config.yml")) -Target ([IO.Path]::Combine($pwd, "dotfiles/lazygit.config.yml")) -ItemType SymbolicLink -Force

# vim
ni "~/.vimrc" -Target ([IO.Path]::Combine($pwd, "dotfiles/.vimrc")) -ItemType SymbolicLink -Force
ni "~/.vsvimrc" -Target ([IO.Path]::Combine($pwd, "dotfiles/.vsvimrc")) -ItemType SymbolicLink -Force
ni "~/.ideavimrc" -Target ([IO.Path]::Combine($pwd, "dotfiles/.ideavimrc")) -ItemType SymbolicLink -Force

# shell
ni '~/.bashrc' -Target ([IO.Path]::Combine($pwd, "dotfiles/.bashrc")) -ItemType SymbolicLink -Force
ni $Profile -Target ([IO.Path]::Combine($pwd, "dotfiles/pwsh.profile.ps1")) -ItemType SymbolicLink -Force
ni ([IO.Path]::Combine($env:APPDATA, "nushell/config.nu")) -Target ([IO.Path]::Combine($pwd, "dotfiles/config.nu")) -ItemType SymbolicLink -Force
ni "~/.config/wezterm/wezterm.lua" -Target ([IO.Path]::Combine($pwd, "dotfiles/.wezterm.lua")) -ItemType SymbolicLink -Force

# yazi
ni ([IO.Path]::Combine($env:APPDATA, 'yazi/config/yazi.toml')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/yazi.toml')) -ItemType SymbolicLink -Force
ni ([IO.Path]::Combine($env:APPDATA, 'yazi/config/keymap.toml')) -Target ([IO.Path]::Combine($pwd, 'dotfiles/yazi.keymap.toml')) -ItemType SymbolicLink -Force
if (gcm ya) {
    ya pack -a 'Reledia/glow'
    ya pack -a 'ndtoan96/ouch'
    ya pack -a 'Reledia/miller'
    ya pack -a 'Tyarel8/video-ffmpeg'
    ya pack -a 'kirasok/torrent-preview'
    ya pack -a 'yazi-rs/plugins:max-preview'
}

