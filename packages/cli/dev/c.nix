{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    clang-tools
    clang
    # gcc
    cmake
    gnumake
  ];
}
