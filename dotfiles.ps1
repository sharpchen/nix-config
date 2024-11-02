# this file is for restoring dotfiles on windows
Write-Output "Starting restoring dotfiles for windows..."

New-Item -ItemType SymbolicLink -Path "~/.gitconfig" -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/.gitconfig")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vsvimrc" -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/.vsvimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vimrc" -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/.vimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.ideavimrc" -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/.ideavimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.wezterm.lua" -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/.wezterm.lua")) -Force
New-Item -ItemType SymbolicLink -Path ([IO.Path]::Combine($env:APPDATA, "nushell/config.nu")) -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/config.nu")) -Force
New-Item -ItemType SymbolicLink -Path ([IO.Path]::Combine($env:LOCALAPPDATA, "lazygit/config.yml")) -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/lazygit.config.yml")) -Force
New-Item -ItemType SymbolicLink -Path $Profile -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/pwsh.profile.ps1")) -Force

if (Get-Command scoop) {
    New-Item -ItemType SymbolicLink -Path ([IO.Path]::Combine([IO.Path]::GetDirectoryName([IO.Path]::GetDirectoryName((Get-Command scoop).Source)), 'persist/librewolf/Profiles/Default/librewolf.overrides.cfg')) -Target ([IO.Path]::Combine((Get-Location).Path, "dotfiles/librewolf.cfg")) -Force
}


Write-Output "Restore finished."
