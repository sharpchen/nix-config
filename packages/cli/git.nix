{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    lazygit
    gh
  ];
  programs.git.enable = true;
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.gitconfig";
  home.file.".config/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/lazygit.config.yml";
}
