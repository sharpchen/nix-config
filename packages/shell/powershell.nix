{ pkgs, ... }:
{
  home.packages = with pkgs; [
    powershell
  ];
  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".source =
    ../../dotfiles/pwsh.profile/pwsh.profile.ps1;
  xdg.configFile."powershell/Profile".source = ../../dotfiles/pwsh.profile/Profile;
}
