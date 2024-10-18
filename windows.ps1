# this file is for restoring dotfiles on windows
echo "Starting restoring dotfiles for windows..."

New-Item -ItemType SymbolicLink -Path "~/.gitconfig" -Target $([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.gitconfig")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vsvimrc" -Target $([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.vsvimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.vimrc" -Target $([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.vimrc")) -Force
New-Item -ItemType SymbolicLink -Path "~/.wezterm" -Target $([System.IO.Path]::Combine((Get-Location).Path, "dotfiles/.wezterm")) -Force

echo "Restore finished."
