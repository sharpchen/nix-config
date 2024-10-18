{ pkgs, ... }:
{
  home.packages = with pkgs;[
    nushell
  ];

  home.file.".config/nushell/config.nu".source = ../../dotfiles/config.nu;
}
