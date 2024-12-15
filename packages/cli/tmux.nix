{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    prefix = "C-Space";
    keyMode = "vi";
    escapeTime = 0;
    mouse = true;
    extraConfig = # sh
      ''
        set-option -sa terminal-overrides ",xterm*:Tc"
      '';
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
    ];
  };
}
