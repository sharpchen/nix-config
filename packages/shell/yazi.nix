{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.yazi = {
    enable = true;
    extraPackages = with pkgs; [
      imagemagick # image preview
      ffmpeg # media preview
      _7zz-rar # archive preview
      rich-cli # csv preview
      poppler # pdf preview
      resvg # svg preview
      jq # json preview
    ];

    plugins = with pkgs.yaziPlugins; {
      rich-preview = rich-preview;
      jump-to-char = jump-to-char;
      toggle-pane = toggle-pane;
    };
  };

  home.file.".config/yazi/yazi.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi.toml";
  home.file.".config/yazi/keymap.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi.keymap.toml";
}
