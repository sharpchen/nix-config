{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    powershell
    powershell-editor-services
  ];
  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/pwsh.profile/pwsh.profile.ps1";
  xdg.configFile."powershell/PwshProfile".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/pwsh.profile/PwshProfile";
}
