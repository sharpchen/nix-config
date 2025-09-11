{
  pkgs,
  config,
  lib,
  ...
}:
let
  append = # sh
    ''
      source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
      ble-import -d "${pkgs.blesh}/share/blesh/contrib/integration/fzf-completion.bash"
      ble-import -d "${pkgs.blesh}/share/blesh/contrib/integration/fzf-key-bindings.bash"

      function sharpchen/vim-load-hook {
          bleopt keymap_vi_mode_show=
      }
      blehook/eval-after-load keymap_vi sharpchen/vim-load-hook

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
      bleopt prompt_eol_mark=""
      bleopt prompt_eol_mark="↵"

      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
in
{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      XDG_RUNTIME_DIR = "$HOME/.cache/";
    };
    # prepend content for auto-gen rc by hm
    initExtra = (builtins.readFile ../../dotfiles/.bashrc) + "\n" + append;
    # append content fot auto-gen profile by hm
    profileExtra = builtins.readFile ../../dotfiles/bash.profile.sh;
  };

  home.packages = with pkgs; [
    blesh
  ];

  home.file.".inputrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.inputrc";
  };
}
