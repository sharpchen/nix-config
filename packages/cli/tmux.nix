{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    prefix = "C-Space";
    keyMode = "vi";
    extraConfig = /* sh */''
      set-option -sa terminal-overrides ",xterm*:Tc"
    '';
  };
}
