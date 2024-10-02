{
  programs.git.enable = true;
  home.file.".gitconfig" = {
    text = /* gitconfig */''
      [user]
        name = sharpchen
        email = rui.chen.sharp@gmail.com
      [init]
        defaultBranch = main
    '';
  };
}
