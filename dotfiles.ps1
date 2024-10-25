# this file is for restoring dotfiles on windows
Write-Output "Starting restoring dotfiles for windows..."

New-Item -ItemType SymbolicLink -Path "~/.gitconfig" -Target ([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.gitconfig")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vsvimrc" -Target ([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.vsvimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vimrc" -Target ([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.vimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.ideavimrc" -Target ([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.ideavimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.wezterm.lua" -Target $([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.wezterm.lua")) -Force
New-Item -ItemType SymbolicLink -Path ([System.IO.Path]::Combine($env:APPDATA, "nushell/config.nu")) -Target ([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/config.nu")) -Force
New-Item -ItemType SymbolicLink -Path ([System.IO.Path]::Combine($env:LOCALAPPDATA, "lazygit/config.yml")) -Target ([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/lazygit.config.yml")) -Force

Write-Output "Restore finished."
