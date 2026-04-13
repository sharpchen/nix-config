{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ruff
    zuban
    python312
    uv
  ];
}
