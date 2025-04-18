{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stylua
    shfmt
    yamlfmt
    nixfmt-rfc-style
  ];
  xdg.configFile.".stylua.toml".source = ../../dotfiles/.stylua.toml;
}
