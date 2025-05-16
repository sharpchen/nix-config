{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    stylua
    shfmt
    yamlfmt
    nixfmt-rfc-style
  ];
  xdg.configFile.".stylua.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.stylua.toml";
}
