#Requires -RunAsAdministrator

# This file is for fresh installation on a new windows

function RefreshPath {
    $env:Path = 
     [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
        + ';' 
        + [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
}
# install scoop
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add fonts 'https://github.com/KnotUntied/scoop-fonts.git'
RefreshPath
#endregion

$scoopPackages = @(
   'git',
   'vswhere',
   'vim',
   'neovim',
   'bat',
   'tokei',
   'pnpm',
   'adb',
   'gcc',
   'ripgrep',
   'lazygit',
   'nodejs-lts',
   'wiztree',
   '7zip',
   'carnac',
   'librewolf',
   'abdownloadmanager'
)

$scoopFonts = @(
   'Cascadia-Code',
   'jetbrainsmono-nl',
   'notosansmono',
)

$wingetPackages = @(
   'wez.wezterm',
   'Microsoft.PowerShell',
   'Microsoft.VisualStudio.2022.Community',
   'File-New-Project.EarTrumpet',
   'dotPDN.PaintDotNet',
   'Ditto.Ditto',
   'Microsoft.PowerToys',
   'Google.Chrome'
)

& ./dotfiles.ps1

scoop install ($scoopPackages -join ' ')
RefreshPath
scoop install ($scoopFonts -join ' ')
winget add --silent --accept-source-agreements ($wingetPackages -join ' ')
RefreshPath

& ./make_vs.ps1
