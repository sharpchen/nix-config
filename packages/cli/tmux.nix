{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    prefix = "C-Space";
    keyMode = "vi";
    escapeTime = 0;
    extraConfig = /* sh */''
      set-option -sa terminal-overrides ",xterm*:Tc"
    '';
  };
}
