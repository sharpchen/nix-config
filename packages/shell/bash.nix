{
  pkgs,
  config,
  lib,
  ...
}:
let
  append_blesh = # sh
    ''
      source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
      ble-import -d "${pkgs.blesh}/share/blesh/contrib/integration/fzf-completion.bash"
      ble-import -d "${pkgs.blesh}/share/blesh/contrib/integration/fzf-key-bindings.bash"

      function __vim-load-hook {
          bleopt keymap_vi_mode_show=
      }
      blehook/eval-after-load keymap_vi __vim-load-hook

      ble-face -s syntax_command fg=blue
      ble-face -s syntax_function_name fg=blue
      ble-face -s syntax_command fg=blue
      ble-face -s syntax_varname fg=green,bold
      ble-face -s command_builtin_dot fg=blue
      ble-face -s command_builtin fg=blue
      ble-face -s command_alias fg=blue
      ble-face -s command_function fg=blue
      ble-face -s command_file fg=blue
      ble-face -s command_keyword fg=magenta
      ble-face -s filename_executable fg=blue
      ble-face -s syntax_history_expansion fg=gray,bg=
      ble-face -s syntax_param_expansion fg=yellow,bold
      ble-face -s syntax_error fg=red
      ble-face -s argument_option fg=magenta
      ble-face -s auto_complete fg=gray
      bleopt highlight_filename=
      bleopt highlight_variable=
      bleopt prompt_eol_mark="↵"
    '';
in
{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
    };
    # prepend content for auto-gen rc by hm
    initExtra = builtins.concatStringsSep "\n" [
      (builtins.readFile ../../dotfiles/.bashrc)
      append_blesh
      "[[ ! \${BLE_VERSION-} ]] || ble-attach"
    ];
    # append content for auto-gen profile by hm
    profileExtra = builtins.readFile ../../dotfiles/bash.profile.sh;
  };

  home.packages = with pkgs; [
    blesh
    complete-alias
  ];
  # NOTE: import complete-alias support in custom bash completion
  # for setting completion for alias, see: 'append_completealias' variable above
  home.file.".bash_completion".text = # sh
    ''
      . ${pkgs.complete-alias}/bin/complete_alias
      complete -F _complete_alias ll
      complete -F _complete_alias ydl
      complete -F _complete_alias ri
      complete -c which type
    '';
  home.file.".inputrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.inputrc";
  };
}
