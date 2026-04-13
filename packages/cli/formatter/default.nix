{ config, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      stylua
      shfmt
      yamlfmt
      nixfmt
    ]
    ++ [
      (callPackage ./xstyler/default.nix { inherit pkgs; })
    ];
  xdg.configFile.".stylua.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.stylua.toml";
}
