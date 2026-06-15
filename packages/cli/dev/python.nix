{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ruff
    zuban
    python312
    uv
  ];

  home.file.".config/uv/uv.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/uv.toml";
}
