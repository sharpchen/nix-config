{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vim
  ];
  home.file.".vimrc".source = ../../dotfiles/.vimrc;
  home.sessionVariables = {
    MYVIMRC = "~/.vimrc";
  };
}
