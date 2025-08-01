{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = lib.mkBefore [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=1"
    ];
    trusted-users = [ "sharpchen" ];
  };

  system.stateVersion = "24.11"; # you don't have to change this value
}
