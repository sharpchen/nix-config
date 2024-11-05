{ pkgs, ... }:
{
  home.packages = with pkgs;[
    stylua
    shfmt
    yamlfmt
  ];
}
