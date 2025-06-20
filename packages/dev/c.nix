{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    clang-tools
    gcc
    cmake
    gnumake
    neocmakelsp
  ];
}
