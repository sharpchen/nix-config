{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/nvim-config";
  };

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.vimrc";
}
