{ pkgs, ... }:
{
  home.packages = with pkgs; [
    powershell
  ];
  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".source =
    ../../dotfiles/pwsh.profile.ps1;
}
