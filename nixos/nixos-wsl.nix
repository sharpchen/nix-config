{
  pkgs,
  config,
  lib,
  ...
}:
{
  wsl.enable = true;
  wsl.defaultUser = "sharpchen";
  wsl.interop.includePath = false;
  wsl.wslConf.interop.appendWindowsPath = false;

  # NOTE: see https://github.com/nix-community/NixOS-WSL/issues/262
  systemd.services.wsl-vpnkit = {
    enable = true;
    description = "wsl-vpnkit";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
      Restart = "always";
      KillMode = "mixed";
    };
  };
}
