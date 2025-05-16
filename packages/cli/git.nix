{ config, ... }:
{
  programs.git.enable = true;
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.gitconfig";
}
