{ config, pkgs, stable, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
    };
  };
  imports = [
    ./packages/default.nix
  ];
  home = rec {
    username = "sharpchen";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05"; # Please read the comment before changing.
  };
  home.packages = [
    pkgs.harper
    pkgs.nixd
  ];
  targets.genericLinux.enable = true;
  
  programs.home-manager.enable = true;

  xdg.enable = true;
}

