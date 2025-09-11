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
      "https://nix-community.cachix.org?priority=2"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [ "sharpchen" ];
  };

  time.timeZone = "Asia/Shanghai";
  networking.timeServers = lib.mkBefore [ "ntp.ntsc.ac.cn" ];

  system.stateVersion = "24.11"; # you don't have to change this value
}
