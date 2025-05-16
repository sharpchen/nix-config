{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    wezterm
  ];

  home.file."~/.wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.wezterm.lua";
}
