{ config, ... }:
{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "vim"; # --clean -c \"source ~/.vimrc\"'";
      XDG_RUNTIME_DIR = "$HOME/.cache/";
    };
    # prepend content for auto-gen rc by hm
    initExtra = builtins.readFile ../../dotfiles/.bashrc;
    # append content fot auto-gen profile by hm
    profileExtra = builtins.readFile ../../dotfiles/bash.profile.sh;
  };

  home.file.".inputrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.inputrc";
  };
}
