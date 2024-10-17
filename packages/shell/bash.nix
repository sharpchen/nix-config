{ pkgs, ...}:
{
  home.packages = with pkgs;[
    bash
    bash-completion
  ];

  home.file.".bashrc" = {
    source = ../../dotfiles/.bashrc;
  };
}
