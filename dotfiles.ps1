# this file is for restoring dotfiles on windows

# git
New-Item -ItemType SymbolicLink -Path "~/.gitconfig" -Target ([IO.Path]::Combine($pwd, "dotfiles/.gitconfig")) -Force
New-Item -ItemType SymbolicLink -Path "~/.gitconfig_windows" -Target ([IO.Path]::Combine($pwd, "dotfiles/.gitconfig-windows")) -Force
New-Item -ItemType SymbolicLink -Path ([IO.Path]::Combine($env:LOCALAPPDATA, "lazygit/config.yml")) -Target ([IO.Path]::Combine($pwd, "dotfiles/lazygit.config.yml")) -Force

# vim
New-Item -ItemType SymbolicLink -Path "~/.vimrc" -Target ([IO.Path]::Combine($pwd, "dotfiles/.vimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vsvimrc" -Target ([IO.Path]::Combine($pwd, "dotfiles/.vsvimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.ideavimrc" -Target ([IO.Path]::Combine($pwd, "dotfiles/.ideavimrc")) -Force

# shell
New-Item -ItemType SymbolicLink -Path '~/.bashrc' -Target ([IO.Path]::Combine($pwd, "dotfiles/.bashrc")) -Force
New-Item -ItemType SymbolicLink -Path $Profile -Target ([IO.Path]::Combine($pwd, "dotfiles/pwsh.profile.ps1")) -Force
New-Item -ItemType SymbolicLink -Path ([IO.Path]::Combine($env:APPDATA, "nushell/config.nu")) -Target ([IO.Path]::Combine($pwd, "dotfiles/config.nu")) -Force
New-Item -ItemType SymbolicLink -Path "~/.wezterm.lua" -Target ([IO.Path]::Combine($pwd, "dotfiles/.wezterm.lua")) -Force

if (Get-Command scoop) {
    $scoopRoot = [IO.Path]::GetDirectoryName([IO.Path]::GetDirectoryName((Get-Command scoop).Source))
    # librewolf overrides
    New-Item -ItemType SymbolicLink -Path ([IO.Path]::Combine($scoopRoot, 'persist/librewolf/Profiles/Default/librewolf.overrides.cfg')) -Target ([IO.Path]::Combine($pwd, "dotfiles/librewolf.cfg")) -Force
}
