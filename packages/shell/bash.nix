{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim"; # --clean -c \"source ~/.vimrc\"'";
      XDG_RUNTIME_DIR = "$HOME/.cache/";
    };
    initExtra = builtins.readFile ../../dotfiles/.bashrc;
  };

  home.file.".inputrc" = {
    source = ../../dotfiles/.inputrc;
  };
}
