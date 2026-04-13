{ config, pkgs, ... }:
{

  imports = [
    ./wezterm.nix
  ];

  home.packages = with pkgs; [
    sioyek
    mpv
  ];
}
