{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ruff
    basedpyright
    python312Full
    uv
  ];
}
