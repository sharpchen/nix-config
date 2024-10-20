# This file is for fresh installation on a new windows


# install scoop
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop bucket add extras
scoop bucket add nerd-fonts
#endregion

$packages = @(
   git,
   vswhere,
   vim,
   neovim,
   bat,
   tokei,
   pnpm,
   adb,
   gcc,
   ripgrep,
   lazygit,
)

scoop install ($packages -join " ")

& ./dotfiles.ps1
