{
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  home.file."~/.vimrc".source = ../../dotfiles/.vimrc;
}
