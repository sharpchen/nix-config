{
  pkgs,
  config,
  lib,
  ...
}:
{
  fonts.packages = with pkgs; [
    ibm-plex
    jetbrains-mono
    cascadia-code
    roboto-mono
    lilex
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
  ];
}
